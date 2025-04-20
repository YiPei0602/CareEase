import 'package:speech_to_text/speech_to_text.dart';

class SttService {
  static final SpeechToText _speech = SpeechToText();
  static String _latestWords = '';

  /// Begin listening (call onLongPressStart).
  static Future<void> start() async {
    if (_speech.isListening) await _speech.stop();

    final ready = await _speech.initialize(
      onStatus: (s) => print('🎤 STT status: $s'),
      onError : (e) => print('❌ STT error: $e'),
    );
    print('🎤 STT ready: $ready');
    if (!ready) return;

    _latestWords = '';

    await _speech.listen(
      listenMode   : ListenMode.dictation,
      localeId     : 'en_US',
      listenFor    : const Duration(seconds: 15), // max session
      pauseFor     : const Duration(seconds: 2),  // stop after 2 s silence
      partialResults: true,
      onResult: (r) {
        _latestWords = r.recognizedWords;
        print('📝 STT update: $_latestWords');
      },
    );
  }

  /// Stop listening and return the final transcript (call onLongPressEnd).
  static Future<String> stop() async {
    if (_speech.isListening) await _speech.stop();
    return _latestWords.trim();
  }
}
