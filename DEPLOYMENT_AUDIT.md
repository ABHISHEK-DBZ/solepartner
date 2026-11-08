# Deployment Audit — KhataCopilot

**Score: 2 / 10**
**Scope:** `android/`, `pubspec.yaml`, build config, release readiness

---

## 1. Platform coverage

Only `android/` exists (plus `lib/`, `test/`). There is **no `ios/`, `web/`, `windows/`,
`macos/`, or `linux/` directory**. If cross-platform is intended, those targets are absent.

---

## 2. Findings

### DEP-01 — CRITICAL — Release is signed with the debug key
- **File:** `android/app/build.gradle.kts:37`
- **Evidence:** `signingConfig = signingConfigs.getByName("debug")` in the `release` block.
- **Impact:** Not a valid production artifact; cannot be safely updated or published; debug
  keys are public.
- **Fix:** Generate a keystore, store credentials outside VCS (`key.properties`), configure
  a `release` signing config, and document key custody.
- **Verify:** `flutter build apk --release` + `apksigner verify --print-certs`.

### DEP-02 — CRITICAL — Placeholder application ID and version
- **File:** `android/app/build.gradle.kts:24`, `pubspec.yaml`
- **Evidence:** `applicationId = "com.khatacopilot.khatacopilot"`; `version: 1.0.0+1`;
  `description: "A new Flutter project."`; Android label `khatacopilot` (lowercase).
- **Impact:** Store rejection / identity collision / unprofessional metadata; no versioning
  discipline.
- **Fix:** Choose a stable reverse-DNS ID, set a proper label, description and version, and
  document the release process.

### DEP-03 — HIGH — INTERNET permission missing from the release manifest
- **Files:** `android/app/src/main/AndroidManifest.xml`,
  `android/app/src/debug/AndroidManifest.xml`
- **Evidence:** Only the debug manifest declares `INTERNET`.
- **Impact:** Solana RPC and cloud AI fail in release builds.
- **Fix:** Add `INTERNET` to the main manifest (and any other required permissions).

### DEP-04 — HIGH — Backups enabled by default
- **File:** `android/app/src/main/AndroidManifest.xml`
- **Evidence:** No `android:allowBackup="false"` and no `dataExtractionRules`.
- **Impact:** Plaintext financial DB can be exfiltrated via backup.
- **Fix:** Disable backup or define strict extraction rules.

### DEP-05 — MEDIUM — No CI/CD
- **Evidence:** No pipeline config or release scripts.
- **Impact:** No automated analyze/test/format gate; regressions ship silently.
- **Fix:** Add CI (analyze, test, format check, build) and a tagged release workflow.

### DEP-06 — MEDIUM — No obfuscation/shrinking configuration
- **Evidence:** No `isMinifyEnabled`/`isShrinkResources` or ProGuard/R8 rules in the release
  block.
- **Impact:** Larger APK and easier reverse engineering of business logic.
- **Fix:** Enable R8/shrinking with keep rules for Drift/reflection-free code.

### DEP-07 — MEDIUM — No privacy policy, terms, or data-safety disclosure
- **Evidence:** No policy screens or store metadata in the repo, despite collecting customer
  PII and optionally sending it to a cloud AI endpoint.
- **Impact:** Store rejection and legal/compliance risk.
- **Fix:** Add in-app privacy/terms and complete the Play data-safety form.

### DEP-08 — LOW — Demo seed data ships in the production path
- **File:** `lib/data/db/seed_data.dart`
- **Evidence:** First run inserts demo merchant/customers/products/transactions.
- **Impact:** Real merchants start with fake books.
- **Fix:** Gate behind a demo flag or remove for release.

### DEP-09 — LOW — Debug banner disabled, but no crash reporting
- **Evidence:** `debugShowCheckedModeBanner: false`; no Sentry/Firebase Crashlytics.
- **Impact:** Production crashes are invisible.
- **Fix:** Add opt-in crash reporting with PII scrubbing (or document local-only support).

### DEP-10 — LOW — No environment separation
- **Evidence:** Devnet-only is UI-enforced; no build flavors for dev/staging/prod.
- **Fix:** Add flavors and a compile-time network/policy switch.

---

## 3. Release readiness checklist

| Item | Status |
|---|---|
| Production keystore | No |
| Real applicationId | No |
| Release INTERNET | No |
| `allowBackup=false` | No |
| Privacy policy / terms | No |
| CI analyze/test gate | No |
| Versioning strategy | No |
| Crash reporting | No |
| Store listing assets | No |
| iOS/web targets | No |

## 4. Score rationale

- + The debug build compiles and the app is functional in development.
- − Every production-release requirement is missing or placeholder.
