import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/chad/chad_recovery_service.dart';
import '../../models/rpe_data.dart';
import '../../utils/config/constants.dart';

/// Chad 회복 점수 표시 위젯
///
/// 기능:
/// - Chad 분석 회복 점수 (0-100점) 표시
/// - 회복 레벨별 Chad 이미지 및 메시지
/// - 운동 강도 조정 추천
/// - 애니메이션 효과
class ChadRecoveryWidget extends StatefulWidget {
  final bool showDetails;

  const ChadRecoveryWidget({
    super.key,
    this.showDetails = true,
  });

  @override
  State<ChadRecoveryWidget> createState() => _ChadRecoveryWidgetState();
}

class _ChadRecoveryWidgetState extends State<ChadRecoveryWidget>
    with TickerProviderStateMixin {
  late AnimationController _scoreController;
  late AnimationController _pulseController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    // Chad 회복 서비스 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChadRecoveryService>(context, listen: false).initialize();
    });
  }

  void _initializeAnimations() {
    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scoreController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // 애니메이션 시작
    _scoreController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<ChadRecoveryService>(
      builder: (context, recoveryService, child) {
        return Container(
          margin: const EdgeInsets.all(AppConstants.paddingM),
          padding: const EdgeInsets.all(AppConstants.paddingL),
          decoration: BoxDecoration(
            gradient: _getGradientForLevel(recoveryService.recoveryLevel),
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            boxShadow: [
              BoxShadow(
                color: _getColorForLevel(recoveryService.recoveryLevel)
                    .withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Chad 회복 점수 헤더
              _buildRecoveryHeader(context, recoveryService),

              if (widget.showDetails) ...[
                const SizedBox(height: AppConstants.paddingL),

                // Chad 이미지 + 메시지
                _buildChadSection(context, recoveryService),

                const SizedBox(height: AppConstants.paddingM),

                // 운동 강도 추천
                _buildWorkoutRecommendation(context, recoveryService),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecoveryHeader(
      BuildContext context, ChadRecoveryService recoveryService) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chad 회복 분석',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${recoveryService.recoveryLevel.label} ${recoveryService.recoveryLevel.emoji}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),

        // 회복 점수 원형 표시
        AnimatedBuilder(
          animation: _scoreAnimation,
          builder: (context, child) {
            return ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _scoreAnimation,
                        builder: (context, child) {
                          final displayScore = (recoveryService.recoveryScore *
                                  _scoreAnimation.value)
                              .round();
                          return Text(
                            '$displayScore',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _getColorForLevel(
                                  recoveryService.recoveryLevel),
                            ),
                          );
                        },
                      ),
                      Text(
                        'SCORE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color:
                              _getColorForLevel(recoveryService.recoveryLevel),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildChadSection(
      BuildContext context, ChadRecoveryService recoveryService) {
    return Row(
      children: [
        // Chad 이미지
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              recoveryService.getChadImageForRecovery(),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(width: AppConstants.paddingM),

        // Chad 메시지
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              recoveryService.getChadRecoveryMessage(),
              style: const TextStyle(
                fontSize: 13,
                height: 1.3,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutRecommendation(
      BuildContext context, ChadRecoveryService recoveryService) {
    final adjustment = recoveryService.getWorkoutAdjustment();

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getIconForAdjustment(adjustment),
                size: 20,
                color: _getColorForLevel(recoveryService.recoveryLevel),
              ),
              const SizedBox(width: 8),
              Text(
                '오늘의 운동 추천',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _getColorForLevel(recoveryService.recoveryLevel),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            adjustment.reasoning,
            style: const TextStyle(
              fontSize: 13,
              height: 1.3,
            ),
          ),
          if (adjustment.repsMultiplier != 1.0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '강도: ${(adjustment.repsMultiplier * 100).round()}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  LinearGradient _getGradientForLevel(RecoveryLevel level) {
    switch (level) {
      case RecoveryLevel.excellent:
        return LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case RecoveryLevel.good:
        return LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case RecoveryLevel.fair:
        return LinearGradient(
          colors: [Colors.orange.shade400, Colors.orange.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case RecoveryLevel.poor:
        return LinearGradient(
          colors: [Colors.purple.shade400, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Color _getColorForLevel(RecoveryLevel level) {
    switch (level) {
      case RecoveryLevel.excellent:
        return Colors.green.shade600;
      case RecoveryLevel.good:
        return Colors.blue.shade600;
      case RecoveryLevel.fair:
        return Colors.orange.shade600;
      case RecoveryLevel.poor:
        return Colors.purple.shade600;
    }
  }

  IconData _getIconForAdjustment(WorkoutAdjustment adjustment) {
    if (adjustment.isIncrease) {
      return Icons.trending_up;
    } else if (adjustment.isDecrease) {
      return Icons.trending_down;
    } else {
      return Icons.trending_flat;
    }
  }
}
