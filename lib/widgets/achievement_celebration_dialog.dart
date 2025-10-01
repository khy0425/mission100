import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../generated/app_localizations.dart';
import '../models/achievement.dart';
import '../utils/constants.dart';

class AchievementCelebrationDialog extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback? onDismiss;

  const AchievementCelebrationDialog({
    super.key,
    required this.achievement,
    this.onDismiss,
  });

  @override
  State<AchievementCelebrationDialog> createState() =>
      _AchievementCelebrationDialogState();
}

class _AchievementCelebrationDialogState
    extends State<AchievementCelebrationDialog> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _confettiController;
  late AnimationController _xpController;
  late AnimationController _pulseController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _xpScaleAnimation;
  late Animation<double> _xpFadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // 메인 애니메이션 컨트롤러
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // 컨페티 애니메이션 컨트롤러
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // XP 애니메이션 컨트롤러
    _xpController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // 펄스 애니메이션 컨트롤러
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // 애니메이션 설정
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _xpScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _xpController, curve: Curves.bounceOut));

    _xpFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _xpController, curve: Curves.easeOut));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 애니메이션 시작
    _startAnimations();
  }

  void _startAnimations() async {
    // 햅틱 피드백
    HapticFeedback.heavyImpact();

    // 메인 애니메이션 시작
    _mainController.forward();
    _confettiController.forward();

    // 펄스 애니메이션 반복
    _pulseController.repeat(reverse: true);

    // XP 애니메이션 지연 시작
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      _xpController.forward();
      HapticFeedback.mediumImpact();
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _confettiController.dispose();
    _xpController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Color _getRarityColor() {
    switch (widget.achievement.rarity) {
      case AchievementRarity.common:
        return Colors.grey[600] ?? Colors.grey;
      case AchievementRarity.rare:
        return Colors.blue[600] ?? Colors.blue;
      case AchievementRarity.epic:
        return Colors.purple[600] ?? Colors.purple;
      case AchievementRarity.legendary:
        return Colors.orange[600] ?? Colors.orange;
    }
  }

  String _getRarityText(BuildContext context) {
    switch (widget.achievement.rarity) {
      case AchievementRarity.common:
        return AppLocalizations.of(context).common;
      case AchievementRarity.rare:
        return AppLocalizations.of(context).rare;
      case AchievementRarity.epic:
        return AppLocalizations.of(context).epic;
      case AchievementRarity.legendary:
        return AppLocalizations.of(context).legendary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rarityColor = _getRarityColor();

    return Material(
      color: Colors.black54,
      child: Stack(
        children: [
          // 컨페티 배경
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, child) {
              return CustomPaint(
                painter: ConfettiPainter(_confettiController.value),
                size: Size.infinite,
              );
            },
          ),

          // 메인 다이얼로그
          Center(
            child: AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                        margin: const EdgeInsets.all(32),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: rarityColor, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: rarityColor.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 업적 달성 헤더
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: rarityColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: rarityColor.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.celebration,
                                    color: rarityColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    ).achievementUnlocked,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      color: rarityColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // 업적 아이콘 (펄스 애니메이션)
                            AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: rarityColor.withValues(alpha: 0.1),
                                      border: Border.all(
                                        color: rarityColor,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: rarityColor.withValues(
                                              alpha: 0.3),
                                          blurRadius: 15,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        widget.achievement.icon,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 20),

                            // 레어도 배지
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: rarityColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getRarityText(context),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // 업적 제목
                            Text(
                              widget.achievement.getTitle(context),
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: rarityColor,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 8),

                            // 업적 설명
                            Text(
                              widget.achievement.getDescription(context),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 24),

                            // XP 획득 애니메이션
                            AnimatedBuilder(
                              animation: _xpController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _xpScaleAnimation.value,
                                  child: Opacity(
                                    opacity: _xpFadeAnimation.value,
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(AppColors.primaryColor),
                                            const Color(
                                              AppColors.primaryColor,
                                            ).withValues(alpha: 0.7),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              AppColors.primaryColor,
                                            ).withValues(alpha: 0.3),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.stars,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '+${widget.achievement.xpReward} XP',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 24),

                            // 격려 메시지
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.achievement.getMotivation(context),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // 확인 버튼
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  widget.onDismiss?.call();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: rarityColor,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  ).feelThePowerOfChad,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 컨페티 애니메이션을 위한 커스텀 페인터
class ConfettiPainter extends CustomPainter {
  final double animationValue;
  final List<ConfettiParticle> particles;

  ConfettiPainter(this.animationValue) : particles = _generateParticles();

  static List<ConfettiParticle> _generateParticles() {
    final random = math.Random();
    return List.generate(50, (index) {
      return ConfettiParticle(
        x: random.nextDouble(),
        y: random.nextDouble() * 0.3, // 상단에서 시작
        color: _getRandomColor(random),
        size: random.nextDouble() * 8 + 4,
        rotation: random.nextDouble() * 2 * math.pi,
        speed: random.nextDouble() * 0.5 + 0.3,
      );
    });
  }

  static Color _getRandomColor(math.Random random) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      const Color(AppColors.primaryColor),
    ];
    return colors[random.nextInt(colors.length)];
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final particle in particles) {
      final x = particle.x * size.width;
      final y = particle.y * size.height +
          (animationValue * size.height * particle.speed);

      // 화면 밖으로 나간 파티클은 그리지 않음
      if (y > size.height + 20) continue;

      paint.color =
          particle.color.withValues(alpha: 1.0 - animationValue * 0.5);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotation + animationValue * 4);

      // 사각형 컨페티
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size * 0.6,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// 컨페티 파티클 클래스
class ConfettiParticle {
  final double x;
  final double y;
  final Color color;
  final double size;
  final double rotation;
  final double speed;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.rotation,
    required this.speed,
  });
}
