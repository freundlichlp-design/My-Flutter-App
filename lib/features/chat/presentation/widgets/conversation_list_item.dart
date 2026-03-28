import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/conversation.dart';
import '../../../../theme/kali_colors.dart';
import '../../../../theme/kali_radius.dart';
import '../../../../theme/kali_spacing.dart';
import '../../../../theme/kali_durations.dart';
import '../../../../theme/kali_text_styles.dart';

class ConversationListItem extends StatelessWidget {
  final ConversationEntity conversation;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onArchive;

  const ConversationListItem({
    super.key,
    required this.conversation,
    required this.onTap,
    required this.onDelete,
    required this.onArchive,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(conversation.id),
      direction: DismissDirection.horizontal,
      dismissThresholds: const {
        DismissDirection.endToStart: 0.4,
        DismissDirection.startToEnd: 0.4,
      },
      confirmDismiss: (direction) async {
        HapticFeedback.mediumImpact();

        if (direction == DismissDirection.endToStart) {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: KaliColors.bgTertiary,
              shape: RoundedRectangleBorder(
                borderRadius: KaliRadius.card,
              ),
              title: Text(
                'Delete conversation?',
                style: KaliTextStyles.subtitle,
              ),
              content: Text(
                '"${conversation.title}" will be permanently deleted.',
                style: KaliTextStyles.body,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(
                    'Cancel',
                    style: KaliTextStyles.caption,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(
                    'Delete',
                    style: KaliTextStyles.caption.copyWith(color: KaliColors.accentDanger),
                  ),
                ),
              ],
            ),
          );
          if (confirmed == true) {
            onDelete();
            return true;
          }
          return false;
        } else {
          onArchive();
          return false;
        }
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: KaliSpacing.lg),
        color: KaliColors.accentPrimary.withValues(alpha: 0.125),
        child: const Icon(
          Icons.archive_outlined,
          color: KaliColors.accentPrimary,
          size: 28,
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: KaliSpacing.lg),
        color: KaliColors.accentDanger.withValues(alpha: 0.125),
        child: const Icon(
          Icons.delete_outline,
          color: KaliColors.accentDanger,
          size: 28,
        ),
      ),
      movementDuration: KaliDurations.normal,
      resizeDuration: KaliDurations.normal,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 72,
          padding: KaliSpacing.paddingScreenH,
          decoration: const BoxDecoration(
            color: KaliColors.bgSecondary,
            border: Border(
              bottom: BorderSide(color: KaliColors.borderColor, width: 1),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: KaliColors.bgTertiary,
                child: Text(
                  conversation.apiProvider[0].toUpperCase(),
                  style: KaliTextStyles.bodyBold.copyWith(fontSize: 16),
                ),
              ),
              SizedBox(width: KaliSpacing.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversation.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: KaliTextStyles.subtitle,
                    ),
                    SizedBox(height: KaliSpacing.xs),
                    Text(
                      '${conversation.apiProvider} · ${conversation.model}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: KaliTextStyles.caption,
                    ),
                  ],
                ),
              ),
              SizedBox(width: KaliSpacing.sm),
              Text(
                _formatDate(conversation.updatedAt),
                style: KaliTextStyles.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
