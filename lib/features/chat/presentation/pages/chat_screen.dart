import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/chat_provider.dart';
import '../../../../../providers/settings_provider.dart';
import '../../../../../providers/subscription_provider.dart';
import '../../../../../theme/kali_colors.dart';
import '../../../../../theme/kali_durations.dart';
import '../../../../../theme/kali_radius.dart';
import '../../../../../theme/kali_spacing.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/message_input.dart';
import '../widgets/streaming_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: KaliDurations.normal,
          curve: KaliCurves.slideUp,
        );
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSend(
    BuildContext context,
    ChatProvider provider,
    SettingsProvider settings,
    SubscriptionProvider sub,
    String text, {
    String? imagePath,
  }) {
    if (!sub.canSendMessage) {
      context.push('/paywall');
      return;
    }
    sub.recordMessageSent();
    provider.sendMessage(
      text,
      apiKeys: settings.apiKeys,
      providerConfig: settings.providerConfig,
      personality: settings.selectedPersonality,
      imagePath: imagePath,
    );
  }

  Widget _buildUsageBar(BuildContext context, SubscriptionProvider sub) {
    final ratio = sub.messagesUsedToday / sub.dailyLimit;
    final color = sub.remainingMessages <= 2
        ? KaliColors.accentDanger
        : sub.remainingMessages <= 5
            ? KaliColors.accentWarning
            : KaliColors.accentPrimary;

    return GestureDetector(
      onTap: () => context.push('/paywall'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        color: Theme.of(context).colorScheme.surface,
        child: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(KaliRadius.sm),
                child: LinearProgressIndicator(
                  value: ratio,
                  backgroundColor: KaliColors.bgTertiary,
                  valueColor: AlwaysStoppedAnimation(color),
                  minHeight: 4,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${sub.remainingMessages} / ${sub.dailyLimit}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: 4),
            Icon(Icons.lock_open, size: 14, color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, _) {
        final messages = provider.messages;

        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

        return Scaffold(
          appBar: AppBar(
            title: Text(provider.activeConversation?.title ?? 'New Chat'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              if (provider.errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          provider.errorMessage!,
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: provider.clearError,
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Start a conversation',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        itemCount:
                            messages.length + (provider.isStreaming ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == messages.length) {
                            return const StreamingIndicator();
                          }
                          return ChatBubble(message: messages[index]);
                        },
                      ),
              ),
              Consumer2<SettingsProvider, SubscriptionProvider>(
                builder: (context, settings, sub, _) {
                  final canSend = !provider.isStreaming && sub.canSendMessage;
                  return Column(
                    children: [
                      if (!sub.isPremium)
                        _buildUsageBar(context, sub),
                      MessageInput(
                        onSend: (text) => _handleSend(
                          context, provider, settings, sub, text,
                        ),
                        onImageSelected: (imagePath) => _handleSend(
                          context, provider, settings, sub, '', imagePath: imagePath,
                        ),
                        enabled: canSend,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
