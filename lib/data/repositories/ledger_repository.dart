import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

import '../../core/money.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';
import '../../domain/rules/ledger_rules.dart';
import '../db/app_database.dart';
import '../mappers.dart';
import 'inventory_repository.dart';

class LedgerException implements Exception {
  LedgerException(this.message);
  final String message;
  @override
  String toString() => message;
}

class SaleLineInput {
  const SaleLineInput({
    required this.productId,
    required this.quantity,
    required this.unitPricePaise,
    required this.unitCostPaise,
  });

  final int productId;
  final double quantity;
  final int unitPricePaise;
  final int unitCostPaise;
}

class LedgerRepository {
  LedgerRepository(this._db, this._inventory);

  final AppDatabase _db;
  final InventoryRepository _inventory;

  static final DateFormat _dayFormat = DateFormat('yyyy-MM-dd');

  // --- Reads ---------------------------------------------------------------

  Stream<List<LedgerEntry>> watchEntries({
    DateTime? from,
    DateTime? to,
    int? customerId,
    int? supplierId,
    String query = '',
    int limit = 500,
    bool includeReversals = true,
  }) {
    final joined = _db.select(_db.transactions).join(<Join<HasResultSet, dynamic>>[
      leftOuterJoin(
        _db.customers,
        _db.customers.id.equalsExp(_db.transactions.customerId),
      ),
      leftOuterJoin(
        _db.suppliers,
        _db.suppliers.id.equalsExp(_db.transactions.supplierId),
      ),
    ]);

    if (from != null) {
      joined.where(_db.transactions.occurredAt.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      joined.where(_db.transactions.occurredAt.isSmallerThanValue(to));
    }
    if (customerId != null) {
      joined.where(_db.transactions.customerId.equals(customerId));
    }
    if (supplierId != null) {
      joined.where(_db.transactions.supplierId.equals(supplierId));
    }
    final String search = query.trim();
    if (search.isNotEmpty) {
      joined.where(
        _db.transactions.note.like('%$search%') |
            _db.customers.name.like('%$search%') |
            _db.suppliers.name.like('%$search%'),
      );
    }
    if (!includeReversals) {
      joined.where(_db.transactions.reversalOfId.isNull());
    }
    joined
      ..orderBy(<OrderingTerm>[
        OrderingTerm.desc(_db.transactions.occurredAt),
        OrderingTerm.desc(_db.transactions.id),
      ])
      ..limit(limit);

    return _stream(joined);
  }

  Stream<List<LedgerEntry>> _stream(
    JoinedSelectStatement<HasResultSet, dynamic> joined,
  ) {
    return joined.watch().map((List<TypedResult> results) {
      return results.map((TypedResult row) {
        final Transaction txn = row.readTable(_db.transactions);
        return ledgerEntryFrom(
          txn,
          customerName: row.readTableOrNull(_db.customers)?.name,
          supplierName: row.readTableOrNull(_db.suppliers)?.name,
        );
      }).toList();
    });
  }

  Stream<List<LedgerEntry>> watchCustomerEntries(int customerId) =>
      watchEntries(customerId: customerId, limit: 500);

  Stream<List<LedgerEntry>> watchSupplierEntries(int supplierId) =>
      watchEntries(supplierId: supplierId, limit: 500);

  Future<List<LedgerEntry>> entriesBetween(DateTime from, DateTime to) async {
    final rows = await (_db.select(_db.transactions)
          ..where((t) =>
              t.occurredAt.isBiggerOrEqualValue(from) &
              t.occurredAt.isSmallerThanValue(to))
          ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]))
        .get();
    return rows.map((row) => ledgerEntryFrom(row)).toList();
  }

  Future<LedgerEntry?> findEntry(int id) async {
    final joined = _db.select(_db.transactions).join(<Join<HasResultSet, dynamic>>[
      leftOuterJoin(
          _db.customers, _db.customers.id.equalsExp(_db.transactions.customerId)),
      leftOuterJoin(
          _db.suppliers, _db.suppliers.id.equalsExp(_db.transactions.supplierId)),
    ])
      ..where(_db.transactions.id.equals(id));
    final TypedResult? row = await joined.getSingleOrNull();
    if (row == null) return null;
    final Transaction txn = row.readTable(_db.transactions);
    return ledgerEntryFrom(
      txn,
      customerName: row.readTableOrNull(_db.customers)?.name,
      supplierName: row.readTableOrNull(_db.suppliers)?.name,
      lines: await linesFor(id),
    );
  }

  Future<List<LedgerLine>> linesFor(int transactionId) async {
    final query = _db.select(_db.transactionLines).join(<Join<HasResultSet, dynamic>>[
      innerJoin(_db.products,
          _db.products.id.equalsExp(_db.transactionLines.productId)),
    ])
      ..where(_db.transactionLines.transactionId.equals(transactionId));
    final List<TypedResult> rows = await query.get();
    return rows.map((TypedResult row) {
      final TransactionLine line = row.readTable(_db.transactionLines);
      final Product product = row.readTable(_db.products);
      return LedgerLine(
        productId: line.productId,
        productName: product.name,
        quantity: line.quantity,
        unitPricePaise: line.unitPricePaise,
        unitCostPaise: line.unitCostPaise,
      );
    }).toList();
  }

  Future<List<LedgerEntry>> allEntries({int limit = 5000}) async {
    final rows = await (_db.select(_db.transactions)
          ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)])
          ..limit(limit))
        .get();
    return rows.map((row) => ledgerEntryFrom(row)).toList();
  }

  // --- Writes --------------------------------------------------------------

  /// Records a ledger entry. Stock lines are only used by sales.
  Future<int> recordEntry({
    required TransactionKind kind,
    required int amountPaise,
    required PaymentMethod method,
    int? customerId,
    int? supplierId,
    String note = '',
    DateTime? occurredAt,
    EntrySource source = EntrySource.manual,
    List<SaleLineInput> lines = const <SaleLineInput>[],
    String? externalRef,
  }) async {
    if (amountPaise <= 0) {
      throw LedgerException('Amount must be greater than zero.');
    }
    if (kind == TransactionKind.creditGiven ||
        kind == TransactionKind.creditRepayment) {
      if (customerId == null) {
        throw LedgerException('Choose a customer for this credit entry.');
      }
    }
    if (kind == TransactionKind.purchasePayment && supplierId == null) {
      throw LedgerException('Choose a supplier for this payment.');
    }
    if (lines.isNotEmpty && kind != TransactionKind.sale) {
      throw LedgerException('Only sales can carry product lines.');
    }

    final LedgerDelta delta = LedgerRules.deltasFor(
      kind: kind,
      amountPaise: amountPaise,
      method: method,
    );
    final DateTime when = occurredAt ?? DateTime.now();

    return _db.transaction(() async {
      int? customer = customerId;
      if (customerId != null) {
        final Customer? row = await (_db.select(_db.customers)
              ..where((c) => c.id.equals(customerId)))
            .getSingleOrNull();
        if (row == null) throw LedgerException('Customer not found.');
        customer = row.id;
      }

      final int id = await _db.into(_db.transactions).insert(
            TransactionsCompanion.insert(
              kind: kind,
              amountPaise: amountPaise,
              cashDeltaPaise: delta.cashPaise,
              creditDeltaPaise: delta.creditPaise,
              customerId: Value(customer),
              supplierId: Value(supplierId),
              method: method,
              note: note.trim(),
              source: source,
              externalRef: Value(externalRef),
              occurredAt: when,
              createdAt: DateTime.now(),
            ),
          );

      if (lines.isNotEmpty) {
        for (final SaleLineInput line in lines) {
          if (line.quantity <= 0) {
            throw LedgerException('Line quantity must be greater than zero.');
          }
          await _db.into(_db.transactionLines).insert(
                TransactionLinesCompanion.insert(
                  transactionId: id,
                  productId: line.productId,
                  quantity: InventoryRepository.roundQty(line.quantity),
                  unitPricePaise: line.unitPricePaise,
                  unitCostPaise: line.unitCostPaise,
                ),
              );
          await _inventory.applyStockMovement(
            productId: line.productId,
            quantityDelta: -line.quantity,
            kind: StockMovementKind.sale,
            reason: 'Sale #$id',
            unitCostPaise: line.unitCostPaise,
            referenceType: 'transaction',
            referenceId: id,
          );
        }
      }

      await _audit('transaction', id, 'recorded', <String, Object?>{
        'kind': kind.name,
        'amountPaise': amountPaise,
        'method': method.name,
        'customerId': customer,
        'source': source.name,
      });
      return id;
    });
  }

  /// Records the settlement of an already-verified Solana transfer.
  ///
  /// SOL is a separate asset from shop cash, so this entry carries no cash
  /// delta. [inrMemoPaise] is the merchant's own optional valuation and is
  /// never derived from a price feed.
  Future<int> recordSolanaSettlement({
    required int amountLamports,
    required int inrMemoPaise,
    required String signature,
    required String recipientName,
    required String recipientAddress,
  }) async {
    final Transaction? existing = await (_db.select(_db.transactions)
          ..where((t) => t.externalRef.equals(signature))
          ..limit(1))
        .getSingleOrNull();
    if (existing != null) return existing.id;

    final String note = '${Money.formatSolWithUnit(amountLamports)} to '
        '${recipientName.isEmpty ? _shortAddress(recipientAddress) : recipientName}'
        '${inrMemoPaise > 0 ? ' (recorded as ${Money.format(inrMemoPaise)})' : ''}';

    return _db.transaction(() async {
      final int id = await _db.into(_db.transactions).insert(
            TransactionsCompanion.insert(
              kind: TransactionKind.solanaPayment,
              amountPaise: inrMemoPaise,
              cashDeltaPaise: 0,
              creditDeltaPaise: 0,
              method: PaymentMethod.solana,
              note: note,
              source: EntrySource.payment,
              externalRef: Value(signature),
              occurredAt: DateTime.now(),
              createdAt: DateTime.now(),
            ),
          );
      await _audit('transaction', id, 'solana_settled', <String, Object?>{
        'signature': signature,
        'lamports': amountLamports,
      });
      return id;
    });
  }

  static String _shortAddress(String address) => address.length <= 8
      ? address
      : '${address.substring(0, 4)}…${address.substring(address.length - 4)}';

  /// Reverses an entry by posting a compensating entry. Nothing is deleted.
  Future<int> reverseEntry(int id, {String reason = ''}) async {
    return _db.transaction(() async {
      final Transaction? original = await (_db.select(_db.transactions)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      if (original == null) throw LedgerException('Entry not found.');
      if (original.isReversed) {
        throw LedgerException('This entry is already reversed.');
      }
      if (original.reversalOfId != null) {
        throw LedgerException('A reversal entry cannot be reversed.');
      }

      final List<LedgerLine> lines = await linesFor(id);
      for (final LedgerLine line in lines) {
        await _inventory.applyStockMovement(
          productId: line.productId,
          quantityDelta: line.quantity,
          kind: StockMovementKind.returnIn,
          reason: 'Reversal of #$id',
          unitCostPaise: line.unitCostPaise,
          referenceType: 'transaction',
          referenceId: id,
        );
      }

      final int reversalId = await _db.into(_db.transactions).insert(
            TransactionsCompanion.insert(
              kind: original.kind,
              amountPaise: original.amountPaise,
              cashDeltaPaise: -original.cashDeltaPaise,
              creditDeltaPaise: -original.creditDeltaPaise,
              customerId: Value(original.customerId),
              supplierId: Value(original.supplierId),
              method: original.method,
              note: reason.trim().isEmpty
                  ? 'Reversal of #$id'
                  : 'Reversal of #$id: ${reason.trim()}',
              source: EntrySource.manual,
              externalRef: Value(original.externalRef),
              occurredAt: DateTime.now(),
              createdAt: DateTime.now(),
              reversalOfId: Value(id),
            ),
          );

      await (_db.update(_db.transactions)
            ..where((t) => t.id.equals(id)))
          .write(const TransactionsCompanion(isReversed: Value(true)));

      await _audit('transaction', id, 'reversed', <String, Object?>{
        'reversalId': reversalId,
        'reason': reason,
      });
      return reversalId;
    });
  }

  /// Pays a supplier, allocating the amount to open purchases oldest first.
  Future<int> paySupplier({
    required int supplierId,
    required int amountPaise,
    required PaymentMethod method,
    String note = '',
  }) async {
    if (amountPaise <= 0) {
      throw LedgerException('Amount must be greater than zero.');
    }
    if (method == PaymentMethod.credit) {
      throw LedgerException('Choose cash, UPI or bank for a payment.');
    }

    return _db.transaction(() async {
      final List<Purchase> purchases = await (_db.select(_db.purchases)
            ..where((p) => p.supplierId.equals(supplierId))
            ..orderBy([(p) => OrderingTerm.asc(p.occurredAt)]))
          .get();

      int due = 0;
      for (final Purchase purchase in purchases) {
        due += purchase.totalPaise - purchase.paidPaise;
      }
      if (amountPaise > due) {
        throw LedgerException(
          'Amount is more than the outstanding payable '
          '(${Money.format(due)}).',
        );
      }

      int remaining = amountPaise;
      for (final Purchase purchase in purchases) {
        if (remaining <= 0) break;
        final int open = purchase.totalPaise - purchase.paidPaise;
        if (open <= 0) continue;
        final int apply = open < remaining ? open : remaining;
        await (_db.update(_db.purchases)
              ..where((p) => p.id.equals(purchase.id)))
            .write(PurchasesCompanion(
          paidPaise: Value(purchase.paidPaise + apply),
        ));
        remaining -= apply;
      }

      return recordEntry(
        kind: TransactionKind.purchasePayment,
        amountPaise: amountPaise,
        method: method,
        supplierId: supplierId,
        note: note,
        source: EntrySource.manual,
      );
    });
  }

  /// Deterministic figures used by the assistant and analytics.
  Future<Map<String, int>> todayTotals() async {
    final DateTime now = DateTime.now();
    final DateTime start = DateTime(now.year, now.month, now.day);
    final List<LedgerEntry> entries = await entriesBetween(
      start,
      start.add(const Duration(days: 1)),
    );
    int sales = 0;
    int expenses = 0;
    int cashIn = 0;
    int cashOut = 0;
    for (final LedgerEntry entry in entries) {
      // Cash deltas always count so an original and its reversal net to zero.
      final bool isReversal = entry.reversalOfId != null;
      if (!isReversal && !entry.isReversed && entry.kind == TransactionKind.sale) {
        sales += entry.amountPaise;
      }
      if (!isReversal && !entry.isReversed && LedgerRules.isExpenseLike(entry.kind)) {
        expenses += entry.amountPaise;
      }
      if (entry.cashDeltaPaise > 0) cashIn += entry.cashDeltaPaise;
      if (entry.cashDeltaPaise < 0) cashOut += -entry.cashDeltaPaise;
    }
    return <String, int>{
      'salesPaise': sales,
      'expensesPaise': expenses,
      'cashInPaise': cashIn,
      'cashOutPaise': cashOut,
      'netCashPaise': cashIn - cashOut,
      'entries': entries.where((LedgerEntry e) => !e.isReversed).length,
    };
  }

  /// Cash on hand implied by recorded entries. Used for affordability answers.
  /// Includes both an original and its compensating reversal so they net to
  /// zero; filtering out reversed originals alone would invert the balance.
  Future<int> cashBalancePaise() async {
    final List<Transaction> rows = await _db.select(_db.transactions).get();
    return rows.fold<int>(0, (int sum, Transaction t) => sum + t.cashDeltaPaise);
  }

  String todayKey() => _dayFormat.format(DateTime.now());

  Future<void> _audit(
    String entityType,
    int? entityId,
    String action,
    Map<String, Object?> details,
  ) {
    return _db.into(_db.auditLogs).insert(
          AuditLogsCompanion.insert(
            entityType: entityType,
            entityId: Value(entityId),
            action: action,
            detailsJson: jsonEncode(details),
            createdAt: DateTime.now(),
          ),
        );
  }
}
