import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/user_subscription.dart';

/// VIP 환영 다이얼로그
///
/// 로그인 시 사용자를 환영하는 애니메이션 다이얼로그
/// 구독 타입별로 다른 메시지와 스타일을 표시합니다.
class VIPWelcomeDialog extends StatefulWidget {
  final String userName;
  final UserSubscription subscription;

  const VIPWelcomeDialog({
    super.key,
    required this.userName,
    required this.subscription,
  });

  @override
  State<VIPWelcomeDialog> createState() => _VIPWelcomeDialogState();
}

class _VIPWelcomeDialogState extends State<VIPWelcomeDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 설정
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // 애니메이션 시작
    _controller.forward();

    // 3초 후 자동 닫기
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = widget.subscription.type == SubscriptionType.premium;
    final isLaunchPromo =
        widget.subscription.type == SubscriptionType.launchPromo;

    // 구독 타입별 색상
    final gradientColors = _getGradientColors(widget.subscription.type);
    final icon = _getIcon(widget.subscription.type);
    final title = _getTitle(widget.subscription.type);
    final subtitle = _getSubtitle(widget.subscription, context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 아이콘
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 48,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                // 환영 메시지
                Text(
                  AppLocalizations.of(context).welcome,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                // 사용자 이름
                Text(
                  widget.userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 16),

                // 타이틀 (구독 타입)
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withValues(alpha: 0.95),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // 서브타이틀 (남은 일수 등)
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                    textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 20),

                // 프리미엄/프로모션 전용 혜택 표시
                if (isPremium || isLaunchPromo) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.flash_on,
                          size: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'VIP 10배 빠른 로딩',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withValues(alpha: 0.95),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 구독 타입별 그라디언트 색상
  List<Color> _getGradientColors(SubscriptionType type) {
    switch (type) {
      case SubscriptionType.premium:
        return [
          const Color(0xFFFFD700), // 골드
          const Color(0xFFFFA500), // 오렌지
        ];
      case SubscriptionType.launchPromo:
        return [
          const Color(0xFF9C27B0), // 퍼플
          const Color(0xFFE91E63), // 핑크
        ];
      case SubscriptionType.free:
        return [
          const Color(0xFF2196F3), // 블루
          const Color(0xFF03A9F4), // 라이트블루
        ];
    }
  }

  /// 구독 타입별 아이콘
  IconData _getIcon(SubscriptionType type) {
    switch (type) {
      case SubscriptionType.premium:
        return Icons.stars; // 프리미엄
      case SubscriptionType.launchPromo:
        return Icons.celebration; // 런칭 프로모션
      case SubscriptionType.free:
        return Icons.waving_hand; // 무료
    }
  }

  /// 구독 타입별 타이틀
  String _getTitle(SubscriptionType type) {
    switch (type) {
      case SubscriptionType.premium:
        return '✨ 프리미엄 회원';
      case SubscriptionType.launchPromo:
        return '🎉 런칭 프로모션';
      case SubscriptionType.free:
        return '👋 무료 회원';
    }
  }

  /// 구독 타입별 서브타이틀
  String? _getSubtitle(UserSubscription subscription, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final days = subscription.remainingDays;

    switch (subscription.type) {
      case SubscriptionType.premium:
        if (days != null && days > 0) {
          return l10n.freeTrialDaysRemaining(days);
        } else if (days == null) {
          return '💎 VIP (평생)';
        }
        return null;

      case SubscriptionType.launchPromo:
        if (days != null && days > 0) {
          return l10n.freeTrialDaysRemaining(days);
        }
        return null;

      case SubscriptionType.free:
        return l10n.allWorkoutProgramsAvailable;
    }
  }
}
