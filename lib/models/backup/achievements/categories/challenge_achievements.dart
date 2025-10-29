import 'package:flutter/material.dart';
import '../achievement.dart';
import '../achievement_type.dart';

/// 챌린지 관련 업적들 (18개)
///
/// 다양한 챌린지 완료 및 마스터 업적
class ChallengeAchievements {
  static List<Achievement> get all => [
        Achievement(
          id: 'challenge_7_days',
          titleKey: 'achievementChallenge7DaysTitle',
          descriptionKey: 'achievementChallenge7DaysDesc',
          motivationKey: 'achievementChallenge7DaysMotivation',
          type: AchievementType.challenge,
          rarity: AchievementRarity.rare,
          targetValue: 1,
          xpReward: 500,
          icon: Icons.calendar_today,
        ),

        Achievement(
          id: 'challenge_50_single',
          titleKey: 'achievementChallenge50SingleTitle',
          descriptionKey: 'achievementChallenge50SingleDesc',
          motivationKey: 'achievementChallenge50SingleMotivation',
          type: AchievementType.challenge,
          rarity: AchievementRarity.epic,
          targetValue: 1,
          xpReward: 750,
          icon: Icons.fitness_center,
        ),

        Achievement(
          id: 'challenge_100_cumulative',
          titleKey: 'achievementChallenge100CumulativeTitle',
          descriptionKey: 'achievementChallenge100CumulativeDesc',
          motivationKey: 'achievementChallenge100CumulativeMotivation',
          type: AchievementType.challenge,
          rarity: AchievementRarity.rare,
          targetValue: 1,
          xpReward: 400,
          icon: Icons.trending_up,
        ),

        Achievement(
          id: 'challenge_200_cumulative',
          titleKey: 'achievementChallenge200CumulativeTitle',
          descriptionKey: 'achievementChallenge200CumulativeDesc',
          motivationKey: 'achievementChallenge200CumulativeMotivation',
          type: AchievementType.challenge,
          rarity: AchievementRarity.epic,
          targetValue: 1,
          xpReward: 800,
          icon: Icons.emoji_events,
        ),

        Achievement(
          id: 'challenge_14_days',
          titleKey: 'achievementChallenge14DaysTitle',
          descriptionKey: 'achievementChallenge14DaysDesc',
          motivationKey: 'achievementChallenge14DaysMotivation',
          type: AchievementType.challenge,
          rarity: AchievementRarity.legendary,
          targetValue: 1,
          xpReward: 1200,
          icon: Icons.military_tech,
        ),

        Achievement(
          id: 'challenge_master',
          titleKey: 'achievementChallengeMasterTitle',
          descriptionKey: 'achievementChallengeMasterDesc',
          motivationKey: 'achievementChallengeMasterMotivation',
          type: AchievementType.challenge,
          rarity: AchievementRarity.legendary,
          targetValue: 5, // 5개 챌린지 모두 완료
          xpReward: 2000,
          icon: Icons.workspace_premium,
        ),

        // 첫 번째 챌린지 완료
        Achievement(
          id: 'first_challenge_complete',
          titleKey: '챌린지 도전자',
          descriptionKey: '첫 번째 챌린지를 완료했습니다',
          motivationKey: '챌린지의 첫 걸음을 뗀 CHAD! 멋지다! 💪',
          type: AchievementType.challenge,
          rarity: AchievementRarity.common,
          targetValue: 1,
          xpReward: 100,
          icon: Icons.flag,
        ),

        // 일일 완벽 자세 챌린지 완료
        Achievement(
          id: 'daily_perfect_challenger',
          titleKey: '완벽한 하루 CHAD',
          descriptionKey: '일일 완벽 자세 챌린지를 완료했습니다',
          motivationKey: '오늘 하루 완벽했다! CHAD의 자세가 빛났다! ✨',
          type: AchievementType.challenge,
          rarity: AchievementRarity.common,
          targetValue: 1,
          xpReward: 150,
          icon: Icons.stars,
        ),

        // 스킬 챌린지 완료 (30개 또는 50개)
        Achievement(
          id: 'skill_master',
          titleKey: '스킬 마스터 CHAD',
          descriptionKey: '스킬 챌린지를 완료했습니다',
          motivationKey: '한 번에 그 개수를? 당신은 진정한 BEAST! 🔥',
          type: AchievementType.challenge,
          rarity: AchievementRarity.rare,
          targetValue: 1,
          xpReward: 300,
          icon: Icons.local_fire_department,
        ),

        // 완벽한 휴식 주기 챌린지 완료
        Achievement(
          id: 'perfect_cycle_champion',
          titleKey: '완벽한 휴식 주기 마스터',
          descriptionKey: '완벽한 휴식 주기 챌린지를 완료했습니다',
          motivationKey: '운동→휴식→운동→휴식! 완벽한 패턴! 이것이 진정한 CHAD의 라이프스타일! 🔄',
          type: AchievementType.challenge,
          rarity: AchievementRarity.epic,
          targetValue: 1,
          xpReward: 500,
          icon: Icons.refresh,
        ),

        // 주간 완벽 스케줄 완료
        Achievement(
          id: 'weekly_schedule_master',
          titleKey: '완벽한 주간 CHAD',
          descriptionKey: '주간 완벽 스케줄 챌린지를 완료했습니다',
          motivationKey: '휴식도 계획대로! 운동도 완벽하게! LEGENDARY! 👑',
          type: AchievementType.challenge,
          rarity: AchievementRarity.epic,
          targetValue: 1,
          xpReward: 500,
          icon: Icons.calendar_view_week,
        ),

        // 월요일 모티베이션 완료
        Achievement(
          id: 'monday_crusher',
          titleKey: 'Monday Crusher',
          descriptionKey: '월요일 모티베이션 챌린지를 완료했습니다',
          motivationKey: '월요병? 그게 뭔가요? CHAD는 월요일도 CRUSH! 💥',
          type: AchievementType.challenge,
          rarity: AchievementRarity.common,
          targetValue: 1,
          xpReward: 200,
          icon: Icons.wb_sunny,
        ),

        // 챌린지 연속 완료 (5개)
        Achievement(
          id: 'challenge_streak_5',
          titleKey: '챌린지 스트리커',
          descriptionKey: '5개의 챌린지를 연속으로 완료했습니다',
          motivationKey: '연속 챌린지 완료! 당신의 의지력이 무섭다! 😤',
          type: AchievementType.challenge,
          rarity: AchievementRarity.rare,
          targetValue: 5,
          xpReward: 600,
          icon: Icons.trending_up,
        ),

        // 모든 타입의 챌린지 완료
        Achievement(
          id: 'all_challenge_types',
          titleKey: '챌린지 컬렉터',
          descriptionKey: '모든 타입의 챌린지를 완료했습니다',
          motivationKey: '일일, 주간, 스킬, 스프린트, 이벤트! 다 정복한 CHAD! 🏆',
          type: AchievementType.challenge,
          rarity: AchievementRarity.epic,
          targetValue: 5, // 5가지 타입 모두 완료
          xpReward: 800,
          icon: Icons.emoji_events,
        ),

        // 챌린지 레전드 (20개 완료)
        Achievement(
          id: 'challenge_legend',
          titleKey: '챌린지 레전드',
          descriptionKey: '20개의 챌린지를 완료했습니다',
          motivationKey: '20개라고? 당신은 이미 전설이다! IMMORTAL CHAD! 👑',
          type: AchievementType.challenge,
          rarity: AchievementRarity.legendary,
          targetValue: 20,
          xpReward: 2000,
          icon: Icons.workspace_premium,
        ),

        // 동시 활성 챌린지 (3개 동시에)
        Achievement(
          id: 'multi_challenger',
          titleKey: '멀티 챌린저',
          descriptionKey: '3개의 챌린지를 동시에 진행했습니다',
          motivationKey: '동시에 3개? 당신의 멀티태스킹 능력이 무섭다! 🤹',
          type: AchievementType.challenge,
          rarity: AchievementRarity.rare,
          targetValue: 3,
          xpReward: 400,
          icon: Icons.layers,
        ),

        // 빠른 챌린지 완료 (시작 후 24시간 내)
        Achievement(
          id: 'speed_challenger',
          titleKey: '스피드 챌린저',
          descriptionKey: '챌린지를 24시간 내에 완료했습니다',
          motivationKey: '24시간 완료? 이 속도감! FLASH보다 빠르다! ⚡',
          type: AchievementType.challenge,
          rarity: AchievementRarity.rare,
          targetValue: 1,
          xpReward: 350,
          icon: Icons.flash_on,
        ),
      ];

  /// 총 EXP
  static int get totalExp => 11650;

  /// 업적 개수
  static int get count => 17;
}
