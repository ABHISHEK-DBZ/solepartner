import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';
import 'product_form_sheet.dart';

final AutoDisposeStreamProviderFamily<ProductView?, int> _productProvider =
    StreamProvider.autoDispose.family<ProductView?, int>((ref, int id) {
  return ref.watch(inventoryRepositoryProvider).watchProduct(id);
});

final AutoDisposeStreamProviderFamily<List<StockMovement>, int>
    _movementsProvider =
    StreamProvider.autoDispose.family<List<StockMovement>, int>((ref, int id) {
  return ref.watch(inventoryRepositoryProvider).watchMovements(id);
});

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppThemeColors colors = context.appColors;
    final AsyncValue<ProductView?> async = ref.watch(_productProvider(productId));

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Product'),
        actions: <Widget>[
          async.valueOrNull == null
              ? const SizedBox.shrink()
              : PopupMenuButton<String>(
                  onSelected: (String value) async {
                    if (value == 'edit') {
                      await showProductForm(context, product: async.value);
                    } else if (value == 'archive') {
                      final bool confirm = await confirmAction(
                        context,
                        title: 'Archive product?',
                        message:
                            'Archived products stay in your records but leave '
                            'the stock list and pickers.',
                        confirmLabel: 'Archive',
                        destructive: true,
                      );
                      if (confirm) {
                        await ref
                            .read(inventoryRepositoryProvider)
                            .archiveProduct(productId);
                        if (context.mounted) Navigator.of(context).pop();
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      const <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit product'),
                    ),
                    PopupMenuItem<String>(
                      value: 'archive',
                      child: Text('Archive product'),
                    ),
                  ],
                ),
        ],
      ),
      body: async.when(
        loading: () => const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (Object error, StackTrace _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load product',
          message: error.toString(),
        ),
        data: (ProductView? product) {
          if (product == null) {
            return const EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'Product not found',
              message: 'It may have been archived.',
            );
          }
          final List<StockMovement> movements =
              ref.watch(_movementsProvider(productId)).valueOrNull ??
                  <StockMovement>[];
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: <Widget>[
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      <String>[
                        if (product.category.isNotEmpty) product.category,
                        if (product.sku.isNotEmpty) 'SKU ${product.sku}',
                        if (product.barcode.isNotEmpty) product.barcode,
                        if (product.supplierName != null) product.supplierName!,
                      ].join(' · '),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (product.isLowStock) ...<Widget>[
                      const SizedBox(height: 10),
                      StatusPill(
                        label: product.isOutOfStock
                            ? 'Out of stock'
                            : 'Low stock · min ${qtyLabel(product.minStockQty)}',
                        color: AppColors.danger,
                        background: AppColors.dangerSoft,
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _metric(
                            context,
                            'In stock',
                            '${qtyLabel(product.stockQty)} ${product.unit}',
                          ),
                        ),
                        Expanded(
                          child: _metric(
                            context,
                            'Stock value',
                            Money.format(product.stockValuePaise),
                          ),
                        ),
                        Expanded(
                          child: _metric(
                            context,
                            'Margin / unit',
                            Money.format(product.marginPerUnitPaise),
                            tone: product.marginPerUnitPaise < 0
                                ? AppColors.danger
                                : AppColors.positive,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                child: Column(
                  children: <Widget>[
                    DetailRow(
                      label: 'Purchase price',
                      value: Money.format(product.purchasePricePaise),
                    ),
                    DetailRow(
                      label: 'Selling price',
                      value: Money.format(product.sellingPricePaise),
                    ),
                    DetailRow(
                      label: 'Retail value of stock',
                      value: Money.format(product.retailValuePaise),
                    ),
                    DetailRow(
                      label: 'Sold in last 30 days',
                      value: '${qtyLabel(product.unitsSold30d)} ${product.unit}',
                    ),
                    if (product.isSlowMoving)
                      const DetailRow(
                        label: 'Movement',
                        value: 'Slow moving',
                        valueColor: AppColors.warning,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const SectionHeader(title: 'Update stock'),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _stockAction(
                      context,
                      ref,
                      label: 'Add stock',
                      icon: Icons.add_box_outlined,
                      kind: StockMovementKind.adjustment,
                      positive: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _stockAction(
                      context,
                      ref,
                      label: 'Reduce',
                      icon: Icons.indeterminate_check_box_outlined,
                      kind: StockMovementKind.adjustment,
                      positive: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _stockAction(
                      context,
                      ref,
                      label: 'Damaged',
                      icon: Icons.broken_image_outlined,
                      kind: StockMovementKind.damage,
                      positive: false,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _stockAction(
                      context,
                      ref,
                      label: 'Expired',
                      icon: Icons.event_busy_outlined,
                      kind: StockMovementKind.expiry,
                      positive: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const SectionHeader(title: 'Stock movements'),
              if (movements.isEmpty)
                const EmptyState(
                  icon: Icons.swap_vert,
                  title: 'No movements yet',
                  message: 'Every stock change will be listed here.',
                )
              else
                AppCard(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  child: Column(
                    children: movements
                        .map((StockMovement m) => _movementRow(context, m))
                        .toList(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _metric(
    BuildContext context,
    String label,
    String value, {
    Color? tone,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: tone,
          ),
        ),
      ],
    );
  }

  Widget _stockAction(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required IconData icon,
    required StockMovementKind kind,
    required bool positive,
  }) {
    return OutlinedButton.icon(
      onPressed: () => _openStockDialog(
        context,
        ref,
        kind: kind,
        positive: positive,
      ),
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        foregroundColor: AppColors.ink,
        side: const BorderSide(color: AppColors.line),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Future<void> _openStockDialog(
    BuildContext context,
    WidgetRef ref, {
    required StockMovementKind kind,
    required bool positive,
  }) async {
    final TextEditingController qty = TextEditingController();
    final TextEditingController reason = TextEditingController(
      text: kind == StockMovementKind.damage
          ? 'Damaged in shop'
          : kind == StockMovementKind.expiry
              ? 'Expired'
              : '',
    );
    final bool? submit = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(positive ? 'Add stock' : kind.label),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LabeledField(
              label: positive ? 'Quantity to add' : 'Quantity to remove',
              child: TextField(
                controller: qty,
                autofocus: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            LabeledField(
              label: 'Reason',
              child: TextField(
                controller: reason,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Stock count correction',
                ),
              ),
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
            child: const Text('Record'),
          ),
        ],
      ),
    );
    if (submit != true) {
      qty.dispose();
      reason.dispose();
      return;
    }
    try {
      final double value = double.tryParse(qty.text.trim()) ?? 0;
      if (value <= 0) {
        throw InventoryException('Enter a quantity greater than zero.');
      }
      await ref.read(inventoryRepositoryProvider).adjustStock(
            productId: productId,
            quantityDelta: positive ? value : -value,
            kind: kind,
            reason: reason.text,
          );
      if (context.mounted) showMessage(context, 'Stock updated.');
    } catch (error) {
      if (context.mounted) showError(context, error);
    } finally {
      qty.dispose();
      reason.dispose();
    }
  }

  Widget _movementRow(BuildContext context, StockMovement movement) {
    final bool inbound = movement.quantityDelta > 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: <Widget>[
          Icon(
            inbound ? Icons.south_west : Icons.north_east,
            size: 16,
            color: inbound ? AppColors.positive : AppColors.inkSoft,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  movement.kind.label,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  <String>[
                    movement.reason.isEmpty ? '—' : movement.reason,
                    friendlyDay(movement.createdAt),
                  ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            '${inbound ? '+' : ''}${qtyLabel(movement.quantityDelta)}',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: inbound ? AppColors.positive : AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
