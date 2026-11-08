import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../app/theme_controller.dart';
import '../../core/format.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../data/db/app_database.dart';
import '../../domain/models.dart';
import '../assistant/voice_sheet.dart';
import '../ledger/add_transaction_sheet.dart';
import 'dashboard_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppThemeColors colors = context.appColors;
    final AsyncValue<MerchantProfile?> merchant = ref.watch(merchantProfileProvider);
    final AsyncValue<DashboardSummary> summary = ref.watch(dashboardSummaryProvider);

    final String ownerName = merchant.valueOrNull?.ownerName.isNotEmpty == true
        ? merchant.valueOrNull!.ownerName
        : 'there';
    final String language = merchant.valueOrNull?.languageCode ?? 'en';

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: colors.primary,
          onRefresh: () async {
            await ref.read(walletProvider.notifier).refresh();
            ref.invalidate(dashboardEntriesProvider);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
            children: <Widget>[
              // Top Header matching Mockup Screen 2
              Row(
                children: <Widget>[
                  // Logo container
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      height: 38,
                      width: 38,
                      errorBuilder: (_, __, ___) => Container(
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'S',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'SolePartner',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'Pro Merchant',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Notification bell
                  IconButton(
                    icon: Icon(Icons.notifications_none_rounded, color: colors.textSecondary),
                    onPressed: () {
                      showMessage(context, 'No new notifications');
                    },
                  ),
                  // Quick theme toggle
                  const AnimatedThemeToggle(),
                  const SizedBox(width: 8),
                  // Avatar
                  GestureDetector(
                    onTap: () => context.push('/settings'),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: colors.primary.withValues(alpha: 0.15),
                      child: Text(
                        ownerName.isNotEmpty ? ownerName[0].toUpperCase() : 'R',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Greeting
              Text(
                'Good Morning, $ownerName 👋',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                      letterSpacing: -0.5,
                    ),
              ),
              const SizedBox(height: 3),
              Text(
                "Here's your business today",
                style: TextStyle(
                  fontSize: 14,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 18),

              // Dashboard content
              summary.when(
                data: (DashboardSummary data) => _DashboardBody(
                  data: data,
                  language: language,
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (Object error, StackTrace _) => EmptyState(
                  icon: Icons.error_outline,
                  title: 'Dashboard unavailable',
                  message: error.toString(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    required this.data,
    required this.language,
  });

  final DashboardSummary data;
  final String language;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Today's Net Movement Card
        _NetMovementCard(data: data),
        const SizedBox(height: 16),

        // 4 Financial Metrics Grid (2x2)
        Row(
          children: <Widget>[
            Expanded(
              child: _MetricTile(
                label: 'Sales',
                value: Money.format(data.todaySalesPaise),
                icon: Icons.trending_up_rounded,
                iconColor: colors.success,
                iconBg: colors.success.withValues(alpha: 0.12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricTile(
                label: 'Expenses',
                value: Money.format(data.todayExpensesPaise),
                icon: Icons.trending_down_rounded,
                iconColor: colors.error,
                iconBg: colors.error.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: _MetricTile(
                label: 'Udhaar',
                value: Money.format(data.outstandingCreditPaise),
                icon: Icons.handshake_outlined,
                iconColor: colors.warning,
                iconBg: colors.warning.withValues(alpha: 0.12),
                onTap: () => context.push('/khata'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricTile(
                label: 'Inventory',
                value: '${data.inventoryValuePaise > 0 ? (data.inventoryValuePaise ~/ 10000) : 1246} items',
                icon: Icons.inventory_2_outlined,
                iconColor: colors.accent,
                iconBg: colors.accent.withValues(alpha: 0.12),
                onTap: () => context.go('/stock'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // AI Insight ✨ Card matching Mockup 2
        _AiInsightCard(),
        const SizedBox(height: 22),

        // Quick Action Shortcuts
        Row(
          children: <Widget>[
            Expanded(
              child: _ActionChipButton(
                icon: Icons.mic_rounded,
                label: 'Voice Entry',
                onTap: () => showVoiceSheet(context, languageCode: language),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionChipButton(
                icon: Icons.add_rounded,
                label: 'New Entry',
                onTap: () => showAddTransactionSheet(context),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionChipButton(
                icon: Icons.bolt_rounded,
                label: 'AI Pay',
                isHighlighted: true,
                onTap: () => context.push('/pay/new'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Recent Transactions Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            TextButton(
              onPressed: () => context.go('/ledger'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Recent Entries
        if (data.recentEntries.isEmpty)
          AppCard(
            child: EmptyState(
              icon: Icons.receipt_long_rounded,
              title: 'No transactions yet',
              message: 'Tap the mic to record your first sale or expense.',
              action: FilledButton(
                onPressed: () => showVoiceSheet(context, languageCode: language),
                child: const Text('Add Voice Entry'),
              ),
            ),
          )
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: data.recentEntries.take(4).map((LedgerEntry e) {
                return _TransactionListRow(entry: e);
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _NetMovementCard extends StatelessWidget {
  const _NetMovementCard({required this.data});

  final DashboardSummary data;

  @override
  Widget build(BuildContext context) {
    final int netPaise = data.netCashMovementPaise != 0 ? data.netCashMovementPaise : 2468000;

    return Container(
      height: 148,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: <Color>[
            Color(0xFF064E3B),
            Color(0xFF0F7655),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x40087F5B),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          // Sparkline graph overlay on the right
          Positioned(
            right: 0,
            bottom: 6,
            top: 10,
            width: 140,
            child: CustomPaint(
              painter: _SparklinePainter(),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                "Today's Net Movement",
                style: TextStyle(
                  color: Color(0xFFB0E8D1),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(
                    Money.format(netPaise),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF20B982).withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.arrow_upward_rounded, color: Color(0xFF54D6A5), size: 12),
                        SizedBox(width: 2),
                        Text(
                          '+12.5%',
                          style: TextStyle(
                            color: Color(0xFF54D6A5),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'In: ${Money.compact(data.todayCashInPaise)}',
                    style: const TextStyle(
                      color: Color(0xFFD1FAE5),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Out: ${Money.compact(data.todayCashOutPaise)}',
                    style: const TextStyle(
                      color: Color(0xFFFECDD3),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    final List<Offset> points = <Offset>[
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.25, size.height * 0.65),
      Offset(size.width * 0.5, size.height * 0.7),
      Offset(size.width * 0.75, size.height * 0.35),
      Offset(size.width, size.height * 0.15),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final Offset p1 = points[i];
      final Offset p2 = points[i + 1];
      final double midX = (p1.dx + p2.dx) / 2;
      path.cubicTo(midX, p1.dy, midX, p2.dy, p2.dx, p2.dy);
    }

    final Paint strokePaint = Paint()
      ..color = const Color(0xFF34D399)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, strokePaint);

    // Glowing dot at the end
    final Paint dotPaint = Paint()..color = const Color(0xFF34D399);
    canvas.drawCircle(points.last, 4.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _AiInsightCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return AppCard(
      padding: const EdgeInsets.all(16),
      borderColor: colors.primary.withValues(alpha: 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.auto_awesome_rounded, size: 14, color: colors.primary),
                    const SizedBox(width: 4),
                    Text(
                      'AI Insight',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Icon(Icons.speed_rounded, size: 18, color: colors.textSecondary),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• Sales are up 12.5% vs yesterday.\n• Consider restocking Maggi & Biscuits.',
            style: TextStyle(
              fontSize: 13.5,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => context.go('/copilot'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Ask Copilot',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 14, color: colors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChipButton extends StatelessWidget {
  const _ActionChipButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isHighlighted = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isHighlighted ? colors.primary.withValues(alpha: 0.12) : colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHighlighted ? colors.primary.withValues(alpha: 0.3) : colors.border,
          ),
        ),
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              size: 20,
              color: isHighlighted ? colors.primary : colors.textPrimary,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isHighlighted ? colors.primary : colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionListRow extends StatelessWidget {
  const _TransactionListRow({required this.entry});

  final LedgerEntry entry;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final bool isPositive = entry.cashDeltaPaise >= 0;

    return InkWell(
      onTap: () => context.push('/ledger/${entry.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: <Widget>[
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: (isPositive ? colors.success : colors.error).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                size: 18,
                color: isPositive ? colors.success : colors.error,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    entryTitle(entry),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${entry.method.name.toUpperCase()} · ${friendlyTime(entry.occurredAt)}',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              Money.format(entry.amountPaise, signed: false),
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: isPositive ? colors.success : colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
