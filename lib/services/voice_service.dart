import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

enum VoiceState { idle, listening, speaking, error }

class VoiceService {
  static final VoiceService _instance = VoiceService._internal();

  factory VoiceService() => _instance;

  VoiceService._internal();

  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  VoiceState _state = VoiceState.idle;
  String _lastRecognizedText = '';
  bool _isInitialized = false;

  final _stateController = StreamController<VoiceState>.broadcast();
  final _textController = StreamController<String>.broadcast();

  Stream<VoiceState> get stateStream => _stateController.stream;
  Stream<String> get textStream => _textController.stream;

  VoiceState get state => _state;
  String get lastRecognizedText => _lastRecognizedText;
  bool get isListening => _state == VoiceState.listening;
  bool get isInitialized => _isInitialized;

  void _updateState(VoiceState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  Future<bool> init() async {
    if (_isInitialized) return true;

    try {
      _isInitialized = await _speech.initialize(
        onError: (error) {
          _updateState(VoiceState.error);
        },
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            _updateState(VoiceState.idle);
          }
        },
      );

      await _tts.setLanguage('de-DE');
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);

      _tts.setCompletionHandler(() {
        _updateState(VoiceState.idle);
      });

      return _isInitialized;
    } catch (e) {
      _updateState(VoiceState.error);
      return false;
    }
  }

  Future<void> startListening({String localeId = 'de_DE'}) async {
    if (!_isInitialized) {
      final ok = await init();
      if (!ok) return;
    }

    if (_speech.isListening) return;

    _updateState(VoiceState.listening);
    _lastRecognizedText = '';

    await _speech.listen(
      onResult: (result) {
        _lastRecognizedText = result.recognizedWords;
        _textController.add(_lastRecognizedText);
        if (result.finalResult) {
          _updateState(VoiceState.idle);
        }
      },
      localeId: localeId,
      listenMode: stt.ListenMode.confirmation,
      cancelOnError: true,
      partialResults: true,
    );
  }

  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
      _updateState(VoiceState.idle);
    }
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      final ok = await init();
      if (!ok) return;
    }

    _updateState(VoiceState.speaking);
    await _tts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _tts.stop();
    _updateState(VoiceState.idle);
  }

  Future<void> setLanguage(String languageCode) async {
    await _tts.setLanguage(languageCode);
  }

  void dispose() {
    _speech.cancel();
    _tts.stop();
    _stateController.close();
    _textController.close();
  }
}
