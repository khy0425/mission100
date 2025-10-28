import 'package:flutter/material.dart';
import '../models/rpe_data.dart';

/// RPE 기반 회복 상태 표시 카드
class RPERecoveryCard extends StatelessWidget {
  final RecoveryStatus recoveryStatus;
  final VoidCallback? onTap;

  const RPERecoveryCard({
    super.key,
    required this.recoveryStatus,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _getStatusColor(recoveryStatus.level);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: isDark ? 0.15 : 0.1),
                color.withValues(alpha: isDark ? 0.05 : 0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getStatusIcon(recoveryStatus.level),
                      color: color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '회복 상태',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey : Colors.grey.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _getStatusLabel(recoveryStatus.level),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircularPercentIndicator(
                    score: recoveryStatus.score,
                    color: color,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black12 : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recoveryStatus.recommendation,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey.withValues(alpha: 0.1) : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (recoveryStatus.suggestedRestDays > 0) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.hotel,
                        color: Colors.orange,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '권장 휴식: ${recoveryStatus.suggestedRestDays}일',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
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
    );
  }

  Color _getStatusColor(RecoveryLevel level) {
    switch (level) {
      case RecoveryLevel.excellent:
        return Colors.green;
      case RecoveryLevel.good:
        return Colors.lightGreen;
      case RecoveryLevel.fair:
        return Colors.orange;
      case RecoveryLevel.poor:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(RecoveryLevel level) {
    switch (level) {
      case RecoveryLevel.excellent:
        return Icons.sentiment_very_satisfied;
      case RecoveryLevel.good:
        return Icons.sentiment_satisfied;
      case RecoveryLevel.fair:
        return Icons.sentiment_neutral;
      case RecoveryLevel.poor:
        return Icons.sentiment_dissatisfied;
    }
  }

  String _getStatusLabel(RecoveryLevel level) {
    switch (level) {
      case RecoveryLevel.excellent:
        return '최상';
      case RecoveryLevel.good:
        return '양호';
      case RecoveryLevel.fair:
        return '보통';
      case RecoveryLevel.poor:
        return '주의';
    }
  }
}

/// 원형 퍼센트 인디케이터
class CircularPercentIndicator extends StatelessWidget {
  final int score;
  final Color color;
  final double size;

  const CircularPercentIndicator({
    super.key,
    required this.score,
    required this.color,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 4,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          Center(
            child: Text(
              '$score',
              style: TextStyle(
                fontSize: size * 0.3,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
