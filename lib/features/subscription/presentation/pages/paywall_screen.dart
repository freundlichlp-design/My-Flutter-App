import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../models/subscription.dart';
import '../../../../providers/subscription_provider.dart';
import '../../../../theme/kali_colors.dart';
import '../../../../theme/kali_radius.dart';
import '../../../../theme/kali_spacing.dart';
import '../../../../theme/kali_text_styles.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<SubscriptionProvider>(
        builder: (context, sub, _) {
          return SingleChildScrollView(
            padding: KaliSpacing.paddingMD,
            child: Column(
              children: [
                const SizedBox(height: KaliSpacing.xl),
                _buildHeader(sub),
                const SizedBox(height: KaliSpacing.xl),
                _buildFeaturesList(),
                const SizedBox(height: KaliSpacing.xl),
                _buildUsageCard(sub),
                const SizedBox(height: KaliSpacing.xl),
                _buildActionButtons(context, sub),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(SubscriptionProvider sub) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [KaliColors.accentPrimary, KaliColors.accentSecondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: KaliColors.accentPrimary.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            sub.isPremium ? Icons.verified : Icons.lock_open,
            size: 40,
            color: KaliColors.textInverse,
          ),
        ),
        const SizedBox(height: KaliSpacing.md),
        Text(
          sub.isPremium ? 'Premium Aktiv' : 'Kali Premium',
          style: KaliTextStyles.headline,
        ),
        const SizedBox(height: KaliSpacing.sm),
        Text(
          sub.isPremium
              ? 'Du hast vollen Zugriff auf alle Features'
              : 'Unbegrenzte Nachrichten und exklusive Features',
          style: KaliTextStyles.muted,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      _FeatureItem(
        icon: Icons.all_inclusive,
        title: 'Unbegrenzte Nachrichten',
        description: 'Kein Tageslimit — chatte so viel du willst',
      ),
      _FeatureItem(
        icon: Icons.psychology,
        title: 'Alle KI-Provider',
        description: 'OpenAI, Claude und Gemini ohne Einschränkungen',
      ),
      _FeatureItem(
        icon: Icons.mic,
        title: 'Voice Input',
        description: 'Spracheingabe für schnelle Nachrichten',
      ),
      _FeatureItem(
        icon: Icons.image,
        title: 'Bild-Analyse',
        description: 'Sende Bilder an die KI zur Analyse',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: KaliColors.bgSecondary,
        borderRadius: KaliRadius.card,
        border: Border.all(color: KaliColors.borderColor),
      ),
      child: Column(
        children: features.asMap().entries.map((entry) {
          final feature = entry.value;
          final isLast = entry.key == features.length - 1;
          return Column(
            children: [
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: KaliColors.accentPrimary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(KaliRadius.md),
                  ),
                  child: Icon(
                    feature.icon,
                    color: KaliColors.accentPrimary,
                    size: 20,
                  ),
                ),
                title: Text(
                  feature.title,
                  style: KaliTextStyles.bodyBold,
                ),
                subtitle: Text(
                  feature.description,
                  style: KaliTextStyles.caption,
                ),
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  indent: 72,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUsageCard(SubscriptionProvider sub) {
    return Container(
      width: double.infinity,
      padding: KaliSpacing.paddingMD,
      decoration: BoxDecoration(
        color: KaliColors.bgSecondary,
        borderRadius: KaliRadius.card,
        border: Border.all(color: KaliColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Heutige Nutzung',
            style: KaliTextStyles.bodyBold,
          ),
          const SizedBox(height: KaliSpacing.sm),
          if (sub.isPremium)
            Row(
              children: [
                const Icon(Icons.all_inclusive, color: KaliColors.accentSuccess, size: 20),
                const SizedBox(width: KaliSpacing.sm),
                Text('Unbegrenzt', style: KaliTextStyles.body.copyWith(color: KaliColors.accentSuccess)),
              ],
            )
          else ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(KaliRadius.sm),
              child: LinearProgressIndicator(
                value: sub.messagesUsedToday / Subscription.freeDailyLimit,
                backgroundColor: KaliColors.bgTertiary,
                valueColor: AlwaysStoppedAnimation<Color>(
                  sub.remainingMessages <= 2
                      ? KaliColors.accentDanger
                      : sub.remainingMessages <= 5
                          ? KaliColors.accentWarning
                          : KaliColors.accentPrimary,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: KaliSpacing.sm),
            Text(
              '${sub.messagesUsedToday} / ${Subscription.freeDailyLimit} Nachrichten',
              style: KaliTextStyles.caption,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, SubscriptionProvider sub) {
    if (sub.isPremium) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => _showDowngradeDialog(context, sub),
          style: OutlinedButton.styleFrom(
            foregroundColor: KaliColors.accentDanger,
            side: const BorderSide(color: KaliColors.accentDanger),
            padding: const EdgeInsets.symmetric(vertical: KaliSpacing.md),
            shape: RoundedRectangleBorder(borderRadius: KaliRadius.inputField),
          ),
          child: const Text('Zurück zu Free'),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _handleUpgrade(context, sub),
            style: ElevatedButton.styleFrom(
              backgroundColor: KaliColors.accentPrimary,
              foregroundColor: KaliColors.textInverse,
              padding: const EdgeInsets.symmetric(vertical: KaliSpacing.md),
              shape: RoundedRectangleBorder(borderRadius: KaliRadius.inputField),
            ),
            child: const Text(
              'Premium freischalten',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: KaliSpacing.sm),
        Text(
          'Test-Upgrade (kein Zahlungsanbieter)',
          style: KaliTextStyles.caption,
        ),
      ],
    );
  }

  Future<void> _handleUpgrade(BuildContext context, SubscriptionProvider sub) async {
    await sub.upgradeToPremium();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Premium aktiviert!')),
      );
      context.pop();
    }
  }

  void _showDowngradeDialog(BuildContext context, SubscriptionProvider sub) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Premium deaktivieren?'),
        content: const Text(
          'Du verlierst den Zugang zu unbegrenzten Nachrichten und wirst auf das Free-Tarif (10 Nachrichten/Tag) zurückgesetzt.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await sub.downgradeToFree();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Zurück zum Free-Tarif')),
                );
                context.pop();
              }
            },
            style: TextButton.styleFrom(foregroundColor: KaliColors.accentDanger),
            child: const Text('Deaktivieren'),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
