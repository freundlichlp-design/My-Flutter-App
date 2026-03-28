import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repositories/settings_repository.dart';

class SaveApiKey {
  final SettingsRepository repository;

  SaveApiKey(this.repository);

  Future<Either<Failure, void>> call(String provider, String key) {
    return repository.saveApiKey(provider, key);
  }
}
