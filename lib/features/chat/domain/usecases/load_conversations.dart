import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/chat_repository.dart';

class LoadConversations {
  final ChatRepository repository;

  LoadConversations(this.repository);

  Future<Either<Failure, List<ConversationEntity>>> call() async {
    return repository.getConversations();
  }
}
