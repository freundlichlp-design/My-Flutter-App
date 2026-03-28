import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/memory_provider.dart';
import '../../../../theme/kali_colors.dart';
import '../../../../theme/kali_spacing.dart';
import '../../../../theme/kali_text_styles.dart';

class MemorySettingsScreen extends StatelessWidget {
  const MemorySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory & Privacy'),
      ),
      body: Consumer<MemoryProvider>(
        builder: (context, memory, _) {
          final settings = memory.privacySettings;
          return ListView(
            padding: KaliSpacing.paddingMD,
            children: [
              // Header
              Container(
                padding: KaliSpacing.paddingMD,
                decoration: BoxDecoration(
                  color: KaliColors.bgSecondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: KaliColors.borderColor),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.psychology, color: KaliColors.accentPrimary, size: 32),
                    const SizedBox(width: KaliSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hive Memory Box',
                              style: KaliTextStyles.subtitle),
                          const SizedBox(height: 4),
                          Text(
                            '${memory.memoryCount} Fakten gespeichert',
                            style: KaliTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: KaliSpacing.lg),

              // Privacy Toggles
              Text('Datenschutz', style: KaliTextStyles.subtitle),
              const SizedBox(height: KaliSpacing.md),

              _buildSwitchTile(
                title: 'Memory aktiviert',
                subtitle: 'Fakten aus Gesprächen speichern',
                value: settings.memoryEnabled,
                onChanged: memory.toggleMemoryEnabled,
                icon: Icons.memory,
              ),
              _buildSwitchTile(
                title: 'Auto Fact-Extraction',
                subtitle: 'Fakten automatisch erkennen',
                value: settings.autoExtractFacts,
                onChanged: memory.toggleAutoExtractFacts,
                icon: Icons.auto_awesome,
              ),
              const Divider(height: 32),
              _buildSwitchTile(
                title: 'Persönliche Daten',
                subtitle: 'Namen, Adresse etc. speichern',
                value: settings.storePersonalInfo,
                onChanged: memory.toggleStorePersonalInfo,
                icon: Icons.person,
                isWarning: true,
              ),
              _buildSwitchTile(
                title: 'Präferenzen',
                subtitle: 'Vorlieben und Meinungen speichern',
                value: settings.storePreferences,
                onChanged: memory.toggleStorePreferences,
                icon: Icons.favorite,
              ),
              _buildSwitchTile(
                title: 'Technische Fakten',
                subtitle: 'Tech-Stack, Tools etc. speichern',
                value: settings.storeTechnicalFacts,
                onChanged: memory.toggleStoreTechnicalFacts,
                icon: Icons.code,
              ),
              const SizedBox(height: KaliSpacing.lg),

              // Memory Stats
              Text('Kategorien', style: KaliTextStyles.subtitle),
              const SizedBox(height: KaliSpacing.md),
              ...memory.categories.map((cat) => ListTile(
                    leading: Icon(_categoryIcon(cat), color: KaliColors.accentPrimary),
                    title: Text(cat, style: KaliTextStyles.body),
                    trailing: Text(
                      '${memory.getMemoriesByCategory(cat).length}',
                      style: KaliTextStyles.caption,
                    ),
                  )),
              const SizedBox(height: KaliSpacing.lg),

              // Danger Zone
              Text('Daten', style: KaliTextStyles.subtitle),
              const SizedBox(height: KaliSpacing.md),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: KaliColors.accentDanger),
                title: const Text('Alle Memories löschen',
                    style: TextStyle(color: KaliColors.accentDanger)),
                onTap: () => _showDeleteConfirmation(context, memory),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    bool isWarning = false,
  }) {
    return SwitchListTile(
      secondary: Icon(
        icon,
        color: isWarning && value
            ? KaliColors.accentWarning
            : KaliColors.accentPrimary,
      ),
      title: Text(title, style: KaliTextStyles.body),
      subtitle: Text(subtitle, style: KaliTextStyles.caption),
      value: value,
      onChanged: onChanged,
      activeColor: KaliColors.accentPrimary,
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'preference':
        return Icons.favorite;
      case 'personal':
        return Icons.person;
      case 'work':
        return Icons.work;
      case 'location':
        return Icons.location_on;
      case 'language':
        return Icons.language;
      case 'technical':
        return Icons.code;
      case 'goal':
        return Icons.flag;
      default:
        return Icons.info;
    }
  }

  void _showDeleteConfirmation(BuildContext context, MemoryProvider memory) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: KaliColors.bgSecondary,
        title: const Text('Alle Memories löschen?',
            style: TextStyle(color: KaliColors.textPrimary)),
        content: const Text(
          'Diese Aktion kann nicht rückgängig gemacht werden.',
          style: TextStyle(color: KaliColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              memory.clearAllMemories();
              Navigator.pop(ctx);
            },
            child: const Text('Löschen',
                style: TextStyle(color: KaliColors.accentDanger)),
          ),
        ],
      ),
    );
  }
}
