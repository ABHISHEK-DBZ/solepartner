import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../domain/models.dart';
import 'product_form_sheet.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  String _query = '';
  String _selectedCategory = 'All';

  static const List<String> _categories = <String>[
    'All',
    'Grocery',
    'Snacks',
    'Beverages',
  ];

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final AsyncValue<List<ProductView>> async = ref.watch(allProductsProvider);
    final List<ProductView> all = async.valueOrNull ?? <ProductView>[];

    final List<ProductView> filtered = all.where((ProductView p) {
      final bool matchesCategory = _selectedCategory == 'All' ||
          p.category.toLowerCase() == _selectedCategory.toLowerCase();
      if (!matchesCategory) return false;

      if (_query.isNotEmpty) {
        final String haystack = '${p.name} ${p.sku} ${p.barcode} ${p.category}'.toLowerCase();
        if (!haystack.contains(_query.toLowerCase())) return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Stock Analytics',
            icon: const Icon(Icons.insights_rounded),
            onPressed: () => context.push('/insights'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showProductForm(context),
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Product'),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            // Search Bar with Barcode Scanner Icon matching Mockup 5
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
              child: SearchField(
                hint: 'Search product, SKU or barcode',
                onChanged: (String value) => setState(() => _query = value),
                trailing: IconButton(
                  icon: Icon(Icons.qr_code_scanner_rounded, color: colors.primary),
                  onPressed: () {
                    showMessage(context, 'Barcode scanner initialized');
                  },
                ),
              ),
            ),

            // Category Chips matching Mockup 5: All, Grocery, Snacks, Beverages
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: _categories.map((String cat) {
                  final bool isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) {
                        HapticFeedback.lightImpact();
                        setState(() => _selectedCategory = cat);
                      },
                      backgroundColor: colors.surface,
                      selectedColor: colors.primary.withValues(alpha: 0.15),
                      labelStyle: TextStyle(
                        color: isSelected ? colors.primary : colors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 12.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? colors.primary : colors.border,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: async.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (Object error, StackTrace _) => EmptyState(
                  icon: Icons.error_outline,
                  title: 'Could not load stock',
                  message: error.toString(),
                ),
                data: (_) {
                  if (filtered.isEmpty) {
                    return EmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: all.isEmpty ? 'No products yet' : 'No matching products',
                      message: all.isEmpty
                          ? 'Add your store inventory to track quantity and sales.'
                          : 'Try searching with another keyword.',
                      action: FilledButton(
                        onPressed: () => showProductForm(context),
                        child: const Text('Add Product'),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int index) {
                      final ProductView product = filtered[index];
                      return _ProductCard(product: product);
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
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final ProductView product;

  Color _categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'grocery':
        return const Color(0xFFF59E0B);
      case 'snacks':
        return const Color(0xFFEF4444);
      case 'beverages':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF10B981);
    }
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'grocery':
        return Icons.shopping_basket_rounded;
      case 'snacks':
        return Icons.cookie_rounded;
      case 'beverages':
        return Icons.local_drink_rounded;
      default:
        return Icons.inventory_2_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final Color catColor = _categoryColor(product.category);

    return AppCard(
      padding: const EdgeInsets.all(14),
      onTap: () => context.push('/stock/${product.id}'),
      child: Row(
        children: <Widget>[
          // Product category thumbnail placeholder matching mockup
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: catColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _categoryIcon(product.category),
              size: 24,
              color: catColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: <Widget>[
                    Text(
                      product.sku.isNotEmpty ? 'SKU: ${product.sku}' : 'Grocery',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: product.isLowStock
                            ? colors.error.withValues(alpha: 0.1)
                            : colors.chipBackground,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Stock: ${qtyLabel(product.stockQty)}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: product.isLowStock ? colors.error : colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                Money.format(product.sellingPricePaise),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                  fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, size: 18, color: colors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }
}
