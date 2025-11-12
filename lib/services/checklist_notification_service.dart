import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../utils/checklist_data.dart';

/// Checklist Notification Service
/// Handles multi-time notifications for daily checklist items
class ChecklistNotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize notification service
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  /// Schedule all checklist notifications
  Future<void> scheduleAllNotifications() async {
    await _notifications.cancelAll();

    for (var item in ChecklistData.dailyChecklist) {
      if (item.defaultTime != null) {
        await _scheduleNotification(
          id: item.id.hashCode,
          time: item.defaultTime!,
          title: '⏰ ${item.nameKo}',
          body: item.description,
        );
      }

      // Special: Reality Check - multiple notifications
      if (item.id == 'reality_check_2hr' && item.countRequired != null) {
        await _scheduleRealityCheckNotifications(
          count: item.countRequired!,
          intervalMinutes: item.intervalMinutes ?? 120,
        );
      }
    }
  }

  /// Schedule reality check notifications every N minutes
  Future<void> _scheduleRealityCheckNotifications({
    required int count,
    required int intervalMinutes,
  }) async {
    // Default times: 09:00, 11:00, 13:00, 15:00, 17:00
    final times = ['09:00', '11:00', '13:00', '15:00', '17:00'];

    for (int i = 0; i < count && i < times.length; i++) {
      await _scheduleNotification(
        id: 1000 + i,
        time: times[i],
        title: '👁️ 현실 확인 시간',
        body: 'Reality Check를 실천하세요 (${i + 1}/$count)',
      );
    }
  }

  /// Schedule a single notification at specific time
  Future<void> _scheduleNotification({
    required int id,
    required String time,
    required String title,
    required String body,
  }) async {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'checklist_channel',
          'Daily Checklist',
          channelDescription: 'Notifications for daily checklist items',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Get next instance of specific time
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
