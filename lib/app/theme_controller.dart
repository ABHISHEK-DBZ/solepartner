import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme.dart';

const String _kThemePrefKey = 'khatacopilot_theme_mode';

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? saved = prefs.getString(_kThemePrefKey);
      if (saved == 'dark') {
        state = ThemeMode.dark;
      } else if (saved == 'light') {
        state = ThemeMode.light;
      } else {
        state = ThemeMode.system;
      }
    } catch (_) {
      // Fallback to system on error
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (mode == ThemeMode.dark) {
        await prefs.setString(_kThemePrefKey, 'dark');
      } else if (mode == ThemeMode.light) {
        await prefs.setString(_kThemePrefKey, 'light');
      } else {
        await prefs.setString(_kThemePrefKey, 'system');
      }
    } catch (_) {}
  }

  void toggle() {
    HapticFeedback.lightImpact();
    if (state == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }
}

final StateNotifierProvider<ThemeModeController, ThemeMode>
    themeModeProvider = StateNotifierProvider<ThemeModeController, ThemeMode>(
  (ref) => ThemeModeController(),
);

/// A widget that performs a smooth 400ms animated color interpolation
/// across light and dark theme changes, eliminating sudden flashes.
class AnimatedThemeTransition extends StatelessWidget {
  const AnimatedThemeTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AnimatedTheme(
      data: theme,
      duration: duration,
      curve: Curves.easeInOutCubic,
      child: child,
    );
  }
}

/// A button that animates between sun and moon icon with smooth rotation,
/// scale, and color transition.
class AnimatedThemeToggle extends StatelessWidget {
  const AnimatedThemeToggle({
    super.key,
    this.size = 20,
    this.padding = const EdgeInsets.all(8),
  });

  final double size;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, _) {
        final ThemeMode mode = ref.watch(themeModeProvider);
        final bool isDark = mode == ThemeMode.dark ||
            (mode == ThemeMode.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);

        final AppThemeColors colors = context.appColors;

        return Tooltip(
          message: isDark ? 'Switch to light mode' : 'Switch to dark mode',
          child: InkWell(
            onTap: () => ref.read(themeModeProvider.notifier).toggle(),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.border),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colors.border.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 420),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return RotationTransition(
                    turns: Tween<double>(begin: 0.75, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutBack,
                      ),
                    ),
                    child: ScaleTransition(
                      scale: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                      child: child,
                    ),
                  );
                },
                child: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  key: ValueKey<bool>(isDark),
                  size: size,
                  color: isDark ? const Color(0xFFFBBF24) : colors.textPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
