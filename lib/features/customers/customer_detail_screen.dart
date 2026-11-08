import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../data/db/app_database.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';
import '../../domain/rules/reminder.dart';
import 'customer_credit_sheet.dart';
import 'customer_form_sheet.dart';

final AutoDisposeStreamProviderFamily<CustomerView?, int> _customerProvider =
    StreamProvider.autoDispose.family<CustomerView?, int>((ref, int id) {
  return ref.watch(customerRepositoryProvider).watchCustomer(id);
});

final AutoDisposeStreamProviderFamily<List<LedgerEntry>, int> _entriesProvider =
    StreamProvider.autoDispose.family<List<LedgerEntry>, int>((ref, int id) {
  return ref.watch(ledgerRepositoryProvider).watchCustomerEntries(id);
});

class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({super.key, required this.customerId});

  final int customerId;

  void _showReminder(
    BuildContext context,
    WidgetRef ref,
    CustomerView customer,
    String shopName,
    String language,
  ) {
    final String text = ReminderBuilder(language).build(
      customer: customer,
      shopName: shopName,
    );
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Reminder draft',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            const Text(
              'Review the message, then copy or share it yourself. '
              'KhataCopilot never messages customers automatically.',
              style: TextStyle(fontSize: 12.5, height: 1.4),
            ),
            const SizedBox(height: 14),
            AppCard(
              color: AppColors.chip,
              borderColor: AppColors.chip,
              child: SelectableText(
                text,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: text));
                      if (context.mounted) {
                        showMessage(context, 'Reminder copied.');
                      }
                    },
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: const Text('Copy'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => SharePlus.instance.share(
                      ShareParams(text: text),
                    ),
                    icon: const Icon(Icons.ios_share_rounded, size: 18),
                    label: const Text('Share'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppThemeColors colors = context.appColors;
    final AsyncValue<CustomerView?> customerAsync =
        ref.watch(_customerProvider(customerId));
    final AsyncValue<List<LedgerEntry>> entriesAsync =
        ref.watch(_entriesProvider(customerId));
    final MerchantProfile? merchant = ref.watch(merchantProfileProvider).valueOrNull;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Customer'),
        actions: <Widget>[
          if (customerAsync.valueOrNull != null)
            PopupMenuButton<String>(
              onSelected: (String value) async {
                final CustomerView customer = customerAsync.valueOrNull!;
                if (value == 'edit') {
                  await showCustomerForm(context, customer: customer);
                } else if (value == 'archive') {
                  await ref
                      .read(customerRepositoryProvider)
                      .archiveCustomer(customer.id, archived: !customer.archived);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Edit details'),
                ),
                PopupMenuItem<String>(
                  value: 'archive',
                  child: Text(
                    customerAsync.valueOrNull!.archived
                        ? 'Restore customer'
                        : 'Archive customer',
                  ),
                ),
              ],
            ),
        ],
      ),
      body: customerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (Object error, StackTrace _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load customer',
          message: error.toString(),
        ),
        data: (CustomerView? customer) {
          if (customer == null) {
            return const EmptyState(
              icon: Icons.search_off,
              title: 'Customer not found',
              message: 'It may have been archived.',
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
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: AppColors.goldSoft,
                          child: Text(
                            initials(customer.name),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                customer.name,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              if (customer.phone.isNotEmpty)
                                Text(
                                  customer.phone,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              if (customer.archived)
                                const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: StatusPill(
                                    label: 'ARCHIVED',
                                    color: AppColors.danger,
                                    background: AppColors.dangerSoft,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'OUTSTANDING',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Money.format(customer.outstandingPaise),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: customer.outstandingPaise > 0
                                ? AppColors.ink
                                : AppColors.emerald,
                          ),
                    ),
                    if (customer.overduePaise > 0) ...<Widget>[
                      const SizedBox(height: 6),
                      Text(
                        '${Money.format(customer.overduePaise)} older than 30 days',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.danger,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _Total(
                            label: 'Credit given',
                            value: customer.totalCreditGivenPaise,
                            color: AppColors.gold,
                          ),
                        ),
                        Container(
                          height: 26,
                          width: 1,
                          color: AppColors.line,
                          margin: const EdgeInsets.symmetric(horizontal: 14),
                        ),
                        Expanded(
                          child: _Total(
                            label: 'Repaid',
                            value: customer.totalRepaidPaise,
                            color: AppColors.emerald,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: FilledButton(
                      onPressed: () => showCustomerCreditSheet(
                        context,
                        customer: customer,
                        repayment: false,
                      ),
                      child: const Text('Give credit'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: customer.outstandingPaise <= 0
                          ? null
                          : () => showCustomerCreditSheet(
                                context,
                                customer: customer,
                                repayment: true,
                              ),
                      child: const Text('Repayment'),
                    ),
                  ),
                ],
              ),
              if (customer.outstandingPaise > 0) ...<Widget>[
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _showReminder(
                    context,
                    ref,
                    customer,
                    merchant?.shopName ?? 'our shop',
                    merchant?.languageCode ?? 'en',
                  ),
                  icon: const Icon(Icons.chat_bubble_outline, size: 17),
                  label: const Text('Prepare reminder'),
                ),
              ],
              const SizedBox(height: 20),
              SectionHeader(
                title: 'History',
                trailing: Text(
                  '${customer.transactionCount} entries',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              entriesAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                error: (Object error, StackTrace _) => Text(error.toString()),
                data: (List<LedgerEntry> entries) {
                  if (entries.isEmpty) {
                    return const AppCard(
                      child: Text('No entries for this customer yet.'),
                    );
                  }
                  return AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: entries
                          .take(40)
                          .map((LedgerEntry entry) => ListTile(
                                onTap: () =>
                                    context.push('/ledger/${entry.id}'),
                                leading: Icon(
                                  iconForKind(entry.kind),
                                  size: 18,
                                  color: colorForKind(entry.kind),
                                ),
                                title: Text(
                                  entry.note.isEmpty
                                      ? entry.kind.label
                                      : entry.note,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    decoration: entry.isReversed
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                subtitle: Text(
                                  friendlyDay(entry.occurredAt),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                trailing: Text(
                                  Money.format(
                                    entry.creditDeltaPaise != 0
                                        ? entry.creditDeltaPaise
                                        : entry.amountPaise,
                                    signed: entry.creditDeltaPaise != 0,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Total extends StatelessWidget {
  const _Total({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 3),
        Text(
          Money.format(value),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
