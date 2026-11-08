import 'package:intl/intl.dart';

/// All INR amounts in KhataCopilot are stored and computed as integer paise.
///
/// Floating point is never used for money. Foreign display concerns (symbols,
/// grouping) live here so every screen formats identically.
class Money {
  Money._();

  static const int paisePerRupee = 100;
  static const int lamportsPerSol = 1000000000;

  static final NumberFormat _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _inrWithPaise = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static final NumberFormat _grouped = NumberFormat.decimalPattern('en_IN');

  /// Formats paise for display. Paise are shown only when non-zero or when
  /// [showPaise] is true.
  static String format(
    int paise, {
    bool showSymbol = true,
    bool showPaise = false,
    bool signed = false,
  }) {
    final int value = signed ? paise : paise.abs();
    final bool hasPaise = value % paisePerRupee != 0;
    final String body = (showPaise || hasPaise)
        ? _inrWithPaise.format(value / paisePerRupee)
        : _inr.format(value / paisePerRupee);
    final String prefix = signed
        ? (paise < 0 ? '−' : '+')
        : (paise < 0 ? '−' : '');
    if (!showSymbol) {
      return '$prefix${body.replaceAll('₹', '').trim()}';
    }
    return '$prefix$body';
  }

  /// Short form used on dashboard tiles: ₹1.2L, ₹45.6K.
  static String compact(int paise) {
    final int abs = paise.abs();
    final String sign = paise < 0 ? '−' : '';
    if (abs >= 10000000 * paisePerRupee) {
      return '$sign₹${_trim(abs / (10000000 * paisePerRupee))}Cr';
    }
    if (abs >= 100000 * paisePerRupee) {
      return '$sign₹${_trim(abs / (100000 * paisePerRupee))}L';
    }
    if (abs >= 1000 * paisePerRupee) {
      return '$sign₹${_trim(abs / (1000 * paisePerRupee))}K';
    }
    return '$sign₹${_grouped.format(abs / paisePerRupee)}';
  }

  static String _trim(double value) {
    final String text = value.toStringAsFixed(value >= 100 ? 0 : 1);
    return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
  }

  static double toRupees(int paise) => paise / paisePerRupee;

  static int fromRupees(num rupees) => (rupees * paisePerRupee).round();

  /// Parses an amount from free text, including "₹1,250.50", "rs 500",
  /// "2k", "1.5 lakh". Returns null when no positive amount is found.
  static int? tryParsePaise(String input) {
    final String text = input.toLowerCase().replaceAll('₹', ' ').trim();
    final RegExp pattern = RegExp(
      r'(\d+(?:,\d{2,3})*(?:\.\d{1,2})?)\s*(k|thousand|hazar|hazaar|lakh|lac|cr|crore)?',
    );
    for (final RegExpMatch match in pattern.allMatches(text)) {
      final String digits = match.group(1)!.replaceAll(',', '');
      final double? base = double.tryParse(digits);
      if (base == null || base <= 0) continue;
      final String? unit = match.group(2);
      double multiplier = 1;
      switch (unit) {
        case 'k':
        case 'thousand':
        case 'hazar':
        case 'hazaar':
          multiplier = 1000;
          break;
        case 'lakh':
        case 'lac':
          multiplier = 100000;
          break;
        case 'cr':
        case 'crore':
          multiplier = 10000000;
          break;
        default:
          multiplier = 1;
      }
      final int paise = (base * multiplier * paisePerRupee).round();
      if (paise > 0) return paise;
    }
    return null;
  }

  /// Parses a plain decimal entered in a text field. Empty or invalid input
  /// yields null so callers can surface a validation message.
  static int? parseRupeeField(String? value) {
    if (value == null) return null;
    final String cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) return null;
    final double? rupees = double.tryParse(cleaned);
    if (rupees == null || rupees <= 0) return null;
    return (rupees * paisePerRupee).round();
  }

  static String rupeeFieldValue(int? paise) {
    if (paise == null) return '';
    if (paise % paisePerRupee == 0) {
      return (paise ~/ paisePerRupee).toString();
    }
    return (paise / paisePerRupee).toStringAsFixed(2);
  }

  // --- SOL / lamports -------------------------------------------------------

  static String formatSol(int lamports, {int maxDecimals = 4}) {
    final String raw = (lamports / lamportsPerSol).toStringAsFixed(9);
    String trimmed = raw.replaceFirst(RegExp(r'0+$'), '');
    if (trimmed.endsWith('.')) trimmed = trimmed.substring(0, trimmed.length - 1);
    final List<String> parts = trimmed.split('.');
    if (parts.length == 2 && parts[1].length > maxDecimals) {
      final String cut = parts[1].substring(0, maxDecimals);
      final String tail = parts[1].substring(maxDecimals);
      final bool roundUp = tail.isNotEmpty && int.parse(tail[0]) >= 5;
      int frac = int.parse(cut);
      if (roundUp) frac += 1;
      final String fracText = frac.toString().padLeft(maxDecimals, '0');
      return '${parts[0]}.$fracText';
    }
    return trimmed;
  }

  static String formatSolWithUnit(int lamports) =>
      '${formatSol(lamports)} SOL';

  static int? tryParseSol(String input) {
    final RegExpMatch? match =
        RegExp(r'(\d+(?:\.\d{1,9})?)').firstMatch(input);
    if (match == null) return null;
    final double? sol = double.tryParse(match.group(1)!);
    if (sol == null || sol <= 0) return null;
    return (sol * lamportsPerSol).round();
  }
}
