import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/kali_personality.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _providerPref = 'selected_provider';
  static const String _modelPref = 'selected_model';
  static const String _personalityPref = 'selected_personality';

  static const String _openaiKeyKey = 'openai_api_key';
  static const String _claudeKeyKey = 'claude_api_key';
  static const String _geminiKeyKey = 'gemini_api_key';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  String _openaiApiKey = '';
  String _claudeApiKey = '';
  String _geminiApiKey = '';
  String _selectedProvider = 'openai';
  String _selectedModel = 'gpt-4o';
  String _selectedPersonalityId = 'default';

  String get selectedProvider => _selectedProvider;
  String get selectedModel => _selectedModel;
  String get selectedPersonalityId => _selectedPersonalityId;
  KaliPersonality get selectedPersonality =>
      KaliPersonality.getById(_selectedPersonalityId);

  String get currentApiKey {
    switch (_selectedProvider) {
      case 'claude':
        return _claudeApiKey;
      case 'gemini':
        return _geminiApiKey;
      default:
        return _openaiApiKey;
    }
  }

  static const Map<String, List<String>> providerModels = {
    'openai': ['gpt-4o', 'gpt-4o-mini', 'gpt-3.5-turbo'],
    'claude': ['claude-sonnet-4-20250514', 'claude-opus-4-20250514', 'claude-3-5-haiku-20241022'],
    'gemini': ['gemini-2.0-flash', 'gemini-1.5-pro'],
  };

  List<String> get availableModels =>
      providerModels[_selectedProvider] ?? ['gpt-4o'];

  bool get isConfigured => currentApiKey.isNotEmpty;

  /// Returns a masked version of the API key for display purposes.
  /// Never exposes the full key.
  String getMaskedKey(String provider) {
    final key = switch (provider) {
      'claude' => _claudeApiKey,
      'gemini' => _geminiApiKey,
      _ => _openaiApiKey,
    };
    if (key.isEmpty) return '';
    if (key.length <= 8) return '••••••••';
    return '${key.substring(0, 4)}••••${key.substring(key.length - 4)}';
  }

  /// Returns whether a key is configured for the given provider.
  bool hasKeyForProvider(String provider) {
    return switch (provider) {
      'claude' => _claudeApiKey.isNotEmpty,
      'gemini' => _geminiApiKey.isNotEmpty,
      _ => _openaiApiKey.isNotEmpty,
    };
  }

  Future<void> loadSettings({bool notify = true}) async {
    final prefs = await SharedPreferences.getInstance();
    _openaiApiKey = await _secureStorage.read(key: _openaiKeyKey) ?? '';
    _claudeApiKey = await _secureStorage.read(key: _claudeKeyKey) ?? '';
    _geminiApiKey = await _secureStorage.read(key: _geminiKeyKey) ?? '';
    _selectedProvider = prefs.getString(_providerPref) ?? 'openai';
    _selectedModel = prefs.getString(_modelPref) ?? 'gpt-4o';
    _selectedPersonalityId = prefs.getString(_personalityPref) ?? 'default';
    if (notify) notifyListeners();
  }

  Future<void> setOpenaiApiKey(String key) async {
    _openaiApiKey = key;
    await _secureStorage.write(key: _openaiKeyKey, value: key);
    notifyListeners();
  }

  Future<void> setClaudeApiKey(String key) async {
    _claudeApiKey = key;
    await _secureStorage.write(key: _claudeKeyKey, value: key);
    notifyListeners();
  }

  Future<void> setGeminiApiKey(String key) async {
    _geminiApiKey = key;
    await _secureStorage.write(key: _geminiKeyKey, value: key);
    notifyListeners();
  }

  Future<void> setSelectedProvider(String provider) async {
    _selectedProvider = provider;
    final models = providerModels[provider] ?? ['gpt-4o'];
    if (!models.contains(_selectedModel)) {
      _selectedModel = models.first;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_providerPref, provider);
    await prefs.setString(_modelPref, _selectedModel);
    notifyListeners();
  }

  Future<void> setSelectedModel(String model) async {
    _selectedModel = model;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modelPref, model);
    notifyListeners();
  }

  Future<void> setSelectedPersonality(String personalityId) async {
    _selectedPersonalityId = personalityId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_personalityPref, personalityId);
    notifyListeners();
  }
}
