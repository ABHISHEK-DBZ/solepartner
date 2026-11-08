import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/ai_config.dart';
import '../db/app_database.dart';

class SettingsRepository {
  SettingsRepository(this._db, this._secureStorage);

  final AppDatabase _db;
  final FlutterSecureStorage _secureStorage;

  static const String aiEndpointKey = 'ai.endpoint';
  static const String aiModelKey = 'ai.model';
  static const String aiKeyStorageKey = 'khatacopilot.ai.api_key';
  static const String voiceResponsesKey = 'voice.responses_enabled';
  static const String cloudConsentKey = 'ai.cloud_consent';

  Future<String?> read(String key) async {
    final AppSetting? row = await (_db.select(_db.appSettings)
          ..where((s) => s.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Stream<String?> watch(String key) {
    return (_db.select(_db.appSettings)
          ..where((s) => s.key.equals(key)))
        .watchSingleOrNull()
        .map((AppSetting? row) => row?.value);
  }

  Future<void> write(String key, String value) async {
    await _db.into(_db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: key, value: value),
        );
  }

  Future<void> remove(String key) async {
    await (_db.delete(_db.appSettings)
          ..where((s) => s.key.equals(key)))
        .go();
  }

  Future<AiConfig?> loadAiConfig() async {
    final String endpoint = await read(aiEndpointKey) ?? '';
    final String model = await read(aiModelKey) ?? '';
    final String? apiKey = await _secureStorage.read(key: aiKeyStorageKey);
    if (endpoint.isEmpty || model.isEmpty || apiKey == null || apiKey.isEmpty) {
      // Fall back to values injected at build time (e.g. a Groq key).
      if (AiConfig.defaultApiKey.isEmpty) return null;
      return AiConfig(
        endpoint: AiConfig.defaultEndpoint,
        model: AiConfig.defaultModel,
        apiKey: AiConfig.defaultApiKey,
      );
    }
    return AiConfig(endpoint: endpoint, model: model, apiKey: apiKey);
  }

  Future<void> saveAiConfig({
    required String endpoint,
    required String model,
    required String apiKey,
  }) async {
    await write(aiEndpointKey, endpoint.trim());
    await write(aiModelKey, model.trim());
    if (apiKey.trim().isEmpty) {
      await _secureStorage.delete(key: aiKeyStorageKey);
    } else {
      await _secureStorage.write(key: aiKeyStorageKey, value: apiKey.trim());
    }
  }

  Future<void> clearAiConfig() async {
    await remove(aiEndpointKey);
    await remove(aiModelKey);
    await _secureStorage.delete(key: aiKeyStorageKey);
  }

  Future<bool> voiceResponsesEnabled() async {
    return (await read(voiceResponsesKey)) != 'false';
  }

  Future<void> setVoiceResponsesEnabled(bool enabled) {
    return write(voiceResponsesKey, enabled ? 'true' : 'false');
  }

  /// Cloud AI is opt-in: the merchant must agree before any text leaves the
  /// device. Without a stored choice, a key baked in at build time counts as
  /// the operator's opt-in; otherwise it stays off.
  Future<bool> cloudConsentEnabled() async {
    final String? stored = await read(cloudConsentKey);
    if (stored != null) return stored == 'true';
    return AiConfig.defaultApiKey.isNotEmpty;
  }

  Future<void> setCloudConsentEnabled(bool enabled) {
    return write(cloudConsentKey, enabled ? 'true' : 'false');
  }
}
