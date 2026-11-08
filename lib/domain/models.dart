import 'enums.dart';

/// A ledger entry as the UI and rules see it, decoupled from Drift rows.
class LedgerEntry {
  const LedgerEntry({
    required this.id,
    required this.kind,
    required this.amountPaise,
    required this.cashDeltaPaise,
    required this.creditDeltaPaise,
    required this.method,
    required this.note,
    required this.source,
    required this.occurredAt,
    this.customerId,
    this.customerName,
    this.supplierId,
    this.supplierName,
    this.isReversed = false,
    this.reversalOfId,
    this.externalRef,
    this.lines = const <LedgerLine>[],
  });

  final int id;
  final TransactionKind kind;
  final int amountPaise;
  final int cashDeltaPaise;
  final int creditDeltaPaise;
  final PaymentMethod method;
  final String note;
  final EntrySource source;
  final DateTime occurredAt;
  final int? customerId;
  final String? customerName;
  final int? supplierId;
  final String? supplierName;
  final bool isReversed;
  final int? reversalOfId;
  final String? externalRef;
  final List<LedgerLine> lines;

  bool get isInflow => cashDeltaPaise > 0;
  bool get isOutflow => cashDeltaPaise < 0;
}

class LedgerLine {
  const LedgerLine({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPricePaise,
    required this.unitCostPaise,
  });

  final int productId;
  final String productName;
  final double quantity;
  final int unitPricePaise;
  final int unitCostPaise;

  int get totalPaise => (unitPricePaise * quantity).round();
  int get costPaise => (unitCostPaise * quantity).round();
  int get marginPaise => totalPaise - costPaise;
}

class ProductView {
  const ProductView({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.unit,
    required this.purchasePricePaise,
    required this.sellingPricePaise,
    required this.stockQty,
    required this.minStockQty,
    this.barcode = '',
    this.supplierId,
    this.supplierName,
    this.imagePath,
    this.archived = false,
    this.unitsSold30d = 0,
    this.lastSoldAt,
  });

  final int id;
  final String name;
  final String sku;
  final String category;
  final String unit;
  final int purchasePricePaise;
  final int sellingPricePaise;
  final double stockQty;
  final double minStockQty;
  final String barcode;
  final int? supplierId;
  final String? supplierName;
  final String? imagePath;
  final bool archived;
  final double unitsSold30d;
  final DateTime? lastSoldAt;

  int get stockValuePaise => (purchasePricePaise * stockQty).round();
  int get retailValuePaise => (sellingPricePaise * stockQty).round();
  bool get isLowStock => stockQty <= minStockQty;
  bool get isOutOfStock => stockQty <= 0;
  bool get isSlowMoving => stockQty > 0 && unitsSold30d <= 0;
  int get marginPerUnitPaise => sellingPricePaise - purchasePricePaise;

  /// Deterministic reorder suggestion: two cycles of the minimum level.
  double get suggestedReorderQty {
    final double target = minStockQty * 2;
    final double gap = target - stockQty;
    return gap > 0 ? gap : 0;
  }
}

class CustomerView {
  const CustomerView({
    required this.id,
    required this.name,
    this.phone = '',
    this.address = '',
    this.notes = '',
    this.archived = false,
    this.outstandingPaise = 0,
    this.totalCreditGivenPaise = 0,
    this.totalRepaidPaise = 0,
    this.overduePaise = 0,
    this.lastActivityAt,
    this.transactionCount = 0,
  });

  final int id;
  final String name;
  final String phone;
  final String address;
  final String notes;
  final bool archived;
  final int outstandingPaise;
  final int totalCreditGivenPaise;
  final int totalRepaidPaise;
  final int overduePaise;
  final DateTime? lastActivityAt;
  final int transactionCount;

  bool get hasDues => outstandingPaise > 0;
}

class SupplierView {
  const SupplierView({
    required this.id,
    required this.name,
    this.phone = '',
    this.address = '',
    this.notes = '',
    this.archived = false,
    this.payablePaise = 0,
    this.paidPaise = 0,
    this.lastPurchaseAt,
    this.productCount = 0,
  });

  final int id;
  final String name;
  final String phone;
  final String address;
  final String notes;
  final bool archived;
  final int payablePaise;
  final int paidPaise;
  final DateTime? lastPurchaseAt;
  final int productCount;
}

class DashboardSummary {
  const DashboardSummary({
    required this.todaySalesPaise,
    required this.todayExpensesPaise,
    required this.todayCashInPaise,
    required this.todayCashOutPaise,
    required this.outstandingCreditPaise,
    required this.inventoryValuePaise,
    required this.lowStockCount,
    required this.lowStockProducts,
    required this.recentEntries,
    required this.customersWithDues,
    required this.weekSalesPaise,
    required this.weekExpensesPaise,
  });

  final int todaySalesPaise;
  final int todayExpensesPaise;
  final int todayCashInPaise;
  final int todayCashOutPaise;
  final int outstandingCreditPaise;
  final int inventoryValuePaise;
  final int lowStockCount;
  final List<ProductView> lowStockProducts;
  final List<LedgerEntry> recentEntries;
  final int customersWithDues;
  final int weekSalesPaise;
  final int weekExpensesPaise;

  int get netCashMovementPaise => todayCashInPaise - todayCashOutPaise;
  int get todayProfitEstimatePaise => todaySalesPaise - todayExpensesPaise;
}

class SpendingPolicy {
  const SpendingPolicy({
    required this.maxPerPaymentLamports,
    required this.dailyLimitLamports,
    required this.savedRecipientsOnly,
    required this.devnetOnly,
    required this.requireApproval,
    this.updatedAt,
  });

  final int maxPerPaymentLamports;
  final int dailyLimitLamports;
  final bool savedRecipientsOnly;
  final bool devnetOnly;
  final bool requireApproval;
  final DateTime? updatedAt;

  static const SpendingPolicy defaults = SpendingPolicy(
    maxPerPaymentLamports: 100000000,
    dailyLimitLamports: 1000000000,
    savedRecipientsOnly: true,
    devnetOnly: true,
    requireApproval: true,
  );
}

class PolicyViolation {
  const PolicyViolation(this.code, this.message);

  final String code;
  final String message;
}

class PolicyEvaluation {
  const PolicyEvaluation({
    required this.allowed,
    required this.violations,
    required this.passedChecks,
    required this.requiresApproval,
    required this.remainingDailyLamports,
  });

  final bool allowed;
  final List<PolicyViolation> violations;
  final List<String> passedChecks;
  final bool requiresApproval;
  final int remainingDailyLamports;

  String get summary => allowed
      ? 'All ${passedChecks.length} policy checks passed'
      : '${violations.length} policy check${violations.length == 1 ? '' : 's'} failed';
}

class ParsedCommand {
  const ParsedCommand({
    required this.intent,
    required this.rawText,
    this.amountPaise,
    this.amountLamports,
    this.customerId,
    this.customerName,
    this.productId,
    this.productName,
    this.payeeId,
    this.payeeName,
    this.payeeAddress,
    this.method,
    this.quantity,
    this.category,
    this.confidence = 0.5,
    this.parsedLocally = true,
    this.notes = const <String>[],
  });

  final AssistantIntent intent;
  final String rawText;
  final int? amountPaise;
  final int? amountLamports;
  final int? customerId;
  final String? customerName;
  final int? productId;
  final String? productName;
  final int? payeeId;
  final String? payeeName;
  final String? payeeAddress;
  final PaymentMethod? method;
  final double? quantity;
  final String? category;
  final double confidence;
  final bool parsedLocally;
  final List<String> notes;

  bool get isRecordingCommand => const {
    AssistantIntent.recordSale,
    AssistantIntent.recordExpense,
    AssistantIntent.recordIncome,
    AssistantIntent.recordPaymentReceived,
    AssistantIntent.giveCredit,
  }.contains(intent);

  bool get isQuery => const {
    AssistantIntent.queryTodaySales,
    AssistantIntent.queryOutstanding,
    AssistantIntent.queryLowStock,
    AssistantIntent.queryStock,
    AssistantIntent.queryTopProducts,
    AssistantIntent.queryAffordability,
    AssistantIntent.queryWalletBalance,
  }.contains(intent);

  bool get isPayment => intent == AssistantIntent.paySolana;

  ParsedCommand copyWith({
    AssistantIntent? intent,
    int? amountPaise,
    int? customerId,
    String? customerName,
    PaymentMethod? method,
    double? confidence,
    bool? parsedLocally,
    List<String>? notes,
  }) {
    return ParsedCommand(
      intent: intent ?? this.intent,
      rawText: rawText,
      amountPaise: amountPaise ?? this.amountPaise,
      amountLamports: amountLamports,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      productId: productId,
      productName: productName,
      payeeId: payeeId,
      payeeName: payeeName,
      payeeAddress: payeeAddress,
      method: method ?? this.method,
      quantity: quantity,
      category: category,
      confidence: confidence ?? this.confidence,
      parsedLocally: parsedLocally ?? this.parsedLocally,
      notes: notes ?? this.notes,
    );
  }

  /// Human readable label used in the confirmation sheet.
  String get actionLabel {
    switch (intent) {
      case AssistantIntent.recordSale:
        return 'Record sale';
      case AssistantIntent.recordExpense:
        return 'Record expense';
      case AssistantIntent.recordIncome:
        return 'Record income';
      case AssistantIntent.recordPaymentReceived:
        return 'Record money received';
      case AssistantIntent.giveCredit:
        return 'Give credit (udhaar)';
      case AssistantIntent.paySolana:
        return 'Create Solana payment';
      case AssistantIntent.queryTodaySales:
        return "Answer: today's sales";
      case AssistantIntent.queryOutstanding:
        return 'Answer: outstanding credit';
      case AssistantIntent.queryLowStock:
        return 'Answer: low stock';
      case AssistantIntent.queryStock:
        return 'Answer: stock level';
      case AssistantIntent.queryTopProducts:
        return 'Answer: best sellers';
      case AssistantIntent.queryAffordability:
        return 'Answer: affordability';
      case AssistantIntent.queryWalletBalance:
        return 'Answer: wallet balance';
      case AssistantIntent.smallTalk:
        return 'Assistant';
      case AssistantIntent.unknown:
        return 'Not understood';
    }
  }
}

class AssistantAnswer {
  const AssistantAnswer({
    required this.message,
    this.command,
    this.usedCloud = false,
    this.requiresConfirmation = false,
    this.dataPeriod,
    this.isEstimate = false,
  });

  final String message;
  final ParsedCommand? command;
  final bool usedCloud;
  final bool requiresConfirmation;
  final String? dataPeriod;
  final bool isEstimate;
}

class PaymentProposal {
  const PaymentProposal({
    required this.id,
    required this.recipientName,
    required this.recipientAddress,
    required this.amountLamports,
    required this.network,
    required this.status,
    required this.createdAt,
    this.payeeId,
    this.requestText = '',
    this.signature,
    this.explorerUrl,
    this.errorMessage,
    this.ledgerTransactionId,
    this.evaluation,
    this.availableBalanceLamports,
    this.dailySpentLamports = 0,
  });

  final int id;
  final String recipientName;
  final String recipientAddress;
  final int amountLamports;
  final String network;
  final PaymentStatus status;
  final DateTime createdAt;
  final int? payeeId;
  final String requestText;
  final String? signature;
  final String? explorerUrl;
  final String? errorMessage;
  final int? ledgerTransactionId;
  final PolicyEvaluation? evaluation;
  final int? availableBalanceLamports;
  final int dailySpentLamports;

  PaymentProposal copyWith({
    PaymentStatus? status,
    String? signature,
    String? explorerUrl,
    String? errorMessage,
    int? ledgerTransactionId,
    PolicyEvaluation? evaluation,
    int? availableBalanceLamports,
    int? dailySpentLamports,
  }) {
    return PaymentProposal(
      id: id,
      recipientName: recipientName,
      recipientAddress: recipientAddress,
      amountLamports: amountLamports,
      network: network,
      status: status ?? this.status,
      createdAt: createdAt,
      payeeId: payeeId,
      requestText: requestText,
      signature: signature ?? this.signature,
      explorerUrl: explorerUrl ?? this.explorerUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      ledgerTransactionId: ledgerTransactionId ?? this.ledgerTransactionId,
      evaluation: evaluation ?? this.evaluation,
      availableBalanceLamports:
          availableBalanceLamports ?? this.availableBalanceLamports,
      dailySpentLamports: dailySpentLamports ?? this.dailySpentLamports,
    );
  }
}

class CustomerRef {
  const CustomerRef(this.id, this.name);
  final int id;
  final String name;
}

class ProductRef {
  const ProductRef(this.id, this.name, this.stockQty, this.sellingPricePaise);
  final int id;
  final String name;
  final double stockQty;
  final int sellingPricePaise;
}

class PayeeRef {
  const PayeeRef(this.id, this.name, this.walletAddress);
  final int id;
  final String name;
  final String walletAddress;
}

class WalletSnapshot {
  const WalletSnapshot({
    required this.connected,
    this.address,
    this.balanceLamports,
    this.network = 'devnet',
    this.balanceError,
    this.lastActivity,
    this.isMwaSupported = true,
  });

  final bool connected;
  final String? address;
  final int? balanceLamports;
  final String network;
  final String? balanceError;
  final DateTime? lastActivity;
  final bool isMwaSupported;

  WalletSnapshot copyWith({
    bool? connected,
    String? address,
    int? balanceLamports,
    String? balanceError,
    DateTime? lastActivity,
    bool? isMwaSupported,
  }) {
    return WalletSnapshot(
      connected: connected ?? this.connected,
      address: address ?? this.address,
      balanceLamports: balanceLamports ?? this.balanceLamports,
      network: network,
      balanceError: balanceError ?? this.balanceError,
      lastActivity: lastActivity ?? this.lastActivity,
      isMwaSupported: isMwaSupported ?? this.isMwaSupported,
    );
  }
}

class ProductSales {
  const ProductSales({
    required this.productId,
    required this.productName,
    required this.units,
    required this.revenuePaise,
    required this.marginPaise,
  });

  final int productId;
  final String productName;
  final double units;
  final int revenuePaise;
  final int marginPaise;
}
