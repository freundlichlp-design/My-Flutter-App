import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_app/core/errors/failures.dart';
import 'package:my_flutter_app/features/settings/domain/entities/api_key_config.dart';
import 'package:my_flutter_app/features/settings/domain/entities/personality.dart';
import 'package:my_flutter_app/features/settings/domain/entities/provider_config.dart';
import 'package:my_flutter_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:my_flutter_app/features/settings/domain/usecases/settings_get_api_key.dart';

class MockSettingsRepository implements SettingsRepository {
  Either<Failure, ApiKeyConfigEntity> getApiKeysResult = const Right(
    ApiKeyConfigEntity(openaiKey: '', claudeKey: '', geminiKey: ''),
  );
  Either<Failure, void> saveApiKeyResult = const Right(null);
  Either<Failure, ProviderConfigEntity> getProviderConfigResult = const Right(
    ProviderConfigEntity(selectedProvider: 'openai', selectedModel: 'gpt-4o'),
  );
  Either<Failure, void> saveProviderConfigResult = const Right(null);
  Either<Failure, PersonalityEntity> getSelectedPersonalityResult = const Right(
    PersonalityEntity(
        id: 'default',
        name: 'Kali',
        description: 'Default',
        systemPrompt: 'Test'),
  );
  Either<Failure, void> saveSelectedPersonalityResult = const Right(null);

  String? savedProvider;
  String? savedKey;

  @override
  Future<Either<Failure, ApiKeyConfigEntity>> getApiKeys() async {
    return getApiKeysResult;
  }

  @override
  Future<Either<Failure, void>> saveApiKey(String provider, String key) async {
    savedProvider = provider;
    savedKey = key;
    return saveApiKeyResult;
  }

  @override
  Future<Either<Failure, ProviderConfigEntity>> getProviderConfig() async {
    return getProviderConfigResult;
  }

  @override
  Future<Either<Failure, void>> saveProviderConfig(
      ProviderConfigEntity config) async {
    return saveProviderConfigResult;
  }

  @override
  Future<Either<Failure, PersonalityEntity>> getSelectedPersonality() async {
    return getSelectedPersonalityResult;
  }

  @override
  Future<Either<Failure, void>> saveSelectedPersonality(
      String personalityId) async {
    return saveSelectedPersonalityResult;
  }
}

void main() {
  late SettingsGetApiKey usecase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    usecase = SettingsGetApiKey(mockRepository);
  });

  group('SettingsGetApiKey', () {
    test('should return ValidationFailure when provider is empty', () async {
      final result = await usecase(provider: '');

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, 'Provider cannot be empty');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return ValidationFailure when provider is only whitespace',
        () async {
      final result = await usecase(provider: '   ');

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, 'Provider cannot be empty');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return ValidationFailure for unsupported provider', () async {
      final result = await usecase(provider: 'invalid_provider');

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('Unsupported provider'));
          expect(failure.message, contains('invalid_provider'));
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return AuthFailure when API key is not configured', () async {
      mockRepository.getApiKeysResult = const Right(
        ApiKeyConfigEntity(openaiKey: '', claudeKey: '', geminiKey: ''),
      );

      final result = await usecase(provider: 'openai');

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, contains('No API key configured'));
          expect(failure.message, contains('openai'));
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return openai key for openai provider', () async {
      mockRepository.getApiKeysResult = const Right(
        ApiKeyConfigEntity(
            openaiKey: 'sk-openai-123', claudeKey: '', geminiKey: ''),
      );

      final result = await usecase(provider: 'openai');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return key'),
        (key) => expect(key, 'sk-openai-123'),
      );
    });

    test('should return claude key for claude provider', () async {
      mockRepository.getApiKeysResult = const Right(
        ApiKeyConfigEntity(
            openaiKey: '', claudeKey: 'sk-claude-456', geminiKey: ''),
      );

      final result = await usecase(provider: 'claude');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return key'),
        (key) => expect(key, 'sk-claude-456'),
      );
    });

    test('should return gemini key for gemini provider', () async {
      mockRepository.getApiKeysResult = const Right(
        ApiKeyConfigEntity(
            openaiKey: '', claudeKey: '', geminiKey: 'gem-789'),
      );

      final result = await usecase(provider: 'gemini');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return key'),
        (key) => expect(key, 'gem-789'),
      );
    });

    test('should return CacheFailure when repository fails', () async {
      mockRepository.getApiKeysResult =
          Left(CacheFailure('Storage error'));

      final result = await usecase(provider: 'openai');

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, 'Storage error');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should accept all supported providers', () async {
      for (final provider in ['openai', 'claude', 'gemini']) {
        mockRepository.getApiKeysResult = Right(
          ApiKeyConfigEntity(
            openaiKey: 'key-openai',
            claudeKey: 'key-claude',
            geminiKey: 'key-gemini',
          ),
        );

        final result = await usecase(provider: provider);
        expect(result.isRight(), true,
            reason: 'Provider $provider should be supported');
      }
    });
  });
}
