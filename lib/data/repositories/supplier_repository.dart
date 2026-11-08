import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/stream_combine.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';
import '../db/app_database.dart';
import '../mappers.dart';
import 'inventory_repository.dart';
import 'ledger_repository.dart';

class SupplierException implements Exception {
  SupplierException(this.message);
  final String message;
  @override
  String toString() => message;
}

class PurchaseItemInput {
  const PurchaseItemInput({
    required this.productId,
    required this.quantity,
    required this.unitCostPaise,
  });

  final int productId;
  final double quantity;
  final int unitCostPaise;
}

class PurchaseLineView {
  const PurchaseLineView({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitCostPaise,
  });

  final int productId;
  final String productName;
  final double quantity;
  final int unitCostPaise;

  int get totalPaise => (unitCostPaise * quantity).round();
}

class SupplierRepository {
  SupplierRepository(this._db, this._inventory, this._ledger);

  final AppDatabase _db;
  final InventoryRepository _inventory;
  final LedgerRepository _ledger;

  Stream<List<SupplierView>> watchSuppliers({bool includeArchived = false}) {
    final Stream<List<Supplier>> supplierStream = (_db.select(_db.suppliers)
          ..where((s) =>
              includeArchived ? const Constant(true) : s.archived.equals(false))
          ..orderBy([(s) => OrderingTerm.asc(s.name)]))
        .watch();
    final Stream<List<Purchase>> purchaseStream =
        _db.select(_db.purchases).watch();
    final Stream<List<Product>> productStream = _db.select(_db.products).watch();

    return combineLatest3(
      supplierStream,
      purchaseStream,
      productStream,
      (List<Supplier> suppliers, List<Purchase> purchases, List<Product> products) {
        return suppliers.map((Supplier supplier) {
          final List<Purchase> supplierPurchases = purchases
              .where((p) => p.supplierId == supplier.id)
              .toList();
          final int productCount = products
              .where((p) => p.supplierId == supplier.id && !p.archived)
              .length;
          return supplierViewFrom(supplier, supplierPurchases, productCount);
        }).toList();
      },
    );
  }

  Stream<SupplierView?> watchSupplier(int id) {
    return watchSuppliers(includeArchived: true)
        .map((List<SupplierView> list) {
      for (final SupplierView supplier in list) {
        if (supplier.id == id) return supplier;
      }
      return null;
    });
  }

  Future<List<SupplierView>> loadSuppliers() async {
    final List<Supplier> suppliers = await _db.select(_db.suppliers).get();
    final List<Purchase> purchases = await _db.select(_db.purchases).get();
    final List<Product> products = await _db.select(_db.products).get();
    return suppliers
        .map((s) => supplierViewFrom(
              s,
              purchases.where((p) => p.supplierId == s.id).toList(),
              products
                  .where((p) => p.supplierId == s.id && !p.archived)
                  .length,
            ))
        .toList();
  }

  Future<int> createSupplier({
    required String name,
    String phone = '',
    String address = '',
    String notes = '',
  }) async {
    if (name.trim().isEmpty) {
      throw SupplierException('Supplier name is required.');
    }
    final int id = await _db.into(_db.suppliers).insert(
          SuppliersCompanion.insert(
            name: name.trim(),
            phone: phone.trim(),
            address: address.trim(),
            notes: notes.trim(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
    await _audit(id, 'created', <String, Object?>{'name': name});
    return id;
  }

  Future<void> updateSupplier({
    required int id,
    required String name,
    String? phone,
    String? address,
    String? notes,
  }) async {
    if (name.trim().isEmpty) {
      throw SupplierException('Supplier name is required.');
    }
    await (_db.update(_db.suppliers)..where((s) => s.id.equals(id)))
        .write(SuppliersCompanion(
      name: Value(name.trim()),
      phone: phone == null ? const Value.absent() : Value(phone.trim()),
      address: address == null ? const Value.absent() : Value(address.trim()),
      notes: notes == null ? const Value.absent() : Value(notes.trim()),
      updatedAt: Value(DateTime.now()),
    ));
    await _audit(id, 'updated', <String, Object?>{'name': name});
  }

  Future<void> archiveSupplier(int id, {bool archived = true}) async {
    await (_db.update(_db.suppliers)..where((s) => s.id.equals(id)))
        .write(SuppliersCompanion(
      archived: Value(archived),
      updatedAt: Value(DateTime.now()),
    ));
    await _audit(id, archived ? 'archived' : 'restored', const {});
  }

  /// Receives a purchase: records the payable, moves stock and updates cost.
  Future<int> receivePurchase({
    required int supplierId,
    required List<PurchaseItemInput> items,
    String invoiceNumber = '',
    String note = '',
    DateTime? occurredAt,
    int paidNowPaise = 0,
    PaymentMethod method = PaymentMethod.cash,
  }) async {
    if (items.isEmpty) {
      throw SupplierException('Add at least one product to the purchase.');
    }
    for (final PurchaseItemInput item in items) {
      if (item.quantity <= 0) {
        throw SupplierException('Quantities must be greater than zero.');
      }
      if (item.unitCostPaise < 0) {
        throw SupplierException('Cost cannot be negative.');
      }
    }
    if (paidNowPaise < 0) {
      throw SupplierException('Paid amount cannot be negative.');
    }

    final Supplier? supplier = await (_db.select(_db.suppliers)
          ..where((s) => s.id.equals(supplierId)))
        .getSingleOrNull();
    if (supplier == null) throw SupplierException('Supplier not found.');

    int total = 0;
    for (final PurchaseItemInput item in items) {
      total += (item.unitCostPaise * item.quantity).round();
    }
    if (paidNowPaise > total) {
      throw SupplierException('Paid amount is more than the purchase total.');
    }

    return _db.transaction(() async {
      final int purchaseId = await _db.into(_db.purchases).insert(
            PurchasesCompanion.insert(
              supplierId: supplierId,
              invoiceNumber: invoiceNumber.trim(),
              totalPaise: total,
              paidPaise: Value(0),
              note: note.trim(),
              occurredAt: occurredAt ?? DateTime.now(),
              createdAt: DateTime.now(),
            ),
          );

      for (final PurchaseItemInput item in items) {
        await _db.into(_db.purchaseItems).insert(
              PurchaseItemsCompanion.insert(
                purchaseId: purchaseId,
                productId: item.productId,
                quantity: InventoryRepository.roundQty(item.quantity),
                unitCostPaise: item.unitCostPaise,
              ),
            );
        await _inventory.applyStockMovement(
          productId: item.productId,
          quantityDelta: item.quantity,
          kind: StockMovementKind.purchaseReceipt,
          reason: 'Purchase #$purchaseId',
          unitCostPaise: item.unitCostPaise,
          referenceType: 'purchase',
          referenceId: purchaseId,
        );
        await (_db.update(_db.products)
              ..where((p) => p.id.equals(item.productId)))
            .write(ProductsCompanion(
          purchasePricePaise: Value(item.unitCostPaise),
          updatedAt: Value(DateTime.now()),
        ));
      }

      if (paidNowPaise > 0) {
        await (_db.update(_db.purchases)
              ..where((p) => p.id.equals(purchaseId)))
            .write(PurchasesCompanion(paidPaise: Value(paidNowPaise)));
        await _ledger.recordEntry(
          kind: TransactionKind.purchasePayment,
          amountPaise: paidNowPaise,
          method: method,
          supplierId: supplierId,
          note: 'Paid on purchase #$purchaseId',
          source: EntrySource.manual,
        );
      }

      await _audit(purchaseId, 'received', <String, Object?>{
        'supplierId': supplierId,
        'totalPaise': total,
        'items': items.length,
      });
      return purchaseId;
    });
  }

  Stream<List<Purchase>> watchPurchases({int? supplierId}) {
    final query = _db.select(_db.purchases);
    if (supplierId != null) {
      query.where((p) => p.supplierId.equals(supplierId));
    }
    query.orderBy([(p) => OrderingTerm.desc(p.occurredAt)]);
    return query.watch();
  }

  Future<Purchase?> findPurchase(int id) async {
    return (_db.select(_db.purchases)
          ..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<PurchaseLineView>> purchaseLines(int purchaseId) async {
    final query = _db.select(_db.purchaseItems).join(<Join<HasResultSet, dynamic>>[
      innerJoin(_db.products, _db.products.id.equalsExp(_db.purchaseItems.productId)),
    ])
      ..where(_db.purchaseItems.purchaseId.equals(purchaseId));
    final List<TypedResult> rows = await query.get();
    return rows.map((TypedResult row) {
      final PurchaseItem item = row.readTable(_db.purchaseItems);
      final Product product = row.readTable(_db.products);
      return PurchaseLineView(
        productId: item.productId,
        productName: product.name,
        quantity: item.quantity,
        unitCostPaise: item.unitCostPaise,
      );
    }).toList();
  }

  /// Lines for many purchases at once, used by the supplier detail screen.
  Future<Map<int, List<PurchaseLineView>>> purchaseLinesFor(
    List<int> purchaseIds,
  ) async {
    final Map<int, List<PurchaseLineView>> result = <int, List<PurchaseLineView>>{};
    for (final int id in purchaseIds) {
      result[id] = await purchaseLines(id);
    }
    return result;
  }

  Future<void> _audit(
    int? id,
    String action,
    Map<String, Object?> details,
  ) {
    return _db.into(_db.auditLogs).insert(
          AuditLogsCompanion.insert(
            entityType: 'supplier',
            entityId: Value(id),
            action: action,
            detailsJson: jsonEncode(details),
            createdAt: DateTime.now(),
          ),
        );
  }
}
