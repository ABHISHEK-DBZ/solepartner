import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:khatacopilot/domain/ai_config.dart';
import 'package:khatacopilot/services/cloud_ai_client.dart';

const AiConfig _config = AiConfig(
  endpoint: 'https://api.groq.com/openai/v1',
  model: 'openai/gpt-oss-120b',
  apiKey: 'k',
);

void main() {
  test('surfaces the status and server error message', () async {
    final CloudAiClient client = CloudAiClient(
      _config,
      httpClient: MockClient((http.Request request) async => http.Response(
            '{"error":{"message":"Invalid API Key"}}',
            401,
          )),
    );
    await expectLater(
      client.completeJson(system: 's', user: 'u'),
      throwsA(
        isA<CloudAiException>().having(
          (CloudAiException e) => e.message,
          'message',
          allOf(contains('401'), contains('Invalid API Key'),
              contains('openai/gpt-oss-120b')),
        ),
      ),
    );
  });

  test('shows the raw reply when it is not JSON', () async {
    final CloudAiClient client = CloudAiClient(
      _config,
      httpClient: MockClient((http.Request request) async => http.Response(
            '{"choices":[{"message":{"content":"I cannot help"}}]}',
            200,
          )),
    );
    await expectLater(
      client.completeJson(system: 's', user: 'u'),
      throwsA(
        isA<CloudAiException>().having(
          (CloudAiException e) => e.message,
          'message',
          contains('I cannot help'),
        ),
      ),
    );
  });
}
