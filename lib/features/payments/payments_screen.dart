import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';

class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  static Color statusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.confirmed:
        return AppColors.positive;
      case PaymentStatus.failed:
      case PaymentStatus.rejected:
        return AppColors.danger;
      case PaymentStatus.unknown:
        return AppColors.warning;
      case PaymentStatus.draft:
      case PaymentStatus.awaitingApproval:
      case PaymentStatus.approved:
      case PaymentStatus.submitted:
        return AppColors.inkSoft;
    }
  }

  static Color statusBackground(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.confirmed:
        return AppColors.positiveSoft;
      case PaymentStatus.failed:
      case PaymentStatus.rejected:
        return AppColors.dangerSoft;
      case PaymentStatus.unknown:
        return AppColors.warningSoft;
      case PaymentStatus.draft:
      case PaymentStatus.awaitingApproval:
      case PaymentStatus.approved:
      case PaymentStatus.submitted:
        return AppColors.chip;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppThemeColors colors = context.appColors;
    final AsyncValue<List<PaymentProposal>> async =
        ref.watch(allPaymentsProvider);
    final WalletSnapshot wallet = ref.watch(walletProvider);
    final List<PaymentProposal> payments =
        async.valueOrNull ?? <PaymentProposal>[];
    final int confirmed = payments
        .where((PaymentProposal p) => p.status == PaymentStatus.confirmed)
        .fold(0, (int sum, PaymentProposal p) => sum + p.amountLamports);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Payments'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Wallet',
            onPressed: () => context.push('/wallet'),
            icon: const Icon(Icons.account_balance_wallet_outlined),
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/pay/new'),
        backgroundColor: AppColors.ink,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.bolt, size: 20),
        label: const Text('Pay'),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          children: <Widget>[
            AppCard(
              color: AppColors.ink,
              onTap: () => context.push('/wallet'),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.account_balance_wallet_outlined,
                      color: Colors.white70, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          wallet.connected
                              ? Money.formatSolWithUnit(
                                  wallet.balanceLamports ?? 0)
                              : 'Wallet not connected',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          wallet.connected
                              ? 'Devnet · ${shortAddress(wallet.address ?? '')}'
                              : 'Tap to connect and pay',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'DEVNET',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: StatTile(
                    label: 'Confirmed sent',
                    value: Money.formatSol(confirmed),
                    icon: Icons.check_circle_outline,
                    tone: StatTone.positive,
                    caption: '${payments.length} proposals',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatTile(
                    label: 'Daily policy',
                    value: ref
                        .watch(spendingPolicyProvider)
                        .maybeWhen(
                          data: (SpendingPolicy p) =>
                              Money.formatSol(p.dailyLimitLamports),
                          orElse: () => '—',
                        ),
                    icon: Icons.shield_outlined,
                    onTap: () => context.push('/policy'),
                    caption: 'Tap to adjust limits',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Payment history'),
            if (async.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2)),
              )
            else if (payments.isEmpty)
              const EmptyState(
                icon: Icons.bolt,
                title: 'No payments yet',
                message: 'Payments you propose will appear here with their '
                    'verification status.',
              )
            else
              ...payments.map((PaymentProposal payment) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AppCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      onTap: () => context.push('/payments/${payment.id}'),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  payment.recipientName.isEmpty
                                      ? shortAddress(
                                          payment.recipientAddress)
                                      : payment.recipientName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${friendlyDay(payment.createdAt)} · '
                                  '${payment.status.label}',
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '${Money.formatSol(payment.amountLamports)} SOL',
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 3),
                              StatusPill(
                                label: payment.status.label,
                                color: statusColor(payment.status),
                                background: statusBackground(payment.status),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
