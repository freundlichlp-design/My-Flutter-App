import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/api_key_config.dart';
import '../entities/personality.dart';
import '../entities/provider_config.dart';

abstract class SettingsRepository {
  Future<Either<Failure, ApiKeyConfigEntity>> getApiKeys();
  Future<Either<Failure, void>> saveApiKey(String provider, String key);
  Future<Either<Failure, ProviderConfigEntity>> getProviderConfig();
  Future<Either<Failure, void>> saveProviderConfig(ProviderConfigEntity config);
  Future<Either<Failure, PersonalityEntity>> getSelectedPersonality();
  Future<Either<Failure, void>> saveSelectedPersonality(String personalityId);
}
