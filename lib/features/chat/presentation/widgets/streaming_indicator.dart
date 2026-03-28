import 'package:flutter/material.dart';

import '../../../../theme/kali_colors.dart';

class StreamingIndicator extends StatefulWidget {
  final int? tokenCount;
  final Duration? elapsedTime;

  const StreamingIndicator({
    super.key,
    this.tokenCount,
    this.elapsedTime,
  });

  @override
  State<StreamingIndicator> createState() => _StreamingIndicatorState();
}

class _StreamingIndicatorState extends State<StreamingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    // Blinking cursor animation - 500ms as per STYLE_GUIDE
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Bubble with streaming cursor
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: KaliColors.bgTertiary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4),
                ),
                border: Border.all(
                  color: KaliColors.borderColor,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Blinking cursor █ (Option A from STYLE_GUIDE)
                  AnimatedBuilder(
                    animation: _cursorController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _cursorController.value,
                        child: const Text(
                          '█',
                          style: TextStyle(
                            color: KaliColors.accentPrimary,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Stream Status Bar (as per STYLE_GUIDE section 5)
          Container(
            margin: const EdgeInsets.only(top: 4, left: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: const BoxDecoration(
              color: KaliColors.bgTertiary,
              border: Border(
                top: BorderSide(color: KaliColors.borderColor, width: 1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pulsing dot
                _PulsingDot(),
                const SizedBox(width: 6),
                const Text(
                  'Streaming',
                  style: TextStyle(
                    color: KaliColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                if (widget.tokenCount != null) ...[
                  const Text(
                    ' · ',
                    style: TextStyle(color: KaliColors.textSecondary),
                  ),
                  Text(
                    '${widget.tokenCount} tokens',
                    style: const TextStyle(
                      color: KaliColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
                if (widget.elapsedTime != null) ...[
                  const Text(
                    ' · ',
                    style: TextStyle(color: KaliColors.textSecondary),
                  ),
                  Text(
                    '${widget.elapsedTime!.inMilliseconds / 1000.0}s',
                    style: const TextStyle(
                      color: KaliColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Pulsing dot animation - 800ms loop as per STYLE_GUIDE
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: KaliColors.accentSuccess.withValues(
              alpha: 0.5 + _controller.value * 0.5,
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
