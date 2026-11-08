import 'package:drift/drift.dart';

import '../db/app_database.dart';

class MerchantException implements Exception {
  MerchantException(this.message);
  final String message;
  @override
  String toString() => message;
}

class MerchantRepository {
  MerchantRepository(this._db);

  final AppDatabase _db;

  Stream<MerchantProfile?> watchMerchant() {
    return (_db.select(_db.merchantProfiles)..limit(1))
        .watchSingleOrNull();
  }

  Future<MerchantProfile?> getMerchant() {
    return (_db.select(_db.merchantProfiles)..limit(1)).getSingleOrNull();
  }

  Future<int> saveMerchant({
    required String shopName,
    String ownerName = '',
    String businessType = '',
    String languageCode = 'en',
    String currencyCode = 'INR',
  }) async {
    if (shopName.trim().isEmpty) {
      throw MerchantException('Shop name is required.');
    }
    final MerchantProfile? existing = await getMerchant();
    if (existing == null) {
      return _db.into(_db.merchantProfiles).insert(
            MerchantProfilesCompanion.insert(
              shopName: shopName.trim(),
              ownerName: ownerName.trim(),
              businessType: businessType.trim(),
              languageCode: languageCode,
              currencyCode: currencyCode,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
    }
    await (_db.update(_db.merchantProfiles)
          ..where((m) => m.id.equals(existing.id)))
        .write(MerchantProfilesCompanion(
      shopName: Value(shopName.trim()),
      ownerName: Value(ownerName.trim()),
      businessType: Value(businessType.trim()),
      languageCode: Value(languageCode),
      currencyCode: Value(currencyCode),
      updatedAt: Value(DateTime.now()),
    ));
    await _db.into(_db.auditLogs).insert(
          AuditLogsCompanion.insert(
            entityType: 'merchant',
            entityId: Value(existing.id),
            action: 'profile_updated',
            detailsJson: '{"shopName":"${shopName.trim()}"}',
            createdAt: DateTime.now(),
          ),
        );
    return existing.id;
  }
}
