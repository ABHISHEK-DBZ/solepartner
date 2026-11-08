# KhataCopilot — Audit Executive Summary

**Audit date:** 2026-11-08
**Snapshot:** stable at 17:24 IST (another process was editing the repo until then; see caveat)
**Build state:** `flutter analyze` -> "No issues found!"; `flutter test` -> 3/3 passed
**Auditor stance:** read-only. No source file was modified by this audit.

---

## 1. What this product is

KhataCopilot is a **local-first Flutter accounting app** for an Indian small merchant. It
stores customers, products, suppliers, purchases, ledger entries, audit logs and Solana
payment proposals in a local Drift/SQLite database. There is **no backend, no remote
database, no authentication service, no sync and no CI/CD**. AI is hybrid: a deterministic
on-device parser first, then an optional user-configured OpenAI-compatible endpoint.
Solana payments are prepared on-device and signed through a wallet adapter.

Because there is no server, the "backend" review is really a review of the local data
layer and service layer. That is stated explicitly in `BACKEND_AUDIT.md`.

---

## 2. Overall score

| Area | Score | Verdict |
|---|---|---|
| Frontend / UX | 6 / 10 | Broad, polished, but several dead or misleading flows |
| Backend / service layer | 5 / 10 | Coherent local-first design; missing invariants |
| Database | 6 / 10 | Good schema shape; weak constraints and no migrations |
| Security | 3 / 10 | Debug signing, no encryption, no lock, over-broad backup |
| AI safety | 4 / 10 | Deterministic-first is good; Hindi gap and PII consent gap |
| Blockchain payments | 3 / 10 | No signed-payload or on-chain verification |
| Performance | 4 / 10 | O(n) aggregates, 1200-row cap, no pagination |
| Testing | 2 / 10 | Only 3 unit tests; no widget/integration/security tests |
| Deployment | 2 / 10 | Debug signing, placeholder ID, no release permissions |
| **Overall production readiness** | **3.5 / 10** | **Not shippable to real merchants** |

---

## 3. Critical and high findings (must fix before any release)

| ID | Severity | Finding | Location |
|---|---|---|---|
| DEP-01 | CRITICAL | Release build is signed with the **debug** key and uses placeholder `applicationId` | `android/app/build.gradle.kts:24,37` |
| BC-01 | CRITICAL | Signed Solana transaction is **never verified** against the approved proposal before submit, and confirmation never checks recipient/amount on-chain | `lib/services/payment_service.dart:197-220` |
| FIN-01 | HIGH | Reversal entries are counted as fresh sales/expenses; cash balance is inverted after any reversal | `lib/domain/rules/ledger_rules.dart:94-103`, `lib/data/repositories/ledger_repository.dart:443-480` |
| SEC-01 | HIGH | Release APK has **no INTERNET permission** (only the debug manifest declares it) | `android/app/src/main/AndroidManifest.xml`, `android/app/src/debug/AndroidManifest.xml` |
| SEC-02 | HIGH | `android:allowBackup` is absent (defaults true); plaintext financial DB is eligible for device/cloud backup | `android/app/src/main/AndroidManifest.xml` |
| FIN-02 | HIGH | Daily Solana spend limit is computed from `createdAt`, so proposals created yesterday and sent today bypass the limit | `lib/data/repositories/payment_repository.dart:200-205` |
| FIN-03 | HIGH | Supplier purchase payment with `method: credit` still reduces cash | `lib/domain/rules/ledger_rules.dart:39-42` |
| UX-01 | HIGH | Voice payment intent is discarded: `VoiceSheet` pushes `/pay/new` with `extra`, `PayScreen` never reads it | `lib/features/assistant/voice_sheet.dart:161-165`, `lib/features/payments/pay_screen.dart` |
| UX-02 | HIGH | Offline Hindi/Devanagari voice input does not work (parser word lists are Latin-only); app has no `localizationsDelegates`/`supportedLocales` | `lib/domain/rules/voice_parser.dart`, `lib/app/app.dart:31` |
| PROD-01 | HIGH | "AI Business Insights" shows **fabricated** figures and the export button fakes success | `lib/features/insights/insights_screen.dart` |
| DATA-01 | HIGH | No export, backup, restore or clear-all-data; uninstall destroys the ledger | `lib/features/settings/`, `lib/features/more/` (no implementation) |
| AI-01 | HIGH | Cloud AI endpoint accepts `http://`; API key and command text (customer names, amounts) can leave the device in cleartext with no explicit consent | `lib/domain/ai_config.dart:24-33`, `lib/services/cloud_ai_client.dart:36-45` |

---

## 4. What is genuinely good

- **Deterministic-first AI design.** The on-device parser runs before any cloud call, and
  recording intents always require confirmation (`assistant_service.dart`).
- **No LLM in the money path.** Solana amounts, policy checks and ledger writes are
  deterministic; the LLM only classifies intent.
- **Append-only accounting intent.** Reversals post a compensating entry rather than
  deleting history (`ledger_repository.reverseEntry`).
- **Policy engine is separate from the UI.** `PolicyEngine` checks per-payment and daily
  limits before signing.
- **Clean separation** between `domain`, `data`, `services` and `features`.
- **Secrets in secure storage.** The cloud API key is stored via `flutter_secure_storage`,
  not in SQLite.
- **No hard-coded provider secrets found** in `lib/` or `android/`.

---

## 5. Biggest structural gaps

1. **No production hardening.** Debug signing, placeholder app ID, missing release
   permission, backups enabled, no app lock, plaintext DB.
2. **Financial correctness under reversal is broken.** Any reversal corrupts dashboard
   sales/expenses and cash-on-hand, and the assistant uses that same broken cash figure
   for affordability answers.
3. **Payment integrity is asserted, not verified.** The app trusts whatever the wallet
   returns and never inspects the confirmed transaction.
4. **Hindi is claimed but not delivered offline.** The UI/locale and parser are English-first.
5. **The "insights" screen is a mockup, not analytics.** It shows fixed numbers and a fake
   export toast, which is dangerous in a financial product.
6. **Data durability is unaddressed.** No backup/export and no migration strategy means a
   single uninstall or schema bump can lose or strand merchant data.
7. **Verification is almost absent.** Three unit tests, no widget or integration tests, no
   CI, no security tests.

---

## 6. Caveat on the snapshot

While this audit was running, another process modified `lib/**/*.dart` continuously until
**17:24:03**. The audit waited for 60 seconds of no changes, then re-ran the analyzer and
tests. All findings below refer to that stable snapshot. If the other process resumes,
re-run `flutter analyze` and `flutter test` before acting on this report.

---

## 7. Recommended order of work

1. **Stop the bleeding (P0):** release signing + applicationId, INTERNET permission,
   `allowBackup=false`, signed-transaction verification, reversal accounting fix,
   daily-limit timestamp fix.
2. **Make the product honest (P1):** wire or remove the insights screen and fake export,
   fix voice-to-pay, cap repayments, fix credit purchases, add export/backup.
3. **Harden (P2):** HTTPS-only AI endpoint + consent, app lock/biometric, DB encryption,
   payment status state machine, duplicate-invoice/phone constraints.
4. **Scale and verify (P3):** pagination, aggregate queries, widget/integration tests, CI.

See `REMEDIATION_ROADMAP.md` for the full sequencing and `IMPLEMENTATION_GAP_REPORT.md`
for the feature-by-feature gap list.
