import 'package:equatable/equatable.dart';

class ConversationEntity extends Equatable {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String model;
  final String apiProvider;

  const ConversationEntity({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.model,
    required this.apiProvider,
  });

  @override
  List<Object?> get props => [id, title, createdAt, updatedAt, model, apiProvider];
}
