import 'package:hive/hive.dart';

part 'memory_entry.g.dart';

@HiveType(typeId: 2)
class MemoryEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fact;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String sourceConversationId;

  @HiveField(4)
  final DateTime extractedAt;

  @HiveField(5)
  final bool isPrivate;

  MemoryEntry({
    required this.id,
    required this.fact,
    required this.category,
    required this.sourceConversationId,
    required this.extractedAt,
    this.isPrivate = false,
  });

  factory MemoryEntry.fromJson(Map<String, dynamic> json) {
    return MemoryEntry(
      id: json['id'] as String,
      fact: json['fact'] as String,
      category: json['category'] as String,
      sourceConversationId: json['sourceConversationId'] as String,
      extractedAt: DateTime.parse(json['extractedAt'] as String),
      isPrivate: json['isPrivate'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fact': fact,
      'category': category,
      'sourceConversationId': sourceConversationId,
      'extractedAt': extractedAt.toIso8601String(),
      'isPrivate': isPrivate,
    };
  }
}
