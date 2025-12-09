import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_subscription.dart';
import '../../utils/config/constants.dart';

/// 런칭 프로모션 환영 다이얼로그
class LaunchPromoWelcomeDialog extends StatelessWidget {
  const LaunchPromoWelcomeDialog({super.key});

  /// 다이얼로그를 표시해야 하는지 확인하고 표시
  static Future<void> showIfNeeded(
    BuildContext context,
    UserSubscription? subscription,
  ) async {
    if (subscription?.type != SubscriptionType.launchPromo) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool('launch_promo_welcome_shown') ?? false;

    if (shown) {
      return;
    }

    // 플래그 설정
    await prefs.setBool('launch_promo_welcome_shown', true);

    // 다이얼로그 표시 (약간의 딜레이 후)
    if (!context.mounted) return;

    await Future.delayed(const Duration(milliseconds: 800));

    if (!context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LaunchPromoWelcomeDialog(),
    );
  }

  /// 수동 클레임 시 표시 (플래그 설정 포함)
  static Future<void> showOnClaim(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('launch_promo_welcome_shown', true);

    if (!context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LaunchPromoWelcomeDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFD700), // Gold
              Color(0xFFFFA500), // Orange
              Color(0xFFFF6B6B), // Red-Orange
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 반짝이는 효과 (선택적)
            Positioned.fill(
              child: CustomPaint(
                painter: _SparklesPainter(),
              ),
            ),

            // 메인 컨텐츠
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 축하 아이콘
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.celebration,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 타이틀
                  const Text(
                    '🎉 출시 기념 이벤트!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  // 서브타이틀
                  const Text(
                    '2025년 12월 설치자 전용',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // 혜택 카드
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        // 14일 무료 프리미엄
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.workspace_premium,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '14일 프리미엄 무료',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    '모든 프리미엄 기능 무제한',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // 혜택 목록
                        _buildBenefit(Icons.block, '광고 완전 제거'),
                        const SizedBox(height: 8),
                        _buildBenefit(Icons.psychology, 'AI 대화 토큰 5개 지급'),
                        const SizedBox(height: 8),
                        _buildBenefit(Icons.auto_awesome, '프리미엄 캐릭터 진화'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 감사 메시지
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '앱을 다운로드해주셔서\n진심으로 감사드립니다! 🙏',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 확인 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFFF6B6B),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        '시작하기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefit(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Icon(
          Icons.check_circle,
          color: Colors.white,
          size: 20,
        ),
      ],
    );
  }
}

/// 반짝이는 효과 페인터
class _SparklesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // 랜덤 위치에 작은 원들 그리기
    final sparkles = [
      Offset(size.width * 0.1, size.height * 0.15),
      Offset(size.width * 0.85, size.height * 0.2),
      Offset(size.width * 0.15, size.height * 0.7),
      Offset(size.width * 0.9, size.height * 0.65),
      Offset(size.width * 0.5, size.height * 0.1),
      Offset(size.width * 0.7, size.height * 0.85),
    ];

    for (final sparkle in sparkles) {
      canvas.drawCircle(sparkle, 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
