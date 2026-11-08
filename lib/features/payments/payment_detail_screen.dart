import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../data/repositories/payment_repository.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';
import '../../services/payment_service.dart';
import '../../services/solana_service.dart';
import 'payments_screen.dart';

final AutoDisposeStreamProviderFamily<PaymentProposal?, int> _paymentProvider =
    StreamProvider.autoDispose.family<PaymentProposal?, int>((ref, int id) {
  return ref.watch(paymentRepositoryProvider).watchPayment(id);
});

final AutoDisposeFutureProviderFamily<PolicyEvaluation?, int> _checkProvider =
    FutureProvider.autoDispose.family<PolicyEvaluation?, int>((ref, int id) {
  final PaymentProposal? proposal =
      ref.watch(_paymentProvider(id)).valueOrNull;
  final WalletSnapshot wallet = ref.watch(walletProvider);
  if (proposal == null) return Future<PolicyEvaluation?>.value();
  return ref.read(paymentServiceProvider).evaluate(
        amountLamports: proposal.amountLamports,
        recipientAddress: proposal.recipientAddress,
        isSavedRecipient: proposal.payeeId != null,
        walletBalanceLamports: wallet.balanceLamports,
        ownAddress: wallet.address,
      );
});

class PaymentDetailScreen extends ConsumerStatefulWidget {
  const PaymentDetailScreen({super.key, required this.paymentId});

  final int paymentId;

  @override
  ConsumerState<PaymentDetailScreen> createState() =>
      _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends ConsumerState<PaymentDetailScreen> {
  bool _sending = false;

  Future<void> _approveAndSend() async {
    final WalletSnapshot wallet = ref.read(walletProvider);
    if (!wallet.connected || wallet.address == null) {
      showError(context, 'Connect your wallet first.');
      return;
    }
    final bool confirmed = await confirmAction(
      context,
      title: 'Approve and pay?',
      message:
          'Your wallet will open to sign this Devnet transfer. Nothing is '
          'sent until you approve inside the wallet.',
      confirmLabel: 'Open wallet',
    );
    if (!confirmed) return;
    setState(() => _sending = true);
    try {
      final PaymentResult result =
          await ref.read(paymentServiceProvider).approveAndSend(
                paymentId: widget.paymentId,
                fromAddress: wallet.address!,
              );
      await ref.read(walletProvider.notifier).refresh();
      if (!mounted) return;
      switch (result.state) {
        case TxState.confirmed:
          showMessage(context, 'Payment confirmed on Devnet.');
        case TxState.failed:
          showError(context, result.error ?? 'Payment failed.');
        case TxState.unknown:
          showMessage(
            context,
            'Submitted, but confirmation could not be verified. '
            'Check the explorer.',
          );
      }
    } on PaymentException catch (error) {
      if (mounted) showError(context, error);
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _reject() async {
    final bool confirmed = await confirmAction(
      context,
      title: 'Reject this payment?',
      message: 'The proposal stays in history marked as rejected. '
          'No transaction is sent.',
      confirmLabel: 'Reject',
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await ref.read(paymentServiceProvider).reject(widget.paymentId);
      if (mounted) showMessage(context, 'Payment rejected.');
    } catch (error) {
      if (mounted) showError(context, error);
    }
  }

  Future<void> _verifyAgain() async {
    final PaymentProposal? proposal =
        ref.read(_paymentProvider(widget.paymentId)).valueOrNull;
    final String? signature = proposal?.signature;
    if (signature == null) return;
    setState(() => _sending = true);
    try {
      final TxOutcome outcome = await ref
          .read(solanaServiceProvider)
          .pollConfirmation(signature, timeout: const Duration(seconds: 20));
      if (!mounted) return;
      if (outcome.state == TxState.confirmed) {
        final int ledgerId =
            await ref.read(paymentRepositoryProvider).markConfirmed(
                  id: widget.paymentId,
                  signature: signature,
                  explorerUrl:
                      ref.read(solanaServiceProvider).explorerUrl(signature),
                );
        if (mounted) {
          showMessage(context,
              'Confirmed. Linked to ledger entry #$ledgerId.');
        }
      } else {
        showMessage(context, outcome.error ?? 'Still not confirmed.');
      }
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final AsyncValue<PaymentProposal?> async =
        ref.watch(_paymentProvider(widget.paymentId));

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Payment')),
      body: async.when(
        loading: () => const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (Object error, StackTrace _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load payment',
          message: error.toString(),
        ),
        data: (PaymentProposal? payment) {
          if (payment == null) {
            return const EmptyState(
              icon: Icons.bolt,
              title: 'Payment not found',
              message: 'It may have been removed.',
            );
          }
          final PolicyEvaluation? check =
              ref.watch(_checkProvider(widget.paymentId)).valueOrNull;
          final bool canSend = payment.status == PaymentStatus.awaitingApproval ||
              payment.status == PaymentStatus.approved;
          final bool canVerify = payment.status == PaymentStatus.unknown ||
              payment.status == PaymentStatus.submitted;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: <Widget>[
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            payment.recipientName.isEmpty
                                ? 'Unsaved recipient'
                                : payment.recipientName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        StatusPill(
                          label: payment.status.label,
                          color: PaymentsScreen.statusColor(payment.status),
                          background:
                              PaymentsScreen.statusBackground(payment.status),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '${Money.formatSol(payment.amountLamports)} SOL',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shortAddress(payment.recipientAddress),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 14),
                    DetailRow(label: 'Network', value: 'Solana Devnet'),
                    DetailRow(
                      label: 'Recipient address',
                      value: shortAddress(payment.recipientAddress),
                      onTap: () async {
                        await Clipboard.setData(
                            ClipboardData(text: payment.recipientAddress));
                        if (context.mounted) {
                          showMessage(context, 'Address copied.');
                        }
                      },
                    ),
                    if (payment.requestText.isNotEmpty)
                      DetailRow(label: 'Note', value: payment.requestText),
                    DetailRow(
                      label: 'Created',
                      value: friendlyDay(payment.createdAt),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(Icons.shield_outlined, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Policy check',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (check == null)
                      Text(
                        'Checking limits…',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    else ...<Widget>[
                      if (check.allowed)
                        Row(
                          children: <Widget>[
                            const Icon(Icons.check_circle,
                                size: 16, color: AppColors.positive),
                            const SizedBox(width: 6),
                            const Text(
                              'All checks passed',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.positive,
                              ),
                            ),
                          ],
                        ),
                      ...check.violations.map((PolicyViolation v) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Icon(Icons.block,
                                    size: 15, color: AppColors.danger),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    v.message,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 6),
                      ...check.passedChecks.map((String passed) => Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Row(
                              children: <Widget>[
                                const Icon(Icons.check,
                                    size: 13, color: AppColors.positive),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    passed,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 6),
                      Text(
                        'Remaining today: '
                        '${Money.formatSolWithUnit(check.remainingDailyLamports)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              if (payment.errorMessage != null &&
                  payment.errorMessage!.isNotEmpty) ...<Widget>[
                const SizedBox(height: 12),
                AppCard(
                  color: AppColors.dangerSoft,
                  borderColor: AppColors.dangerSoft,
                  child: Text(
                    payment.errorMessage!,
                    style: const TextStyle(
                      color: AppColors.danger,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],
              if (payment.signature != null) ...<Widget>[
                const SizedBox(height: 12),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Transaction signature',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              payment.signature!,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: payment.signature!));
                              if (context.mounted) {
                                showMessage(context, 'Signature copied.');
                              }
                            },
                            icon: const Icon(Icons.copy, size: 16),
                          ),
                        ],
                      ),
                      if (payment.explorerUrl != null)
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                          ),
                          onPressed: () => launchUrl(
                            Uri.parse(payment.explorerUrl!),
                            mode: LaunchMode.externalApplication,
                          ),
                          icon: const Icon(Icons.open_in_new, size: 14),
                          label: const Text('View on Solana Explorer'),
                        ),
                    ],
                  ),
                ),
              ],
              if (payment.status == PaymentStatus.confirmed &&
                  payment.ledgerTransactionId != null) ...<Widget>[
                const SizedBox(height: 12),
                AppCard(
                  onTap: () =>
                      context.push('/ledger/${payment.ledgerTransactionId}'),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.receipt_long_outlined, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Linked ledger entry '
                          '#${payment.ledgerTransactionId}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right,
                          color: AppColors.inkFaint),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 18),
              if (canSend) ...<Widget>[
                FilledButton(
                  onPressed: _sending ? null : _approveAndSend,
                  child: _sending
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Approve & sign in wallet'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: _sending ? null : _reject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.dangerSoft),
                  ),
                  child: const Text('Reject payment'),
                ),
              ],
              if (canVerify) ...<Widget>[
                FilledButton(
                  onPressed: _sending ? null : _verifyAgain,
                  child: const Text('Verify on Devnet'),
                ),
              ],
              const SizedBox(height: 10),
              Text(
                'Payments only show as confirmed after the Solana RPC '
                'reports the transaction as confirmed. If verification fails, '
                'the payment is marked unknown — never confirmed.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }
}
