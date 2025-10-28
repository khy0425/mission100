import 'package:flutter/material.dart';

/// 운동 알림 설정 섹션
class ReminderSettingsSection extends StatelessWidget {
  final bool notificationsEnabled;
  final TimeOfDay notificationTime;
  final Function(bool) onNotificationToggle;
  final VoidCallback onTimeSelect;
  final String Function() formatTime;

  const ReminderSettingsSection({
    super.key,
    required this.notificationsEnabled,
    required this.notificationTime,
    required this.onNotificationToggle,
    required this.onTimeSelect,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_active,
                color: Colors.blue[700],
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                Localizations.localeOf(context).languageCode == 'ko'
                    ? '운동 알림 설정'
                    : 'Workout Notifications',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 알림 on/off 스위치
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: notificationsEnabled
                  ? Colors.blue.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: notificationsEnabled
                    ? Colors.blue.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  notificationsEnabled
                      ? Icons.notifications
                      : Icons.notifications_off,
                  color: notificationsEnabled
                      ? Colors.blue[700]
                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Localizations.localeOf(context).languageCode == 'ko'
                            ? '운동 알림 받기'
                            : 'Enable Workout Reminders',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: notificationsEnabled
                                  ? Colors.blue[700]
                                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                      ),
                      Text(
                        Localizations.localeOf(context).languageCode == 'ko'
                            ? '선택한 운동일에 알림을 받습니다'
                            : 'Get reminders on your workout days',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: notificationsEnabled,
                  onChanged: onNotificationToggle,
                  activeThumbColor: Colors.blue[700],
                ),
              ],
            ),
          ),

          // 알림 시간 설정 (알림이 켜져있을 때만 표시)
          if (notificationsEnabled) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: InkWell(
                onTap: onTimeSelect,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.orange,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Localizations.localeOf(context).languageCode ==
                                      'ko'
                                  ? '알림 시간'
                                  : 'Notification Time',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange,
                                  ),
                            ),
                            Text(
                              formatTime(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[800],
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.edit, color: Colors.orange, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // 정보 메시지
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    Localizations.localeOf(context).languageCode == 'ko'
                        ? '💡 설정 탭에서 언제든지 변경할 수 있습니다'
                        : '💡 You can change these settings anytime in Settings',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
