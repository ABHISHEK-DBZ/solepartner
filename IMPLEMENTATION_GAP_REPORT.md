# Implementation Gap Report — KhataCopilot

Status legend: **Working** (verified in code), **Partial**, **Fake/Stub**, **Missing**.

---

## 1. Core accounting

| Capability | Status | Evidence / gap |
|---|---|---|
| Record sale / expense / income | Working | `LedgerRepository.recordEntry`, `add_transaction_sheet` |
| Customer udhaar (credit given/repaid) | Working | `creditGiven`/`creditRepayment` deltas |
| Repayment cap | **Partial** | credit sheet caps; add-transaction sheet does not (FE-05) |
| Reversal | **Partial** | rows are appended correctly, but aggregates are wrong (BE-01) |
| Cash-on-hand | **Broken after reversal** | `cashBalancePaise` inverts (BE-01) |
| Dashboard today/week totals | **Broken after reversal** | `summarise` (BE-01) |
| Outstanding/overdue | Working | `creditDelta` nets correctly |
| Supplier payables / purchases | **Partial** | credit method still debits cash (BE-03); duplicate invoices allowed (DB-04) |
| Purchase edit/delete/reversal | **Missing** | no UI or repository path |
| Supplier edit/restore | **Partial** | no edit UI; archive cannot be restored |
| Customer merge / duplicate detection | **Missing** | FE-09 |
| Barcode lookup | **Partial** | `findByBarcode` exists; no scanner UI (FE-10) |
| Inventory stock movements | Working | `applyStockMovement`, negative guard in `adjustStock` |
| Custom product units | **Partial** | silently reset to `pc` on edit (FE-08) |

## 2. AI / voice

| Capability | Status | Evidence / gap |
|---|---|---|
| On-device English parsing | Working | `VoiceParser` |
| Hindi / Devanagari offline | **Missing** | Latin-only lists (AI-01) |
| Short/fuzzy name match | **Partial** | full-name match only (AI-04) |
| Quantity-aware amount parse | **Partial** | first number wins; sales-only stripping (AI-05) |
| Cloud LLM fallback | Working | `AssistantService._askCloud` |
| Cloud identity resolution | **Partial** | name without id (AI-03) |
| Cloud privacy consent | **Missing** | no consent screen (SEC-06) |
| Cloud HTTPS enforcement | **Missing** | any scheme accepted (SEC-05) |
| Voice responses (TTS) | Working | `flutter_tts` |
| Speech error handling | **Partial** | no `onError`; 30s timeout (AI-07) |
| Hindi UI localisation | **Missing** | no delegates/locales (FE-02) |
| AI Business Insights | **Fake/Stub** | hard-coded figures + fake export (FE-03) |

## 3. Payments / Solana

| Capability | Status | Evidence / gap |
|---|---|---|
| Proposal + approval flow | Working | `PaymentService` |
| Policy checks (per-payment/daily) | **Partial** | daily uses `createdAt` (BC-02) |
| Devnet-only enforcement | **Partial** | UI-only; repo accepts false (BC-03) |
| Signed-tx verification | **Missing** | no decode/compare (BC-01) |
| On-chain confirmation check | **Partial** | status polled, fields not verified (BC-01) |
| Duplicate signature prevention | **Partial** | app-level, after submit; no DB unique (BC-06/07) |
| Status state machine | **Missing** | any transition allowed (BC-05) |
| On-chain refund / reversal handling | **Missing** | books can reverse without refund (BC-04) |
| Reconciliation memo/reference | **Missing** | BC-09 |
| INR memo on confirmed entry | **Broken** | written as 0 (BC-08) |
| Explorer link | Working | `explorerUrl` |

## 4. Data durability / security

| Capability | Status | Evidence / gap |
|---|---|---|
| Local persistence | Working | Drift/SQLite |
| Schema migrations | **Missing** | `schemaVersion 1`, no strategy (DB-01) |
| Export ledger | **Missing** | FE-04 |
| Backup / restore | **Missing** | FE-04 |
| Clear all data | **Missing** | FE-04 |
| App lock / biometric | **Missing** | SEC-04 |
| Encryption at rest | **Missing** | plaintext SQLite |
| Disable OS backup | **Missing** | default true (SEC-03) |
| Tamper-evident audit | **Missing** | mutable local rows (SEC-07) |
| Phone validation | **Missing** | FE-09 |
| Unique constraints (barcode/signature/invoice) | **Missing** | DB-02/03/04 |

## 5. Platform / release

| Capability | Status | Evidence / gap |
|---|---|---|
| Android debug build | Working | analyzer clean, tests pass |
| Android release signing | **Missing** | debug key (SEC-01) |
| Release network permission | **Missing** | INTERNET only in debug (SEC-02) |
| Real app identity/version | **Missing** | placeholder ID/label/description (DEP-02) |
| iOS / web / desktop | **Missing** | only `android/` exists |
| CI/CD | **Missing** | TEST-05, DEP-05 |
| Crash reporting | **Missing** | DEP-09 |
| Privacy policy / terms | **Missing** | DEP-07 |
| Store listing assets | **Missing** | none in repo |
| Demo data gating | **Missing** | seed runs in production path (DB-09) |

## 6. Quality

| Capability | Status | Evidence / gap |
|---|---|---|
| Static analysis | Working | `flutter analyze` clean |
| Unit tests | **Partial** | only 3 money tests |
| Widget tests | **Missing** | none |
| Integration tests | **Missing** | none |
| Migration tests | **Missing** | none |
| Security config tests | **Missing** | none |
| Formatting enforcement | **Missing** | 54/67 files differ (TEST-06) |
| Pagination | **Missing** | all lists unbounded (PERF-03) |

---

## 7. Top 10 "looks done but is not" items

1. **AI Business Insights** — static mockup with a fake export toast.
2. **Voice payment review** — ignores the spoken command and shows demo data.
3. **Hindi support** — toggle exists; parser and UI are English-only.
4. **Release readiness** — debug signing, placeholder ID, no release INTERNET.
5. **Cash-on-hand** — wrong after any reversal, yet used for affordability answers.
6. **Daily spend limit** — bypassable by proposal timing.
7. **Credit purchase** — reduces cash.
8. **Backup/export** — absent despite being essential for a ledger.
9. **Solana verification** — none; the app trusts the wallet.
10. **Barcode** — field and lookup exist, but no scanning flow.
