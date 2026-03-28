import 'package:flutter/material.dart';

import '../../../../theme/kali_colors.dart';

class ConversationListSkeleton extends StatefulWidget {
  final int itemCount;

  const ConversationListSkeleton({
    super.key,
    this.itemCount = 5,
  });

  @override
  State<ConversationListSkeleton> createState() =>
      _ConversationListSkeletonState();
}

class _ConversationListSkeletonState extends State<ConversationListSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Column(
          children: List.generate(
            widget.itemCount,
            (_) => _SkeletonItem(animationValue: _animation.value),
          ),
        );
      },
    );
  }
}

class _SkeletonItem extends StatelessWidget {
  final double animationValue;

  const _SkeletonItem({required this.animationValue});

  @override
  Widget build(BuildContext context) {
    final shimmerColor = Color.lerp(
      KaliColors.bgSecondary,
      KaliColors.bgTertiary,
      animationValue,
    )!;

    return Container(
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: shimmerColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: shimmerColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: shimmerColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
