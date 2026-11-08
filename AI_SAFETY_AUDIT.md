# AI Safety Audit — KhataCopilot

**Score: 4 / 10**
**Scope:** `lib/services/assistant_service.dart`, `cloud_ai_client.dart`,
`command_executor.dart`, `speech_service.dart`, `lib/domain/rules/voice_parser.dart`,
`phrases.dart`, `lib/domain/ai_config.dart`, `lib/features/settings/settings_screen.dart`

---

## 1. Design summary

The assistant is **hybrid and deterministic-first**:

1. `VoiceParser` parses the transcript locally.
2. If the local parser produces a recording intent, the app shows a confirmation and never
   calls the cloud.
3. Only unresolved queries or unparsed commands go to the optional cloud LLM.
4. The LLM returns JSON describing intent/amount/name. Recording intents always require a
   user confirmation tap before `CommandExecutor` writes.
5. Solana amount, policy and ledger math are never derived from the LLM.

This is the right architecture. The problems are coverage, identity resolution, privacy and
a couple of unsafe fallbacks.

---

## 2. Findings

### AI-01 — HIGH — Hindi/Devanagari offline coverage is zero
- **File:** `lib/domain/rules/voice_parser.dart`
- **Evidence:** Keyword and number lists are Latin-script English only. No Devanagari
  synonyms or Hindi number words. A `hi_IN` recognizer returns Devanagari, so local parsing
  fails and the request escalates to the cloud (or fails entirely offline).
- **Impact:** The product's Hindi promise is not met; offline mode is English-only.
- **Fix:** Add Devanagari/Hinglish synonyms and number words; add tests for
  "राहुल को 500 उधार दिया", "मैगी 2 बेचे".
- **Verify:** Airplane mode, Hindi locale, assert correct intent.

### AI-02 — HIGH — Cloud endpoint can be HTTP; PII sent without explicit consent
- **Files:** `lib/domain/ai_config.dart:24-33`, `cloud_ai_client.dart:36-45`,
  `assistant_service.dart:270-290`
- **Evidence:** `chatUri` accepts any scheme. The cloud payload includes the raw `command`
  text, which commonly contains customer names and amounts, plus aggregate counts.
- **Impact:** API key and customer data can be transmitted in cleartext to an arbitrary
  endpoint; users are not clearly told what leaves the device.
- **Fix:** Require `https`; add a consent screen listing the exact fields sent; offer
  redaction; never send names when a local match is possible.
- **Verify:** Reject `http://`; confirm consent is required before the first cloud call.

### AI-03 — MEDIUM — Cloud identity loss causes wrong accounting
- **File:** `lib/services/assistant_service.dart:316-350`
- **Evidence:** `_fromCloudJson` sets `customerName` but not `customerId`. `CommandExecutor`
  needs `customerId` for `creditGiven`/`creditRepayment`; otherwise it may record a cash
  sale/income.
- **Impact:** "Rahul paid 500" can be booked as income instead of reducing Rahul's udhaar.
- **Fix:** Resolve `customerName` against the customer list after parsing; if ambiguous,
  ask; if unresolved, block the write.
- **Verify:** Force the cloud path; assert a repayment, not income.

### AI-04 — MEDIUM — Local name matching requires the full stored name
- **File:** `lib/domain/rules/voice_parser.dart` (`_matchName`)
- **Evidence:** Exact/full-name matching only; "Rahul" does not match "Rahul Sharma".
- **Impact:** Common short-name commands fail and escalate to cloud.
- **Fix:** Token/prefix/fuzzy matching with ambiguity prompts.
- **Verify:** Customer "Rahul Sharma", say "Rahul paid 200", assert match or disambiguation.

### AI-05 — MEDIUM — Amount parser grabs the first number anywhere
- **File:** `lib/core/money.dart` (`tryParsePaise`)
- **Evidence:** Parses the first numeric token; quantity stripping is applied only for sales.
- **Impact:** "2 kg sugar 100" parses ₹2 for an expense; prices/quantities can be swapped.
- **Fix:** Parse with intent context (quantity vs amount), prefer the last/largest money-like
  token, and require confirmation when ambiguous.
- **Verify:** Unit-test quantity+amount phrases for sale and expense.

### AI-06 — MEDIUM — Cloud intent is trusted too broadly
- **File:** `lib/services/assistant_service.dart:39,299-372`
- **Evidence:** `_fromCloudJson` maps any returned intent and builds a command. Recording
  intents still require confirmation, and `paySolana` only returns a reply (no payment is
  prepared), which limits damage. But an injected/compromised endpoint can propose arbitrary
  customers/amounts.
- **Impact:** Social-engineering risk: a user may confirm a wrong payment proposal.
- **Fix:** Validate intent against an allow-list, clamp amounts, re-resolve names locally,
  and show the deterministic parser's interpretation alongside the cloud's.
- **Verify:** Feed a malicious JSON response in a test; assert rejection/clamping.

### AI-07 — LOW — Speech errors are not surfaced; availability is cached false
- **File:** `lib/services/speech_service.dart:33-74`
- **Evidence:** No `onError` handler; a recognition error waits for the 30s timeout. Once
  `isAvailable` returns false it stays false for the session.
- **Impact:** Silent 30-second hangs; a transient failure disables voice until restart.
- **Fix:** Handle `onError`, complete with a typed failure, and allow re-checking availability.

### AI-08 — LOW — No cloud response size limit / `max_tokens`
- **File:** `lib/services/cloud_ai_client.dart`
- **Evidence:** Request sets `temperature` only; no `max_tokens`; body is decoded unbounded.
- **Impact:** Cost and memory risk from a hostile/misconfigured endpoint.
- **Fix:** Set `max_tokens` and cap the body before decoding.

### AI-09 — INFO — Deterministic parser is the security boundary
- **Evidence:** `LedgerRules`, `PolicyEngine` and `PaymentService` never consume LLM output
  for amounts or destinations.
- **Impact:** Positive: prompt injection cannot directly move money without a user tap and a
  deterministic proposal. Preserve this invariant.

---

## 3. AI safety score rationale

- + Local-first, deterministic money path, confirmation required, `paySolana` not executed
  from cloud output.
- − Hindi gap, HTTP endpoint, no PII consent, identity loss, brittle name/amount parsing,
  silent speech failures.
