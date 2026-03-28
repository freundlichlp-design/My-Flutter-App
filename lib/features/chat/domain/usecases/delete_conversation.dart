import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repositories/chat_repository.dart';

class DeleteConversation {
  final ChatRepository repository;

  DeleteConversation(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return repository.deleteConversation(id);
  }
}
