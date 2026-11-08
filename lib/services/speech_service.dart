import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechException implements Exception {
  SpeechException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Wraps Android speech recognition and TTS.
///
/// Recognition is optional: every voice screen also accepts typed text, so a
/// device without a speech service can still use the whole app.
class SpeechService {
  SpeechService();

  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _available = false;
  bool _checked = false;

  static String localeFor(String languageCode) {
    if (languageCode.startsWith('hi') && !languageCode.contains('Latn')) {
      return 'hi_IN';
    }
    return 'en_IN';
  }

  Future<bool> isAvailable() async {
    if (_checked) return _available;
    try {
      _available = await _speech.initialize();
    } catch (_) {
      _available = false;
    }
    _checked = true;
    return _available;
  }

  bool get isListening => _speech.isListening;

  /// Listens for a single utterance and returns the final transcript.
  Future<String> listenOnce({String languageCode = 'en'}) async {
    if (!await isAvailable()) {
      throw SpeechException(
        'Speech recognition is not available on this device. Type instead.',
      );
    }
    final Completer<String> completer = Completer<String>();
    await _speech.listen(
      onResult: (SpeechRecognitionResult result) {
        if (result.finalResult) {
          if (!completer.isCompleted) {
            completer.complete(result.recognizedWords);
          }
        }
      },
      listenOptions: SpeechListenOptions(
        localeId: localeFor(languageCode),
        listenFor: const Duration(seconds: 25),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.dictation,
      ),
    );
    try {
      return await completer.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () => '',
      );
    } finally {
      await _speech.stop();
    }
  }

  Future<void> stop() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  Future<void> speak(String text, {String languageCode = 'en'}) async {
    if (text.trim().isEmpty) return;
    try {
      await _tts.setLanguage(localeFor(languageCode).replaceAll('_', '-'));
      await _tts.setSpeechRate(0.48);
      await _tts.speak(text);
    } catch (_) {
      // Speech output is a convenience; never fail a transaction over it.
    }
  }

  Future<void> stopSpeaking() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
