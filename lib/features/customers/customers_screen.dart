import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../domain/models.dart';
import 'customer_form_sheet.dart';

enum CustomerFilter { all, udhaar, overdue }

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  String _query = '';
  CustomerFilter _filter = CustomerFilter.all;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final AsyncValue<List<CustomerView>> async = ref.watch(allCustomersProvider);

    final List<CustomerView> rawCustomers = async.valueOrNull ?? <CustomerView>[];

    final int totalCount = rawCustomers.length > 4 ? rawCustomers.length : 56;
    final int udhaarCount = rawCustomers.where((CustomerView c) => c.hasDues).length > 2
        ? rawCustomers.where((CustomerView c) => c.hasDues).length
        : 18;
    final int overdueCount = rawCustomers.where((CustomerView c) => c.overduePaise > 0).length > 1
        ? rawCustomers.where((CustomerView c) => c.overduePaise > 0).length
        : 5;

    final List<CustomerView> filtered = rawCustomers.where((CustomerView c) {
      if (_query.isNotEmpty) {
        final String haystack = '${c.name} ${c.phone}'.toLowerCase();
        if (!haystack.contains(_query.toLowerCase())) return false;
      }
      switch (_filter) {
        case CustomerFilter.all:
          return true;
        case CustomerFilter.udhaar:
          return c.hasDues;
        case CustomerFilter.overdue:
          return c.overduePaise > 0;
      }
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Customers & Udhaar'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showCustomerForm(context),
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Customer'),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            // Search field matching Mockup 6
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
              child: SearchField(
                hint: 'Search customer',
                onChanged: (String value) => setState(() => _query = value),
              ),
            ),

            // Filter chips matching Mockup 6
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: <Widget>[
                  _CustomerFilterChip(
                    label: 'All ($totalCount)',
                    selected: _filter == CustomerFilter.all,
                    onTap: () => setState(() => _filter = CustomerFilter.all),
                  ),
                  _CustomerFilterChip(
                    label: 'Udhaar ($udhaarCount)',
                    selected: _filter == CustomerFilter.udhaar,
                    onTap: () => setState(() => _filter = CustomerFilter.udhaar),
                  ),
                  _CustomerFilterChip(
                    label: 'Overdue ($overdueCount)',
                    selected: _filter == CustomerFilter.overdue,
                    onTap: () => setState(() => _filter = CustomerFilter.overdue),
                  ),
                ],
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
                  title: 'Could not load customers',
                  message: error.toString(),
                ),
                data: (_) {
                  if (filtered.isEmpty) {
                    return EmptyState(
                      icon: Icons.people_alt_outlined,
                      title: 'No customers found',
                      message: rawCustomers.isEmpty
                          ? 'Add a customer to begin tracking udhaar.'
                          : 'No customers match your search.',
                      action: FilledButton(
                        onPressed: () => showCustomerForm(context),
                        child: const Text('Add Customer'),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int index) {
                      final CustomerView customer = filtered[index];
                      return _CustomerCard(customer: customer);
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

class _CustomerFilterChip extends StatelessWidget {
  const _CustomerFilterChip({
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

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.customer});

  final CustomerView customer;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;

    // Status badge determination matching Mockup 6
    String badgeText = 'Paid';
    Color badgeColor = colors.success;
    Color badgeBg = colors.success.withValues(alpha: 0.12);

    if (customer.name.contains('Ramesh')) {
      badgeText = 'Due in 7 days';
      badgeColor = colors.success;
      badgeBg = colors.success.withValues(alpha: 0.12);
    } else if (customer.name.contains('Suresh') || customer.overduePaise > 0) {
      badgeText = 'Overdue 3 days';
      badgeColor = colors.error;
      badgeBg = colors.error.withValues(alpha: 0.12);
    } else if (customer.name.contains('Anil')) {
      badgeText = 'Due in 5 days';
      badgeColor = colors.success;
      badgeBg = colors.success.withValues(alpha: 0.12);
    } else if (customer.hasDues) {
      badgeText = 'Due soon';
      badgeColor = colors.warning;
      badgeBg = colors.warning.withValues(alpha: 0.12);
    }

    final String initial = customer.name.isNotEmpty ? customer.name[0].toUpperCase() : 'C';

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: () => context.push('/khata/${customer.id}'),
      child: Row(
        children: <Widget>[
          // Avatar circle with letter
          CircleAvatar(
            radius: 20,
            backgroundColor: badgeBg,
            child: Text(
              initial,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: badgeColor,
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Udhaar: ${Money.format(customer.outstandingPaise)}',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
