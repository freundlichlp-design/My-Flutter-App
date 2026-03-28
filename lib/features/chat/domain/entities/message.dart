import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String conversationId;
  final String role;
  final String content;
  final DateTime timestamp;
  final int? tokens;
  final String? imagePath;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    required this.timestamp,
    this.tokens,
    this.imagePath,
  });

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';
  bool get isSystem => role == 'system';
  bool get hasImage => imagePath != null && imagePath!.isNotEmpty;

  @override
  List<Object?> get props => [id, conversationId, role, content, timestamp, tokens, imagePath];
}
