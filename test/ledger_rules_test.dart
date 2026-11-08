import 'package:flutter_test/flutter_test.dart';
import 'package:khatacopilot/domain/enums.dart';
import 'package:khatacopilot/domain/models.dart';
import 'package:khatacopilot/domain/rules/ledger_rules.dart';

LedgerEntry entry({
  required int id,
  required TransactionKind kind,
  required int amount,
  required int cash,
  int credit = 0,
  required DateTime at,
  bool isReversed = false,
  int? reversalOfId,
}) {
  return LedgerEntry(
    id: id,
    kind: kind,
    amountPaise: amount,
    cashDeltaPaise: cash,
    creditDeltaPaise: credit,
    method: PaymentMethod.cash,
    note: '',
    source: EntrySource.manual,
    occurredAt: at,
    isReversed: isReversed,
    reversalOfId: reversalOfId,
  );
}

void main() {
  test('reversal nets sales and cash to zero', () {
    final DateTime now = DateTime(2026, 1, 10, 12);
    final DashboardSummary summary = LedgerRules.summarise(
      entries: <LedgerEntry>[
        entry(
          id: 1,
          kind: TransactionKind.sale,
          amount: 10000,
          cash: 10000,
          at: now.subtract(const Duration(hours: 1)),
          isReversed: true,
        ),
        entry(
          id: 2,
          kind: TransactionKind.sale,
          amount: 10000,
          cash: -10000,
          at: now,
          reversalOfId: 1,
        ),
      ],
      products: const <ProductView>[],
      customers: const <CustomerView>[],
      now: now,
    );

    expect(summary.todaySalesPaise, 0);
    expect(summary.weekSalesPaise, 0);
    expect(summary.todayCashInPaise, 10000);
    expect(summary.todayCashOutPaise, 10000);
    expect(summary.netCashMovementPaise, 0);
  });

  test('reversal nets outstanding credit to zero', () {
    final DateTime now = DateTime(2026, 1, 10, 12);
    final DashboardSummary summary = LedgerRules.summarise(
      entries: <LedgerEntry>[
        entry(
          id: 1,
          kind: TransactionKind.creditGiven,
          amount: 5000,
          cash: 0,
          credit: 5000,
          at: now,
          isReversed: true,
        ),
        entry(
          id: 2,
          kind: TransactionKind.creditGiven,
          amount: 5000,
          cash: 0,
          credit: -5000,
          at: now,
          reversalOfId: 1,
        ),
      ],
      products: const <ProductView>[],
      customers: const <CustomerView>[],
      now: now,
    );

    expect(summary.outstandingCreditPaise, 0);
  });

  test('credit purchase payment does not move cash', () {
    final LedgerDelta delta = LedgerRules.deltasFor(
      kind: TransactionKind.purchasePayment,
      amountPaise: 5000,
      method: PaymentMethod.credit,
    );
    expect(delta.cashPaise, 0);
    expect(delta.creditPaise, 0);
  });
}
