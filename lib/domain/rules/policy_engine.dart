import '../models.dart';

/// Deterministic spending policy evaluation.
///
/// This never consults the LLM. It runs on every payment proposal, before
/// approval and again before signing, using values read from the local policy
/// row and the Solana RPC.
class PolicyEngine {
  PolicyEngine._();

  /// Reserved for the network fee so a payment cannot drain the last lamports.
  static const int feeBufferLamports = 5000;

  static const String devnet = 'devnet';

  static final RegExp _base58 = RegExp(r'^[1-9A-HJ-NP-Za-km-z]{32,44}$');

  static PolicyEvaluation evaluate({
    required SpendingPolicy policy,
    required int amountLamports,
    required String recipientAddress,
    required bool isSavedRecipient,
    required int dailySpentLamports,
    required String network,
    int? walletBalanceLamports,
    String? ownAddress,
  }) {
    final List<PolicyViolation> violations = <PolicyViolation>[];
    final List<String> passed = <String>[];

    if (amountLamports <= 0) {
      violations.add(const PolicyViolation(
        'invalid_amount',
        'Amount must be greater than zero.',
      ));
    } else {
      passed.add('Amount is positive');
    }

    if (!_base58.hasMatch(recipientAddress)) {
      violations.add(const PolicyViolation(
        'invalid_recipient',
        'Recipient address is not a valid Solana address.',
      ));
    } else {
      passed.add('Recipient address is valid');
    }

    if (ownAddress != null && recipientAddress == ownAddress) {
      violations.add(const PolicyViolation(
        'self_transfer',
        'Recipient is your own wallet address.',
      ));
    }

    if (policy.devnetOnly && network != devnet) {
      violations.add(const PolicyViolation(
        'wrong_network',
        'This build only allows Devnet payments.',
      ));
    } else {
      passed.add('Network is allowed');
    }

    if (policy.savedRecipientsOnly && !isSavedRecipient) {
      violations.add(const PolicyViolation(
        'unsaved_recipient',
        'Policy allows saved recipients only. Save this recipient first.',
      ));
    } else {
      passed.add('Recipient is permitted');
    }

    if (amountLamports > policy.maxPerPaymentLamports) {
      violations.add(PolicyViolation(
        'per_payment_limit',
        'Amount exceeds the per-payment limit. '
            '${_solLabel(policy.maxPerPaymentLamports)} max.',
      ));
    } else {
      passed.add('Within per-payment limit');
    }

    final int projectedDaily = dailySpentLamports + amountLamports;
    if (projectedDaily > policy.dailyLimitLamports) {
      violations.add(PolicyViolation(
        'daily_limit',
        'Daily spending limit would be exceeded. '
            '${_solLabel(policy.dailyLimitLamports)} per day.',
      ));
    } else {
      passed.add('Within daily limit');
    }

    final int remaining =
        policy.dailyLimitLamports - dailySpentLamports;
    if (walletBalanceLamports != null) {
      if (amountLamports + feeBufferLamports > walletBalanceLamports) {
        violations.add(const PolicyViolation(
          'insufficient_balance',
          'Wallet balance is too low for this amount plus network fee.',
        ));
      } else {
        passed.add('Wallet balance is sufficient');
      }
    }

    return PolicyEvaluation(
      allowed: violations.isEmpty,
      violations: violations,
      passedChecks: passed,
      requiresApproval: policy.requireApproval,
      remainingDailyLamports: remaining < 0 ? 0 : remaining,
    );
  }

  static String _solLabel(int lamports) {
    final String value = (lamports / 1000000000).toStringAsFixed(4);
    final String trimmed = value
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
    return '$trimmed SOL';
  }
}
