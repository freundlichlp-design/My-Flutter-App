import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_app/core/errors/failures.dart';
import 'package:my_flutter_app/features/chat/domain/entities/conversation.dart';
import 'package:my_flutter_app/features/chat/domain/entities/message.dart';
import 'package:my_flutter_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:my_flutter_app/features/chat/domain/usecases/create_conversation.dart';

class MockChatRepository implements ChatRepository {
  Either<Failure, void> saveConversationResult = const Right(null);
  Either<Failure, void> saveMessageResult = const Right(null);
  Either<Failure, void> deleteConversationResult = const Right(null);
  Either<Failure, List<ConversationEntity>> getConversationsResult =
      const Right([]);
  Either<Failure, ConversationEntity>? getConversationResult;
  Either<Failure, List<MessageEntity>> getMessagesResult = const Right([]);
  Stream<Either<Failure, String>> sendMessageResult =
      Stream.value(const Right(''));

  ConversationEntity? savedConversation;

  @override
  Future<Either<Failure, void>> saveConversation(
      ConversationEntity conversation) async {
    savedConversation = conversation;
    return saveConversationResult;
  }

  @override
  Future<Either<Failure, List<ConversationEntity>>> getConversations() async {
    return getConversationsResult;
  }

  @override
  Future<Either<Failure, ConversationEntity>> getConversation(String id) async {
    return getConversationResult ?? Left(CacheFailure('Not found'));
  }

  @override
  Future<Either<Failure, void>> deleteConversation(String id) async {
    return deleteConversationResult;
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(
      String conversationId) async {
    return getMessagesResult;
  }

  @override
  Future<Either<Failure, void>> saveMessage(MessageEntity message) async {
    return saveMessageResult;
  }

  @override
  Stream<Either<Failure, String>> sendMessage(
    List<MessageEntity> history, {
    String? systemPrompt,
    required String provider,
    required String apiKey,
    required String model,
  }) {
    return sendMessageResult;
  }
}

void main() {
  late CreateConversation usecase;
  late MockChatRepository mockRepository;

  final testConversation = ConversationEntity(
    id: 'conv-1',
    title: 'Test Chat',
    createdAt: DateTime(2025, 1, 1),
    updatedAt: DateTime(2025, 1, 1),
    model: 'gpt-4o',
    apiProvider: 'openai',
  );

  setUp(() {
    mockRepository = MockChatRepository();
    usecase = CreateConversation(mockRepository);
  });

  group('CreateConversation', () {
    test('should save conversation via repository', () async {
      final result = await usecase(testConversation);

      expect(result.isRight(), true);
      expect(mockRepository.savedConversation, testConversation);
    });

    test('should return failure when repository fails', () async {
      mockRepository.saveConversationResult =
          Left(CacheFailure('Storage full'));

      final result = await usecase(testConversation);

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, 'Storage full');
        },
        (_) => fail('Should return failure'),
      );
    });
  });
}
