import '../../core/money.dart';
import '../enums.dart';
import '../models.dart';

/// Deterministic, offline-first natural language parser for merchant commands.
///
/// The parser never invents totals. It only extracts intent and entities; the
/// repositories and rules compute money. When nothing matches confidently the
/// intent is [AssistantIntent.unknown] so the assistant can ask, or fall back
/// to cloud AI if the merchant has configured it.
class VoiceParser {
  const VoiceParser();

  static const List<String> _greetings = <String>[
    'hi',
    'hello',
    'hey',
    'namaste',
    'namaskar',
    'thanks',
    'thank you',
    'dhanyavad',
    'नमस्ते',
    'नमस्कार',
    'धन्यवाद',
    'हैलो',
  ];

  static const List<String> _creditWords = <String>[
    'udhaar',
    'udhar',
    'udhari',
    'credit',
    'khata',
    'khate',
    'baki',
    'baaki',
    'likh do',
    'उधार',
    'उधारी',
    'खाता',
    'खाते',
    'बाकी',
    'लिख दो',
    'लिखो',
  ];

  static const List<String> _repaymentWords = <String>[
    'paid',
    'repaid',
    'repay',
    'jama',
    'diya',
    'de diya',
    'wapas',
    'settled',
    'settle',
    'mila',
    'received from',
    'cleared',
    'दिया',
    'जमा',
    'वापस',
    'मिला',
    'चुका',
    'चुकता',
  ];

  static const List<String> _expenseWords = <String>[
    'expense',
    'kharch',
    'kharcha',
    'bill',
    'bought',
    'kharida',
    'kharid',
    'electricity',
    'rent',
    'salary',
    'fuel',
    'petrol',
    'diesel',
    'transport',
    'tea',
    'chai',
    'supplier payment',
    'purchase',
    'खर्च',
    'खर्चा',
    'बिल',
    'खरीदा',
    'खरीद',
    'बिजली',
    'किराया',
    'वेतन',
    'सैलरी',
    'तेल',
    'चाय',
  ];

  static const List<String> _saleWords = <String>[
    'sale',
    'sales',
    'sold',
    'becha',
    'bech',
    'bechi',
    'bikri',
    'bik gaya',
    'bik gayi',
    'बेचा',
    'बेच',
    'बेची',
    'बिक्री',
    'बिक गया',
    'बिक गई',
  ];

  static const List<String> _incomeWords = <String>[
    'income',
    'earning',
    'earned',
    'kamai',
    'aay',
    'received',
    'mila',
    'कमाई',
    'आय',
    'मिला',
  ];

  static const List<String> _sendWords = <String>[
    'send',
    'transfer',
    'bhejo',
    'bhej do',
    'pay',
    'de do',
    'karo',
    'kar do',
    'भेजो',
    'भेज दो',
    'भुगतान',
    'दे दो',
    'करो',
    'कर दो',
    'ट्रांसफर',
  ];

  ParsedCommand parse(
    String rawText, {
    List<CustomerRef> customers = const <CustomerRef>[],
    List<ProductRef> products = const <ProductRef>[],
    List<PayeeRef> payees = const <PayeeRef>[],
  }) {
    final String text = _normalize(rawText);
    if (text.isEmpty) {
      return const ParsedCommand(
        intent: AssistantIntent.unknown,
        rawText: '',
        confidence: 0,
      );
    }

    if (_greetings.contains(text)) {
      return ParsedCommand(
        intent: AssistantIntent.smallTalk,
        rawText: rawText,
        confidence: 0.95,
      );
    }

    final PaymentMethod? method = _detectMethod(text);
    final _NameMatch? customer = _matchName(
      text,
      customers.map((CustomerRef c) => (c.id, c.name)).toList(),
    );
    final _NameMatch? product = _matchName(
      text,
      products.map((ProductRef p) => (p.id, p.name)).toList(),
    );
    final _NameMatch? payee = _matchName(
      text,
      payees.map((PayeeRef p) => (p.id, p.name)).toList(),
    );

    // --- Queries -----------------------------------------------------------
    if (_hasAny(text, <String>['today', 'aaj', 'आज']) &&
        _hasAny(text, <String>[
          'sales',
          'sale',
          'becha',
          'bikri',
          'kamai',
          'earning',
          'business',
          'dhanda',
          'बिक्री',
          'बेचा',
          'कमाई',
          'धंधा',
        ])) {
      return ParsedCommand(
        intent: AssistantIntent.queryTodaySales,
        rawText: rawText,
        confidence: 0.94,
      );
    }

    if (_hasAny(text, <String>[
          'outstanding',
          'owe',
          'owes',
          'pending',
          'udhaar kitna',
          'udhar kitna',
          'baki kitna',
          'kisne',
          'who has to pay',
          'dues',
          'उधार कितना',
          'बाकी कितना',
          'किसने',
        ])) {
      return ParsedCommand(
        intent: AssistantIntent.queryOutstanding,
        rawText: rawText,
        confidence: 0.93,
      );
    }

    if (_hasAny(text, <String>[
      'low stock',
      'kam stock',
      'khatam',
      'reorder',
      'out of stock',
      'stock out',
      'कम स्टॉक',
      'खत्म',
      'स्टॉक खत्म',
    ])) {
      return ParsedCommand(
        intent: AssistantIntent.queryLowStock,
        rawText: rawText,
        confidence: 0.92,
      );
    }

    if (_hasAny(text, <String>['best sell', 'top product', 'sabse zyada', 'most sold', 'सबसे ज्यादा', 'सबसे ज़्यादा'])) {
      return ParsedCommand(
        intent: AssistantIntent.queryTopProducts,
        rawText: rawText,
        confidence: 0.9,
      );
    }

    if (_hasAny(text, <String>['afford', 'kar sakta', 'kar sakti', 'paisa hai', 'खर्च कर सकता', 'पैसा है'])) {
      return ParsedCommand(
        intent: AssistantIntent.queryAffordability,
        rawText: rawText,
        confidence: 0.82,
      );
    }

    if ((_hasAny(text, <String>['sol', 'wallet']) &&
            _hasAny(text, <String>['balance', 'kitna', 'how much', 'बैलेंस', 'कितना'])) ||
        text.contains('sol balance')) {
      return ParsedCommand(
        intent: AssistantIntent.queryWalletBalance,
        rawText: rawText,
        confidence: 0.88,
      );
    }

    if (_hasAny(text, <String>['stock', 'maal', 'inventory', 'kitna bacha', 'स्टॉक', 'माल'])) {
      return ParsedCommand(
        intent: AssistantIntent.queryStock,
        rawText: rawText,
        productId: product?.id,
        productName: product?.name,
        confidence: product != null ? 0.92 : 0.75,
        notes: product == null
            ? const <String>['No matching product, will show overall stock.']
            : const <String>[],
      );
    }

    // --- Solana payment ----------------------------------------------------
    if (text.contains('sol') && _hasAny(text, _sendWords)) {
      final int? lamports = Money.tryParseSol(text);
      return ParsedCommand(
        intent: AssistantIntent.paySolana,
        rawText: rawText,
        amountLamports: lamports,
        payeeId: payee?.id,
        payeeName: payee?.name,
        payeeAddress: payee == null ? null : _addressFor(payee.id, payees),
        method: PaymentMethod.solana,
        confidence: lamports != null ? 0.9 : 0.6,
        notes: payee == null
            ? const <String>['Recipient is not a saved payee yet.']
            : const <String>[],
      );
    }

    // --- Recording ---------------------------------------------------------
    final String amountText = _withoutQuantity(text);
    final _QuantityMatch? quantity = _extractQuantity(text);
    int? amountPaise = Money.tryParsePaise(amountText);

    if (_hasAny(text, _creditWords) &&
        _hasAny(text, <String>[
          'give',
          'do',
          'diya',
          'de',
          'add',
          'likh',
          'likho',
          'kar',
          'दो',
          'दिया',
          'दे',
          'जोड़',
          'लिख',
          'कर',
        ])) {
      return ParsedCommand(
        intent: AssistantIntent.giveCredit,
        rawText: rawText,
        amountPaise: amountPaise,
        customerId: customer?.id,
        customerName: customer?.name,
        method: PaymentMethod.credit,
        confidence: _confidence(
          amount: amountPaise != null,
          named: customer != null,
          method: true,
        ),
        notes: customer == null
            ? const <String>['Customer not recognised, please pick one.']
            : const <String>[],
      );
    }

    if (customer != null && _hasAny(text, _repaymentWords)) {
      return ParsedCommand(
        intent: AssistantIntent.recordPaymentReceived,
        rawText: rawText,
        amountPaise: amountPaise,
        customerId: customer.id,
        customerName: customer.name,
        method: method ?? PaymentMethod.cash,
        confidence: _confidence(
          amount: amountPaise != null,
          named: true,
          method: method != null,
        ),
      );
    }

    if (_hasAny(text, _expenseWords)) {
      final String? category = _firstMatch(text, _expenseWords);
      return ParsedCommand(
        intent: AssistantIntent.recordExpense,
        rawText: rawText,
        amountPaise: amountPaise,
        method: method ?? PaymentMethod.cash,
        category: category,
        confidence: _confidence(
          amount: amountPaise != null,
          named: false,
          method: method != null,
        ),
      );
    }

    if (_hasAny(text, _saleWords)) {
      final int? unitPrice = product == null
          ? null
          : products
              .firstWhere((ProductRef p) => p.id == product.id)
              .sellingPricePaise;
      if (amountPaise == null &&
          quantity != null &&
          unitPrice != null &&
          unitPrice > 0) {
        amountPaise = (unitPrice * quantity.value).round();
      }
      return ParsedCommand(
        intent: AssistantIntent.recordSale,
        rawText: rawText,
        amountPaise: amountPaise,
        productId: product?.id,
        productName: product?.name,
        quantity: quantity?.value,
        method: method ?? PaymentMethod.cash,
        confidence: _confidence(
          amount: amountPaise != null,
          named: product != null,
          method: method != null,
        ),
        notes: quantity != null && product != null
            ? <String>['Stock will be reduced by ${quantity.label}.']
            : const <String>[],
      );
    }

    if (_hasAny(text, _incomeWords)) {
      return ParsedCommand(
        intent: AssistantIntent.recordIncome,
        rawText: rawText,
        amountPaise: amountPaise,
        customerId: customer?.id,
        customerName: customer?.name,
        method: method ?? PaymentMethod.cash,
        confidence: _confidence(
          amount: amountPaise != null,
          named: customer != null,
          method: method != null,
        ),
      );
    }

    return ParsedCommand(
      intent: AssistantIntent.unknown,
      rawText: rawText,
      amountPaise: amountPaise,
      customerId: customer?.id,
      customerName: customer?.name,
      confidence: 0.2,
    );
  }

  static double _confidence({
    required bool amount,
    required bool named,
    required bool method,
  }) {
    double value = 0.55;
    if (amount) value += 0.22;
    if (named) value += 0.1;
    if (method) value += 0.08;
    return value > 0.97 ? 0.97 : value;
  }

  static String _normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[\u2018\u2019]'), "'")
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[।.!?]+$'), '')
        .trim();
  }

  static bool _hasAny(String text, List<String> words) =>
      words.any((String word) => _containsWord(text, word));

  static bool _containsWord(String text, String word) {
    // Unicode-aware boundaries so Devanagari words match as whole words.
    final String pattern =
        '(?<![\\p{L}\\p{N}])${RegExp.escape(word)}(?![\\p{L}\\p{N}])';
    return RegExp(pattern, unicode: true).hasMatch(text);
  }

  static String? _firstMatch(String text, List<String> words) {
    for (final String word in words) {
      if (_containsWord(text, word)) return word;
    }
    return null;
  }

  static PaymentMethod? _detectMethod(String text) {
    if (_containsWord(text, 'upi') ||
        _containsWord(text, 'gpay') ||
        _containsWord(text, 'phonepe') ||
        _containsWord(text, 'paytm') ||
        _containsWord(text, 'यूपीआई')) {
      return PaymentMethod.upi;
    }
    if (_containsWord(text, 'bank') ||
        _containsWord(text, 'neft') ||
        _containsWord(text, 'imps') ||
        _containsWord(text, 'बैंक')) {
      return PaymentMethod.bank;
    }
    if (_containsWord(text, 'cash') ||
        _containsWord(text, 'nakad') ||
        _containsWord(text, 'नकद')) {
      return PaymentMethod.cash;
    }
    if (_containsWord(text, 'sol') || _containsWord(text, 'solana')) {
      return PaymentMethod.solana;
    }
    return null;
  }

  static _NameMatch? _matchName(String text, List<(int, String)> names) {
    _NameMatch? best;
    for (final (int id, String name) in names) {
      final String needle = name.toLowerCase().trim();
      if (needle.isEmpty) continue;
      if (!_containsWord(text, needle)) continue;
      if (best == null || needle.length > best.name.length) {
        best = _NameMatch(id, name);
      }
    }
    return best;
  }

  static String? _addressFor(int id, List<PayeeRef> payees) {
    for (final PayeeRef payee in payees) {
      if (payee.id == id) return payee.walletAddress;
    }
    return null;
  }

  static String _withoutQuantity(String text) {
    return text.replaceAll(
      RegExp(
        r'\d+(?:\.\d+)?\s*(?:kg|kilo|kilos|gram|grams|gm|g|ltr|litre|liter|litres|liters|ml|pcs|pc|piece|pieces|packet|packets|pack|dozen|box|boxes|unit|units|bottle|bottles)\b',
      ),
      ' ',
    );
  }

  static _QuantityMatch? _extractQuantity(String text) {
    final RegExpMatch? match = RegExp(
      r'(\d+(?:\.\d+)?)\s*(kg|kilo|kilos|gram|grams|gm|g|ltr|litre|liter|litres|liters|ml|pcs|pc|piece|pieces|packet|packets|pack|dozen|box|boxes|unit|units|bottle|bottles)\b',
    ).firstMatch(text);
    if (match == null) return null;
    final double? value = double.tryParse(match.group(1)!);
    if (value == null || value <= 0) return null;
    return _QuantityMatch(value, '${match.group(1)} ${match.group(2)}');
  }
}

class _NameMatch {
  const _NameMatch(this.id, this.name);
  final int id;
  final String name;
}

class _QuantityMatch {
  const _QuantityMatch(this.value, this.label);
  final double value;
  final String label;
}

