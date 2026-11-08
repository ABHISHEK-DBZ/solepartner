import 'package:drift/drift.dart';

import '../../domain/enums.dart';

/// The single merchant profile created during onboarding.
class MerchantProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get shopName => text().withLength(min: 1, max: 120)();
  TextColumn get ownerName => text().withLength(min: 0, max: 120)();
  TextColumn get businessType => text().withLength(min: 0, max: 80)();
  TextColumn get languageCode => text().withLength(min: 2, max: 8)();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get phone => text().withLength(min: 0, max: 32)();
  TextColumn get address => text().withLength(min: 0, max: 240)();
  TextColumn get notes => text().withLength(min: 0, max: 500)();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class Suppliers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get phone => text().withLength(min: 0, max: 32)();
  TextColumn get address => text().withLength(min: 0, max: 240)();
  TextColumn get notes => text().withLength(min: 0, max: 500)();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 160)();
  TextColumn get sku => text().withLength(min: 0, max: 64)();
  TextColumn get barcode => text().withLength(min: 0, max: 64)();
  TextColumn get category => text().withLength(min: 0, max: 80)();
  TextColumn get unit => text().withLength(min: 0, max: 24)();
  IntColumn get purchasePricePaise => integer().withDefault(const Constant(0))();
  IntColumn get sellingPricePaise => integer().withDefault(const Constant(0))();
  RealColumn get stockQty => real().withDefault(const Constant(0))();
  RealColumn get minStockQty => real().withDefault(const Constant(0))();
  IntColumn get supplierId =>
      integer().nullable().references(Suppliers, #id)();
  TextColumn get imagePath => text().nullable()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class StockMovements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  TextColumn get kind => textEnum<StockMovementKind>()();
  RealColumn get quantityDelta => real()();
  IntColumn get unitCostPaise => integer().nullable()();
  TextColumn get reason => text().withLength(min: 0, max: 240)();
  TextColumn get referenceType => text().nullable()();
  IntColumn get referenceId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => textEnum<TransactionKind>()();
  IntColumn get amountPaise => integer()();
  IntColumn get cashDeltaPaise => integer()();
  IntColumn get creditDeltaPaise => integer()();
  IntColumn get customerId =>
      integer().nullable().references(Customers, #id)();
  IntColumn get supplierId =>
      integer().nullable().references(Suppliers, #id)();
  TextColumn get method => textEnum<PaymentMethod>()();
  TextColumn get note => text().withLength(min: 0, max: 500)();
  TextColumn get source => textEnum<EntrySource>()();
  TextColumn get externalRef => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isReversed => boolean().withDefault(const Constant(false))();
  IntColumn get reversalOfId => integer().nullable().references(Transactions, #id)();
}

/// Line items for sales that move stock. The transaction is the money truth;
/// the lines are the quantity truth.
class TransactionLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer().references(Transactions, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  RealColumn get quantity => real()();
  IntColumn get unitPricePaise => integer()();
  IntColumn get unitCostPaise => integer()();
}

class Purchases extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get supplierId => integer().references(Suppliers, #id)();
  TextColumn get invoiceNumber => text().withLength(min: 0, max: 64)();
  IntColumn get totalPaise => integer()();
  IntColumn get paidPaise => integer().withDefault(const Constant(0))();
  TextColumn get note => text().withLength(min: 0, max: 500)();
  DateTimeColumn get occurredAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
}

class PurchaseItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get purchaseId => integer().references(Purchases, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  RealColumn get quantity => real()();
  IntColumn get unitCostPaise => integer()();
}

/// Saved Solana recipients. Policies can restrict payments to this list.
class Payees extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get walletAddress => text().withLength(min: 32, max: 64)();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}

/// Solana payment proposals and their verified lifecycle.
class SolanaPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get idempotencyKey => text().withLength(min: 8, max: 64).unique()();
  IntColumn get payeeId => integer().nullable().references(Payees, #id)();
  TextColumn get recipientName => text().withLength(min: 0, max: 120)();
  TextColumn get recipientAddress => text().withLength(min: 32, max: 64)();
  IntColumn get amountLamports => integer()();
  /// Optional merchant-entered INR memo. Never derived from a price feed.
  IntColumn get inrMemoPaise => integer().withDefault(const Constant(0))();
  TextColumn get network => text().withLength(min: 4, max: 16)();
  TextColumn get status => textEnum<PaymentStatus>()();
  TextColumn get requestText => text().withLength(min: 0, max: 500)();
  TextColumn get signature => text().nullable()();
  TextColumn get explorerUrl => text().nullable()();
  IntColumn get ledgerTransactionId =>
      integer().nullable().references(Transactions, #id)();
  TextColumn get errorMessage => text().nullable()();
  TextColumn get policySnapshotJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get confirmedAt => dateTime().nullable()();
}

/// Single-row spending policy. Deterministic; never derived from LLM output.
class PolicyRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get maxPerPaymentLamports => integer()();
  IntColumn get dailyLimitLamports => integer()();
  BoolColumn get savedRecipientsOnly => boolean()();
  BoolColumn get devnetOnly => boolean()();
  BoolColumn get requireApproval => boolean()();
  DateTimeColumn get updatedAt => dateTime()();
}

class AuditLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text().withLength(min: 1, max: 40)();
  IntColumn get entityId => integer().nullable()();
  TextColumn get action => text().withLength(min: 1, max: 60)();
  TextColumn get detailsJson => text().withLength(min: 0, max: 4000)();
  DateTimeColumn get createdAt => dateTime()();
}

/// Small key/value store for non-financial app preferences.
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
