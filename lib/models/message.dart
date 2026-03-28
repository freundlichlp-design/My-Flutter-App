import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 1)
class Message extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String conversationId;

  @HiveField(2)
  final String role;

  @HiveField(3)
  String content;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final int? tokens;

  @HiveField(6)
  final String? imagePath;

  Message({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    required this.timestamp,
    this.tokens,
    this.imagePath,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      tokens: json['tokens'] as int?,
      imagePath: json['imagePath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'role': role,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'tokens': tokens,
      'imagePath': imagePath,
    };
  }

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';
  bool get isSystem => role == 'system';
}
