import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repositories/settings_repository.dart';

class SavePersonality {
  final SettingsRepository repository;

  SavePersonality(this.repository);

  Future<Either<Failure, void>> call(String personalityId) {
    return repository.saveSelectedPersonality(personalityId);
  }
}
