import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../domain/models.dart';
import '../../domain/rules/ledger_rules.dart';
import '../dashboard/dashboard_providers.dart';

/// Product-wise margin for the last seven days, from recorded sale lines.
final AutoDisposeFutureProvider<List<ProductSales>> _weeklySalesProvider =
    FutureProvider.autoDispose<List<ProductSales>>((ref) {
  return ref.watch(inventoryRepositoryProvider).productSales(days: 7, limit: 100);
});

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  String _activeTab = 'Overview';

  static const List<String> _tabs = <String>[
    'Overview',
    'Sales',
    'Stock',
    'Profit',
  ];

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final DashboardSummary summary =
        ref.watch(dashboardSummaryProvider).valueOrNull ??
            LedgerRules.summarise(
              entries: const <LedgerEntry>[],
              products: const <ProductView>[],
              customers: const <CustomerView>[],
              now: DateTime.now(),
            );
    final List<LedgerEntry> entries =
        ref.watch(dashboardEntriesProvider).valueOrNull ?? <LedgerEntry>[];
    final List<ProductSales> weeklySales =
        ref.watch(_weeklySalesProvider).valueOrNull ?? <ProductSales>[];

    final DateTime now = DateTime.now();
    final DateTime todayStart = DateTime(now.year, now.month, now.day);
    final DateTime weekStart = todayStart.subtract(const Duration(days: 6));
    final DateTime prevStart = weekStart.subtract(const Duration(days: 7));

    final List<int> dailySales = List<int>.filled(7, 0);
    int prevWeekSales = 0;
    for (final LedgerEntry entry in entries) {
      if (entry.isReversed ||
          entry.reversalOfId != null ||
          !LedgerRules.isSaleLike(entry.kind)) {
        continue;
      }
      final DateTime day = DateTime(
        entry.occurredAt.year,
        entry.occurredAt.month,
        entry.occurredAt.day,
      );
      final int index = day.difference(weekStart).inDays;
      if (index >= 0 && index < 7) dailySales[index] += entry.amountPaise;
      if (!entry.occurredAt.isBefore(prevStart) &&
          entry.occurredAt.isBefore(weekStart)) {
        prevWeekSales += entry.amountPaise;
      }
    }

    final int marginPaise = weeklySales.fold<int>(
      0,
      (int sum, ProductSales sale) => sum + sale.marginPaise,
    );
    final ProductSales? topProduct =
        weeklySales.isEmpty ? null : weeklySales.first;
    final int? growthPercent = prevWeekSales > 0
        ? ((summary.weekSalesPaise - prevWeekSales) * 100 / prevWeekSales)
            .round()
        : null;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.auto_awesome_rounded, color: colors.primary, size: 20),
            const SizedBox(width: 8),
            const Text('AI Business Insights'),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          children: <Widget>[
            // Tab chips matching Mockup 7
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _tabs.map((String tab) {
                  final bool isSelected = _activeTab == tab;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(tab),
                      selected: isSelected,
                      onSelected: (_) {
                        HapticFeedback.lightImpact();
                        setState(() => _activeTab = tab);
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
            const SizedBox(height: 18),

            // This Week's Summary Card with Bar Chart matching Mockup 7
            AppCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "This Week's Summary",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        Money.format(summary.weekSalesPaise),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (growthPercent != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: (growthPercent >= 0
                                    ? colors.success
                                    : colors.error)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${growthPercent >= 0 ? '+' : ''}$growthPercent%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: growthPercent >= 0
                                  ? colors.success
                                  : colors.error,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    growthPercent == null
                        ? 'No sales last week to compare'
                        : 'vs last week',
                    style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
                  ),
                  const SizedBox(height: 24),

                  // Ascending Bar Chart matching Mockup 7
                  SizedBox(
                    height: 110,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List<Widget>.generate(7, (int index) {
                        final DateTime day =
                            weekStart.add(Duration(days: index));
                        final int max = dailySales.reduce(math.max);
                        final double ratio =
                            max == 0 ? 0.05 : dailySales[index] / max;
                        return _BarColumn(
                          day: _weekdayLetter(day.weekday),
                          heightRatio: ratio,
                          isHighlighted: index == 6,
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Key Insights Card matching Mockup 7
            AppCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Key Insights',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _insightBullet(
                    colors,
                    growthPercent == null
                        ? 'Not enough history to compare this week.'
                        : 'Sales are ${growthPercent >= 0 ? 'up' : 'down'} '
                            '${growthPercent.abs()}% vs last week.',
                  ),
                  _insightBullet(
                    colors,
                    '${summary.lowStockCount} items running low on stock.',
                  ),
                  _insightBullet(
                    colors,
                    'Udhaar outstanding: '
                    '${Money.format(summary.outstandingCreditPaise)}.',
                  ),
                  _insightBullet(
                    colors,
                    topProduct == null
                        ? 'No product-linked sales this week.'
                        : '${topProduct.productName} is the top seller '
                            '(${Money.format(topProduct.revenuePaise)}).',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // "Get Detailed Report ->" button matching Mockup 7
            FilledButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                _showReportSheet(
                  context,
                  summary: summary,
                  marginPaise: marginPaise,
                  topProduct: topProduct,
                  growthPercent: growthPercent,
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Get Detailed Report',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _weekdayLetter(int weekday) {
    const List<String> letters = <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return letters[weekday - 1];
  }

  Widget _insightBullet(AppThemeColors colors, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 6),
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: colors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportSheet(
    BuildContext context, {
    required DashboardSummary summary,
    required int marginPaise,
    required ProductSales? topProduct,
    required int? growthPercent,
  }) {
    final String topSku = topProduct == null
        ? '—'
        : '${topProduct.productName} (${topProduct.units} units)';
    final String growth = growthPercent == null
        ? '—'
        : '${growthPercent >= 0 ? '+' : ''}$growthPercent%';
    final String report = <String>[
      'KhataCopilot weekly report',
      'Generated ${DateTime.now().toIso8601String().split('T').first}',
      '',
      'Total sales,${Money.format(summary.weekSalesPaise, showSymbol: false)}',
      'Expenses,${Money.format(summary.weekExpensesPaise, showSymbol: false)}',
      'Product margin,${Money.format(marginPaise, showSymbol: false)}',
      'Udhaar outstanding,'
          '${Money.format(summary.outstandingCreditPaise, showSymbol: false)}',
      'Low stock items,${summary.lowStockCount}',
      'Top seller,"$topSku"',
      'Growth vs last week,$growth',
    ].join('\n');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Weekly Executive Report',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Generated on-device from your ledger records.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              DetailRow(
                label: 'Total Sales',
                value: Money.format(summary.weekSalesPaise),
              ),
              DetailRow(
                label: 'Product Margin',
                value: Money.format(marginPaise),
              ),
              DetailRow(
                label: 'Udhaar Outstanding',
                value: Money.format(summary.outstandingCreditPaise),
              ),
              DetailRow(
                label: 'Low Stock Items',
                value: '${summary.lowStockCount}',
              ),
              DetailRow(label: 'Top Selling SKU', value: topSku),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await SharePlus.instance.share(
                    ShareParams(
                      text: report,
                      subject: 'KhataCopilot weekly report',
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Share Report'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BarColumn extends StatelessWidget {
  const _BarColumn({
    required this.day,
    required this.heightRatio,
    this.isHighlighted = false,
  });

  final String day;
  final double heightRatio;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 28,
          height: 80 * heightRatio,
          decoration: BoxDecoration(
            color: isHighlighted ? colors.primary : colors.accent.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
            color: isHighlighted ? colors.primary : colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
