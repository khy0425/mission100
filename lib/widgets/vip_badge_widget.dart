import 'package:flutter/material.dart';
import '../generated/app_localizations.dart';
import '../models/user_subscription.dart';

/// VIP 배지 위젯
///
/// 사용자의 구독 타입을 작은 배지로 표시합니다.
/// 홈 화면, 설정 화면 등에 사용됩니다.
class VIPBadgeWidget extends StatelessWidget {
  final UserSubscription subscription;
  final VIPBadgeSize size;
  final bool showLabel;

  const VIPBadgeWidget({
    super.key,
    required this.subscription,
    this.size = VIPBadgeSize.medium,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    // 무료 사용자는 배지 표시 안 함
    if (subscription.type == SubscriptionType.free) {
      return const SizedBox.shrink();
    }

    final badgeData = _getBadgeData(subscription.type, context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.horizontalPadding,
        vertical: size.verticalPadding,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: badgeData.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size.borderRadius),
        boxShadow: [
          BoxShadow(
            color: badgeData.gradientColors[0].withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            badgeData.icon,
            size: size.iconSize,
            color: Colors.white,
          ),
          if (showLabel) ...[
            SizedBox(width: size.spacing),
            Text(
              badgeData.label,
              style: TextStyle(
                fontSize: size.fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  _BadgeData _getBadgeData(SubscriptionType type, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case SubscriptionType.premium:
        return _BadgeData(
          icon: Icons.star,
          label: l10n.premium,
          gradientColors: [
            const Color(0xFFFFD700), // 골드
            const Color(0xFFFFA500), // 오렌지
          ],
        );
      case SubscriptionType.launchPromo:
        return _BadgeData(
          icon: Icons.celebration,
          label: l10n.promotion,
          gradientColors: [
            const Color(0xFF9C27B0), // 퍼플
            const Color(0xFFE91E63), // 핑크
          ],
        );
      case SubscriptionType.free:
        return _BadgeData(
          icon: Icons.person,
          label: l10n.free,
          gradientColors: [
            const Color(0xFF2196F3),
            const Color(0xFF03A9F4),
          ],
        );
    }
  }
}

/// VIP 배지 크기
enum VIPBadgeSize {
  small(
    iconSize: 14,
    fontSize: 10,
    horizontalPadding: 6,
    verticalPadding: 3,
    borderRadius: 8,
    spacing: 3,
  ),
  medium(
    iconSize: 16,
    fontSize: 12,
    horizontalPadding: 8,
    verticalPadding: 4,
    borderRadius: 10,
    spacing: 4,
  ),
  large(
    iconSize: 20,
    fontSize: 14,
    horizontalPadding: 12,
    verticalPadding: 6,
    borderRadius: 12,
    spacing: 6,
  );

  const VIPBadgeSize({
    required this.iconSize,
    required this.fontSize,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.borderRadius,
    required this.spacing,
  });

  final double iconSize;
  final double fontSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final double spacing;
}

/// 배지 데이터
class _BadgeData {
  final IconData icon;
  final String label;
  final List<Color> gradientColors;

  _BadgeData({
    required this.icon,
    required this.label,
    required this.gradientColors,
  });
}
