import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_app/core/errors/failures.dart';
import 'package:my_flutter_app/features/chat/domain/entities/conversation.dart';
import 'package:my_flutter_app/features/chat/domain/entities/message.dart';
import 'package:my_flutter_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:my_flutter_app/features/chat/domain/usecases/delete_conversation.dart';

class MockChatRepository implements ChatRepository {
  Either<Failure, void> deleteConversationResult = const Right(null);
  Either<Failure, void> saveMessageResult = const Right(null);
  Either<Failure, void> saveConversationResult = const Right(null);
  Either<Failure, List<ConversationEntity>> getConversationsResult =
      const Right([]);
  Either<Failure, ConversationEntity>? getConversationResult;
  Either<Failure, List<MessageEntity>> getMessagesResult = const Right([]);
  Stream<Either<Failure, String>> sendMessageResult =
      Stream.value(const Right(''));

  String? deletedConversationId;

  @override
  Future<Either<Failure, void>> deleteConversation(String id) async {
    deletedConversationId = id;
    return deleteConversationResult;
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
  late DeleteConversation usecase;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    usecase = DeleteConversation(mockRepository);
  });

  group('DeleteConversation', () {
    test('should delete conversation via repository', () async {
      final result = await usecase('conv-1');

      expect(result.isRight(), true);
      expect(mockRepository.deletedConversationId, 'conv-1');
    });

    test('should return failure when repository fails', () async {
      mockRepository.deleteConversationResult =
          Left(CacheFailure('Not found'));

      final result = await usecase('conv-999');

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, 'Not found');
        },
        (_) => fail('Should return failure'),
      );
    });
  });
}
