import 'package:flutter_test/flutter_test.dart';
import 'package:khatacopilot/domain/ai_config.dart';

void main() {
  test('rejects plain HTTP endpoints', () {
    const AiConfig config = AiConfig(
      endpoint: 'http://api.example.com/v1',
      model: 'm',
      apiKey: 'k',
    );
    expect(config.chatUri, isNull);
  });

  test('builds an HTTPS chat completions URL', () {
    const AiConfig config = AiConfig(
      endpoint: 'https://api.groq.com/openai/v1',
      model: 'llama',
      apiKey: 'k',
    );
    expect(
      config.chatUri.toString(),
      'https://api.groq.com/openai/v1/chat/completions',
    );
  });
}
