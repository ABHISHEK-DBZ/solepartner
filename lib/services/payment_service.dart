import '../data/repositories/payment_repository.dart';
import '../domain/enums.dart';
import '../domain/models.dart';
import '../domain/rules/policy_engine.dart';
import 'solana_service.dart';

class PaymentResult {
  const PaymentResult({
    required this.state,
    required this.paymentId,
    this.signature,
    this.explorerUrl,
    this.error,
    this.ledgerTransactionId,
  });

  final TxState state;
  final int paymentId;
  final String? signature;
  final String? explorerUrl;
  final String? error;
  final int? ledgerTransactionId;
}

/// Orchestrates a Devnet payment while keeping every decision deterministic.
///
/// The AI only ever produces a proposal. Policy evaluation, approval, wallet
/// signing, RPC submission and confirmation all happen here, and a payment is
/// labelled confirmed only after the cluster reports success.
class PaymentService {
  PaymentService(this._payments, this._solana);

  final PaymentRepository _payments;
  final SolanaService _solana;

  Future<int> dailySpentLamports() => _payments.dailySpentLamports();

  Future<PolicyEvaluation> evaluate({
    required int amountLamports,
    required String recipientAddress,
    required bool isSavedRecipient,
    int? walletBalanceLamports,
    String? ownAddress,
    String network = SolanaService.network,
  }) async {
    final SpendingPolicy policy = await _payments.loadPolicy();
    final int spent = await _payments.dailySpentLamports();
    return PolicyEngine.evaluate(
      policy: policy,
      amountLamports: amountLamports,
      recipientAddress: recipientAddress,
      isSavedRecipient: isSavedRecipient,
      dailySpentLamports: spent,
      network: network,
      walletBalanceLamports: walletBalanceLamports,
      ownAddress: ownAddress,
    );
  }

  /// Creates a proposal only when the deterministic policy allows it.
  Future<PaymentProposal> propose({
    required String recipientName,
    required String recipientAddress,
    required int amountLamports,
    required bool isSavedRecipient,
    int? payeeId,
    int? walletBalanceLamports,
    String? ownAddress,
    String requestText = '',
    int inrMemoPaise = 0,
  }) async {
    final PolicyEvaluation evaluation = await evaluate(
      amountLamports: amountLamports,
      recipientAddress: recipientAddress,
      isSavedRecipient: isSavedRecipient,
      walletBalanceLamports: walletBalanceLamports,
      ownAddress: ownAddress,
    );
    final int id = await _payments.createProposal(
      recipientName: recipientName,
      recipientAddress: recipientAddress,
      amountLamports: amountLamports,
      evaluation: evaluation,
      payeeId: payeeId,
      requestText: requestText,
      inrMemoPaise: inrMemoPaise,
    );
    final PaymentProposal? proposal = await _payments.findPayment(id);
    if (proposal == null) {
      throw PaymentException('Could not create the payment proposal.');
    }
    return proposal.copyWith(
      evaluation: evaluation,
      availableBalanceLamports: walletBalanceLamports,
      dailySpentLamports: await _payments.dailySpentLamports(),
    );
  }

  Future<PaymentProposal> reject(int id) async {
    await _payments.setStatus(id, PaymentStatus.rejected,
        errorMessage: 'Rejected by the owner.');
    final PaymentProposal? proposal = await _payments.findPayment(id);
    if (proposal == null) throw PaymentException('Payment not found.');
    return proposal;
  }

  /// Signs through the wallet, submits, and polls the RPC for confirmation.
  Future<PaymentResult> approveAndSend({
    required int paymentId,
    required String fromAddress,
  }) async {
    final PaymentProposal? proposal = await _payments.findPayment(paymentId);
    if (proposal == null) throw PaymentException('Payment not found.');
    if (proposal.status != PaymentStatus.awaitingApproval &&
        proposal.status != PaymentStatus.approved) {
      throw PaymentException(
        'This payment cannot be sent from status '
        '${proposal.status.label}.',
      );
    }

    // Re-check the policy with fresh balance and daily totals right before
    // signing, so a stale proposal can never exceed the limits.
    int? balance;
    try {
      balance = await _solana.getBalanceLamports(fromAddress);
    } on SolanaException {
      balance = null;
    }
    final SpendingPolicy policy = await _payments.loadPolicy();
    final int spent = await _payments.dailySpentLamports();
    final PolicyEvaluation check = PolicyEngine.evaluate(
      policy: policy,
      amountLamports: proposal.amountLamports,
      recipientAddress: proposal.recipientAddress,
      isSavedRecipient: proposal.payeeId != null,
      dailySpentLamports: spent,
      network: proposal.network,
      walletBalanceLamports: balance,
      ownAddress: fromAddress,
    );
    if (!check.allowed) {
      final String reason =
          check.violations.map((PolicyViolation v) => v.message).join(' ');
      await _payments.setStatus(paymentId, PaymentStatus.failed,
          errorMessage: reason);
      return PaymentResult(
        state: TxState.failed,
        paymentId: paymentId,
        error: reason,
      );
    }

    await _payments.setStatus(paymentId, PaymentStatus.approved);

    final PreparedTransfer prepared;
    try {
      prepared = await _solana.prepareTransfer(
        fromAddress: fromAddress,
        toAddress: proposal.recipientAddress,
        lamports: proposal.amountLamports,
      );
    } on SolanaException catch (error) {
      await _payments.setStatus(paymentId, PaymentStatus.failed,
          errorMessage: error.message);
      return PaymentResult(
        state: TxState.failed,
        paymentId: paymentId,
        error: error.message,
      );
    }

    final String signed;
    try {
      signed = await _solana.signTransaction(prepared.unsignedBase64);
    } on SolanaException catch (error) {
      if (error.isCancellation) {
        await _payments.setStatus(paymentId, PaymentStatus.rejected,
            errorMessage: error.message);
        return PaymentResult(
          state: TxState.failed,
          paymentId: paymentId,
          error: error.message,
        );
      }
      await _payments.setStatus(paymentId, PaymentStatus.failed,
          errorMessage: error.message);
      return PaymentResult(
        state: TxState.failed,
        paymentId: paymentId,
        error: error.message,
      );
    }

    // Pre-submission wire payload verification: ensure the wallet did not tamper
    // with destination or source addresses before broadcasting to the cluster.
    try {
      _solana.verifySignedWireTransaction(
        signedBase64: signed,
        fromAddress: fromAddress,
        toAddress: proposal.recipientAddress,
      );
    } on SolanaException catch (error) {
      await _payments.setStatus(paymentId, PaymentStatus.failed,
          errorMessage: 'Pre-submission validation failed: ${error.message}');
      return PaymentResult(
        state: TxState.failed,
        paymentId: paymentId,
        error: error.message,
      );
    }

    String signature;
    try {
      signature = await _solana.submitSignedTransaction(signed);
    } on SolanaException catch (error) {
      await _payments.setStatus(paymentId, PaymentStatus.failed,
          errorMessage: error.message);
      return PaymentResult(
        state: TxState.failed,
        paymentId: paymentId,
        error: error.message,
      );
    }

    if (await _payments.signatureAlreadyUsed(signature)) {
      await _payments.setStatus(paymentId, PaymentStatus.failed,
          errorMessage: 'This signature was already recorded. '
              'Duplicate submission prevented.');
      return PaymentResult(
        state: TxState.failed,
        paymentId: paymentId,
        error: 'Duplicate transaction signature.',
      );
    }

    await _payments.attachSignature(id: paymentId, signature: signature);
    final TxOutcome outcome = await _solana.pollConfirmation(signature);

    switch (outcome.state) {
      case TxState.confirmed:
        try {
          await _solana.verifyTransfer(
            signature: signature,
            fromAddress: fromAddress,
            toAddress: proposal.recipientAddress,
            lamports: proposal.amountLamports,
          );
        } on SolanaException catch (error) {
          await _payments.setStatus(paymentId, PaymentStatus.unknown,
              errorMessage: error.message);
          return PaymentResult(
            state: TxState.unknown,
            paymentId: paymentId,
            signature: signature,
            explorerUrl: _solana.explorerUrl(signature),
            error: error.message,
          );
        }
        final int ledgerId = await _payments.markConfirmed(
          id: paymentId,
          signature: signature,
          explorerUrl: _solana.explorerUrl(signature),
        );
        return PaymentResult(
          state: TxState.confirmed,
          paymentId: paymentId,
          signature: signature,
          explorerUrl: _solana.explorerUrl(signature),
          ledgerTransactionId: ledgerId,
        );
      case TxState.failed:
        await _payments.setStatus(paymentId, PaymentStatus.failed,
            errorMessage: outcome.error ?? 'The transaction failed on-chain.');
        return PaymentResult(
          state: TxState.failed,
          paymentId: paymentId,
          signature: signature,
          explorerUrl: _solana.explorerUrl(signature),
          error: outcome.error ?? 'The transaction failed on-chain.',
        );
      case TxState.unknown:
        await _payments.setStatus(paymentId, PaymentStatus.unknown,
            errorMessage: outcome.error ??
                'Confirmation could not be verified. Check the explorer '
                    'before retrying.');
        return PaymentResult(
          state: TxState.unknown,
          paymentId: paymentId,
          signature: signature,
          explorerUrl: _solana.explorerUrl(signature),
          error: outcome.error ??
              'Confirmation could not be verified. Check the explorer.',
        );
    }
  }
}
