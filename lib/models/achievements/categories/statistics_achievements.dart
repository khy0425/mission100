import 'package:flutter/material.dart';
import '../achievement.dart';
import '../achievement_type.dart';

/// 통계 기반 업적들 (16개)
///
/// 완료율, 운동시간, 빈도 등 통계 달성
class StatisticsAchievements {
  static List<Achievement> get all => [
        // 평균 완료율 관련 업적
        Achievement(
          id: 'completion_rate_80',
          titleKey: 'achievementCompletionRate80Title',
          descriptionKey: 'achievementCompletionRate80Desc',
          motivationKey: 'achievementCompletionRate80Motivation',
          type: AchievementType.statistics,
          rarity: AchievementRarity.rare,
          targetValue: 80,
          xpReward: 400,
          icon: Icons.percent,
        ),

        Achievement(
          id: 'completion_rate_90',
          titleKey: 'achievementCompletionRate90Title',
          descriptionKey: 'achievementCompletionRate90Desc',
          motivationKey: 'achievementCompletionRate90Motivation',
          type: AchievementType.statistics,
          rarity: AchievementRarity.epic,
          targetValue: 90,
          xpReward: 600,
          icon: Icons.verified_user,
        ),

        Achievement(
          id: 'completion_rate_95',
          titleKey: 'achievementCompletionRate95Title',
          descriptionKey: 'achievementCompletionRate95Desc',
          motivationKey: 'achievementCompletionRate95Motivation',
          type: AchievementType.statistics,
          rarity: AchievementRarity.legendary,
          targetValue: 95,
          xpReward: 1000,
          icon: Icons.stars,
        ),

        // 총 운동 시간 관련 업적
        Achievement(
          id: 'total_workout_time_60',
          titleKey: 'achievementWorkoutTime60Title',
          descriptionKey: 'achievementWorkoutTime60Desc',
          motivationKey: 'achievementWorkoutTime60Motivation',
          type: AchievementType.statistics,
          rarity: AchievementRarity.common,
          targetValue: 60,
          xpReward: 200,
          icon: Icons.timer,
        ),

        Achievement(
          id: 'total_workout_time_300',
          titleKey: 'achievementWorkoutTime300Title',
          descriptionKey: 'achievementWorkoutTime300Desc',
          motivationKey: 'achievementWorkoutTime300Motivation',
          type: AchievementType.statistics,
          rarity: AchievementRarity.rare,
          targetValue: 300,
          xpReward: 500,
          icon: Icons.fitness_center,
        ),

        Achievement(
          id: 'total_workout_time_600',
          titleKey: '10시간 운동 헌신자',
          descriptionKey: '총 운동 시간 600분(10시간)을 달성했습니다',
          motivationKey: '운동에 대한 헌신이 놀랍습니다!',
          type: AchievementType.statistics,
          rarity: AchievementRarity.epic,
          targetValue: 600,
          xpReward: 800,
          icon: Icons.schedule,
        ),

        Achievement(
          id: 'total_workout_time_1200',
          titleKey: '20시간 운동 전설',
          descriptionKey: '총 운동 시간 1200분(20시간)을 달성했습니다',
          motivationKey: '당신은 진정한 운동 전설입니다!',
          type: AchievementType.statistics,
          rarity: AchievementRarity.legendary,
          targetValue: 1200,
          xpReward: 1500,
          icon: Icons.emoji_events,
        ),

        // 평균 운동 시간 관련 업적
        Achievement(
          id: 'avg_workout_time_5',
          titleKey: '효율적인 운동가',
          descriptionKey: '평균 운동 시간 5분 이상을 달성했습니다',
          motivationKey: '짧지만 효과적인 운동을 하고 있습니다!',
          type: AchievementType.statistics,
          rarity: AchievementRarity.common,
          targetValue: 5,
          xpReward: 150,
          icon: Icons.speed,
        ),

        Achievement(
          id: 'avg_workout_time_10',
          titleKey: '집중력 마스터',
          descriptionKey: '평균 운동 시간 10분 이상을 달성했습니다',
          motivationKey: '집중해서 운동하는 습관이 훌륭합니다!',
          type: AchievementType.statistics,
          rarity: AchievementRarity.rare,
          targetValue: 10,
          xpReward: 300,
          icon: Icons.psychology,
        ),

        Achievement(
          id: 'avg_workout_time_15',
          titleKey: '지구력 챔피언',
          descriptionKey: '평균 운동 시간 15분 이상을 달성했습니다',
          motivationKey: '탁월한 지구력을 보여주고 있습니다!',
          type: AchievementType.statistics,
          rarity: AchievementRarity.epic,
          targetValue: 15,
          xpReward: 500,
          icon: Icons.sports_score,
        ),

        // 주간 통계 관련 업적
        Achievement(
          id: 'weekly_sessions_5',
          titleKey: '주간 운동 달성자',
          descriptionKey: '주 5회 이상 운동을 달성했습니다',
          motivationKey: '규칙적인 운동 습관이 자리잡았습니다!',
          type: AchievementType.statistics,
          rarity: AchievementRarity.rare,
          targetValue: 5,
          xpReward: 400,
          icon: Icons.date_range,
        ),

        Achievement(
          id: 'weekly_sessions_7',
          titleKey: '매일 운동 챔피언',
          descriptionKey: '매일 운동을 실천했습니다',
          motivationKey: '완벽한 운동 루틴을 유지하고 있습니다!',
          type: AchievementType.statistics,
          rarity: AchievementRarity.legendary,
          targetValue: 7,
          xpReward: 1000,
          icon: Icons.today,
        ),

        // 월간 통계 관련 업적
        Achievement(
          id: 'monthly_sessions_20',
          titleKey: '월간 운동 마스터',
          descriptionKey: '한 달에 20회 이상 운동을 완료했습니다',
          motivationKey: '꾸준함의 힘을 보여주고 있습니다!',
          type: AchievementType.statistics,
          rarity: AchievementRarity.epic,
          targetValue: 20,
          xpReward: 800,
          icon: Icons.calendar_today,
        ),

        Achievement(
          id: 'monthly_pushups_1000',
          titleKey: '월간 1000개 달성',
          descriptionKey: '한 달에 1000개 이상의 푸쉬업을 완료했습니다',
          motivationKey: '놀라운 운동량을 기록했습니다!',
          type: AchievementType.statistics,
          rarity: AchievementRarity.legendary,
          targetValue: 1000,
          xpReward: 1200,
          icon: Icons.trending_up,
        ),

        // 개인 기록 관련 업적
        Achievement(
          id: 'personal_best_improvement',
          titleKey: '개인 기록 갱신자',
          descriptionKey: '개인 최고 기록을 갱신했습니다',
          motivationKey: '한계를 뛰어넘는 성장을 보여주고 있습니다!',
          type: AchievementType.statistics,
          rarity: AchievementRarity.rare,
          targetValue: 1,
          xpReward: 350,
          icon: Icons.trending_up,
        ),

        Achievement(
          id: 'consistency_score_high',
          titleKey: '일관성 마스터',
          descriptionKey: '높은 일관성 점수를 달성했습니다',
          motivationKey: '꾸준한 운동 패턴이 인상적입니다!',
          type: AchievementType.statistics,
          rarity: AchievementRarity.epic,
          targetValue: 85,
          xpReward: 600,
          icon: Icons.timeline,
        ),

        // 운동 빈도 관련 업적
        Achievement(
          id: 'workout_frequency_daily',
          titleKey: '데일리 운동 전문가',
          descriptionKey: '하루도 빠짐없이 운동을 실천했습니다',
          motivationKey: '완벽한 운동 일정을 지키고 있습니다!',
          type: AchievementType.statistics,
          rarity: AchievementRarity.legendary,
          targetValue: 30,
          xpReward: 2000,
          icon: Icons.event_available,
        ),
      ];

  /// 총 EXP
  static int get totalExp => 12400;

  /// 업적 개수
  static int get count => 17;
}
