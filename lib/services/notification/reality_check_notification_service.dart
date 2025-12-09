import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../ai/dream_sign_detection_service.dart';
import '../auth/auth_service.dart';
import '../../generated/l10n/app_localizations.dart';
import 'package:timezone/timezone.dart' as tz;

/// Reality Check 알림 서비스
///
/// 꿈 패턴 분석 기반으로 Reality Check 알림 자동 스케줄링
/// - 반복되는 Dream Sign 감지 시 Reality Check 알림 전송
/// - Aspy et al. (2017) 연구 기반: Reality Check의 효과적인 타이밍
class RealityCheckNotificationService {
  static final RealityCheckNotificationService _instance =
      RealityCheckNotificationService._internal();

  factory RealityCheckNotificationService() => _instance;

  RealityCheckNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final DreamSignDetectionService _dreamSignDetection =
      DreamSignDetectionService();
  final AuthService _authService = AuthService();

  /// 꿈 저장 후 Reality Check 알림 스케줄링
  ///
  /// - 꿈에서 반복 패턴 감지
  /// - 주요 Dream Sign 분석
  /// - 다음 2시간 간격으로 Reality Check 알림 설정 (연구 권장)
  Future<void> scheduleRealityCheckNotificationsAfterDream(AppLocalizations l10n) async {
    try {
      debugPrint('🔔 Reality Check 알림 스케줄링 시작...');

      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        debugPrint('⚠️ 사용자 ID 없음 - 알림 스케줄링 중단');
        return;
      }

      // 최근 꿈들 분석하여 패턴 감지
      final analysisResult =
          await _dreamSignDetection.analyzeAllDreams(userId, l10n);

      // 상위 3개 Dream Sign 선택
      final topSigns = analysisResult.topPotentialSigns.take(3).toList();

      if (topSigns.isEmpty) {
        debugPrint('ℹ️ Dream Sign이 충분하지 않음 - 기본 Reality Check 알림 스케줄링');
        await _scheduleDefaultRealityCheckReminder();
        return;
      }

      // 감지된 패턴을 기반으로 맞춤형 알림 생성
      final signDescriptions =
          topSigns.map((s) => s.description).join(', ');

      final message =
          '당신의 꿈에서 자주 나타나는 패턴: $signDescriptions\n\nReality Check를 수행하세요:\n• 손바닥 확인하기\n• 코를 막고 숨쉬기\n• 시계 두 번 보기';

      // 다음 2시간 후 알림 스케줄링 (Aspy et al. 2017 권장)
      await _scheduleNotification(
        id: 1001,
        title: '🌟 Reality Check 시간!',
        body: message,
        hoursFromNow: 2,
      );

      // 4시간 후 두 번째 알림
      await _scheduleNotification(
        id: 1002,
        title: '🌟 Reality Check 시간!',
        body: 'Reality Check를 꾸준히 수행하면 자각몽 가능성이 높아집니다!',
        hoursFromNow: 4,
      );

      debugPrint('✅ Reality Check 알림 스케줄링 완료 (2시간, 4시간 후)');
    } catch (e) {
      debugPrint('❌ Reality Check 알림 스케줄링 오류: $e');
    }
  }

  /// 기본 Reality Check 알림 (패턴이 감지되지 않은 경우)
  Future<void> _scheduleDefaultRealityCheckReminder() async {
    await _scheduleNotification(
      id: 1001,
      title: '🌟 Reality Check 시간!',
      body:
          'Reality Check를 수행하세요:\n• 손바닥 확인하기\n• 코를 막고 숨쉬기\n• 시계 두 번 보기\n\n자각몽 훈련의 핵심입니다!',
      hoursFromNow: 2,
    );
    debugPrint('✅ 기본 Reality Check 알림 스케줄링 완료');
  }

  /// 알림 스케줄링 헬퍼 메서드
  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hoursFromNow,
  }) async {
    final scheduledDate =
        tz.TZDateTime.now(tz.local).add(Duration(hours: hoursFromNow));

    const androidDetails = AndroidNotificationDetails(
      'reality_check_channel',
      'Reality Check',
      channelDescription: 'Reality Check 알림 (자각몽 훈련)',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      debugPrint('📬 알림 스케줄됨: $title ($hoursFromNow시간 후)');
    } catch (e) {
      debugPrint('❌ 알림 스케줄링 실패: $e');
      // 폴백: 즉시 알림
      await _notifications.show(
        id,
        title,
        body,
        notificationDetails,
      );
      debugPrint('📬 즉시 알림으로 폴백됨: $title');
    }
  }

  /// 모든 Reality Check 알림 취소
  Future<void> cancelAllRealityCheckNotifications() async {
    await _notifications.cancel(1001);
    await _notifications.cancel(1002);
    debugPrint('🔕 Reality Check 알림 모두 취소됨');
  }
}
