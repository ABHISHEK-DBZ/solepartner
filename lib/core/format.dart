import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app/theme.dart';
import '../domain/enums.dart';
import '../domain/models.dart';

final DateFormat dayMonth = DateFormat('d MMM');
final DateFormat dayMonthYear = DateFormat('d MMM yyyy');
final DateFormat timeOfDay = DateFormat('h:mm a');
final DateFormat fullDateTime = DateFormat('d MMM yyyy, h:mm a');
final NumberFormat qtyFormat = NumberFormat('#,##0.###');

String friendlyDay(DateTime when) {
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime day = DateTime(when.year, when.month, when.day);
  final int diff = today.difference(day).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  if (diff < 7) return '$diff days ago';
  return dayMonth.format(when);
}

String friendlyTime(DateTime when) => timeOfDay.format(when);

String entryTitle(LedgerEntry entry) {
  if (entry.note.trim().isNotEmpty) return entry.note.trim();
  if (entry.customerName != null) return '${entry.kind.label} · ${entry.customerName}';
  if (entry.supplierName != null) {
    return '${entry.kind.label} · ${entry.supplierName}';
  }
  return entry.kind.label;
}

String entrySubtitle(LedgerEntry entry) {
  final String when = '${friendlyDay(entry.occurredAt)} · '
      '${timeOfDay.format(entry.occurredAt)}';
  final String method = entry.method.name.toUpperCase();
  return '$method · $when';
}

IconData iconForKind(TransactionKind kind) {
  switch (kind) {
    case TransactionKind.sale:
      return Icons.shopping_bag_outlined;
    case TransactionKind.income:
    case TransactionKind.cashReceived:
    case TransactionKind.bankTransferIn:
    case TransactionKind.upiReceived:
      return Icons.south_west;
    case TransactionKind.expense:
    case TransactionKind.bankTransferOut:
    case TransactionKind.upiPaid:
      return Icons.north_east;
    case TransactionKind.creditGiven:
      return Icons.handshake_outlined;
    case TransactionKind.creditRepayment:
      return Icons.check_circle_outline;
    case TransactionKind.purchasePayment:
      return Icons.local_shipping_outlined;
    case TransactionKind.solanaPayment:
      return Icons.bolt;
  }
}

Color colorForKind(TransactionKind kind) {
  if (kind == TransactionKind.creditGiven) return AppColors.gold;
  if (kind.isOutflow) return AppColors.danger;
  if (kind == TransactionKind.solanaPayment) return AppColors.ink;
  return AppColors.emerald;
}

String paymentMethodLabel(PaymentMethod method) {
  switch (method) {
    case PaymentMethod.cash:
      return 'Cash';
    case PaymentMethod.upi:
      return 'UPI';
    case PaymentMethod.bank:
      return 'Bank';
    case PaymentMethod.credit:
      return 'Credit';
    case PaymentMethod.solana:
      return 'Solana';
    case PaymentMethod.other:
      return 'Other';
  }
}

String qtyLabel(double value) => qtyFormat.format(value);

String shortAddress(String address) => address.length <= 10
    ? address
    : '${address.substring(0, 4)}…${address.substring(address.length - 4)}';

String initials(String name) {
  final List<String> parts =
      name.trim().split(RegExp(r'\s+')).where((String p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
      .toUpperCase();
}
