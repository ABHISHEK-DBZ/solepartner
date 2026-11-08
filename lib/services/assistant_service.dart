import 'dart:convert';

import '../core/money.dart';
import '../data/db/app_database.dart';
import '../data/repositories/customer_repository.dart';
import '../data/repositories/inventory_repository.dart';
import '../data/repositories/ledger_repository.dart';
import '../data/repositories/payment_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../domain/enums.dart';
import '../domain/models.dart';
import '../domain/rules/phrases.dart';
import '../domain/rules/voice_parser.dart';
import 'cloud_ai_client.dart';

/// Hybrid assistant: the local parser always runs first; the cloud model is
/// only asked to understand language, never to compute money.
class AssistantService {
  AssistantService({
    required this.ledger,
    required this.customers,
    required this.inventory,
    required this.payments,
    required this.settings,
    this.walletBalanceLamports,
    VoiceParser parser = const VoiceParser(),
  }) : _parser = parser;

  final LedgerRepository ledger;
  final CustomerRepository customers;
  final InventoryRepository inventory;
  final PaymentRepository payments;
  final SettingsRepository settings;
  final VoiceParser _parser;

  /// Optional bridge to the Solana wallet for balance questions.
  final Future<int?> Function()? walletBalanceLamports;

  static const Set<AssistantIntent> _cloudIntents = <AssistantIntent>{
    AssistantIntent.recordSale,
    AssistantIntent.recordExpense,
    AssistantIntent.recordIncome,
    AssistantIntent.recordPaymentReceived,
    AssistantIntent.giveCredit,
    AssistantIntent.queryTodaySales,
    AssistantIntent.queryOutstanding,
    AssistantIntent.queryLowStock,
    AssistantIntent.queryStock,
    AssistantIntent.queryTopProducts,
    AssistantIntent.queryAffordability,
    AssistantIntent.queryWalletBalance,
    AssistantIntent.smallTalk,
  };

  Future<AssistantAnswer> ask(
    String rawText, {
    String languageCode = 'en',
    bool allowCloud = true,
  }) async {
    final Phrases phrases = Phrases(languageCode);
    final String text = rawText.trim();
    if (text.isEmpty) {
      return AssistantAnswer(message: phrases.notUnderstood);
    }

    final List<CustomerView> customerViews = await customers.loadCustomers();
    final List<Product> productRows = await inventory.allProducts();
    final List<Payee> payees = await payments.loadPayees();

    final ParsedCommand parsed = _parser.parse(
      text,
      customers: customerViews
          .where((CustomerView c) => !c.archived)
          .map((CustomerView c) => CustomerRef(c.id, c.name))
          .toList(),
      products: productRows
          .where((Product p) => !p.archived)
          .map((Product p) =>
              ProductRef(p.id, p.name, p.stockQty, p.sellingPricePaise))
          .toList(),
      payees: payees
          .map((Payee p) => PayeeRef(p.id, p.name, p.walletAddress))
          .toList(),
    );

    if (parsed.intent == AssistantIntent.smallTalk) {
      return AssistantAnswer(message: phrases.greeting, dataPeriod: null);
    }

    if (parsed.isQuery) {
      return _answerQuery(parsed, phrases);
    }

    if (parsed.isRecordingCommand) {
      return _confirmation(parsed, phrases);
    }

    if (parsed.isPayment) {
      final String sol = parsed.amountLamports == null
          ? '—'
          : Money.formatSol(parsed.amountLamports!);
      return AssistantAnswer(
        message: phrases.paymentPrepared(
          sol,
          parsed.payeeName ?? 'the chosen recipient',
        ),
        command: parsed,
        requiresConfirmation: true,
      );
    }

    if (allowCloud) {
      final AssistantAnswer? cloud = await _askCloud(text, phrases);
      if (cloud != null) return cloud;
    }

    return AssistantAnswer(message: phrases.notUnderstood);
  }

  AssistantAnswer _confirmation(ParsedCommand parsed, Phrases phrases) {
    final String amount = parsed.amountPaise == null
        ? 'amount missing'
        : Money.format(parsed.amountPaise!);
    return AssistantAnswer(
      message: phrases.confirmation(
        actionLabel: parsed.actionLabel,
        amount: amount,
        customerName: parsed.customerName,
      ),
      command: parsed,
      requiresConfirmation: true,
    );
  }

  Future<AssistantAnswer> _answerQuery(
    ParsedCommand parsed,
    Phrases phrases,
  ) async {
    switch (parsed.intent) {
      case AssistantIntent.queryTodaySales:
        final Map<String, int> totals = await ledger.todayTotals();
        return AssistantAnswer(
          message: phrases.todaySales(
            totals['salesPaise'] ?? 0,
            totals['expensesPaise'] ?? 0,
            totals['netCashPaise'] ?? 0,
          ),
          dataPeriod: 'Today, local time',
        );

      case AssistantIntent.queryOutstanding:
        final List<CustomerView> all = await customers.loadCustomers();
        final List<CustomerView> withDues = all
            .where((CustomerView c) => c.outstandingPaise > 0)
            .toList()
          ..sort((CustomerView a, CustomerView b) =>
              b.outstandingPaise.compareTo(a.outstandingPaise));
        final int total =
            withDues.fold(0, (int sum, CustomerView c) => sum + c.outstandingPaise);
        final String top = withDues
            .take(3)
            .map((CustomerView c) => '${c.name} ${Money.format(c.outstandingPaise)}')
            .join(', ');
        return AssistantAnswer(
          message: phrases.outstanding(total, withDues.length, top),
          dataPeriod: 'All recorded credit',
        );

      case AssistantIntent.queryLowStock:
        final List<ProductView> products = await inventory.loadProductViews();
        final List<ProductView> low =
            products.where((ProductView p) => p.isLowStock).toList()
              ..sort((ProductView a, ProductView b) =>
                  a.stockQty.compareTo(b.stockQty));
        final String names =
            low.take(3).map((ProductView p) => p.name).join(', ');
        return AssistantAnswer(
          message: phrases.lowStock(low.length, names),
          dataPeriod: 'Current stock',
        );

      case AssistantIntent.queryStock:
        final List<ProductView> products = await inventory.loadProductViews();
        if (parsed.productId != null) {
          for (final ProductView product in products) {
            if (product.id == parsed.productId) {
              return AssistantAnswer(
                message: phrases.stockLevel(
                  product.name,
                  product.stockQty,
                  product.unit,
                  product.stockValuePaise,
                ),
                dataPeriod: 'Current stock',
              );
            }
          }
        }
        final int value =
            products.fold(0, (int sum, ProductView p) => sum + p.stockValuePaise);
        final int lowCount =
            products.where((ProductView p) => p.isLowStock).length;
        return AssistantAnswer(
          message: phrases.totalStock(products.length, value, lowCount),
          dataPeriod: 'Current stock',
        );

      case AssistantIntent.queryTopProducts:
        final List<ProductSales> sales =
            await inventory.productSales(days: 30, limit: 5);
        if (sales.isEmpty) {
          return AssistantAnswer(
            message: 'No product-linked sales in the last 30 days.',
            dataPeriod: 'Last 30 days',
          );
        }
        final String list = sales
            .map((ProductSales s) =>
                '${s.productName} (${Money.format(s.revenuePaise)})')
            .join(', ');
        return AssistantAnswer(
          message: phrases.topProducts(list),
          dataPeriod: 'Last 30 days',
          isEstimate: true,
        );

      case AssistantIntent.queryAffordability:
        if (parsed.amountPaise == null) {
          return AssistantAnswer(
            message: 'Tell me the amount you are considering.',
            dataPeriod: 'Estimated cash on hand',
          );
        }
        final int cash = await ledger.cashBalancePaise();
        return AssistantAnswer(
          message: phrases.affordability(parsed.amountPaise!, cash),
          dataPeriod: 'Estimated cash on hand from recorded entries',
          isEstimate: true,
        );

      case AssistantIntent.queryWalletBalance:
        final int? lamports = await walletBalanceLamports?.call();
        if (lamports == null) {
          return const AssistantAnswer(
            message: 'Connect a Devnet wallet first to see its SOL balance.',
          );
        }
        return AssistantAnswer(
          message: 'Your Devnet wallet holds '
              '${Money.formatSolWithUnit(lamports)}.',
        );

      default:
        return AssistantAnswer(message: phrases.notUnderstood);
    }
  }

  Future<AssistantAnswer?> _askCloud(String text, Phrases phrases) async {
    if (!await settings.cloudConsentEnabled()) {
      return const AssistantAnswer(
        message: 'Cloud AI is off. Turn on "Allow cloud AI" in Settings, or '
            'use the built-in commands.',
      );
    }
    final config = await settings.loadAiConfig();
    if (config == null || !config.isConfigured) {
      return const AssistantAnswer(
        message: 'No AI key is configured. Add one in Settings, or use the '
            'built-in commands.',
      );
    }

    final CloudAiClient client = CloudAiClient(config);
    try {
      final Map<String, int> totals = await ledger.todayTotals();
      final List<CustomerView> allCustomers = await customers.loadCustomers();
      final List<ProductView> products = await inventory.loadProductViews();
      final int outstanding = allCustomers.fold<int>(
          0, (int sum, CustomerView c) => sum + c.outstandingPaise);

      // Data minimisation: only aggregates and the command text leave the
      // device. No customer phone numbers, addresses or notes are sent.
      final String userPayload = jsonEncode(<String, Object?>{
        'language': phrases.languageCode,
        'command': text,
        'businessSummary': <String, Object?>{
          'salesTodayPaise': totals['salesPaise'],
          'expensesTodayPaise': totals['expensesPaise'],
          'outstandingPaise': outstanding,
          'customerCount': allCustomers.length,
          'productCount': products.length,
          'lowStockCount':
              products.where((ProductView p) => p.isLowStock).length,
        },
        'capabilities': _cloudIntents.map((AssistantIntent i) => i.name).toList(),
      });

      final Map<String, dynamic> json = await client.completeJson(
        system: _systemPrompt,
        user: userPayload,
      );
      return await _fromCloudJson(
        json,
        phrases,
        customers: allCustomers,
        products: products,
      );
    } on CloudAiException catch (error) {
      return AssistantAnswer(message: 'AI request failed: ${error.message}');
    } catch (error) {
      return AssistantAnswer(message: 'AI request failed: $error');
    } finally {
      client.dispose();
    }
  }

  Future<AssistantAnswer?> _fromCloudJson(
    Map<String, dynamic> json,
    Phrases phrases, {
    required List<CustomerView> customers,
    required List<ProductView> products,
  }) async {
    final String intentName =
        (json['intent'] as String?)?.trim() ?? 'unknown';
    final AssistantIntent? intent = _intentFromName(intentName);
    final String? reply = (json['reply'] as String?)?.trim();

    if (intent == null || intent == AssistantIntent.unknown) {
      if (reply != null && reply.isNotEmpty) {
        return AssistantAnswer(
          message: reply,
          usedCloud: true,
        );
      }
      return null;
    }

    final double? amountRupees = (json['amountRupees'] as num?)?.toDouble();
    final String? customerName = (json['customerName'] as String?)?.trim();
    final String? productName = (json['productName'] as String?)?.trim();
    final String? methodName = (json['method'] as String?)?.trim();

    return _buildCloudCommand(
      intent: intent,
      amountPaise:
          amountRupees == null ? null : Money.fromRupees(amountRupees),
      customerName: customerName,
      customerId: _matchCustomer(customers, customerName),
      productName: productName,
      productId: _matchProduct(products, productName),
      method: _methodFromName(methodName),
      text: json['command'] as String? ?? '',
      phrases: phrases,
      reply: reply,
    );
  }

  static int? _matchCustomer(List<CustomerView> customers, String? name) {
    if (name == null || name.isEmpty) return null;
    for (final CustomerView customer in customers) {
      if (customer.name.toLowerCase() == name.toLowerCase()) return customer.id;
    }
    return null;
  }

  static int? _matchProduct(List<ProductView> products, String? name) {
    if (name == null || name.isEmpty) return null;
    for (final ProductView product in products) {
      if (product.name.toLowerCase() == name.toLowerCase()) return product.id;
    }
    return null;
  }

  Future<AssistantAnswer> _buildCloudCommand({
    required AssistantIntent intent,
    required int? amountPaise,
    required String? customerName,
    required int? customerId,
    required String? productName,
    required int? productId,
    required PaymentMethod? method,
    required String text,
    required Phrases phrases,
    String? reply,
  }) async {
    final ParsedCommand command = ParsedCommand(
      intent: intent,
      rawText: text,
      amountPaise: amountPaise,
      customerId: customerId,
      customerName: customerName,
      productId: productId,
      productName: productName,
      method: method,
      parsedLocally: false,
      confidence: 0.7,
    );

    if (command.isQuery) {
      return await _answerQuery(command, phrases);
    }
    if (command.isRecordingCommand) {
      return AssistantAnswer(
        message: phrases.confirmation(
          actionLabel: command.actionLabel,
          amount: amountPaise == null ? 'amount missing' : Money.format(amountPaise),
          customerName: customerName,
        ),
        command: command,
        usedCloud: true,
        requiresConfirmation: true,
      );
    }
    return AssistantAnswer(
      message: reply?.isNotEmpty == true ? reply! : phrases.notUnderstood,
      usedCloud: true,
    );
  }

  static AssistantIntent? _intentFromName(String name) {
    for (final AssistantIntent intent in AssistantIntent.values) {
      if (intent.name.toLowerCase() == name.toLowerCase()) return intent;
    }
    return null;
  }

  static PaymentMethod? _methodFromName(String? name) {
    if (name == null) return null;
    for (final PaymentMethod method in PaymentMethod.values) {
      if (method.name.toLowerCase() == name.toLowerCase()) return method;
    }
    return null;
  }

  static const String _systemPrompt = '''
You are the language layer of KhataCopilot, an Indian merchant ledger app.
Convert the merchant command into ONE JSON object and nothing else:
{"intent":"<one of the capabilities>","amountRupees":<number or null>,
 "customerName":<string or null>,"productName":<string or null>,
 "method":"cash|upi|bank|credit|solana|other|null","reply":"<short reply>"}

Rules:
- Never calculate totals, balances or margins. The app computes money.
- Never invent customer or product names that are not in the command.
- "paid me", "diya", "jama" -> recordPaymentReceived.
- "udhaar", "credit do", "khata" -> giveCredit.
- "kharch", "bill", "expense" -> recordExpense.
- "sold", "becha", "bikri" -> recordSale.
- Questions about sales, stock, dues -> the matching query intent.
- Use the merchant's language for "reply".
- If unclear, use intent "unknown".
''';
}
