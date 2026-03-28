import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/message.dart';
import 'ai_api_service.dart';

class ClaudeService implements AiApiService {
  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';

  final http.Client _client;
  final String apiKey;
  final String model;

  ClaudeService({
    required this.apiKey,
    this.model = 'claude-sonnet-4-20250514',
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
      for (final msg in history) {
        messages.add({'role': msg.role, 'content': msg.content});
      }

      final body = <String, dynamic>{
        'model': model,
        'max_tokens': 4096,
        'stream': true,
        'messages': messages,
      };

      if (systemPrompt != null) {
        body['system'] = systemPrompt;
      }

      final request = http.Request('POST', Uri.parse(_baseUrl));
      request.headers['x-api-key'] = apiKey;
      request.headers['anthropic-version'] = '2023-06-01';
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);

      final response = await _client.send(request);

      if (response.statusCode != 200) {
        final responseBody = await response.stream.bytesToString();
        controller.addError(Exception('Claude API error ${response.statusCode}: $responseBody'));
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
            try {
              final json = jsonDecode(data) as Map<String, dynamic>;
              final type = json['type'] as String?;
              if (type == 'content_block_delta') {
                final delta = json['delta'] as Map<String, dynamic>?;
                final text = delta?['text'] as String?;
                if (text != null) {
                  controller.add(text);
                }
              } else if (type == 'message_stop') {
                controller.close();
              }
            } catch (e) {
              debugPrint('Claude stream parse error: $e');
            }
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

  @override
  void dispose() => _client.close();
}
