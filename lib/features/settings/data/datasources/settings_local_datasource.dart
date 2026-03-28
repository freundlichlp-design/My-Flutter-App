import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsLocalDatasource {
  static const String _providerPref = 'selected_provider';
  static const String _modelPref = 'selected_model';
  static const String _personalityPref = 'selected_personality';

  static const String _openaiKeyKey = 'openai_api_key';
  static const String _claudeKeyKey = 'claude_api_key';
  static const String _geminiKeyKey = 'gemini_api_key';

  final FlutterSecureStorage _secureStorage;

  SettingsLocalDatasource({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<String> getOpenaiApiKey() async {
    return await _secureStorage.read(key: _openaiKeyKey) ?? '';
  }

  Future<String> getClaudeApiKey() async {
    return await _secureStorage.read(key: _claudeKeyKey) ?? '';
  }

  Future<String> getGeminiApiKey() async {
    return await _secureStorage.read(key: _geminiKeyKey) ?? '';
  }

  Future<void> saveOpenaiApiKey(String key) async {
    await _secureStorage.write(key: _openaiKeyKey, value: key);
  }

  Future<void> saveClaudeApiKey(String key) async {
    await _secureStorage.write(key: _claudeKeyKey, value: key);
  }

  Future<void> saveGeminiApiKey(String key) async {
    await _secureStorage.write(key: _geminiKeyKey, value: key);
  }

  Future<String> getSelectedProvider() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_providerPref) ?? 'openai';
  }

  Future<void> saveSelectedProvider(String provider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_providerPref, provider);
  }

  Future<String> getSelectedModel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_modelPref) ?? 'gpt-4o';
  }

  Future<void> saveSelectedModel(String model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modelPref, model);
  }

  Future<String> getSelectedPersonalityId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_personalityPref) ?? 'default';
  }

  Future<void> saveSelectedPersonalityId(String personalityId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_personalityPref, personalityId);
  }
}
