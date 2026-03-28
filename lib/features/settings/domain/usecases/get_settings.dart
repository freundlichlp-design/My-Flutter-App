import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/api_key_config.dart';
import '../../domain/entities/personality.dart';
import '../../domain/entities/provider_config.dart';
import '../../domain/repositories/settings_repository.dart';

class GetSettings {
  final SettingsRepository repository;

  GetSettings(this.repository);

  Future<Either<Failure, ApiKeyConfigEntity>> getApiKeys() {
    return repository.getApiKeys();
  }

  Future<Either<Failure, ProviderConfigEntity>> getProviderConfig() {
    return repository.getProviderConfig();
  }

  Future<Either<Failure, PersonalityEntity>> getSelectedPersonality() {
    return repository.getSelectedPersonality();
  }
}
