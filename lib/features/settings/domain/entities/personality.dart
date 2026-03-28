import 'package:equatable/equatable.dart';

class PersonalityEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String systemPrompt;

  const PersonalityEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.systemPrompt,
  });

  @override
  List<Object?> get props => [id, name, description, systemPrompt];
}
