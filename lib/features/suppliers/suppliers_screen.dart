import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../domain/models.dart';

class SuppliersScreen extends ConsumerStatefulWidget {
  const SuppliersScreen({super.key});

  @override
  ConsumerState<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends ConsumerState<SuppliersScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final AsyncValue<List<SupplierView>> async =
        ref.watch(allSuppliersProvider);
    final List<SupplierView> all = async.valueOrNull ?? <SupplierView>[];
    final List<SupplierView> visible = all
        .where((SupplierView s) =>
            _query.isEmpty ||
            s.name.toLowerCase().contains(_query.toLowerCase()) ||
            s.phone.contains(_query))
        .toList();
    final int payable =
        all.fold(0, (int sum, SupplierView s) => sum + s.payablePaise);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Suppliers')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(context, ref),
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add, size: 20),
        label: const Text('Supplier'),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Column(
                children: <Widget>[
                  SearchField(
                    hint: 'Search supplier',
                    onChanged: (String value) =>
                        setState(() => _query = value),
                  ),
                  const SizedBox(height: 12),
                  StatTile(
                    label: 'Total payable',
                    value: Money.format(payable),
                    icon: Icons.account_balance_wallet_outlined,
                    tone: payable > 0 ? StatTone.negative : StatTone.positive,
                    caption: '${all.length} suppliers',
                  ),
                ],
              ),
            ),
            Expanded(
              child: async.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (Object error, StackTrace _) => EmptyState(
                  icon: Icons.error_outline,
                  title: 'Could not load suppliers',
                  message: error.toString(),
                ),
                data: (_) {
                  if (visible.isEmpty) {
                    return EmptyState(
                      icon: Icons.local_shipping_outlined,
                      title: all.isEmpty ? 'No suppliers yet' : 'No matches',
                      message: all.isEmpty
                          ? 'Add the suppliers you buy stock from to track '
                              'payables and purchase history.'
                          : 'Try a different name.',
                      action: FilledButton.tonal(
                        onPressed: () => _showForm(context, ref),
                        child: const Text('Add a supplier'),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                    itemCount: visible.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (BuildContext context, int index) {
                      final SupplierView supplier = visible[index];
                      return AppCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        onTap: () => context.push('/suppliers/${supplier.id}'),
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 42,
                              width: 42,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.chip,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                initials(supplier.name),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    supplier.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    <String>[
                                      if (supplier.phone.isNotEmpty)
                                        supplier.phone,
                                      '${supplier.productCount} products',
                                      if (supplier.lastPurchaseAt != null)
                                        'last ${friendlyDay(supplier.lastPurchaseAt!)}',
                                    ].join(' · '),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  supplier.payablePaise > 0
                                      ? Money.format(supplier.payablePaise)
                                      : 'Settled',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: supplier.payablePaise > 0
                                        ? AppColors.danger
                                        : AppColors.positive,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  supplier.payablePaise > 0
                                      ? 'payable'
                                      : 'no dues',
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showForm(BuildContext context, WidgetRef ref) async {
    final TextEditingController name = TextEditingController();
    final TextEditingController phone = TextEditingController();
    final TextEditingController address = TextEditingController();
    final TextEditingController notes = TextEditingController();
    final bool? save = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('New supplier'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LabeledField(
                label: 'Name',
                child: TextField(
                  controller: name,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              LabeledField(
                label: 'Phone (optional)',
                child: TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                ),
              ),
              LabeledField(
                label: 'Address (optional)',
                child: TextField(
                  controller: address,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              LabeledField(
                label: 'Notes (optional)',
                child: TextField(
                  controller: notes,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (save == true) {
      try {
        await ref.read(supplierRepositoryProvider).createSupplier(
              name: name.text,
              phone: phone.text,
              address: address.text,
              notes: notes.text,
            );
        if (context.mounted) showMessage(context, 'Supplier added.');
      } catch (error) {
        if (context.mounted) showError(context, error);
      }
    }
    name.dispose();
    phone.dispose();
    address.dispose();
    notes.dispose();
  }
}
