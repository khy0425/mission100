import 'package:flutter/material.dart';
import '../achievement.dart';
import '../achievement_type.dart';

/// 진화 마일스톤 업적들 (4개)
///
/// Week 4, 8, 12, 14에서 캐릭터 진화 시 획득하는 특별 업적
class EvolutionAchievements {
  static List<Achievement> get all => [
        // Week 4 - 첫 번째 진화
        Achievement(
          id: 'evolution_week_4',
          titleKey: '첫 번째 진화',
          descriptionKey: 'Week 4를 완료하고 첫 진화를 달성했습니다',
          motivationKey: '당신은 이제 변화했다! 첫 진화 완료! 🔥',
          type: AchievementType.special,
          rarity: AchievementRarity.epic,
          targetValue: 1,
          xpReward: 500,
          icon: Icons.auto_awesome,
        ),

        // Week 8 - 2차 진화
        Achievement(
          id: 'evolution_week_8',
          titleKey: '2차 진화',
          descriptionKey: 'Week 8를 완료하고 2차 진화를 달성했습니다',
          motivationKey: '한 단계 더 강해졌다! 2차 진화 완료! 💪',
          type: AchievementType.special,
          rarity: AchievementRarity.epic,
          targetValue: 1,
          xpReward: 750,
          icon: Icons.trending_up,
        ),

        // Week 12 - 3차 진화
        Achievement(
          id: 'evolution_week_12',
          titleKey: '3차 진화',
          descriptionKey: 'Week 12를 완료하고 3차 진화를 달성했습니다',
          motivationKey: '거의 완성형! 3차 진화 완료! 🚀',
          type: AchievementType.special,
          rarity: AchievementRarity.legendary,
          targetValue: 1,
          xpReward: 1000,
          icon: Icons.star,
        ),

        // Week 14 - 최종 진화
        Achievement(
          id: 'evolution_week_14',
          titleKey: '최종 진화',
          descriptionKey: 'Week 14를 완료하고 최종 진화를 달성했습니다',
          motivationKey: '완벽한 CHAD! 최종 진화 달성! 당신은 전설이다! 👑',
          type: AchievementType.special,
          rarity: AchievementRarity.legendary,
          targetValue: 1,
          xpReward: 1500,
          icon: Icons.workspace_premium,
        ),
      ];

  /// 총 EXP
  static int get totalExp => 3750;

  /// 업적 개수
  static int get count => 4;
}
