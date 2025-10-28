/// Chad Evolution 보상 대화 시스템
/// 9 Levels × 7 Performance Tiers = 63 대화

/// 성과 등급 열거형
enum PerformanceTier {
  legendary, // 완벽 이상 (110%+)
  perfect, // 완벽 (100%)
  excellent, // 탁월 (90-99%)
  good, // 좋음 (80-89%)
  normal, // 보통 (70-79%)
  minimal, // 최소 (60-69%)
  barely, // 간신히 (50-59%)
}

/// 보상 대화 데이터 모델
class RewardDialogue {
  final int level;
  final PerformanceTier tier;
  final String title;
  final String message;
  final String? subMessage;

  const RewardDialogue({
    required this.level,
    required this.tier,
    required this.title,
    required this.message,
    this.subMessage,
  });
}

/// 63개 보상 대화 전체 데이터
class ChadRewardDialogues {
  static const Map<int, Map<PerformanceTier, RewardDialogue>> dialogues = {
    // Level 1: Basic Chad
    1: {
      PerformanceTier.legendary: RewardDialogue(
        level: 1,
        tier: PerformanceTier.legendary,
        title: '전설의 시작!',
        message: '완벽을 넘어섰다! 턱선이 벌써부터 날카로워진다!',
        subMessage: 'Chad는 완성형이다. 남은 것은 뇌절뿐.',
      ),
      PerformanceTier.perfect: RewardDialogue(
        level: 1,
        tier: PerformanceTier.perfect,
        title: '완벽한 첫걸음!',
        message: '100% 달성! Basic Chad의 기본기가 탄탄하다!',
      ),
      PerformanceTier.excellent: RewardDialogue(
        level: 1,
        tier: PerformanceTier.excellent,
        title: '탁월한 시작!',
        message: '좋은 출발이다! 턱선이 조금씩 생기기 시작한다.',
      ),
      PerformanceTier.good: RewardDialogue(
        level: 1,
        tier: PerformanceTier.good,
        title: '좋은 시작!',
        message: '나쁘지 않다! Basic Chad로의 여정이 순조롭다.',
      ),
      PerformanceTier.normal: RewardDialogue(
        level: 1,
        tier: PerformanceTier.normal,
        title: '괜찮은 시작',
        message: '보통이다. 하지만 Chad의 길은 이제부터다!',
      ),
      PerformanceTier.minimal: RewardDialogue(
        level: 1,
        tier: PerformanceTier.minimal,
        title: '최소 달성',
        message: '간신히 통과했다. 다음엔 더 잘할 수 있다!',
      ),
      PerformanceTier.barely: RewardDialogue(
        level: 1,
        tier: PerformanceTier.barely,
        title: '아슬아슬',
        message: '거의 실패할 뻔했다! 집중이 필요하다.',
      ),
    },

    // Level 2: Coffee Chad
    2: {
      PerformanceTier.legendary: RewardDialogue(
        level: 2,
        tier: PerformanceTier.legendary,
        title: '☕ 카페인 폭발!',
        message: '완벽 이상! 에스프레소 10샷을 마신 것 같은 파워!',
        subMessage: '뇌절 2도 달성! 카페인 오라 MAX!',
      ),
      PerformanceTier.perfect: RewardDialogue(
        level: 2,
        tier: PerformanceTier.perfect,
        title: '☕ 완벽한 커피 타임!',
        message: '100% 완료! Coffee Chad의 진면목을 보여줬다!',
      ),
      PerformanceTier.excellent: RewardDialogue(
        level: 2,
        tier: PerformanceTier.excellent,
        title: '☕ 진한 에스프레소급!',
        message: '탁월하다! 카페인이 온몸에 퍼진다!',
      ),
      PerformanceTier.good: RewardDialogue(
        level: 2,
        tier: PerformanceTier.good,
        title: '☕ 좋은 아메리카노!',
        message: '좋은 성과! Coffee Chad답다!',
      ),
      PerformanceTier.normal: RewardDialogue(
        level: 2,
        tier: PerformanceTier.normal,
        title: '☕ 라떼 정도',
        message: '보통이다. 더 진한 커피가 필요하다.',
      ),
      PerformanceTier.minimal: RewardDialogue(
        level: 2,
        tier: PerformanceTier.minimal,
        title: '☕ 디카페인?',
        message: '최소 달성. 카페인이 부족한가?',
      ),
      PerformanceTier.barely: RewardDialogue(
        level: 2,
        tier: PerformanceTier.barely,
        title: '☕ 물 탄 커피',
        message: '간신히 통과. 에너지 충전이 필요하다!',
      ),
    },

    // Level 3: Confident Chad
    3: {
      PerformanceTier.legendary: RewardDialogue(
        level: 3,
        tier: PerformanceTier.legendary,
        title: '💪 자신감 폭발!',
        message: '전설적 성과! 자신감이 우주를 뚫고 나간다!',
        subMessage: '뇌절 3도! 턱선이 다이아몬드처럼 단단해졌다!',
      ),
      PerformanceTier.perfect: RewardDialogue(
        level: 3,
        tier: PerformanceTier.perfect,
        title: '💪 완벽한 자신감!',
        message: '100% 완성! Confident Chad의 정점!',
      ),
      PerformanceTier.excellent: RewardDialogue(
        level: 3,
        tier: PerformanceTier.excellent,
        title: '💪 넘치는 자신감!',
        message: '탁월하다! 눈빛에서 자신감이 뿜어진다!',
      ),
      PerformanceTier.good: RewardDialogue(
        level: 3,
        tier: PerformanceTier.good,
        title: '💪 당당한 Chad!',
        message: '좋은 성과! 자신감이 느껴진다!',
      ),
      PerformanceTier.normal: RewardDialogue(
        level: 3,
        tier: PerformanceTier.normal,
        title: '💪 보통 자신감',
        message: '보통이다. 더 당당해질 수 있다!',
      ),
      PerformanceTier.minimal: RewardDialogue(
        level: 3,
        tier: PerformanceTier.minimal,
        title: '💪 약간의 자신감',
        message: '최소 달성. 자신감이 좀 부족하다.',
      ),
      PerformanceTier.barely: RewardDialogue(
        level: 3,
        tier: PerformanceTier.barely,
        title: '💪 떨리는 자신감',
        message: '간신히 통과. 자신감을 더 키워야 한다!',
      ),
    },

    // Level 4: Sunglasses Chad
    4: {
      PerformanceTier.legendary: RewardDialogue(
        level: 4,
        tier: PerformanceTier.legendary,
        title: '🕶️ 쿨함의 극치!',
        message: '전설급 쿨함! 선글라스 너머로 레이저가 보인다!',
        subMessage: '뇌절 4도! 쿨함 지수 999%!',
      ),
      PerformanceTier.perfect: RewardDialogue(
        level: 4,
        tier: PerformanceTier.perfect,
        title: '🕶️ 완벽한 쿨함!',
        message: '100% 달성! Sunglasses Chad의 진수!',
      ),
      PerformanceTier.excellent: RewardDialogue(
        level: 4,
        tier: PerformanceTier.excellent,
        title: '🕶️ 극강 쿨함!',
        message: '탁월하다! 선글라스가 빛난다!',
      ),
      PerformanceTier.good: RewardDialogue(
        level: 4,
        tier: PerformanceTier.good,
        title: '🕶️ 멋진 Chad!',
        message: '좋은 성과! 쿨하게 완수했다!',
      ),
      PerformanceTier.normal: RewardDialogue(
        level: 4,
        tier: PerformanceTier.normal,
        title: '🕶️ 그냥 선글라스',
        message: '보통이다. 더 쿨해질 필요가 있다.',
      ),
      PerformanceTier.minimal: RewardDialogue(
        level: 4,
        tier: PerformanceTier.minimal,
        title: '🕶️ 뿌연 렌즈',
        message: '최소 달성. 선글라스를 닦아야겠다.',
      ),
      PerformanceTier.barely: RewardDialogue(
        level: 4,
        tier: PerformanceTier.barely,
        title: '🕶️ 금 간 렌즈',
        message: '간신히 통과. 쿨함이 부족하다!',
      ),
    },

    // Level 5: Laser Eyes Chad
    5: {
      PerformanceTier.legendary: RewardDialogue(
        level: 5,
        tier: PerformanceTier.legendary,
        title: '⚡ 레이저 최대 출력!',
        message: '전설의 레이저! 눈빔으로 모든 것을 관통한다!',
        subMessage: '뇌절 5도! 레이저 전압 5000V!',
      ),
      PerformanceTier.perfect: RewardDialogue(
        level: 5,
        tier: PerformanceTier.perfect,
        title: '⚡ 완벽한 레이저!',
        message: '100% 레이저 발사! Laser Eyes Chad의 진면목!',
      ),
      PerformanceTier.excellent: RewardDialogue(
        level: 5,
        tier: PerformanceTier.excellent,
        title: '⚡ 강력한 레이저!',
        message: '탁월하다! 눈에서 불꽃이 튄다!',
      ),
      PerformanceTier.good: RewardDialogue(
        level: 5,
        tier: PerformanceTier.good,
        title: '⚡ 좋은 레이저!',
        message: '좋은 성과! 레이저가 제대로 발사되었다!',
      ),
      PerformanceTier.normal: RewardDialogue(
        level: 5,
        tier: PerformanceTier.normal,
        title: '⚡ 약한 레이저',
        message: '보통이다. 레이저 충전이 필요하다.',
      ),
      PerformanceTier.minimal: RewardDialogue(
        level: 5,
        tier: PerformanceTier.minimal,
        title: '⚡ 깜빡이는 레이저',
        message: '최소 달성. 배터리가 부족한가?',
      ),
      PerformanceTier.barely: RewardDialogue(
        level: 5,
        tier: PerformanceTier.barely,
        title: '⚡ 레이저 오작동',
        message: '간신히 통과. 레이저 점검이 필요하다!',
      ),
    },

    // Level 6: Laser Eyes HUD Chad
    6: {
      PerformanceTier.legendary: RewardDialogue(
        level: 6,
        tier: PerformanceTier.legendary,
        title: '⚡🎯 HUD 시스템 MAX!',
        message: '전투력 측정기 폭발! 레전더리 전투력 감지!',
        subMessage: '뇌절 6도! 전투력: 9000 이상!',
      ),
      PerformanceTier.perfect: RewardDialogue(
        level: 6,
        tier: PerformanceTier.perfect,
        title: '⚡🎯 완벽한 HUD!',
        message: '100% 시스템 가동! HUD Chad의 완성형!',
      ),
      PerformanceTier.excellent: RewardDialogue(
        level: 6,
        tier: PerformanceTier.excellent,
        title: '⚡🎯 최적화된 HUD!',
        message: '탁월하다! 모든 시스템이 완벽하게 작동한다!',
      ),
      PerformanceTier.good: RewardDialogue(
        level: 6,
        tier: PerformanceTier.good,
        title: '⚡🎯 안정된 HUD',
        message: '좋은 성과! HUD가 정상 작동 중!',
      ),
      PerformanceTier.normal: RewardDialogue(
        level: 6,
        tier: PerformanceTier.normal,
        title: '⚡🎯 기본 HUD',
        message: '보통이다. 시스템 업그레이드가 필요하다.',
      ),
      PerformanceTier.minimal: RewardDialogue(
        level: 6,
        tier: PerformanceTier.minimal,
        title: '⚡🎯 버퍼링 HUD',
        message: '최소 달성. HUD가 버퍼링 중이다.',
      ),
      PerformanceTier.barely: RewardDialogue(
        level: 6,
        tier: PerformanceTier.barely,
        title: '⚡🎯 오류 HUD',
        message: '간신히 통과. 시스템 재부팅이 필요하다!',
      ),
    },

    // Level 7: Double Chad
    7: {
      PerformanceTier.legendary: RewardDialogue(
        level: 7,
        tier: PerformanceTier.legendary,
        title: '👥 더블 파워 폭발!',
        message: '전설적 분신술! 2배가 아니라 10배 파워다!',
        subMessage: '뇌절 7도! 더블 Chad 시너지 MAX!',
      ),
      PerformanceTier.perfect: RewardDialogue(
        level: 7,
        tier: PerformanceTier.perfect,
        title: '👥 완벽한 더블!',
        message: '100% × 2! Double Chad의 진정한 힘!',
      ),
      PerformanceTier.excellent: RewardDialogue(
        level: 7,
        tier: PerformanceTier.excellent,
        title: '👥 강력한 더블!',
        message: '탁월하다! 두 Chad가 완벽한 조화를 이룬다!',
      ),
      PerformanceTier.good: RewardDialogue(
        level: 7,
        tier: PerformanceTier.good,
        title: '👥 좋은 더블!',
        message: '좋은 성과! 분신술이 제대로 작동했다!',
      ),
      PerformanceTier.normal: RewardDialogue(
        level: 7,
        tier: PerformanceTier.normal,
        title: '👥 보통 더블',
        message: '보통이다. 분신이 좀 흐릿하다.',
      ),
      PerformanceTier.minimal: RewardDialogue(
        level: 7,
        tier: PerformanceTier.minimal,
        title: '👥 희미한 분신',
        message: '최소 달성. 분신이 거의 안 보인다.',
      ),
      PerformanceTier.barely: RewardDialogue(
        level: 7,
        tier: PerformanceTier.barely,
        title: '👥 불안정한 분신',
        message: '간신히 통과. 분신이 곧 사라질 것 같다!',
      ),
    },

    // Level 8: Triple Chad
    8: {
      PerformanceTier.legendary: RewardDialogue(
        level: 8,
        tier: PerformanceTier.legendary,
        title: '👥👥 트리플 극대화!',
        message: '전설의 삼위일체! 우주가 떨린다!',
        subMessage: '뇌절 8도! Triple Chad 초월 모드!',
      ),
      PerformanceTier.perfect: RewardDialogue(
        level: 8,
        tier: PerformanceTier.perfect,
        title: '👥👥 완벽한 트리플!',
        message: '100% × 3! Triple Chad의 완성!',
      ),
      PerformanceTier.excellent: RewardDialogue(
        level: 8,
        tier: PerformanceTier.excellent,
        title: '👥👥 완벽한 삼위일체!',
        message: '탁월하다! 세 Chad가 하나가 되었다!',
      ),
      PerformanceTier.good: RewardDialogue(
        level: 8,
        tier: PerformanceTier.good,
        title: '👥👥 좋은 트리플!',
        message: '좋은 성과! 삼위일체가 안정적이다!',
      ),
      PerformanceTier.normal: RewardDialogue(
        level: 8,
        tier: PerformanceTier.normal,
        title: '👥👥 보통 트리플',
        message: '보통이다. 한 명이 좀 약해 보인다.',
      ),
      PerformanceTier.minimal: RewardDialogue(
        level: 8,
        tier: PerformanceTier.minimal,
        title: '👥👥 불완전한 트리플',
        message: '최소 달성. 세 번째 분신이 희미하다.',
      ),
      PerformanceTier.barely: RewardDialogue(
        level: 8,
        tier: PerformanceTier.barely,
        title: '👥👥 붕괴 직전',
        message: '간신히 통과. 분신들이 싸우고 있다!',
      ),
    },

    // Level 9: GOD CHAD (최종)
    9: {
      PerformanceTier.legendary: RewardDialogue(
        level: 9,
        tier: PerformanceTier.legendary,
        title: '👑🌟 신의 영역 초월!',
        message: 'GOD CHAD를 넘어섰다! 우주의 신이 되었다!',
        subMessage: '뇌절 9도(극한)! 존재 자체가 전설이다!',
      ),
      PerformanceTier.perfect: RewardDialogue(
        level: 9,
        tier: PerformanceTier.perfect,
        title: '👑🌟 완벽한 신!',
        message: '100% GOD CHAD! 완전무결한 신의 경지!',
      ),
      PerformanceTier.excellent: RewardDialogue(
        level: 9,
        tier: PerformanceTier.excellent,
        title: '👑🌟 신의 위엄!',
        message: '탁월하다! GOD CHAD의 진정한 힘!',
      ),
      PerformanceTier.good: RewardDialogue(
        level: 9,
        tier: PerformanceTier.good,
        title: '👑🌟 신의 은총!',
        message: '좋은 성과! GOD CHAD답다!',
      ),
      PerformanceTier.normal: RewardDialogue(
        level: 9,
        tier: PerformanceTier.normal,
        title: '👑🌟 신의 휴식',
        message: '보통이다. 신도 쉴 때가 있다.',
      ),
      PerformanceTier.minimal: RewardDialogue(
        level: 9,
        tier: PerformanceTier.minimal,
        title: '👑🌟 잠든 신',
        message: '최소 달성. 신이 졸고 있었나?',
      ),
      PerformanceTier.barely: RewardDialogue(
        level: 9,
        tier: PerformanceTier.barely,
        title: '👑🌟 신의 시험',
        message: '간신히 통과. 신도 시련이 필요하다!',
      ),
    },
  };

  /// 특정 레벨과 성과에 맞는 대화 가져오기
  static RewardDialogue getDialogue(int level, PerformanceTier tier) {
    final levelDialogues = dialogues[level];
    if (levelDialogues == null) {
      // 레벨이 범위를 벗어나면 Level 1 기본값 반환
      return dialogues[1]![PerformanceTier.normal]!;
    }

    return levelDialogues[tier] ?? levelDialogues[PerformanceTier.normal]!;
  }

  /// 완료율에 따른 성과 등급 계산
  static PerformanceTier calculateTier(double completionRate) {
    if (completionRate >= 1.10) {
      return PerformanceTier.legendary;
    } else if (completionRate >= 1.0) {
      return PerformanceTier.perfect;
    } else if (completionRate >= 0.90) {
      return PerformanceTier.excellent;
    } else if (completionRate >= 0.80) {
      return PerformanceTier.good;
    } else if (completionRate >= 0.70) {
      return PerformanceTier.normal;
    } else if (completionRate >= 0.60) {
      return PerformanceTier.minimal;
    } else {
      return PerformanceTier.barely;
    }
  }

  /// 운동 완료 후 대화 가져오기 (원스톱 메서드)
  static RewardDialogue getWorkoutReward({
    required int chadLevel,
    required double completionRate,
  }) {
    final tier = calculateTier(completionRate);
    return getDialogue(chadLevel, tier);
  }
}
