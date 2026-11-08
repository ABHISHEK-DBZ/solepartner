import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../app/theme_controller.dart';
import '../../core/money.dart';
import '../../core/widgets/common.dart';
import '../../data/db/app_database.dart';
import '../../domain/models.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppThemeColors colors = context.appColors;
    final AsyncValue<MerchantProfile?> merchant = ref.watch(merchantProfileProvider);
    final WalletSnapshot wallet = ref.watch(walletProvider);

    final String shopName = merchant.valueOrNull?.shopName ?? 'KhataCopilot';
    final String ownerName = merchant.valueOrNull?.ownerName ?? 'Merchant';

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('More'),
        actions: const <Widget>[
          AnimatedThemeToggle(),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: <Widget>[
          // Merchant mini profile card
          AppCard(
            padding: const EdgeInsets.all(16),
            onTap: () => context.push('/settings'),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 24,
                  backgroundColor: colors.primary.withValues(alpha: 0.12),
                  child: Text(
                    shopName.isNotEmpty ? shopName[0].toUpperCase() : 'K',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        shopName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$ownerName · Pro Merchant',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: colors.textSecondary),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 8 Grid items matching mockup screen 10
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,
            children: <Widget>[
              _MoreGridTile(
                title: 'Customers',
                subtitle: 'Manage & track udhaar',
                icon: Icons.people_outline_rounded,
                iconColor: colors.primary,
                onTap: () => context.push('/khata'),
              ),
              _MoreGridTile(
                title: 'Suppliers',
                subtitle: 'Vendors & payments',
                icon: Icons.local_shipping_outlined,
                iconColor: colors.accent,
                onTap: () => context.push('/suppliers'),
              ),
              _MoreGridTile(
                title: 'Purchases',
                subtitle: 'Stock purchase entries',
                icon: Icons.shopping_bag_outlined,
                iconColor: colors.warning,
                onTap: () => context.push('/suppliers'),
              ),
              _MoreGridTile(
                title: 'AI Insights',
                subtitle: 'Business intelligence',
                icon: Icons.auto_awesome_rounded,
                iconColor: const Color(0xFF8B5CF6),
                onTap: () => context.push('/insights'),
              ),
              _MoreGridTile(
                title: 'Payments',
                subtitle: 'AI payment agent',
                icon: Icons.bolt_rounded,
                iconColor: colors.primary,
                onTap: () => context.push('/payments'),
              ),
              _MoreGridTile(
                title: 'Wallet',
                subtitle: wallet.connected
                    ? Money.formatSol(wallet.balanceLamports ?? 0)
                    : 'Solana (SOL)',
                icon: Icons.account_balance_wallet_outlined,
                iconColor: const Color(0xFF06B6D4),
                onTap: () => context.push('/wallet'),
              ),
              _MoreGridTile(
                title: 'Reports',
                subtitle: 'Sales, profit & more',
                icon: Icons.bar_chart_rounded,
                iconColor: colors.accent,
                onTap: () => context.push('/insights'),
              ),
              _MoreGridTile(
                title: 'Settings',
                subtitle: 'App, profile & security',
                icon: Icons.settings_outlined,
                iconColor: colors.textSecondary,
                onTap: () => context.push('/settings'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Security & Audit Log Card
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            onTap: () => context.push('/audit'),
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.chipBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.shield_outlined, size: 20, color: colors.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Audit Trail & Policy',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        'On-device deterministic ledger verification',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: colors.textSecondary),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // App Intro & Tour Card
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            onTap: () => context.push('/intro'),
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.smart_toy_outlined, size: 20, color: colors.accent),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'SolePartner Intro & Features',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        'Replay 3D intro tour and feature walkthrough',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: colors.textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreGridTile extends StatelessWidget {
  const _MoreGridTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return AppCard(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
