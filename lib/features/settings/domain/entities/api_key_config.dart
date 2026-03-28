import 'package:equatable/equatable.dart';

class ApiKeyConfigEntity extends Equatable {
  final String openaiKey;
  final String claudeKey;
  final String geminiKey;

  const ApiKeyConfigEntity({
    required this.openaiKey,
    required this.claudeKey,
    required this.geminiKey,
  });

  String getKeyForProvider(String provider) {
    return switch (provider) {
      'claude' => claudeKey,
      'gemini' => geminiKey,
      _ => openaiKey,
    };
  }

  bool isProviderConfigured(String provider) =>
      getKeyForProvider(provider).isNotEmpty;

  @override
  List<Object?> get props => [openaiKey, claudeKey, geminiKey];
}
