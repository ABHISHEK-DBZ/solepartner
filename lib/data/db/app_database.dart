import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/enums.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    MerchantProfiles,
    Customers,
    Suppliers,
    Products,
    StockMovements,
    Transactions,
    TransactionLines,
    Purchases,
    PurchaseItems,
    Payees,
    SolanaPayments,
    PolicyRows,
    AuditLogs,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'khatacopilot'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await into(policyRows).insert(
            PolicyRowsCompanion.insert(
              maxPerPaymentLamports: 100000000, // 0.1 SOL
              dailyLimitLamports: 1000000000, // 1 SOL
              savedRecipientsOnly: true,
              devnetOnly: true,
              requireApproval: true,
              updatedAt: DateTime.now(),
            ),
          );
        },
        beforeOpen: (OpeningDetails details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Used by the UI when a merchant edits their profile.
  Future<MerchantProfile?> get merchant async =>
      (select(merchantProfiles)..limit(1)).getSingleOrNull();

  /// Wipes every business record and restores the default spending policy.
  /// The merchant can start a clean ledger without reinstalling the app.
  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(solanaPayments).go();
      await delete(transactionLines).go();
      await delete(transactions).go();
      await delete(purchaseItems).go();
      await delete(purchases).go();
      await delete(stockMovements).go();
      await delete(products).go();
      await delete(customers).go();
      await delete(suppliers).go();
      await delete(payees).go();
      await delete(auditLogs).go();
      await delete(appSettings).go();
      await delete(merchantProfiles).go();
      await delete(policyRows).go();
      await into(policyRows).insert(
        PolicyRowsCompanion.insert(
          maxPerPaymentLamports: 100000000,
          dailyLimitLamports: 1000000000,
          savedRecipientsOnly: true,
          devnetOnly: true,
          requireApproval: true,
          updatedAt: DateTime.now(),
        ),
      );
    });
  }
}
