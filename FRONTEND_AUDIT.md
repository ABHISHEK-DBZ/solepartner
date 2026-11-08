# Frontend Audit — KhataCopilot

**Score: 6 / 10**
**Scope:** `lib/app`, `lib/core`, `lib/features`, `lib/domain/models.dart`
**Snapshot:** 2026-11-08 17:24, `flutter analyze` clean, `flutter test` 3/3.

The UI is broad and visually consistent (custom `AppCard`, `StatusPill`, theme tokens,
light/dark mode). The problems are functional integrity and a few dead/misleading flows,
not visual quality.

---

## Findings

### FE-01 — HIGH — Voice payment intent is silently discarded
- **Files:** `lib/features/assistant/voice_sheet.dart:161-165`,
  `lib/features/payments/pay_screen.dart:20-30`
- **Evidence:** `_reviewPayment` calls `router.push('/pay/new', extra: command)`. `PayScreen`
  is a `ConsumerStatefulWidget` whose state hard-codes `_recipientName`, `_recipientAddress`,
  `_amountPaise` and `_amountLamports`; it never reads `GoRouterState.extra`.
- **Impact:** A merchant says "pay Singh Distributors 5000", taps Review, and lands on a
  pre-filled demo payment (0.01 SOL to a placeholder address) instead of their command.
  Worse, the screen presents it as if it came from the command.
- **Fix:** Read `GoRouterState.of(context).extra as ParsedCommand?` in `PayScreen.initState`
  and seed the fields; or pass the command through a provider. If the command has no
  resolvable payee, show an explicit error instead of demo data.
- **Verify:** Parse a payment command, tap Review, confirm recipient/amount match the
  transcript.

### FE-02 — HIGH — Hindi / Devanagari is not supported end to end
- **Files:** `lib/domain/rules/voice_parser.dart` (word lists), `lib/app/app.dart:31`
- **Evidence:** All parser keywords are Latin script (`paid`, `udhaar`, `sold`, ...). A
  `hi_IN` speech recognizer returns Devanagari, which matches nothing and falls through to
  the cloud path. `MaterialApp.router` has no `localizationsDelegates`, `supportedLocales`
  or `locale`.
- **Impact:** The onboarding language toggle implies Hindi support, but offline Hindi
  commands fail and Material widgets remain English.
- **Fix:** Add Devanagari synonyms and number words; add
  `flutter_localizations`, `supportedLocales: [Locale('en'), Locale('hi')]` and
  `localizationsDelegates`. Persist the selected locale and pass it to `speech_to_text`.
- **Verify:** Airplane mode, Hindi locale, say "Rahul ko 500 udhaar diya", confirm parse.

### FE-03 — HIGH — "AI Business Insights" is fabricated
- **File:** `lib/features/insights/insights_screen.dart`
- **Evidence:** Fixed strings `₹13,24,680`, `+18.2%`, hard-coded bar heights
  (`_BarColumn(heightRatio: ...)`), fixed "Key Insights" bullets. The tab chips only change
  their own colour; `_activeTab` never affects the data. The export button shows
  `"Report exported to Device Storage / PDF"` but performs no file write or share.
- **Impact:** A financial product presenting invented revenue and profit figures can cause
  real business decisions. The fake export message is a broken promise.
- **Fix:** Either wire the screen to `dashboardSummaryProvider` / ledger aggregates and
  implement a real PDF/CSV share, or remove the route and the "AI Insights" tile until it
  is real. Never show a success toast for work not performed.
- **Verify:** Compare displayed totals to `LedgerRules.summarise`; tap export and confirm a
  real file/share sheet appears.

### FE-04 — HIGH — No export, backup, restore or clear-all-data
- **Files:** `lib/features/settings/settings_screen.dart`, `lib/features/more/more_screen.dart`
- **Evidence:** No code path writes a backup, exports CSV/PDF, restores, or clears the DB.
  `share_plus` is used only for a customer reminder text.
- **Impact:** Uninstalling the app or losing the device destroys the merchant's books.
  There is also no way to migrate to a new phone.
- **Fix:** Add "Export ledger (CSV/JSON)" via `share_plus`, and a destructive
  "Erase all data" behind a confirmation + typed phrase. Consider scheduled local backup.
- **Verify:** Export, reinstall, import/restore, confirm counts and balances match.

### FE-05 — MEDIUM — Credit repayment is not capped at outstanding
- **File:** `lib/features/ledger/add_transaction_sheet.dart`
- **Evidence:** The customer picker shows `outstandingPaise` but the amount field has no
  clamp; `creditRepayment` posts `creditDelta: -amount`, so a repayment larger than the due
  drives `outstandingPaise` negative (an unexplained advance).
- **Contrast:** `lib/features/customers/customer_credit_sheet.dart` does cap the repayment.
- **Fix:** Validate `amount <= customer.outstandingPaise` (or explicitly support advances
  with a separate field/flag).
- **Verify:** Customer owes 500, enter 900, confirm validation blocks or records an advance
  intentionally.

### FE-06 — MEDIUM — Customer history is silently truncated
- **File:** `lib/features/customers/customer_detail_screen.dart`
- **Evidence:** `entries.take(40)` with no "load more" and no total-count disclaimer.
- **Impact:** A merchant cannot see older entries, which looks like missing data.
- **Fix:** Paginate or add a "View all" link to the filtered ledger.
- **Verify:** Create 50 entries, confirm the 41st is reachable.

### FE-07 — MEDIUM — Archive/delete actions lack confirmation
- **Files:** `customer_detail_screen.dart`, `suppliers_screen.dart`, `product_detail_screen.dart`
- **Evidence:** Archive toggles run directly on tap. There is no restore UI for archived
  suppliers, and no confirmation dialog.
- **Impact:** Accidental archival hides records and, for suppliers, cannot be undone in the UI.
- **Fix:** Confirm before archive; add an "Archived" filter with Restore for every entity.

### FE-08 — MEDIUM — Product form silently resets custom units
- **File:** `lib/features/inventory/product_form_sheet.dart:46,66,207-215`
- **Evidence:** `_unit = _units.contains(product.unit) ? product.unit : 'pc'`. A product saved
  with a unit outside the fixed list is silently rewritten to `pc` on edit.
- **Impact:** Data corruption on edit (e.g. "dozen", "kg" variants).
- **Fix:** Add the existing unit to the dropdown options when it is not in the list.
- **Verify:** Save unit "dozen" via direct DB/older data, open edit, confirm it is preserved.

### FE-09 — MEDIUM — No phone validation or duplicate detection
- **File:** `lib/features/customers/customer_form_sheet.dart:50-69`
- **Evidence:** Only `name.isEmpty` is validated; phone is free text.
- **Impact:** Duplicate customers split the ledger and distort udhaar totals.
- **Fix:** Normalise phone, warn on an existing match, and allow merge/link.

### FE-10 — MEDIUM — Barcode field is decorative
- **Files:** `lib/features/inventory/product_form_sheet.dart`,
  `lib/data/repositories/inventory_repository.dart:158`
- **Evidence:** A barcode text field exists, `findByBarcode` exists, but no scanner UI calls
  it and no screen searches by barcode.
- **Impact:** Advertised inventory speed-up is absent.
- **Fix:** Add a scan action (mobile_scanner or keyboard wedge) that calls `findByBarcode`,
  or remove the field.

### FE-11 — LOW — Search and IN/OUT include reversal entries
- **File:** `lib/features/ledger/ledger_screen.dart`
- **Evidence:** Search matches the paise string; the IN/OUT chip includes compensating
  entries, so a reversed sale still appears in "IN" as a reversal row.
- **Fix:** Filter out `reversalOfId != null` from directional totals or label them clearly.

### FE-12 — LOW — Voice examples fail when demo customers are absent
- **File:** `lib/features/assistant/voice_sheet.dart`
- **Evidence:** Example chips reference names that only exist in seed data; a fresh user
  gets "customer not found".
- **Fix:** Generate examples from the user's real customer/product names.

### FE-13 — LOW — Router has no error builder
- **File:** `lib/app/router.dart`
- **Evidence:** Invalid paths show GoRouter's default error screen. Detail screens with a
  missing ID render a bare "not found".
- **Fix:** Add `errorBuilder` and a friendly not-found state.

### FE-14 — LOW — Theme load flash / double animation
- **Files:** `lib/app/theme_controller.dart`, `lib/app/theme.dart`
- **Evidence:** `SharedPreferences` is read asynchronously, so the first frame may use the
  default theme; `AnimatedThemeTransition` wraps the app while `MaterialApp` already
  animates theme changes.
- **Fix:** Preload the theme before `runApp` or gate the first frame.

---

## Screen inventory reviewed

Dashboard, Ledger, Add Transaction, Transaction Detail, Customers, Customer Detail, Udhaar,
Customer Credit, Inventory, Product Detail, Inventory Analytics, Product Form, Suppliers,
Supplier Detail, Purchase Form, Payments, Pay, Payment Detail, Wallet, Policy, Assistant,
Voice Sheet, Settings, Audit, More, Insights, Onboarding, Home Shell.

## Frontend score rationale

- + Consistent design system, dark mode, haptics, empty states in most lists.
- + Deterministic confirmation before writes.
- − One high-impact broken flow (voice→pay), one fabricated analytics screen, missing
  backup/export, Hindi gap, and several silent data mutations.
