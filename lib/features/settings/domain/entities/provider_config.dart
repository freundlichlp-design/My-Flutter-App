import 'package:equatable/equatable.dart';

class ProviderConfigEntity extends Equatable {
  final String selectedProvider;
  final String selectedModel;

  const ProviderConfigEntity({
    required this.selectedProvider,
    required this.selectedModel,
  });

  static const Map<String, List<String>> providerModels = {
    'openai': ['gpt-4o', 'gpt-4o-mini', 'gpt-3.5-turbo'],
    'claude': ['claude-sonnet-4-20250514', 'claude-opus-4-20250514', 'claude-3-5-haiku-20241022'],
    'gemini': ['gemini-2.0-flash', 'gemini-1.5-pro'],
  };

  List<String> get availableModels =>
      providerModels[selectedProvider] ?? ['gpt-4o'];

  @override
  List<Object?> get props => [selectedProvider, selectedModel];
}
