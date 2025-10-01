import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';

/// 사용자 정의 이벤트 타입
enum CustomEventType {
  // 운동 관련
  workoutStarted,
  workoutCompleted,
  workoutSkipped,
  workoutPaused,
  workoutResumed,

  // 진행도 관련
  levelUp,
  achievementUnlocked,
  streakAchieved,
  weekCompleted,

  // 구독 관련
  subscriptionStarted,
  subscriptionCancelled,
  subscriptionUpgraded,
  subscriptionDowngraded,

  // 사용자 행동
  appOpened,
  tutorialCompleted,
  settingsChanged,
  feedbackSubmitted,

  // 에러 관련
  errorOccurred,
  crashReported,
}

/// 분석 이벤트 데이터
class AnalyticsEvent {
  final String name;
  final Map<String, Object> parameters;
  final DateTime timestamp;
  final String? userId;

  const AnalyticsEvent({
    required this.name,
    required this.parameters,
    required this.timestamp,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'parameters': parameters,
      'timestamp': timestamp.toIso8601String(),
      'user_id': userId,
    };
  }
}

/// Firebase Analytics 서비스
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  FirebaseAnalytics? _analytics;
  FirebaseCrashlytics? _crashlytics;
  FirebasePerformance? _performance;

  bool _isInitialized = false;
  bool _analyticsEnabled = true;
  final List<AnalyticsEvent> _eventQueue = [];

  /// 초기화
  Future<void> initialize() async {
    try {
      if (_isInitialized) return;

      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;
      _performance = FirebasePerformance.instance;

      // 개발 모드에서는 분석 비활성화
      if (kDebugMode) {
        await _analytics?.setAnalyticsCollectionEnabled(false);
        await _crashlytics?.setCrashlyticsCollectionEnabled(false);
        _analyticsEnabled = false;
        debugPrint('개발 모드: Firebase 분석 비활성화');
      } else {
        await _analytics?.setAnalyticsCollectionEnabled(true);
        await _crashlytics?.setCrashlyticsCollectionEnabled(true);
        _analyticsEnabled = true;
        debugPrint('운영 모드: Firebase 분석 활성화');
      }

      // 앱 시작 이벤트 기록
      await logCustomEvent(CustomEventType.appOpened, {
        'app_version': '2.1.0',
        'platform': defaultTargetPlatform.name,
      });

      _isInitialized = true;
      debugPrint('Analytics 서비스 초기화 완료');

    } catch (e) {
      debugPrint('Analytics 서비스 초기화 실패: $e');
    }
  }

  /// 사용자 설정
  Future<void> setUserId(String userId) async {
    try {
      if (!_analyticsEnabled) return;

      await _analytics?.setUserId(id: userId);
      await _crashlytics?.setUserIdentifier(userId);

      debugPrint('Analytics 사용자 ID 설정: $userId');
    } catch (e) {
      debugPrint('사용자 ID 설정 실패: $e');
    }
  }

  /// 사용자 속성 설정
  Future<void> setUserProperty(String name, String value) async {
    try {
      if (!_analyticsEnabled) return;

      await _analytics?.setUserProperty(name: name, value: value);
      debugPrint('사용자 속성 설정: $name = $value');
    } catch (e) {
      debugPrint('사용자 속성 설정 실패: $e');
    }
  }

  /// 화면 조회 기록
  Future<void> logScreenView(String screenName, {String? screenClass}) async {
    try {
      if (!_analyticsEnabled) return;

      await _analytics?.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );

      debugPrint('화면 조회: $screenName');
    } catch (e) {
      debugPrint('화면 조회 기록 실패: $e');
    }
  }

  /// 커스텀 이벤트 기록
  Future<void> logCustomEvent(
    CustomEventType eventType,
    Map<String, Object> parameters,
  ) async {
    try {
      final eventName = _getEventName(eventType);
      final sanitizedParameters = _sanitizeParameters(parameters);

      final event = AnalyticsEvent(
        name: eventName,
        parameters: sanitizedParameters,
        timestamp: DateTime.now(),
      );

      if (_analyticsEnabled) {
        await _analytics?.logEvent(
          name: eventName,
          parameters: sanitizedParameters,
        );
        debugPrint('이벤트 기록: $eventName');
      } else {
        _eventQueue.add(event);
        debugPrint('이벤트 큐에 추가: $eventName');
      }

    } catch (e) {
      debugPrint('커스텀 이벤트 기록 실패: $e');
    }
  }

  /// 운동 관련 이벤트들
  Future<void> logWorkoutStarted({
    required String exerciseType,
    required int week,
    required int day,
    int? targetReps,
  }) async {
    await logCustomEvent(CustomEventType.workoutStarted, {
      'exercise_type': exerciseType,
      'week': week,
      'day': day,
      'target_reps': targetReps ?? 0,
    });
  }

  Future<void> logWorkoutCompleted({
    required String exerciseType,
    required int completedReps,
    required int targetReps,
    required int week,
    required int day,
    required Duration workoutDuration,
  }) async {
    await logCustomEvent(CustomEventType.workoutCompleted, {
      'exercise_type': exerciseType,
      'completed_reps': completedReps,
      'target_reps': targetReps,
      'week': week,
      'day': day,
      'duration_seconds': workoutDuration.inSeconds,
      'completion_rate': (completedReps / targetReps * 100).round(),
    });
  }

  Future<void> logLevelUp({
    required int newLevel,
    required int experience,
    required String achievementType,
  }) async {
    await logCustomEvent(CustomEventType.levelUp, {
      'new_level': newLevel,
      'total_experience': experience,
      'achievement_type': achievementType,
    });
  }

  Future<void> logAchievementUnlocked({
    required String achievementId,
    required String achievementName,
    required String category,
    required int xpReward,
  }) async {
    await logCustomEvent(CustomEventType.achievementUnlocked, {
      'achievement_id': achievementId,
      'achievement_name': achievementName,
      'category': category,
      'xp_reward': xpReward,
    });
  }

  /// 구독 관련 이벤트들
  Future<void> logSubscriptionStarted({
    required String productId,
    required String subscriptionType,
    required double price,
    required String currency,
  }) async {
    await logCustomEvent(CustomEventType.subscriptionStarted, {
      'product_id': productId,
      'subscription_type': subscriptionType,
      'price': price,
      'currency': currency,
    });

    // Firebase Analytics 내장 이벤트도 사용
    if (_analyticsEnabled) {
      await _analytics?.logPurchase(
        currency: currency,
        value: price,
        items: [
          AnalyticsEventItem(
            itemId: productId,
            itemName: subscriptionType,
            itemCategory: 'subscription',
            price: price,
            quantity: 1,
          ),
        ],
      );
    }
  }

  Future<void> logSubscriptionCancelled({
    required String productId,
    required String reason,
    required int daysUsed,
  }) async {
    await logCustomEvent(CustomEventType.subscriptionCancelled, {
      'product_id': productId,
      'cancellation_reason': reason,
      'days_used': daysUsed,
    });
  }

  /// 에러 및 크래시 기록
  Future<void> logError({
    required String errorType,
    required String errorMessage,
    String? stackTrace,
    Map<String, String>? additionalData,
  }) async {
    try {
      // Crashlytics에 에러 기록
      if (_crashlytics != null) {
        await _crashlytics!.recordError(
          errorMessage,
          stackTrace != null ? StackTrace.fromString(stackTrace) : null,
          information: (additionalData ?? {}).entries.map((e) => 'Key: ${e.key}, Value: ${e.value}').toList(),
          fatal: false,
        );
      }

      // Analytics에도 에러 이벤트 기록
      await logCustomEvent(CustomEventType.errorOccurred, {
        'error_type': errorType,
        'error_message': errorMessage.length > 100
            ? errorMessage.substring(0, 100)
            : errorMessage,
      });

      debugPrint('에러 기록: $errorType - $errorMessage');

    } catch (e) {
      debugPrint('에러 기록 실패: $e');
    }
  }

  /// 커스텀 키-값 로깅 (Crashlytics)
  Future<void> setCustomKey(String key, Object value) async {
    try {
      await _crashlytics?.setCustomKey(key, value);
    } catch (e) {
      debugPrint('커스텀 키 설정 실패: $e');
    }
  }

  /// 성능 트레이싱 시작
  Trace? startTrace(String traceName) {
    try {
      return _performance?.newTrace(traceName);
    } catch (e) {
      debugPrint('트레이스 시작 실패: $e');
      return null;
    }
  }

  /// HTTP 메트릭 생성
  HttpMetric? createHttpMetric(String url, HttpMethod httpMethod) {
    try {
      return _performance?.newHttpMetric(url, httpMethod);
    } catch (e) {
      debugPrint('HTTP 메트릭 생성 실패: $e');
      return null;
    }
  }

  /// 이벤트 이름 매핑
  String _getEventName(CustomEventType eventType) {
    switch (eventType) {
      case CustomEventType.workoutStarted:
        return 'workout_started';
      case CustomEventType.workoutCompleted:
        return 'workout_completed';
      case CustomEventType.workoutSkipped:
        return 'workout_skipped';
      case CustomEventType.workoutPaused:
        return 'workout_paused';
      case CustomEventType.workoutResumed:
        return 'workout_resumed';
      case CustomEventType.levelUp:
        return 'level_up';
      case CustomEventType.achievementUnlocked:
        return 'achievement_unlocked';
      case CustomEventType.streakAchieved:
        return 'streak_achieved';
      case CustomEventType.weekCompleted:
        return 'week_completed';
      case CustomEventType.subscriptionStarted:
        return 'subscription_started';
      case CustomEventType.subscriptionCancelled:
        return 'subscription_cancelled';
      case CustomEventType.subscriptionUpgraded:
        return 'subscription_upgraded';
      case CustomEventType.subscriptionDowngraded:
        return 'subscription_downgraded';
      case CustomEventType.appOpened:
        return 'app_opened';
      case CustomEventType.tutorialCompleted:
        return 'tutorial_completed';
      case CustomEventType.settingsChanged:
        return 'settings_changed';
      case CustomEventType.feedbackSubmitted:
        return 'feedback_submitted';
      case CustomEventType.errorOccurred:
        return 'error_occurred';
      case CustomEventType.crashReported:
        return 'crash_reported';
    }
  }

  /// 파라미터 정리 (Firebase 제한 준수)
  Map<String, Object> _sanitizeParameters(Map<String, Object> parameters) {
    final sanitized = <String, Object>{};

    for (final entry in parameters.entries) {
      String key = entry.key;
      Object value = entry.value;

      // 키 길이 제한 (40자)
      if (key.length > 40) {
        key = key.substring(0, 40);
      }

      // 문자열 값 길이 제한 (100자)
      if (value is String && value.length > 100) {
        value = value.substring(0, 100);
      }

      sanitized[key] = value;
    }

    return sanitized;
  }

  /// 분석 활성화/비활성화
  Future<void> setAnalyticsEnabled(bool enabled) async {
    try {
      _analyticsEnabled = enabled;
      await _analytics?.setAnalyticsCollectionEnabled(enabled);

      if (enabled && _eventQueue.isNotEmpty) {
        // 큐에 있던 이벤트들 처리
        for (final event in _eventQueue) {
          await _analytics?.logEvent(
            name: event.name,
            parameters: event.parameters,
          );
        }
        _eventQueue.clear();
        debugPrint('큐에 있던 ${_eventQueue.length}개 이벤트 처리 완료');
      }

      debugPrint('Analytics 활성화 상태: $enabled');
    } catch (e) {
      debugPrint('Analytics 활성화 설정 실패: $e');
    }
  }

  /// 현재 세션 ID 조회
  Future<String?> getSessionId() async {
    try {
      final sessionId = await _analytics?.getSessionId();
      return sessionId?.toString();
    } catch (e) {
      debugPrint('세션 ID 조회 실패: $e');
      return null;
    }
  }

  /// 앱 인스턴스 ID 조회
  Future<String?> getAppInstanceId() async {
    try {
      return await _analytics?.appInstanceId;
    } catch (e) {
      debugPrint('앱 인스턴스 ID 조회 실패: $e');
      return null;
    }
  }

  /// 분석 통계
  Map<String, dynamic> getAnalyticsStats() {
    return {
      'is_initialized': _isInitialized,
      'analytics_enabled': _analyticsEnabled,
      'queued_events': _eventQueue.length,
      'platform': defaultTargetPlatform.name,
      'debug_mode': kDebugMode,
    };
  }

  /// 디버그 정보 출력
  void printAnalyticsInfo() {
    if (kDebugMode) {
      final stats = getAnalyticsStats();
      debugPrint('=== Analytics 서비스 정보 ===');
      debugPrint('초기화됨: ${stats['is_initialized']}');
      debugPrint('분석 활성화: ${stats['analytics_enabled']}');
      debugPrint('큐에 있는 이벤트: ${stats['queued_events']}개');
      debugPrint('플랫폼: ${stats['platform']}');
      debugPrint('디버그 모드: ${stats['debug_mode']}');
      debugPrint('=============================');
    }
  }

  /// 리소스 정리
  void dispose() {
    _eventQueue.clear();
    debugPrint('Analytics 서비스 정리 완료');
  }
}