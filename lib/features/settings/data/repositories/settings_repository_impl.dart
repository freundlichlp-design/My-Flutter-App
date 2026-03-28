import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/api_key_config.dart';
import '../../domain/entities/personality.dart';
import '../../domain/entities/provider_config.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDatasource _localDatasource;

  SettingsRepositoryImpl({required SettingsLocalDatasource localDatasource})
      : _localDatasource = localDatasource;

  @override
  Future<Either<Failure, ApiKeyConfigEntity>> getApiKeys() async {
    try {
      final openaiKey = await _localDatasource.getOpenaiApiKey();
      final claudeKey = await _localDatasource.getClaudeApiKey();
      final geminiKey = await _localDatasource.getGeminiApiKey();
      return Right(ApiKeyConfigEntity(
        openaiKey: openaiKey,
        claudeKey: claudeKey,
        geminiKey: geminiKey,
      ));
    } catch (e) {
      return Left(CacheFailure('Failed to load API keys: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveApiKey(
      String provider, String key) async {
    try {
      switch (provider) {
        case 'claude':
          await _localDatasource.saveClaudeApiKey(key);
        case 'gemini':
          await _localDatasource.saveGeminiApiKey(key);
        default:
          await _localDatasource.saveOpenaiApiKey(key);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save API key: $e'));
    }
  }

  @override
  Future<Either<Failure, ProviderConfigEntity>> getProviderConfig() async {
    try {
      final provider = await _localDatasource.getSelectedProvider();
      final model = await _localDatasource.getSelectedModel();
      return Right(ProviderConfigEntity(
        selectedProvider: provider,
        selectedModel: model,
      ));
    } catch (e) {
      return Left(CacheFailure('Failed to load provider config: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveProviderConfig(
      ProviderConfigEntity config) async {
    try {
      await _localDatasource.saveSelectedProvider(config.selectedProvider);
      await _localDatasource.saveSelectedModel(config.selectedModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save provider config: $e'));
    }
  }

  @override
  Future<Either<Failure, PersonalityEntity>> getSelectedPersonality() async {
    try {
      final personalityId =
          await _localDatasource.getSelectedPersonalityId();
      final staticPersonality = _getStaticPersonality(personalityId);
      return Right(staticPersonality);
    } catch (e) {
      return Left(CacheFailure('Failed to load personality: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveSelectedPersonality(
      String personalityId) async {
    try {
      await _localDatasource.saveSelectedPersonalityId(personalityId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save personality: $e'));
    }
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
}
