import '../core/money.dart';
import '../data/repositories/customer_repository.dart';
import '../data/repositories/inventory_repository.dart';
import '../data/repositories/ledger_repository.dart';
import '../domain/enums.dart';
import '../domain/models.dart';
import '../domain/rules/phrases.dart';

class CommandException implements Exception {
  CommandException(this.message);
  final String message;
  @override
  String toString() => message;
}

class ExecutionResult {
  const ExecutionResult({required this.ledgerId, required this.message});
  final int ledgerId;
  final String message;
}

/// Turns a confirmed [ParsedCommand] into journal entries.
///
/// This is the only place the assistant is allowed to write. It validates all
/// values again, because speech recognition and cloud models both make errors.
class CommandExecutor {
  CommandExecutor({
    required this.ledger,
    required this.customers,
    required this.inventory,
  });

  final LedgerRepository ledger;
  final CustomerRepository customers;
  final InventoryRepository inventory;

  Future<ExecutionResult> execute(
    ParsedCommand command, {
    String languageCode = 'en',
  }) async {
    final Phrases phrases = Phrases(languageCode);
    final int? amount = command.amountPaise;
    if (amount == null || amount <= 0) {
      throw CommandException('An amount is required.');
    }

    switch (command.intent) {
      case AssistantIntent.recordSale:
        return _recordSale(command, amount);

      case AssistantIntent.recordExpense:
        final int id = await ledger.recordEntry(
          kind: TransactionKind.expense,
          amountPaise: amount,
          method: command.method ?? PaymentMethod.cash,
          note: command.category == null
              ? command.rawText
              : '${command.category}: ${command.rawText}',
          source: EntrySource.voice,
        );
        return ExecutionResult(
          ledgerId: id,
          message: 'Expense of ${Money.format(amount)} recorded.',
        );

      case AssistantIntent.recordIncome:
        final int id = await ledger.recordEntry(
          kind: TransactionKind.income,
          amountPaise: amount,
          method: command.method ?? PaymentMethod.cash,
          customerId: command.customerId,
          note: command.rawText,
          source: EntrySource.voice,
        );
        return ExecutionResult(
          ledgerId: id,
          message: 'Income of ${Money.format(amount)} recorded.',
        );

      case AssistantIntent.recordPaymentReceived:
        final int? customerId = command.customerId;
        TransactionKind kind = TransactionKind.cashReceived;
        if (customerId != null) {
          final List<CustomerView> all = await customers.loadCustomers();
          CustomerView? customer;
          for (final CustomerView row in all) {
            if (row.id == customerId) customer = row;
          }
          if (customer == null) {
            throw CommandException('Customer not found.');
          }
          if (customer.outstandingPaise > 0) {
            if (amount > customer.outstandingPaise) {
              throw CommandException(
                'Amount is more than ${customer.name}\'s outstanding '
                '${Money.format(customer.outstandingPaise)}.',
              );
            }
            kind = TransactionKind.creditRepayment;
          }
        }
        final int id = await ledger.recordEntry(
          kind: kind,
          amountPaise: amount,
          method: command.method ?? PaymentMethod.cash,
          customerId: customerId,
          note: command.rawText,
          source: EntrySource.voice,
        );
        return ExecutionResult(
          ledgerId: id,
          message: '${Money.format(amount)} received and recorded.',
        );

      case AssistantIntent.giveCredit:
        if (command.customerId == null) {
          throw CommandException('Choose the customer for this credit.');
        }
        final int id = await ledger.recordEntry(
          kind: TransactionKind.creditGiven,
          amountPaise: amount,
          method: PaymentMethod.credit,
          customerId: command.customerId,
          note: command.rawText,
          source: EntrySource.voice,
        );
        return ExecutionResult(
          ledgerId: id,
          message:
              'Credit of ${Money.format(amount)} added for ${command.customerName ?? 'the customer'}.',
        );

      case AssistantIntent.paySolana:
        throw CommandException(
          'Solana payments go through the wallet approval screen.',
        );

      default:
        throw CommandException(phrases.notUnderstood);
    }
  }

  Future<ExecutionResult> _recordSale(
    ParsedCommand command,
    int amount,
  ) async {
    final List<SaleLineInput> lines = <SaleLineInput>[];
    if (command.productId != null && command.quantity != null) {
      final product = await inventory.findProduct(command.productId!);
      if (product == null) {
        throw CommandException('Product not found.');
      }
      if (command.quantity! <= 0) {
        throw CommandException('Quantity must be greater than zero.');
      }
      if (product.stockQty < command.quantity!) {
        throw CommandException(
          '${product.name} has only ${product.stockQty} ${product.unit} left.',
        );
      }
      final int unitPrice =
          product.sellingPricePaise > 0 ? product.sellingPricePaise : amount;
      lines.add(SaleLineInput(
        productId: product.id,
        quantity: command.quantity!,
        unitPricePaise: unitPrice,
        unitCostPaise: product.purchasePricePaise,
      ));
    }

    final int id = await ledger.recordEntry(
      kind: TransactionKind.sale,
      amountPaise: amount,
      method: command.method ?? PaymentMethod.cash,
      customerId: command.customerId,
      note: command.rawText,
      source: EntrySource.voice,
      lines: lines,
    );
    return ExecutionResult(
      ledgerId: id,
      message: 'Sale of ${Money.format(amount)} recorded.',
    );
  }
}
