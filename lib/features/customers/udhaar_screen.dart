import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../domain/models.dart';

class UdhaarScreen extends ConsumerWidget {
  const UdhaarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppThemeColors colors = context.appColors;
    final AsyncValue<List<CustomerView>> async =
        ref.watch(allCustomersProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Udhaar')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (Object error, StackTrace _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load udhaar',
          message: error.toString(),
        ),
        data: (List<CustomerView> all) {
          final List<CustomerView> withDues = all
              .where((CustomerView c) => c.outstandingPaise > 0)
              .toList()
            ..sort((CustomerView a, CustomerView b) {
              if (a.overduePaise != b.overduePaise) {
                return b.overduePaise.compareTo(a.overduePaise);
              }
              return b.outstandingPaise.compareTo(a.outstandingPaise);
            });

          final int total = withDues.fold(
              0, (int sum, CustomerView c) => sum + c.outstandingPaise);
          final int overdue = withDues.fold(
              0, (int sum, CustomerView c) => sum + c.overduePaise);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: <Widget>[
              AppCard(
                color: AppColors.ink,
                borderColor: AppColors.ink,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'OUTSTANDING CREDIT',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.55),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      Money.format(total),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1.1,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: <Widget>[
                        _Pill(
                          label: '${withDues.length} customers',
                          color: AppColors.gold,
                        ),
                        const SizedBox(width: 8),
                        _Pill(
                          label: '${Money.format(overdue)} over 30d',
                          color: overdue > 0
                              ? const Color(0xFFFFB4AB)
                              : Colors.white70,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (withDues.isEmpty)
                const EmptyState(
                  icon: Icons.check_circle_outline,
                  title: 'No udhaar outstanding',
                  message: 'Every customer account is settled.',
                )
              else
                ...withDues.map((CustomerView customer) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AppCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        onTap: () => context.push('/khata/${customer.id}'),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 19,
                              backgroundColor: customer.overduePaise > 0
                                  ? AppColors.dangerSoft
                                  : AppColors.goldSoft,
                              child: Text(
                                initials(customer.name),
                                style: const TextStyle(
                                  fontSize: 12,
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
                                    customer.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  if (customer.overduePaise > 0)
                                    Text(
                                      '${Money.format(customer.overduePaise)} overdue',
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        color: AppColors.danger,
                                      ),
                                    )
                                  else
                                    Text(
                                      customer.lastActivityAt == null
                                          ? 'No activity'
                                          : 'Last ${friendlyDay(customer.lastActivityAt!)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              Money.format(customer.outstandingPaise),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
            ],
          );
        },
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
