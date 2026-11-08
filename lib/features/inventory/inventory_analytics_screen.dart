import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../domain/models.dart';

final AutoDisposeFutureProvider<List<ProductSales>> _salesProvider =
    FutureProvider.autoDispose<List<ProductSales>>((ref) {
  return ref.watch(inventoryRepositoryProvider).productSales(days: 30);
});

class InventoryAnalyticsScreen extends ConsumerWidget {
  const InventoryAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppThemeColors colors = context.appColors;
    final List<ProductView> products =
        ref.watch(allProductsProvider).valueOrNull ?? <ProductView>[];
    final AsyncValue<List<ProductSales>> sales = ref.watch(_salesProvider);

    final int stockValue = products.fold(
        0, (int sum, ProductView p) => sum + p.stockValuePaise);
    final int retailValue = products.fold(
        0, (int sum, ProductView p) => sum + p.retailValuePaise);
    final List<ProductView> low =
        products.where((ProductView p) => p.isLowStock).toList();
    final List<ProductView> slow =
        products.where((ProductView p) => p.isSlowMoving).toList();
    final List<ProductView> reorder = products
        .where((ProductView p) => p.suggestedReorderQty > 0)
        .toList()
      ..sort((ProductView a, ProductView b) =>
          b.suggestedReorderQty.compareTo(a.suggestedReorderQty));

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Stock analytics')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: StatTile(
                  label: 'Cost of stock',
                  value: Money.compact(stockValue),
                  icon: Icons.inventory_2_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatTile(
                  label: 'Retail value',
                  value: Money.compact(retailValue),
                  icon: Icons.sell_outlined,
                  tone: StatTone.positive,
                  caption: 'Potential ${Money.compact(retailValue - stockValue)} '
                      'margin',
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const SectionHeader(title: 'Best sellers · last 30 days'),
          sales.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (Object error, StackTrace _) =>
                Text(error.toString(), style: Theme.of(context).textTheme.bodySmall),
            data: (List<ProductSales> list) {
              if (list.isEmpty) {
                return Text(
                  'No product sales recorded yet. Add a sale with products to '
                  'see this ranking.',
                  style: Theme.of(context).textTheme.bodySmall,
                );
              }
              final int top = list.first.revenuePaise;
              return Column(
                children: list.take(6).map((ProductSales row) {
                  final double ratio =
                      top == 0 ? 0 : row.revenuePaise / top;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                row.productName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              Money.format(row.revenuePaise),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: ratio,
                            minHeight: 5,
                            backgroundColor: AppColors.chip,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.ink,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${qtyLabel(row.units)} units · '
                          '${Money.format(row.marginPaise)} margin',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 20),
          SectionHeader(
            title: 'Reorder suggestions',
            trailing: Text(
              '${reorder.length} products',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          if (reorder.isEmpty)
            Text(
              'Nothing to reorder — stock is above minimum levels.',
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Column(
                children: reorder.take(10).map((ProductView p) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                p.name,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'In stock ${qtyLabel(p.stockQty)} ${p.unit} '
                                '· min ${qtyLabel(p.minStockQty)}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        StatusPill(
                          label: '+${qtyLabel(p.suggestedReorderQty)}',
                          color: AppColors.warning,
                          background: AppColors.warningSoft,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 22),
          SectionHeader(
            title: 'Slow moving',
            trailing: Text(
              'No sales in 30 days',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          if (slow.isEmpty)
            Text(
              'Every product sold at least once in the last 30 days.',
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Column(
                children: slow.take(10).map((ProductView p) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            p.name,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          '${qtyLabel(p.stockQty)} ${p.unit} · '
                          '${Money.format(p.stockValuePaise)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 22),
          SectionHeader(
            title: 'Low stock',
            trailing: Text(
              '${low.length} products',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          if (low.isEmpty)
            Text(
              'All products are above their minimum level.',
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: low
                  .map((ProductView p) => StatusPill(
                        label: p.name,
                        color: AppColors.danger,
                        background: AppColors.dangerSoft,
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}
