import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatGetHistory {
  final ChatRepository repository;

  ChatGetHistory(this.repository);

  Future<Either<Failure, List<MessageEntity>>> call({
    required String conversationId,
  }) async {
    if (conversationId.trim().isEmpty) {
      return Left(ValidationFailure('Conversation ID cannot be empty'));
    }

    return repository.getMessages(conversationId);
  }
}
