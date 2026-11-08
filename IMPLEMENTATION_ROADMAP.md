# SOLEPARTNER — MULTI-PHASE IMPLEMENTATION ROADMAP
**Document ID:** ROADMAP-2026-11-08  
**Target Release:** SolePartner v1.0.0 Production  
**Execution Methodology:** Incremental, Test-Driven, Security-First  
**Classification:** Engineering Implementation Roadmap (Phase 0)

---

## Roadmap Overview & Phase Sequence

```
┌────────────────────────────────────────────────────────────────────────┐
│ Phase 0: Discovery & Comprehensive Audit (COMPLETED)                   │
├────────────────────────────────────────────────────────────────────────┤
│ Phase 1: Architecture, Database & Security Decisions (CURRENT)         │
├────────────────────────────────────────────────────────────────────────┤
│ Phase 2: Foundation, Environments, Release Config & Tokens             │
├────────────────────────────────────────────────────────────────────────┤
│ Phase 3: Authentication, App Lock & Merchant Roles                     │
├────────────────────────────────────────────────────────────────────────┤
│ Phase 4: Dashboard, Ledger & Reversible Financial Engine               │
├────────────────────────────────────────────────────────────────────────┤
│ Phase 5: Customers, Udhaar, Catalog, Suppliers & Purchasing            │
├────────────────────────────────────────────────────────────────────────┤
│ Phase 6: Offline Storage, Durability, SQLCipher & Sync Boundary        │
├────────────────────────────────────────────────────────────────────────┤
│ Phase 7: AI Assistant, Colloquial Voice Grammar & Real Analytics       │
├────────────────────────────────────────────────────────────────────────┤
│ Phase 8: Payment Agent, Zero-Trust Wire Verification & Solana Devnet   │
├────────────────────────────────────────────────────────────────────────┤
│ Phase 9: Legal Templates, DPDP Consent & Privacy Workflows             │
├────────────────────────────────────────────────────────────────────────┤
│ Phase 10: Automated Testing Expansion, Widget Tests & Security Audit   │
├────────────────────────────────────────────────────────────────────────┤
│ Phase 11: Keystore Signing, Release Packaging & Operational Runbooks   │
└────────────────────────────────────────────────────────────────────────┘
```

---

## Detailed Phase Breakdown

### Phase 0: Discovery & Comprehensive Audit
- **Status:** **COMPLETE**
- **Artifacts:**
  - `AUDIT_REPORT.md`
  - `ARCHITECTURE.md`
  - `SECURITY_AUDIT.md`
  - `DATA_MODEL.md`
  - `API_SPECIFICATION.md`
  - `LEGAL_COMPLIANCE_MATRIX.md`
  - `PRODUCTION_READINESS.md`
  - `IMPLEMENTATION_ROADMAP.md`
- **Gate:** All 8 discovery documents generated and aligned with master requirements.

---

### Phase 1: Architecture, Database & Technical Decisions
- **Objectives:**
  - Formalize local-first Drift SQLite storage as authoritative source of truth.
  - Establish pre-submission signed wire payload decoding interface in `SolanaService`.
  - Design optional biometric/PIN app lock boundary (`local_auth`).
- **Deliverables:** Architectural consensus, schema v1 validation tests.
- **Verification:** Unit test suite covering data structures.

---

### Phase 2: Foundation, Configuration & Design System
- **Objectives:**
  - Re-verify high-fidelity SolePartner design tokens (deep emerald `#087F5B`, light surface `#FFFFFF`, dark surface `#111C2D`).
  - Maintain smooth 400ms crossfade theme switching and persistent `ThemeModeController`.
  - Implement `key.properties.example` for Android release signing template.
- **Deliverables:** Updated Android configuration files, validated design tokens.
- **Verification:** `flutter analyze` zero issues.

---

### Phase 3: Authentication, App Lock & Merchant Onboarding
- **Objectives:**
  - Maintain 3D animated intro tour with 4 interactive feature cards.
  - Implement biometric / device PIN lock service for sensitive screen access (audit, policy edit, ledger clear).
  - Multi-store member permission matrix design.
- **Deliverables:** `LocalAuthService`, onboarding persistence checks.
- **Verification:** Widget tests for onboarding flow and app lock triggers.

---

### Phase 4: Dashboard, Ledger & Financial Calculations
- **Objectives:**
  - Verify dashboard summary calculations: today sales, expenses, net cash movement, and udhaar balances.
  - Verify double-entry ledger reversal pattern: compensating entries netting to zero.
  - Expand test suite for edge-case reversals, partial repayments, and supplier credit.
- **Deliverables:** Complete financial test suite in `test/ledger_rules_test.dart`.
- **Verification:** 100% test pass rate on financial calculations.

---

### Phase 5: Customers, Udhaar, Catalog, Suppliers & Purchasing
- **Objectives:**
  - Customer directory with search, overdue badges, and repayment recording.
  - Inventory management with barcode scanner integration and low-stock alerts.
  - Supplier purchasing workflows with stock movement tracking.
- **Deliverables:** Repositories, interactive sheets, and view models.
- **Verification:** Integration tests verifying stock deduction upon sales and stock addition upon purchases.

---

### Phase 6: Offline Storage, SQLCipher & Data Export
- **Objectives:**
  - 1-click CSV data export for transactions, customers, and inventory catalog.
  - Irreversible "Clear all data" cascade deletion meeting DPDP right to erasure.
  - Database encryption evaluation using SQLCipher.
- **Deliverables:** Verified export/erasure routines in `SettingsScreen`.
- **Verification:** Automated export parsing test verifying CSV integrity.

---

### Phase 7: AI Assistant, Colloquial Voice & Business Insights
- **Objectives:**
  - Local-first grammar parser handling Hindi, Hinglish, and English Kirana commands.
  - Secure HTTPS-only cloud LLM client with structured JSON response validation.
  - Real database-backed business intelligence charts and margin reports.
- **Deliverables:** `VoiceParser` word-lists, `InsightsScreen` weekly breakdown.
- **Verification:** Tests in `voice_parser_test.dart` and `ai_config_test.dart`.

---

### Phase 8: Payment Agent, Approval Policy & Solana Devnet
- **Objectives:**
  - Conversational payment intent extraction with visual confirmation dialog.
  - Deterministic spending policy checks (single payment cap, daily cap, saved payees).
  - Mobile Wallet Adapter signing, duplicate signature prevention, and on-chain RPC confirmation.
  - Implementation of pre-submission signed wire payload decoding.
- **Deliverables:** Hardened `PaymentService` and `SolanaService`.
- **Verification:** Mock wallet signing tests and policy rejection tests.

---

### Phase 9: Legal, Privacy & Compliance Controls
- **Objectives:**
  - Formalize standalone Privacy Policy, Terms of Service, and Non-Custodial Disclaimers in app settings.
  - Document designated Grievance Redressal Officer contact information.
- **Deliverables:** Legal dialogs and markdown documents within app.
- **Verification:** Content inspection against statutory matrix.

---

### Phase 10: Automated Testing Expansion & Security Verification
- **Objectives:**
  - Comprehensive unit, widget, and integration test suite across all user flows.
  - Static security analysis and dependency vulnerability audit.
- **Deliverables:** Expanded test suites in `test/`.
- **Verification:** `flutter test` executing all suites with 0 failures.

---

### Phase 11: Deployment Configuration & Release Readiness
- **Objectives:**
  - Android release build configuration with `key.properties`.
  - Final Release Candidate build verification on Android.
  - Final Production Readiness report presentation.
- **Deliverables:** Release APK/AAB build instructions and operational runbooks.
- **Verification:** Successful release build execution with signed certificates.

