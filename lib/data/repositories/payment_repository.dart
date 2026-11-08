import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/enums.dart';
import '../../domain/models.dart';
import '../db/app_database.dart';
import '../mappers.dart';
import 'ledger_repository.dart';

class PaymentException implements Exception {
  PaymentException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Persistence for Solana payment proposals and the spending policy.
class PaymentRepository {
  PaymentRepository(this._db, this._ledger);

  final AppDatabase _db;
  final LedgerRepository _ledger;

  static final RegExp _base58 = RegExp(r'^[1-9A-HJ-NP-Za-km-z]{32,44}$');

  // --- Payments ------------------------------------------------------------

  Stream<List<PaymentProposal>> watchPayments({int limit = 100}) {
    return (_db.select(_db.solanaPayments)
          ..orderBy([(p) => OrderingTerm.desc(p.createdAt)])
          ..limit(limit))
        .watch()
        .map((List<SolanaPayment> rows) =>
            rows.map(paymentProposalFrom).toList());
  }

  Stream<PaymentProposal?> watchPayment(int id) {
    return (_db.select(_db.solanaPayments)
          ..where((p) => p.id.equals(id)))
        .watchSingleOrNull()
        .map((SolanaPayment? row) =>
            row == null ? null : paymentProposalFrom(row));
  }

  Future<PaymentProposal?> findPayment(int id) async {
    final SolanaPayment? row = await (_db.select(_db.solanaPayments)
          ..where((p) => p.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : paymentProposalFrom(row);
  }

  Future<SolanaPayment?> findPaymentRow(int id) {
    return (_db.select(_db.solanaPayments)
          ..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }

  Future<PaymentProposal?> findByIdempotencyKey(String key) async {
    final SolanaPayment? row = await (_db.select(_db.solanaPayments)
          ..where((p) => p.idempotencyKey.equals(key)))
        .getSingleOrNull();
    return row == null ? null : paymentProposalFrom(row);
  }

  /// Creates a proposal. Idempotent on [idempotencyKey].
  Future<int> createProposal({
    required String recipientName,
    required String recipientAddress,
    required int amountLamports,
    required PolicyEvaluation evaluation,
    String network = 'devnet',
    int? payeeId,
    String requestText = '',
    int inrMemoPaise = 0,
    String? idempotencyKey,
  }) async {
    if (amountLamports <= 0) {
      throw PaymentException('Amount must be greater than zero.');
    }
    if (!_base58.hasMatch(recipientAddress)) {
      throw PaymentException('Recipient address is not a valid Solana address.');
    }
    final String key = idempotencyKey ?? const Uuid().v4();
    final PaymentProposal? existing = await findByIdempotencyKey(key);
    if (existing != null) return existing.id;

    return _db.into(_db.solanaPayments).insert(
          SolanaPaymentsCompanion.insert(
            idempotencyKey: key,
            payeeId: Value(payeeId),
            recipientName: recipientName.trim(),
            recipientAddress: recipientAddress,
            amountLamports: amountLamports,
            inrMemoPaise: Value(inrMemoPaise),
            network: network,
            status: PaymentStatus.awaitingApproval,
            requestText: requestText.trim(),
            policySnapshotJson: Value(jsonEncode(<String, Object?>{
              'allowed': evaluation.allowed,
              'passed': evaluation.passedChecks,
              'violations': evaluation.violations
                  .map((PolicyViolation v) => v.code)
                  .toList(),
              'at': DateTime.now().toIso8601String(),
            })),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
  }

  Future<void> setStatus(
    int id,
    PaymentStatus status, {
    String? errorMessage,
    bool clearError = false,
  }) async {
    final SolanaPayment? row = await findPaymentRow(id);
    if (row == null) throw PaymentException('Payment not found.');
    await (_db.update(_db.solanaPayments)
          ..where((p) => p.id.equals(id)))
        .write(SolanaPaymentsCompanion(
      status: Value(status),
      errorMessage: clearError
          ? const Value(null)
          : (errorMessage == null ? const Value.absent() : Value(errorMessage)),
      updatedAt: Value(DateTime.now()),
    ));
    await _audit(id, 'status_${status.name}', <String, Object?>{
      'previous': row.status.name,
      'error': errorMessage,
    });
  }

  Future<void> attachSignature({
    required int id,
    required String signature,
  }) async {
    await (_db.update(_db.solanaPayments)
          ..where((p) => p.id.equals(id)))
        .write(SolanaPaymentsCompanion(
      signature: Value(signature),
      status: const Value(PaymentStatus.submitted),
      updatedAt: Value(DateTime.now()),
    ));
    await _audit(id, 'submitted', <String, Object?>{'signature': signature});
  }

  /// Marks a payment confirmed only after RPC confirmation, then links a local
  /// ledger entry carrying the signature.
  Future<int> markConfirmed({
    required int id,
    required String signature,
    required String explorerUrl,
    int inrMemoPaise = 0,
  }) async {
    final SolanaPayment? row = await findPaymentRow(id);
    if (row == null) throw PaymentException('Payment not found.');
    if (row.status == PaymentStatus.confirmed) {
      return row.ledgerTransactionId ?? 0;
    }
    if (row.status == PaymentStatus.rejected ||
        row.status == PaymentStatus.failed) {
      throw PaymentException(
        'A ${row.status.name} payment cannot be confirmed.',
      );
    }
    final List<SolanaPayment> sameSignature =
        await (_db.select(_db.solanaPayments)
              ..where((p) => p.signature.equals(signature)))
            .get();
    if (sameSignature.any((SolanaPayment p) => p.id != id)) {
      throw PaymentException(
        'This transaction signature is already recorded on another payment.',
      );
    }

    return _db.transaction(() async {
      final int ledgerId = await _ledger.recordSolanaSettlement(
        amountLamports: row.amountLamports,
        // Keep the merchant's INR valuation captured at proposal time.
        inrMemoPaise: inrMemoPaise > 0 ? inrMemoPaise : row.inrMemoPaise,
        signature: signature,
        recipientName: row.recipientName,
        recipientAddress: row.recipientAddress,
      );
      await (_db.update(_db.solanaPayments)
            ..where((p) => p.id.equals(id)))
          .write(SolanaPaymentsCompanion(
        status: const Value(PaymentStatus.confirmed),
        signature: Value(signature),
        explorerUrl: Value(explorerUrl),
        ledgerTransactionId: Value(ledgerId),
        confirmedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        errorMessage: const Value(null),
      ));
      await _audit(id, 'confirmed', <String, Object?>{
        'signature': signature,
        'ledgerTransactionId': ledgerId,
      });
      return ledgerId;
    });
  }

  Future<bool> signatureAlreadyUsed(String signature) async {
    final SolanaPayment? row = await (_db.select(_db.solanaPayments)
          ..where((p) => p.signature.equals(signature))
          ..limit(1))
        .getSingleOrNull();
    return row != null;
  }

  Future<int> dailySpentLamports({DateTime? now}) async {
    final DateTime reference = now ?? DateTime.now();
    final DateTime start =
        DateTime(reference.year, reference.month, reference.day);
    // Spend is counted by when it was actually submitted/confirmed, not when
    // the proposal was drafted, otherwise a proposal created yesterday can be
    // sent today without touching the daily limit.
    final List<SolanaPayment> rows = await _db.select(_db.solanaPayments).get();
    int total = 0;
    for (final SolanaPayment row in rows) {
      if (row.status != PaymentStatus.confirmed &&
          row.status != PaymentStatus.submitted &&
          row.status != PaymentStatus.unknown) {
        continue;
      }
      final DateTime when = row.confirmedAt ?? row.updatedAt;
      if (when.isBefore(start)) continue;
      total += row.amountLamports;
    }
    return total;
  }

  Future<int> confirmedSpentLamports() async {
    final List<SolanaPayment> rows = await (_db.select(_db.solanaPayments)
          ..where((p) =>
              p.status.equalsValue(PaymentStatus.confirmed)))
        .get();
    return rows.fold<int>(0, (int sum, SolanaPayment p) => sum + p.amountLamports);
  }

  // --- Payees --------------------------------------------------------------

  Stream<List<Payee>> watchPayees({bool includeArchived = false}) {
    return (_db.select(_db.payees)
          ..where((p) =>
              includeArchived ? const Constant(true) : p.archived.equals(false))
          ..orderBy([(p) => OrderingTerm.asc(p.name)]))
        .watch();
  }

  Future<List<Payee>> loadPayees() {
    return (_db.select(_db.payees)..where((p) => p.archived.equals(false)))
        .get();
  }

  Future<int> addPayee({
    required String name,
    required String walletAddress,
  }) async {
    final String address = walletAddress.trim();
    if (name.trim().isEmpty) {
      throw PaymentException('Recipient name is required.');
    }
    if (!_base58.hasMatch(address)) {
      throw PaymentException('That does not look like a Solana address.');
    }
    final Payee? existing = await (_db.select(_db.payees)
          ..where((p) => p.walletAddress.equals(address)))
        .getSingleOrNull();
    if (existing != null) return existing.id;
    final int id = await _db.into(_db.payees).insert(
          PayeesCompanion.insert(
            name: name.trim(),
            walletAddress: address,
            createdAt: DateTime.now(),
          ),
        );
    await _db.into(_db.auditLogs).insert(
          AuditLogsCompanion.insert(
            entityType: 'payee',
            entityId: Value(id),
            action: 'created',
            detailsJson: jsonEncode(<String, Object?>{
              'name': name.trim(),
              'address': address,
            }),
            createdAt: DateTime.now(),
          ),
        );
    return id;
  }

  Future<void> archivePayee(int id, {bool archived = true}) async {
    await (_db.update(_db.payees)..where((p) => p.id.equals(id)))
        .write(PayeesCompanion(archived: Value(archived)));
    await _audit(id, archived ? 'archived' : 'restored', const {});
  }

  // --- Policy --------------------------------------------------------------

  Stream<SpendingPolicy> watchPolicy() {
    return (_db.select(_db.policyRows)..limit(1))
        .watchSingleOrNull()
        .map((PolicyRow? row) => row == null ? SpendingPolicy.defaults : policyFrom(row));
  }

  Future<SpendingPolicy> loadPolicy() async {
    final PolicyRow? row =
        await (_db.select(_db.policyRows)..limit(1)).getSingleOrNull();
    return row == null ? SpendingPolicy.defaults : policyFrom(row);
  }

  Future<void> savePolicy(SpendingPolicy policy) async {
    if (policy.maxPerPaymentLamports <= 0 ||
        policy.dailyLimitLamports <= 0) {
      throw PaymentException('Limits must be greater than zero.');
    }
    if (policy.maxPerPaymentLamports > policy.dailyLimitLamports) {
      throw PaymentException(
        'Per-payment limit cannot be higher than the daily limit.',
      );
    }
    final PolicyRow? row =
        await (_db.select(_db.policyRows)..limit(1)).getSingleOrNull();
    if (row == null) {
      await _db.into(_db.policyRows).insert(
            PolicyRowsCompanion.insert(
              maxPerPaymentLamports: policy.maxPerPaymentLamports,
              dailyLimitLamports: policy.dailyLimitLamports,
              savedRecipientsOnly: policy.savedRecipientsOnly,
              devnetOnly: policy.devnetOnly,
              requireApproval: policy.requireApproval,
              updatedAt: DateTime.now(),
            ),
          );
    } else {
      await (_db.update(_db.policyRows)
            ..where((p) => p.id.equals(row.id)))
          .write(PolicyRowsCompanion(
        maxPerPaymentLamports: Value(policy.maxPerPaymentLamports),
        dailyLimitLamports: Value(policy.dailyLimitLamports),
        savedRecipientsOnly: Value(policy.savedRecipientsOnly),
        devnetOnly: Value(policy.devnetOnly),
        requireApproval: Value(policy.requireApproval),
        updatedAt: Value(DateTime.now()),
      ));
    }
    await _db.into(_db.auditLogs).insert(
          AuditLogsCompanion.insert(
            entityType: 'policy',
            entityId: const Value(1),
            action: 'updated',
            detailsJson: jsonEncode(<String, Object?>{
              'maxPerPaymentLamports': policy.maxPerPaymentLamports,
              'dailyLimitLamports': policy.dailyLimitLamports,
              'savedRecipientsOnly': policy.savedRecipientsOnly,
            }),
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<void> _audit(
    int? id,
    String action,
    Map<String, Object?> details,
  ) {
    return _db.into(_db.auditLogs).insert(
          AuditLogsCompanion.insert(
            entityType: 'solana_payment',
            entityId: Value(id),
            action: action,
            detailsJson: jsonEncode(details),
            createdAt: DateTime.now(),
          ),
        );
  }
}
