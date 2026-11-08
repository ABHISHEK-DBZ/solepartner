import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../domain/models.dart';

Future<int?> showProductForm(BuildContext context, {ProductView? product}) {
  return showModalBottomSheet<int?>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext context) => ProductFormSheet(product: product),
  );
}

class ProductFormSheet extends ConsumerStatefulWidget {
  const ProductFormSheet({super.key, this.product});

  final ProductView? product;

  @override
  ConsumerState<ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends ConsumerState<ProductFormSheet> {
  late final TextEditingController _name =
      TextEditingController(text: widget.product?.name ?? '');
  late final TextEditingController _sku =
      TextEditingController(text: widget.product?.sku ?? '');
  late final TextEditingController _barcode =
      TextEditingController(text: widget.product?.barcode ?? '');
  late final TextEditingController _category =
      TextEditingController(text: widget.product?.category ?? '');
  late final TextEditingController _purchase = TextEditingController(
      text: Money.rupeeFieldValue(widget.product?.purchasePricePaise));
  late final TextEditingController _selling = TextEditingController(
      text: Money.rupeeFieldValue(widget.product?.sellingPricePaise));
  late final TextEditingController _opening =
      TextEditingController(text: '0');
  late final TextEditingController _minStock = TextEditingController(
      text: widget.product == null
          ? ''
          : widget.product!.minStockQty.toString());
  String _unit = 'pc';
  int? _supplierId;
  bool _busy = false;

  static const List<String> _units = <String>[
    'pc',
    'kg',
    'g',
    'ltr',
    'ml',
    'pack',
    'dozen',
    'box',
  ];

  @override
  void initState() {
    super.initState();
    final ProductView? product = widget.product;
    if (product != null) {
      _unit = _units.contains(product.unit) ? product.unit : 'pc';
      _supplierId = product.supplierId;
    }
  }

  @override
  void dispose() {
    for (final TextEditingController controller in <TextEditingController>[
      _name,
      _sku,
      _barcode,
      _category,
      _purchase,
      _selling,
      _opening,
      _minStock,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      showError(context, 'Product name is required.');
      return;
    }
    setState(() => _busy = true);
    try {
      final repo = ref.read(inventoryRepositoryProvider);
      final int sellingPaise = Money.parseRupeeField(_selling.text) ?? 0;
      final int purchasePaise = Money.parseRupeeField(_purchase.text) ?? 0;
      final double minStock = double.tryParse(_minStock.text.trim()) ?? 0;
      final int id;
      if (widget.product == null) {
        id = await repo.createProduct(
          name: _name.text,
          sku: _sku.text,
          barcode: _barcode.text,
          category: _category.text,
          unit: _unit,
          purchasePricePaise: purchasePaise,
          sellingPricePaise: sellingPaise,
          openingStockQty: double.tryParse(_opening.text.trim()) ?? 0,
          minStockQty: minStock,
          supplierId: _supplierId,
        );
      } else {
        await repo.updateProduct(
          id: widget.product!.id,
          name: _name.text,
          sku: _sku.text,
          barcode: _barcode.text,
          category: _category.text,
          unit: _unit,
          purchasePricePaise: purchasePaise,
          sellingPricePaise: sellingPaise,
          minStockQty: minStock,
          supplierId: _supplierId,
          clearSupplier: _supplierId == null,
        );
        id = widget.product!.id;
      }
      if (!mounted) return;
      Navigator.of(context).pop(id);
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<SupplierView> suppliers =
        ref.watch(allSuppliersProvider).valueOrNull ?? <SupplierView>[];
    final bool creating = widget.product == null;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              creating ? 'New product' : 'Edit product',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Stock changes are always recorded as movements.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            LabeledField(
              label: 'Product name',
              child: TextField(
                controller: _name,
                autofocus: creating,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(hintText: 'e.g. Tata Salt 1kg'),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: LabeledField(
                    label: 'SKU (optional)',
                    child: TextField(controller: _sku),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: LabeledField(
                    label: 'Barcode (optional)',
                    child: TextField(
                      controller: _barcode,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: LabeledField(
                    label: 'Category',
                    child: TextField(
                      controller: _category,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(hintText: 'Grocery'),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: LabeledField(
                    label: 'Unit',
                    child: DropdownButtonFormField<String>(
                      initialValue: _unit,
                      items: _units
                          .map((String unit) => DropdownMenuItem<String>(
                                value: unit,
                                child: Text(unit),
                              ))
                          .toList(),
                      onChanged: (String? value) {
                        if (value != null) setState(() => _unit = value);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: LabeledField(
                    label: 'Purchase price ₹',
                    child: TextField(
                      controller: _purchase,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: LabeledField(
                    label: 'Selling price ₹',
                    child: TextField(
                      controller: _selling,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                if (creating)
                  Expanded(
                    child: LabeledField(
                      label: 'Opening stock',
                      child: TextField(
                        controller: _opening,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ),
                  ),
                if (creating) const SizedBox(width: 10),
                Expanded(
                  child: LabeledField(
                    label: 'Minimum stock',
                    hint: 'Low-stock alerts use this level.',
                    child: TextField(
                      controller: _minStock,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                    ),
                  ),
                ),
              ],
            ),
            LabeledField(
              label: 'Default supplier (optional)',
              child: DropdownButtonFormField<int?>(
                initialValue: _supplierId,
                items: <DropdownMenuItem<int?>>[
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('No supplier'),
                  ),
                  ...suppliers.map((SupplierView s) => DropdownMenuItem<int?>(
                        value: s.id,
                        child: Text(s.name, overflow: TextOverflow.ellipsis),
                      )),
                ],
                onChanged: (int? value) => setState(() => _supplierId = value),
              ),
            ),
            FilledButton(
              onPressed: _busy ? null : _save,
              child: _busy
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(creating ? 'Add product' : 'Save changes'),
            ),
          ],
        ),
      ),
    );
  }
}
