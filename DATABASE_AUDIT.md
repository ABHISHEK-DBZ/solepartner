# Database Audit — KhataCopilot

**Score: 6 / 10**
**Engine:** Drift over SQLite (`sqlite3_flutter_libs`), single file DB
**Files:** `lib/data/db/tables.dart`, `app_database.dart`, `mappers.dart`,
`lib/data/repositories/*`

---

## 1. Schema overview

Tables: `MerchantProfiles`, `Customers`, `Suppliers`, `Products`, `Purchases`,
`PurchaseLines`, `Transactions` (ledger), `LedgerLines`, `SolanaPayments`, `Payees`,
`PolicyRows`, `AuditLogs`, `Settings` (key/value).

`schemaVersion => 1`, `PRAGMA foreign_keys = ON`. Generated code
`app_database.g.dart` is checked in (13,370 lines).

Strengths:
- Foreign keys are declared on the important relations.
- Money is stored as integer paise / lamports (no floating point).
- `SolanaPayments.idempotencyKey` is `unique()`.
- Ledger rows store both cash and credit deltas for explainable history.
- Reversals use `reversalOfId` rather than deleting rows.

---

## 2. Findings

### DB-01 — HIGH — No migration strategy
- **File:** `lib/data/db/app_database.dart`
- **Evidence:** `schemaVersion => 1` and no `MigrationStrategy` / `onUpgrade`.
- **Impact:** The first schema change will either crash existing installs or require a
  destructive reset, destroying merchant books.
- **Fix:** Add an explicit `MigrationStrategy` with stepwise migrations and a test that
  opens a v1 DB and migrates it.
- **Verify:** Build a fixture v1 DB, bump to v2, open, assert data preserved.

### DB-02 — MEDIUM — `signature` is not unique
- **File:** `lib/data/db/tables.dart:142`
- **Evidence:** `TextColumn get signature => text().nullable()();` — no `.unique()`.
  Duplicate protection exists only in `PaymentRepository.signatureAlreadyUsed`, which runs
  after submit (`payment_service.dart:208`).
- **Impact:** Two rows can reference the same on-chain signature; reconciliation and
  bookkeeping become ambiguous.
- **Fix:** Add a unique index on `signature` (nullable-unique is fine in SQLite) and check
  before submit.
- **Verify:** Insert the same signature twice; expect a constraint error.

### DB-03 — MEDIUM — `barcode` is not unique
- **File:** `lib/data/db/tables.dart:43`
- **Evidence:** `barcode` is a plain text column.
- **Impact:** Duplicate products can share a barcode, breaking `findByBarcode`.
- **Fix:** Unique index (allow empty/null) and a duplicate check in `createProduct`.

### DB-04 — MEDIUM — Duplicate supplier invoice numbers allowed
- **Files:** `lib/data/db/tables.dart` (`Purchases`), `supplier_repository.dart`
- **Evidence:** No unique constraint or repository check on invoice number.
- **Impact:** Double-entered purchases inflate stock and payables.
- **Fix:** Unique per supplier (or global) index plus a pre-insert check.

### DB-05 — MEDIUM — Audit log is mutable and local
- **Files:** `lib/data/db/tables.dart` (`AuditLogs`), `customer_repository._audit`
- **Evidence:** Plain rows, no hash chain, no append-only trigger. `_audit` stores
  `key=value` strings in a column named `detailsJson`.
- **Impact:** A user with DB access can edit history; the name implies JSON that is not JSON.
- **Fix:** Store real JSON, add a hash chain (`prevHash`) if tamper evidence is a goal, or
  rename the column to `details`.

### DB-06 — MEDIUM — No indexes on hot query columns
- **Evidence:** Ledger queries filter by `occurredAt`, `customerId`, `supplierId`,
  `isReversed`; dashboard sorts by `occurredAt`. No explicit indexes were found.
- **Impact:** Full scans as the ledger grows (see `PERFORMANCE_AUDIT.md`).
- **Fix:** Add indexes: `Transactions(occurredAt)`, `Transactions(customerId)`,
  `Transactions(supplierId)`, `(isReversed)`, `LedgerLines(transactionId)`,
  `PurchaseLines(purchaseId)`.

### DB-07 — LOW — Money columns are unbounded integers
- **Evidence:** `IntColumn get amountPaise => integer()();` with no check constraint.
- **Impact:** Negative/zero amounts are prevented in code, not by the DB; a bug can write
  invalid values.
- **Fix:** Add `CHECK(amountPaise > 0)` where appropriate (Drift `customConstraint`).

### DB-08 — LOW — `MerchantProfiles`/`PolicyRows` are effectively single-row but unconstrained
- **Evidence:** Repositories use `limit(1)`; nothing prevents multiple rows.
- **Impact:** Divergent profile/policy rows after a bug.
- **Fix:** Add a fixed `id = 1` check or a unique singleton constraint.

### DB-09 — INFO — Seed data is demo content
- **File:** `lib/data/db/seed_data.dart`
- **Evidence:** Inserts a demo merchant, customers, products and transactions on first run.
- **Impact:** Real merchants start with fake books; must be cleared or clearly labelled.
- **Fix:** Gate seeding behind a "demo mode" flag or remove it for production.

---

## 3. Data integrity assessment

| Concern | Status |
|---|---|
| Foreign keys | Enabled |
| Money as integers | Yes |
| Idempotency for payments | `idempotencyKey` unique |
| Signature uniqueness | **No** |
| Invoice uniqueness | **No** |
| Barcode uniqueness | **No** |
| Migrations | **None** |
| Backup/export | **None** |
| Encryption at rest | **None** (plaintext SQLite) |
| Audit immutability | **None** |

## 4. Score rationale

- + Sensible normalised schema, integer money, FK enforcement, reversal model.
- − No migrations, missing uniqueness constraints, no indexes, no encryption, mutable audit,
  demo seed in production path.
