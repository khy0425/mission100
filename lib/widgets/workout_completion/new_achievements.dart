import 'package:flutter/material.dart';
import '../../models/achievement.dart';

/// 새로운 업적 위젯
class NewAchievements extends StatelessWidget {
  final List<Achievement> newlyUnlockedAchievements;
  final VoidCallback? onViewAll;

  const NewAchievements({
    super.key,
    required this.newlyUnlockedAchievements,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (newlyUnlockedAchievements.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber, width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '🏆 새로운 업적 달성! 🏆',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...(newlyUnlockedAchievements.take(2).map(
                (achievement) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '🌟 ${achievement.titleKey}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )),
          if (newlyUnlockedAchievements.length > 2) ...[
            Text(
              '외 ${newlyUnlockedAchievements.length - 2}개 더!',
              style: TextStyle(
                fontSize: 10,
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: onViewAll,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '✨ 모든 업적 보기',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
