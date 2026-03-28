import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/conversation.dart';
import '../../../../theme/kali_colors.dart';

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
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text(
                'Delete conversation?',
                style: TextStyle(
                  color: KaliColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Text(
                '"${conversation.title}" will be permanently deleted.',
                style: const TextStyle(
                  color: KaliColors.textSecondary,
                  fontSize: 15,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: KaliColors.textSecondary),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: KaliColors.accentDanger),
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
        padding: const EdgeInsets.only(left: 24),
        color: KaliColors.accentPrimary.withValues(alpha: 0.125),
        child: const Icon(
          Icons.archive_outlined,
          color: KaliColors.accentPrimary,
          size: 28,
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: KaliColors.accentDanger.withValues(alpha: 0.125),
        child: const Icon(
          Icons.delete_outline,
          color: KaliColors.accentDanger,
          size: 28,
        ),
      ),
      movementDuration: const Duration(milliseconds: 200),
      resizeDuration: const Duration(milliseconds: 200),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  style: const TextStyle(
                    color: KaliColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversation.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: KaliColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${conversation.apiProvider} · ${conversation.model}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: KaliColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(conversation.updatedAt),
                style: const TextStyle(
                  color: KaliColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
