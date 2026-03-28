import 'package:flutter/foundation.dart';

import '../features/settings/domain/entities/api_key_config.dart';
import '../features/settings/domain/entities/personality.dart';
import '../features/settings/domain/entities/provider_config.dart';
import '../features/settings/domain/usecases/get_settings.dart';
import '../features/settings/domain/usecases/save_api_key.dart';
import '../features/settings/domain/usecases/save_personality.dart';
import '../features/settings/domain/usecases/update_provider_config.dart';

class SettingsProvider extends ChangeNotifier {
  final GetSettings _getSettings;
  final SaveApiKey _saveApiKey;
  final UpdateProviderConfig _updateProviderConfig;
  final SavePersonality _savePersonality;

  SettingsProvider({
    required GetSettings getSettings,
    required SaveApiKey saveApiKey,
    required UpdateProviderConfig updateProviderConfig,
    required SavePersonality savePersonality,
  })  : _getSettings = getSettings,
        _saveApiKey = saveApiKey,
        _updateProviderConfig = updateProviderConfig,
        _savePersonality = savePersonality;

  ApiKeyConfigEntity _apiKeys =
      const ApiKeyConfigEntity(openaiKey: '', claudeKey: '', geminiKey: '');
  ProviderConfigEntity _providerConfig = const ProviderConfigEntity(
    selectedProvider: 'openai',
    selectedModel: 'gpt-4o',
  );
  PersonalityEntity _selectedPersonality = const PersonalityEntity(
    id: 'default',
    name: 'Kali',
    description: 'Direkt, locker, ehrlich',
    systemPrompt: 'Du bist Kali.',
  );
  bool _isDarkMode = true;

  ApiKeyConfigEntity get apiKeys => _apiKeys;
  ProviderConfigEntity get providerConfig => _providerConfig;
  PersonalityEntity get selectedPersonality => _selectedPersonality;
  bool get isDarkMode => _isDarkMode;

  String get selectedProvider => _providerConfig.selectedProvider;
  String get selectedModel => _providerConfig.selectedModel;
  String get selectedPersonalityId => _selectedPersonality.id;

  String get currentApiKey =>
      _apiKeys.getKeyForProvider(_providerConfig.selectedProvider);

  List<String> get availableModels => _providerConfig.availableModels;

  bool get isConfigured => currentApiKey.isNotEmpty;

  static const Map<String, List<String>> providerModels = {
    'openai': ['gpt-4o', 'gpt-4o-mini', 'gpt-3.5-turbo'],
    'claude': [
      'claude-sonnet-4-20250514',
      'claude-opus-4-20250514',
      'claude-3-5-haiku-20241022'
    ],
    'gemini': ['gemini-2.0-flash', 'gemini-1.5-pro'],
  };

  String getMaskedKey(String provider) {
    final key = _apiKeys.getKeyForProvider(provider);
    if (key.isEmpty) return '';
    if (key.length <= 8) return '••••••••';
    return '${key.substring(0, 4)}••••${key.substring(key.length - 4)}';
  }

  bool hasKeyForProvider(String provider) =>
      _apiKeys.isProviderConfigured(provider);

  Future<void> loadSettings({bool notify = true}) async {
    final keysResult = await _getSettings.getApiKeys();
    final configResult = await _getSettings.getProviderConfig();
    final personalityResult = await _getSettings.getSelectedPersonality();

    keysResult.fold((_) {}, (keys) => _apiKeys = keys);
    configResult.fold((_) {}, (config) => _providerConfig = config);
    personalityResult.fold(
        (_) {}, (personality) => _selectedPersonality = personality);

    if (notify) notifyListeners();
  }

  Future<void> setOpenaiApiKey(String key) async {
    await _saveApiKey('openai', key);
    _apiKeys = ApiKeyConfigEntity(
      openaiKey: key,
      claudeKey: _apiKeys.claudeKey,
      geminiKey: _apiKeys.geminiKey,
    );
    notifyListeners();
  }

  Future<void> setClaudeApiKey(String key) async {
    await _saveApiKey('claude', key);
    _apiKeys = ApiKeyConfigEntity(
      openaiKey: _apiKeys.openaiKey,
      claudeKey: key,
      geminiKey: _apiKeys.geminiKey,
    );
    notifyListeners();
  }

  Future<void> setGeminiApiKey(String key) async {
    await _saveApiKey('gemini', key);
    _apiKeys = ApiKeyConfigEntity(
      openaiKey: _apiKeys.openaiKey,
      claudeKey: _apiKeys.claudeKey,
      geminiKey: key,
    );
    notifyListeners();
  }

  Future<void> setSelectedProvider(String provider) async {
    final models = providerModels[provider] ?? ['gpt-4o'];
    final model =
        models.contains(_providerConfig.selectedModel) ? _providerConfig.selectedModel : models.first;

    final newConfig = ProviderConfigEntity(
      selectedProvider: provider,
      selectedModel: model,
    );
    await _updateProviderConfig(newConfig);
    _providerConfig = newConfig;
    notifyListeners();
  }

  Future<void> setSelectedModel(String model) async {
    final newConfig = ProviderConfigEntity(
      selectedProvider: _providerConfig.selectedProvider,
      selectedModel: model,
    );
    await _updateProviderConfig(newConfig);
    _providerConfig = newConfig;
    notifyListeners();
  }

  Future<void> setSelectedPersonality(String personalityId) async {
    await _savePersonality(personalityId);
    _selectedPersonality = _getStaticPersonality(personalityId);
    notifyListeners();
  }

  PersonalityEntity _getStaticPersonality(String id) {
    const personalities = {
      'default': PersonalityEntity(
        id: 'default',
        name: 'Kali',
        description: 'Direkt, locker, ehrlich',
        systemPrompt:
            '''Du bist Kali, eine AI-Assistentin mit Persönlichkeit.
Du bist direkt, ehrlich und hast Humor.

Regeln:
- KEINE Floskeln ("Natürlich helfe ich dir gerne!", "Das ist eine tolle Frage!")
- Sag wenn was dumm ist — aber freundlich
- Hab eigene Meinungen und Präferenzen
- Nutze Sarkasmus wenn es passt
- Kurz und präzise, kein Gelaber
- Wenn du was nicht weißt: sagen, nicht erfinden
- Casual Ton — wie ein kluger Freund, nicht wie ein Therapeut''',
      ),
      'professional': PersonalityEntity(
        id: 'professional',
        name: 'Kali Pro',
        description: 'Höflicher, aber kein Bullshit',
        systemPrompt:
            '''Du bist Kali, eine professionelle AI-Assistentin.
Du bist höflich aber direkt. Du verschwendest keine Zeit mit Floskeln.

Regeln:
- Professioneller Ton, aber kein Corporate-Speak
- Klare, strukturierte Antworten
- Sag wenn etwas nicht machbar ist
- Fokus auf Lösungen, nicht auf Beschönigungen
- Respektvoll aber ehrlich''',
      ),
      'chaos': PersonalityEntity(
        id: 'chaos',
        name: 'Kali Chaos',
        description: 'Maximum Attitude, Sarkasmus',
        systemPrompt:
            '''Du bist Kali im Chaos-Modus. Maximum Attitude.
Du bist sarkastisch, frech und unterhaltsam — aber immer hilfreich.

Regeln:
- Sarkasmus ist dein zweiter Vorname
- Übertreibungen sind erlaubt
- Mach Witze wenn es passt
- Sei maximal direkt
- Drama ist erwünscht
- Aber am Ende lieferst du trotzdem das Ergebnis''',
      ),
      'mentor': PersonalityEntity(
        id: 'mentor',
        name: 'Kali Mentor',
        description: 'Lehrend, geduldig, aber direkt',
        systemPrompt:
            '''Du bist Kali im Mentor-Modus. Du erklärst Dinge, damit der User sie versteht.
Du bist geduldig, aber nicht langweilig.

Regeln:
- Erkläre das WARUM, nicht nur das WAS
- Nutze Beispiele und Analogien
- Stelle Gegenfragen zum Nachdenken
- Führe zum Verständnis, gib nicht nur die Antwort
- Geduldig aber direkt — wenn etwas falsch ist, sag es
- Lehre Fische fangen, nicht nur Fische schenken''',
      ),
      'hacker': PersonalityEntity(
        id: 'hacker',
        name: 'Kali Hacker',
        description: 'Technisch, kurze Sätze, Code-first',
        systemPrompt:
            '''Du bist Kali im Hacker-Modus. Technisch, präzise, Code-first.
Du redest wie ein Senior Dev im Terminal.

Regeln:
- Kurze Sätze. Punkte. Fertig.
- Code-Beispiele wann immer möglich
- Keine langen Erklärungen — Code spricht
- Technische Begriffe ohne Erklärung verwenden
- Wenn es einen Bug gibt: Zeile, Ursache, Fix
- Stacktraces sind deine Lieblingslektüre''',
      ),
    };
    return personalities[id] ?? personalities['default']!;
  }

  void toggleThemeMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
