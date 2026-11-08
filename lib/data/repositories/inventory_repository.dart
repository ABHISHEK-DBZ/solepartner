import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/stream_combine.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';
import '../db/app_database.dart';
import '../mappers.dart';

class InventoryException implements Exception {
  InventoryException(this.message);
  final String message;
  @override
  String toString() => message;
}

class InsufficientStockException extends InventoryException {
  InsufficientStockException(this.productName, this.available, this.requested)
      : super(
          '$productName has only ${_qty(available)} in stock '
          '(needed ${_qty(requested)}).',
        );

  final String productName;
  final double available;
  final double requested;

  static String _qty(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : '$value';
}

class InventoryRepository {
  InventoryRepository(this._db);

  final AppDatabase _db;

  static double roundQty(double value) => (value * 1000).round() / 1000;

  /// Products with supplier names and 30-day sales velocity.
  Stream<List<ProductView>> watchProducts({bool includeArchived = false}) {
    final DateTime cutoff = DateTime.now().subtract(const Duration(days: 30));

    final Stream<List<Product>> productStream = (_db.select(_db.products)
          ..where((p) =>
              includeArchived ? const Constant(true) : p.archived.equals(false))
          ..orderBy([(p) => OrderingTerm.asc(p.name)]))
        .watch();

    final Stream<List<Supplier>> supplierStream =
        _db.select(_db.suppliers).watch();

    final Stream<List<_SoldAggregate>> soldStream = _soldAggregates(cutoff);

    return combineLatest2(
      combineLatest2(productStream, supplierStream,
          (List<Product> products, List<Supplier> suppliers) =>
              (products, suppliers)),
      soldStream,
      ((List<Product>, List<Supplier>) data, List<_SoldAggregate> sold) {
        final Map<int, Supplier> suppliersById = <int, Supplier>{
          for (final Supplier s in data.$2) s.id: s,
        };
        final Map<int, _SoldAggregate> soldById = <int, _SoldAggregate>{
          for (final _SoldAggregate a in sold) a.productId: a,
        };
        return data.$1.map((Product p) {
          final _SoldAggregate? aggregate = soldById[p.id];
          return productViewFrom(
            p,
            supplierName: p.supplierId == null
                ? null
                : suppliersById[p.supplierId!]?.name,
            unitsSold30d: aggregate?.units ?? 0,
            lastSoldAt: aggregate?.lastSoldAt,
          );
        }).toList();
      },
    );
  }

  Stream<List<_SoldAggregate>> _soldAggregates(DateTime cutoff) {
    final query = _db.select(_db.transactionLines).join([
      innerJoin(
        _db.transactions,
        _db.transactions.id.equalsExp(_db.transactionLines.transactionId),
      ),
    ])
      ..where(_db.transactions.isReversed.equals(false) &
          _db.transactions.occurredAt.isBiggerOrEqualValue(cutoff));

    return query.watch().map((List<TypedResult> rows) {
      final Map<int, double> units = <int, double>{};
      final Map<int, DateTime> lastSold = <int, DateTime>{};
      for (final TypedResult row in rows) {
        final TransactionLine line = row.readTable(_db.transactionLines);
        final Transaction txn = row.readTable(_db.transactions);
        units[line.productId] = (units[line.productId] ?? 0) + line.quantity;
        final DateTime? previous = lastSold[line.productId];
        if (previous == null || txn.occurredAt.isAfter(previous)) {
          lastSold[line.productId] = txn.occurredAt;
        }
      }
      return units.entries
          .map((MapEntry<int, double> e) => _SoldAggregate(
                e.key,
                roundQty(e.value),
                lastSold[e.key],
              ))
          .toList();
    });
  }

  Stream<ProductView?> watchProduct(int productId) {
    return watchProducts(includeArchived: true).map(
      (List<ProductView> products) {
        for (final ProductView product in products) {
          if (product.id == productId) return product;
        }
        return null;
      },
    );
  }

  /// One-shot product views for analytics and the assistant.
  Future<List<ProductView>> loadProductViews() async {
    final List<Product> products = await allProducts(includeArchived: false);
    final List<Supplier> suppliers = await _db.select(_db.suppliers).get();
    final List<ProductSales> sales = await productSales(days: 30, limit: 10000);
    final Map<int, Supplier> suppliersById = <int, Supplier>{
      for (final Supplier s in suppliers) s.id: s,
    };
    final Map<int, ProductSales> salesById = <int, ProductSales>{
      for (final ProductSales s in sales) s.productId: s,
    };
    return products.map((Product p) {
      return productViewFrom(
        p,
        supplierName: p.supplierId == null ? null : suppliersById[p.supplierId!]?.name,
        unitsSold30d: salesById[p.id]?.units ?? 0,
      );
    }).toList();
  }

  Future<List<Product>> allProducts({bool includeArchived = true}) {
    return (_db.select(_db.products)
          ..where((p) =>
              includeArchived ? const Constant(true) : p.archived.equals(false))
          ..orderBy([(p) => OrderingTerm.asc(p.name)]))
        .get();
  }

  Future<Product?> findProduct(int id) {
    return (_db.select(_db.products)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }

  Future<Product?> findByBarcode(String barcode) {
    if (barcode.trim().isEmpty) return Future<Product?>.value();
    return (_db.select(_db.products)
          ..where((p) => p.barcode.equals(barcode.trim())))
        .getSingleOrNull();
  }

  Future<int> createProduct({
    required String name,
    String sku = '',
    String barcode = '',
    String category = '',
    String unit = 'pc',
    int purchasePricePaise = 0,
    int sellingPricePaise = 0,
    double openingStockQty = 0,
    double minStockQty = 0,
    int? supplierId,
    String? imagePath,
  }) async {
    if (name.trim().isEmpty) {
      throw InventoryException('Product name is required.');
    }
    if (purchasePricePaise < 0 || sellingPricePaise < 0) {
      throw InventoryException('Prices cannot be negative.');
    }
    final double opening = roundQty(openingStockQty);
    if (opening < 0) {
      throw InventoryException('Opening stock cannot be negative.');
    }

    return _db.transaction(() async {
      final int id = await _db.into(_db.products).insert(
            ProductsCompanion.insert(
              name: name.trim(),
              sku: sku.trim(),
              barcode: barcode.trim(),
              category: category.trim(),
              unit: unit.trim().isEmpty ? 'pc' : unit.trim(),
              purchasePricePaise: Value(purchasePricePaise),
              sellingPricePaise: Value(sellingPricePaise),
              stockQty: Value(opening),
              minStockQty: Value(roundQty(minStockQty)),
              supplierId: Value(supplierId),
              imagePath: Value(imagePath),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
      if (opening > 0) {
        await _insertMovement(
          productId: id,
          kind: StockMovementKind.opening,
          quantityDelta: opening,
          unitCostPaise: purchasePricePaise,
          reason: 'Opening stock',
        );
      }
      await _log('product', id, 'created', <String, Object?>{
        'name': name,
        'openingStock': opening,
      });
      return id;
    });
  }

  Future<void> updateProduct({
    required int id,
    required String name,
    String? sku,
    String? barcode,
    String? category,
    String? unit,
    int? purchasePricePaise,
    int? sellingPricePaise,
    double? minStockQty,
    int? supplierId,
    bool clearSupplier = false,
    String? imagePath,
  }) async {
    if (name.trim().isEmpty) {
      throw InventoryException('Product name is required.');
    }
    final int changed = await (_db.update(_db.products)
          ..where((p) => p.id.equals(id)))
        .write(
      ProductsCompanion(
        name: Value(name.trim()),
        sku: sku == null ? const Value.absent() : Value(sku.trim()),
        barcode: barcode == null ? const Value.absent() : Value(barcode.trim()),
        category:
            category == null ? const Value.absent() : Value(category.trim()),
        unit: unit == null ? const Value.absent() : Value(unit.trim()),
        purchasePricePaise: purchasePricePaise == null
            ? const Value.absent()
            : Value(purchasePricePaise),
        sellingPricePaise: sellingPricePaise == null
            ? const Value.absent()
            : Value(sellingPricePaise),
        minStockQty: minStockQty == null
            ? const Value.absent()
            : Value(roundQty(minStockQty)),
        supplierId: clearSupplier
            ? const Value(null)
            : (supplierId == null ? const Value.absent() : Value(supplierId)),
        imagePath: imagePath == null ? const Value.absent() : Value(imagePath),
        updatedAt: Value(DateTime.now()),
      ),
    );
    if (changed > 0) {
      await _log('product', id, 'updated', <String, Object?>{'name': name});
    }
  }

  Future<void> archiveProduct(int id, {bool archived = true}) async {
    await (_db.update(_db.products)..where((p) => p.id.equals(id)))
        .write(ProductsCompanion(
      archived: Value(archived),
      updatedAt: Value(DateTime.now()),
    ));
    await _log('product', id, archived ? 'archived' : 'restored', const {});
  }

  /// Applies a signed stock delta and always writes a movement row.
  ///
  /// Callers are responsible for wrapping this in a database transaction.
  Future<void> applyStockMovement({
    required int productId,
    required double quantityDelta,
    required StockMovementKind kind,
    String reason = '',
    int? unitCostPaise,
    String? referenceType,
    int? referenceId,
    bool allowNegative = false,
  }) async {
    final Product? product = await findProduct(productId);
    if (product == null) {
      throw InventoryException('Product not found.');
    }
    final double delta = roundQty(quantityDelta);
    if (delta == 0) {
      throw InventoryException('Stock change cannot be zero.');
    }
    if (kind.requiresReason && reason.trim().isEmpty) {
      throw InventoryException('${kind.label} needs a reason.');
    }
    final double next = roundQty(product.stockQty + delta);
    if (next < 0 && !allowNegative) {
      throw InsufficientStockException(product.name, product.stockQty, -delta);
    }
    await (_db.update(_db.products)
          ..where((p) => p.id.equals(productId)))
        .write(ProductsCompanion(
      stockQty: Value(next),
      updatedAt: Value(DateTime.now()),
    ));
    await _insertMovement(
      productId: productId,
      kind: kind,
      quantityDelta: delta,
      unitCostPaise: unitCostPaise ?? product.purchasePricePaise,
      reason: reason,
      referenceType: referenceType,
      referenceId: referenceId,
    );
  }

  Future<void> adjustStock({
    required int productId,
    required double quantityDelta,
    required StockMovementKind kind,
    required String reason,
  }) async {
    if (!kind.requiresReason) {
      throw InventoryException('Only adjustments, damage or expiry can be '
          'entered directly. Record purchases and sales through their flows.');
    }
    await _db.transaction(() async {
      await applyStockMovement(
        productId: productId,
        quantityDelta: quantityDelta,
        kind: kind,
        reason: reason,
        allowNegative: false,
      );
      await _log('stock', productId, 'adjusted', <String, Object?>{
        'delta': quantityDelta,
        'kind': kind.name,
        'reason': reason,
      });
    });
  }

  /// Product-wise sales for the last [days], ordered by revenue.
  Future<List<ProductSales>> productSales({int days = 30, int limit = 10}) async {
    final DateTime cutoff = DateTime.now().subtract(Duration(days: days));
    final query = _db.select(_db.transactionLines).join(<Join<HasResultSet, dynamic>>[
      innerJoin(_db.transactions,
          _db.transactions.id.equalsExp(_db.transactionLines.transactionId)),
      innerJoin(_db.products, _db.products.id.equalsExp(_db.transactionLines.productId)),
    ])
      ..where(_db.transactions.occurredAt.isBiggerOrEqualValue(cutoff) &
          _db.transactions.isReversed.equals(false));
    final List<TypedResult> rows = await query.get();
    final Map<int, ProductSales> totals = <int, ProductSales>{};
    for (final TypedResult row in rows) {
      final TransactionLine line = row.readTable(_db.transactionLines);
      final Product product = row.readTable(_db.products);
      final ProductSales? current = totals[product.id];
      final double units = (current?.units ?? 0) + line.quantity;
      final int revenue = (current?.revenuePaise ?? 0) +
          (line.unitPricePaise * line.quantity).round();
      final int margin = (current?.marginPaise ?? 0) +
          ((line.unitPricePaise - line.unitCostPaise) * line.quantity).round();
      totals[product.id] = ProductSales(
        productId: product.id,
        productName: product.name,
        units: roundQty(units),
        revenuePaise: revenue,
        marginPaise: margin,
      );
    }
    final List<ProductSales> list = totals.values.toList()
      ..sort((ProductSales a, ProductSales b) =>
          b.revenuePaise.compareTo(a.revenuePaise));
    return list.take(limit).toList();
  }

  Stream<List<StockMovement>> watchMovements(int productId, {int limit = 100}) {
    return (_db.select(_db.stockMovements)
          ..where((m) => m.productId.equals(productId))
          ..orderBy([
            (m) => OrderingTerm.desc(m.createdAt),
            (m) => OrderingTerm.desc(m.id),
          ])
          ..limit(limit))
        .watch();
  }

  Future<void> _insertMovement({
    required int productId,
    required StockMovementKind kind,
    required double quantityDelta,
    int? unitCostPaise,
    String reason = '',
    String? referenceType,
    int? referenceId,
  }) {
    return _db.into(_db.stockMovements).insert(
          StockMovementsCompanion.insert(
            productId: productId,
            kind: kind,
            quantityDelta: roundQty(quantityDelta),
            unitCostPaise: Value(unitCostPaise),
            reason: reason,
            referenceType: Value(referenceType),
            referenceId: Value(referenceId),
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<void> _log(
    String entityType,
    int entityId,
    String action,
    Map<String, Object?> details,
  ) {
    return _db.into(_db.auditLogs).insert(
          AuditLogsCompanion.insert(
            entityType: entityType,
            entityId: Value(entityId),
            action: action,
            detailsJson: _encode(details),
            createdAt: DateTime.now(),
          ),
        );
  }

  static String _encode(Map<String, Object?> details) => jsonEncode(details);
}

class _SoldAggregate {
  const _SoldAggregate(this.productId, this.units, this.lastSoldAt);
  final int productId;
  final double units;
  final DateTime? lastSoldAt;
}
