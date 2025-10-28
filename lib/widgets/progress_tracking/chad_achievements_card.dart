import 'package:flutter/material.dart';
import '../../generated/app_localizations.dart';
import 'achievement_card.dart';

/// Chad 업적 카드
class ChadAchievementsCard extends StatelessWidget {
  const ChadAchievementsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 업적 데이터 (임시)
    final achievements = [
      {
        'title': '첫 걸음',
        'description': '첫 번째 워크아웃 완료',
        'icon': Icons.play_arrow,
        'color': const Color(0xFF51CF66),
        'isUnlocked': true,
      },
      {
        'title': '일주일 챌린지',
        'description': '7일 연속 운동',
        'icon': Icons.calendar_view_week,
        'color': const Color(0xFF4DABF7),
        'isUnlocked': true,
      },
      {
        'title': '백 푸시업',
        'description': '한 세션에 100회 달성',
        'icon': Icons.fitness_center,
        'color': const Color(0xFFFFD43B),
        'isUnlocked': false,
      },
      {
        'title': '완벽주의자',
        'description': '한 주 100% 완료',
        'icon': Icons.star,
        'color': const Color(0xFFFF6B6B),
        'isUnlocked': false,
      },
    ];

    return Card(
      color: isDark ? const Color(0xFF1A1A1A) : theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.military_tech,
                  color: Color(0xFFFF6B6B),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).chadAchievements,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B6B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: achievements
                  .map(
                    (achievement) => AchievementCard(
                      title: achievement['title'] as String,
                      description: achievement['description'] as String,
                      icon: achievement['icon'] as IconData,
                      color: achievement['color'] as Color,
                      isUnlocked: achievement['isUnlocked'] as bool,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
