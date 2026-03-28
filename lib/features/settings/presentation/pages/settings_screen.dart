import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/settings_provider.dart';
import '../../../../../models/kali_personality.dart';
import '../../../../../theme/kali_colors.dart';
import '../../../../../theme/kali_spacing.dart';
import '../../../../../theme/kali_text_styles.dart';

class SettingsScreen extends StatefulWidget {
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
            padding: KaliSpacing.paddingMD,
            children: [
              // Theme Toggle
              Container(
                padding: KaliSpacing.paddingSM,
                decoration: BoxDecoration(
                  color: KaliColors.bgSecondary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: KaliColors.borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          color: KaliColors.accentPrimary,
                        ),
                        const SizedBox(width: KaliSpacing.sm),
                        Text(
                          'Dark Mode',
                          style: KaliTextStyles.body,
                        ),
                      ],
                    ),
                    Switch(
                      value: settings.isDarkMode,
                      onChanged: (_) => settings.toggleThemeMode(),
                      activeColor: KaliColors.accentPrimary,
                      activeTrackColor: KaliColors.accentPrimary.withValues(alpha: 0.3),
                      inactiveThumbColor: KaliColors.textMuted,
                      inactiveTrackColor: KaliColors.bgTertiary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: KaliSpacing.lg),
              Text(
                'API Provider',
                style: KaliTextStyles.subtitle,
              ),
              const SizedBox(height: KaliSpacing.sm),
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
              const SizedBox(height: KaliSpacing.lg),
              Text(
                'Model',
                style: KaliTextStyles.subtitle,
              ),
              const SizedBox(height: KaliSpacing.sm),
              DropdownButtonFormField<String>(
                value: settings.selectedModel,
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
              const SizedBox(height: KaliSpacing.lg),
              const Divider(),
              const SizedBox(height: KaliSpacing.md),
              Text(
                'Kali Personality',
                style: KaliTextStyles.subtitle,
              ),
              const SizedBox(height: KaliSpacing.sm),
              DropdownButtonFormField<String>(
                value: settings.selectedPersonalityId,
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
              const SizedBox(height: KaliSpacing.lg),
              const Divider(),
              const SizedBox(height: KaliSpacing.md),
              Text(
                'API Keys',
                style: KaliTextStyles.subtitle,
              ),
              const SizedBox(height: KaliSpacing.md),
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
              const SizedBox(height: KaliSpacing.lg),
              const Divider(),
              const SizedBox(height: KaliSpacing.md),
              Text(
                'Memory & Privacy',
                style: KaliTextStyles.subtitle,
              ),
              const SizedBox(height: KaliSpacing.sm),
              ListTile(
                leading: const Icon(Icons.psychology, color: KaliColors.accentPrimary),
                title: const Text('Memory Einstellungen'),
                subtitle: const Text('Fact-Extraction, Datenschutz, gespeicherte Fakten'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/settings/memory'),
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
