import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../domain/entities/message.dart';
import '../../../../theme/kali_colors.dart';
import 'code_block.dart';

class ChatBubble extends StatelessWidget {
  final MessageEntity message;
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
                  : _FormattedMessage(content: message.content),
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

class _FormattedMessage extends StatelessWidget {
  final String content;

  const _FormattedMessage({required this.content});

  @override
  Widget build(BuildContext context) {
    final segments = _parseContent(content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: segments.map((segment) {
        if (segment.isCode) {
          return CodeBlock(
            code: segment.code,
            language: segment.language,
          );
        }
        return MarkdownBody(
          data: segment.text,
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
            code: const TextStyle(
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
        );
      }).toList(),
    );
  }

  List<_ContentSegment> _parseContent(String input) {
    final segments = <_ContentSegment>[];
    final regex = RegExp(r'```(\w*)\n(.*?)```', dotAll: true);
    int lastEnd = 0;

    for (final match in regex.allMatches(input)) {
      if (match.start > lastEnd) {
        final text = input.substring(lastEnd, match.start);
        if (text.trim().isNotEmpty) {
          segments.add(_ContentSegment.text(text));
        }
      }

      final lang = match.group(1)?.trim() ?? '';
      final code = match.group(2) ?? '';
      segments.add(_ContentSegment.codeBlock(code, lang.isNotEmpty ? lang : null));

      lastEnd = match.end;
    }

    if (lastEnd < input.length) {
      final text = input.substring(lastEnd);
      if (text.trim().isNotEmpty) {
        segments.add(_ContentSegment.text(text));
      }
    }

    if (segments.isEmpty) {
      segments.add(_ContentSegment.text(input));
    }

    return segments;
  }
}

class _ContentSegment {
  final String text;
  final String code;
  final String? language;
  final bool isCode;

  _ContentSegment.text(this.text)
      : code = '',
        language = null,
        isCode = false;

  _ContentSegment.codeBlock(this.code, this.language)
      : text = '',
        isCode = true;
}
