import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../models/message.dart';

/// Kali Chat App Color Palette (Dark Theme)
class KaliColors {
  // Background colors
  static const Color bgPrimary = Color(0xFF0D1117);
  static const Color bgSecondary = Color(0xFF161B22);
  static const Color bgTertiary = Color(0xFF21262D);
  static const Color borderColor = Color(0xFF30363D);
  
  // Text colors
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF484F58);
  
  // Accent colors
  static const Color accentPrimary = Color(0xFF58A6FF);
  static const Color accentSuccess = Color(0xFF3FB950);
  
  // Bubble colors
  static const Color bubbleUser = Color(0xFF1F6FEB);
  static const Color bubbleUserText = Color(0xFFFFFFFF);
  static const Color bubbleAi = Color(0xFF21262D);
  static const Color bubbleAiText = Color(0xFFE6EDF3);
  static const Color bubbleAiBorder = Color(0xFF30363D);
}

class ChatBubble extends StatelessWidget {
  final Message message;
  final String? model;
  final int? tokenCount;

  const ChatBubble({
    super.key,
    required this.message,
    this.model,
    this.tokenCount,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.85,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isUser ? KaliColors.bubbleUser : KaliColors.bubbleAi,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                border: isUser ? null : Border.all(
                  color: KaliColors.bubbleAiBorder,
                  width: 1,
                ),
              ),
              child: isUser
                  ? Text(
                      message.content,
                      style: const TextStyle(
                        color: KaliColors.bubbleUserText,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    )
                  : MarkdownBody(
                      data: message.content,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                          color: KaliColors.bubbleAiText,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                        h1: const TextStyle(
                          color: KaliColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        h2: const TextStyle(
                          color: KaliColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                        h3: const TextStyle(
                          color: KaliColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        strong: const TextStyle(
                          color: KaliColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        code: TextStyle(
                          backgroundColor: KaliColors.bgPrimary,
                          fontFamily: 'monospace',
                          fontSize: 13,
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: KaliColors.bgPrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        a: const TextStyle(
                          color: KaliColors.accentPrimary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
            ),
          ),
          // Metadata for AI messages
          if (!isUser && (model != null || tokenCount != null))
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
              child: Text(
                _buildMetadata(),
                style: const TextStyle(
                  color: KaliColors.textSecondary,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _buildMetadata() {
    final parts = <String>[];
    if (model != null) parts.add(model!);
    if (tokenCount != null) parts.add('$tokenCount tokens');
    return parts.join(' · ');
  }
}
