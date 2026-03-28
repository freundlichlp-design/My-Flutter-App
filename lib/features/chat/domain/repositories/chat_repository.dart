import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/conversation.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ConversationEntity>>> getConversations();
  Future<Either<Failure, ConversationEntity>> getConversation(String id);
  Future<Either<Failure, void>> saveConversation(ConversationEntity conversation);
  Future<Either<Failure, void>> deleteConversation(String id);
  Future<Either<Failure, List<MessageEntity>>> getMessages(String conversationId);
  Future<Either<Failure, void>> saveMessage(MessageEntity message);
  Stream<Either<Failure, String>> sendMessage(
    List<MessageEntity> history, {
    String? systemPrompt,
    required String provider,
    required String apiKey,
    required String model,
  });
}
