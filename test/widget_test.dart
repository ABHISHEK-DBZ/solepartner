import 'package:flutter_test/flutter_test.dart';
import 'package:khatacopilot/core/money.dart';

void main() {
  test('formats integer paise as INR', () {
    expect(Money.format(50000), '₹500');
    expect(Money.format(125050), '₹1,250.50');
  });

  test('parses shorthand amounts from text', () {
    expect(Money.tryParsePaise('Rahul paid ₹500'), 50000);
    expect(Money.tryParsePaise('2k'), 200000);
    expect(Money.tryParsePaise('no amount here'), isNull);
  });

  test('formats lamports as SOL', () {
    expect(Money.formatSol(Money.lamportsPerSol), '1');
  });
}
