import 'package:flutter/material.dart';
import '../achievement.dart';
import '../achievement_type.dart';

/// 주차 완료 업적들 (14개)
///
/// 각 주차를 완료할 때마다 획득하는 업적
class WeekAchievements {
  static List<Achievement> get all => [
        // Week 1
        Achievement(
          id: 'week_1_complete',
          titleKey: 'Week 1 완료',
          descriptionKey: '첫 번째 주차를 완료했습니다',
          motivationKey: '시작이 반이다! Week 1 완료!',
          type: AchievementType.first,
          rarity: AchievementRarity.common,
          targetValue: 1,
          xpReward: 100,
          icon: Icons.looks_one,
        ),

        // Week 2
        Achievement(
          id: 'week_2_complete',
          titleKey: 'Week 2 완료',
          descriptionKey: '두 번째 주차를 완료했습니다',
          motivationKey: '꾸준함의 힘! Week 2 완료!',
          type: AchievementType.first,
          rarity: AchievementRarity.common,
          targetValue: 1,
          xpReward: 120,
          icon: Icons.looks_two,
        ),

        // Week 3
        Achievement(
          id: 'week_3_complete',
          titleKey: 'Week 3 완료',
          descriptionKey: '세 번째 주차를 완료했습니다',
          motivationKey: '습관이 되어간다! Week 3 완료!',
          type: AchievementType.first,
          rarity: AchievementRarity.common,
          targetValue: 1,
          xpReward: 140,
          icon: Icons.looks_3,
        ),

        // Week 4 (진화)
        Achievement(
          id: 'week_4_complete',
          titleKey: 'Week 4 완료 (진화)',
          descriptionKey: '네 번째 주차를 완료했습니다',
          motivationKey: '첫 진화 주차 완료! 대단해!',
          type: AchievementType.first,
          rarity: AchievementRarity.rare,
          targetValue: 1,
          xpReward: 200,
          icon: Icons.looks_4,
        ),

        // Week 5
        Achievement(
          id: 'week_5_complete',
          titleKey: 'Week 5 완료',
          descriptionKey: '다섯 번째 주차를 완료했습니다',
          motivationKey: '중간 지점 통과! Week 5 완료!',
          type: AchievementType.first,
          rarity: AchievementRarity.common,
          targetValue: 1,
          xpReward: 160,
          icon: Icons.looks_5,
        ),

        // Week 6
        Achievement(
          id: 'week_6_complete',
          titleKey: 'Week 6 완료',
          descriptionKey: '여섯 번째 주차를 완료했습니다',
          motivationKey: '절반 가까이 왔다! Week 6 완료!',
          type: AchievementType.first,
          rarity: AchievementRarity.common,
          targetValue: 1,
          xpReward: 180,
          icon: Icons.looks_6,
        ),

        // Week 7
        Achievement(
          id: 'week_7_complete',
          titleKey: 'Week 7 완료',
          descriptionKey: '일곱 번째 주차를 완료했습니다',
          motivationKey: '반환점 돌파! Week 7 완료!',
          type: AchievementType.first,
          rarity: AchievementRarity.common,
          targetValue: 1,
          xpReward: 200,
          icon: Icons.filter_7,
        ),

        // Week 8 (진화)
        Achievement(
          id: 'week_8_complete',
          titleKey: 'Week 8 완료 (진화)',
          descriptionKey: '여덟 번째 주차를 완료했습니다',
          motivationKey: '2차 진화 주차 완료! 멋져!',
          type: AchievementType.first,
          rarity: AchievementRarity.rare,
          targetValue: 1,
          xpReward: 300,
          icon: Icons.filter_8,
        ),

        // Week 9
        Achievement(
          id: 'week_9_complete',
          titleKey: 'Week 9 완료',
          descriptionKey: '아홉 번째 주차를 완료했습니다',
          motivationKey: '끝이 보인다! Week 9 완료!',
          type: AchievementType.first,
          rarity: AchievementRarity.common,
          targetValue: 1,
          xpReward: 220,
          icon: Icons.filter_9,
        ),

        // Week 10
        Achievement(
          id: 'week_10_complete',
          titleKey: 'Week 10 완료',
          descriptionKey: '열 번째 주차를 완료했습니다',
          motivationKey: '10주 돌파! Week 10 완료!',
          type: AchievementType.first,
          rarity: AchievementRarity.common,
          targetValue: 1,
          xpReward: 240,
          icon: Icons.filter_9_plus,
        ),

        // Week 11
        Achievement(
          id: 'week_11_complete',
          titleKey: 'Week 11 완료',
          descriptionKey: '열한 번째 주차를 완료했습니다',
          motivationKey: '거의 다 왔다! Week 11 완료!',
          type: AchievementType.first,
          rarity: AchievementRarity.common,
          targetValue: 1,
          xpReward: 260,
          icon: Icons.confirmation_number,
        ),

        // Week 12 (진화)
        Achievement(
          id: 'week_12_complete',
          titleKey: 'Week 12 완료 (진화)',
          descriptionKey: '열두 번째 주차를 완료했습니다',
          motivationKey: '3차 진화 주차 완료! 대단해!',
          type: AchievementType.first,
          rarity: AchievementRarity.epic,
          targetValue: 1,
          xpReward: 400,
          icon: Icons.stars,
        ),

        // Week 13
        Achievement(
          id: 'week_13_complete',
          titleKey: 'Week 13 완료',
          descriptionKey: '열세 번째 주차를 완료했습니다',
          motivationKey: '마지막이 코앞! Week 13 완료!',
          type: AchievementType.first,
          rarity: AchievementRarity.rare,
          targetValue: 1,
          xpReward: 280,
          icon: Icons.filter_vintage,
        ),

        // Week 14 (최종)
        Achievement(
          id: 'week_14_complete',
          titleKey: 'Week 14 완료 (최종)',
          descriptionKey: '열네 번째(마지막) 주차를 완료했습니다',
          motivationKey: '마지막 주차 완료! 당신은 해냈다!',
          type: AchievementType.first,
          rarity: AchievementRarity.legendary,
          targetValue: 1,
          xpReward: 500,
          icon: Icons.emoji_events,
        ),
      ];

  /// 총 EXP
  static int get totalExp => 3460;

  /// 업적 개수
  static int get count => 14;
}
