import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';

final AutoDisposeFutureProviderFamily<LedgerEntry?, int> _entryProvider =
    FutureProvider.autoDispose.family<LedgerEntry?, int>((ref, int id) {
  return ref.watch(ledgerRepositoryProvider).findEntry(id);
});

class TransactionDetailScreen extends ConsumerWidget {
  const TransactionDetailScreen({super.key, required this.transactionId});

  final int transactionId;

  Future<void> _reverse(
    BuildContext context,
    WidgetRef ref,
    LedgerEntry entry,
  ) async {
    final bool confirmed = await confirmAction(
      context,
      title: 'Reverse this entry?',
      message: 'A compensating entry will be posted and the original marked '
          'reversed. Nothing is deleted.',
      confirmLabel: 'Reverse',
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await ref
          .read(ledgerRepositoryProvider)
          .reverseEntry(entry.id, reason: 'Reversed by owner');
      if (!context.mounted) return;
      ref.invalidate(_entryProvider(transactionId));
      showMessage(context, 'Reversal posted.');
    } catch (error) {
      if (context.mounted) showError(context, error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppThemeColors colors = context.appColors;
    final AsyncValue<LedgerEntry?> async = ref.watch(_entryProvider(transactionId));
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Entry details')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (Object error, StackTrace _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load this entry',
          message: error.toString(),
        ),
        data: (LedgerEntry? entry) {
          if (entry == null) {
            return const EmptyState(
              icon: Icons.search_off,
              title: 'Entry not found',
              message: 'It may have been removed.',
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: <Widget>[
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        StatusPill(
                          label: entry.kind.label.toUpperCase(),
                          color: colorForKind(entry.kind),
                          background: AppColors.chip,
                        ),
                        const Spacer(),
                        if (entry.isReversed)
                          const StatusPill(
                            label: 'REVERSED',
                            color: AppColors.danger,
                            background: AppColors.dangerSoft,
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      Money.format(entry.amountPaise, showPaise: true),
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      entry.note.isEmpty ? entry.kind.label : entry.note,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                child: Column(
                  children: <Widget>[
                    DetailRow(
                      label: 'When',
                      value: fullDateTime.format(entry.occurredAt),
                    ),
                    DetailRow(
                      label: 'Method',
                      value: paymentMethodLabel(entry.method),
                    ),
                    DetailRow(
                      label: 'Cash effect',
                      value: Money.format(entry.cashDeltaPaise, signed: true),
                      valueColor: entry.cashDeltaPaise >= 0
                          ? AppColors.emerald
                          : AppColors.danger,
                    ),
                    DetailRow(
                      label: 'Credit effect',
                      value: Money.format(entry.creditDeltaPaise, signed: true),
                      valueColor: entry.creditDeltaPaise == 0
                          ? AppColors.inkSoft
                          : AppColors.gold,
                    ),
                    if (entry.customerId != null)
                      DetailRow(
                        label: 'Customer',
                        value: entry.customerName ?? '#${entry.customerId}',
                        onTap: () => context.push('/khata/${entry.customerId}'),
                      ),
                    if (entry.supplierId != null)
                      DetailRow(
                        label: 'Supplier',
                        value: entry.supplierName ?? '#${entry.supplierId}',
                        onTap: () => context.push('/suppliers/${entry.supplierId}'),
                      ),
                    DetailRow(
                      label: 'Source',
                      value: entry.source.name.toUpperCase(),
                    ),
                    if (entry.reversalOfId != null)
                      DetailRow(
                        label: 'Reverses',
                        value: '#${entry.reversalOfId}',
                        onTap: () =>
                            context.push('/ledger/${entry.reversalOfId}'),
                      ),
                    if (entry.externalRef != null)
                      DetailRow(
                        label: 'Signature',
                        value: '${entry.externalRef!.substring(0, 10)}…',
                        onTap: () => launchUrl(
                          Uri.parse(
                            'https://explorer.solana.com/tx/${entry.externalRef}?cluster=devnet',
                          ),
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                  ],
                ),
              ),
              if (entry.lines.isNotEmpty) ...<Widget>[
                const SizedBox(height: 18),
                SectionHeader(title: 'Products'),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: entry.lines
                        .map((LedgerLine line) => ListTile(
                              title: Text(line.productName),
                              subtitle: Text(
                                '${qtyLabel(line.quantity)} × '
                                '${Money.format(line.unitPricePaise)}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              trailing: Text(
                                Money.format(line.totalPaise),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              if (!entry.isReversed && entry.reversalOfId == null)
                OutlinedButton.icon(
                  onPressed: () => _reverse(context, ref, entry),
                  icon: const Icon(Icons.undo_rounded, size: 18),
                  label: const Text('Reverse entry'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                'Reversals keep the original entry and post the opposite '
                'effects, so the audit trail stays complete.',
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
