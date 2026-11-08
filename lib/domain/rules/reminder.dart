import '../../core/money.dart';
import '../models.dart';

/// Builds a reminder the merchant can review and send themselves.
///
/// KhataCopilot never messages a customer automatically: there is no network
/// call here, only text placed on the clipboard or share sheet.
class ReminderBuilder {
  const ReminderBuilder(this.languageCode);

  final String languageCode;

  String build({
    required CustomerView customer,
    required String shopName,
  }) {
    final String amount = Money.format(customer.outstandingPaise);
    final bool hindi = languageCode.startsWith('hi') && !languageCode.contains('Latn');
    final bool hinglish = languageCode.contains('Latn');

    if (hindi) {
      return 'नमस्ते ${customer.name},\n\n'
          '$shopName के खाते में आपका $amount बाकी है। '
          'कृपया सुविधा अनुसार भुगतान कर दें।\n\nधन्यवाद।';
    }
    if (hinglish) {
      return 'Namaste ${customer.name},\n\n'
          '$shopName ke khate me aapka $amount baki hai. '
          'Kripya payment kar dein.\n\nDhanyavad.';
    }
    return 'Hello ${customer.name},\n\n'
        'Our records show $amount outstanding on your account at $shopName. '
        'Please settle it when convenient.\n\nThank you.';
  }
}
