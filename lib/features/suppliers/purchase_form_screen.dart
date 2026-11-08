import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../data/repositories/supplier_repository.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';

class _Line {
  _Line({
    required this.product,
    required double quantity,
    required int unitCostPaise,
  })  : quantity = TextEditingController(
          text: quantity == quantity.roundToDouble()
              ? quantity.toInt().toString()
              : quantity.toString(),
        ),
        cost = TextEditingController(
          text: Money.rupeeFieldValue(unitCostPaise),
        );

  final ProductView product;
  final TextEditingController quantity;
  final TextEditingController cost;

  double get qty => double.tryParse(quantity.text.trim()) ?? 0;
  int get costPaise => Money.parseRupeeField(cost.text) ?? 0;
  int get totalPaise => (costPaise * qty).round();

  void dispose() {
    quantity.dispose();
    cost.dispose();
  }
}

class PurchaseFormScreen extends ConsumerStatefulWidget {
  const PurchaseFormScreen({super.key, required this.supplierId});

  final int supplierId;

  @override
  ConsumerState<PurchaseFormScreen> createState() => _PurchaseFormScreenState();
}

class _PurchaseFormScreenState extends ConsumerState<PurchaseFormScreen> {
  final List<_Line> _lines = <_Line>[];
  final TextEditingController _invoice = TextEditingController();
  final TextEditingController _note = TextEditingController();
  final TextEditingController _paid = TextEditingController(text: '0');
  PaymentMethod _method = PaymentMethod.cash;
  bool _busy = false;

  @override
  void dispose() {
    for (final _Line line in _lines) {
      line.dispose();
    }
    _invoice.dispose();
    _note.dispose();
    _paid.dispose();
    super.dispose();
  }

  int get _totalPaise =>
      _lines.fold(0, (int sum, _Line line) => sum + line.totalPaise);

  Future<void> _addProduct() async {
    final List<ProductView> products =
        ref.read(allProductsProvider).valueOrNull ?? <ProductView>[];
    if (products.isEmpty) {
      showError(context, 'Add products to your stock list first.');
      return;
    }
    final ProductView? picked = await showModalBottomSheet<ProductView>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) =>
          _ProductPicker(products: products),
    );
    if (picked == null) return;
    setState(() {
      _lines.add(_Line(
        product: picked,
        quantity: 1,
        unitCostPaise: picked.purchasePricePaise,
      ));
    });
  }

  Future<void> _submit() async {
    if (_lines.isEmpty) {
      showError(context, 'Add at least one product.');
      return;
    }
    for (final _Line line in _lines) {
      if (line.qty <= 0) {
        showError(context, 'Quantity for ${line.product.name} must be above 0.');
        return;
      }
    }
    setState(() => _busy = true);
    try {
      final int paidPaise = Money.parseRupeeField(_paid.text) ?? 0;
      final int purchaseId =
          await ref.read(supplierRepositoryProvider).receivePurchase(
                supplierId: widget.supplierId,
                invoiceNumber: _invoice.text,
                note: _note.text,
                paidNowPaise: paidPaise,
                method: _method,
                items: _lines
                    .map((_Line line) => PurchaseItemInput(
                          productId: line.product.id,
                          quantity: line.qty,
                          unitCostPaise: line.costPaise,
                        ))
                    .toList(),
              );
      if (!mounted) return;
      showMessage(
        context,
        'Purchase #$purchaseId received. Stock and payable updated.',
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final AsyncValue<SupplierView?> supplier =
        ref.watch(allSuppliersProvider.select((AsyncValue<List<SupplierView>> v) {
      final List<SupplierView> list = v.valueOrNull ?? <SupplierView>[];
      for (final SupplierView item in list) {
        if (item.id == widget.supplierId) {
          return AsyncValue<SupplierView?>.data(item);
        }
      }
      return const AsyncValue<SupplierView?>.data(null);
    }));

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text('Purchase · ${supplier.valueOrNull?.name ?? ''}'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: LabeledField(
                  label: 'Invoice number (optional)',
                  child: TextField(
                    controller: _invoice,
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const SectionHeader(title: 'Items'),
          if (_lines.isEmpty)
            AppCard(
              child: Column(
                children: <Widget>[
                  const Icon(Icons.add_shopping_cart_outlined,
                      size: 26, color: AppColors.inkFaint),
                  const SizedBox(height: 8),
                  Text(
                    'No items yet. Add the products you received and their '
                    'cost price.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            )
          else
            ..._lines.map((_Line line) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AppCard(
                    padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                line.product.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() {
                                _lines.remove(line);
                                line.dispose();
                              }),
                              icon: const Icon(Icons.close, size: 18),
                              color: AppColors.inkFaint,
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: LabeledField(
                                label: 'Qty (${line.product.unit})',
                                child: TextField(
                                  controller: line.quantity,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: LabeledField(
                                label: 'Cost ₹ / unit',
                                child: TextField(
                                  controller: line.cost,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  'Total',
                                  style:
                                      Theme.of(context).textTheme.labelSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  Money.format(line.totalPaise),
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          const SizedBox(height: 6),
          OutlinedButton.icon(
            onPressed: _addProduct,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add product'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              foregroundColor: AppColors.ink,
              side: const BorderSide(color: AppColors.line),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 20),
          AppCard(
            child: Column(
              children: <Widget>[
                DetailRow(
                  label: 'Purchase total',
                  value: Money.format(_totalPaise),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: LabeledField(
                          label: 'Paid now ₹',
                          child: TextField(
                            controller: _paid,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: LabeledField(
                          label: 'Method',
                          child: DropdownButtonFormField<PaymentMethod>(
                            initialValue: _method,
                            items: const <PaymentMethod>[
                              PaymentMethod.cash,
                              PaymentMethod.upi,
                              PaymentMethod.bank,
                            ]
                                .map((PaymentMethod m) =>
                                    DropdownMenuItem<PaymentMethod>(
                                      value: m,
                                      child: Text(paymentMethodLabel(m)),
                                    ))
                                .toList(),
                            onChanged: (PaymentMethod? value) {
                              if (value != null) {
                                setState(() => _method = value);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                DetailRow(
                  label: 'Added to supplier payable',
                  value: Money.format(
                    _totalPaise - (Money.parseRupeeField(_paid.text) ?? 0),
                  ),
                  valueColor: AppColors.danger,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          LabeledField(
            label: 'Note (optional)',
            child: TextField(
              controller: _note,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          FilledButton(
            onPressed: _busy || _lines.isEmpty ? null : _submit,
            child: _busy
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text('Receive purchase · ${Money.format(_totalPaise)}'),
          ),
          const SizedBox(height: 8),
          Text(
            'Receiving a purchase adds stock, logs a stock movement and '
            'updates the product cost price. Nothing changes silently.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ProductPicker extends StatefulWidget {
  const _ProductPicker({required this.products});

  final List<ProductView> products;

  @override
  State<_ProductPicker> createState() => _ProductPickerState();
}

class _ProductPickerState extends State<_ProductPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final List<ProductView> visible = widget.products
        .where((ProductView p) =>
            _query.isEmpty ||
            p.name.toLowerCase().contains(_query.toLowerCase()) ||
            p.sku.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Column(
              children: <Widget>[
                Text('Add product',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                SearchField(
                  hint: 'Search product',
                  onChanged: (String value) => setState(() => _query = value),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: visible.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (BuildContext context, int index) {
                final ProductView product = visible[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(product.name),
                  subtitle: Text(
                    'Stock ${qtyLabel(product.stockQty)} ${product.unit} · '
                    'cost ${Money.format(product.purchasePricePaise)}',
                  ),
                  trailing: const Icon(Icons.add_circle_outline, size: 20),
                  onTap: () => Navigator.of(context).pop(product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
