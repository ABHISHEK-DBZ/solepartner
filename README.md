# SolePartner — AI Business Partner
> **Autonomous AI Merchant Copilot & Real-Time Financial Operating System**  
> *Your Voice. Your Ledger. Your AI Payment Agent.*

---

## 📌 Overview

**SolePartner** (formerly KhataCopilot) is a production-grade, local-first financial and business management operating system designed for Indian kirana stores, retail merchants, and small businesses.

Built with **Flutter** (Android), **Drift SQLite**, and **Solana Mobile Wallet Adapter (MWA)**, it delivers hands-free voice bookkeeping, offline-first ledger and inventory management, zero-trust AI financial controls, and non-custodial crypto/fiat settlements.

---

## 🚀 Key Highlights & Architectural Guarantees

1. **Voice-First Merchant Bookkeeping**:
   - Natural language voice commands in Hindi, Hinglish, and English (e.g. *"Aaj Ramesh ko ₹5,000 ka udhaar diya"* or *"Dukaan kiraya ₹12,000 cash me record karo"*).
   - Deterministic slot-filling parser with strict validation before ledger entry creation.

2. **Zero-Trust Financial AI Policy**:
   - **LLMs are strictly decoupled from transaction authorization.**
   - The AI assistant can propose transaction drafts, but can never sign, authorize, or execute transfers without explicit, biometric/cryptographic user approval.
   - Built-in spending limits: Per-payment cap (0.1 SOL default), daily velocity limits (1.0 SOL default), and whitelisted payee checks.

3. **Production Solana Wallet Integration**:
   - Native **Mobile Wallet Adapter (MWA)** protocol for seamless communication with Phantom, Solflare, and compatible Solana mobile wallets on Android.
   - **Zero Custody**: Private keys and seed phrases never touch the application.
   - **Pre-Submission Cryptographic Wire Verification**: Every signed transaction wire payload is decoded and cryptographically verified (`SignedTx.fromBytes`) before submission to ensure destination addresses and amounts have not been tampered with.
   - Authoritative RPC confirmation on Solana Devnet & Mainnet with explorer deep links.

4. **Offline-First & Local-First Integrity**:
   - High-performance SQLite embedded database via **Drift** (`drift_flutter`).
   - Pure integer math (`paise` for INR, `lamports` for SOL) preventing floating-point rounding errors.
   - Instant query execution, full offline readiness, and reactive UI updates via Riverpod streams.

5. **Fintech Design System**:
   - Modern, minimal, and information-dense interface tailored for daily merchant operations.
   - Smooth animated Light & Dark theme toggle with 400ms crossfade interpolation and persisted user preferences.
   - Full bilingual support (English and Hindi localization).

---

## 📱 Application Modules

- **📊 Dashboard**: Real-time net movement, daily sales, operational expenses, pending udhaar, and low-stock AI insights.
- **📖 Digital Ledger**: Dual-entry style transaction history categorized by Sales, Expenses, and Udhaar with search and date filtering.
- **🎙️ Voice Copilot**: Real-time microphone listening sheet with waveform animation and voice-to-ledger command execution.
- **📦 Inventory & Stock**: Product catalog with SKU, barcode, unit pricing, real-time stock counters, and restock alerts.
- **👥 Customers & Udhaar**: Khata ledger for regular customers, credit limits, overdue day tracking, and WhatsApp payment reminder sharing.
- **⚡ AI Payment Agent & Wallet**: Solana self-custodial wallet manager, Devnet faucet airdrop button, balance cards, and proposal approval flow.
- **⚙️ Settings & Audit**: Detailed audit logs, system diagnostics, spending policies, and data export.

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter 3.x / Dart 3.x |
| **State Management** | Flutter Riverpod 2.6 (`StreamProvider`, `StateNotifier`) |
| **Local Database** | Drift SQLite (`drift`, `drift_flutter`, `sqlite3_flutter_libs`) |
| **Blockchain** | `solana`, `solana_wallet_adapter`, `pinenacl` |
| **Voice & Audio** | `speech_to_text`, `flutter_tts` |
| **Secure Storage** | `flutter_secure_storage` |
| **Routing** | `go_router` |
| **Charts** | `fl_chart` |

---

## 🧪 Verification & Quality Assurance

- **Unit & Widget Tests**: `flutter test` passing with 100% success rate across domain rules, ledger invariants, voice parser, wire transaction verification, and wallet repository.
- **Static Analysis**: `flutter analyze` reports **0 errors, 0 warnings, 0 issues**.
- **Android Target**: Configured for Android 11+ (`minSdk: 23`, `targetSdk: 34`, `applicationId: com.solepartner.app`).

---

## 📦 Building the Application

### Prerequisites
- Flutter SDK installed and on PATH
- Android SDK & Build Tools installed
- Java 11 or 17 JDK

### Setup & Run
```bash
# Clone the repository
git clone https://github.com/ABHISHEK-DBZ/solepartner.git
cd solepartner

# Fetch dependencies
flutter pub get

# Run test suite
flutter test

# Run code analyzer
flutter analyze

# Build Release APK
flutter build apk --release
```

Generated APKs will be located at `build/app/outputs/flutter-apk/app-release.apk`.

---

## 📄 License
Proprietary & Confidential. All rights reserved.
