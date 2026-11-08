# Blockchain Payment Audit — KhataCopilot

**Score: 3 / 10**
**Scope:** `lib/services/solana_service.dart`, `lib/services/payment_service.dart`,
`lib/domain/rules/policy_engine.dart`, `lib/data/repositories/payment_repository.dart`,
`lib/features/payments/*`
**Network:** Devnet only (UI-enforced).

---

## 1. Flow as implemented

1. `PaymentService.proposePayment` validates amount, recipient, policy and stores a
   `SolanaPayments` proposal with a unique `idempotencyKey`.
2. `approveAndSend` re-runs the policy, builds an unsigned transaction
   (`SolanaService.buildTransfer`), asks the wallet to sign, submits the signed base64, then
   polls `getSignatureStatuses`.
3. On confirmed, `PaymentRepository.markConfirmed` writes a ledger transaction and links it.

The separation of proposal, approval and settlement is good. The gap is **verification**.

---

## 2. Findings

### BC-01 — CRITICAL — Signed transaction is never verified against the approved proposal
- **File:** `lib/services/payment_service.dart:173-220`
- **Evidence:** After `_solana.signTransaction(prepared.unsignedBase64)`, the app calls
  `_solana.submitSignedTransaction(signed)` and then polls by signature. It never deserializes
  the signed payload to confirm:
  - the fee payer / signer is the expected wallet,
  - the destination equals `proposal.recipientAddress`,
  - the lamport amount equals `proposal.amountLamports`,
  - the cluster matches.
  `solana_service.dart` has no `getTransaction`/decode path.
- **Impact:** A compromised wallet adapter, malicious deeplink, or a bug in the wallet can
  return a signature for a **different** transaction, while the app records the approved
  recipient and amount. Funds can go elsewhere and the books will lie.
- **Fix:** Decode the signed transaction (or fetch it after confirmation with
  `getTransaction`) and assert recipient, amount, signer and cluster before marking
  confirmed. Store the verified fields. Reject on mismatch.
- **Verify:** Unit-test with a signed payload whose destination differs; expect rejection.
  Integration: confirm on devnet, fetch the tx, compare.

### BC-02 — HIGH — Daily spend limit is bypassable
- **File:** `lib/data/repositories/payment_repository.dart:200-205`
- **Evidence:** `dailySpentLamports` filters on `createdAt`.
- **Impact:** Create proposals before midnight, approve after; the daily cap is not enforced
  on actual spend. Also, in-flight proposals may not be counted.
- **Fix:** Sum `confirmedAt` (and `submitted`) within the window.
- **Verify:** Boundary test across midnight.

### BC-03 — HIGH — Policy can be saved with `devnetOnly: false`
- **File:** `lib/data/repositories/payment_repository.dart` `savePolicy`
- **Evidence:** The UI locks the toggle, but the repository accepts `false`.
- **Impact:** Mainnet can be enabled without the intended guard.
- **Fix:** Enforce `devnetOnly == true` in the repository for this release, or require an
  explicit secondary confirmation token.

### BC-04 — MEDIUM — Ledger reversal of a Solana settlement does not refund on-chain
- **File:** `lib/features/ledger/transaction_detail_screen.dart`
- **Evidence:** Any ledger entry, including a `solanaPayment`, can be reversed in the books
  with no on-chain action.
- **Impact:** Books show the payment refunded while funds remain with the recipient. This is
  a reconciliation hazard and a trust issue.
- **Fix:** Block reversal of `solanaPayment` entries, or require an explicit "refund is
  off-chain/manual" acknowledgement and link to the explorer.
- **Verify:** Attempt to reverse a Solana settlement; expect a warning/block.

### BC-05 — MEDIUM — Payment status transitions are unguarded
- **File:** `lib/data/repositories/payment_repository.dart:114-190`
- **Evidence:** `setStatus` accepts any status; `markConfirmed` does not require
  `submitted` and does not verify the stored signature equals the argument.
- **Impact:** A failed/expired proposal can be marked confirmed; a stale signature can be
  attached to the wrong row.
- **Fix:** Enforce a state machine and assert signature equality.
- **Verify:** Illegal-transition unit tests.

### BC-06 — MEDIUM — `signature` column is not unique
- **File:** `lib/data/db/tables.dart:142`
- **Evidence:** No `.unique()`; duplicate check runs after submit.
- **Impact:** The same on-chain transfer could be recorded twice.
- **Fix:** Unique index + pre-submit check.

### BC-07 — LOW — Duplicate-signature check after submit
- **File:** `lib/services/payment_service.dart:197-220`
- **Evidence:** `signatureAlreadyUsed` is checked after `submitSignedTransaction`.
- **Fix:** Check immediately after signing.

### BC-08 — LOW — `markConfirmed` drops the INR memo
- **File:** `lib/services/payment_service.dart:224-230`
- **Evidence:** `inrMemoPaise: 0`.
- **Fix:** Pass `proposal.inrMemoPaise`.

### BC-09 — LOW — No memo/reference for reconciliation
- **Evidence:** The transfer has no memo or reference key tying it to the proposal ID.
- **Impact:** Manual reconciliation requires matching amount/time only.
- **Fix:** Add a memo instruction or reference public key derived from the idempotency key.

### BC-10 — LOW — Explorer URL and `externalRef.substring(0, 10)` risk
- **File:** `transaction_detail_screen.dart`
- **Evidence:** `externalRef` is truncated with `substring(0, 10)` without a length check.
- **Impact:** `RangeError` on short references.
- **Fix:** Guard with `length <= 10 ? value : value.substring(0, 10)`.

---

## 3. What is good

- Proposal → approval → submit → confirm is a clean lifecycle.
- Unique `idempotencyKey`; policy snapshot stored with the proposal.
- Devnet-only UI, explicit approval tap, no automatic signing.
- Amounts in lamports (integer), no float math.

## 4. Score rationale

- + Good lifecycle and policy separation.
- − No payload/on-chain verification (critical), bypassable daily limit, unguarded states,
  off-chain reversal of on-chain settlement, no reconciliation memo.
