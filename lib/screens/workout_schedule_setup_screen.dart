import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/database_service.dart';
import '../services/workout_program_service.dart';
import '../models/user_profile.dart';
import 'main_navigation_screen.dart';
import '../generated/app_localizations.dart';

class WorkoutScheduleSetupScreen extends StatefulWidget {
  final UserProfile userProfile;

  const WorkoutScheduleSetupScreen({super.key, required this.userProfile});

  @override
  State<WorkoutScheduleSetupScreen> createState() =>
      _WorkoutScheduleSetupScreenState();
}

class _WorkoutScheduleSetupScreenState extends State<WorkoutScheduleSetupScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // 운동 요일 선택 상태 (월요일0, 화요일1, ... 일요일6)
  final List<bool> _selectedDays = [
    true,
    false,
    true,
    false,
    true,
    false,
    false,
  ]; // 기본: 월수금

  // 알림 설정 상태
  bool _notificationsEnabled = true;
  TimeOfDay _notificationTime = const TimeOfDay(
    hour: 18,
    minute: 0,
  ); // 기본: 오후 6시

  // 선택된 요일 개수
  int get _selectedDaysCount =>
      _selectedDays.where((selected) => selected).length;

  @override
  void initState() {
    super.initState();
    _setupAnimations();

    // UserProfile에서 기존 알림 설정 불러오기
    _notificationsEnabled = widget.userProfile.reminderEnabled;
    _notificationTime = widget.userProfile.reminderTimeOfDay ??
        const TimeOfDay(hour: 18, minute: 0);
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _toggleDay(int dayIndex) {
    setState(() {
      _selectedDays[dayIndex] = !_selectedDays[dayIndex];
    });

    // 3일 미만이면 경고 (최소 3일은 선택해야 함)
    if (_selectedDaysCount < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).selectMinimum3Days,
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // 알림 시간 선택 메서드
  Future<void> _selectNotificationTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _notificationTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _notificationTime) {
      setState(() {
        _notificationTime = picked;
      });
    }
  }

  // 알림 시간을 문자열로 변환
  String _formatNotificationTime() {
    final isKorean = Localizations.localeOf(context).languageCode == 'ko';
    final hour = _notificationTime.hourOfPeriod;
    final minute = _notificationTime.minute;
    final period = _notificationTime.period;

    if (isKorean) {
      final periodText = period == DayPeriod.am ? '오전' : '오후';
      return '$periodText ${hour == 0 ? 12 : hour}:${minute.toString().padLeft(2, '0')}';
    } else {
      final periodText = period == DayPeriod.am ? 'AM' : 'PM';
      return '${hour == 0 ? 12 : hour}:${minute.toString().padLeft(2, '0')} $periodText';
    }
  }

  Future<void> _finishSetup() async {
    // 최소 3일 체크
    if (_selectedDaysCount < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).championNeedsConsistency,
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      // 사용자 프로필 업데이트 (운동 요일과 알림 설정 저장)
      final updatedProfile = widget.userProfile.copyWith(
        workoutDays: _selectedDays,
        // 알림 설정 추가
        reminderEnabled: _notificationsEnabled,
        reminderTimeOfDay: _notificationTime,
      );

      final databaseService = DatabaseService();
      await databaseService.updateUserProfile(updatedProfile);

      // 사용자 워크아웃 프로그램 초기화
      final workoutProgramService = WorkoutProgramService();
      final sessionsCreated = await workoutProgramService.initializeUserProgram(
        updatedProfile,
      );

      // 알림 설정은 설정 탭에서 관리하므로 여기서는 스케줄링하지 않음

      if (mounted) {
        // 설정 완료 메시지
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).scheduleSetupComplete(sessionsCreated),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );

        // 메인 화면으로 이동
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).scheduleSetupError(e.toString()),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Color(
        isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      ),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).workoutScheduleSetup,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ?목 ?션
                  _buildHeaderSection(),

                  const SizedBox(height: 30),

                  // ?동 ?일 ?택 ?션
                  _buildDaySelectionSection(),

                  const SizedBox(height: 30),

                  // 리마?드 ?정 ?션
                  _buildReminderSection(),

                  const SizedBox(height: 40),

                  // ?료 버튼
                  _buildFinishButton(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(AppColors.primaryColor).withValues(alpha: 0.1),
            Colors.orange.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month, color: Colors.orange[700], size: 32),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context).setYourWorkoutSchedule,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700],
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).championNeedsConsistency,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelectionSection() {
    final locale = Localizations.localeOf(context);
    final dayNames = locale.languageCode == 'ko'
        ? ['월', '화', '수', '목', '금', '토', '일']
        : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.fitness_center,
              color: Color(AppColors.primaryColor),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).selectWorkoutDaysMin3,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(AppColors.primaryColor),
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context).selectedDaysCount(_selectedDaysCount),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _selectedDaysCount >= 3 ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(7, (index) {
            final isSelected = _selectedDays[index];
            return GestureDetector(
              onTap: () => _toggleDay(index),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(AppColors.primaryColor)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? const Color(AppColors.primaryColor)
                        : Colors.grey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    dayNames[index],
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildReminderSection() {
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
                AppLocalizations.of(context).workoutNotifications,
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
              color: _notificationsEnabled
                  ? Colors.blue.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _notificationsEnabled
                    ? Colors.blue.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _notificationsEnabled
                      ? Icons.notifications
                      : Icons.notifications_off,
                  color: _notificationsEnabled
                      ? Colors.blue[700]
                      : Colors.grey[600],
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).enableWorkoutReminders,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: _notificationsEnabled
                                  ? Colors.blue[700]
                                  : Colors.grey[600],
                            ),
                      ),
                      Text(
                        AppLocalizations.of(context).getRemindersOnWorkoutDays,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                  activeThumbColor: Colors.blue[700],
                ),
              ],
            ),
          ),

          // 알림 시간 설정 (알림이 켜져있을 때만 표시)
          if (_notificationsEnabled) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: InkWell(
                onTap: _selectNotificationTime,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.orange[700],
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context).notificationTime,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange[700],
                                  ),
                            ),
                            Text(
                              _formatNotificationTime(),
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
                      Icon(Icons.edit, color: Colors.orange[700], size: 20),
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
                Icon(Icons.info_outline, color: Colors.green[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).canChangeInSettingsAnytime,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.green[700],
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

  Widget _buildFinishButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedDaysCount >= 3 ? _finishSetup : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedDaysCount >= 3
              ? const Color(AppColors.primaryColor)
              : Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: _selectedDaysCount >= 3 ? 4 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch,
              color: _selectedDaysCount >= 3 ? Colors.black : Colors.grey[400],
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).startTheJourney,
              style: TextStyle(
                color:
                    _selectedDaysCount >= 3 ? Colors.black : Colors.grey[400],
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
