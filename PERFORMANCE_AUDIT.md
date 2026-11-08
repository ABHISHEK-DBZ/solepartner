# Performance Audit — KhataCopilot

**Score: 4 / 10**
**Method:** static review of streams, providers, queries and list rendering. No profiling
session was run, so all claims are code-level, not measured.

---

## 1. Findings

### PERF-01 — MEDIUM — Dashboard aggregates cap at 1200 entries
- **File:** `lib/features/dashboard/dashboard_providers.dart:9`
- **Evidence:** `watchEntries(limit: 1200)`, then `LedgerRules.summarise` over that list.
- **Impact:** Once a merchant has more than 1200 entries, today's/week's totals and
  outstanding can be wrong because the window silently truncates. "Outstanding" is computed
  from the same capped list.
- **Fix:** Use SQL aggregates (`SUM` grouped by day/kind) for totals and a separate
  unbounded/aggregate query for outstanding.
- **Verify:** Seed 1500 entries; compare totals to a full-table sum.

### PERF-02 — MEDIUM — O(customers x transactions) recomputation
- **Files:** `lib/app/providers.dart` (`allCustomersProvider`, `allProductsProvider`),
  `lib/data/mappers.dart`
- **Evidence:** Customer/product views are rebuilt by scanning all transactions on every
  change.
- **Impact:** UI jank and battery drain as the ledger grows; every write invalidates large
  derived lists.
- **Fix:** Maintain denormalised balances (`outstandingPaise`, `stockQty`) updated in the
  same transaction, or use SQL `SUM`/`GROUP BY` streams.
- **Verify:** Profile with 5k transactions; expect frame drops today.

### PERF-03 — MEDIUM — No pagination on any list
- **Files:** `ledger_screen.dart`, `customers_screen.dart`, `inventory_screen.dart`,
  `supplier_detail_screen.dart`, `product_detail_screen.dart`
- **Evidence:** All lists load full streams; customer history is capped with `take(40)`
  (which hides data rather than paginating).
- **Impact:** Slow first paint and memory growth on large datasets.
- **Fix:** Cursor/limit pagination with "load more" and indexed queries.

### PERF-04 — MEDIUM — Missing indexes on hot columns
- **File:** `lib/data/db/tables.dart`
- **Evidence:** Filters/sorts on `occurredAt`, `customerId`, `supplierId`, `isReversed`.
- **Impact:** Full table scans.
- **Fix:** Add indexes (see `DATABASE_AUDIT.md` DB-06).

### PERF-05 — LOW — N+1 queries in purchase/detail screens
- **Files:** `supplier_repository.dart` (`purchaseLinesFor`), `product_detail_screen.dart`
- **Evidence:** Lines are loaded per purchase/product in a loop.
- **Impact:** Linear query count; noticeable with many purchases.
- **Fix:** Batch-load lines with an `IN` query and group in memory.

### PERF-06 — LOW — DB opened twice at startup
- **Files:** `lib/main.dart`, `lib/data/db/database_provider.dart`
- **Evidence:** `main` opens the DB to check onboarding, closes it, then providers reopen it.
- **Impact:** Extra I/O and a subtle startup race.
- **Fix:** Open once, pass the instance into the provider scope.

### PERF-07 — LOW — Theme preference read after first frame
- **File:** `lib/app/theme_controller.dart`
- **Evidence:** Async `SharedPreferences` load causes a theme flash and a rebuild.
- **Fix:** Preload before `runApp`.

### PERF-08 — LOW — Insights screen is static
- **File:** `lib/features/insights/insights_screen.dart`
- **Evidence:** No queries; renders constants. (Also a correctness issue — see
  `FRONTEND_AUDIT.md` FE-03.)
- **Impact:** No performance cost, but no real analytics either.

---

## 2. Positive notes

- Money is integer arithmetic (fast, exact).
- Streams are `autoDispose` where appropriate.
- No obvious synchronous heavy work on the UI thread.
- `solana` polling uses a bounded loop with timeouts.

## 3. Score rationale

- + Reasonable reactive architecture, integer money.
- − Capped aggregates that silently produce wrong numbers, O(n) derivations, no pagination,
  no indexes, startup double-open.
