import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/ai_config.dart';

class CloudAiException implements Exception {
  CloudAiException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Minimal OpenAI-compatible chat client.
///
/// Any endpoint that accepts `POST /chat/completions` works: OpenAI, Groq,
/// Together, OpenRouter, a local Ollama (`/v1`) or a FastAPI gateway.
class CloudAiClient {
  CloudAiClient(this.config, {http.Client? httpClient})
      : _http = httpClient ?? http.Client();

  final AiConfig config;
  final http.Client _http;

  Future<Map<String, dynamic>> completeJson({
    required String system,
    required String user,
    Duration timeout = const Duration(seconds: 25),
  }) async {
    final Uri? uri = config.chatUri;
    if (uri == null) {
      throw CloudAiException(
          'The AI endpoint must be an HTTPS URL without extra parameters.');
    }
    // Cap the prompt so a runaway transcript can never be uploaded whole.
    final String safeUser =
        user.length > 4000 ? user.substring(0, 4000) : user;
    late final http.Response response;
    try {
      response = await _http
          .post(
            uri,
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${config.apiKey}',
            },
            body: jsonEncode(<String, dynamic>{
              'model': config.model,
              'temperature': 0.1,
              'max_tokens': 300,
              'messages': <Map<String, String>>[
                <String, String>{'role': 'system', 'content': system},
                <String, String>{'role': 'user', 'content': safeUser},
              ],
            }),
          )
          .timeout(timeout);
    } on Exception catch (error) {
      throw CloudAiException('Could not reach the AI service: $error');
    }

    if (response.statusCode >= 400) {
      throw CloudAiException(
        'AI service returned ${response.statusCode}'
        '${_serverMessage(response.body)} '
        '(${uri.host}${uri.path}, model ${config.model}).',
      );
    }

    final dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw CloudAiException('AI service returned an unreadable response.');
    }
    if (decoded is! Map<String, dynamic>) {
      throw CloudAiException('AI service returned an unexpected shape.');
    }
    final dynamic choices = decoded['choices'];
    if (choices is! List || choices.isEmpty) {
      throw CloudAiException('AI service returned no choices.');
    }
    final dynamic message = choices.first['message'];
    final dynamic content = message is Map ? message['content'] : null;
    if (content is! String || content.trim().isEmpty) {
      throw CloudAiException('AI service returned an empty answer.');
    }
    final Map<String, dynamic>? json = extractJsonObject(content);
    if (json == null) {
      throw CloudAiException(
        'AI service did not return valid JSON: ${_clip(content, 160)}',
      );
    }
    return json;
  }

  /// Pulls the human-readable `error.message` out of a failed response.
  static String _serverMessage(String body) {
    try {
      final dynamic decoded = jsonDecode(body);
      if (decoded is Map && decoded['error'] is Map) {
        final dynamic message = decoded['error']['message'];
        if (message is String && message.trim().isNotEmpty) {
          return ': ${_clip(message.trim(), 180)}';
        }
      }
    } catch (_) {
      // Not JSON; fall through to the raw body.
    }
    final String raw = body.trim();
    return raw.isEmpty ? '' : ': ${_clip(raw, 180)}';
  }

  static String _clip(String text, int max) =>
      text.length <= max ? text : '${text.substring(0, max)}...';

  /// Finds the first balanced JSON object in a model reply.
  static Map<String, dynamic>? extractJsonObject(String text) {
    final int start = text.indexOf('{');
    if (start < 0) return null;
    int depth = 0;
    bool inString = false;
    bool escaped = false;
    for (int i = start; i < text.length; i++) {
      final String ch = text[i];
      if (inString) {
        if (escaped) {
          escaped = false;
        } else if (ch == r'\') {
          escaped = true;
        } else if (ch == '"') {
          inString = false;
        }
        continue;
      }
      if (ch == '"') {
        inString = true;
      } else if (ch == '{') {
        depth++;
      } else if (ch == '}') {
        depth--;
        if (depth == 0) {
          try {
            final dynamic decoded = jsonDecode(text.substring(start, i + 1));
            return decoded is Map<String, dynamic> ? decoded : null;
          } catch (_) {
            return null;
          }
        }
      }
    }
    return null;
  }

  void dispose() => _http.close();
}
