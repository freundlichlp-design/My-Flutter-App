import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../domain/entities/message.dart';
import '../../../../theme/kali_colors.dart';
import '../../../../theme/kali_radius.dart';
import '../../../../theme/kali_spacing.dart';
import '../../../../theme/kali_text_styles.dart';
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
    final hasImage = message.hasImage;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: KaliSpacing.xxs),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (hasImage) _ImageAttachment(imagePath: message.imagePath!, isUser: isUser),
          if (message.content.isNotEmpty)
            Align(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.85,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: KaliSpacing.md,
                  horizontal: KaliSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: isUser ? KaliColors.bubbleUser : KaliColors.bubbleAi,
                  borderRadius: isUser ? KaliRadius.bubbleUser : KaliRadius.bubbleAi,
                  border: isUser ? null : Border.all(
                    color: KaliColors.bubbleAiBorder,
                    width: 1,
                  ),
                ),
                child: isUser
                    ? Text(
                        message.content,
                        style: KaliTextStyles.body.copyWith(
                          color: KaliColors.bubbleUserText,
                        ),
                      )
                    : _FormattedMessage(content: message.content),
              ),
            ),
          // Metadata for AI messages
          if (!isUser && (model != null || tokenCount != null))
            Padding(
              padding: const EdgeInsets.only(
                top: KaliSpacing.xs,
                left: KaliSpacing.xs,
                right: KaliSpacing.xs,
              ),
              child: Text(
                _buildMetadata(),
                style: KaliTextStyles.caption,
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
            p: KaliTextStyles.body.copyWith(color: KaliColors.bubbleAiText),
            h1: KaliTextStyles.subtitle,
            h2: KaliTextStyles.subtitle.copyWith(fontSize: 17),
            h3: KaliTextStyles.subtitle.copyWith(fontSize: 16),
            strong: KaliTextStyles.bodyBold,
            code: KaliTextStyles.code,
            codeblockDecoration: BoxDecoration(
              color: KaliColors.bgPrimary,
              borderRadius: KaliRadius.codeBlock,
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

class _ImageAttachment extends StatelessWidget {
  final String imagePath;
  final bool isUser;

  const _ImageAttachment({required this.imagePath, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: KaliSpacing.xs),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
            maxHeight: 300,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(KaliRadius.lg),
            border: isUser
                ? null
                : Border.all(color: KaliColors.bubbleAiBorder, width: 1),
          ),
          clipBehavior: Clip.antiAlias,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(KaliRadius.lg),
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 200,
                height: 150,
                color: KaliColors.bgTertiary,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, color: KaliColors.textMuted, size: 48),
                    SizedBox(height: 8),
                    Text('Bild konnte nicht geladen werden',
                        style: TextStyle(color: KaliColors.textMuted, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
