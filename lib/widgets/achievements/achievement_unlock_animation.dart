import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../generated/app_localizations.dart';
import '../../models/achievement.dart';
import '../../utils/constants.dart';

class AchievementUnlockAnimation extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback onComplete;

  const AchievementUnlockAnimation({
    super.key,
    required this.achievement,
    required this.onComplete,
  });

  @override
  State<AchievementUnlockAnimation> createState() =>
      _AchievementUnlockAnimationState();
}

class _AchievementUnlockAnimationState extends State<AchievementUnlockAnimation>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late AnimationController _rotationController;
  late ConfettiController _confettiController;

  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    // 애니메이션 정의
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.bounceOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: const Interval(0.3, 1.0),
      ),
    );

    // 애니메이션 시작
    _startAnimation();
  }

  void _startAnimation() async {
    // 컨페티 시작
    _confettiController.play();

    // 순차적 애니메이션 실행
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();

    await Future<void>.delayed(const Duration(milliseconds: 300));
    _slideController.forward();

    await Future<void>.delayed(const Duration(milliseconds: 200));
    _rotationController.forward();

    // 3초 후 자동 닫기
    await Future<void>.delayed(const Duration(seconds: 3));
    widget.onComplete();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    _rotationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Color _getRarityColor() {
    switch (widget.achievement.rarity) {
      case AchievementRarity.common:
        return Colors.grey;
      case AchievementRarity.rare:
        return Colors.blue;
      case AchievementRarity.epic:
        return Colors.purple;
      case AchievementRarity.legendary:
        return const Color(AppColors.primaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Stack(
        children: [
          // 배경 터치로 닫기
          GestureDetector(
            onTap: widget.onComplete,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),

          // 컨페티 효과
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 1.57, // 아래쪽으로
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.05,
              shouldLoop: false,
              colors: [
                _getRarityColor(),
                const Color(AppColors.primaryColor),
                const Color(AppColors.successColor),
                Colors.white,
              ],
            ),
          ),

          // 메인 애니메이션 컨테이너
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _scaleController,
                _slideController,
                _rotationController,
              ]),
              builder: (context, child) {
                return SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        margin: const EdgeInsets.all(AppConstants.paddingL),
                        padding: const EdgeInsets.all(AppConstants.paddingXL),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusL,
                          ),
                          border: Border.all(
                            color: _getRarityColor(),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _getRarityColor().withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Achievement Unlocked text
                            Text(
                              '🏆 Achievement Unlocked! 🏆',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: _getRarityColor(),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),

                            const SizedBox(height: AppConstants.paddingM),

                            // 업적 아이콘 (회전 애니메이션)
                            RotationTransition(
                              turns: _rotationAnimation,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: _getRarityColor(),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getRarityColor()
                                          .withValues(alpha: 0.5),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.emoji_events,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: AppConstants.paddingL),

                            // 업적 제목
                            Text(
                              widget.achievement.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: AppConstants.paddingS),

                            // 업적 설명
                            Text(
                              widget.achievement.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: AppConstants.paddingM),

                            // 희귀도 표시
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingM,
                                vertical: AppConstants.paddingS,
                              ),
                              decoration: BoxDecoration(
                                color: _getRarityColor().withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(
                                  AppConstants.radiusS,
                                ),
                                border: Border.all(
                                  color: _getRarityColor(),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                widget.achievement.rarity.name.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: _getRarityColor(),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),

                            const SizedBox(height: AppConstants.paddingL),

                            // 닫기 버튼
                            ElevatedButton(
                              onPressed: widget.onComplete,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _getRarityColor(),
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                AppLocalizations.of(context).confirm,
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
