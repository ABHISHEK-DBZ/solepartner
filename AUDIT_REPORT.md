# SOLEPARTNER — COMPREHENSIVE REPOSITORY AUDIT REPORT
**Document ID:** AUD-2026-11-08-01  
**Project:** SolePartner (formerly KhataCopilot)  
**Classification:** Engineering & Security Audit  
**Date:** November 8, 2026  
**Auditor:** Principal Software & Security Architect  
**Status:** Baseline Discovery Complete (Phase 0)

---

## 1. Executive Summary

A comprehensive, ground-up technical and security audit of the **SolePartner** codebase was conducted across all layers:
- Mobile client (Flutter 3.x, Dart 3.9+)
- Local persistence (Drift / SQLite, SQLCipher considerations)
- Business logic & accounting engine (Integer paise/lamport arithmetic, reversal rules, FIFO debt aging)
- Voice interaction & AI pipeline (Hybrid: deterministic regex/grammar parser first, OpenAI-compatible cloud LLM fallback)
- Payment & blockchain engine (Solana Devnet, Mobile Wallet Adapter, policy engine, RPC verification)
- Android native configuration (Manifest permissions, signing configurations, application ID)
- Legal, privacy, and regulatory controls (India DPDP Act 2023, IT Act 2000, RBI directions, CERT-In guidelines)

### Summary of System Posture

| Area | Score | Status | Key Observation |
|---|---|---|---|
| **Frontend & UI Polish** | 9 / 10 | **Ready** | High-fidelity SolePartner design system, dark/light mode toggle with 400ms lerp, animated 3D onboarding tour, responsive layouts, zero visual overflows. |
| **Accounting Invariants** | 8.5 / 10 | **Substantially Hardened** | Integer paise arithmetic, strict deltas for cash/credit, reversal netting to zero, FIFO overdue aging. |
| **Solana Blockchain Engine** | 8 / 10 | **Substantially Hardened** | Mobile Wallet Adapter integration, deterministic pre-signing policy validation, signature deduping, post-confirmation on-chain instruction verification. Pre-submission signed payload decode needed. |
| **AI Safety & Privacy** | 8.5 / 10 | **Substantially Hardened** | Deterministic parser executes first; cloud LLM strictly opt-in; HTTPS-only enforced; zero LLMs in financial mutation path. |
| **Native Android Configuration** | 7.5 / 10 | **Needs Release Signing** | `INTERNET` and `RECORD_AUDIO` permissions in main manifest; `allowBackup="false"` configured; needs production keystore and custom application ID. |
| **Automated Testing** | 6 / 10 | **In Progress** | 12 unit tests passing (100% pass rate); integration, widget, and accessibility test suites to be expanded. |
| **Legal & Regulatory Compliance** | 6 / 10 | **Templates Drafted** | Clear distinction between ledger bookkeeping and external payment settlement; DPDP Act 2023 consent flows and data export/deletion workflows present. Formal legal counsel signoff pending. |

---

## 2. Comprehensive Findings Log

### [CRIT-01] Release APK Signed with Debug Key & Placeholder Application ID
- **Severity:** Critical
- **Affected File:** `android/app/build.gradle.kts:24, 37`
- **Evidence:**
  ```kotlin
  defaultConfig {
      applicationId = "com.khata.copilot"
  }
  buildTypes {
      release {
          signingConfig = signingConfigs.getByName("debug")
      }
  }
  ```
- **Exploit / Failure Scenario:** An APK compiled with debug keys cannot be safely distributed on Google Play Store or sideloaded without warnings. Debug certificates have well-known private keys, making the binary susceptible to repackaging and signature spoofing.
- **Business Impact:** Blocked app store deployment, inability to establish trusted merchant identity, security warning flags on modern Android devices.
- **Recommended Correction:** Configure `key.properties` pattern reading keystore credentials from environment variables / secure build vault, and change `applicationId` to official package name (e.g., `com.solepartner.app`).
- **Verification Test:** Run `flutter build apk --release` and verify with `apksigner verify --print-certs`.

---

### [HIGH-01] Pre-Submission Signed Transaction Payload Verification Gap
- **Severity:** High
- **Affected File:** `lib/services/payment_service.dart:173-207`
- **Evidence:**
  ```dart
  final String signed = await _solana.signTransaction(prepared.unsignedBase64);
  ...
  signature = await _solana.submitSignedTransaction(signed);
  ```
- **Exploit / Failure Scenario:** The app validates the unsigned transaction before sending it to the wallet, and verifies the on-chain transfer *after* confirmation via `verifyTransfer`. However, between receiving the signed payload from the wallet and submitting it to the Solana cluster via RPC, the base64-encoded transaction is submitted directly without decoding to verify that the wallet didn't alter instructions or recipient addresses.
- **Business Impact:** In the event of a malicious or compromised wallet app modifying instructions during the sign phase, the altered transaction would be submitted to the Solana cluster before failing verification.
- **Recommended Correction:** Decode the signed transaction bytes prior to calling `submitSignedTransaction` and assert that the destination public key and lamports match the approved proposal.
- **Verification Test:** Unit test injecting a modified signed payload and confirming `approveAndSend` rejects submission before hitting the RPC client.

---

### [MED-01] SQLite Database Stored Unencrypted (Plaintext At Rest)
- **Severity:** Medium
- **Affected File:** `lib/data/db/app_database.dart:28-30`
- **Evidence:**
  ```dart
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'khatacopilot'));
  ```
- **Exploit / Failure Scenario:** While `android:allowBackup="false"` is set (preventing ADB/cloud extraction), on rooted devices or via forensic extraction, the local SQLite database file `khatacopilot.sqlite` contains unencrypted customer names, phone numbers, and debts.
- **Business Impact:** Potential unauthorized exposure of merchant customer records on lost or compromised hardware under DPDP Act 2023 data security provisions.
- **Recommended Correction:** Introduce SQLCipher encryption via `sqlite3_flutter_libs` with encryption key derived securely from Android Keystore / `flutter_secure_storage`.
- **Verification Test:** Inspect raw database file on storage; confirm file header is not `SQLite format 3` and content is unreadable without decryption key.

---

### [MED-02] Application Lock & Biometric Guard Absent for Sensitive Actions
- **Severity:** Medium
- **Affected File:** `lib/app/router.dart`, `lib/features/payments/pay_screen.dart`
- **Evidence:** The application opens directly to the dashboard without PIN/biometric authentication, and payment approvals rely solely on an on-screen button tap before invoking the wallet.
- **Exploit / Failure Scenario:** If an employee or third party has physical access to an unlocked merchant device, they can review confidential turnover data or submit payment proposals to the wallet.
- **Business Impact:** Staff misuse, unintended transaction initiation, unauthorized visibility into store financials.
- **Recommended Correction:** Integrate `local_auth` package to provide an optional app-level biometric/PIN lock and require step-up authentication prior to Solana payment approval or ledger clearing.
- **Verification Test:** Trigger payment approval; verify biometric/PIN dialog blocks execution until authentication succeeds.

---

### [LOW-01] Lack of Formal Database Migration Test Harness
- **Severity:** Low
- **Affected File:** `lib/data/db/app_database.dart:33`
- **Evidence:** `schemaVersion => 1` is currently hardcoded with no incremental migration step handlers registered.
- **Exploit / Failure Scenario:** When upgrading the app to schema version 2 (e.g., adding multi-store support or sync metadata), merchants' existing local databases could fail to open or require a destructive table drop if migration steps are not properly tested.
- **Business Impact:** Risk of local data loss during app updates.
- **Recommended Correction:** Implement Drift migration steps (`MigrationStrategy.onUpgrade`) and establish a migration test harness using Drift test verifiers.
- **Verification Test:** Test database upgrade from schema v1 to future schema v2 preserving existing rows.

---

### [LOW-02] Pagination Missing on Large Ledger & Customer Queries
- **Severity:** Low
- **Affected File:** `lib/data/repositories/ledger_repository.dart:36-45`
- **Evidence:** `allEntries()` and `loadCustomers()` fetch all rows in a single query.
- **Exploit / Failure Scenario:** For high-volume kirana merchants with >10,000 transactions over several months, querying the entire ledger into memory could cause UI jank and frame drops on budget Android devices.
- **Business Impact:** Degraded user experience, higher memory footprint on low-end Android devices.
- **Recommended Correction:** Introduce limit/offset pagination or cursor-based streaming queries in Riverpod providers for large datasets.
- **Verification Test:** Seed 15,000 ledger entries and measure time to first render and memory usage under 60fps frame rate.

---

## 3. Resolved Findings (Verified in Audit)

| Original Finding ID | Description | Resolution Status | Verified In |
|---|---|---|---|
| **SEC-01 (Old)** | Release APK lacked INTERNET permission | **RESOLVED** | `android/app/src/main/AndroidManifest.xml:2` |
| **SEC-02 (Old)** | Backups enabled by default | **RESOLVED** | `android/app/src/main/AndroidManifest.xml:7` (`allowBackup="false"`) |
| **AI-01** | Cloud AI endpoint allowed cleartext HTTP | **RESOLVED** | `lib/domain/ai_config.dart:37` (`scheme != 'https'`) |
| **FIN-01** | Reversals counted as fresh sales/expenses | **RESOLVED** | `lib/domain/rules/ledger_rules.dart:101-125` |
| **FIN-02** | Spend limit bypassed via stale proposal | **RESOLVED** | `lib/data/repositories/payment_repository.dart:231` |
| **FIN-03** | Credit purchase payment reduced cash | **RESOLVED** | `lib/domain/rules/ledger_rules.dart:43-45` |
| **UX-01** | Voice payment extra parameter discarded | **RESOLVED** | `lib/features/payments/pay_screen.dart:48-50` |
| **BC-01** | Post-confirmation on-chain verification | **RESOLVED** | `lib/services/solana_service.dart:253-296` (`verifyTransfer`) |
| **PROD-01** | Insights screen had mocked data | **RESOLVED** | `lib/features/insights/insights_screen.dart:52-90` |
| **DATA-01** | Missing export and clear data features | **RESOLVED** | `lib/features/settings/settings_screen.dart:101-180` |

---

## 4. Audit Conclusion & Next Phase Gate
The SolePartner codebase demonstrates a clean, resilient, local-first architecture with strong accounting rigor and explicit security boundaries. The critical blocking item for production deployment is the release keystore signing configuration. All architectural blueprints, threat models, API specs, and compliance matrices are formalized in the companion Phase 0 documents.

