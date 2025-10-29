import 'package:flutter/material.dart';
import '../../generated/app_localizations.dart';
import '../../services/chad/chad_evolution_service.dart';

/// 레벨 섹션 빌더
class LevelSection extends StatelessWidget {
  final int currentLevel;
  final int currentLevelExp;
  final int expForNextLevel;
  final int totalExp;
  final double levelProgress;
  final int totalWorkouts;
  final int totalLevelUps;
  final ChadEvolutionService chadService;

  const LevelSection({
    super.key,
    required this.currentLevel,
    required this.currentLevelExp,
    required this.expForNextLevel,
    required this.totalExp,
    required this.levelProgress,
    required this.totalWorkouts,
    required this.totalLevelUps,
    required this.chadService,
  });

  @override
  Widget build(BuildContext context) {
    final currentChad = chadService.currentChad;
    final isMaxLevel = currentLevel >= 14;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 섹션 헤더
            Row(
              children: [
                Icon(Icons.auto_awesome, color: currentChad.themeColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).levelAndExperience,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 레벨 진행도 바
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isMaxLevel
                    ? AppLocalizations.of(context).levelProgressMax(currentLevel)
                    : AppLocalizations.of(context).levelProgressNext(currentLevel, currentLevel + 1),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: currentChad.themeColor,
                  ),
                ),
                Text(
                  isMaxLevel
                      ? 'MAX'
                      : AppLocalizations.of(context).expProgress(currentLevelExp, expForNextLevel),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: isMaxLevel ? 1.0 : levelProgress,
                minHeight: 12,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                color: currentChad.themeColor,
              ),
            ),

            const SizedBox(height: 24),

            // 통계 카드 3개
            Row(
              children: [
                Expanded(
                  child: _MiniStatCard(
                    label: AppLocalizations.of(context).totalExpEarned,
                    value: '$totalExp',
                    icon: Icons.stars,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MiniStatCard(
                    label: AppLocalizations.of(context).avgExpPerDay,
                    value: totalWorkouts > 0
                        ? (totalExp / totalWorkouts).toStringAsFixed(0)
                        : '0',
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MiniStatCard(
                    label: AppLocalizations.of(context).levelUps,
                    value: AppLocalizations.of(context).levelUpsCount(totalLevelUps),
                    icon: Icons.arrow_upward,
                    color: const Color(0xFF00BCD4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 업적 섹션 빌더
class AchievementSection extends StatelessWidget {
  final int completedAchievements;
  final int totalAchievements;
  final int achievementProgress;
  final Map<String, int> achievementsByCategory;
  final String Function(String) getCategoryName;

  const AchievementSection({
    super.key,
    required this.completedAchievements,
    required this.totalAchievements,
    required this.achievementProgress,
    required this.achievementsByCategory,
    required this.getCategoryName,
  });

  @override
  Widget build(BuildContext context) {
    final completionRate = totalAchievements > 0
        ? (completedAchievements / totalAchievements)
        : 0.0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 섹션 헤더
            Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.orange, size: 24),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).achievements,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 업적 완료율
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).achievementsCompleted(completedAchievements, totalAchievements),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                Text(
                  '$achievementProgress%',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: completionRate,
                minHeight: 12,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 24),

            // 카테고리별 업적 통계
            Text(
              AppLocalizations.of(context).categoryAchievements,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: achievementsByCategory.entries.map((entry) {
                return _AchievementCategoryChip(
                  category: entry.key,
                  count: entry.value,
                  getCategoryName: getCategoryName,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// 진행률 시각화 섹션
class ProgressVisualizationSection extends StatelessWidget {
  final double weeklyProgress;
  final int thisWeekWorkouts;
  final int weeklyGoal;
  final double monthlyProgress;
  final int thisMonthWorkouts;
  final int monthlyGoal;
  final int currentStreak;
  final int streakTarget;

  const ProgressVisualizationSection({
    super.key,
    required this.weeklyProgress,
    required this.thisWeekWorkouts,
    required this.weeklyGoal,
    required this.monthlyProgress,
    required this.thisMonthWorkouts,
    required this.monthlyGoal,
    required this.currentStreak,
    required this.streakTarget,
  });

  @override
  Widget build(BuildContext context) {
    final streakProgress = (currentStreak / streakTarget).clamp(0.0, 1.0);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).progressVisualization,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 원형 진행률 표시기들
            Row(
              children: [
                Expanded(
                  child: _CircularProgress(
                    title: AppLocalizations.of(context).weeklyGoal,
                    progress: weeklyProgress,
                    current: thisWeekWorkouts,
                    target: weeklyGoal,
                    color: const Color(0xFF00BCD4),
                    icon: Icons.calendar_view_week,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _CircularProgress(
                    title: AppLocalizations.of(context).monthlyGoal,
                    progress: monthlyProgress,
                    current: thisMonthWorkouts,
                    target: monthlyGoal,
                    color: Colors.green,
                    icon: Icons.calendar_month,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 스트릭 진행 바
            _StreakProgressBar(
              currentStreak: currentStreak,
              streakTarget: streakTarget,
              progress: streakProgress,
            ),
          ],
        ),
      ),
    );
  }
}

/// 원형 진행률 위젯 (내부 사용)
class _CircularProgress extends StatelessWidget {
  final String title;
  final double progress;
  final int current;
  final int target;
  final Color color;
  final IconData icon;

  const _CircularProgress({
    required this.title,
    required this.progress,
    required this.current,
    required this.target,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: color.withValues(alpha: 0.2),
                color: color,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(height: 4),
                Text(
                  '$current',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  '/$target',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        Text(
          '${(progress * 100).toInt()}%',
          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
      ],
    );
  }
}

/// 스트릭 진행 바 (내부 사용)
class _StreakProgressBar extends StatelessWidget {
  final int currentStreak;
  final int streakTarget;
  final double progress;

  const _StreakProgressBar({
    required this.currentStreak,
    required this.streakTarget,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context).streakProgress,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              '$currentStreak / $streakTarget ${AppLocalizations.of(context).days}',
              style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 스트릭 아이콘들 표시
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: List.generate(streakTarget, (index) {
            final isComplete = index < currentStreak;
            return Icon(
              Icons.local_fire_department,
              color: isComplete ? Colors.orange : Theme.of(context).colorScheme.surfaceContainerHighest,
              size: 24,
            );
          }),
        ),
      ],
    );
  }
}

/// 미니 통계 카드 (내부 사용)
class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// 업적 카테고리 칩 (내부 사용)
class _AchievementCategoryChip extends StatelessWidget {
  final String category;
  final int count;
  final String Function(String) getCategoryName;

  const _AchievementCategoryChip({
    required this.category,
    required this.count,
    required this.getCategoryName,
  });

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'first':
        return const Color(0xFF00BCD4);
      case 'streak':
        return Colors.orange;
      case 'volume':
        return Colors.green;
      case 'perfect':
        return Colors.purple;
      case 'special':
        return Colors.red;
      case 'challenge':
        return Colors.teal;
      case 'statistics':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'first':
        return Icons.flag;
      case 'streak':
        return Icons.local_fire_department;
      case 'volume':
        return Icons.fitness_center;
      case 'perfect':
        return Icons.star;
      case 'special':
        return Icons.emoji_events;
      case 'challenge':
        return Icons.sports_martial_arts;
      case 'statistics':
        return Icons.analytics;
      default:
        return Icons.emoji_events;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(category);
    final icon = _getCategoryIcon(category);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            getCategoryName(category),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
