import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:mission100/generated/app_localizations.dart';
import '../../services/notification_service.dart';
import '../../services/auth_service.dart';
import '../../models/user_subscription.dart';
import '../../widgets/vip_badge_widget.dart';
import '../onboarding_screen.dart';
import 'workout_reminder_settings_screen.dart';
import '../subscription/subscription_screen.dart';

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
        title: Text(AppLocalizations.of(context).settings),
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
                        colors: [
                          Colors.grey[800] ?? Colors.grey,
                          Colors.grey[700] ?? Colors.grey
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
                        colors: [
                          Color(0xFF2196F3),
                          Color(0xFF1976D2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.settings, size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).mission100Settings,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context).customizeAppFeatures,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 알림 설정
            _buildSectionHeader(
              AppLocalizations.of(context).notificationSettings,
              Icons.notifications,
            ),
            const SizedBox(height: 8),
            _buildSettingsCard([
              SwitchListTile(
                title: Text(AppLocalizations.of(context).pushNotifications),
                subtitle: Text(
                  AppLocalizations.of(context).receiveGeneralNotifications,
                ),
                value: _pushNotifications,
                onChanged: (bool value) async {
                  setState(() {
                    _pushNotifications = value;
                  });
                  await _saveBoolSetting('push_notifications', value);
                  _showSnackBar(
                    value
                        ? AppLocalizations.of(context).pushNotificationEnabled
                        : AppLocalizations.of(
                            context,
                          ).pushNotificationDisabled,
                  );
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: Text(AppLocalizations.of(context).workoutReminder),
                subtitle: Text(
                  AppLocalizations.of(
                    context,
                  ).dailyReminderAt(_reminderTime.format(context)),
                ),
                value: _workoutReminders,
                onChanged: (bool value) async {
                  setState(() {
                    _workoutReminders = value;
                  });
                  await _saveBoolSetting('workout_reminders', value);

                  // 실제 알림 스케줄링 처리
                  if (value && _pushNotifications) {
                    await NotificationService.scheduleWorkoutReminder(
                      _reminderTime,
                    );
                  } else {
                    await NotificationService.cancelWorkoutReminder();
                  }

                  _showSnackBar(
                    value
                        ? AppLocalizations.of(context).workoutReminderEnabled
                        : AppLocalizations.of(context).workoutReminderDisabled,
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.schedule),
                title: Text(
                  AppLocalizations.of(context).detailedReminderSettings,
                ),
                subtitle: Text(
                  AppLocalizations.of(context).weeklyWorkoutSchedule,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: _workoutReminders ? _openReminderSettings : null,
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: Text(
                  AppLocalizations.of(context).achievementNotifications,
                ),
                subtitle: Text(
                  AppLocalizations.of(context).receiveAchievementNotifications,
                ),
                value: true,
                onChanged: (bool value) {
                  _showSnackBar(
                    AppLocalizations.of(
                      context,
                    ).achievementNotificationsAlwaysOn,
                  );
                },
              ),
            ]),

            const SizedBox(height: 20),

            // 외관 설정
            _buildSectionHeader(
              AppLocalizations.of(context).appearanceSettings,
              Icons.palette,
            ),
            const SizedBox(height: 8),
            _buildSettingsCard([
              SwitchListTile(
                title: Text(AppLocalizations.of(context).darkMode),
                subtitle: Text(AppLocalizations.of(context).useDarkTheme),
                value: _darkMode,
                onChanged: (bool value) async {
                  setState(() {
                    _darkMode = value;
                  });
                  await _saveBoolSetting('dark_mode', value);
                  _showSnackBar(
                    AppLocalizations.of(context).themeChangeAfterRestart,
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(AppLocalizations.of(context).languageSettings),
                subtitle: Text(AppLocalizations.of(context).korean),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showSnackBar(
                    AppLocalizations.of(context).languageSettingsComingSoon,
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.fitness_center),
                title: Text(AppLocalizations.of(context).difficultySettings),
                subtitle: Text(AppLocalizations.of(context).beginnerMode),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showSnackBar(
                    AppLocalizations.of(context).difficultySettingsComingSoon,
                  );
                },
              ),
            ]),

            const SizedBox(height: 20),

            // 데이터 관리
            _buildSectionHeader(
              AppLocalizations.of(context).dataManagement,
              Icons.storage,
            ),
            const SizedBox(height: 8),
            _buildSettingsCard([
              ListTile(
                leading: const Icon(Icons.backup),
                title: Text(AppLocalizations.of(context).dataBackup),
                subtitle: Text(
                  AppLocalizations.of(context).backupWorkoutRecords,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showSnackBar(
                    AppLocalizations.of(context).dataBackupComingSoon,
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.restore),
                title: Text(AppLocalizations.of(context).dataRestore),
                subtitle: Text(AppLocalizations.of(context).restoreBackupData),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showSnackBar(
                    AppLocalizations.of(context).dataRestoreComingSoon,
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: Text(
                  AppLocalizations.of(context).dataReset,
                  style: const TextStyle(color: Colors.red),
                ),
                subtitle: Text(
                  AppLocalizations.of(context).deleteAllWorkoutRecords,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showSnackBar(
                    AppLocalizations.of(context).dataResetComingSoon,
                  );
                },
              ),
            ]),

            const SizedBox(height: 20),

            // 계정 관리 섹션 추가
            _buildSectionHeader(
              AppLocalizations.of(context).accountSettings,
              Icons.person,
            ),
            const SizedBox(height: 8),
            _buildSettingsCard([
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: Text(AppLocalizations.of(context).accountInfo),
                subtitle: Consumer<AuthService>(
                  builder: (context, authService, child) {
                    final user = authService.currentUser;
                    if (user != null) {
                      return Text(user.email ?? user.displayName ?? 'User');
                    }
                    return Text(AppLocalizations.of(context).guestMode);
                  },
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showAccountInfo();
                },
              ),
              const Divider(height: 1),
              Consumer<AuthService>(
                builder: (context, authService, child) {
                  // 로그인된 경우에만 로그아웃 버튼 표시
                  if (authService.isLoggedIn) {
                    return ListTile(
                      leading: const Icon(Icons.logout, color: Colors.orange),
                      title: Text(
                        AppLocalizations.of(context).logoutButton,
                        style: const TextStyle(color: Colors.orange),
                      ),
                      subtitle: Text(AppLocalizations.of(context).logoutFromAccount),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _showLogoutConfirmDialog();
                      },
                    );
                  } else {
                    // 게스트 모드일 때는 로그인 버튼 표시
                    return ListTile(
                      leading: const Icon(Icons.login, color: Colors.blue),
                      title: Text(
                        AppLocalizations.of(context).loginButton,
                        style: const TextStyle(color: Colors.blue),
                      ),
                      subtitle: Text(AppLocalizations.of(context).loginToSaveProgress),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        _navigateToLogin();
                      },
                    );
                  }
                },
              ),
            ]),

            const SizedBox(height: 20),

            // 구독 관리
            _buildSectionHeader(
              AppLocalizations.of(context).subscriptionManagement,
              Icons.workspace_premium,
            ),
            const SizedBox(height: 8),
            Consumer<AuthService>(
              builder: (context, authService, child) {
                final subscription = authService.currentSubscription;
                final isPremium = subscription?.type == SubscriptionType.premium;
                final isLaunchPromo = subscription?.type == SubscriptionType.launchPromo;

                String statusText;
                if (isPremium) {
                  statusText = AppLocalizations.of(context).premiumActive;
                } else if (isLaunchPromo) {
                  statusText = AppLocalizations.of(context).launchPromoActive;
                } else {
                  statusText = AppLocalizations.of(context).freeUsing;
                }

                return _buildSettingsCard([
                  ListTile(
                    leading: const Icon(Icons.workspace_premium),
                    title: Row(
                      children: [
                        Text(AppLocalizations.of(context).currentSubscription),
                        const SizedBox(width: 8),
                        if (subscription != null)
                          VIPBadgeWidget(
                            subscription: subscription,
                            size: VIPBadgeSize.small,
                            showLabel: true,
                          ),
                      ],
                    ),
                    subtitle: Text(
                      statusText,
                      style: TextStyle(
                        color: isPremium ? Colors.green : Colors.grey,
                        fontWeight: isPremium ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    trailing: isPremium
                        ? const Icon(Icons.verified, color: Colors.green)
                        : const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const SubscriptionScreen(),
                        ),
                      );
                    },
                  ),
                ]);
              },
            ),

            const SizedBox(height: 20),

            // 앱 정보
            _buildSectionHeader(
              AppLocalizations.of(context).appInfo,
              Icons.info,
            ),
            const SizedBox(height: 8),
            _buildSettingsCard([
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(AppLocalizations.of(context).version),
                subtitle: const Text('1.0.0'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.code),
                title: Text(AppLocalizations.of(context).developer),
                subtitle: Text(AppLocalizations.of(context).mission100Team),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.description),
                title: Text(AppLocalizations.of(context).license),
                subtitle: Text(AppLocalizations.of(context).openSourceLicense),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showSnackBar(
                    AppLocalizations.of(context).licenseInfoComingSoon,
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.star),
                title: Text(AppLocalizations.of(context).appRating),
                subtitle: Text(AppLocalizations.of(context).rateOnPlayStore),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showSnackBar(
                    AppLocalizations.of(context).appRatingComingSoon,
                  );
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
                  color: isDark
                      ? Colors.grey[700] ?? Colors.grey
                      : Colors.grey[300] ?? Colors.grey,
                  width: 1,
                ),
              ),
              child: Text(
                AppLocalizations.of(context).copyrightMission100,
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
            color: isDark
                ? Colors.blue.withValues(alpha: 0.2)
                : Colors.blue.withValues(alpha: 0.1),
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
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.grey[700] ?? Colors.grey
              : Colors.grey[200] ?? Colors.grey,
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // 계정 정보 표시
  void _showAccountInfo() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.account_circle, color: Colors.blue),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context).accountInfoTitle),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user != null) ...[
                if (user.displayName != null)
                  _buildInfoRow(
                    AppLocalizations.of(context).nameLabel,
                    user.displayName!,
                  ),
                if (user.email != null)
                  _buildInfoRow(
                    AppLocalizations.of(context).emailLabel,
                    user.email!,
                  ),
                _buildInfoRow(
                  AppLocalizations.of(context).accountTypeLabel,
                  authService.currentSubscription?.type == SubscriptionType.premium
                      ? AppLocalizations.of(context).premiumAccountType
                      : AppLocalizations.of(context).freeAccountType,
                ),
                _buildInfoRow(
                  AppLocalizations.of(context).loginMethodLabel,
                  user.providerData.isNotEmpty
                      ? user.providerData.first.providerId.contains('google')
                          ? AppLocalizations.of(context).googleMethod
                          : AppLocalizations.of(context).emailMethod
                      : AppLocalizations.of(context).emailMethod,
                ),
              ] else ...[
                Text(AppLocalizations.of(context).guestModeMessage),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).closeButton),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  // 로그아웃 확인 다이얼로그
  void _showLogoutConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).logoutTitle),
          content: Text(AppLocalizations.of(context).logoutConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).cancelButton),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // 다이얼로그 닫기
                await _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: Text(AppLocalizations.of(context).logoutButton),
            ),
          ],
        );
      },
    );
  }

  // 실제 로그아웃 수행
  Future<void> _performLogout() async {
    try {
      // 로딩 표시
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signOut();

      // SharedPreferences 초기화 (선택적)
      final prefs = await SharedPreferences.getInstance();
      // 온보딩 완료 상태는 유지하되, 사용자 관련 데이터만 초기화
      await prefs.remove('user_profile');
      await prefs.remove('workout_history');

      if (!mounted) return;

      // 로딩 다이얼로그 닫기
      Navigator.pop(context);

      // 온보딩 화면으로 이동
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        (Route<dynamic> route) => false,
      );

      _showSnackBar(AppLocalizations.of(context).logoutSuccessMessage);
    } catch (e) {
      if (!mounted) return;

      // 로딩 다이얼로그 닫기
      Navigator.pop(context);

      _showSnackBar(AppLocalizations.of(context).logoutErrorMessage(e.toString()));
    }
  }

  // 로그인 화면으로 이동
  void _navigateToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
