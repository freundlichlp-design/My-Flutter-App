import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/message.dart';
import 'ai_api_service.dart';

class OpenAiService implements AiApiService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  final http.Client _client;
  final String apiKey;
  final String model;

  OpenAiService({
    required this.apiKey,
    this.model = 'gpt-4o',
    http.Client? client,
  }) : _client = client ?? http.Client();

  @override
  Stream<String> sendMessage(List<Message> history, {String? systemPrompt}) {
    final controller = StreamController<String>();

    _streamRequest(history, systemPrompt, controller);

    return controller.stream;
  }

  @override
  Future<String> getResponse(List<Message> history, {String? systemPrompt}) async {
    final buffer = StringBuffer();
    await for (final chunk in sendMessage(history, systemPrompt: systemPrompt)) {
      buffer.write(chunk);
    }
    return buffer.toString();
  }

  Future<void> _streamRequest(
    List<Message> history,
    String? systemPrompt,
    StreamController<String> controller,
  ) async {
    try {
      final messages = <Map<String, String>>[];

      if (systemPrompt != null) {
        messages.add({'role': 'system', 'content': systemPrompt});
      }

      for (final msg in history) {
        messages.add({'role': msg.role, 'content': msg.content});
      }

      final request = http.Request('POST', Uri.parse(_baseUrl));
      request.headers['Authorization'] = 'Bearer $apiKey';
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode({
        'model': model,
        'stream': true,
        'messages': messages,
      });

      final response = await _client.send(request);

      if (response.statusCode != 200) {
        final body = await response.stream.bytesToString();
        controller.addError(Exception('OpenAI API error ${response.statusCode}: $body'));
        await controller.close();
        return;
      }

      response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
        (line) {
          if (line.startsWith('data: ')) {
            final data = line.substring(6);
            if (data == '[DONE]') {
              controller.close();
              return;
            }
            try {
              final json = jsonDecode(data) as Map<String, dynamic>;
              final choices = json['choices'] as List<dynamic>?;
              if (choices != null && choices.isNotEmpty) {
                final delta = choices[0]['delta'] as Map<String, dynamic>?;
                final content = delta?['content'] as String?;
                if (content != null) {
                  controller.add(content);
                }
              }
            } catch (_) {}
          }
        },
        onError: (error) {
          controller.addError(error);
          controller.close();
        },
        onDone: () {
          controller.close();
        },
      );
    } catch (e) {
      controller.addError(e);
      await controller.close();
    }
  }
}
