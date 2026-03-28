import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDatasource {
  Future<String> getOpenaiApiKey();
  Future<String> getClaudeApiKey();
  Future<String> getGeminiApiKey();
  Future<void> saveOpenaiApiKey(String key);
  Future<void> saveClaudeApiKey(String key);
  Future<void> saveGeminiApiKey(String key);
  Future<String> getSelectedProvider();
  Future<void> saveSelectedProvider(String provider);
  Future<String> getSelectedModel();
  Future<void> saveSelectedModel(String model);
  Future<String> getSelectedPersonalityId();
  Future<void> saveSelectedPersonalityId(String personalityId);
}

class SettingsLocalDatasourceImpl implements SettingsLocalDatasource {
  static const String _providerPref = 'selected_provider';
  static const String _modelPref = 'selected_model';
  static const String _personalityPref = 'selected_personality';

  static const String _openaiKeyKey = 'openai_api_key';
  static const String _claudeKeyKey = 'claude_api_key';
  static const String _geminiKeyKey = 'gemini_api_key';

  final FlutterSecureStorage _secureStorage;

  SettingsLocalDatasourceImpl({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  @override
  Future<String> getOpenaiApiKey() async {
    return await _secureStorage.read(key: _openaiKeyKey) ?? '';
  }

  @override
  Future<String> getClaudeApiKey() async {
    return await _secureStorage.read(key: _claudeKeyKey) ?? '';
  }

  @override
  Future<String> getGeminiApiKey() async {
    return await _secureStorage.read(key: _geminiKeyKey) ?? '';
  }

  @override
  Future<void> saveOpenaiApiKey(String key) async {
    await _secureStorage.write(key: _openaiKeyKey, value: key);
  }

  @override
  Future<void> saveClaudeApiKey(String key) async {
    await _secureStorage.write(key: _claudeKeyKey, value: key);
  }

  @override
  Future<void> saveGeminiApiKey(String key) async {
    await _secureStorage.write(key: _geminiKeyKey, value: key);
  }

  @override
  Future<String> getSelectedProvider() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_providerPref) ?? 'openai';
  }

  @override
  Future<void> saveSelectedProvider(String provider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_providerPref, provider);
  }

  @override
  Future<String> getSelectedModel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_modelPref) ?? 'gpt-4o';
  }

  @override
  Future<void> saveSelectedModel(String model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modelPref, model);
  }

  @override
  Future<String> getSelectedPersonalityId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_personalityPref) ?? 'default';
  }

  @override
  Future<void> saveSelectedPersonalityId(String personalityId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_personalityPref, personalityId);
  }
}
