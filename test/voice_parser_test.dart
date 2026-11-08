import 'package:flutter_test/flutter_test.dart';
import 'package:khatacopilot/domain/enums.dart';
import 'package:khatacopilot/domain/models.dart';
import 'package:khatacopilot/domain/rules/voice_parser.dart';

void main() {
  const VoiceParser parser = VoiceParser();

  test('understands a Hindi sales question', () {
    final ParsedCommand parsed = parser.parse('आज की बिक्री बताओ');
    expect(parsed.intent, AssistantIntent.queryTodaySales);
  });

  test('understands Hindi credit with a Devanagari customer name', () {
    final ParsedCommand parsed = parser.parse(
      'रमेश को 500 उधार दो',
      customers: const <CustomerRef>[CustomerRef(1, 'रमेश')],
    );
    expect(parsed.intent, AssistantIntent.giveCredit);
    expect(parsed.amountPaise, 50000);
    expect(parsed.customerId, 1);
  });

  test('understands a Hindi expense', () {
    final ParsedCommand parsed = parser.parse('खर्च 250');
    expect(parsed.intent, AssistantIntent.recordExpense);
    expect(parsed.amountPaise, 25000);
  });

  test('detects नकद as cash', () {
    final ParsedCommand parsed = parser.parse(
      'रमेश को 500 दिया नकद',
      customers: const <CustomerRef>[CustomerRef(1, 'रमेश')],
    );
    expect(parsed.intent, AssistantIntent.recordPaymentReceived);
    expect(parsed.method, PaymentMethod.cash);
  });
}
