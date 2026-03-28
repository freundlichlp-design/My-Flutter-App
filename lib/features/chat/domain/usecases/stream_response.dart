import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';

class StreamResponse {
  final ChatRepository repository;

  StreamResponse(this.repository);

  Stream<Either<Failure, String>> call({
    required List<MessageEntity> history,
    String? systemPrompt,
    required String provider,
    required String apiKey,
    required String model,
  }) {
    return repository.sendMessage(
      history,
      systemPrompt: systemPrompt,
      provider: provider,
      apiKey: apiKey,
      model: model,
    );
  }
}
