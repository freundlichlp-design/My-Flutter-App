import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/chat_provider.dart';
import '../../../../../providers/settings_provider.dart';
import '../../../../../theme/kali_colors.dart';
import '../../../../../theme/kali_text_styles.dart';
import '../widgets/conversation_list_item.dart';
import '../widgets/conversation_list_skeleton.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  static const _kaliEmptyMessages = [
    'Noch da. Warte auf deine erste Frage.',
    'Stille. Entweder du denkst oder du schreibst.',
    'Nichts hier. Fang an.',
    'Die Leere antwortet schneller als du denkst.',
    'Keine Gespräche. Noch.',
  ];

  late final String _emptyMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _emptyMessage = _kaliEmptyMessages[Random().nextInt(_kaliEmptyMessages.length)];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ChatProvider>().loadConversations();
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kali Chat'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final provider = context.read<ChatProvider>();
          final settings = context.read<SettingsProvider>();
          await provider.createNewConversation(
            model: settings.selectedModel,
            apiProvider: settings.selectedProvider,
          );
          if (context.mounted) {
            context.push('/chat');
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, provider, _) {
          if (_isLoading) {
            return const ConversationListSkeleton();
          }

          if (provider.conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'KALI',
                    style: KaliTextStyles.headline.copyWith(
                      color: KaliColors.accentPrimary,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _emptyMessage,
                    style: KaliTextStyles.body.copyWith(
                      color: KaliColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.conversations.length,
            itemBuilder: (context, index) {
              final conversation = provider.conversations[index];
              return ConversationListItem(
                conversation: conversation,
                onTap: () async {
                  await provider.selectConversation(conversation.id);
                  if (context.mounted) {
                    context.push('/chat');
                  }
                },
                onDelete: () {
                  provider.deleteConversation(conversation.id);
                },
                onArchive: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Archived: ${conversation.title}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
