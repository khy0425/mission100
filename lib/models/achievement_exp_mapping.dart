/// 업적과 경험치 매핑
///
/// 각 업적 달성 시 획득하는 경험치를 정의합니다.
///
/// ⚠️ 주의: 이 파일은 실제 PredefinedAchievements와 동기화되어야 합니다!
class AchievementExpMapping {
  /// 업적별 경험치 테이블
  static const Map<String, int> expRewards = {
    // ==================== 시작 & 첫 걸음 (First) ====================
    'first_workout': 100, // 첫 운동 완료
    'first_50_pushups': 150, // 50개 푸시업 달성
    'first_100_single': 500, // 한 번에 100개
    'first_level_up': 300, // 첫 레벨업

    // ==================== 연속 일수 (Streak) ====================
    'streak_3_days': 300, // 연속 3일
    'streak_7_days': 500, // 연속 7일 (1주)
    'streak_14_days': 800, // 연속 14일 (2주)
    'streak_30_days': 1500, // 연속 30일
    'streak_60_days': 2500, // 연속 60일
    'streak_100_days': 5000, // 연속 100일 (거의 불가능)

    // ==================== 진화 마일스톤 ====================
    'evolution_week_4': 500, // 첫 진화 (Week 4)
    'evolution_week_8': 750, // 2차 진화 (Week 8)
    'evolution_week_12': 1000, // 3차 진화 (Week 12)
    'evolution_week_14': 1500, // 최종 진화 (Week 14)

    // ==================== 주차 완료 ====================
    'week_1_complete': 100,
    'week_2_complete': 120,
    'week_3_complete': 140,
    'week_4_complete': 200, // 진화 주차
    'week_5_complete': 160,
    'week_6_complete': 180,
    'week_7_complete': 200,
    'week_8_complete': 300, // 진화 주차
    'week_9_complete': 220,
    'week_10_complete': 240,
    'week_11_complete': 260,
    'week_12_complete': 400, // 진화 주차
    'week_13_complete': 280,
    'week_14_complete': 500, // 최종 주차

    // ==================== 총량 달성 (Volume) ====================
    'total_50_pushups': 100, // 총 50회 달성
    'total_100_pushups': 200, // 총 100회 달성
    'total_250_pushups': 300, // 총 250회 달성
    'total_500_pushups': 500, // 총 500회 달성
    'total_1000_pushups': 1000, // 총 1000회 달성
    'total_2500_pushups': 1500, // 총 2500회 달성
    'total_5000_pushups': 2000, // 총 5000회 달성
    'total_10000_pushups': 5000, // 총 10000회 달성 (거의 불가능)

    // ==================== 완벽 수행 (Perfect) ====================
    'perfect_workout_3': 250, // 3회 완벽 수행
    'perfect_workout_5': 400, // 5회 완벽 수행
    'perfect_workout_10': 750, // 10회 완벽 수행
    'perfect_workout_20': 1200, // 20회 완벽 수행

    // ==================== 특별 조건 (Special) ====================
    'tutorial_explorer': 200, // 튜토리얼 탐험가
    'tutorial_student': 300, // 튜토리얼 학생
    'tutorial_master': 1000, // 튜토리얼 마스터
    'early_bird': 300, // 아침 운동
    'night_owl': 300, // 저녁 운동
    'weekend_warrior': 200, // 주말 전사
    'lunch_break_chad': 150, // 점심시간 운동
    'speed_demon': 500, // 속도 악마
    'endurance_king': 500, // 지구력 왕
    'comeback_kid': 400, // 컴백 키드
    'overachiever': 600, // 과다 달성자
    'double_trouble': 350, // 더블 트러블
    'consistency_master': 1000, // 일관성 마스터

    // ==================== 챌린지 완료 (Challenge) ====================
    'challenge_7_days': 500, // 7일 챌린지
    'challenge_50_single': 750, // 50개 단일 챌린지
    'challenge_100_cumulative': 400, // 100개 누적 챌린지
    'challenge_200_cumulative': 800, // 200개 누적 챌린지
    'challenge_14_days': 1200, // 14일 챌린지
    'challenge_master': 2000, // 챌린지 마스터 (5개 완료)
    'first_challenge_complete': 100, // 첫 챌린지 완료
    'daily_perfect_challenger': 150, // 일일 완벽 챌린저
    'skill_master': 300, // 스킬 마스터
    'perfect_cycle_champion': 500, // 완벽한 주기 챔피언
    'weekly_schedule_master': 500, // 주간 스케줄 마스터
    'monday_crusher': 200, // 월요일 크러셔
    'challenge_streak_5': 600, // 챌린지 연속 5개
    'all_challenge_types': 800, // 모든 챌린지 타입
    'challenge_legend': 2000, // 챌린지 전설 (20개)
    'multi_challenger': 400, // 멀티 챌린저 (3개 동시)
    'speed_challenger': 350, // 스피드 챌린저

    // ==================== 통계 기반 (Statistics) ====================
    'completion_rate_80': 400, // 완료율 80%
    'completion_rate_90': 600, // 완료율 90%
    'completion_rate_95': 1000, // 완료율 95%
    'total_workout_time_60': 200, // 총 운동시간 60분
    'total_workout_time_300': 500, // 총 운동시간 300분
    'total_workout_time_600': 800, // 총 운동시간 600분
    'total_workout_time_1200': 1500, // 총 운동시간 1200분
    'avg_workout_time_5': 150, // 평균 운동시간 5분
    'avg_workout_time_10': 300, // 평균 운동시간 10분
    'avg_workout_time_15': 500, // 평균 운동시간 15분
    'weekly_sessions_5': 400, // 주간 세션 5회
    'weekly_sessions_7': 1000, // 주간 세션 7회
    'monthly_sessions_20': 800, // 월간 세션 20회
    'monthly_pushups_1000': 1200, // 월간 푸시업 1000개
    'personal_best_improvement': 350, // 개인 기록 개선
    'consistency_score_high': 600, // 일관성 점수 높음
    'workout_frequency_daily': 2000, // 운동 빈도 매일 (30일)

    // ==================== 프로그램 완료 ====================
    'sessions_42': 1000, // 42세션 완료
    'program_complete': 5000, // 프로그램 완료
  };

  /// 업적 ID로 경험치 가져오기
  static int getExpForAchievement(String achievementId) {
    return expRewards[achievementId] ?? 0;
  }

  /// 업적 카테고리별 총 경험치
  static Map<String, int> getCategoryTotalExp() {
    return {
      '첫 번째 달성 (First)': 1050, // 4개
      '연속 달성 (Streak)': 10600, // 6개
      '총량 달성 (Volume)': 10600, // 8개
      '완벽 수행 (Perfect)': 2600, // 4개
      '특별 조건 (Special)': 5800, // 11개 + 진화 4개
      '챌린지 (Challenge)': 13050, // 18개
      '통계 (Statistics)': 12300, // 16개
      '진화 마일스톤': 3750, // 4개
      '주차 완료': 3460, // 14개
      '프로그램 완료': 6000, // sessions_42 + program_complete
    };
  }

  /// 모든 업적 완료 시 총 경험치
  static int get totalPossibleExpFromAchievements {
    return expRewards.values.fold(0, (sum, exp) => sum + exp);
  }

  /// 자동 달성 가능한 업적 EXP (운동만 하면 달성)
  static int get automaticAchievementExp {
    return 550 + // First (first_workout, first_50_pushups, first_level_up)
        3100 + // Streak (3, 7, 14, 30일)
        2100 + // Volume (50-1000회)
        500 + // Special (tutorial)
        1950 + // Statistics (시간/세션)
        3750 + // Evolution (4개 진화)
        3460 + // Week completion (14주)
        1000; // sessions_42
    // 총: 16,410 EXP
  }

  /// 노력 필요 업적 EXP (완벽 수행 필요)
  static int get effortBasedAchievementExp {
    return 500 + // First (100개 single)
        3500 + // Volume (2500, 5000회)
        2600 + // Perfect (모두)
        2000 + // Special (tutorial_master, consistency)
        6350; // Statistics (완료율, 시간 등)
    // 총: 14,950 EXP
  }

  /// 선택 업적 EXP (추가 도전)
  static int get optionalAchievementExp {
    return 3300 + // Special (early_bird 등)
        13050 + // Challenge (모두)
        4000; // Statistics (선택적)
    // 총: 20,350 EXP
  }

  /// 난이도별 업적 분류
  static Map<AchievementDifficulty, List<String>> get achievementsByDifficulty {
    return {
      AchievementDifficulty.easy: [
        'first_workout',
        'first_week',
        'first_perfect',
        'streak_3',
        'reps_100',
        'sessions_10',
        'week_1_complete',
      ],
      AchievementDifficulty.medium: [
        'streak_7',
        'streak_14',
        'evolution_1',
        'reps_500',
        'reps_1000',
        'sessions_20',
        'perfect_5',
        'perfect_10',
      ],
      AchievementDifficulty.hard: [
        'streak_21',
        'streak_30',
        'evolution_2',
        'evolution_3',
        'reps_2000',
        'reps_5000',
        'sessions_30',
        'perfect_20',
        'challenge_week',
        'challenge_month',
      ],
      AchievementDifficulty.legendary: [
        'streak_42',
        'evolution_final',
        'reps_10000',
        'sessions_42',
        'perfect_all',
        'no_skip',
        'challenge_master',
        'program_complete',
        'master_achievement',
        'level_14',
      ],
    };
  }
}

/// 업적 난이도
enum AchievementDifficulty {
  easy, // 쉬움 (50-100 EXP)
  medium, // 보통 (200-600 EXP)
  hard, // 어려움 (800-1500 EXP)
  legendary, // 전설 (2000+ EXP)
}

/// 업적 카테고리
enum AchievementCategory {
  milestone, // 마일스톤
  streak, // 연속 일수
  evolution, // 진화
  volume, // 운동량
  performance, // 수행 능력
  special, // 특별
  challenge, // 챌린지
  completion, // 완료
}

/// 업적 정보 모델
class AchievementInfo {
  final String id;
  final String name;
  final String description;
  final int expReward;
  final AchievementDifficulty difficulty;
  final AchievementCategory category;
  final String iconPath;

  const AchievementInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.expReward,
    required this.difficulty,
    required this.category,
    required this.iconPath,
  });

  /// 난이도에 따른 색상
  String get difficultyColor {
    switch (difficulty) {
      case AchievementDifficulty.easy:
        return '#4CAF50'; // 녹색
      case AchievementDifficulty.medium:
        return '#2196F3'; // 파란색
      case AchievementDifficulty.hard:
        return '#9C27B0'; // 보라색
      case AchievementDifficulty.legendary:
        return '#FFD700'; // 금색
    }
  }

  /// 난이도 텍스트
  String get difficultyText {
    switch (difficulty) {
      case AchievementDifficulty.easy:
        return '쉬움';
      case AchievementDifficulty.medium:
        return '보통';
      case AchievementDifficulty.hard:
        return '어려움';
      case AchievementDifficulty.legendary:
        return '전설';
    }
  }
}

/// 업적 상세 정보 데이터베이스
class AchievementDatabase {
  /// 모든 업적 정보
  static final List<AchievementInfo> allAchievements = [
    // 시작 & 첫 걸음
    AchievementInfo(
      id: 'first_workout',
      name: '첫 걸음',
      description: '첫 운동을 완료하세요',
      expReward: AchievementExpMapping.getExpForAchievement('first_workout'),
      difficulty: AchievementDifficulty.easy,
      category: AchievementCategory.milestone,
      iconPath: 'assets/icons/first_workout.png',
    ),
    AchievementInfo(
      id: 'first_week',
      name: '한 주의 시작',
      description: '첫 주차를 완료하세요',
      expReward: AchievementExpMapping.getExpForAchievement('first_week'),
      difficulty: AchievementDifficulty.easy,
      category: AchievementCategory.milestone,
      iconPath: 'assets/icons/first_week.png',
    ),

    // 진화
    AchievementInfo(
      id: 'evolution_1',
      name: '첫 번째 진화',
      description: 'Week 4를 완료하고 첫 진화를 달성하세요',
      expReward: AchievementExpMapping.getExpForAchievement('evolution_1'),
      difficulty: AchievementDifficulty.medium,
      category: AchievementCategory.evolution,
      iconPath: 'assets/icons/evolution_1.png',
    ),
    AchievementInfo(
      id: 'evolution_final',
      name: '최종 진화',
      description: 'Week 14를 완료하고 최종 진화를 달성하세요',
      expReward: AchievementExpMapping.getExpForAchievement('evolution_final'),
      difficulty: AchievementDifficulty.legendary,
      category: AchievementCategory.evolution,
      iconPath: 'assets/icons/evolution_final.png',
    ),

    // 연속 일수
    AchievementInfo(
      id: 'streak_7',
      name: '일주일 연속',
      description: '7일 연속으로 운동하세요',
      expReward: AchievementExpMapping.getExpForAchievement('streak_7'),
      difficulty: AchievementDifficulty.medium,
      category: AchievementCategory.streak,
      iconPath: 'assets/icons/streak_7.png',
    ),
    AchievementInfo(
      id: 'streak_42',
      name: '완벽한 연속',
      description: '42일 연속으로 운동하세요 (전체 프로그램)',
      expReward: AchievementExpMapping.getExpForAchievement('streak_42'),
      difficulty: AchievementDifficulty.legendary,
      category: AchievementCategory.streak,
      iconPath: 'assets/icons/streak_42.png',
    ),

    // 최종 달성
    AchievementInfo(
      id: 'program_complete',
      name: '프로그램 완료',
      description: '14주 프로그램을 완료하세요',
      expReward: AchievementExpMapping.getExpForAchievement('program_complete'),
      difficulty: AchievementDifficulty.legendary,
      category: AchievementCategory.completion,
      iconPath: 'assets/icons/program_complete.png',
    ),
    AchievementInfo(
      id: 'master_achievement',
      name: '완벽한 마스터',
      description: '모든 업적을 달성하세요',
      expReward: AchievementExpMapping.getExpForAchievement('master_achievement'),
      difficulty: AchievementDifficulty.legendary,
      category: AchievementCategory.completion,
      iconPath: 'assets/icons/master.png',
    ),
  ];

  /// ID로 업적 정보 가져오기
  static AchievementInfo? getAchievement(String id) {
    try {
      return allAchievements.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 카테고리별 업적 가져오기
  static List<AchievementInfo> getAchievementsByCategory(AchievementCategory category) {
    return allAchievements.where((a) => a.category == category).toList();
  }

  /// 난이도별 업적 가져오기
  static List<AchievementInfo> getAchievementsByDifficulty(AchievementDifficulty difficulty) {
    return allAchievements.where((a) => a.difficulty == difficulty).toList();
  }
}
