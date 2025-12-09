import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../services/notification/notification_service.dart';
import 'settings_card_widget.dart';

/// 알림 설정 섹션 위젯
///
/// 푸시 알림, 운동 리마인더, 업적 알림 설정
class NotificationSettingsSection extends StatelessWidget {
  final bool pushNotifications;
  final bool workoutReminders;
  final TimeOfDay reminderTime;
  final Function(bool) onPushNotificationsChanged;
  final Function(bool) onWorkoutRemindersChanged;
  final Function(String) showSnackBar;

  const NotificationSettingsSection({
    super.key,
    required this.pushNotifications,
    required this.workoutReminders,
    required this.reminderTime,
    required this.onPushNotificationsChanged,
    required this.onWorkoutRemindersChanged,
    required this.showSnackBar,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SettingsCardWidget(
      children: [
        SwitchListTile(
          title: Text(l10n.pushNotifications),
          subtitle: Text(l10n.receiveGeneralNotifications),
          value: pushNotifications,
          onChanged: onPushNotificationsChanged,
        ),
        const Divider(height: 1),
        SwitchListTile(
          title: Text(l10n.workoutReminder),
          subtitle: Text(
            l10n.dailyReminderAt(reminderTime.format(context)),
          ),
          value: workoutReminders,
          onChanged: (value) async {
            onWorkoutRemindersChanged(value);

            // 실제 알림 스케줄링 처리
            if (value && pushNotifications) {
              await NotificationService.scheduleWorkoutReminder(reminderTime);
            } else {
              await NotificationService.cancelWorkoutReminder();
            }
          },
        ),
        const Divider(height: 1),
        SwitchListTile(
          title: Text(l10n.achievementNotifications),
          subtitle: Text(l10n.receiveAchievementNotifications),
          value: true,
          onChanged: (bool value) {
            showSnackBar(l10n.achievementNotificationsAlwaysOn);
          },
        ),
      ],
    );
  }
}
