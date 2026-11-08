import '../enums.dart';
import '../models.dart';

/// The only place where a business event turns into cash and credit effects.
///
/// Both values are stored with the transaction so history stays explainable
/// even if these rules change later.
class LedgerDelta {
  const LedgerDelta({required this.cashPaise, required this.creditPaise});

  final int cashPaise;
  final int creditPaise;

  bool get isNoOp => cashPaise == 0 && creditPaise == 0;
}

class LedgerRules {
  LedgerRules._();

  static LedgerDelta deltasFor({
    required TransactionKind kind,
    required int amountPaise,
    required PaymentMethod method,
  }) {
    assert(amountPaise > 0, 'Ledger amounts must be positive');
    switch (kind) {
      case TransactionKind.sale:
        return method == PaymentMethod.credit
            ? LedgerDelta(cashPaise: 0, creditPaise: amountPaise)
            : LedgerDelta(cashPaise: amountPaise, creditPaise: 0);
      case TransactionKind.income:
      case TransactionKind.cashReceived:
      case TransactionKind.bankTransferIn:
      case TransactionKind.upiReceived:
        return LedgerDelta(cashPaise: amountPaise, creditPaise: 0);
      case TransactionKind.expense:
      case TransactionKind.bankTransferOut:
      case TransactionKind.upiPaid:
        return LedgerDelta(cashPaise: -amountPaise, creditPaise: 0);
      case TransactionKind.purchasePayment:
        // A credit purchase payment does not move cash; it only settles the
        // supplier payable, which is tracked on the purchase row.
        return method == PaymentMethod.credit
            ? const LedgerDelta(cashPaise: 0, creditPaise: 0)
            : LedgerDelta(cashPaise: -amountPaise, creditPaise: 0);
      case TransactionKind.solanaPayment:
        return LedgerDelta(cashPaise: -amountPaise, creditPaise: 0);
      case TransactionKind.creditGiven:
        return LedgerDelta(cashPaise: 0, creditPaise: amountPaise);
      case TransactionKind.creditRepayment:
        return LedgerDelta(cashPaise: amountPaise, creditPaise: -amountPaise);
    }
  }

  /// Cash-positive kinds used for the "money in" tile.
  static const Set<TransactionKind> inflowKinds = {
    TransactionKind.sale,
    TransactionKind.income,
    TransactionKind.cashReceived,
    TransactionKind.creditRepayment,
    TransactionKind.bankTransferIn,
    TransactionKind.upiReceived,
  };

  static const Set<TransactionKind> outflowKinds = {
    TransactionKind.expense,
    TransactionKind.bankTransferOut,
    TransactionKind.upiPaid,
    TransactionKind.purchasePayment,
    TransactionKind.solanaPayment,
  };

  static bool isSaleLike(TransactionKind kind) =>
      kind == TransactionKind.sale;

  static bool isExpenseLike(TransactionKind kind) =>
      kind == TransactionKind.expense ||
      kind == TransactionKind.upiPaid ||
      kind == TransactionKind.bankTransferOut;

  /// Cash and credit totals for a time window. Reversed entries are excluded
  /// by the caller before this is called.
  static DashboardSummary summarise({
    required List<LedgerEntry> entries,
    required List<ProductView> products,
    required List<CustomerView> customers,
    required DateTime now,
  }) {
    final DateTime todayStart = DateTime(now.year, now.month, now.day);
    final DateTime weekStart = todayStart.subtract(const Duration(days: 6));

    int todaySales = 0;
    int todayExpenses = 0;
    int todayCashIn = 0;
    int todayCashOut = 0;
    int weekSales = 0;
    int weekExpenses = 0;
    int outstanding = 0;

    for (final LedgerEntry entry in entries) {
      // Cash and credit deltas always count: an original and its compensating
      // reversal must net to zero. Only the amount totals below skip rows.
      outstanding += entry.creditDeltaPaise;
      final bool isReversal = entry.reversalOfId != null;
      final bool isToday = !entry.occurredAt.isBefore(todayStart);
      final bool inWeek = !entry.occurredAt.isBefore(weekStart);
      if (isToday) {
        if (!isReversal && !entry.isReversed && isSaleLike(entry.kind)) {
          todaySales += entry.amountPaise;
        }
        if (!isReversal && !entry.isReversed && isExpenseLike(entry.kind)) {
          todayExpenses += entry.amountPaise;
        }
        if (entry.cashDeltaPaise > 0) todayCashIn += entry.cashDeltaPaise;
        if (entry.cashDeltaPaise < 0) todayCashOut += -entry.cashDeltaPaise;
      }
      if (inWeek) {
        if (!isReversal && !entry.isReversed && isSaleLike(entry.kind)) {
          weekSales += entry.amountPaise;
        }
        if (!isReversal && !entry.isReversed && isExpenseLike(entry.kind)) {
          weekExpenses += entry.amountPaise;
        }
      }
    }

    final List<ProductView> lowStock = products
        .where((ProductView p) => !p.archived && p.isLowStock)
        .toList()
      ..sort((ProductView a, ProductView b) =>
          a.stockQty.compareTo(b.stockQty));

    final int inventoryValue = products
        .where((ProductView p) => !p.archived)
        .fold(0, (int sum, ProductView p) => sum + p.stockValuePaise);

    final List<LedgerEntry> recent = entries
        .where((LedgerEntry e) => !e.isReversed)
        .toList()
      ..sort((LedgerEntry a, LedgerEntry b) =>
          b.occurredAt.compareTo(a.occurredAt));

    return DashboardSummary(
      todaySalesPaise: todaySales,
      todayExpensesPaise: todayExpenses,
      todayCashInPaise: todayCashIn,
      todayCashOutPaise: todayCashOut,
      outstandingCreditPaise: outstanding < 0 ? 0 : outstanding,
      inventoryValuePaise: inventoryValue,
      lowStockCount: lowStock.length,
      lowStockProducts: lowStock.take(5).toList(),
      recentEntries: recent.take(6).toList(),
      customersWithDues:
          customers.where((CustomerView c) => c.outstandingPaise > 0).length,
      weekSalesPaise: weekSales,
      weekExpensesPaise: weekExpenses,
    );
  }

  /// Outstanding balance for one customer, floored at zero.
  static int customerOutstanding(List<LedgerEntry> entries, int customerId) {
    int total = 0;
    for (final LedgerEntry entry in entries) {
      if (entry.customerId != customerId || entry.isReversed) continue;
      total += entry.creditDeltaPaise;
    }
    return total < 0 ? 0 : total;
  }

  /// Credit older than [days] that has not been repaid. Deterministic FIFO
  /// approximation: old credits minus old repayments.
  static int overdueFor(
    List<LedgerEntry> entries,
    int customerId,
    DateTime now, {
    int days = 30,
  }) {
    final DateTime cutoff = now.subtract(Duration(days: days));
    int given = 0;
    int repaid = 0;
    for (final LedgerEntry entry in entries) {
      if (entry.customerId != customerId || entry.isReversed) continue;
      if (entry.occurredAt.isAfter(cutoff)) continue;
      if (entry.creditDeltaPaise > 0) given += entry.creditDeltaPaise;
      if (entry.creditDeltaPaise < 0) repaid += -entry.creditDeltaPaise;
    }
    final int overdue = given - repaid;
    return overdue < 0 ? 0 : overdue;
  }

  /// Balance per customer from all entries.
  static Map<int, int> outstandingByCustomer(List<LedgerEntry> entries) {
    final Map<int, int> totals = <int, int>{};
    for (final LedgerEntry entry in entries) {
      final int? id = entry.customerId;
      if (id == null || entry.isReversed) continue;
      totals[id] = (totals[id] ?? 0) + entry.creditDeltaPaise;
    }
    totals.removeWhere((int _, int value) => value <= 0);
    return totals;
  }
}
