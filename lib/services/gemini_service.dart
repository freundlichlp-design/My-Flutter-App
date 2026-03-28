import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/message.dart';
import 'ai_api_service.dart';

class GeminiService implements AiApiService {
  final http.Client _client;
  final String apiKey;
  final String model;

  GeminiService({
    required this.apiKey,
    this.model = 'gemini-2.0-flash',
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
      final contents = <Map<String, dynamic>>[];
      for (final msg in history) {
        final role = msg.role == 'assistant' ? 'model' : 'user';
        contents.add({
          'role': role,
          'parts': [
            {'text': msg.content}
          ],
        });
      }

      final body = <String, dynamic>{
        'contents': contents,
      };

      if (systemPrompt != null) {
        contents.insert(0, {
          'role': 'user',
          'parts': [
            {'text': 'System instruction: $systemPrompt'}
          ],
        });
      }

      final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:streamGenerateContent?key=$apiKey',
      );

      final request = http.Request('POST', uri);
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);

      final response = await _client.send(request);

      if (response.statusCode != 200) {
        final responseBody = await response.stream.bytesToString();
        controller.addError(Exception('Gemini API error ${response.statusCode}: $responseBody'));
        await controller.close();
        return;
      }

      response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
        (line) {
          if (line.trim().isEmpty) return;
          try {
            // Gemini streamGenerateContent returns a JSON array that may be
            // split across lines. Try to parse each line as a JSON object.
            String cleaned = line.trim();
            if (cleaned.endsWith(',')) cleaned = cleaned.substring(0, cleaned.length - 1);
            if (cleaned.startsWith('[')) cleaned = cleaned.substring(1);
            if (cleaned.endsWith(']')) cleaned = cleaned.substring(0, cleaned.length - 1);

            final json = jsonDecode(cleaned) as Map<String, dynamic>;
            final candidates = json['candidates'] as List<dynamic>?;
            if (candidates != null && candidates.isNotEmpty) {
              final content = candidates[0]['content'] as Map<String, dynamic>?;
              final parts = content?['parts'] as List<dynamic>?;
              if (parts != null && parts.isNotEmpty) {
                final text = parts[0]['text'] as String?;
                if (text != null) {
                  controller.add(text);
                }
              }
            }
          } catch (e) {
            debugPrint('Gemini stream parse error: $e');
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
