/// 대화 토큰 시스템
///
/// 프리미엄 일회성 결제에서도 지속 가능한 대화형 AI 제공
class ConversationTokenSystem {
  /// 토큰 획득 방법
  static const int freeUserDailyTokens = 1; // 무료: 하루 1개
  static const int premiumUserDailyTokens = 5; // 프리미엄: 하루 5개
  static const int rewardAdTokens = 1; // 리워드 광고: 1개

  /// 토큰 사용
  static const int conversationCost = 1; // 대화 시작 1토큰
  static const int messagesPerToken = 5; // 토큰당 5회 대화

  /// 보유 제한
  static const int maxFreeTokens = 5; // 무료: 최대 5개
  static const int maxPremiumTokens = 30; // 프리미엄: 최대 30개
}

/// 대화 토큰 상태
class ConversationTokens {
  final int balance; // 현재 보유 토큰
  final DateTime lastDailyReward; // 마지막 일일 보상 시간
  final int lifetimeEarned; // 누적 획득 토큰
  final int lifetimeSpent; // 누적 사용 토큰

  const ConversationTokens({
    required this.balance,
    required this.lastDailyReward,
    required this.lifetimeEarned,
    required this.lifetimeSpent,
  });

  /// 초기 상태
  static ConversationTokens initial() {
    return ConversationTokens(
      balance: 0,
      lastDailyReward: DateTime.now(),
      lifetimeEarned: 0,
      lifetimeSpent: 0,
    );
  }

  /// 일일 보상 받을 수 있는지
  bool canClaimDailyReward() {
    final now = DateTime.now();
    return now.day != lastDailyReward.day ||
        now.month != lastDailyReward.month ||
        now.year != lastDailyReward.year;
  }

  /// 일일 보상 받기
  ConversationTokens claimDailyReward({required bool isPremium}) {
    final tokensToAdd = isPremium
        ? ConversationTokenSystem.premiumUserDailyTokens
        : ConversationTokenSystem.freeUserDailyTokens;

    final maxTokens = isPremium
        ? ConversationTokenSystem.maxPremiumTokens
        : ConversationTokenSystem.maxFreeTokens;

    final newBalance = (balance + tokensToAdd).clamp(0, maxTokens);

    return ConversationTokens(
      balance: newBalance,
      lastDailyReward: DateTime.now(),
      lifetimeEarned: lifetimeEarned + tokensToAdd,
      lifetimeSpent: lifetimeSpent,
    );
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
    );
  }

  /// 대화 시작 (토큰 소모)
  ConversationTokens? startConversation() {
    if (balance < ConversationTokenSystem.conversationCost) {
      return null; // 토큰 부족
    }

    return ConversationTokens(
      balance: balance - ConversationTokenSystem.conversationCost,
      lastDailyReward: lastDailyReward,
      lifetimeEarned: lifetimeEarned,
      lifetimeSpent: lifetimeSpent + ConversationTokenSystem.conversationCost,
    );
  }

  /// JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'lastDailyReward': lastDailyReward.toIso8601String(),
      'lifetimeEarned': lifetimeEarned,
      'lifetimeSpent': lifetimeSpent,
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
    );
  }
}
