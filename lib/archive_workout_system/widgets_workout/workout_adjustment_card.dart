import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/rpe_data.dart';

/// 운동 조정 결과를 보여주는 카드 위젯
class WorkoutAdjustmentCard extends StatefulWidget {
  final WorkoutAdjustment adjustment;
  final int originalReps;
  final Duration originalRest;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final bool showAnimation;

  const WorkoutAdjustmentCard({
    super.key,
    required this.adjustment,
    required this.originalReps,
    required this.originalRest,
    this.onAccept,
    this.onDecline,
    this.showAnimation = true,
  });

  @override
  State<WorkoutAdjustmentCard> createState() => _WorkoutAdjustmentCardState();
}

class _WorkoutAdjustmentCardState extends State<WorkoutAdjustmentCard>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    if (widget.showAnimation) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _slideController.forward();
          _scaleController.forward();
        }
      });
    } else {
      _slideController.value = 1.0;
      _scaleController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  int get adjustedReps =>
      (widget.originalReps * widget.adjustment.repsMultiplier).round();

  Duration get adjustedRest => Duration(
        milliseconds: (widget.originalRest.inMilliseconds *
                widget.adjustment.restMultiplier)
            .round(),
      );

  Color get adjustmentColor {
    if (widget.adjustment.isIncrease) return Colors.orange;
    if (widget.adjustment.isDecrease) return Colors.blue;
    return Colors.green;
  }

  IconData get adjustmentIcon {
    if (widget.adjustment.isIncrease) return Icons.trending_up;
    if (widget.adjustment.isDecrease) return Icons.trending_down;
    return Icons.check_circle;
  }

  String get adjustmentTypeLabel {
    if (widget.adjustment.isIncrease) return '강도 증가';
    if (widget.adjustment.isDecrease) return '강도 감소';
    return '강도 유지';
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: adjustmentColor.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    adjustmentColor.withValues(alpha: 0.1),
                    adjustmentColor.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: adjustmentColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        adjustmentIcon,
                        color: adjustmentColor,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🤖 AI 트레이너 추천',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          adjustmentTypeLabel,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: adjustmentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: adjustmentColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 조정 내용
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 조정 이유
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.psychology,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.adjustment.reasoning,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Before & After 비교
                  Row(
                    children: [
                      // Before
                      Expanded(
                        child: _buildComparisonCard(
                          title: 'Before',
                          reps: widget.originalReps,
                          rest: widget.originalRest,
                          isOriginal: true,
                        ),
                      ),

                      // 화살표
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: adjustmentColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: adjustmentColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      // After
                      Expanded(
                        child: _buildComparisonCard(
                          title: 'After',
                          reps: adjustedReps,
                          rest: adjustedRest,
                          isOriginal: false,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 액션 버튼들
                  Row(
                    children: [
                      if (widget.onDecline != null)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              widget.onDecline!();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              '기존 유지',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      if (widget.onDecline != null && widget.onAccept != null)
                        const SizedBox(width: 12),
                      if (widget.onAccept != null)
                        Expanded(
                          flex: widget.onDecline != null ? 1 : 1,
                          child: ElevatedButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              widget.onAccept!();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: adjustmentColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              '추천 적용',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonCard({
    required String title,
    required int reps,
    required Duration rest,
    required bool isOriginal,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOriginal
            ? Colors.grey[50]
            : adjustmentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOriginal
              ? Colors.grey[200]!
              : adjustmentColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$reps개',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isOriginal ? Colors.grey[700] : adjustmentColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '휴식 ${rest.inSeconds}초',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

/// 간단한 조정 알림 위젯 (투자자 데모용)
class QuickAdjustmentAlert extends StatelessWidget {
  final WorkoutAdjustment adjustment;
  final VoidCallback? onTap;

  const QuickAdjustmentAlert({
    super.key,
    required this.adjustment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color = Colors.blue;
    IconData icon = Icons.auto_fix_high;
    String message = '';

    if (adjustment.isIncrease) {
      color = Colors.orange;
      icon = Icons.trending_up;
      message = '강도가 낮아 운동량을 증가시켰습니다';
    } else if (adjustment.isDecrease) {
      color = Colors.blue;
      icon = Icons.trending_down;
      message = '강도가 높아 운동량을 감소시켰습니다';
    } else {
      color = Colors.green;
      icon = Icons.check_circle;
      message = '적절한 강도를 유지합니다';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🤖 AI 자동 조정',
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
