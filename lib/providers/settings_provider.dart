import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _openaiKeyPref = 'openai_api_key';
  static const String _claudeKeyPref = 'claude_api_key';
  static const String _geminiKeyPref = 'gemini_api_key';
  static const String _providerPref = 'selected_provider';
  static const String _modelPref = 'selected_model';

  String _openaiApiKey = '';
  String _claudeApiKey = '';
  String _geminiApiKey = '';
  String _selectedProvider = 'openai';
  String _selectedModel = 'gpt-4o';

  String get openaiApiKey => _openaiApiKey;
  String get claudeApiKey => _claudeApiKey;
  String get geminiApiKey => _geminiApiKey;
  String get selectedProvider => _selectedProvider;
  String get selectedModel => _selectedModel;

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

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _openaiApiKey = prefs.getString(_openaiKeyPref) ?? '';
    _claudeApiKey = prefs.getString(_claudeKeyPref) ?? '';
    _geminiApiKey = prefs.getString(_geminiKeyPref) ?? '';
    _selectedProvider = prefs.getString(_providerPref) ?? 'openai';
    _selectedModel = prefs.getString(_modelPref) ?? 'gpt-4o';
    notifyListeners();
  }

  Future<void> setOpenaiApiKey(String key) async {
    _openaiApiKey = key;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_openaiKeyPref, key);
    notifyListeners();
  }

  Future<void> setClaudeApiKey(String key) async {
    _claudeApiKey = key;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claudeKeyPref, key);
    notifyListeners();
  }

  Future<void> setGeminiApiKey(String key) async {
    _geminiApiKey = key;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_geminiKeyPref, key);
    notifyListeners();
  }

  Future<void> setSelectedProvider(String provider) async {
    _selectedProvider = provider;
    final models = providerModels[provider] ?? ['gpt-4o'];
    _selectedModel = models.first;
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
}
