import 'package:flutter/material.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../utils/config/constants.dart';
import '../../../services/notification/notification_service.dart';

/// 알림 설정을 관리하는 위젯
///
/// 기능:
/// - 푸시 알림 권한 상태 표시
/// - 각종 알림 토글 (업적, 운동 리마인더, Chad 진화 등)
/// - 알림 시간 설정
/// - 권한 요청 및 상태 확인
class NotificationSettingsWidget extends StatelessWidget {
  final bool pushNotifications;
  final bool achievementNotifications;
  final bool workoutReminders;
  final bool chadEvolutionNotifications;
  final bool chadEvolutionPreviewNotifications;
  final bool chadEvolutionEncouragementNotifications;
  final bool workoutDaysOnlyNotifications;
  final TimeOfDay reminderTime;

  final ValueChanged<bool>? onPushNotificationsChanged;
  final ValueChanged<bool>? onAchievementNotificationsChanged;
  final ValueChanged<bool>? onWorkoutRemindersChanged;
  final ValueChanged<bool>? onChadEvolutionNotificationsChanged;
  final ValueChanged<bool>? onChadEvolutionPreviewNotificationsChanged;
  final ValueChanged<bool>? onChadEvolutionEncouragementNotificationsChanged;
  final ValueChanged<bool>? onWorkoutDaysOnlyNotificationsChanged;
  final ValueChanged<TimeOfDay>? onReminderTimeChanged;
  final VoidCallback? onShowPermissionRequestDialog;

  const NotificationSettingsWidget({
    super.key,
    required this.pushNotifications,
    required this.achievementNotifications,
    required this.workoutReminders,
    required this.chadEvolutionNotifications,
    required this.chadEvolutionPreviewNotifications,
    required this.chadEvolutionEncouragementNotifications,
    required this.workoutDaysOnlyNotifications,
    required this.reminderTime,
    this.onPushNotificationsChanged,
    this.onAchievementNotificationsChanged,
    this.onWorkoutRemindersChanged,
    this.onChadEvolutionNotificationsChanged,
    this.onChadEvolutionPreviewNotificationsChanged,
    this.onChadEvolutionEncouragementNotificationsChanged,
    this.onWorkoutDaysOnlyNotificationsChanged,
    this.onReminderTimeChanged,
    this.onShowPermissionRequestDialog,
  });

  @override
  Widget build(BuildContext context) {
    return _buildSettingsSection(
      AppLocalizations.of(context).notificationSettings,
      [
        // 알림 권한 상태 표시기
        _buildNotificationPermissionStatus(context),

        _buildNotificationToggle(
          context,
          AppLocalizations.of(context).pushNotifications,
          AppLocalizations.of(context).pushNotificationsDesc,
          pushNotifications,
          Icons.notifications,
          onPushNotificationsChanged,
        ),
        _buildNotificationToggle(
          context,
          AppLocalizations.of(context).achievementNotifications,
          AppLocalizations.of(context).achievementNotificationsDesc,
          achievementNotifications,
          Icons.emoji_events,
          onAchievementNotificationsChanged,
          enabled: pushNotifications,
        ),
        _buildNotificationToggle(
          context,
          AppLocalizations.of(context).workoutReminders,
          AppLocalizations.of(context).workoutRemindersDesc,
          workoutReminders,
          Icons.schedule,
          onWorkoutRemindersChanged,
          enabled: pushNotifications,
        ),

        // 운동 리마인더 시간 설정 (운동 리마인더가 켜져있을 때만 표시)
        if (workoutReminders && pushNotifications)
          _buildTimePickerSetting(
            context,
            AppLocalizations.of(context).reminderTime,
            AppLocalizations.of(context).reminderTimeDesc,
            reminderTime,
            Icons.access_time,
            onReminderTimeChanged,
          ),

        _buildNotificationToggle(
          context,
          AppLocalizations.of(context).chadEvolutionNotifications,
          AppLocalizations.of(context).chadEvolutionNotificationsDesc,
          chadEvolutionNotifications,
          Icons.trending_up,
          onChadEvolutionNotificationsChanged,
          enabled: pushNotifications,
        ),
        _buildNotificationToggle(
          context,
          AppLocalizations.of(context).chadEvolutionPreviewNotifications,
          AppLocalizations.of(context).chadEvolutionPreviewNotificationsDesc,
          chadEvolutionPreviewNotifications,
          Icons.preview,
          onChadEvolutionPreviewNotificationsChanged,
          enabled: pushNotifications && chadEvolutionNotifications,
        ),
        _buildNotificationToggle(
          context,
          AppLocalizations.of(context).chadEvolutionEncouragementNotifications,
          AppLocalizations.of(
            context,
          ).chadEvolutionEncouragementNotificationsDesc,
          chadEvolutionEncouragementNotifications,
          Icons.psychology,
          onChadEvolutionEncouragementNotificationsChanged,
          enabled: pushNotifications,
        ),
        _buildNotificationToggle(
          context,
          AppLocalizations.of(context).workoutDaysOnlyNotifications,
          AppLocalizations.of(context).workoutDaysOnlyNotificationsDesc,
          workoutDaysOnlyNotifications,
          Icons.today,
          onWorkoutDaysOnlyNotificationsChanged,
          enabled: pushNotifications && workoutReminders,
        ),
      ],
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(AppColors.primaryColor),
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildNotificationPermissionStatus(BuildContext context) {
    return FutureBuilder<Map<String, bool>>(
      future: _getNotificationPermissionStatus(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final permissions = snapshot.data!;
        final hasBasicNotifications = permissions['notifications'] ?? false;
        final hasExactAlarms = permissions['exactAlarms'] ?? false;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: hasBasicNotifications
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasBasicNotifications ? Colors.green : Colors.orange,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    hasBasicNotifications ? Icons.check_circle : Icons.warning,
                    color: hasBasicNotifications ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).notificationPermissionStatus,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildPermissionStatusRow(
                AppLocalizations.of(context).basicNotificationPermission,
                hasBasicNotifications,
                AppLocalizations.of(context).basicNotificationRequired,
                isRequired: true,
              ),
              const SizedBox(height: 8),
              _buildPermissionStatusRow(
                AppLocalizations.of(context).exactAlarmPermission,
                hasExactAlarms,
                AppLocalizations.of(context).exactAlarmRequired,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPermissionStatusRow(
    String title,
    bool granted,
    String description, {
    bool isRequired = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          granted ? Icons.check_circle : Icons.cancel,
          color: granted
              ? Colors.green
              : (isRequired ? Colors.red : Colors.orange),
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: granted
                          ? Colors.green[700]
                          : (isRequired ? Colors.red[700] : Colors.orange[700]),
                    ),
                  ),
                  if (isRequired) ...[
                    const SizedBox(width: 4),
                    Builder(
                      builder: (context) => Text(
                        AppLocalizations.of(context).required,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationToggle(
    BuildContext context,
    String title,
    String description,
    bool value,
    IconData icon,
    ValueChanged<bool>? onChanged, {
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: enabled ? const Color(AppColors.primaryColor) : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: enabled ? Colors.black87 : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: enabled ? Colors.grey[600] : Colors.grey[400],
            fontSize: 13,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: enabled ? onChanged : null,
          activeThumbColor: const Color(AppColors.primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      ),
    );
  }

  Widget _buildTimePickerSetting(
    BuildContext context,
    String title,
    String description,
    TimeOfDay time,
    IconData icon,
    ValueChanged<TimeOfDay>? onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: const Color(AppColors.primaryColor)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          description,
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            time.format(context),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(AppColors.primaryColor),
            ),
          ),
        ),
        onTap: () async {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: time,
          );
          if (pickedTime != null && onChanged != null) {
            onChanged(pickedTime);
          }
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      ),
    );
  }

  Future<Map<String, bool>> _getNotificationPermissionStatus() async {
    final notifications = await NotificationService.hasPermission();
    final exactAlarms = await NotificationService.canScheduleExactAlarms();

    return {'notifications': notifications, 'exactAlarms': exactAlarms};
  }
}
