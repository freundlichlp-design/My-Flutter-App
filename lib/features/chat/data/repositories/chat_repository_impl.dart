import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../models/conversation.dart';
import '../../../../models/message.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDatasource _localDatasource;
  final ChatRemoteDatasource _remoteDatasource;

  ChatRepositoryImpl({
    required ChatLocalDatasource localDatasource,
    required ChatRemoteDatasource remoteDatasource,
  })  : _localDatasource = localDatasource,
        _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, List<ConversationEntity>>> getConversations() async {
    try {
      final conversations = _localDatasource.getAllConversations();
      return Right(conversations.map(_toEntity).toList());
    } catch (e) {
      return Left(CacheFailure('Failed to load conversations: $e'));
    }
  }

  @override
  Future<Either<Failure, ConversationEntity>> getConversation(
      String id) async {
    try {
      final conversation = _localDatasource.getConversation(id);
      if (conversation == null) {
        return Left(CacheFailure('Conversation not found: $id'));
      }
      return Right(_toEntity(conversation));
    } catch (e) {
      return Left(CacheFailure('Failed to load conversation: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveConversation(
      ConversationEntity conversation) async {
    try {
      await _localDatasource.saveConversation(_toModel(conversation));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save conversation: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteConversation(String id) async {
    try {
      await _localDatasource.deleteConversation(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to delete conversation: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(
      String conversationId) async {
    try {
      final messages =
          _localDatasource.getMessagesForConversation(conversationId);
      return Right(messages.map(_toMessageEntity).toList());
    } catch (e) {
      return Left(CacheFailure('Failed to load messages: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveMessage(MessageEntity message) async {
    try {
      await _localDatasource.saveMessage(_toMessageModel(message));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save message: $e'));
    }
  }

  @override
  Stream<Either<Failure, String>> sendMessage(
    List<MessageEntity> history, {
    String? systemPrompt,
    required String provider,
    required String apiKey,
    required String model,
  }) {
    final models = history.map(_toMessageModel).toList();
    return _remoteDatasource
        .sendMessage(
      history: models,
      provider: provider,
      apiKey: apiKey,
      model: model,
      systemPrompt: systemPrompt,
    )
        .map((chunk) {
      return Right<Failure, String>(chunk);
    }).handleError((error) {
      return Left<Failure, String>(
          ServerFailure('Streaming error: $error'));
    });
  }

  ConversationEntity _toEntity(Conversation model) {
    return ConversationEntity(
      id: model.id,
      title: model.title,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      model: model.model,
      apiProvider: model.apiProvider,
    );
  }

  Conversation _toModel(ConversationEntity entity) {
    return Conversation(
      id: entity.id,
      title: entity.title,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      model: entity.model,
      apiProvider: entity.apiProvider,
    );
  }

  MessageEntity _toMessageEntity(Message model) {
    return MessageEntity(
      id: model.id,
      conversationId: model.conversationId,
      role: model.role,
      content: model.content,
      timestamp: model.timestamp,
      tokens: model.tokens,
      imagePath: model.imagePath,
    );
  }

  Message _toMessageModel(MessageEntity entity) {
    return Message(
      id: entity.id,
      conversationId: entity.conversationId,
      role: entity.role,
      content: entity.content,
      timestamp: entity.timestamp,
      tokens: entity.tokens,
      imagePath: entity.imagePath,
    );
  }
}
