import 'achievement.dart';
import 'categories/first_achievements.dart';
import 'categories/streak_achievements.dart';
import 'categories/volume_achievements.dart';
import 'categories/perfect_achievements.dart';
import 'categories/special_achievements.dart';
import 'categories/challenge_achievements.dart';
import 'categories/statistics_achievements.dart';
import 'categories/evolution_achievements.dart';
import 'categories/week_achievements.dart';
import 'categories/program_achievements.dart';

/// 미리 정의된 모든 업적들
///
/// 카테고리별로 분리된 업적들을 통합하여 제공합니다.
///
/// **총 77개 업적, 71,736 EXP**
class PredefinedAchievements {
  /// 모든 업적 리스트 (77개)
  static List<Achievement> get all => [
        ...FirstAchievements.all, // 4개
        ...StreakAchievements.all, // 6개
        ...VolumeAchievements.all, // 8개
        ...PerfectAchievements.all, // 4개
        ...SpecialAchievements.all, // 13개
        ...ChallengeAchievements.all, // 17개
        ...StatisticsAchievements.all, // 17개
        ...EvolutionAchievements.all, // 4개
        ...WeekAchievements.all, // 14개
        ...ProgramAchievements.all, // 2개
      ];

  // ============================================
  // 카테고리별 접근
  // ============================================

  /// 첫 번째 달성 업적 (4개, 1,050 EXP)
  static List<Achievement> get first => FirstAchievements.all;

  /// 연속 달성 업적 (6개, 10,600 EXP)
  static List<Achievement> get streak => StreakAchievements.all;

  /// 총량 달성 업적 (8개, 10,600 EXP)
  static List<Achievement> get volume => VolumeAchievements.all;

  /// 완벽 수행 업적 (4개, 2,600 EXP)
  static List<Achievement> get perfect => PerfectAchievements.all;

  /// 특별 조건 업적 (13개, 5,800 EXP)
  static List<Achievement> get special => SpecialAchievements.all;

  /// 챌린지 업적 (17개, 11,650 EXP)
  static List<Achievement> get challenge => ChallengeAchievements.all;

  /// 통계 기반 업적 (17개, 12,400 EXP)
  static List<Achievement> get statistics => StatisticsAchievements.all;

  /// 진화 마일스톤 업적 (4개, 3,750 EXP)
  static List<Achievement> get evolution => EvolutionAchievements.all;

  /// 주차 완료 업적 (14개, 3,460 EXP)
  static List<Achievement> get week => WeekAchievements.all;

  /// 프로그램 완료 업적 (2개, 6,000 EXP)
  static List<Achievement> get program => ProgramAchievements.all;

  // ============================================
  // 통계 정보
  // ============================================

  /// 총 업적 개수
  static int get totalCount => all.length;

  /// 총 EXP
  static int get totalExp =>
      FirstAchievements.totalExp +
      StreakAchievements.totalExp +
      VolumeAchievements.totalExp +
      PerfectAchievements.totalExp +
      SpecialAchievements.totalExp +
      ChallengeAchievements.totalExp +
      StatisticsAchievements.totalExp +
      EvolutionAchievements.totalExp +
      WeekAchievements.totalExp +
      ProgramAchievements.totalExp;

  /// 카테고리별 EXP
  static Map<String, int> get expByCategory => {
        '첫 번째 달성': FirstAchievements.totalExp,
        '연속 달성': StreakAchievements.totalExp,
        '총량 달성': VolumeAchievements.totalExp,
        '완벽 수행': PerfectAchievements.totalExp,
        '특별 조건': SpecialAchievements.totalExp,
        '챌린지': ChallengeAchievements.totalExp,
        '통계': StatisticsAchievements.totalExp,
        '진화': EvolutionAchievements.totalExp,
        '주차 완료': WeekAchievements.totalExp,
        '프로그램 완료': ProgramAchievements.totalExp,
      };

  /// 카테고리별 업적 개수
  static Map<String, int> get countByCategory => {
        '첫 번째 달성': FirstAchievements.count,
        '연속 달성': StreakAchievements.count,
        '총량 달성': VolumeAchievements.count,
        '완벽 수행': PerfectAchievements.count,
        '특별 조건': SpecialAchievements.count,
        '챌린지': ChallengeAchievements.count,
        '통계': StatisticsAchievements.count,
        '진화': EvolutionAchievements.count,
        '주차 완료': WeekAchievements.count,
        '프로그램 완료': ProgramAchievements.count,
      };
}
