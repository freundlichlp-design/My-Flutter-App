import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsGetApiKey {
  final SettingsRepository repository;

  SettingsGetApiKey(this.repository);

  Future<Either<Failure, String>> call({
    required String provider,
  }) async {
    if (provider.trim().isEmpty) {
      return Left(ValidationFailure('Provider cannot be empty'));
    }

    const supportedProviders = ['openai', 'claude', 'gemini'];
    if (!supportedProviders.contains(provider)) {
      return Left(ValidationFailure(
        'Unsupported provider: $provider. Supported: ${supportedProviders.join(", ")}',
      ));
    }

    final keysResult = await repository.getApiKeys();
    return keysResult.fold(
      (failure) => Left(failure),
      (apiKeys) {
        final key = apiKeys.getKeyForProvider(provider);
        if (key.isEmpty) {
          return Left(AuthFailure(
            'No API key configured for $provider. Please add one in Settings.',
          ));
        }
        return Right(key);
      },
    );
  }
}
