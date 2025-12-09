import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/user_subscription.dart';

/// 프리미엄 사용자를 위한 환영 배너 위젯
class PremiumWelcomeBannerWidget extends StatelessWidget {
  final UserSubscription subscription;

  const PremiumWelcomeBannerWidget({
    super.key,
    required this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isPremium = subscription.type == SubscriptionType.premium;
    final isLaunchPromo = subscription.type == SubscriptionType.launchPromo;

    if (!isPremium && !isLaunchPromo) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isPremium
              ? [
                  const Color(0xFF7B2CBF),
                  const Color(0xFF9D4EDD),
                  const Color(0xFFC77DFF),
                ]
              : [
                  const Color(0xFFFF6B6B),
                  const Color(0xFFFFD93D),
                  const Color(0xFFFF8E53),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isPremium ? const Color(0xFF7B2CBF) : const Color(0xFFFF6B6B))
                .withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 배경 패턴 (선택적)
          Positioned.fill(
            child: CustomPaint(
              painter: _DiamondPatternPainter(),
            ),
          ),

          // 메인 컨텐츠
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 아이콘 + 타이틀
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isPremium ? Icons.workspace_premium : Icons.celebration,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isPremium
                                ? l10n.vipWelcomePremiumMember
                                : l10n.vipWelcomeLaunchPromo,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '프리미엄 혜택을 즐기세요',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 프리미엄 혜택 요약 (3개 아이콘)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBenefitBadge(
                      icon: Icons.block,
                      label: '광고\n제거',
                    ),
                    _buildBenefitBadge(
                      icon: Icons.auto_awesome,
                      label: 'Lumi\n진화',
                    ),
                    _buildBenefitBadge(
                      icon: Icons.psychology,
                      label: '무제한\nAI',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitBadge({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// 다이아몬드 패턴 배경 페인터
class _DiamondPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const spacing = 40.0;

    for (double x = -spacing; x < size.width + spacing; x += spacing) {
      for (double y = -spacing; y < size.height + spacing; y += spacing) {
        final path = Path();
        path.moveTo(x, y - 15);
        path.lineTo(x + 15, y);
        path.lineTo(x, y + 15);
        path.lineTo(x - 15, y);
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
