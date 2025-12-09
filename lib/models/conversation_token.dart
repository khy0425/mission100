import '../services/progress/stage_unlock_service.dart';

/// 대화 토큰 시스템
///
/// 6-Stage 레벨 시스템 기반 토큰 제공
/// Stage 1-2: 무료 (1-2 토큰/일)
/// Stage 3-6: 프리미엄 (5-20 토큰/일)
class ConversationTokenSystem {
  /// 스테이지 기반 일일 토큰 (NEW)
  static int getDailyTokensForStage(int stage) {
    return StageUnlockService.getDailyTokensForStage(stage);
  }

  /// XP 기반 일일 토큰 (NEW)
  static int getDailyTokensFromXP(int totalXP, {required bool isPremium}) {
    final effectiveStage = StageUnlockService.getEffectiveStage(
      totalXP,
      isPremium: isPremium,
    );
    return StageUnlockService.getDailyTokensForStage(effectiveStage);
  }

  /// 레거시 지원 (하위 호환성)
  static const int freeUserDailyTokens = 1; // Stage 1 기본값
  static const int premiumUserDailyTokens = 5; // Stage 3 기본값
  static const int rewardAdTokens = 1; // 리워드 광고: 1개

  /// 연속 출석 보너스
  static const int streakBonusAt3Days = 1; // 3일 연속: +1 토큰
  static const int streakBonusAt7Days = 2; // 7일 연속: +2 토큰

  /// 토큰 사용 - 티어별 비용
  static const int quickChatCost = 1; // 빠른 상담: 1토큰
  static const int deepChatCost = 3; // 깊은 상담: 3토큰

  /// 티어별 메시지 수
  static const int quickChatMessages = 3; // 빠른 상담: 3회 응답
  static const int deepChatMessages = 10; // 깊은 상담: 10회 응답

  /// 레거시 지원 (하위 호환성)
  static const int conversationCost = 1; // 기본값
  static const int messagesPerToken = 5; // 기본값

  /// 스테이지 기반 최대 토큰 (NEW)
  static int getMaxTokensForStage(int stage) {
    // Stage 1-2: 5개, Stage 3-4: 30개, Stage 5-6: 50개
    if (stage <= 2) return 5;
    if (stage <= 4) return 30;
    return 50;
  }

  /// 레거시 보유 제한
  static const int maxFreeTokens = 5; // 무료: 최대 5개
  static const int maxPremiumTokens = 50; // 프리미엄: 최대 50개 (Stage 6 기준)
}

/// 대화 티어 - 빠른 상담 vs 깊은 상담
enum ConversationTier {
  quick, // 빠른 상담 (1토큰, 3메시지)
  deep, // 깊은 상담 (3토큰, 10메시지)
}

/// ConversationTier 확장 메서드
extension ConversationTierExtension on ConversationTier {
  /// 티어 비용
  int get cost {
    switch (this) {
      case ConversationTier.quick:
        return ConversationTokenSystem.quickChatCost;
      case ConversationTier.deep:
        return ConversationTokenSystem.deepChatCost;
    }
  }

  /// 티어별 최대 메시지 수
  int get maxMessages {
    switch (this) {
      case ConversationTier.quick:
        return ConversationTokenSystem.quickChatMessages;
      case ConversationTier.deep:
        return ConversationTokenSystem.deepChatMessages;
    }
  }

  /// 한국어 표시 이름
  String get displayNameKo {
    switch (this) {
      case ConversationTier.quick:
        return '빠른 상담';
      case ConversationTier.deep:
        return '깊은 상담';
    }
  }

  /// 영어 표시 이름
  String get displayNameEn {
    switch (this) {
      case ConversationTier.quick:
        return 'Quick Chat';
      case ConversationTier.deep:
        return 'Deep Chat';
    }
  }

  /// 티어 설명 (한국어)
  String get descriptionKo {
    switch (this) {
      case ConversationTier.quick:
        return '간단한 불안 대처법 조언';
      case ConversationTier.deep:
        return '깊이 있는 감정 상담';
    }
  }

  /// 티어 설명 (영어)
  String get descriptionEn {
    switch (this) {
      case ConversationTier.quick:
        return 'Quick answers to short questions';
      case ConversationTier.deep:
        return 'In-depth conversation and guidance';
    }
  }
}

/// 대화 토큰 상태
class ConversationTokens {
  final int balance; // 현재 보유 토큰
  final DateTime lastDailyReward; // 마지막 일일 보상 시간
  final int lifetimeEarned; // 누적 획득 토큰
  final int lifetimeSpent; // 누적 사용 토큰
  final int currentStreak; // 연속 출석 일수

  const ConversationTokens({
    required this.balance,
    required this.lastDailyReward,
    required this.lifetimeEarned,
    required this.lifetimeSpent,
    required this.currentStreak,
  });

  /// 초기 상태 (환영 보너스 1토큰 포함)
  static ConversationTokens initial() {
    return ConversationTokens(
      balance: 1, // 신규 사용자 환영 보너스 1토큰
      lastDailyReward: DateTime.now(),
      lifetimeEarned: 1,
      lifetimeSpent: 0,
      currentStreak: 0,
    );
  }

  /// 일일 보상 받을 수 있는지
  bool canClaimDailyReward() {
    final now = DateTime.now();
    return now.day != lastDailyReward.day ||
        now.month != lastDailyReward.month ||
        now.year != lastDailyReward.year;
  }

  /// 일일 보상 받기 (스테이지 기반)
  ///
  /// [stage]: 현재 사용자 스테이지 (1-6)
  /// [isPremium]: 프리미엄 구독 여부 (Stage 3+ 접근용)
  ConversationTokens claimDailyReward({
    required bool isPremium,
    int? stage, // NEW: 스테이지 기반 토큰
    int? totalXP, // NEW: XP 기반 스테이지 계산
  }) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final lastRewardDate = DateTime(
      lastDailyReward.year,
      lastDailyReward.month,
      lastDailyReward.day,
    );

    // 연속 출석 계산
    final isConsecutive = lastRewardDate.isAtSameMomentAs(yesterday);
    final newStreak = isConsecutive ? currentStreak + 1 : 1;

    // 스테이지 기반 토큰 계산
    int tokensToAdd;
    int maxTokens;
    int effectiveStage;

    if (stage != null) {
      // 직접 스테이지 전달 시
      effectiveStage = isPremium ? stage : stage.clamp(1, 2);
      tokensToAdd = ConversationTokenSystem.getDailyTokensForStage(effectiveStage);
      maxTokens = ConversationTokenSystem.getMaxTokensForStage(effectiveStage);
    } else if (totalXP != null) {
      // XP 전달 시 스테이지 자동 계산
      effectiveStage = StageUnlockService.getEffectiveStage(totalXP, isPremium: isPremium);
      tokensToAdd = ConversationTokenSystem.getDailyTokensFromXP(totalXP, isPremium: isPremium);
      maxTokens = ConversationTokenSystem.getMaxTokensForStage(effectiveStage);
    } else {
      // 레거시 지원 (stage/XP 없이 호출 시)
      tokensToAdd = isPremium
          ? ConversationTokenSystem.premiumUserDailyTokens
          : ConversationTokenSystem.freeUserDailyTokens;
      maxTokens = isPremium
          ? ConversationTokenSystem.maxPremiumTokens
          : ConversationTokenSystem.maxFreeTokens;
    }

    // 연속 출석 보너스 (무료/프리미엄 모두 동일)
    int bonusTokens = 0;
    if (newStreak == 3) {
      bonusTokens = ConversationTokenSystem.streakBonusAt3Days;
    } else if (newStreak == 7) {
      bonusTokens = ConversationTokenSystem.streakBonusAt7Days;
    } else if (newStreak > 7 && newStreak % 7 == 0) {
      // 7일마다 보너스
      bonusTokens = ConversationTokenSystem.streakBonusAt7Days;
    }

    tokensToAdd += bonusTokens;

    final newBalance = (balance + tokensToAdd).clamp(0, maxTokens);

    return ConversationTokens(
      balance: newBalance,
      lastDailyReward: now,
      lifetimeEarned: lifetimeEarned + tokensToAdd,
      lifetimeSpent: lifetimeSpent,
      currentStreak: newStreak,
    );
  }

  /// 보너스 토큰 계산 (표시용)
  int calculateBonusTokens() {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final lastRewardDate = DateTime(
      lastDailyReward.year,
      lastDailyReward.month,
      lastDailyReward.day,
    );

    final isConsecutive = lastRewardDate.isAtSameMomentAs(yesterday);
    final newStreak = isConsecutive ? currentStreak + 1 : 1;

    if (newStreak == 3) {
      return ConversationTokenSystem.streakBonusAt3Days;
    } else if (newStreak == 7) {
      return ConversationTokenSystem.streakBonusAt7Days;
    } else if (newStreak > 7 && newStreak % 7 == 0) {
      return ConversationTokenSystem.streakBonusAt7Days;
    }
    return 0;
  }

  /// 리워드 광고로 토큰 획득
  ConversationTokens earnFromAd({required bool isPremium}) {
    final maxTokens = isPremium
        ? ConversationTokenSystem.maxPremiumTokens
        : ConversationTokenSystem.maxFreeTokens;

    final newBalance = (balance + ConversationTokenSystem.rewardAdTokens)
        .clamp(0, maxTokens);

    return ConversationTokens(
      balance: newBalance,
      lastDailyReward: lastDailyReward,
      lifetimeEarned: lifetimeEarned + ConversationTokenSystem.rewardAdTokens,
      lifetimeSpent: lifetimeSpent,
      currentStreak: currentStreak,
    );
  }

  /// 대화 시작 (토큰 소모) - 레거시 지원
  ConversationTokens? startConversation() {
    if (balance < ConversationTokenSystem.conversationCost) {
      return null; // 토큰 부족
    }

    return ConversationTokens(
      balance: balance - ConversationTokenSystem.conversationCost,
      lastDailyReward: lastDailyReward,
      lifetimeEarned: lifetimeEarned,
      lifetimeSpent: lifetimeSpent + ConversationTokenSystem.conversationCost,
      currentStreak: currentStreak,
    );
  }

  /// 티어별 대화 시작 가능 여부
  bool canStartChat(ConversationTier tier) {
    return balance >= tier.cost;
  }

  /// 빠른 상담 가능 여부
  bool get canStartQuickChat => canStartChat(ConversationTier.quick);

  /// 깊은 상담 가능 여부
  bool get canStartDeepChat => canStartChat(ConversationTier.deep);

  /// 티어별 대화 시작 (토큰 소모)
  ConversationTokens? startChat(ConversationTier tier) {
    if (!canStartChat(tier)) {
      return null; // 토큰 부족
    }

    return ConversationTokens(
      balance: balance - tier.cost,
      lastDailyReward: lastDailyReward,
      lifetimeEarned: lifetimeEarned,
      lifetimeSpent: lifetimeSpent + tier.cost,
      currentStreak: currentStreak,
    );
  }

  /// JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'lastDailyReward': lastDailyReward.toIso8601String(),
      'lifetimeEarned': lifetimeEarned,
      'lifetimeSpent': lifetimeSpent,
      'currentStreak': currentStreak,
    };
  }

  factory ConversationTokens.fromJson(Map<String, dynamic> json) {
    return ConversationTokens(
      balance: json['balance'] as int? ?? 0,
      lastDailyReward: json['lastDailyReward'] != null
          ? DateTime.parse(json['lastDailyReward'] as String)
          : DateTime.now(),
      lifetimeEarned: json['lifetimeEarned'] as int? ?? 0,
      lifetimeSpent: json['lifetimeSpent'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
    );
  }
}
