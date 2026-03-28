import 'package:flutter/material.dart';

import '../../../../theme/kali_colors.dart';
import '../../../../theme/kali_radius.dart';
import '../../../../theme/kali_spacing.dart';
import '../../../../theme/kali_text_styles.dart';

class MessageInput extends StatefulWidget {
  final ValueChanged<String> onSend;
  final bool enabled;

  const MessageInput({
    super.key,
    required this.onSend,
    this.enabled = true,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && widget.enabled) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: KaliSpacing.paddingSM,
        decoration: const BoxDecoration(
          color: KaliColors.bgTertiary,
          border: Border(
            top: BorderSide(color: KaliColors.borderColor, width: 1),
          ),
        ),
        child: Row(
          children: [
            // Input Field
            Expanded(
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 48,
                  maxHeight: 120,
                ),
                decoration: BoxDecoration(
                  color: KaliColors.bgTertiary,
                  borderRadius: KaliRadius.inputField,
                  border: Border.all(
                    color: _isFocused
                        ? KaliColors.accentPrimary
                        : KaliColors.borderColor,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                  style: KaliTextStyles.body.copyWith(color: KaliColors.textInverse),
                  decoration: InputDecoration(
                    hintText: 'Schreibe eine Nachricht...',
                    hintStyle: KaliTextStyles.muted,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: KaliSpacing.md,
                      vertical: KaliSpacing.md,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: KaliSpacing.sm),
            // Send Button - Circle, 40px, accentPrimary bg
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.enabled
                    ? KaliColors.accentPrimary
                    : KaliColors.borderColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: widget.enabled ? _handleSend : null,
                icon: const Icon(
                  Icons.send,
                  color: KaliColors.textInverse,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
