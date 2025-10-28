import 'package:flutter/material.dart';
import '../achievement.dart';
import '../achievement_type.dart';

/// 프로그램 완료 업적들 (2개)
///
/// 전체 프로그램 완주 관련 업적
class ProgramAchievements {
  static List<Achievement> get all => [
        // 42세션 달성
        Achievement(
          id: 'sessions_42',
          titleKey: '42세션 달성',
          descriptionKey: '42회의 운동 세션을 완료했습니다',
          motivationKey: '42세션! 전체 프로그램을 완주했다! 🎉',
          type: AchievementType.volume,
          rarity: AchievementRarity.legendary,
          targetValue: 42,
          xpReward: 1000,
          icon: Icons.fact_check,
        ),

        // 프로그램 완료
        Achievement(
          id: 'program_complete',
          titleKey: '프로그램 완료',
          descriptionKey: '14주 Mission100 프로그램을 완료했습니다',
          motivationKey: '14주 여정 완주! 당신은 진정한 CHAD! 축하합니다! 🏆',
          type: AchievementType.special,
          rarity: AchievementRarity.legendary,
          targetValue: 1,
          xpReward: 5000,
          icon: Icons.military_tech,
        ),
      ];

  /// 총 EXP
  static int get totalExp => 6000;

  /// 업적 개수
  static int get count => 2;
}
