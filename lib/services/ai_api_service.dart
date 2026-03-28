import '../models/message.dart';

abstract class AiApiService {
  Stream<String> sendMessage(List<Message> history, {String? systemPrompt});
  Future<String> getResponse(List<Message> history, {String? systemPrompt});
  void dispose() {}
}
