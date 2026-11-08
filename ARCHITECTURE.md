# SOLEPARTNER — SYSTEM ARCHITECTURE SPECIFICATION
**Version:** 1.0.0-PROD  
**Target:** Android Mobile & Future Cloud Synchronization  
**Document Classification:** Architectural Blueprint (Phase 0)

---

## 1. System Vision & Architectural Paradigm

**SolePartner** is an offline-first, voice-native financial operating system designed for Indian kirana stores and small retail merchants.

The architecture prioritizes **uncompromising data integrity, zero-trust financial execution, and complete offline autonomy**:
1. **Local-First Truth:** The device's local database is the primary source of truth for daily retail operations. Network connectivity is never a prerequisite for recording sales, checking stock, adding customers, or calculating udhaar.
2. **Deterministic Financial Safety:** All balances, credit aging, inventory movements, and spending limits are calculated using pure, deterministic Dart functions. No LLM or generative model ever sits in the execution path of money movements.
3. **Zero-Trust Blockchain Bridge:** The AI generates payment proposals; human merchants approve proposals; mobile wallets sign transactions; the Solana cluster executes transfers; and the on-chain state authoritatively verifies settlement.

---

## 2. Layered Clean Architecture

SolePartner follows Clean Architecture with strict directional dependencies:

```
┌────────────────────────────────────────────────────────┐
│                   PRESENTATION (UI)                   │
│   Screens, Widgets, Sheets, Theme, AnimatedSwitcher   │
└───────────────────────────▲────────────────────────────┘
                            │ depends on
┌───────────────────────────┴────────────────────────────┐
│                    APPLICATION STATE                   │
│           Riverpod Providers, Controllers, Routers     │
└───────────────────────────▲────────────────────────────┘
                            │ depends on
┌───────────────────────────┴────────────────────────────┐
│                     SERVICES LAYER                     │
│   PaymentService, SolanaService, CloudAiClient, Audio  │
└───────────────────────────▲────────────────────────────┘
                            │ depends on
┌───────────────────────────┴────────────────────────────┐
│                   DATA & REPOSITORIES                  │
│       Mappers, Drift SQLite Database, SecureStorage    │
└───────────────────────────▲────────────────────────────┘
                            │ depends on
┌───────────────────────────┴────────────────────────────┐
│                   DOMAIN CORE (PURE)                   │
│  Models, Enums, LedgerRules, PolicyEngine, VoiceParser │
└────────────────────────────────────────────────────────┘
```

### Module Responsibilities:
- **`lib/domain/`**: Pure business rules with zero Flutter/UI dependencies. Contains models, value objects, integer paise rules (`ledger_rules.dart`), spending policy checks (`policy_engine.dart`), and Hindi/English grammar parsing (`voice_parser.dart`).
- **`lib/data/`**: Drift table schemas (`tables.dart`), SQLite queries, type mappers (`mappers.dart`), and domain repositories (`customer_repository.dart`, `ledger_repository.dart`, etc.).
- **`lib/services/`**: External boundary adapters: `solana_service.dart` (RPC client & Mobile Wallet Adapter), `cloud_ai_client.dart` (HTTPS OpenAI completions), `speech_service.dart` (Speech-to-Text), `payment_service.dart` (orchestrating proposals, approval, and verification).
- **`lib/app/`**: Root configuration, providers (`providers.dart`), routing (`router.dart`), design tokens (`theme.dart`), and animated theme controller (`theme_controller.dart`).
- **`lib/features/`**: Feature-first UI components divided into:
  - `onboarding/`: 3D artwork, welcome tour, merchant setup form.
  - `dashboard/`: Financial summary cards, sparklines, quick actions.
  - `ledger/`: Reversible double-entry transaction list, date filters.
  - `assistant/`: Pulsing microphone, waveform animation, transcript review.
  - `inventory/`: Product catalog, SKU scanner, stock movement history.
  - `customers/`: Udhaar ledger, customer profiles, repayment sheets.
  - `suppliers/`: Vendor directory, purchase orders, payable tracking.
  - `insights/`: Database-backed revenue trends and margin reports.
  - `payments/`: Conversational payment proposals, policy review, Solana wallet.
  - `settings/`: Theme toggle, shop profile, audit logs, cloud AI settings.

---

## 3. Financial Integrity & Accounting Model

### Integer Paise Representation
- Floating-point numbers (`double`) are strictly prohibited in financial accounting to prevent binary rounding errors.
- Every currency value is stored as an integer number of **paise** (`1 INR = 100 paise`).
- Display formatting (`Money.format`) converts integer paise to formatted currency string (e.g. `125050 paise` -> `₹1,250.50`).
- Solana amounts are stored as integer **lamports** (`1 SOL = 1,000,000,000 lamports`).

### Immutable Ledger & Reversal Pattern
- The ledger is append-only. Financial records are never updated or deleted in place.
- If an erroneous entry occurs, a compensating **Reversal Entry** is inserted pointing to `reversalOfId`.
- Both entries remain in the permanent audit trail.
- As demonstrated in `test/ledger_rules_test.dart`, an entry and its reversal net sales, expenses, and cash-on-hand deltas to exactly zero.

---

## 4. AI & Voice Pipeline

```
  [Microphone / Text Input]
              │
              ▼
    [Speech-to-Text Engine]
              │
              ▼
  [Deterministic VoiceParser] ──(Match Found)──► [Structured ParsedCommand]
              │                                             │
      (No Local Match)                                      │
              ▼                                             │
      [Opt-in Cloud LLM]                                    │
  (HTTPS JSON Mode Structured Prompt)                       │
              │                                             │
              ▼                                             │
      [Parsed JSON Output] ─────────────────────────────────┤
                                                            ▼
                                              [Merchant Confirmation Dialog]
                                                            │
                                                     (User Confirms)
                                                            ▼
                                                [Deterministic Service]
                                             (Ledger / Stock / Proposal)
```

1. **Local First:** 90%+ of common merchant commands (Hindi, Hinglish, English) are resolved offline in < 5 milliseconds by `VoiceParser`.
2. **Cloud Fallback:** If local grammar confidence is low and cloud AI consent is explicitly granted, an HTTPS request is dispatched to Groq / OpenAI-compatible endpoint.
3. **Structured Enforcement:** Responses are constrained to strict JSON schemas.
4. **Mandatory Human-in-the-Loop:** Neither parser nor cloud LLM can mutate database state directly. Every action generates a preview command that requires merchant confirmation.

---

## 5. Blockchain Payment & Zero-Trust Safety Engine

Solana transactions follow an 8-stage zero-trust lifecycle:

```
[Intent] ──► [Policy Engine Check] ──► [Draft Proposal] ──► [Merchant Approval]
                                                                  │
[On-Chain Settlement] ◄── [RPC Submit] ◄── [Payload Verify] ◄── [Wallet Sign]
        │
        ▼
[Transaction Verification (RPC parsed instructions)]
        │
        ▼
[Confirmed Ledger Update & Audit Log]
```

- **Policy Engine:** Verifies daily spend cap, single-payment cap, allowlisted recipients, and Devnet network enforcement before signing.
- **Mobile Wallet Adapter:** Private keys never enter the app. Transactions are signed inside Phantom/Solflare.
- **RPC Verification:** On-chain instruction parsed verification ensures destination and lamports match proposal before marking status as `confirmed`.

---

## 6. Future Multi-Tenant Cloud Synchronization Architecture

When remote cloud synchronization is enabled for multi-store chains:
- **Protocol:** REST/JSON + WebSockets via Supabase / PostgreSQL or FastAPI backend.
- **Conflict Resolution:** Last-Write-Wins with Lamport timestamps for static metadata; additive CRDT delta aggregation for ledger and stock movements.
- **Tenant Isolation:** Supabase Row Level Security (RLS) policies scoped to authenticated `merchant_id`.

