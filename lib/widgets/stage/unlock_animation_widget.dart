import 'package:flutter/material.dart';

/// 해금 애니메이션 위젯
///
/// 기능이 해금될 때 표시되는 부드러운 페이드 애니메이션
class UnlockAnimationWidget extends StatefulWidget {
  final Widget child;
  final bool showAnimation;
  final Duration duration;
  final VoidCallback? onAnimationComplete;

  const UnlockAnimationWidget({
    super.key,
    required this.child,
    this.showAnimation = false,
    this.duration = const Duration(milliseconds: 500),
    this.onAnimationComplete,
  });

  @override
  State<UnlockAnimationWidget> createState() => _UnlockAnimationWidgetState();
}

class _UnlockAnimationWidgetState extends State<UnlockAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });

    if (widget.showAnimation) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(UnlockAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showAnimation && !oldWidget.showAnimation) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showAnimation) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// 잠금 해제 트랜지션 위젯
///
/// 잠금 상태에서 해금 상태로 자연스럽게 전환
class UnlockTransition extends StatelessWidget {
  final Widget lockedChild;
  final Widget unlockedChild;
  final bool isUnlocked;
  final Duration duration;

  const UnlockTransition({
    super.key,
    required this.lockedChild,
    required this.unlockedChild,
    required this.isUnlocked,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: isUnlocked ? unlockedChild : lockedChild,
    );
  }
}

/// 간단한 해금 배너 위젯 (SnackBar 스타일)
class UnlockBanner extends StatelessWidget {
  final String featureName;
  final String emoji;
  final Color? backgroundColor;

  const UnlockBanner({
    super.key,
    required this.featureName,
    required this.emoji,
    this.backgroundColor,
  });

  /// SnackBar로 표시
  static void show(
    BuildContext context, {
    required String featureName,
    required String emoji,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '새 기능 해금',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  Text(
                    featureName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor ?? Colors.teal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.teal,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '새 기능 해금',
                style: TextStyle(fontSize: 11, color: Colors.white70),
              ),
              Text(
                featureName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
