import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatSendMessage {
  final ChatRepository repository;
  static const _uuid = Uuid();

  ChatSendMessage(this.repository);

  Future<Either<Failure, MessageEntity>> call({
    required String content,
    required ConversationEntity conversation,
    required String provider,
    required String apiKey,
    required String model,
  }) async {
    if (content.trim().isEmpty) {
      return Left(ValidationFailure('Message cannot be empty'));
    }

    if (content.length > 10000) {
      return Left(ValidationFailure('Message too long (max 10000 chars)'));
    }

    final userMessage = MessageEntity(
      id: _uuid.v4(),
      conversationId: conversation.id,
      role: 'user',
      content: content.trim(),
      timestamp: DateTime.now(),
    );

    final saveResult = await repository.saveMessage(userMessage);
    return saveResult.fold(
      (failure) => Left(failure),
      (_) => Right(userMessage),
    );
  }
}
