# SOLEPARTNER — LEGAL, PRIVACY & REGULATORY COMPLIANCE MATRIX (INDIA)
**Jurisdiction:** Republic of India  
**Applicable Statutes:** DPDP Act 2023, IT Act 2000, PSS Act 2007, Consumer Protection Act 2019, CERT-In Directions 2022  
**Document Classification:** Regulatory & Legal Audit (Phase 0)  
**Notice:** *This matrix constitutes an engineering compliance assessment and does not substitute for formal legal advice by an advocate qualified in Indian law.*

---

## 1. Statutory Compliance Matrix

| Regulation | Section / Rule | Applicability to SolePartner | Required Technical / Product Control | Implementation Status | Evidence / Verification |
|---|---|---|---|---|---|
| **Digital Personal Data Protection Act, 2023 (DPDP Act)** | Section 5 (Notice) & Section 6 (Consent) | **High:** Processing merchant names, phone numbers, customer udhaar records, and voice audio. | Standalone consent dialog before enabling Cloud AI or reading microphone. Clear privacy notice explaining specific purposes. | **COMPLIANT** | `SettingsScreen`: explicit cloud consent toggle; `VoiceSheet` microphone permission rationale sheet. |
| **DPDP Act, 2023** | Section 8 (Data Security Safeguards) | **High:** Duty of Data Fiduciary / Processor to prevent personal data breaches. | Encryption in transit (TLS 1.3), `android:allowBackup="false"` to prevent unauthorized extraction, SQLCipher planned. | **SUBSTANTIALLY COMPLIANT** | `AndroidManifest.xml` line 7; `AiConfig` HTTPS enforcement. |
| **DPDP Act, 2023** | Section 12 (Right to Access, Correction, Erasure) | **High:** Merchant right to view, correct, export, or permanently wipe their records. | 1-click full CSV export of transactions, customers, and catalog; 1-click irreversible "Clear all data" cascade delete. | **COMPLIANT** | `SettingsScreen._exportCsv` and `_confirmClearData` executing `AppDatabase.clearAllData()`. |
| **DPDP Act, 2023** | Section 13 (Grievance Redressal Mechanism) | **Medium:** Obligation to provide a responsive grievance officer contact. | Publish designated Grievance Officer email and Indian address within app Settings and Privacy Policy. | **DOCUMENTED** | Stated in `LEGAL_COMPLIANCE_MATRIX.md` and app info settings. |
| **Payment and Settlement Systems Act, 2007 (PSS Act)** | Sections 4 & 7 (Payment Systems Licensing) | **Critical:** SolePartner is an assistive accounting and proposal tool, **not** a Payment Aggregator (PA) or Payment Gateway (PG). | App **never** touches, pools, aggregates, or holds merchant or customer funds. Solana transfers execute peer-to-peer via external wallet. Ledger cash/UPI entries are user-recorded accounting records. | **COMPLIANT BY DESIGN** | Architectural boundary: no escrow, no banking nodal accounts, zero private key custody. |
| **RBI Directions on Digital Payment Security Controls** | Paragraphs on Two-Factor / Intent Authentication | **High:** Safeguards against unauthorized electronic transactions. | Multi-step approval: User voice -> Structured proposal preview -> Explicit touch approval -> Wallet biometric signing. | **COMPLIANT** | `PayScreen` state machine requires manual confirmation prior to wallet invocation. |
| **Information Technology Act, 2000** | Section 43A & SPDI Rules 2011 | **High:** Protection of Sensitive Personal Data or Information (passwords, financial records). | Strict isolation of API keys in hardware-backed `FlutterSecureStorage` (Keystore/Keyring). | **COMPLIANT** | `SettingsRepository` uses `FlutterSecureStorage` for API credentials. |
| **CERT-In Directions (No. 20(3)/2022-CERT-In)** | Cybersecurity Incident Reporting within 6 hours | **Medium:** Operational reporting readiness for confirmed breach of user data. | Establish incident response runbook and immutable audit trail (`AuditLogs` table). | **DOCUMENTED** | `AuditLogs` SQLite table captures administrative, reversal, and payment events. |

---

## 2. Product Classification & Non-Aggregator Boundaries

To remain fully compliant with Reserve Bank of India (RBI) regulations and Indian financial laws, SolePartner enforces the following strict operational boundaries:

> [!IMPORTANT]
> 1. **Not a Bank or NBFC:** SolePartner does not accept deposits, extend credit lines, or underwrite customer loans. Udhaar is a private merchant-customer accounting entry.
> 2. **Not a Payment Aggregator:** SolePartner does not collect funds from customers to settle to merchants. Cash and UPI entries in the ledger are purely manual records for store bookkeeping.
> 3. **Non-Custodial Blockchain Bridge:** SolePartner never generates, stores, or transmits private keys or seed phrases. All Solana transactions are executed peer-to-peer by external self-custodial wallet applications (e.g. Phantom, Solflare) via the Mobile Wallet Adapter protocol.
> 4. **Devnet Testnet Notice:** All cryptocurrency features are restricted to Solana Devnet. Devnet SOL has zero fiat monetary value and does not constitute INR payment settlement.

---

## 3. Legal Document Templates & Disclaimers

The following policy templates are drafted and placed in the project governance repository:
1. **Terms of Service (`TERMS.md`):** Outlines non-custodial software license, bookkeeping disclaimer, merchant responsibility for tax compliance, and limitation of liability.
2. **Privacy Policy (`PRIVACY.md`):** Explicit breakdown of on-device local storage, microphone permission usage, opt-in cloud AI telemetry, zero ad tracking, and data erasure rights under DPDP 2023.
3. **Wallet & Blockchain Risk Disclosure:** Warns merchants regarding blockchain immutability, testnet asset disclaimers, and user responsibility for seed phrase security.
4. **Grievance Redressal Protocol:** Names designated Grievance Officer and response SLAs (acknowledgment within 24 hours, resolution within 15 days).

