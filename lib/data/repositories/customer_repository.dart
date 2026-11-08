import 'package:drift/drift.dart';

import '../../core/stream_combine.dart';
import '../../domain/models.dart';
import '../db/app_database.dart';
import '../mappers.dart';

class CustomerException implements Exception {
  CustomerException(this.message);
  final String message;
  @override
  String toString() => message;
}

class CustomerRepository {
  CustomerRepository(this._db);

  final AppDatabase _db;

  Stream<List<CustomerView>> watchCustomers({bool includeArchived = false}) {
    final Stream<List<Customer>> customerStream = (_db.select(_db.customers)
          ..where((c) =>
              includeArchived ? const Constant(true) : c.archived.equals(false))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .watch();

    final Stream<List<Transaction>> transactionStream =
        _db.select(_db.transactions).watch();

    return combineLatest2(
      customerStream,
      transactionStream,
      (List<Customer> customers, List<Transaction> transactions) {
        final DateTime now = DateTime.now();
        final List<LedgerEntry> entries = transactions
            .map((row) => ledgerEntryFrom(row))
            .toList();
        final List<CustomerView> views = customers
            .map((row) => customerViewFrom(row, entries, now))
            .toList();
        views.sort((CustomerView a, CustomerView b) {
          if (a.outstandingPaise != b.outstandingPaise) {
            return b.outstandingPaise.compareTo(a.outstandingPaise);
          }
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        return views;
      },
    );
  }

  Stream<CustomerView?> watchCustomer(int id) {
    return watchCustomers(includeArchived: true).map((List<CustomerView> list) {
      for (final CustomerView customer in list) {
        if (customer.id == id) return customer;
      }
      return null;
    });
  }

  Future<List<CustomerView>> loadCustomers() async {
    final List<Customer> customers = await _db.select(_db.customers).get();
    final List<Transaction> transactions = await _db.select(_db.transactions).get();
    final DateTime now = DateTime.now();
    final List<LedgerEntry> entries =
        transactions.map((row) => ledgerEntryFrom(row)).toList();
    return customers
        .map((row) => customerViewFrom(row, entries, now))
        .toList();
  }

  Future<int> createCustomer({
    required String name,
    String phone = '',
    String address = '',
    String notes = '',
  }) async {
    if (name.trim().isEmpty) {
      throw CustomerException('Customer name is required.');
    }
    final int id = await _db.into(_db.customers).insert(
          CustomersCompanion.insert(
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

  Future<void> updateCustomer({
    required int id,
    required String name,
    String? phone,
    String? address,
    String? notes,
  }) async {
    if (name.trim().isEmpty) {
      throw CustomerException('Customer name is required.');
    }
    await (_db.update(_db.customers)..where((c) => c.id.equals(id)))
        .write(CustomersCompanion(
      name: Value(name.trim()),
      phone: phone == null ? const Value.absent() : Value(phone.trim()),
      address: address == null ? const Value.absent() : Value(address.trim()),
      notes: notes == null ? const Value.absent() : Value(notes.trim()),
      updatedAt: Value(DateTime.now()),
    ));
    await _audit(id, 'updated', <String, Object?>{'name': name});
  }

  Future<void> archiveCustomer(int id, {bool archived = true}) async {
    await (_db.update(_db.customers)..where((c) => c.id.equals(id)))
        .write(CustomersCompanion(
      archived: Value(archived),
      updatedAt: Value(DateTime.now()),
    ));
    await _audit(id, archived ? 'archived' : 'restored', const {});
  }

  Future<void> _audit(int id, String action, Map<String, Object?> details) {
    return _db.into(_db.auditLogs).insert(
          AuditLogsCompanion.insert(
            entityType: 'customer',
            entityId: Value(id),
            action: action,
            detailsJson: details.entries
                .map((MapEntry<String, Object?> e) => '${e.key}=${e.value}')
                .join(','),
            createdAt: DateTime.now(),
          ),
        );
  }
}
