import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../money.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.color,
    this.borderColor,
    this.borderRadius = 20,
    this.shadow,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final double borderRadius;
  final List<BoxShadow>? shadow;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final Widget content = Padding(padding: padding, child: child);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadow ??
            <BoxShadow>[
              BoxShadow(
                color: colors.border.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      child: Material(
        color: color ?? colors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? colors.border,
                width: 1,
              ),
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.padding = const EdgeInsets.only(bottom: 12, top: 8),
  });

  final String title;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    letterSpacing: -0.3,
                  ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

enum StatTone { neutral, positive, negative, gold }

class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.caption,
    this.icon,
    this.tone = StatTone.neutral,
    this.onTap,
    this.trend,
  });

  final String label;
  final String value;
  final String? caption;
  final IconData? icon;
  final StatTone tone;
  final VoidCallback? onTap;
  final String? trend;

  Color _accent(AppThemeColors colors) {
    switch (tone) {
      case StatTone.positive:
        return colors.success;
      case StatTone.negative:
        return colors.error;
      case StatTone.gold:
        return colors.warning;
      case StatTone.neutral:
        return colors.textPrimary;
    }
  }

  Color _bg(AppThemeColors colors) {
    switch (tone) {
      case StatTone.positive:
        return colors.success.withValues(alpha: 0.12);
      case StatTone.negative:
        return colors.error.withValues(alpha: 0.12);
      case StatTone.gold:
        return colors.warning.withValues(alpha: 0.12);
      case StatTone.neutral:
        return colors.chipBackground;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final Color accentColor = _accent(colors);

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _bg(colors),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: accentColor),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.textSecondary,
                        letterSpacing: 0.8,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    trend!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: colors.success,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.6,
                color: colors.textPrimary,
                fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
              ),
            ),
          ),
          if (caption != null) ...<Widget>[
            const SizedBox(height: 5),
            Text(
              caption!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.color,
    this.background,
    this.icon,
  });

  final String label;
  final Color? color;
  final Color? background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    final Color textColor = color ?? colors.textSecondary;
    final Color bgColor = background ?? colors.chipBackground;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: colors.chipBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: colors.primary, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
            ),
            if (action != null) ...<Widget>[
              const SizedBox(height: 18),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    super.key,
    required this.value,
    required this.builder,
    this.loading,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: builder,
      loading: () =>
          loading ??
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2.2),
              ),
            ),
          ),
      error: (Object error, StackTrace stack) => EmptyState(
        icon: Icons.error_outline,
        title: 'Could not load data',
        message: error.toString(),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.onTap,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoneyText extends StatelessWidget {
  const MoneyText(
    this.paise, {
    super.key,
    this.fontSize = 15,
    this.weight = FontWeight.w600,
    this.color,
    this.signed = false,
    this.showPaise = false,
  });

  final int paise;
  final double fontSize;
  final FontWeight weight;
  final Color? color;
  final bool signed;
  final bool showPaise;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;
    return Text(
      Money.format(paise, signed: signed, showPaise: showPaise),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: weight,
        color: color ?? colors.textPrimary,
        letterSpacing: -0.2,
        fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
      ),
    );
  }
}

class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.child,
    this.hint,
  });

  final String label;
  final Widget child;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colors.textSecondary,
                letterSpacing: 0.8,
              ),
        ),
        const SizedBox(height: 7),
        child,
        if (hint != null) ...<Widget>[
          const SizedBox(height: 6),
          Text(
            hint!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.hint,
    required this.onChanged,
    this.controller,
    this.trailing,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: TextStyle(color: colors.textPrimary, fontSize: 14.5),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          Icons.search,
          size: 20,
          color: colors.textSecondary,
        ),
        suffixIcon: trailing,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
        fillColor: colors.surface,
      ),
    );
  }
}

class AmountField extends StatelessWidget {
  const AmountField({
    super.key,
    required this.controller,
    this.label = 'Amount',
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String label;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return LabeledField(
      label: label,
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        ],
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          color: colors.textPrimary,
          fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
        ),
        decoration: InputDecoration(
          prefixText: '₹ ',
          prefixStyle: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

void showError(BuildContext context, Object error) {
  final AppThemeColors colors = context.appColors;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        error.toString().replaceAll('Exception: ', ''),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      backgroundColor: colors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

void showMessage(BuildContext context, String message) {
  final AppThemeColors colors = context.appColors;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w500),
      ),
      backgroundColor: colors.surface,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.border),
      ),
    ),
  );
}

Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  bool destructive = false,
}) async {
  final AppThemeColors colors = context.appColors;

  final bool? result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: Text(title, style: TextStyle(color: colors.textPrimary)),
      content: Text(message, style: TextStyle(color: colors.textSecondary)),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(backgroundColor: colors.error)
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}
