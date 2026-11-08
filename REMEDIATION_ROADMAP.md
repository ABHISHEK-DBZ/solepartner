# Remediation Roadmap — KhataCopilot

Sequenced by risk. Each item lists the finding IDs it closes. Do not ship to real merchants
before P0 and P1 are complete.

---

## P0 — Stop the bleeding (before any release)

| # | Action | Closes | Effort |
|---|---|---|---|
| 1 | Production keystore + real `applicationId` + version/label/description | SEC-01, DEP-01, DEP-02 | S |
| 2 | Add `INTERNET` to the main manifest; set `allowBackup=false` / strict rules | SEC-02, SEC-03, DEP-03, DEP-04 | S |
| 3 | Verify the signed Solana transaction (recipient, amount, signer, cluster) before submit; verify on-chain after confirm | BC-01, T-01 | M |
| 4 | Fix reversal accounting in `summarise`, `todayTotals`, `cashBalancePaise` | FIN-01/BE-01, T-09 | S |
| 5 | Compute daily spend from `confirmedAt`/`submitted` | FIN-02/BC-02, T-07 | S |
| 6 | Enforce `devnetOnly == true` in `savePolicy` | BC-03, T-07 | S |
| 7 | Fix credit purchase cash delta | FIN-03/BE-03 | S |
| 8 | Add a signed-tx/policy/reversal test suite | TEST-01 | M |

**Exit criteria:** release APK signed with a real key, network works, reversals net to zero,
daily limit holds, no credit-purchase cash leak, tests cover each fix.

---

## P1 — Make the product honest and durable

| # | Action | Closes | Effort |
|---|---|---|---|
| 9 | Wire voice→pay (`GoRouterState.extra`) or remove the flow | FE-01 | S |
| 10 | Wire Insights to real aggregates + real export, or remove it | FE-03, PERF-08 | M |
| 11 | Implement export/backup/restore + clear-all-data | FE-04, T-08 | M |
| 12 | Cap credit repayment at outstanding (or model advances) | FE-05 | S |
| 13 | Fix cloud customer identity resolution | AI-03, BE-05 | S |
| 14 | Add migration strategy + migration test | DB-01, TEST-02 | M |
| 15 | Add unique indexes: signature, barcode, supplier invoice | DB-02/03/04, BC-06 | S |
| 16 | Enforce payment status state machine + signature equality | BE-06, BC-05 | M |
| 17 | Block/warn on reversing a Solana settlement | BC-04 | S |
| 18 | Guard `externalRef.substring` | BC-10 | S |
| 19 | Surface speech errors; allow re-checking availability | AI-07 | S |

**Exit criteria:** no dead or fake flows, data survives reinstall via export/import, balances
stay non-negative under normal use, migrations tested.

---

## P2 — Harden and localise

| # | Action | Closes | Effort |
|---|---|---|---|
| 20 | HTTPS-only AI endpoint + explicit consent + redaction | SEC-05, SEC-06, AI-02, T-04 | M |
| 21 | App lock / biometric gate; consider SQLCipher | SEC-04, T-02 | M |
| 22 | Hindi/Devanagari parser + `flutter_localizations` | FE-02, AI-01 | M |
| 23 | Improve name matching (token/fuzzy + disambiguation) | AI-04 | M |
| 24 | Context-aware amount parsing (quantity vs amount) | AI-05, SEC-09 | M |
| 25 | Add `max_tokens`/body cap to cloud client | SEC-10, AI-08, T-06 | S |
| 26 | Phone validation + duplicate detection + merge | FE-09, SEC-09 | M |
| 27 | Archive confirmations + restore UI for all entities | FE-07 | S |
| 28 | Add DB indexes for hot queries | PERF-04, DB-06 | S |
| 29 | Preserve custom units on edit; barcode scan or remove field | FE-08, FE-10 | S |
| 30 | Privacy policy, terms, Play data-safety form | DEP-07 | M |
| 31 | Remove/rename unused deps; add dependency audit | SEC-11 | S |

---

## P3 — Scale and verify

| # | Action | Closes | Effort |
|---|---|---|---|
| 32 | Replace capped aggregates with SQL `SUM`/`GROUP BY` | PERF-01 | M |
| 33 | Denormalised balances or SQL-derived views | PERF-02 | L |
| 34 | Pagination on ledger/customers/inventory/detail | PERF-03, FE-06 | M |
| 35 | Batch-load purchase/product lines | PERF-05 | S |
| 36 | Single DB open at startup; preload theme | PERF-06, PERF-07 | S |
| 37 | Widget + integration tests for critical flows | TEST-04 | L |
| 38 | CI: format check, analyze, test, build | TEST-05, DEP-05 | M |
| 39 | R8/shrinking + crash reporting (opt-in, PII-scrubbed) | DEP-06, DEP-09 | M |
| 40 | Build flavors (dev/staging/prod) | DEP-10 | M |
| 41 | Gate demo seed data behind a flag | DB-09, DEP-08 | S |
| 42 | Run `dart format .` and enforce in CI | TEST-06 | S |

---

## Suggested sprint plan

- **Sprint 1 (P0):** items 1–8. Ship a signed devnet build to internal testers only.
- **Sprint 2 (P1):** items 9–19. Feature-complete and honest; still internal.
- **Sprint 3 (P2):** items 20–31. Security/privacy/localisation review.
- **Sprint 4 (P3):** items 32–42. Scale, CI, store readiness.

## Verification gate (every sprint)

```
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build apk --release
apksigner verify --print-certs build/app/outputs/flutter-apk/app-release.apk
```

Add a manifest assertion for `INTERNET` and `allowBackup=false`.
