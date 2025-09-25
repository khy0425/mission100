import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mission100/generated/app_localizations.dart';
import '../services/notification_service.dart';
import 'workout_reminder_settings_screen.dart';

class SimpleSettingsScreen extends StatefulWidget {
  const SimpleSettingsScreen({super.key});

  @override
  State<SimpleSettingsScreen> createState() => _SimpleSettingsScreenState();
}

class _SimpleSettingsScreenState extends State<SimpleSettingsScreen> {
  bool _pushNotifications = true;
  bool _workoutReminders = true;
  bool _darkMode = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 18, minute: 0); // 기본 오후 6시

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // 리마인더 시간 로드
    final timeString = prefs.getString('reminder_time') ?? '18:00';
    final timeParts = timeString.split(':');
    final hour = int.tryParse(timeParts[0]) ?? 18;
    final minute = int.tryParse(timeParts[1]) ?? 0;

    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _workoutReminders = prefs.getBool('workout_reminders') ?? true;
      _darkMode = prefs.getBool('dark_mode') ?? false;
      _reminderTime = TimeOfDay(hour: hour, minute: minute);
    });
  }

  Future<void> _saveBoolSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        backgroundColor: isDark ? Colors.grey[900] : Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: isDark
                  ? LinearGradient(
                      colors: [Colors.grey[800]!, Colors.grey[700]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [const Color(0xFF2196F3), const Color(0xFF1976D2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.settings,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.mission100Settings,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.customizeAppFeatures,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 알림 설정
            _buildSectionHeader(AppLocalizations.of(context)!.notificationSettings, Icons.notifications),
            const SizedBox(height: 8),
            _buildSettingsCard([
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.pushNotifications),
                subtitle: Text(AppLocalizations.of(context)!.receiveGeneralNotifications),
                value: _pushNotifications,
                onChanged: (bool value) async {
                  setState(() {
                    _pushNotifications = value;
                  });
                  await _saveBoolSetting('push_notifications', value);
                  _showSnackBar(
                    value ? AppLocalizations.of(context)!.pushNotificationEnabled : AppLocalizations.of(context)!.pushNotificationDisabled,
                  );
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.workoutReminder),
                subtitle: Text(AppLocalizations.of(context)!.dailyReminderAt(_reminderTime.format(context))),
                value: _workoutReminders,
                onChanged: (bool value) async {
                  setState(() {
                    _workoutReminders = value;
                  });
                  await _saveBoolSetting('workout_reminders', value);

                  // 실제 알림 스케줄링 처리
                  if (value && _pushNotifications) {
                    await NotificationService.scheduleWorkoutReminder(_reminderTime);
                  } else {
                    await NotificationService.cancelWorkoutReminder();
                  }

                  _showSnackBar(
                    value ? AppLocalizations.of(context)!.workoutReminderEnabled : AppLocalizations.of(context)!.workoutReminderDisabled,
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.schedule),
                title: Text(AppLocalizations.of(context)!.detailedReminderSettings),
                subtitle: Text(AppLocalizations.of(context)!.weeklyWorkoutSchedule),
                trailing: const Icon(Icons.chevron_right),
                onTap: _workoutReminders ? _openReminderSettings : null,
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.achievementNotifications),
                subtitle: Text(AppLocalizations.of(context)!.receiveAchievementNotifications),
                value: true,
                onChanged: (bool value) {
                  _showSnackBar(AppLocalizations.of(context)!.achievementNotificationsAlwaysOn);
                },
              ),
            ]),

            const SizedBox(height: 20),

            // 외관 설정
            _buildSectionHeader(AppLocalizations.of(context)!.appearanceSettings, Icons.palette),
            const SizedBox(height: 8),
            _buildSettingsCard([
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.darkMode),
                subtitle: Text(AppLocalizations.of(context)!.useDarkTheme),
                value: _darkMode,
                onChanged: (bool value) async {
                  setState(() {
                    _darkMode = value;
                  });
                  await _saveBoolSetting('dark_mode', value);
                  _showSnackBar(
                    AppLocalizations.of(context)!.themeChangeAfterRestart,
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(AppLocalizations.of(context)!.languageSettings),
                subtitle: Text(AppLocalizations.of(context)!.korean),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showSnackBar(AppLocalizations.of(context)!.languageSettingsComingSoon);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.fitness_center),
                title: Text(AppLocalizations.of(context)!.difficultySettings),
                subtitle: Text(AppLocalizations.of(context)!.beginnerMode),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showSnackBar(AppLocalizations.of(context)!.difficultySettingsComingSoon);
                },
              ),
            ]),

            const SizedBox(height: 20),

            // 데이터 관리
            _buildSectionHeader(AppLocalizations.of(context)!.dataManagement, Icons.storage),
            const SizedBox(height: 8),
            _buildSettingsCard([
              ListTile(
                leading: const Icon(Icons.backup),
                title: Text(AppLocalizations.of(context)!.dataBackup),
                subtitle: Text(AppLocalizations.of(context)!.backupWorkoutRecords),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showSnackBar(AppLocalizations.of(context)!.dataBackupComingSoon);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.restore),
                title: Text(AppLocalizations.of(context)!.dataRestore),
                subtitle: Text(AppLocalizations.of(context)!.restoreBackupData),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showSnackBar(AppLocalizations.of(context)!.dataRestoreComingSoon);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: Text(AppLocalizations.of(context)!.dataReset, style: const TextStyle(color: Colors.red)),
                subtitle: Text(AppLocalizations.of(context)!.deleteAllWorkoutRecords),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showSnackBar(AppLocalizations.of(context)!.dataResetComingSoon);
                },
              ),
            ]),

            const SizedBox(height: 20),

            // 앱 정보
            _buildSectionHeader(AppLocalizations.of(context)!.appInfo, Icons.info),
            const SizedBox(height: 8),
            _buildSettingsCard([
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(AppLocalizations.of(context)!.version),
                subtitle: const Text('1.0.0'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.code),
                title: Text(AppLocalizations.of(context)!.developer),
                subtitle: Text(AppLocalizations.of(context)!.mission100Team),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.description),
                title: Text(AppLocalizations.of(context)!.license),
                subtitle: Text(AppLocalizations.of(context)!.openSourceLicense),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showSnackBar(AppLocalizations.of(context)!.licenseInfoComingSoon);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.star),
                title: Text(AppLocalizations.of(context)!.appRating),
                subtitle: Text(AppLocalizations.of(context)!.rateOnPlayStore),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showSnackBar(AppLocalizations.of(context)!.appRatingComingSoon);
                },
              ),
            ]),

            const SizedBox(height: 30),

            // 하단 정보
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.copyrightMission100,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.blue.withOpacity(0.2) : Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDark ? Colors.blue[300] : Colors.blue[700],
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(children: children),
    );
  }

  /// 상세 리마인더 설정 화면 열기
  Future<void> _openReminderSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WorkoutReminderSettingsScreen(),
      ),
    );
    // 설정 화면에서 돌아온 후 설정 다시 로드
    await _loadSettings();
  }

  /// 리마인더 시간 저장
  Future<void> _saveReminderTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    final timeString = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    await prefs.setString('reminder_time', timeString);

    setState(() {
      _reminderTime = time;
    });

    // 운동 리마인더가 활성화되어 있으면 새 시간으로 재설정
    if (_workoutReminders && _pushNotifications) {
      await NotificationService.scheduleWorkoutReminder(time);

      _showSnackBar(AppLocalizations.of(context)!.reminderTimeChanged(time.format(context)));
    }

    debugPrint('리마인더 시간 저장: $timeString');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}