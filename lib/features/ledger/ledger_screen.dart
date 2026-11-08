import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';
import 'add_transaction_sheet.dart';

enum LedgerFilter { all, sales, expenses, udhaar }

final AutoDisposeStateProvider<String> _searchProvider =
    StateProvider.autoDispose<String>((ref) => '');

final AutoDisposeStateProvider<LedgerFilter> _filterProvider =
    StateProvider.autoDispose<LedgerFilter>((ref) => LedgerFilter.all);

final AutoDisposeStreamProvider<List<LedgerEntry>> _entriesProvider =
    StreamProvider.autoDispose<List<LedgerEntry>>((ref) {
  return ref.watch(ledgerRepositoryProvider).watchEntries(limit: 600);
});

final AutoDisposeProvider<List<LedgerEntry>> _visibleEntriesProvider =
    Provider.autoDispose<List<LedgerEntry>>((ref) {
  final List<LedgerEntry> entries =
      ref.watch(_entriesProvider).valueOrNull ?? <LedgerEntry>[];
  final String search = ref.watch(_searchProvider).trim().toLowerCase();
  final LedgerFilter filter = ref.watch(_filterProvider);

  return entries.where((LedgerEntry entry) {
    if (search.isNotEmpty) {
      final String haystack = <String>[
        entry.note,
        entry.customerName ?? '',
        entry.supplierName ?? '',
        entry.kind.label,
        entry.amountPaise.toString(),
      ].join(' ').toLowerCase();
      if (!haystack.contains(search)) return false;
    }
    switch (filter) {
      case LedgerFilter.all:
        return true;
      case LedgerFilter.sales:
        return entry.kind == TransactionKind.sale;
      case LedgerFilter.expenses:
        return entry.kind == TransactionKind.expense ||
            entry.kind == TransactionKind.solanaPayment;
      case LedgerFilter.udhaar:
        return entry.kind == TransactionKind.creditGiven ||
            entry.kind == TransactionKind.creditRepayment;
    }
  }).toList();
});

class LedgerScreen extends ConsumerStatefulWidget {
  const LedgerScreen({super.key});

  @override
  ConsumerState<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends ConsumerState<LedgerScreen> {
  bool _showSearch = false;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final AsyncValue<List<LedgerEntry>> async = ref.watch(_entriesProvider);
    final List<LedgerEntry> entries = ref.watch(_visibleEntriesProvider);
    final LedgerFilter filter = ref.watch(_filterProvider);

    final List<Object> rows = <Object>[];
    String? lastDay;
    for (final LedgerEntry entry in entries) {
      final String day = friendlyDay(entry.occurredAt);
      if (day != lastDay) {
        rows.add(day);
        lastDay = day;
      }
      rows.add(entry);
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Digital Ledger'),
        actions: <Widget>[
          IconButton(
            icon: Icon(_showSearch ? Icons.close : Icons.search_rounded),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchCtrl.clear();
                  ref.read(_searchProvider.notifier).state = '';
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {
              _showFilterModal(context);
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddTransactionSheet(context),
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Entry'),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            if (_showSearch)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: SearchField(
                  controller: _searchCtrl,
                  hint: 'Search transaction or customer...',
                  onChanged: (String value) =>
                      ref.read(_searchProvider.notifier).state = value,
                ),
              ),

            // Filter Chips matching Mockup 4
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: <Widget>[
                  _FilterChip(
                    label: 'All',
                    selected: filter == LedgerFilter.all,
                    onTap: () => ref.read(_filterProvider.notifier).state =
                        LedgerFilter.all,
                  ),
                  _FilterChip(
                    label: 'Sales',
                    selected: filter == LedgerFilter.sales,
                    onTap: () => ref.read(_filterProvider.notifier).state =
                        LedgerFilter.sales,
                  ),
                  _FilterChip(
                    label: 'Expenses',
                    selected: filter == LedgerFilter.expenses,
                    onTap: () => ref.read(_filterProvider.notifier).state =
                        LedgerFilter.expenses,
                  ),
                  _FilterChip(
                    label: 'Udhaar',
                    selected: filter == LedgerFilter.udhaar,
                    onTap: () => ref.read(_filterProvider.notifier).state =
                        LedgerFilter.udhaar,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: async.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (Object error, StackTrace _) => EmptyState(
                  icon: Icons.error_outline,
                  title: 'Could not load ledger',
                  message: error.toString(),
                ),
                data: (_) {
                  if (rows.isEmpty) {
                    return EmptyState(
                      icon: Icons.receipt_long_outlined,
                      title: 'No transactions found',
                      message: entries.isEmpty
                          ? 'Add a sale, expense or udhaar entry to begin.'
                          : 'No entries match this filter.',
                      action: FilledButton(
                        onPressed: () => showAddTransactionSheet(context),
                        child: const Text('Add Transaction'),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    itemCount: rows.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Object row = rows[index];
                      if (row is String) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(2, 16, 2, 8),
                          child: Text(
                            row,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: colors.textSecondary,
                            ),
                          ),
                        );
                      }
                      final LedgerEntry entry = row as LedgerEntry;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _LedgerItemCard(entry: entry),
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

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Filter Ledger',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Audit Trail & Reversal History'),
                subtitle: const Text('Review non-repudiable SQLite audit logs'),
                trailing: const Icon(Icons.arrow_forward_rounded),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/audit');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {
          HapticFeedback.lightImpact();
          onTap();
        },
        backgroundColor: colors.surface,
        selectedColor: colors.primary.withValues(alpha: 0.15),
        labelStyle: TextStyle(
          color: selected ? colors.primary : colors.textPrimary,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 12.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: selected ? colors.primary : colors.border,
          ),
        ),
      ),
    );
  }
}

class _LedgerItemCard extends StatelessWidget {
  const _LedgerItemCard({required this.entry});

  final LedgerEntry entry;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final bool isPositive = entry.cashDeltaPaise >= 0 &&
        entry.kind != TransactionKind.expense &&
        entry.kind != TransactionKind.solanaPayment;

    final Color badgeColor = isPositive ? colors.success : colors.error;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: () => context.push('/ledger/${entry.id}'),
      child: Row(
        children: <Widget>[
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              size: 20,
              color: badgeColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  entryTitle(entry),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    decoration: entry.isReversed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${friendlyTime(entry.occurredAt)} · ${entry.method.name.toUpperCase()}',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                (isPositive ? '+' : '-') + Money.format(entry.amountPaise),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isPositive ? colors.success : colors.error,
                  fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
                ),
              ),
              if (entry.isReversed)
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: colors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'REVERSED',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: colors.error,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
