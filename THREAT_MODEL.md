# Threat Model — KhataCopilot

**Method:** STRIDE-style, scoped to a local-first mobile ledger with an optional cloud LLM
and a Solana wallet adapter. No server, no multi-tenant boundary.

---

## 1. Assets

| Asset | Sensitivity |
|---|---|
| Customer names, phones, debts | High (PII + financial) |
| Ledger entries and balances | High (business integrity) |
| Solana wallet / signed transactions | Critical (money) |
| Cloud AI API key | High |
| Audit log | Medium |
| Merchant profile | Low/Medium |

## 2. Trust boundaries

1. **Device user <-> app** (no app lock today).
2. **App <-> SQLite file** (plaintext; backup-eligible).
3. **App <-> cloud AI endpoint** (user-supplied URL; key + command text).
4. **App <-> wallet adapter / deeplink** (signed payload is trusted today).
5. **App <-> Solana RPC** (network; release manifest lacks INTERNET).

## 3. Threat actors

- Lost/stolen device thief.
- Malicious app or ADB user with device/backup access.
- Compromised or malicious wallet adapter / deeplink.
- Malicious or misconfigured cloud AI endpoint.
- Careless insider (merchant) causing accidental data loss.
- Supply-chain attacker via an unused/vulnerable dependency.

---

## 4. Threats and mitigations

| ID | STRIDE | Threat | Current state | Mitigation |
|---|---|---|---|---|
| T-01 | Spoofing | Malicious wallet returns a signed tx to a different recipient | **No verification** (BC-01) | Decode/verify signed payload and on-chain tx before confirm |
| T-02 | Tampering | Attacker edits plaintext DB or backups | Plaintext, backup on (SEC-03/04) | `allowBackup=false`, SQLCipher, app lock |
| T-03 | Repudiation | Merchant denies a recorded transaction | Mutable local audit log | Hash-chained audit + secure head |
| T-04 | Information disclosure | Customer PII sent to third-party AI | No explicit consent; HTTP allowed (SEC-05/06) | HTTPS-only, consent, redaction |
| T-05 | Information disclosure | API key intercepted over HTTP | Scheme unchecked (SEC-05) | Enforce HTTPS, pin host |
| T-06 | Denial of service | Hostile AI endpoint hangs/costs | No `max_tokens`/body cap (SEC-10) | Caps, timeouts, quota errors |
| T-07 | Elevation | Policy bypass via `createdAt` or `devnetOnly=false` | Present (BC-02/03) | Fix window; enforce devnet |
| T-08 | Data loss | Uninstall/device loss destroys books | No export/backup (FE-04) | Export/restore, scheduled backup |
| T-09 | Tampering | Reversal corrupts aggregates | Present (BE-01) | Fix aggregators, add tests |
| T-10 | Spoofing | Duplicate invoice/signature/barcode | No DB uniqueness (DB-02/03/04) | Unique indexes + checks |
| T-11 | Elevation | Debug-signed release replaced/updated | Debug key (SEC-01) | Production keystore |
| T-12 | Information disclosure | Backup exfiltration | `allowBackup` default true | Disable/strict rules |

---

## 5. Residual risk after planned fixes

Even after P0/P1, the app remains a single-device, no-auth, plaintext-by-default product.
Residual risks:

- Anyone with an unlocked device can read the ledger unless a lock is added.
- Local audit logs are convenience records, not legally tamper-proof.
- Solana verification depends on the RPC's honesty unless the tx is independently fetched
  from multiple sources.
- Cloud AI remains an optional third-party data flow; users must understand it.

## 6. Out of scope

Server-side auth/RLS/API security, multi-tenant isolation, network perimeter, and mainnet
financial controls (the product is devnet-only by design).
