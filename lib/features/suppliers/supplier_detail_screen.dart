import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/supplier_repository.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';

final AutoDisposeStreamProviderFamily<SupplierView?, int> _supplierProvider =
    StreamProvider.autoDispose.family<SupplierView?, int>((ref, int id) {
  return ref.watch(supplierRepositoryProvider).watchSupplier(id);
});

final AutoDisposeStreamProviderFamily<List<Purchase>, int> _purchasesProvider =
    StreamProvider.autoDispose.family<List<Purchase>, int>((ref, int id) {
  return ref.watch(supplierRepositoryProvider).watchPurchases(supplierId: id);
});

class SupplierDetailScreen extends ConsumerWidget {
  const SupplierDetailScreen({super.key, required this.supplierId});

  final int supplierId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppThemeColors colors = context.appColors;
    final AsyncValue<SupplierView?> async =
        ref.watch(_supplierProvider(supplierId));

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(async.valueOrNull?.name ?? 'Supplier'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Archived suppliers stay in purchase history',
            onPressed: () async {
              final bool confirmed = await confirmAction(
                context,
                title: 'Archive supplier?',
                message:
                    'Purchase history stays intact. You can still record '
                    'payments against past purchases.',
                confirmLabel: 'Archive',
                destructive: true,
              );
              if (confirmed) {
                await ref
                    .read(supplierRepositoryProvider)
                    .archiveSupplier(supplierId);
                if (context.mounted) Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.archive_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/suppliers/$supplierId/purchase'),
        backgroundColor: AppColors.ink,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_shopping_cart, size: 20),
        label: const Text('New purchase'),
      ),
      body: async.when(
        loading: () => const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (Object error, StackTrace _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load supplier',
          message: error.toString(),
        ),
        data: (SupplierView? supplier) {
          if (supplier == null) {
            return const EmptyState(
              icon: Icons.local_shipping_outlined,
              title: 'Supplier not found',
              message: 'It may have been archived.',
            );
          }
          final List<Purchase> purchases =
              ref.watch(_purchasesProvider(supplierId)).valueOrNull ??
                  <Purchase>[];
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            children: <Widget>[
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      supplier.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (supplier.phone.isNotEmpty ||
                        supplier.address.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        <String>[
                          if (supplier.phone.isNotEmpty) supplier.phone,
                          if (supplier.address.isNotEmpty) supplier.address,
                        ].join(' · '),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Payable',
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                              const SizedBox(height: 4),
                              Text(
                                Money.format(supplier.payablePaise),
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  color: supplier.payablePaise > 0
                                      ? AppColors.danger
                                      : AppColors.positive,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Paid till date',
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                              const SizedBox(height: 4),
                              Text(
                                Money.format(supplier.paidPaise),
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (supplier.payablePaise > 0) ...<Widget>[
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed: () => _recordPayment(
                    context,
                    ref,
                    payablePaise: supplier.payablePaise,
                  ),
                  icon: const Icon(Icons.payments_outlined, size: 18),
                  label: Text('Pay ${Money.format(supplier.payablePaise)}'),
                ),
              ],
              if (supplier.notes.isNotEmpty) ...<Widget>[
                const SizedBox(height: 12),
                AppCard(
                  color: AppColors.chip,
                  child: Text(
                    supplier.notes,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
              const SizedBox(height: 22),
              SectionHeader(
                title: 'Purchase history',
                trailing: Text(
                  '${purchases.length} bills',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              if (purchases.isEmpty)
                const EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: 'No purchases yet',
                  message: 'Receive a purchase to add stock and record '
                      'the payable.',
                )
              else
                ...purchases.map((Purchase purchase) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _PurchaseCard(
                        purchase: purchase,
                        supplierName: supplier.name,
                      ),
                    )),
            ],
          );
        },
      ),
    );
  }

  Future<void> _recordPayment(
    BuildContext context,
    WidgetRef ref, {
    required int payablePaise,
  }) async {
    final TextEditingController amount = TextEditingController(
      text: Money.rupeeFieldValue(payablePaise),
    );
    PaymentMethod method = PaymentMethod.cash;
    final bool? submit = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Record supplier payment'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AmountField(controller: amount, label: 'Amount ₹'),
                const SizedBox(height: 12),
                LabeledField(
                  label: 'Paid via',
                  child: DropdownButtonFormField<PaymentMethod>(
                    initialValue: method,
                    items: const <PaymentMethod>[
                      PaymentMethod.cash,
                      PaymentMethod.upi,
                      PaymentMethod.bank,
                    ]
                        .map((PaymentMethod m) => DropdownMenuItem<PaymentMethod>(
                              value: m,
                              child: Text(paymentMethodLabel(m)),
                            ))
                        .toList(),
                    onChanged: (PaymentMethod? value) {
                      if (value != null) setState(() => method = value);
                    },
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'This records money paid. Purchases reduce the payable '
                  'separately.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Record payment'),
              ),
            ],
          );
        },
      ),
    );
    if (submit == true) {
      try {
        final int paise = Money.parseRupeeField(amount.text) ?? 0;
        if (paise <= 0) {
          throw SupplierException('Enter an amount greater than zero.');
        }
        await ref.read(ledgerRepositoryProvider).recordEntry(
              kind: TransactionKind.purchasePayment,
              amountPaise: paise,
              method: method,
              supplierId: supplierId,
              note: 'Supplier payment',
            );
        if (context.mounted) showMessage(context, 'Payment recorded.');
      } catch (error) {
        if (context.mounted) showError(context, error);
      }
    }
    amount.dispose();
  }
}

class _PurchaseCard extends ConsumerWidget {
  const _PurchaseCard({required this.purchase, required this.supplierName});

  final Purchase purchase;
  final String supplierName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int due = purchase.totalPaise - purchase.paidPaise;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  purchase.invoiceNumber.isEmpty
                      ? 'Purchase #${purchase.id}'
                      : 'Invoice ${purchase.invoiceNumber}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                Money.format(purchase.totalPaise),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${friendlyDay(purchase.occurredAt)} · '
                  'paid ${Money.format(purchase.paidPaise)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              StatusPill(
                label: due <= 0 ? 'Settled' : '${Money.format(due)} due',
                color: due <= 0 ? AppColors.positive : AppColors.danger,
                background:
                    due <= 0 ? AppColors.positiveSoft : AppColors.dangerSoft,
              ),
            ],
          ),
          if (purchase.note.isNotEmpty) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              purchase.note,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
