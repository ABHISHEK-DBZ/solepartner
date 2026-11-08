import '../../core/money.dart';

/// Offline, deterministic reply text in the merchant's chosen language.
///
/// This is intentionally small: the assistant never translates financial
/// numbers, it only formats them.
class Phrases {
  const Phrases(this.languageCode);

  final String languageCode;

  bool get isHindi =>
      languageCode.startsWith('hi') && !languageCode.contains('Latn');
  bool get isHinglish => languageCode.contains('Latn');

  String get greeting {
    if (isHindi) {
      return 'नमस्ते! मैं आपका खाता सहायक हूँ। बोलिए या लिखिए — जैसे '
          '"राहुल ने ₹500 नकद दिए"।';
    }
    if (isHinglish) {
      return 'Namaste! Main aapka khata assistant hoon. Bolo ya likho — '
          'jaise "Rahul ne 500 cash diye".';
    }
    return 'Namaste! I am your khata assistant. Speak or type a command, '
        'for example "Rahul paid ₹500 cash".';
  }

  String get notUnderstood {
    if (isHindi) {
      return 'मैं यह कमांड समझ नहीं पाया। कृपया राशि के साथ बोलिए, '
          'जैसे "सुरेश को ₹200 उधार दो"।';
    }
    if (isHinglish) {
      return 'Ye command samajh nahi aaya. Amount ke saath bolo, '
          'jaise "Suresh ko 200 udhaar do".';
    }
    return 'I could not understand that. Try including an amount, '
        'for example "Give Suresh ₹200 credit".';
  }

  String get cloudUnavailable {
    if (isHindi) {
      return 'ऑफ़लाइन समझ नहीं आया और क्लाउड AI उपलब्ध नहीं है।';
    }
    if (isHinglish) {
      return 'Offline samajh nahi aaya aur cloud AI available nahi hai.';
    }
    return 'That needs the cloud assistant, which is not available right now.';
  }

  String todaySales(int salesPaise, int expensesPaise, int netCashPaise) {
    final String s = Money.format(salesPaise);
    final String e = Money.format(expensesPaise);
    final String n = Money.format(netCashPaise);
    if (isHindi) {
      return 'आज की बिक्री $s, खर्च $e और नकद शुद्ध $n है।';
    }
    if (isHinglish) {
      return 'Aaj ki sales $s, kharch $e aur net cash $n hai.';
    }
    return "Today's sales are $s, expenses $e, and net cash movement $n.";
  }

  String outstanding(int totalPaise, int customerCount, String topNames) {
    final String total = Money.format(totalPaise);
    if (totalPaise <= 0) {
      if (isHindi) return 'कोई उधार बाकी नहीं है।';
      if (isHinglish) return 'Koi udhaar baki nahi hai.';
      return 'No customer credit is outstanding.';
    }
    if (isHindi) {
      return '$customerCount ग्राहकों से $total बाकी है।'
          '${topNames.isEmpty ? '' : ' सबसे ज़्यादा: $topNames।'}';
    }
    if (isHinglish) {
      return '$customerCount customers se $total baki hai.'
          '${topNames.isEmpty ? '' : ' Sabse zyada: $topNames.'}';
    }
    return '$total is outstanding across $customerCount customers.'
        '${topNames.isEmpty ? '' : ' Largest: $topNames.'}';
  }

  String lowStock(int count, String names) {
    if (count == 0) {
      if (isHindi) return 'सभी स्टॉक स्तर ठीक हैं।';
      if (isHinglish) return 'Sab stock levels theek hain.';
      return 'All stock levels are healthy.';
    }
    if (isHindi) {
      return '$count उत्पाद कम स्टॉक में हैं${names.isEmpty ? '' : ': $names'}।';
    }
    if (isHinglish) {
      return '$count products low stock me hain${names.isEmpty ? '' : ': $names'}.';
    }
    return '$count products are low on stock${names.isEmpty ? '' : ': $names'}.';
  }

  String stockLevel(String product, double qty, String unit, int valuePaise) {
    final String qtyText = qty == qty.roundToDouble()
        ? qty.toInt().toString()
        : qty.toString();
    if (isHindi) {
      return '$product का स्टॉक $qtyText $unit है (मूल्य ${Money.format(valuePaise)})।';
    }
    if (isHinglish) {
      return '$product ka stock $qtyText $unit hai (value ${Money.format(valuePaise)}).';
    }
    return '$product has $qtyText $unit in stock, worth ${Money.format(valuePaise)}.';
  }

  String totalStock(int productCount, int valuePaise, int lowStock) {
    if (isHindi) {
      return '$productCount उत्पाद, कुल स्टॉक मूल्य ${Money.format(valuePaise)}, '
          '$lowStock कम स्टॉक में।';
    }
    if (isHinglish) {
      return '$productCount products, total stock value ${Money.format(valuePaise)}, '
          '$lowStock low stock me.';
    }
    return '$productCount products with ${Money.format(valuePaise)} of stock. '
        '$lowStock are low on stock.';
  }

  String topProducts(String list) {
    if (isHindi) return 'सबसे ज़्यादा बिकने वाले: $list।';
    if (isHinglish) return 'Sabse zyada bikne wale: $list.';
    return 'Best sellers: $list.';
  }

  String affordability(int amountPaise, int cashPaise) {
    final String amount = Money.format(amountPaise);
    final String cash = Money.format(cashPaise);
    final bool can = amountPaise <= cashPaise;
    if (isHindi) {
      return can
          ? 'हाँ, $amount दे सकते हैं। अनुमानित नकद $cash है।'
          : 'नहीं, $amount के लिए अनुमानित नकद $cash कम है।';
    }
    if (isHinglish) {
      return can
          ? 'Haan, $amount de sakte hain. Anumanit cash $cash hai.'
          : 'Nahi, $amount ke liye anumanit cash $cash kam hai.';
    }
    return can
        ? 'Yes, $amount is affordable. Estimated cash on hand is $cash.'
        : 'That would exceed the estimated cash on hand of $cash.';
  }

  String confirmation({
    required String actionLabel,
    required String amount,
    String? customerName,
  }) {
    final String who = customerName == null ? '' : ' for $customerName';
    final String what = actionLabel.toLowerCase();
    if (isHindi) {
      return '$what$who — $amount। सहेजने से पहले पुष्टि करें।';
    }
    if (isHinglish) {
      return '$what$who — $amount. Save karne se pehle confirm karein.';
    }
    return '$what$who — $amount. Confirm before saving.';
  }

  String paymentPrepared(String amountSol, String recipient) {
    if (isHindi) {
      return '$recipient को $amountSol SOL का भुगतान तैयार है। '
          'नीति जाँच और आपकी मंज़ूरी ज़रूरी है।';
    }
    if (isHinglish) {
      return '$recipient ko $amountSol SOL ka payment taiyar hai. '
          'Policy check aur aapki approval zaroori hai.';
    }
    return 'A payment of $amountSol SOL to $recipient is ready. '
        'Policy checks and your approval are required.';
  }
}
