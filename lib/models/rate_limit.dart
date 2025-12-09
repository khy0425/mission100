/// Rate Limiting 모델
///
/// 악의적인 트래픽 남용 방지를 위한 속도 제한
class RateLimitConfig {
  // 무료 사용자 제한
  static const int freeMaxMessagesPerMinute = 3;
  static const int freeMaxMessagesPerHour = 20;
  static const int freeMaxConversationsPerDay = 10;
  static const int freeCooldownMinutes = 5;

  // 프리미엄 사용자 제한 (더 관대)
  static const int premiumMaxMessagesPerMinute = 10;
  static const int premiumMaxMessagesPerHour = 100;
  static const int premiumMaxConversationsPerDay = 50;
  static const int premiumCooldownMinutes = 1;

  // 의심스러운 활동 임계값
  static const int suspiciousMessageInterval = 2000; // 2초 이내 연속 메시지
  static const double suspiciousVarianceThreshold = 500; // 간격 표준편차 500ms 미만 (봇 의심)
}

/// Rate Limit 상태
class RateLimitState {
  final List<int> lastMinuteRequests; // 최근 1분간 요청 타임스탬프
  final List<int> lastHourRequests; // 최근 1시간간 요청 타임스탬프
  final int dailyConversations; // 오늘 대화 수
  final int lastResetDate; // 마지막 일일 리셋 시간
  final int cooldownUntil; // 쿨다운 종료 시각
  final int suspiciousScore; // 의심 점수 (0-100)

  const RateLimitState({
    this.lastMinuteRequests = const [],
    this.lastHourRequests = const [],
    this.dailyConversations = 0,
    required this.lastResetDate,
    this.cooldownUntil = 0,
    this.suspiciousScore = 0,
  });

  factory RateLimitState.initial() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return RateLimitState(
      lastResetDate: now,
    );
  }

  RateLimitState copyWith({
    List<int>? lastMinuteRequests,
    List<int>? lastHourRequests,
    int? dailyConversations,
    int? lastResetDate,
    int? cooldownUntil,
    int? suspiciousScore,
  }) {
    return RateLimitState(
      lastMinuteRequests: lastMinuteRequests ?? this.lastMinuteRequests,
      lastHourRequests: lastHourRequests ?? this.lastHourRequests,
      dailyConversations: dailyConversations ?? this.dailyConversations,
      lastResetDate: lastResetDate ?? this.lastResetDate,
      cooldownUntil: cooldownUntil ?? this.cooldownUntil,
      suspiciousScore: suspiciousScore ?? this.suspiciousScore,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastMinuteRequests': lastMinuteRequests,
      'lastHourRequests': lastHourRequests,
      'dailyConversations': dailyConversations,
      'lastResetDate': lastResetDate,
      'cooldownUntil': cooldownUntil,
      'suspiciousScore': suspiciousScore,
    };
  }

  factory RateLimitState.fromJson(Map<String, dynamic> json) {
    return RateLimitState(
      lastMinuteRequests: List<int>.from(json['lastMinuteRequests'] ?? []),
      lastHourRequests: List<int>.from(json['lastHourRequests'] ?? []),
      dailyConversations: json['dailyConversations'] ?? 0,
      lastResetDate: json['lastResetDate'] ?? DateTime.now().millisecondsSinceEpoch,
      cooldownUntil: json['cooldownUntil'] ?? 0,
      suspiciousScore: json['suspiciousScore'] ?? 0,
    );
  }
}

/// Rate Limit 체크 결과
class RateLimitResult {
  final bool allowed;
  final String? reason;
  final int? remainingMinutes;
  final bool isSuspicious;

  const RateLimitResult({
    required this.allowed,
    this.reason,
    this.remainingMinutes,
    this.isSuspicious = false,
  });

  factory RateLimitResult.allowed() {
    return const RateLimitResult(allowed: true);
  }

  factory RateLimitResult.denied({
    required String reason,
    int? remainingMinutes,
  }) {
    return RateLimitResult(
      allowed: false,
      reason: reason,
      remainingMinutes: remainingMinutes,
    );
  }

  factory RateLimitResult.suspicious({
    required String reason,
  }) {
    return RateLimitResult(
      allowed: false,
      reason: reason,
      isSuspicious: true,
    );
  }
}
