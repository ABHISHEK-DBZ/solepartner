/// User-supplied cloud LLM configuration.
///
/// The API key is stored in the platform secure storage, never in the database
/// and never in the repository.
class AiConfig {
  const AiConfig({
    required this.endpoint,
    required this.model,
    required this.apiKey,
  });

  /// Build-time defaults, e.g.
  /// `flutter build apk --dart-define=AI_API_KEY=gsk_...`.
  static const String defaultEndpoint = String.fromEnvironment(
    'AI_ENDPOINT',
    defaultValue: 'https://api.groq.com/openai/v1',
  );
  // Groq retired the Llama 3.3 models; gpt-oss-120b is the free replacement.
  static const String defaultModel = String.fromEnvironment(
    'AI_MODEL',
    defaultValue: 'openai/gpt-oss-120b',
  );
  static const String defaultApiKey = String.fromEnvironment('AI_API_KEY');

  final String endpoint;
  final String model;
  final String apiKey;

  bool get isConfigured =>
      endpoint.trim().isNotEmpty &&
      model.trim().isNotEmpty &&
      apiKey.trim().isNotEmpty;

  Uri? get chatUri {
    final Uri? base = Uri.tryParse(endpoint.trim());
    // Plain HTTP would expose the merchant's ledger summary and API key.
    if (base == null || base.scheme != 'https' || !base.hasAuthority) {
      return null;
    }
    if (base.path.endsWith('/chat/completions')) return base;
    final String path = base.path.endsWith('/')
        ? '${base.path}chat/completions'
        : '${base.path}/chat/completions';
    return base.replace(path: path);
  }

  AiConfig copyWith({String? endpoint, String? model, String? apiKey}) {
    return AiConfig(
      endpoint: endpoint ?? this.endpoint,
      model: model ?? this.model,
      apiKey: apiKey ?? this.apiKey,
    );
  }
}
