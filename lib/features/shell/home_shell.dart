import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({
    super.key,
    required this.currentPath,
    required this.child,
  });

  final String currentPath;
  final Widget child;

  int get _index {
    if (currentPath == '/' || currentPath.isEmpty) return 0;
    if (currentPath.startsWith('/ledger')) return 1;
    if (currentPath.startsWith('/copilot')) return 2;
    if (currentPath.startsWith('/stock')) return 3;
    if (currentPath.startsWith('/more') ||
        currentPath.startsWith('/settings') ||
        currentPath.startsWith('/insights')) {
      return 4;
    }
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    HapticFeedback.lightImpact();
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/ledger');
        break;
      case 2:
        context.go('/copilot');
        break;
      case 3:
        context.go('/stock');
        break;
      case 4:
        context.go('/more');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final int selectedIndex = _index;

    return Scaffold(
      backgroundColor: colors.background,
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(
            top: BorderSide(color: colors.border, width: 1),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: context.isDarkMode ? 0.3 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 66,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                  selected: selectedIndex == 0,
                  onTap: () => _onTap(context, 0),
                ),
                _NavItem(
                  icon: Icons.receipt_long_outlined,
                  activeIcon: Icons.receipt_long_rounded,
                  label: 'Ledger',
                  selected: selectedIndex == 1,
                  onTap: () => _onTap(context, 1),
                ),
                _CenterVoiceButton(
                  selected: selectedIndex == 2,
                  onTap: () => _onTap(context, 2),
                ),
                _NavItem(
                  icon: Icons.inventory_2_outlined,
                  activeIcon: Icons.inventory_2_rounded,
                  label: 'Stock',
                  selected: selectedIndex == 3,
                  onTap: () => _onTap(context, 3),
                ),
                _NavItem(
                  icon: Icons.menu_rounded,
                  activeIcon: Icons.grid_view_rounded,
                  label: 'More',
                  selected: selectedIndex == 4,
                  onTap: () => _onTap(context, 4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final Color itemColor = selected ? colors.primary : colors.textSecondary;

    return Expanded(
      child: InkResponse(
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedScale(
                scale: selected ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                child: Icon(
                  selected ? activeIcon : icon,
                  size: 22,
                  color: itemColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: itemColor,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterVoiceButton extends StatefulWidget {
  const _CenterVoiceButton({
    required this.selected,
    required this.onTap,
  });

  final bool selected;
  final VoidCallback onTap;

  @override
  State<_CenterVoiceButton> createState() => _CenterVoiceButtonState();
}

class _CenterVoiceButtonState extends State<_CenterVoiceButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (BuildContext context, Widget? child) {
          final double pulse = _pulseController.value;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: <Color>[
                  colors.primary,
                  colors.accent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.35 + 0.15 * pulse),
                  blurRadius: 10 + 4 * pulse,
                  spreadRadius: 1 + 2 * pulse,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.mic_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          );
        },
      ),
    );
  }
}
