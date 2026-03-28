import 'package:flutter/material.dart';

import '../../../../theme/kali_colors.dart';
import '../../../../theme/kali_radius.dart';
import '../../../../theme/kali_spacing.dart';
import '../../../../theme/kali_durations.dart';
import '../../../../theme/kali_text_styles.dart';

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
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    // Blinking cursor animation
    _cursorController = AnimationController(
      vsync: this,
      duration: KaliDurations.cursor,
    )..repeat(reverse: true);
    // Neon pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cursorController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: KaliSpacing.xxs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Bubble with streaming cursor
          Align(
            alignment: Alignment.centerLeft,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: KaliSpacing.md,
                    horizontal: KaliSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: KaliColors.bgTertiary,
                    borderRadius: KaliRadius.bubbleAi,
                    border: Border.all(
                      color: KaliColors.accentPrimary.withValues(
                        alpha: 0.3 + _pulseController.value * 0.5,
                      ),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: KaliColors.accentPrimary.withValues(
                          alpha: 0.08 + _pulseController.value * 0.15,
                        ),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Blinking cursor █
                  AnimatedBuilder(
                    animation: _cursorController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _cursorController.value,
                        child: Text(
                          '█',
                          style: KaliTextStyles.body.copyWith(
                            color: KaliColors.accentPrimary,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Neon Pulse Bar
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) {
              return Container(
                margin: const EdgeInsets.only(
                  top: KaliSpacing.xs,
                  left: KaliSpacing.xs,
                ),
                height: 3,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(KaliRadius.sm),
                  color: KaliColors.accentPrimary.withValues(
                    alpha: 0.3 + _pulseController.value * 0.7,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: KaliColors.accentPrimary.withValues(
                        alpha: 0.2 + _pulseController.value * 0.4,
                      ),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              );
            },
          ),
          // Stream Status Bar
          Container(
            margin: const EdgeInsets.only(
              top: KaliSpacing.xs,
              left: KaliSpacing.xs,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: KaliSpacing.sm,
              vertical: KaliSpacing.xs,
            ),
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
                SizedBox(width: KaliSpacing.sm),
                Text(
                  'Streaming',
                  style: KaliTextStyles.caption,
                ),
                if (widget.tokenCount != null) ...[
                  Text(
                    ' · ',
                    style: KaliTextStyles.caption,
                  ),
                  Text(
                    '${widget.tokenCount} tokens',
                    style: KaliTextStyles.caption,
                  ),
                ],
                if (widget.elapsedTime != null) ...[
                  Text(
                    ' · ',
                    style: KaliTextStyles.caption,
                  ),
                  Text(
                    '${widget.elapsedTime!.inMilliseconds / 1000.0}s',
                    style: KaliTextStyles.caption,
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

/// Pulsing dot animation
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
      duration: KaliDurations.pulsing,
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
          width: KaliSpacing.sm,
          height: KaliSpacing.sm,
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
