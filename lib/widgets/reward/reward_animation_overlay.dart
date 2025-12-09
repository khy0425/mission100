import 'package:flutter/material.dart';

/// 보상 애니메이션 오버레이
///
/// 토큰/XP 획득 시 화면에 플로팅 애니메이션을 표시합니다.
/// "+100 XP" 또는 "+1 🪙" 같은 텍스트가 위로 떠오르면서 사라집니다.
class RewardAnimationOverlay extends StatefulWidget {
  final String text;
  final IconData? icon;
  final String? emoji;
  final Color color;
  final Offset startPosition;
  final VoidCallback? onComplete;

  const RewardAnimationOverlay({
    super.key,
    required this.text,
    this.icon,
    this.emoji,
    this.color = Colors.amber,
    required this.startPosition,
    this.onComplete,
  });

  @override
  State<RewardAnimationOverlay> createState() => _RewardAnimationOverlayState();
}

class _RewardAnimationOverlayState extends State<RewardAnimationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // 페이드 아웃 (마지막 30%에서)
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    // 스케일 (처음에 커졌다가 유지)
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.5, end: 1.2)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 40,
      ),
    ]).animate(_controller);

    // 위로 떠오르는 애니메이션
    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -80),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    _controller.forward();
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
        return Positioned(
          left: widget.startPosition.dx - 50,
          top: widget.startPosition.dy + _positionAnimation.value.dy,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.emoji != null)
                      Text(
                        widget.emoji!,
                        style: const TextStyle(fontSize: 18),
                      )
                    else if (widget.icon != null)
                      Icon(widget.icon, color: Colors.white, size: 18),
                    if (widget.emoji != null || widget.icon != null)
                      const SizedBox(width: 6),
                    Text(
                      widget.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 보상 애니메이션 서비스
///
/// 앱 전역에서 보상 애니메이션을 트리거할 수 있는 싱글톤 서비스
class RewardAnimationService {
  static final RewardAnimationService _instance = RewardAnimationService._internal();
  factory RewardAnimationService() => _instance;
  RewardAnimationService._internal();

  OverlayState? _overlayState;
  final List<OverlayEntry> _activeOverlays = [];

  /// 초기화 (main.dart에서 호출)
  void initialize(BuildContext context) {
    _overlayState = Overlay.of(context);
  }

  /// XP 획득 애니메이션 표시
  void showXPReward({
    required int xp,
    Offset? position,
    BuildContext? context,
  }) {
    _showReward(
      text: '+$xp XP',
      emoji: '⚡',
      color: Colors.blue,
      position: position,
      context: context,
    );
  }

  /// 토큰 획득 애니메이션 표시
  void showTokenReward({
    required int tokens,
    Offset? position,
    BuildContext? context,
  }) {
    _showReward(
      text: '+$tokens',
      emoji: '🪙',
      color: Colors.amber,
      position: position,
      context: context,
    );
  }

  /// 체크리스트 완료 보상 애니메이션 (XP + 토큰 동시)
  void showChecklistReward({
    required int xp,
    required int tokens,
    BuildContext? context,
  }) {
    final screenSize = _getScreenSize(context);
    if (screenSize == null) return;

    final centerX = screenSize.width / 2;
    final centerY = screenSize.height / 2;

    // XP 애니메이션 (왼쪽에서)
    Future.delayed(Duration.zero, () {
      showXPReward(
        xp: xp,
        position: Offset(centerX - 40, centerY),
        context: context,
      );
    });

    // 토큰 애니메이션 (오른쪽에서, 약간 딜레이)
    Future.delayed(const Duration(milliseconds: 150), () {
      showTokenReward(
        tokens: tokens,
        position: Offset(centerX + 40, centerY),
        context: context,
      );
    });
  }

  void _showReward({
    required String text,
    String? emoji,
    IconData? icon,
    required Color color,
    Offset? position,
    BuildContext? context,
  }) {
    final overlay = _overlayState ?? (context != null ? Overlay.of(context) : null);
    if (overlay == null) return;

    final screenSize = _getScreenSize(context);
    final defaultPosition = screenSize != null
        ? Offset(screenSize.width / 2, screenSize.height / 2)
        : const Offset(200, 400);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => RewardAnimationOverlay(
        text: text,
        emoji: emoji,
        icon: icon,
        color: color,
        startPosition: position ?? defaultPosition,
        onComplete: () {
          entry.remove();
          _activeOverlays.remove(entry);
        },
      ),
    );

    _activeOverlays.add(entry);
    overlay.insert(entry);
  }

  Size? _getScreenSize(BuildContext? context) {
    if (context != null) {
      return MediaQuery.of(context).size;
    }
    return null;
  }

  /// 모든 활성 애니메이션 제거
  void clearAll() {
    for (final entry in _activeOverlays) {
      entry.remove();
    }
    _activeOverlays.clear();
  }
}

/// 보상 애니메이션을 표시하는 위젯 래퍼
///
/// 자식 위젯 위에 보상 애니메이션을 오버레이로 표시합니다.
class RewardAnimationScope extends StatefulWidget {
  final Widget child;

  const RewardAnimationScope({
    super.key,
    required this.child,
  });

  /// 가장 가까운 RewardAnimationScope 상태 가져오기
  static RewardAnimationScopeState? of(BuildContext context) {
    return context.findAncestorStateOfType<RewardAnimationScopeState>();
  }

  @override
  State<RewardAnimationScope> createState() => RewardAnimationScopeState();
}

class RewardAnimationScopeState extends State<RewardAnimationScope> {
  final List<_RewardAnimationData> _animations = [];
  int _animationKey = 0;

  /// XP 획득 애니메이션 표시
  void showXPReward(int xp, {Offset? position}) {
    _addAnimation(
      text: '+$xp XP',
      emoji: '⚡',
      color: Colors.blue,
      position: position,
    );
  }

  /// 토큰 획득 애니메이션 표시
  void showTokenReward(int tokens, {Offset? position}) {
    _addAnimation(
      text: '+$tokens',
      emoji: '🪙',
      color: Colors.amber,
      position: position,
    );
  }

  /// 체크리스트 완료 보상 애니메이션 (XP + 토큰 동시)
  void showChecklistReward({
    required int xp,
    required int tokens,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height / 2 - 50;

    // XP 애니메이션
    showXPReward(xp, position: Offset(centerX - 40, centerY));

    // 토큰 애니메이션 (약간 딜레이)
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        showTokenReward(tokens, position: Offset(centerX + 40, centerY));
      }
    });
  }

  void _addAnimation({
    required String text,
    String? emoji,
    IconData? icon,
    required Color color,
    Offset? position,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final defaultPosition = Offset(screenSize.width / 2, screenSize.height / 2 - 50);

    setState(() {
      _animations.add(_RewardAnimationData(
        key: _animationKey++,
        text: text,
        emoji: emoji,
        icon: icon,
        color: color,
        position: position ?? defaultPosition,
      ));
    });
  }

  void _removeAnimation(int key) {
    setState(() {
      _animations.removeWhere((a) => a.key == key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        ..._animations.map((data) => RewardAnimationOverlay(
              key: ValueKey(data.key),
              text: data.text,
              emoji: data.emoji,
              icon: data.icon,
              color: data.color,
              startPosition: data.position,
              onComplete: () => _removeAnimation(data.key),
            )),
      ],
    );
  }
}

class _RewardAnimationData {
  final int key;
  final String text;
  final String? emoji;
  final IconData? icon;
  final Color color;
  final Offset position;

  _RewardAnimationData({
    required this.key,
    required this.text,
    this.emoji,
    this.icon,
    required this.color,
    required this.position,
  });
}
