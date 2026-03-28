import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/provider_config.dart';
import '../../domain/repositories/settings_repository.dart';

class UpdateProviderConfig {
  final SettingsRepository repository;

  UpdateProviderConfig(this.repository);

  Future<Either<Failure, void>> call(ProviderConfigEntity config) {
    return repository.saveProviderConfig(config);
  }
}
