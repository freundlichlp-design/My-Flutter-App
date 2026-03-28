import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_app/core/errors/failures.dart';
import 'package:my_flutter_app/features/chat/domain/entities/conversation.dart';
import 'package:my_flutter_app/features/chat/domain/entities/message.dart';
import 'package:my_flutter_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:my_flutter_app/features/chat/domain/usecases/chat_get_history.dart';

class MockChatRepository implements ChatRepository {
  Either<Failure, List<MessageEntity>> getMessagesResult = const Right([]);
  Either<Failure, void> saveMessageResult = const Right(null);
  Either<Failure, void> saveConversationResult = const Right(null);
  Either<Failure, void> deleteConversationResult = const Right(null);
  Either<Failure, List<ConversationEntity>> getConversationsResult =
      const Right([]);
  Either<Failure, ConversationEntity>? getConversationResult;
  Stream<Either<Failure, String>> sendMessageResult =
      Stream.value(const Right(''));

  String? requestedConversationId;

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(
      String conversationId) async {
    requestedConversationId = conversationId;
    return getMessagesResult;
  }

  @override
  Future<Either<Failure, void>> saveMessage(MessageEntity message) async {
    return saveMessageResult;
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
  Future<Either<Failure, void>> saveConversation(
      ConversationEntity conversation) async {
    return saveConversationResult;
  }

  @override
  Future<Either<Failure, void>> deleteConversation(String id) async {
    return deleteConversationResult;
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
  late ChatGetHistory usecase;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    usecase = ChatGetHistory(mockRepository);
  });

  group('ChatGetHistory', () {
    test('should return ValidationFailure when conversationId is empty',
        () async {
      final result = await usecase(conversationId: '');

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, 'Conversation ID cannot be empty');
        },
        (_) => fail('Should return failure'),
      );
    });

    test(
        'should return ValidationFailure when conversationId is only whitespace',
        () async {
      final result = await usecase(conversationId: '   ');

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, 'Conversation ID cannot be empty');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should call repository.getMessages with correct conversationId',
        () async {
      await usecase(conversationId: 'conv-123');

      expect(mockRepository.requestedConversationId, 'conv-123');
    });

    test('should return empty list when no messages exist', () async {
      mockRepository.getMessagesResult = const Right([]);

      final result = await usecase(conversationId: 'conv-1');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return messages'),
        (messages) => expect(messages, isEmpty),
      );
    });

    test('should return messages from repository', () async {
      final messages = [
        MessageEntity(
          id: 'msg-1',
          conversationId: 'conv-1',
          role: 'user',
          content: 'Hello',
          timestamp: DateTime(2025, 1, 1, 10, 0),
        ),
        MessageEntity(
          id: 'msg-2',
          conversationId: 'conv-1',
          role: 'assistant',
          content: 'Hi there!',
          timestamp: DateTime(2025, 1, 1, 10, 1),
        ),
      ];
      mockRepository.getMessagesResult = Right(messages);

      final result = await usecase(conversationId: 'conv-1');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return messages'),
        (resultMessages) {
          expect(resultMessages.length, 2);
          expect(resultMessages[0].content, 'Hello');
          expect(resultMessages[1].content, 'Hi there!');
        },
      );
    });

    test('should return CacheFailure when repository fails', () async {
      mockRepository.getMessagesResult =
          Left(CacheFailure('Database error'));

      final result = await usecase(conversationId: 'conv-1');

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, 'Database error');
        },
        (_) => fail('Should return failure'),
      );
    });
  });
}
