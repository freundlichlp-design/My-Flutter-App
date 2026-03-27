import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/kali_personality.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _openaiController = TextEditingController();
  final _claudeController = TextEditingController();
  final _geminiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = context.read<SettingsProvider>();
      _openaiController.text = settings.getMaskedKey('openai');
      _claudeController.text = settings.getMaskedKey('claude');
      _geminiController.text = settings.getMaskedKey('gemini');
    });
  }

  @override
  void dispose() {
    _openaiController.dispose();
    _claudeController.dispose();
    _geminiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'API Provider',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'openai', label: Text('OpenAI')),
                  ButtonSegment(value: 'claude', label: Text('Claude')),
                  ButtonSegment(value: 'gemini', label: Text('Gemini')),
                ],
                selected: {settings.selectedProvider},
                onSelectionChanged: (selected) {
                  settings.setSelectedProvider(selected.first);
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Model',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: settings.selectedModel,
                items: settings.availableModels
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) settings.setSelectedModel(value);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Kali Personality',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: settings.selectedPersonalityId,
                items: KaliPersonality.all
                    .map((p) => DropdownMenuItem(
                          value: p.id,
                          child: Text('${p.name} — ${p.description}'),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) settings.setSelectedPersonality(value);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'API Keys',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              _buildApiKeyField(
                label: 'OpenAI API Key',
                controller: _openaiController,
                onChanged: settings.setOpenaiApiKey,
                obscured: true,
              ),
              const SizedBox(height: 12),
              _buildApiKeyField(
                label: 'Claude API Key',
                controller: _claudeController,
                onChanged: settings.setClaudeApiKey,
                obscured: true,
              ),
              const SizedBox(height: 12),
              _buildApiKeyField(
                label: 'Gemini API Key',
                controller: _geminiController,
                onChanged: settings.setGeminiApiKey,
                obscured: true,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildApiKeyField({
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    bool obscured = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscured,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.save),
          onPressed: () => onChanged(controller.text),
        ),
      ),
    );
  }
}
