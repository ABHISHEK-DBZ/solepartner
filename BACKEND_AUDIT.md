# Backend / Service-Layer Audit — KhataCopilot

**Score: 5 / 10 (local data + service layer; there is no server)**
**Scope:** `lib/data`, `lib/services`, `lib/domain/rules`, `lib/app/providers.dart`

---

## 1. Architecture reality check

There is **no backend**. No API server, no PostgreSQL/Supabase, no auth, no RLS, no queue,
no cron, no Docker. All persistence is Drift/SQLite on the device. All "services" run
in-process. Therefore:

- Backend API security, server auth, rate limiting, multi-tenancy and RLS are **N/A**.
- The equivalent trust boundary is the **local database + wallet adapter + cloud AI HTTP
  client**.
- Findings below are about service-layer correctness, not server hardening.

The layering is sound: `features -> app/providers -> services/domain -> data/repositories ->
data/db`. Money effects are centralised in `LedgerRules.deltasFor`.

---

## 2. Findings

### BE-01 — HIGH — Reversal entries corrupt aggregates
- **Files:** `lib/domain/rules/ledger_rules.dart:94-103`,
  `lib/data/repositories/ledger_repository.dart:443-480`
- **Evidence:** `reverseEntry` inserts a new row with the **same `kind`** and
  `amountPaise = original.amountPaise`, `cashDeltaPaise = -original.cashDeltaPaise`,
  `isReversed = false`. Aggregators skip only `isReversed == true` (the original), so the
  reversal is counted as a brand-new sale/expense.
  - `summarise` / `todayTotals`: `todaySales` and `todayExpenses` still include the full
    amount; `cashIn`/`cashOut` are inverted.
  - `cashBalancePaise`: filters `isReversed == false`, so it includes the reversal and
    excludes the original, yielding `-original.cashDelta` instead of `0`.
- **Impact:** Dashboard tiles, assistant affordability answers and any report built on these
  methods are wrong after any reversal. A reversed ₹1,000 sale still shows ₹1,000 of sales
  and can make cash-on-hand negative.
- **Fix:** In every aggregator, skip rows where `reversalOfId != null` **and** also skip the
  original (or, better, compute from net `cashDelta`/`creditDelta` only). Unit-test a
  sale→reversal pair.
- **Verify:** Record a sale, reverse it, assert sales=0, expenses unchanged, cash delta=0.

### BE-02 — HIGH — Daily spend limit is bypassable
- **File:** `lib/data/repositories/payment_repository.dart:200-205`
- **Evidence:** `dailySpentLamports` sums proposals where `createdAt >= startOfDay`. Sending
  is gated later; a proposal created yesterday and approved today is not counted.
- **Impact:** The policy's daily cap does not cap actual daily spending.
- **Fix:** Sum by `confirmedAt` (or `submittedAt`) for spend, and keep `createdAt` only for
  listing. Count in-flight (`submitted`) proposals too.
- **Verify:** Create a proposal before midnight, approve after, confirm it counts.

### BE-03 — HIGH — Credit purchase still debits cash
- **File:** `lib/domain/rules/ledger_rules.dart:39-42`
- **Evidence:** `purchasePayment` always returns `cashPaise: -amountPaise`, ignoring
  `method`. `supplier_repository.purchasePayment` passes the user's `method`.
- **Impact:** Paying a supplier on credit reduces cash-on-hand, understating available cash.
- **Fix:** Mirror the sale rule: `method == credit ? cash 0 : cash -amount`; for credit,
  decide whether credit delta should increase payables (currently purchases track payable
  separately).
- **Verify:** Record a credit purchase payment; assert cash unchanged and payable updated.

### BE-04 — MEDIUM — Sale ledger amount can disagree with line items
- **File:** `lib/services/command_executor.dart:143-175`
- **Evidence:** `_recordSale` uses `command.amountPaise` for the ledger amount while the
  line uses `unitPrice * quantity`. No check that they agree.
- **Impact:** Revenue reports (which sum line totals) diverge from the ledger total.
- **Fix:** Derive the ledger amount from lines when a product/quantity is present, or reject
  a mismatch with a clear message.
- **Verify:** "sold 2 Maggi for 100" where unit price is 14; assert one authoritative total.

### BE-05 — MEDIUM — Cloud command loses customer identity
- **File:** `lib/services/assistant_service.dart:316-350`
- **Evidence:** `_fromCloudJson` sets `customerName` but never resolves `customerId`.
  `CommandExecutor` requires `customerId` for credit/repayment and otherwise records a
  cash sale/income.
- **Impact:** A cloud-parsed "Rahul paid 500" can be booked as new income instead of a
  repayment, or rejected for credit.
- **Fix:** Resolve the name against `customers` after parsing; if ambiguous, ask the user.
- **Verify:** Cloud-only path with a known customer; assert repayment, not income.

### BE-06 — MEDIUM — Payment status transitions are unguarded
- **File:** `lib/data/repositories/payment_repository.dart:114-190`
- **Evidence:** `setStatus` writes any status. `markConfirmed` does not require the current
  status to be `submitted`, nor verify that the stored `signature` equals the argument.
- **Impact:** A failed/expired proposal can be marked confirmed; a stale signature can be
  attached to the wrong row.
- **Fix:** Enforce a state machine (`draft -> awaitingApproval -> submitted -> confirmed |
  failed | expired`), and assert signature equality before confirming.
- **Verify:** Attempt illegal transitions in a unit test; expect exceptions.

### BE-07 — MEDIUM — Policy can be saved with `devnetOnly: false`
- **Files:** `lib/data/repositories/payment_repository.dart` `savePolicy`,
  `lib/features/payments/policy_screen.dart`
- **Evidence:** The UI locks the mainnet toggle, but the repository accepts any value. The
  policy engine reads whatever is stored.
- **Impact:** A bug or direct DB edit can enable mainnet with no UI guard.
- **Fix:** Enforce `devnetOnly == true` in the repository for this release, or require an
  explicit second confirmation token.
- **Verify:** Call `savePolicy(devnetOnly: false)` in a test; expect rejection.

### BE-08 — MEDIUM — `markConfirmed` writes `inrMemoPaise: 0`
- **File:** `lib/services/payment_service.dart:224-230`
- **Evidence:** The confirmed ledger entry is created with `inrMemoPaise: 0`, dropping the
  merchant's INR memo.
- **Impact:** The books lose the merchant-entered INR context for the payment.
- **Fix:** Pass `proposal.inrMemoPaise`.
- **Verify:** Approve a payment with a memo; assert the ledger entry retains it.

### BE-09 — LOW — Duplicate-signature check happens after submit
- **File:** `lib/services/payment_service.dart:197-220`
- **Evidence:** The transaction is submitted, then `signatureAlreadyUsed` is checked.
- **Impact:** A duplicate signature may already be broadcast before rejection.
- **Fix:** Check the signature immediately after signing, before submit.

### BE-10 — LOW — `requireApproval` policy flag is unused
- **File:** `lib/domain/rules/policy_engine.dart`
- **Evidence:** The flag is stored but no automated path exists; the UI always requires a
  tap. No security hole today, but the setting is misleading.
- **Fix:** Remove the flag or wire it to an explicit "auto-send under X" mode with tests.

### BE-11 — LOW — Reminder text is local only
- **File:** `lib/domain/rules/reminder.dart`
- **Evidence:** Reviewed; generates text and makes no network call. Fine.
- **Note:** If a future "send reminder" action is added, it must go through `share_plus`
  with user confirmation.

---

## 3. Provider graph

`lib/app/providers.dart` wires repositories, streams (`allCustomersProvider`,
`allProductsProvider`, `dashboardEntriesProvider`) and the assistant. Repositories are
created per provider scope; the DB is opened once in `main.dart`, closed, then reopened by
providers. This works but is wasteful and makes startup timing subtle (see
`PERFORMANCE_AUDIT.md`).

## 4. Score rationale

- + Clear layering, centralised money rules, deterministic confirmation.
- + No server attack surface.
- − Financial aggregates break under reversal, policy bypass, credit-purchase cash bug,
  unguarded payment states, cloud identity loss.
