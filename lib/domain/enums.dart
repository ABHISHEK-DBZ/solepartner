/// Canonical transaction kinds supported by the ledger.
///
/// A kind describes the business event, not the payment rail. The cash and
/// credit effect of each kind is defined once in `LedgerRules.deltasFor`.
enum TransactionKind {
  sale,
  income,
  expense,
  cashReceived,
  creditGiven,
  creditRepayment,
  bankTransferIn,
  bankTransferOut,
  upiReceived,
  upiPaid,
  purchasePayment,
  solanaPayment,
}

/// How money moved. `credit` means no money moved at all.
enum PaymentMethod { cash, upi, bank, credit, solana, other }

/// Where a record came from. Used for audit and for the UI badge.
enum EntrySource { manual, voice, assistant, payment }

/// Every stock change must be one of these; stock never changes silently.
enum StockMovementKind {
  opening,
  purchaseReceipt,
  sale,
  adjustment,
  returnIn,
  returnOut,
  damage,
  expiry,
}

/// Lifecycle of an on-chain payment.
enum PaymentStatus {
  draft,
  awaitingApproval,
  approved,
  submitted,
  confirmed,
  failed,
  rejected,
  unknown,
}

/// Intents the assistant can recognise.
enum AssistantIntent {
  recordSale,
  recordExpense,
  recordIncome,
  recordPaymentReceived,
  giveCredit,
  queryTodaySales,
  queryOutstanding,
  queryLowStock,
  queryStock,
  queryTopProducts,
  queryAffordability,
  paySolana,
  queryWalletBalance,
  smallTalk,
  unknown,
}

extension TransactionKindLabel on TransactionKind {
  String get label {
    switch (this) {
      case TransactionKind.sale:
        return 'Sale';
      case TransactionKind.income:
        return 'Income';
      case TransactionKind.expense:
        return 'Expense';
      case TransactionKind.cashReceived:
        return 'Cash received';
      case TransactionKind.creditGiven:
        return 'Credit given';
      case TransactionKind.creditRepayment:
        return 'Credit repayment';
      case TransactionKind.bankTransferIn:
        return 'Bank transfer in';
      case TransactionKind.bankTransferOut:
        return 'Bank transfer out';
      case TransactionKind.upiReceived:
        return 'UPI received';
      case TransactionKind.upiPaid:
        return 'UPI paid';
      case TransactionKind.purchasePayment:
        return 'Supplier payment';
      case TransactionKind.solanaPayment:
        return 'Solana payment';
    }
  }

  /// True when this kind increases what customers owe the merchant.
  bool get isCreditSide => this == TransactionKind.creditGiven;

  /// True when this kind is money leaving the business.
  bool get isOutflow =>
      this == TransactionKind.expense ||
      this == TransactionKind.bankTransferOut ||
      this == TransactionKind.upiPaid ||
      this == TransactionKind.purchasePayment ||
      this == TransactionKind.solanaPayment;
}

extension StockMovementKindLabel on StockMovementKind {
  String get label {
    switch (this) {
      case StockMovementKind.opening:
        return 'Opening stock';
      case StockMovementKind.purchaseReceipt:
        return 'Purchase received';
      case StockMovementKind.sale:
        return 'Sale';
      case StockMovementKind.adjustment:
        return 'Adjustment';
      case StockMovementKind.returnIn:
        return 'Customer return';
      case StockMovementKind.returnOut:
        return 'Return to supplier';
      case StockMovementKind.damage:
        return 'Damaged';
      case StockMovementKind.expiry:
        return 'Expired';
    }
  }

  /// Whether the movement adds stock.
  bool get isInbound =>
      this == StockMovementKind.opening ||
      this == StockMovementKind.purchaseReceipt ||
      this == StockMovementKind.returnIn ||
      this == StockMovementKind.adjustment;

  bool get requiresReason =>
      this == StockMovementKind.adjustment ||
      this == StockMovementKind.damage ||
      this == StockMovementKind.expiry;
}

extension PaymentStatusLabel on PaymentStatus {
  String get label {
    switch (this) {
      case PaymentStatus.draft:
        return 'Draft';
      case PaymentStatus.awaitingApproval:
        return 'Awaiting approval';
      case PaymentStatus.approved:
        return 'Approved';
      case PaymentStatus.submitted:
        return 'Submitted';
      case PaymentStatus.confirmed:
        return 'Confirmed';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.rejected:
        return 'Rejected';
      case PaymentStatus.unknown:
        return 'Unknown';
    }
  }

  bool get isTerminal =>
      this == PaymentStatus.confirmed ||
      this == PaymentStatus.failed ||
      this == PaymentStatus.rejected;

  bool get isOpen =>
      this == PaymentStatus.submitted || this == PaymentStatus.unknown;
}

const Map<String, String> kSupportedLanguages = {
  'en': 'English',
  'hi': 'हिन्दी',
  'hi-Latn': 'Hinglish',
};
