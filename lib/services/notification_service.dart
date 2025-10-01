import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mission100/generated/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

/// Mission100 통합 알림 서비스
///
/// 개선된 권한 요청 시스템:
/// 1. 기본 알림 권한만 요청 → 바로 완료
/// 2. 정확한 알람 권한은 선택적으로 요청
/// 3. 완전한 폴백 시스템 (정확한 → 부정확한 → 즉시 알림)
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  // Android 12+ SCHEDULE_EXACT_ALARM 권한 확인을 위한 MethodChannel
  static const MethodChannel _channel = MethodChannel(
    'com.misson100.notification_permissions',
  );

  /// Android 12+에서 SCHEDULE_EXACT_ALARM 권한이 있는지 확인
  static Future<bool> canScheduleExactAlarms() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return true; // iOS는 권한 필요 없음
    }

    try {
      final bool? canSchedule = await _channel.invokeMethod(
        'canScheduleExactAlarms',
      );
      debugPrint('🔔 SCHEDULE_EXACT_ALARM 권한 상태: $canSchedule');
      return canSchedule ?? false;
    } on PlatformException catch (e) {
      debugPrint('❌ SCHEDULE_EXACT_ALARM 권한 확인 오류: ${e.message}');
      // Android 12 미만이면 true 반환 (권한 필요 없음)
      return true;
    }
  }

  /// Android 12+에서 SCHEDULE_EXACT_ALARM 권한 요청
  static Future<bool> requestExactAlarmPermission() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return true; // iOS는 권한 필요 없음
    }

    try {
      debugPrint('🔔 SCHEDULE_EXACT_ALARM 권한 요청 시작...');
      final bool? granted = await _channel.invokeMethod(
        'requestExactAlarmPermission',
      );
      debugPrint('🔔 SCHEDULE_EXACT_ALARM 권한 요청 결과: $granted');

      // 설정 화면으로 이동한 후 충분한 시간 대기
      await Future<void>.delayed(const Duration(seconds: 2));

      // 실제 권한 상태를 다시 확인 (사용자가 허용했는지 확인)
      final actualPermission = await canScheduleExactAlarms();
      debugPrint('🔔 SCHEDULE_EXACT_ALARM 실제 권한 상태: $actualPermission');

      return actualPermission;
    } on PlatformException catch (e) {
      debugPrint('❌ SCHEDULE_EXACT_ALARM 권한 요청 오류: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('❌ SCHEDULE_EXACT_ALARM 권한 요청 일반 오류: $e');
      return false;
    }
  }

  /// 안전한 알림 스케줄링 (권한 확인 포함)
  static Future<bool> _safeScheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required NotificationDetails notificationDetails,
  }) async {
    try {
      // Android 12+에서 정확한 알람 권한 확인
      if (defaultTargetPlatform == TargetPlatform.android) {
        final canSchedule = await canScheduleExactAlarms();

        if (!canSchedule) {
          debugPrint('⚠️ SCHEDULE_EXACT_ALARM 권한이 없어 부정확한 알림 방식 사용');
          // 권한이 없으면 부정확한 알림 스케줄링 사용
          return await scheduleInexactNotification(
            id: id,
            title: title,
            body: body,
            scheduledDate: scheduledDate,
            notificationDetails: notificationDetails,
          );
        }
      }

      // 권한이 있으면 정확한 시간에 스케줄링
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      debugPrint('✅ 정확한 알림 스케줄링 성공: $title (${scheduledDate.toString()})');
      return true;
    } catch (e) {
      debugPrint('❌ 정확한 알림 스케줄링 실패: $e');

      // 실패 시 부정확한 알림으로 대체
      try {
        return await scheduleInexactNotification(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduledDate,
          notificationDetails: notificationDetails,
        );
      } catch (fallbackError) {
        debugPrint('❌ 부정확한 알림 대체도 실패: $fallbackError');

        // 최후 수단: 즉시 알림 표시
        try {
          await _notifications.show(id, title, body, notificationDetails);
          debugPrint('🔄 최후 수단으로 즉시 알림 표시');
          return false;
        } catch (immediateError) {
          debugPrint('❌ 즉시 알림도 실패: $immediateError');
          return false;
        }
      }
    }
  }

  /// 알림 서비스 초기화
  static Future<void> initialize() async {
    if (_isInitialized) return;

    // 타임존 초기화
    tz.initializeTimeZones();

    // Android 초기화 설정
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');

    // iOS 초기화 설정
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
  }

  /// 사용자 친화적 권한 요청 다이얼로그 표시
  static Future<bool> showPermissionRequestDialog(BuildContext context) async {
    if (!context.mounted) return false;

    // 현재 권한 상태 확인
    final hasNotificationPermission = await _hasNotificationPermission();
    final hasExactAlarmPermission = await canScheduleExactAlarms();

    // 기본 알림 권한만 있어도 작동하도록 변경
    if (hasNotificationPermission) {
      debugPrint('✅ 기본 알림 권한 있음 - 바로 진행');
      // 정확한 알람이 없어도 기본 알림으로 작동
      if (!hasExactAlarmPermission) {
        _showExactAlarmInfo(context);
      }
      return true;
    }

    // 권한 요청 다이얼로그 표시
    final shouldRequest = await showDialog<bool>(
      context: context,
      barrierDismissible: true, // 사용자가 취소할 수 있도록
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.security, color: Color(0xFF4DABF7)),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context).notificationActivationTitle),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).notificationActivationMessage,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                if (!hasNotificationPermission)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.notifications,
                            color: Colors.blue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(
                                context,
                              ).workoutNotificationPermission,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 28),
                        child: Text(
                          AppLocalizations.of(context).dailyWorkoutAlarm,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '💡 기본 알림만으로도 CHAD 될 수 있다!\n하지만 LEGENDARY CHAD는 모든 권한 허용! DOMINATION! 🚀',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                AppLocalizations.of(context).laterWeak,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4DABF7),
                foregroundColor: Colors.white,
              ),
              child: Text(
                AppLocalizations.of(context).enableChadNotifications,
              ),
            ),
          ],
        );
      },
    );

    if (shouldRequest != true) return false;

    // 실제 권한 요청 수행 (기본 알림만 우선)
    final basicGranted = await _requestBasicNotificationPermission();

    if (basicGranted) {
      // 기본 알림 권한이 있으면 성공으로 처리
      if (!hasExactAlarmPermission) {
        // 정확한 알람 권한은 선택적으로 요청
        _requestExactAlarmOptionally(context);
      }
      return true;
    }

    return false;
  }

  /// 기본 알림 권한만 요청 (사용자 친화적)
  static Future<bool> _requestBasicNotificationPermission() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        // Android - permission_handler 사용
        final status = await Permission.notification.request();
        final granted = status.isGranted;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('notification_permission_granted', granted);

        debugPrint('📱 Android 기본 알림 권한: $granted');
        return granted;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        // iOS - flutter_local_notifications 사용
        final granted = await _notifications
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(
          'notification_permission_granted',
          granted ?? false,
        );

        debugPrint('🍎 iOS 기본 알림 권한: $granted');
        return granted ?? false;
      }
    } catch (e) {
      debugPrint('❌ 기본 알림 권한 요청 실패: $e');
    }

    return false;
  }

  /// 정확한 알람 권한을 선택적으로 요청
  static Future<void> _requestExactAlarmOptionally(BuildContext context) async {
    // 백그라운드에서 정확한 알람 권한 요청
    Future.delayed(const Duration(seconds: 1), () async {
      if (!context.mounted) return;

      final shouldRequest = await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).legendaryChadModeUpgrade),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context).legendaryModeDescription,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context).legendaryModeOptional,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(AppLocalizations.of(context).laterBasicChad),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4DABF7),
                  foregroundColor: Colors.white,
                ),
                child: Text(AppLocalizations.of(context).legendaryModeOn),
              ),
            ],
          );
        },
      );

      if (shouldRequest == true) {
        await requestExactAlarmPermission();
      }
    });
  }

  /// 정확한 알람 권한 설명 토스트 표시
  static void _showExactAlarmInfo(BuildContext context) {
    // 간단한 정보 메시지 표시
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).chadModeActivated),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  /// 기본 알림 권한이 있는지 확인
  static Future<bool> _hasNotificationPermission() async {
    await initialize();

    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        // Android에서는 권한 상태를 직접 확인하기 어려우므로
        // SharedPreferences에 저장된 상태를 확인
        final prefs = await SharedPreferences.getInstance();
        return prefs.getBool('notification_permission_granted') ?? false;
      }
    }

    return true; // iOS는 기본적으로 true로 가정
  }

  /// 부정확한 알림 스케줄링 (SCHEDULE_EXACT_ALARM 권한이 없을 때 사용)
  static Future<bool> scheduleInexactNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required NotificationDetails notificationDetails,
  }) async {
    try {
      debugPrint('📅 부정확한 알림 스케줄링 시도: $title');

      // 예약 시간까지의 지연 시간 계산
      final now = DateTime.now();
      final delay = scheduledDate.difference(now);

      if (delay.isNegative) {
        // 과거 시간이면 즉시 표시
        await _notifications.show(id, title, body, notificationDetails);
        debugPrint('⚡ 과거 시간이므로 즉시 알림 표시');
        return true;
      }

      // 30분 이내면 정확한 스케줄링 시도 (시스템이 허용할 가능성 높음)
      if (delay.inMinutes <= 30) {
        try {
          await _notifications.zonedSchedule(
            id,
            title,
            body,
            tz.TZDateTime.from(scheduledDate, tz.local),
            notificationDetails,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          );
          debugPrint('✅ 30분 이내 정확한 스케줄링 성공');
          return true;
        } catch (e) {
          debugPrint('⚠️ 30분 이내 정확한 스케줄링 실패, 부정확한 방법 사용: $e');
        }
      }

      // 긴 지연시간의 경우 즉시 알림으로 대체
      await _notifications.show(id, title, body, notificationDetails);
      debugPrint('🔄 긴 지연시간으로 즉시 알림 표시');

      return true;
    } catch (e) {
      debugPrint('❌ 부정확한 알림 스케줄링 실패: $e');
      return false;
    }
  }

  /// 요일별 운동 알림 설정 (무한 반복)
  static Future<void> scheduleDailyWorkoutReminder({
    required TimeOfDay time,
    Set<int>? activeDays, // 1=월, 2=화, ..., 7=일
    String title = '🔥 WORKOUT TIME! 지금 당장! 만삣삐! 🔥',
    String body = '💪 MISSION 100 운동 시간! LEGENDARY CHAD MODE 활성화! 💪',
  }) async {
    await initialize();

    // 기존 모든 운동 알림 취소
    await _cancelWorkoutReminders();

    final selectedDays = activeDays ?? {1, 2, 3, 4, 5}; // 기본: 월-금
    final now = DateTime.now();

    debugPrint(
      '🔔 요일별 운동 알림 설정 시작: ${selectedDays.map(_getWeekdayName).join(', ')} ${time.hour}:${time.minute.toString().padLeft(2, '0')}',
    );

    // 다음 30일간의 알림을 스케줄링 (충분히 긴 기간)
    int scheduledCount = 0;
    for (int i = 0; i < 30; i++) {
      final targetDate = now.add(Duration(days: i));

      // 해당 요일이 활성화되어 있는지 확인
      if (!selectedDays.contains(targetDate.weekday)) {
        continue;
      }

      final scheduledDate = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        time.hour,
        time.minute,
      );

      // 오늘 시간이 이미 지났다면 건너뛰기
      if (i == 0 && scheduledDate.isBefore(now)) {
        continue;
      }

      // 각 날짜별로 고유한 알림 ID 사용 (1000 + 일수)
      final notificationId = 1000 + i;

      await _safeScheduleNotification(
        id: notificationId,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'workout_reminders',
            'Workout Reminders',
            channelDescription: '요일별 운동 알림',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@drawable/ic_notification',
            sound:
                const RawResourceAndroidNotificationSound('notification_sound'),
            playSound: true,
            enableVibration: true,
            vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
      scheduledCount++;
    }

    // 25일 후 자동 갱신을 위한 알림 설정 (무한 반복을 위해)
    await _scheduleReminderRenewal(time, selectedDays);

    // 설정된 정보 저장
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notification_hour', time.hour);
    await prefs.setInt('notification_minute', time.minute);
    await prefs.setBool('daily_notification_enabled', true);
    await prefs.setStringList(
      'active_workout_days',
      selectedDays.map((e) => e.toString()).toList(),
    );

    final dayNames = selectedDays.map(_getWeekdayName).join(', ');
    debugPrint(
      '✅ 요일별 운동 알림 설정 완료: $dayNames ${time.hour}:${time.minute.toString().padLeft(2, '0')} ($scheduledCount개 알림 예약)',
    );
  }

  /// 25일 후 자동 갱신을 위한 알림 설정
  static Future<void> _scheduleReminderRenewal(
    TimeOfDay time,
    Set<int> activeDays,
  ) async {
    final renewalDate = DateTime.now().add(
      const Duration(days: 25),
    ); // 25일 후 갱신
    const renewalNotificationId = 9999;

    // 갱신용 데이터를 페이로드에 포함
    final payload =
        'renewal|${time.hour}|${time.minute}|${activeDays.join(',')}';

    await _safeScheduleNotification(
      id: renewalNotificationId,
      title: '⏰ 운동 리마인더 자동 갱신',
      body: '운동 리마인더가 자동으로 갱신되었습니다. 계속해서 건강한 운동 습관을 유지하세요! 💪',
      scheduledDate: renewalDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'system_reminders',
          'System Reminders',
          channelDescription: '시스템 자동 갱신 알림',
          importance: Importance.low,
          priority: Priority.low,
          showWhen: false,
          silent: true,
        ),
      ),
    );

    debugPrint('🔄 25일 후 자동 갱신 알림 설정 완료');
  }

  /// 운동 알림만 취소
  static Future<void> _cancelWorkoutReminders() async {
    // 1000-1030 범위의 운동 알림들 취소
    for (int i = 1000; i <= 1030; i++) {
      await _notifications.cancel(i);
    }
    // 갱신 알림도 취소
    await _notifications.cancel(9999);
    debugPrint('🗑️ 기존 운동 알림들 모두 취소 완료');
  }

  /// 요일 이름 반환
  static String _getWeekdayName(int weekday) {
    const names = ['월', '화', '수', '목', '금', '토', '일'];
    if (weekday < 1 || weekday > 7) return '';
    return names[weekday - 1];
  }

  /// 업적 달성 알림
  static Future<void> showAchievementNotification(
    String title,
    String description,
  ) async {
    await _safeScheduleNotification(
      id: 3, // 업적 알림 ID
      title: '🏆 ACHIEVEMENT UNLOCKED! 만삣삐! 🏆',
      body: '🔥 $title: $description FXXK YEAH! LEGENDARY CHAD! 🔥',
      scheduledDate: DateTime.now(),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'achievements',
          'Achievements',
          channelDescription: '업적 달성 알림',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
          sound:
              const RawResourceAndroidNotificationSound('notification_sound'),
          playSound: true,
          enableVibration: true,
          vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
        ),
        iOS: const DarwinNotificationDetails(
          sound: 'notification_sound.aiff',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  /// 휴식일 알림
  static Future<void> showRestDayNotification() async {
    await initialize();

    const restMessages = [
      '😴 내일은 휴식일! CHAD도 쉬어야 강해진다! 💪',
      '🌙 LEGENDARY CHAD는 회복의 중요성을 안다! 내일은 쉬는 날! 💤',
      '🛏️ BEAST MODE는 휴식에서 태어난다! 내일은 충전 타임! ⚡',
      '🧘‍♂️ 진정한 GIGACHAD는 언제 쉴지 안다! 내일은 회복일! 🌱',
      '🏖️ 휴식은 약함이 아니라 전략이다! CHAD의 지혜! 🧠',
    ];

    final randomMessage =
        restMessages[DateTime.now().millisecond % restMessages.length];

    await _safeScheduleNotification(
      id: 4, // 휴식일 알림 ID
      title: '😴 REST DAY TOMORROW! 만삣삐! 💤',
      body: randomMessage,
      scheduledDate: DateTime.now(),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'rest_day',
          'Rest Day Notifications',
          channelDescription: '휴식일 알림',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
          sound:
              const RawResourceAndroidNotificationSound('notification_sound'),
          playSound: true,
          enableVibration: true,
          vibrationPattern: Int64List.fromList([0, 300, 100, 300]),
        ),
        iOS: const DarwinNotificationDetails(
          sound: 'notification_sound.aiff',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );

    debugPrint('😴 휴식일 알림 전송 완료! CHAD의 회복 타임! 💪');
  }

  /// 운동 완료 축하 알림
  static Future<void> showWorkoutCompletionCelebration({
    required int totalReps,
    required double completionRate,
  }) async {
    await initialize();

    String title = '🔥 WORKOUT DEMOLISHED! 만삣삐! 🔥';
    String body =
        '$totalReps REPS DESTROYED! ${(completionRate * 100).toInt()}% DOMINATION! FXXK YEAH!';

    if (completionRate >= 1.0) {
      title = '🚀 PERFECT EXECUTION! LEGENDARY CHAD! 🚀';
      body =
          '100% TARGET ANNIHILATED! TRUE GIGACHAD CONFIRMED! ULTRA BEAST MODE ACTIVATED! 만삣삐! 💀💪';
    } else if (completionRate >= 0.8) {
      title = '⚡ EXCELLENT DESTRUCTION! RISING CHAD! ⚡';
      body =
          '목표의 ${(completionRate * 100).toInt()}% 파괴! CHAD의 길을 걷고 있다! KEEP GRINDING! 🔥💪';
    } else if (completionRate >= 0.6) {
      title = '💪 SOLID EFFORT! FUTURE CHAD! 💪';
      body =
          '${(completionRate * 100).toInt()}% 달성! 아직 갈 길이 멀지만 CHAD의 DNA가 깨어나고 있다! 🌱';
    } else {
      title = '😤 CHAD JOURNEY BEGINS! 💥';
      body =
          '${(completionRate * 100).toInt()}% 완료! 모든 LEGENDARY CHAD도 여기서 시작했다! NEVER GIVE UP! 🔥';
    }

    await _safeScheduleNotification(
      id: 5, // 운동 완료 알림 ID
      title: title,
      body: body,
      scheduledDate: DateTime.now(),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'workout_completion',
          'Workout Completion',
          channelDescription: '운동 완료 축하 알림',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
          sound:
              const RawResourceAndroidNotificationSound('notification_sound'),
          playSound: true,
          enableVibration: true,
          vibrationPattern: Int64List.fromList([0, 1000, 300, 1000, 300, 1000]),
        ),
        iOS: const DarwinNotificationDetails(
          sound: 'notification_sound.aiff',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );

    debugPrint('🎉 운동 완료 축하 알림 전송! FXXK YEAH! 💪');
  }

  /// 모든 알림 취소
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_notification_enabled', false);
  }

  /// 알림 탭 시 처리
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('알림 탭됨: ${response.payload}');
    // 필요시 특정 화면으로 네비게이션 처리
  }

  /// 알림 권한이 있는지 확인 (기존 호환성 메소드)
  static Future<bool> hasPermission() async {
    try {
      final hasBasicPermission = await _hasNotificationPermission();
      final hasExactAlarms = await canScheduleExactAlarms();

      // 기본 알림만 있어도 충분하다고 판단
      return hasBasicPermission;
    } catch (e) {
      debugPrint('권한 확인 오류: $e');
      return false;
    }
  }

  /// 알림 채널 생성 (Android)
  static Future<void> createNotificationChannels() async {
    try {
      await initialize();

      // Android 알림 채널 생성
      if (defaultTargetPlatform == TargetPlatform.android) {
        const AndroidNotificationChannel workoutChannel =
            AndroidNotificationChannel(
          'workout_reminders',
          'Workout Reminders',
          description: 'Notifications for workout reminders',
          importance: Importance.high,
          playSound: true,
        );

        const AndroidNotificationChannel achievementChannel =
            AndroidNotificationChannel(
          'achievements',
          'Achievements',
          description: 'Notifications for unlocked achievements',
          importance: Importance.high,
          playSound: true,
        );

        const AndroidNotificationChannel chadEvolutionChannel =
            AndroidNotificationChannel(
          'chad_evolution',
          'Chad Evolution',
          description: 'Notifications for Chad evolution',
          importance: Importance.high,
          playSound: true,
        );

        final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
            _notifications.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

        if (androidPlugin != null) {
          await androidPlugin.createNotificationChannel(workoutChannel);
          await androidPlugin.createNotificationChannel(achievementChannel);
          await androidPlugin.createNotificationChannel(chadEvolutionChannel);
          debugPrint('✅ Android 알림 채널 생성 완료');
        }
      }

      debugPrint('✅ 알림 채널 생성 완료');
    } catch (e) {
      debugPrint('❌ 알림 채널 생성 실패: $e');
    }
  }

  /// 앱 재시작 시 권한 재확인
  static Future<void> recheckPermissionsOnResume() async {
    try {
      final hasPermission = await _hasNotificationPermission();
      debugPrint('🔄 권한 재확인: $hasPermission');
    } catch (e) {
      debugPrint('❌ 권한 재확인 실패: $e');
    }
  }

  /// 알림 설정 화면 열기
  static Future<void> openNotificationSettings() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _channel.invokeMethod('openNotificationSettings');
      }
    } catch (e) {
      debugPrint('❌ 알림 설정 화면 열기 실패: $e');
    }
  }

  /// 기본 권한 요청
  static Future<bool> requestPermissions() async {
    return await _requestBasicNotificationPermission();
  }

  /// CHAD 진화 최종 알림
  static Future<void> showChadFinalEvolutionNotification() async {
    await _safeScheduleNotification(
      id: 4,
      title: '🚀 ULTIMATE CHAD EVOLUTION! 🚀',
      body: '🏆 전설의 차드가 되었습니다! LEGENDARY BEAST MODE! 만삣삐! 🏆',
      scheduledDate: DateTime.now(),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'chad_evolution',
          'Chad Evolution',
          channelDescription: '차드 진화 알림',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  /// CHAD 진화 알림
  static Future<void> showChadEvolutionNotification(
    String level,
    String message,
  ) async {
    await _safeScheduleNotification(
      id: 5,
      title: '💪 CHAD EVOLUTION! $level 💪',
      body: '🔥 $message FXXK YEAH! 만삣삐! 🔥',
      scheduledDate: DateTime.now(),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'chad_evolution',
          'Chad Evolution',
          channelDescription: '차드 진화 알림',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  /// CHAD 진화 미리보기 알림
  static Future<void> showChadEvolutionPreview(
    String nextLevel,
    String requirement,
  ) async {
    await _safeScheduleNotification(
      id: 6,
      title: '👀 NEXT CHAD LEVEL PREVIEW! 👀',
      body: '🚀 다음 단계: $nextLevel | 필요조건: $requirement 💪',
      scheduledDate: DateTime.now(),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'chad_evolution',
          'Chad Evolution',
          channelDescription: '차드 진화 알림',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  /// CHAD 진화 격려 알림
  static Future<void> showChadEvolutionEncouragement(String message) async {
    await _safeScheduleNotification(
      id: 7,
      title: '🔥 CHAD MOTIVATION! 🔥',
      body: '💪 $message KEEP GOING! 만삣삐! 💪',
      scheduledDate: DateTime.now(),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'chad_evolution',
          'Chad Evolution',
          channelDescription: '차드 진화 알림',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  /// 오늘의 운동 알림 취소
  static Future<void> cancelTodayWorkoutReminder() async {
    await _notifications.cancel(1000); // 오늘의 운동 알림 ID
    debugPrint('✅ 오늘의 운동 알림 취소');
  }

  /// 연속 운동 격려 알림
  static Future<void> showStreakEncouragement(int streak) async {
    await _safeScheduleNotification(
      id: 8,
      title: '🔥 STREAK POWER! $streak일 연속! 🔥',
      body: '💪 연속 $streak일 달성! LEGENDARY CONSISTENCY! 만삣삐! 💪',
      scheduledDate: DateTime.now(),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'streak',
          'Workout Streak',
          channelDescription: '연속 운동 격려 알림',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  /// 대기 중인 알림 확인
  static Future<void> checkPendingNotifications() async {
    try {
      final pendingNotifications =
          await _notifications.pendingNotificationRequests();
      debugPrint('📋 대기 중인 알림: ${pendingNotifications.length}개');
    } catch (e) {
      debugPrint('❌ 대기 중인 알림 확인 실패: $e');
    }
  }

  /// 운동 알림 스케줄링 (호환성 메소드 - 매개변수 없음)
  static Future<void> scheduleWorkoutReminder([
    TimeOfDay? time,
    Set<int>? activeDays,
  ]) async {
    final reminderTime =
        time ?? const TimeOfDay(hour: 18, minute: 0); // 기본값: 오후 6시
    final selectedDays = activeDays ?? {1, 2, 3, 4, 5}; // 기본값: 월-금
    await scheduleDailyWorkoutReminder(
      time: reminderTime,
      activeDays: selectedDays,
    );
  }

  /// 운동 알림 취소
  static Future<void> cancelWorkoutReminder() async {
    await cancelAllNotifications();
  }

  /// 구독 관리용 간단한 알림 표시
  Future<void> showNotification({
    required String title,
    required String body,
    int? id,
  }) async {
    try {
      if (!_isInitialized) {
        debugPrint('NotificationService가 초기화되지 않음');
        return;
      }

      final notificationId = id ?? Random().nextInt(1000000);

      await _notifications.show(
        notificationId,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'subscription_channel',
            '구독 알림',
            channelDescription: '구독 관련 알림을 표시합니다',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );

      debugPrint('NotificationService: 알림 표시됨 - $title');
    } catch (e) {
      debugPrint('NotificationService: 알림 표시 실패 - $e');
      rethrow;
    }
  }
}
