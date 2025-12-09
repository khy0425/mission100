import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/rate_limit.dart';
import '../../models/user_subscription.dart';

/// Rate Limiting 서비스
///
/// 악의적인 트래픽 남용을 방지하기 위한 속도 제한 관리
class RateLimitService {
  static const String _stateKey = 'rate_limit_state';
  static const String _securityAlertsKey = 'security_alerts';

  /// Rate Limit 체크 (AI 메시지 전송 전)
  static Future<RateLimitResult> checkRateLimit({
    required String action,
    bool isPremium = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;

    // 현재 상태 로드
    RateLimitState state = await _loadState(prefs);

    // 일일 리셋 체크
    final today = DateTime.now().millisecondsSinceEpoch ~/ 86400000;
    final lastResetDay = state.lastResetDate ~/ 86400000;
    if (today > lastResetDay) {
      state = state.copyWith(
        dailyConversations: 0,
        lastResetDate: now,
        suspiciousScore: 0,
      );
    }

    // 쿨다운 체크
    if (state.cooldownUntil > now) {
      final remainingMinutes = ((state.cooldownUntil - now) / 60000).ceil();
      return RateLimitResult.denied(
        reason: '과도한 요청으로 인해 $remainingMinutes분간 대기해주세요.',
        remainingMinutes: remainingMinutes,
      );
    }

    // 사용자 타입에 따른 제한
    final maxPerMinute = isPremium
        ? RateLimitConfig.premiumMaxMessagesPerMinute
        : RateLimitConfig.freeMaxMessagesPerMinute;
    final maxPerHour = isPremium
        ? RateLimitConfig.premiumMaxMessagesPerHour
        : RateLimitConfig.freeMaxMessagesPerHour;
    final maxPerDay = isPremium
        ? RateLimitConfig.premiumMaxConversationsPerDay
        : RateLimitConfig.freeMaxConversationsPerDay;
    final cooldownMinutes = isPremium
        ? RateLimitConfig.premiumCooldownMinutes
        : RateLimitConfig.freeCooldownMinutes;

    // 1. 분당 요청 체크
    final oneMinuteAgo = now - 60000;
    final recentMinuteRequests =
        state.lastMinuteRequests.where((t) => t > oneMinuteAgo).toList();

    if (recentMinuteRequests.length >= maxPerMinute) {
      // 쿨다운 적용
      final cooldownUntil = now + (cooldownMinutes * 60000);
      state = state.copyWith(
        cooldownUntil: cooldownUntil,
        suspiciousScore: state.suspiciousScore + 20,
      );
      await _saveState(prefs, state);
      await _logSecurityAlert(prefs, '분당 요청 제한 초과', state.suspiciousScore);

      return RateLimitResult.denied(
        reason: '분당 $maxPerMinute회 요청 제한을 초과했습니다.\n$cooldownMinutes분 후 다시 시도해주세요.',
        remainingMinutes: cooldownMinutes,
      );
    }

    // 2. 시간당 요청 체크
    final oneHourAgo = now - 3600000;
    final recentHourRequests =
        state.lastHourRequests.where((t) => t > oneHourAgo).toList();

    if (recentHourRequests.length >= maxPerHour) {
      return RateLimitResult.denied(
        reason: '시간당 $maxPerHour회 요청 제한을 초과했습니다.',
      );
    }

    // 3. 일일 대화 수 체크 (새 대화 시작 시에만)
    if (action == 'conversation_start' &&
        state.dailyConversations >= maxPerDay) {
      return RateLimitResult.denied(
        reason: '오늘 $maxPerDay개 대화 제한을 초과했습니다.\n내일 다시 시도해주세요.',
      );
    }

    // 4. 의심스러운 패턴 감지
    final suspiciousResult = _detectSuspiciousPattern(
      state,
      recentMinuteRequests,
      isPremium,
    );

    if (suspiciousResult.isSuspicious) {
      state = state.copyWith(
        suspiciousScore: state.suspiciousScore + 30,
        cooldownUntil: now + (cooldownMinutes * 2 * 60000), // 2배 쿨다운
      );
      await _saveState(prefs, state);
      await _logSecurityAlert(prefs, '의심스러운 행동 패턴 감지', state.suspiciousScore);

      return suspiciousResult;
    }

    // 요청 기록 업데이트
    recentMinuteRequests.add(now);
    recentHourRequests.add(now);

    state = state.copyWith(
      lastMinuteRequests: recentMinuteRequests,
      lastHourRequests: recentHourRequests,
      dailyConversations: action == 'conversation_start'
          ? state.dailyConversations + 1
          : state.dailyConversations,
      // 정상 사용 시 의심 점수 감소
      suspiciousScore: max(0, state.suspiciousScore - 1),
    );

    await _saveState(prefs, state);

    return RateLimitResult.allowed();
  }

  /// 의심스러운 패턴 감지
  static RateLimitResult _detectSuspiciousPattern(
    RateLimitState state,
    List<int> recentRequests,
    bool isPremium,
  ) {
    // 패턴 1: 너무 빠른 연속 요청 (봇 의심)
    if (recentRequests.length >= 2) {
      final lastInterval =
          recentRequests.last - recentRequests[recentRequests.length - 2];

      if (lastInterval < RateLimitConfig.suspiciousMessageInterval) {
        return RateLimitResult.suspicious(
          reason: '비정상적으로 빠른 요청이 감지되었습니다.\n잠시 후 다시 시도해주세요.',
        );
      }
    }

    // 패턴 2: 너무 규칙적인 간격 (자동화 의심)
    if (recentRequests.length >= 5) {
      final intervals = <int>[];
      for (int i = 1; i < recentRequests.length; i++) {
        intervals.add(recentRequests[i] - recentRequests[i - 1]);
      }

      // 평균과 표준편차 계산
      final avgInterval =
          intervals.reduce((a, b) => a + b) / intervals.length;
      final variance = intervals
              .map((i) => pow(i - avgInterval, 2))
              .reduce((a, b) => a + b) /
          intervals.length;
      final stdDev = sqrt(variance);

      // 간격이 너무 일정하면 의심 (표준편차 < 500ms)
      if (stdDev < RateLimitConfig.suspiciousVarianceThreshold) {
        return RateLimitResult.suspicious(
          reason: '비정상적인 요청 패턴이 감지되었습니다.\n수동으로 사용 중이신가요?',
        );
      }
    }

    // 패턴 3: 의심 점수가 너무 높음
    if (state.suspiciousScore > 70) {
      return RateLimitResult.suspicious(
        reason: '보안 정책 위반으로 일시적으로 차단되었습니다.\n고객센터로 문의해주세요.',
      );
    }

    return RateLimitResult.allowed();
  }

  /// 상태 로드
  static Future<RateLimitState> _loadState(SharedPreferences prefs) async {
    final stateJson = prefs.getString(_stateKey);
    if (stateJson == null) {
      return RateLimitState.initial();
    }

    try {
      final Map<String, dynamic> json = jsonDecode(stateJson);
      return RateLimitState.fromJson(json);
    } catch (e) {
      return RateLimitState.initial();
    }
  }

  /// 상태 저장
  static Future<void> _saveState(
    SharedPreferences prefs,
    RateLimitState state,
  ) async {
    await prefs.setString(_stateKey, jsonEncode(state.toJson()));
  }

  /// 보안 알림 로그 기록
  static Future<void> _logSecurityAlert(
    SharedPreferences prefs,
    String reason,
    int suspiciousScore,
  ) async {
    final alerts = prefs.getStringList(_securityAlertsKey) ?? [];
    final alert = {
      'timestamp': DateTime.now().toIso8601String(),
      'reason': reason,
      'suspiciousScore': suspiciousScore,
    };

    alerts.add(jsonEncode(alert));

    // 최대 50개까지만 보관
    if (alerts.length > 50) {
      alerts.removeRange(0, alerts.length - 50);
    }

    await prefs.setStringList(_securityAlertsKey, alerts);
  }

  /// 현재 상태 조회 (디버깅/모니터링용)
  static Future<RateLimitState> getCurrentState() async {
    final prefs = await SharedPreferences.getInstance();
    return _loadState(prefs);
  }

  /// 상태 초기화 (테스트/디버깅용)
  static Future<void> resetState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_stateKey);
    await prefs.remove(_securityAlertsKey);
  }

  /// 보안 알림 조회
  static Future<List<Map<String, dynamic>>> getSecurityAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    final alerts = prefs.getStringList(_securityAlertsKey) ?? [];

    return alerts.map((alertJson) {
      return jsonDecode(alertJson) as Map<String, dynamic>;
    }).toList();
  }
}
