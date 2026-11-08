# Testing Audit — KhataCopilot

**Score: 2 / 10**
**Executed:** `flutter test` -> 3/3 passed (2026-11-08, stable snapshot).

---

## 1. What exists

Only `test/widget_test.dart`:

1. `Money.format(50000)` / `Money.format(125050)` formatting.
2. `Money.tryParsePaise('Rahul paid 1500')`, `'2k'`, no-amount.
3. `Money.formatSol(Money.lamportsPerSol)`.

That is the entire automated suite. There are **no widget tests, no integration tests, no
repository tests, no migration tests, no golden tests, no security tests, and no CI**.

---

## 2. Coverage gaps by risk

| Area | Risk | Existing tests | Needed |
|---|---|---|---|
| Ledger reversal accounting | HIGH | none | sale→reversal, expense→reversal, cash balance |
| Payment policy / daily limit | HIGH | none | midnight boundary, credit method, devnet flag |
| Signed-tx verification | CRITICAL | none | mismatched recipient/amount rejected |
| Money parsing | MEDIUM | 3 basic | quantity+amount, negative, huge, Hindi digits |
| Voice parser | MEDIUM | none | English/Hindi intents, name matching, ambiguity |
| Cloud AI JSON mapping | MEDIUM | none | malicious/partial JSON, identity resolution |
| Repositories | MEDIUM | none | CRUD, constraints, idempotency |
| Migrations | HIGH | none | v1→v2 preserves data |
| Widgets/flows | MEDIUM | none | voice→pay, repayment cap, archive confirm |
| Security config | HIGH | none | manifest assertions (INTERNET, allowBackup) |

---

## 3. Findings

### TEST-01 — HIGH — No tests for financial invariants
- **Evidence:** No test touches `LedgerRules`, `LedgerRepository`, `PaymentService` or
  `PolicyEngine`. The reversal and daily-limit bugs would have been caught by one test each.
- **Fix:** Add unit tests for every `LedgerRules` branch and every `PaymentService` state
  transition.

### TEST-02 — HIGH — No migration test
- **Evidence:** `schemaVersion => 1`, no migration. The first schema change is untested.
- **Fix:** Drift `SchemaVerifier` / fixture DB migration tests.

### TEST-03 — HIGH — No security configuration tests
- **Evidence:** Nothing asserts the release manifest has INTERNET, `allowBackup=false`, or a
  non-debug signing config.
- **Fix:** A small script/test that parses the merged manifest and `build.gradle.kts` in CI.

### TEST-04 — MEDIUM — No widget/flow tests
- **Evidence:** Voice→pay, repayment cap, purchase credit, archive and export are untested.
- **Fix:** `flutter_test` widget tests with a fake repository/DB.

### TEST-05 — MEDIUM — No CI pipeline
- **Evidence:** No `.github/`, no `azure-pipelines.yml`, no `codemagic.yaml`, no scripts.
- **Fix:** Add a CI job: `dart format --set-exit-if-changed`, `flutter analyze`,
  `flutter test`, build debug APK.

### TEST-06 — LOW — Formatting is not enforced
- **Evidence:** `dart format --output=none --set-exit-if-changed .` reports 54 of 67 files
  would change. (No files were written by the audit.)
- **Fix:** Run `dart format .` once and add the check to CI/pre-commit.

### TEST-07 — LOW — Test file contains a legacy widget test name
- **Evidence:** File is named `widget_test.dart` but contains only unit tests.
- **Fix:** Rename to `money_test.dart` and add real widget tests.

---

## 4. Score rationale

- + The three existing tests pass and cover money formatting.
- − Everything financially or security-critical is untested; no CI; formatting drift.
