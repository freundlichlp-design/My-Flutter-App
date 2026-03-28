import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github-dark.dart';

import '../../../../theme/kali_colors.dart';
import '../../../../theme/kali_radius.dart';
import '../../../../theme/kali_spacing.dart';
import '../../../../theme/kali_text_styles.dart';

class CodeBlock extends StatelessWidget {
  final String code;
  final String? language;

  const CodeBlock({
    super.key,
    required this.code,
    this.language,
  });

  @override
  Widget build(BuildContext context) {
    final lang = language ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: KaliSpacing.sm),
      decoration: BoxDecoration(
        color: KaliColors.bgPrimary,
        borderRadius: KaliRadius.codeBlock,
        border: Border.all(
          color: KaliColors.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with language label and copy button
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: KaliSpacing.md,
              vertical: KaliSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: KaliColors.bgSecondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(KaliRadius.md),
                topRight: Radius.circular(KaliRadius.md),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lang.isNotEmpty ? lang : 'code',
                  style: KaliTextStyles.caption.copyWith(fontFamily: 'monospace'),
                ),
                InkWell(
                  onTap: () => _copyToClipboard(context),
                  borderRadius: BorderRadius.circular(KaliRadius.sm),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: KaliSpacing.xs,
                      vertical: KaliSpacing.xxs,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.copy,
                          size: 14,
                          color: KaliColors.textSecondary,
                        ),
                        SizedBox(width: KaliSpacing.xs),
                        Text(
                          'Copy',
                          style: KaliTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Code content with horizontal scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 64,
              ),
              child: HighlightView(
                code,
                language: lang.isNotEmpty ? lang : null,
                theme: githubDarkTheme,
                padding: const EdgeInsets.all(KaliSpacing.md),
                textStyle: KaliTextStyles.code.copyWith(backgroundColor: Colors.transparent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code kopiert'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
