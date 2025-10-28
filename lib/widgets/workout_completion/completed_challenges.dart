import 'package:flutter/material.dart';

/// 완료된 챌린지 위젯
class CompletedChallenges extends StatelessWidget {
  final List<dynamic> completedChallenges;

  const CompletedChallenges({
    super.key,
    required this.completedChallenges,
  });

  @override
  Widget build(BuildContext context) {
    if (completedChallenges.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple, width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events,
                color: Colors.purple,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '🏆 챌린지 완료! 🏆',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[700],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...(completedChallenges.take(2).map(
                (challenge) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '🎯 ${challenge.title ?? challenge.titleKey}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purple[600],
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )),
          if (completedChallenges.length > 2)
            Text(
              '외 ${completedChallenges.length - 2}개 더!',
              style: TextStyle(
                fontSize: 10,
                color: Colors.purple[600],
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
