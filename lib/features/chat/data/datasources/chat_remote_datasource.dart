import 'dart:async';

import '../../../../models/message.dart';
import '../../../../services/ai_api_service.dart';
import '../../../../services/claude_service.dart';
import '../../../../services/gemini_service.dart';
import '../../../../services/openai_service.dart';

class ChatRemoteDatasource {
  AiApiService _createService({
    required String provider,
    required String apiKey,
    required String model,
  }) {
    switch (provider) {
      case 'claude':
        return ClaudeService(apiKey: apiKey, model: model);
      case 'gemini':
        return GeminiService(apiKey: apiKey, model: model);
      default:
        return OpenAiService(apiKey: apiKey, model: model);
    }
  }

  Stream<String> sendMessage({
    required List<Message> history,
    required String provider,
    required String apiKey,
    required String model,
    String? systemPrompt,
  }) {
    final service = _createService(
      provider: provider,
      apiKey: apiKey,
      model: model,
    );
    return service.sendMessage(history, systemPrompt: systemPrompt);
  }
}
