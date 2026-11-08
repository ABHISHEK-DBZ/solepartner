import '../data/db/app_database.dart';
import '../domain/enums.dart';
import '../domain/models.dart';
import '../domain/rules/ledger_rules.dart';

LedgerEntry ledgerEntryFrom(
  Transaction row, {
  String? customerName,
  String? supplierName,
  List<LedgerLine> lines = const <LedgerLine>[],
}) {
  return LedgerEntry(
    id: row.id,
    kind: row.kind,
    amountPaise: row.amountPaise,
    cashDeltaPaise: row.cashDeltaPaise,
    creditDeltaPaise: row.creditDeltaPaise,
    method: row.method,
    note: row.note,
    source: row.source,
    occurredAt: row.occurredAt,
    customerId: row.customerId,
    customerName: customerName,
    supplierId: row.supplierId,
    supplierName: supplierName,
    isReversed: row.isReversed,
    reversalOfId: row.reversalOfId,
    externalRef: row.externalRef,
    lines: lines,
  );
}

ProductView productViewFrom(
  Product row, {
  String? supplierName,
  double unitsSold30d = 0,
  DateTime? lastSoldAt,
}) {
  return ProductView(
    id: row.id,
    name: row.name,
    sku: row.sku,
    category: row.category,
    unit: row.unit,
    purchasePricePaise: row.purchasePricePaise,
    sellingPricePaise: row.sellingPricePaise,
    stockQty: row.stockQty,
    minStockQty: row.minStockQty,
    barcode: row.barcode,
    supplierId: row.supplierId,
    supplierName: supplierName,
    imagePath: row.imagePath,
    archived: row.archived,
    unitsSold30d: unitsSold30d,
    lastSoldAt: lastSoldAt,
  );
}

CustomerView customerViewFrom(
  Customer row,
  List<LedgerEntry> entries,
  DateTime now,
) {
  int outstanding = 0;
  int given = 0;
  int repaid = 0;
  int count = 0;
  DateTime? lastActivity;

  for (final LedgerEntry entry in entries) {
    if (entry.customerId != row.id || entry.isReversed) continue;
    count += 1;
    outstanding += entry.creditDeltaPaise;
    if (entry.creditDeltaPaise > 0) given += entry.creditDeltaPaise;
    if (entry.creditDeltaPaise < 0) repaid += -entry.creditDeltaPaise;
    if (lastActivity == null || entry.occurredAt.isAfter(lastActivity)) {
      lastActivity = entry.occurredAt;
    }
  }

  return CustomerView(
    id: row.id,
    name: row.name,
    phone: row.phone,
    address: row.address,
    notes: row.notes,
    archived: row.archived,
    outstandingPaise: outstanding < 0 ? 0 : outstanding,
    totalCreditGivenPaise: given,
    totalRepaidPaise: repaid,
    overduePaise: LedgerRules.overdueFor(entries, row.id, now),
    lastActivityAt: lastActivity,
    transactionCount: count,
  );
}

SupplierView supplierViewFrom(
  Supplier row,
  List<Purchase> purchases,
  int productCount,
) {
  int payable = 0;
  int paid = 0;
  DateTime? lastPurchase;
  for (final Purchase purchase in purchases) {
    payable += purchase.totalPaise - purchase.paidPaise;
    paid += purchase.paidPaise;
    if (lastPurchase == null || purchase.occurredAt.isAfter(lastPurchase)) {
      lastPurchase = purchase.occurredAt;
    }
  }
  return SupplierView(
    id: row.id,
    name: row.name,
    phone: row.phone,
    address: row.address,
    notes: row.notes,
    archived: row.archived,
    payablePaise: payable < 0 ? 0 : payable,
    paidPaise: paid,
    lastPurchaseAt: lastPurchase,
    productCount: productCount,
  );
}

PaymentProposal paymentProposalFrom(SolanaPayment row) {
  return PaymentProposal(
    id: row.id,
    recipientName: row.recipientName,
    recipientAddress: row.recipientAddress,
    amountLamports: row.amountLamports,
    network: row.network,
    status: row.status,
    createdAt: row.createdAt,
    payeeId: row.payeeId,
    requestText: row.requestText,
    signature: row.signature,
    explorerUrl: row.explorerUrl,
    errorMessage: row.errorMessage,
    ledgerTransactionId: row.ledgerTransactionId,
  );
}

SpendingPolicy policyFrom(PolicyRow row) {
  return SpendingPolicy(
    maxPerPaymentLamports: row.maxPerPaymentLamports,
    dailyLimitLamports: row.dailyLimitLamports,
    savedRecipientsOnly: row.savedRecipientsOnly,
    devnetOnly: row.devnetOnly,
    requireApproval: row.requireApproval,
    updatedAt: row.updatedAt,
  );
}

bool isCreditKind(TransactionKind kind) =>
    kind == TransactionKind.creditGiven;
