import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../services/ad_service.dart';
import '../services/difficulty_service.dart';
import '../services/theme_service.dart';
import '../services/locale_service.dart';
import '../services/notification_service.dart';
import '../services/chad_evolution_service.dart';
import '../generated/app_localizations.dart';
import '../main.dart';
import 'settings/widgets/notification_settings_widget.dart';
import 'settings/widgets/appearance_settings_widget.dart';
import 'settings/widgets/data_settings_widget.dart';
import 'settings/widgets/about_settings_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with WidgetsBindingObserver {
  // 설정 화면 전용 배너 광고
  BannerAd? _settingsBannerAd;

  // 설정 값들
  bool _achievementNotifications = true;
  bool _workoutReminders = true;
  bool _pushNotifications = true;
  bool _chadEvolutionNotifications = true;
  bool _chadEvolutionPreviewNotifications = true;
  bool _chadEvolutionEncouragementNotifications = true;
  bool _workoutDaysOnlyNotifications = true;
  DifficultyLevel _currentDifficulty = DifficultyLevel.beginner;
  Locale _currentLocale = LocaleService.koreanLocale;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 19, minute: 0); // 기본 오후 7시

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadBannerAd();
    _loadSettings();
    _initializeNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _settingsBannerAd?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {}); // 권한 상태 새로고침
    }
  }

  void _loadBannerAd() {
    final adService = Provider.of<AdService>(context, listen: false);

    if (!adService.isTestMode) {
      _settingsBannerAd = BannerAd(
        adUnitId: AdService.settingsBannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            debugPrint('설정 배너 광고 로드됨');
            if (mounted) setState(() {});
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('설정 배너 광고 로드 실패: $error');
            ad.dispose();
            _settingsBannerAd = null;
            if (mounted) setState(() {});
          },
        ),
      );
      _settingsBannerAd?.load();
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // 난이도 서비스에서 현재 설정 가져오기
    final difficultyService = Provider.of<DifficultyService>(context, listen: false);
    final difficulty = difficultyService.currentDifficulty;

    // 현재 언어 설정 가져오기
    final locale = LocaleService.getCurrentLocale();

    // 리마인더 시간 설정
    final timeString = prefs.getString('reminder_time') ?? '19:00';
    final timeParts = timeString.split(':');
    final hour = int.tryParse(timeParts[0]) ?? 19;
    final minute = int.tryParse(timeParts[1]) ?? 0;

    final currentLocale = await locale;

    setState(() {
      _achievementNotifications = prefs.getBool('achievement_notifications') ?? true;
      _workoutReminders = prefs.getBool('workout_reminders') ?? true;
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _chadEvolutionNotifications = prefs.getBool('chad_evolution_notifications') ?? true;
      _chadEvolutionPreviewNotifications = prefs.getBool('chad_evolution_preview_notifications') ?? true;
      _chadEvolutionEncouragementNotifications = prefs.getBool('chad_evolution_encouragement_notifications') ?? true;
      _workoutDaysOnlyNotifications = prefs.getBool('workout_days_only_notifications') ?? true;
      _currentDifficulty = difficulty;
      _currentLocale = currentLocale;
      _reminderTime = TimeOfDay(hour: hour, minute: minute);
    });
  }

  Future<void> _initializeNotifications() async {
    // 알림 시스템 초기화
    await NotificationService.initialize();
    await NotificationService.createNotificationChannels();

    // 권한 상태 확인
    final hasPermission = await NotificationService.hasPermission();
    setState(() {
      _pushNotifications = hasPermission;
    });

    if (!hasPermission) {
      debugPrint('⚠️ 알림 권한이 없습니다');
    }
  }

  /// 설정 값 저장
  Future<void> _saveBoolSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);

    // 알림 관련 설정 처리
    if (key == 'workout_reminders') {
      if (value && _pushNotifications) {
        // 설정된 시간에 운동 리마인더 설정
        await NotificationService.scheduleWorkoutReminder(_reminderTime);
      } else {
        await NotificationService.cancelWorkoutReminder();
      }
    }

    debugPrint('설정 저장: $key = $value');
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.reminderTimeChanged(time.format(context))),
            backgroundColor: const Color(AppColors.primaryColor),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    debugPrint('리마인더 시간 저장: $timeString');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings,
        ),
        backgroundColor: isDark ? Colors.grey[900] : Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.settings,
                    size: 64,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.mission100Settings,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 알림 설정
            _buildSimpleSettingsCard(
              context,
              Icons.notifications,
              AppLocalizations.of(context)!.notificationsSettings,
              [
                SwitchListTile(
                  title: Text(
                    AppLocalizations.of(context)!.pushNotifications,
                  ),
                  value: _pushNotifications,
                  onChanged: _onPushNotificationsChanged,
                ),
                SwitchListTile(
                  title: Text(
                    AppLocalizations.of(context)!.workoutReminders,
                  ),
                  value: _workoutReminders,
                  onChanged: _onWorkoutRemindersChanged,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 외관 설정
            _buildSimpleSettingsCard(
              context,
              Icons.palette,
              AppLocalizations.of(context)!.appearance,
              [
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.darkMode,
                  ),
                  trailing: Switch(
                    value: isDark,
                    onChanged: (value) {
                      // 간단한 테마 변경
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.themeChangeRestart,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.languageSettings,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.languageComingSoon,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 정보
            _buildSimpleSettingsCard(
              context,
              Icons.info,
              AppLocalizations.of(context)!.aboutApp,
              [
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.version,
                  ),
                  subtitle: Text(AppLocalizations.of(context)!.appVersion),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.developer),
                  subtitle: Text(AppLocalizations.of(context)!.mission100Team),
                ),
              ],
            ),

            const SizedBox(height: 80), // 하단 여백
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleSettingsCard(BuildContext context, IconData icon, String title, List<Widget> children) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      color: isDark ? Colors.grey[800] : Colors.white,
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: isDark ? Colors.white : Colors.black),
            title: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 헤더가 렌더링되는지 확인하기 위한 기본 위젯
    if (true) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              Icons.settings,
              size: 48,
              color: isDark ? Colors.white : Colors.black,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.settings,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!.manageAppSettings,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingM),
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        gradient: isDark
          ? LinearGradient(
              colors: [
                Color(AppColors.chadGradient[0]),
                Color(AppColors.chadGradient[1]),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : LinearGradient(
              colors: [
                const Color(0xFF2196F3), // 밝은 파란색
                const Color(0xFF1976D2), // 진한 파란색
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.settings, color: Colors.white, size: 32),
          const SizedBox(width: AppConstants.paddingM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.settings,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.customizeAppFeatures,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettingsSection() {
    // 간단한 테스트 위젯으로 먼저 확인
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.notificationSettings,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: Text(
              AppLocalizations.of(context)!.pushNotifications,
            ),
            value: _pushNotifications,
            onChanged: _onPushNotificationsChanged,
          ),
        ],
      ),
    );

    // 원래 코드 (임시로 주석 처리)
    /*
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
      child: NotificationSettingsWidget(
        pushNotifications: _pushNotifications,
        achievementNotifications: _achievementNotifications,
        workoutReminders: _workoutReminders,
        chadEvolutionNotifications: _chadEvolutionNotifications,
        chadEvolutionPreviewNotifications: _chadEvolutionPreviewNotifications,
        chadEvolutionEncouragementNotifications: _chadEvolutionEncouragementNotifications,
        workoutDaysOnlyNotifications: _workoutDaysOnlyNotifications,
        reminderTime: _reminderTime,
        onPushNotificationsChanged: _onPushNotificationsChanged,
        onAchievementNotificationsChanged: _onAchievementNotificationsChanged,
        onWorkoutRemindersChanged: _onWorkoutRemindersChanged,
        onChadEvolutionNotificationsChanged: _onChadEvolutionNotificationsChanged,
        onChadEvolutionPreviewNotificationsChanged: _onChadEvolutionPreviewNotificationsChanged,
        onChadEvolutionEncouragementNotificationsChanged: _onChadEvolutionEncouragementNotificationsChanged,
        onWorkoutDaysOnlyNotificationsChanged: _onWorkoutDaysOnlyNotificationsChanged,
        onReminderTimeChanged: _onReminderTimeChanged,
        onShowPermissionRequestDialog: _showPermissionRequestDialog,
      ),
    );
    */
  }

  Widget _buildAppearanceSettingsSection() {
    // 간단한 테스트 위젯
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.appearanceSettings,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.themeLanguageSettings,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDataSettingsSection() {
    // 간단한 테스트 위젯
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.dataManagement,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSettingsSection() {
    // 간단한 테스트 위젯
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.aboutInfo,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildBannerAd() {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(color: Color(AppColors.primaryColor), width: 1),
        ),
      ),
      child: _settingsBannerAd != null
          ? AdWidget(ad: _settingsBannerAd!)
          : Container(
              height: 60,
              color: const Color(0xFF1A1A1A),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.settings,
                      color: Color(AppColors.primaryColor),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.perfectChadExperience,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // 알림 설정 콜백 메서드들
  void _onPushNotificationsChanged(bool value) async {
    if (value) {
      final granted = await NotificationService.showPermissionRequestDialog(context);
      if (granted) {
        setState(() => _pushNotifications = true);
        await _saveBoolSetting('push_notifications', true);
      }
    } else {
      setState(() => _pushNotifications = false);
      await _saveBoolSetting('push_notifications', false);
    }
  }

  void _onAchievementNotificationsChanged(bool value) async {
    setState(() => _achievementNotifications = value);
    await _saveBoolSetting('achievement_notifications', value);
  }

  void _onWorkoutRemindersChanged(bool value) async {
    setState(() => _workoutReminders = value);
    await _saveBoolSetting('workout_reminders', value);
  }

  void _onChadEvolutionNotificationsChanged(bool value) async {
    setState(() => _chadEvolutionNotifications = value);
    await _saveBoolSetting('chad_evolution_notifications', value);
    final chadService = Provider.of<ChadEvolutionService>(context, listen: false);
    await chadService.setChadEvolutionNotificationEnabled(value);
  }

  void _onChadEvolutionPreviewNotificationsChanged(bool value) async {
    setState(() => _chadEvolutionPreviewNotifications = value);
    await _saveBoolSetting('chad_evolution_preview_notifications', value);
    final chadService = Provider.of<ChadEvolutionService>(context, listen: false);
    await chadService.setChadEvolutionPreviewNotificationEnabled(value);
  }

  void _onChadEvolutionEncouragementNotificationsChanged(bool value) async {
    setState(() => _chadEvolutionEncouragementNotifications = value);
    await _saveBoolSetting('chad_evolution_encouragement_notifications', value);
    final chadService = Provider.of<ChadEvolutionService>(context, listen: false);
    await chadService.setChadEvolutionEncouragementNotificationEnabled(value);
  }

  void _onWorkoutDaysOnlyNotificationsChanged(bool value) async {
    setState(() => _workoutDaysOnlyNotifications = value);
    await _saveBoolSetting('workout_days_only_notifications', value);
  }

  void _onReminderTimeChanged(TimeOfDay time) async {
    await _saveReminderTime(time);
  }

  void _showPermissionRequestDialog() async {
    try {
      final granted = await NotificationService.showPermissionRequestDialog(context);

      if (granted) {
        setState(() {
          _pushNotifications = true;
        });
        await _saveBoolSetting('push_notifications', true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.notificationPermissionGranted
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }

        if (_workoutReminders) {
          await NotificationService.scheduleWorkoutReminder(_reminderTime);
        }
      }
    } catch (e) {
      debugPrint('권한 요청 오류: $e');
    }
  }

  void _showLanguageDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.languageSettings
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.selectLanguage),
            const SizedBox(height: 16),
            ListTile(
              leading: Text(AppLocalizations.of(context)!.koreanFlag, style: const TextStyle(fontSize: 24)),
              title: Text(AppLocalizations.of(context)!.korean),
              subtitle: Text(AppLocalizations.of(context)!.koreanLanguage),
              trailing: _currentLocale.languageCode == 'ko'
                ? const Icon(Icons.check, color: Color(AppColors.primaryColor))
                : null,
              onTap: () => _changeLanguage(LocaleService.koreanLocale),
            ),
            ListTile(
              leading: Text(AppLocalizations.of(context)!.englishFlag, style: const TextStyle(fontSize: 24)),
              title: Text(AppLocalizations.of(context)!.englishLanguage),
              subtitle: Text(AppLocalizations.of(context)!.english),
              trailing: _currentLocale.languageCode == 'en'
                ? const Icon(Icons.check, color: Color(AppColors.primaryColor))
                : null,
              onTap: () => _changeLanguage(LocaleService.englishLocale),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    );
  }

  Future<void> _changeLanguage(Locale newLocale) async {
    if (_currentLocale.languageCode == newLocale.languageCode) {
      Navigator.pop(context);
      return;
    }

    final localeNotifier = Provider.of<LocaleNotifier>(context, listen: false);
    await localeNotifier.setLocale(newLocale);

    setState(() {
      _currentLocale = newLocale;
    });

    Navigator.pop(context);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.languageChanged(LocaleService.getLocaleName(newLocale)),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(AppColors.primaryColor),
        ),
      );
    }
  }
}