import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_app/core/errors/failures.dart';
import 'package:my_flutter_app/features/chat/domain/entities/conversation.dart';
import 'package:my_flutter_app/features/chat/domain/entities/message.dart';
import 'package:my_flutter_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:my_flutter_app/features/chat/domain/usecases/chat_send_message.dart';

class MockChatRepository implements ChatRepository {
  Either<Failure, void> saveMessageResult = const Right(null);
  Either<Failure, void> saveConversationResult = const Right(null);
  Either<Failure, void> deleteConversationResult = const Right(null);
  Either<Failure, List<ConversationEntity>> getConversationsResult =
      const Right([]);
  Either<Failure, ConversationEntity>? getConversationResult;
  Either<Failure, List<MessageEntity>> getMessagesResult = const Right([]);
  Stream<Either<Failure, String>> sendMessageResult =
      Stream.value(const Right(''));

  MessageEntity? savedMessage;

  @override
  Future<Either<Failure, void>> saveMessage(MessageEntity message) async {
    savedMessage = message;
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
  Future<Either<Failure, List<MessageEntity>>> getMessages(
      String conversationId) async {
    return getMessagesResult;
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
  late ChatSendMessage usecase;
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
    usecase = ChatSendMessage(mockRepository);
  });

  group('ChatSendMessage', () {
    test('should return ValidationFailure when content is empty', () async {
      final result = await usecase(
        content: '',
        conversation: testConversation,
        provider: 'openai',
        apiKey: 'test-key',
        model: 'gpt-4o',
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, 'Message cannot be empty');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return ValidationFailure when content is only whitespace',
        () async {
      final result = await usecase(
        content: '   ',
        conversation: testConversation,
        provider: 'openai',
        apiKey: 'test-key',
        model: 'gpt-4o',
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, 'Message cannot be empty');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return ValidationFailure when content exceeds 10000 chars',
        () async {
      final longContent = 'a' * 10001;

      final result = await usecase(
        content: longContent,
        conversation: testConversation,
        provider: 'openai',
        apiKey: 'test-key',
        model: 'gpt-4o',
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, 'Message too long (max 10000 chars)');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should save message and return it on success', () async {
      final result = await usecase(
        content: 'Hello, world!',
        conversation: testConversation,
        provider: 'openai',
        apiKey: 'test-key',
        model: 'gpt-4o',
      );

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return message'),
        (message) {
          expect(message.role, 'user');
          expect(message.content, 'Hello, world!');
          expect(message.conversationId, 'conv-1');
          expect(message.id, isNotEmpty);
        },
      );
      expect(mockRepository.savedMessage, isNotNull);
      expect(mockRepository.savedMessage!.content, 'Hello, world!');
    });

    test('should trim whitespace from content before saving', () async {
      final result = await usecase(
        content: '  Hello!  ',
        conversation: testConversation,
        provider: 'openai',
        apiKey: 'test-key',
        model: 'gpt-4o',
      );

      result.fold(
        (_) => fail('Should return message'),
        (message) {
          expect(message.content, 'Hello!');
        },
      );
    });

    test('should return failure when repository fails to save', () async {
      mockRepository.saveMessageResult =
          Left(CacheFailure('Storage error'));

      final result = await usecase(
        content: 'Hello!',
        conversation: testConversation,
        provider: 'openai',
        apiKey: 'test-key',
        model: 'gpt-4o',
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, 'Storage error');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should accept exactly 10000 characters', () async {
      final content = 'a' * 10000;

      final result = await usecase(
        content: content,
        conversation: testConversation,
        provider: 'openai',
        apiKey: 'test-key',
        model: 'gpt-4o',
      );

      expect(result.isRight(), true);
    });
  });
}
