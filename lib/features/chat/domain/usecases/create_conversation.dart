import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/chat_repository.dart';

class CreateConversation {
  final ChatRepository repository;

  CreateConversation(this.repository);

  Future<Either<Failure, void>> call(ConversationEntity conversation) async {
    return repository.saveConversation(conversation);
  }
}
