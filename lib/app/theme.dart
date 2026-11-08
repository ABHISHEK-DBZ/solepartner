import 'package:flutter/material.dart';

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.background,
    required this.surface,
    required this.elevatedSurface,
    required this.primary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.success,
    required this.warning,
    required this.error,
    required this.chipBackground,
    required this.glowColor,
    required this.gradientStart,
    required this.gradientEnd,
    required this.walletCardStart,
    required this.walletCardEnd,
  });

  final Color background;
  final Color surface;
  final Color elevatedSurface;
  final Color primary;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color success;
  final Color warning;
  final Color error;
  final Color chipBackground;
  final Color glowColor;
  final Color gradientStart;
  final Color gradientEnd;
  final Color walletCardStart;
  final Color walletCardEnd;

  static const AppThemeColors light = AppThemeColors(
    background: Color(0xFFF5F7FA),
    surface: Color(0xFFFFFFFF),
    elevatedSurface: Color(0xFFFFFFFF),
    primary: Color(0xFF087F5B),
    accent: Color(0xFF20B982),
    textPrimary: Color(0xFF172033),
    textSecondary: Color(0xFF758195),
    border: Color(0xFFE8ECF2),
    success: Color(0xFF16865D),
    warning: Color(0xFFE9A23B),
    error: Color(0xFFD94848),
    chipBackground: Color(0xFFEBF1F5),
    glowColor: Color(0x3320B982),
    gradientStart: Color(0xFF065F46),
    gradientEnd: Color(0xFF0F9D6E),
    walletCardStart: Color(0xFF0E1A2B),
    walletCardEnd: Color(0xFF1C2C42),
  );

  static const AppThemeColors dark = AppThemeColors(
    background: Color(0xFF0B1220),
    surface: Color(0xFF111C2D),
    elevatedSurface: Color(0xFF182536),
    primary: Color(0xFF20B982),
    accent: Color(0xFF54D6A5),
    textPrimary: Color(0xFFF4F7FB),
    textSecondary: Color(0xFFA2ADBD),
    border: Color(0xFF263548),
    success: Color(0xFF20B982),
    warning: Color(0xFFF59E0B),
    error: Color(0xFFEF4444),
    chipBackground: Color(0xFF182536),
    glowColor: Color(0x4420B982),
    gradientStart: Color(0xFF064E3B),
    gradientEnd: Color(0xFF047857),
    walletCardStart: Color(0xFF101B2B),
    walletCardEnd: Color(0xFF1E2D44),
  );

  @override
  AppThemeColors copyWith({
    Color? background,
    Color? surface,
    Color? elevatedSurface,
    Color? primary,
    Color? accent,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? success,
    Color? warning,
    Color? error,
    Color? chipBackground,
    Color? glowColor,
    Color? gradientStart,
    Color? gradientEnd,
    Color? walletCardStart,
    Color? walletCardEnd,
  }) {
    return AppThemeColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      elevatedSurface: elevatedSurface ?? this.elevatedSurface,
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      chipBackground: chipBackground ?? this.chipBackground,
      glowColor: glowColor ?? this.glowColor,
      gradientStart: gradientStart ?? this.gradientStart,
      gradientEnd: gradientEnd ?? this.gradientEnd,
      walletCardStart: walletCardStart ?? this.walletCardStart,
      walletCardEnd: walletCardEnd ?? this.walletCardEnd,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      elevatedSurface: Color.lerp(elevatedSurface, other.elevatedSurface, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      chipBackground: Color.lerp(chipBackground, other.chipBackground, t)!,
      glowColor: Color.lerp(glowColor, other.glowColor, t)!,
      gradientStart: Color.lerp(gradientStart, other.gradientStart, t)!,
      gradientEnd: Color.lerp(gradientEnd, other.gradientEnd, t)!,
      walletCardStart: Color.lerp(walletCardStart, other.walletCardStart, t)!,
      walletCardEnd: Color.lerp(walletCardEnd, other.walletCardEnd, t)!,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppThemeColors get appColors =>
      Theme.of(this).extension<AppThemeColors>() ?? AppThemeColors.light;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

class AppColors {
  AppColors._();

  // Backward compatible color aliases mapped to light theme tokens
  static const Color primaryLight = Color(0xFF087F5B);
  static const Color accentLight = Color(0xFF20B982);
  static const Color bgLight = Color(0xFFF5F7FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF172033);
  static const Color textSecondaryLight = Color(0xFF758195);
  static const Color borderLight = Color(0xFFE8ECF2);

  // Common legacy names
  static const Color ink = Color(0xFF172033);
  static const Color inkSoft = Color(0xFF758195);
  static const Color inkFaint = Color(0xFFA0ABBB);
  static const Color gold = Color(0xFFE9A23B);
  static const Color goldSoft = Color(0xFFFDF4E6);
  static const Color emerald = Color(0xFF087F5B);
  static const Color emeraldSoft = Color(0xFFE6F7F0);
  static const Color danger = Color(0xFFD94848);
  static const Color dangerSoft = Color(0xFFFCE8E8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color canvas = Color(0xFFF5F7FA);
  static const Color line = Color(0xFFE8ECF2);
  static const Color chip = Color(0xFFEEF2F6);
  static const Color positive = Color(0xFF16865D);
  static const Color positiveSoft = Color(0xFFE6F7F0);
  static const Color warning = Color(0xFFE9A23B);
  static const Color warningSoft = Color(0xFFFDF4E6);
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    const AppThemeColors custom = AppThemeColors.light;
    final ColorScheme scheme = ColorScheme(
      brightness: Brightness.light,
      primary: custom.primary,
      onPrimary: Colors.white,
      primaryContainer: custom.chipBackground,
      onPrimaryContainer: custom.primary,
      secondary: custom.accent,
      onSecondary: Colors.white,
      secondaryContainer: custom.chipBackground,
      onSecondaryContainer: custom.textPrimary,
      tertiary: custom.accent,
      onTertiary: Colors.white,
      error: custom.error,
      onError: Colors.white,
      surface: custom.surface,
      onSurface: custom.textPrimary,
      onSurfaceVariant: custom.textSecondary,
      outline: custom.border,
      outlineVariant: custom.border,
      shadow: const Color(0x0C172033),
      scrim: const Color(0x40000000),
      inverseSurface: custom.textPrimary,
      onInverseSurface: Colors.white,
      inversePrimary: custom.accent,
    );

    return _buildTheme(scheme, custom);
  }

  static ThemeData dark() {
    const AppThemeColors custom = AppThemeColors.dark;
    final ColorScheme scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: custom.primary,
      onPrimary: const Color(0xFF0B1220),
      primaryContainer: custom.elevatedSurface,
      onPrimaryContainer: custom.primary,
      secondary: custom.accent,
      onSecondary: const Color(0xFF0B1220),
      secondaryContainer: custom.elevatedSurface,
      onSecondaryContainer: custom.textPrimary,
      tertiary: custom.accent,
      onTertiary: const Color(0xFF0B1220),
      error: custom.error,
      onError: Colors.white,
      surface: custom.surface,
      onSurface: custom.textPrimary,
      onSurfaceVariant: custom.textSecondary,
      outline: custom.border,
      outlineVariant: custom.border,
      shadow: const Color(0x33000000),
      scrim: const Color(0x80000000),
      inverseSurface: custom.textPrimary,
      onInverseSurface: const Color(0xFF0B1220),
      inversePrimary: custom.primary,
    );

    return _buildTheme(scheme, custom);
  }

  static ThemeData _buildTheme(ColorScheme scheme, AppThemeColors custom) {
    final TextTheme baseText = scheme.brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;

    final TextTheme text = baseText.apply(
      bodyColor: custom.textPrimary,
      displayColor: custom.textPrimary,
      fontFamily: 'Inter',
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: custom.background,
      extensions: <ThemeExtension<dynamic>>[custom],
      textTheme: text.copyWith(
        displaySmall: text.displaySmall?.copyWith(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.0,
          height: 1.15,
          fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
        ),
        headlineMedium: text.headlineMedium?.copyWith(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.6,
          height: 1.2,
        ),
        headlineSmall: text.headlineSmall?.copyWith(
          fontSize: 21,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
        titleLarge: text.titleLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
        titleMedium: text.titleMedium?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: text.bodyLarge?.copyWith(
          fontSize: 15,
          height: 1.45,
          color: custom.textPrimary,
        ),
        bodyMedium: text.bodyMedium?.copyWith(
          fontSize: 14,
          height: 1.45,
          color: custom.textPrimary,
        ),
        bodySmall: text.bodySmall?.copyWith(
          fontSize: 12.5,
          color: custom.textSecondary,
        ),
        labelLarge: text.labelLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        labelSmall: text.labelSmall?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: custom.textSecondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: custom.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: custom.textPrimary,
          fontSize: 19,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: custom.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: custom.border, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: custom.border,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: custom.primary,
          foregroundColor: scheme.brightness == Brightness.dark ? const Color(0xFF0B1220) : Colors.white,
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: custom.textPrimary,
          minimumSize: const Size(0, 50),
          side: BorderSide(color: custom.border, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: custom.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: custom.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        hintStyle: TextStyle(color: custom.textSecondary.withValues(alpha: 0.8), fontSize: 14),
        labelStyle: TextStyle(color: custom.textSecondary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: custom.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: custom.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: custom.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: custom.error),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: custom.surface,
        contentTextStyle: TextStyle(color: custom.textPrimary, fontSize: 14),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: custom.border),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: custom.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: custom.chipBackground,
        selectedColor: custom.primary,
        side: BorderSide.none,
        labelStyle: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: custom.textPrimary,
        ),
        secondaryLabelStyle: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: scheme.brightness == Brightness.dark ? const Color(0xFF0B1220) : Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: custom.textSecondary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: custom.primary,
      ),
    );
  }

  // Legacy default builder fallback
  static ThemeData build() => light();
}
