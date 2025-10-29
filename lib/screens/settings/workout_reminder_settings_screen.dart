import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mission100/generated/app_localizations.dart';
import 'dart:convert';

import '../../models/workout_reminder_settings.dart';
import '../../services/notification/notification_service.dart';

class WorkoutReminderSettingsScreen extends StatefulWidget {
  const WorkoutReminderSettingsScreen({super.key});

  @override
  State<WorkoutReminderSettingsScreen> createState() =>
      _WorkoutReminderSettingsScreenState();
}

class _WorkoutReminderSettingsScreenState
    extends State<WorkoutReminderSettingsScreen> {
  WorkoutReminderSettings _settings = WorkoutReminderSettings.defaultWeekdays;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString('workout_reminder_settings');

      if (settingsJson != null) {
        final settingsMap = jsonDecode(settingsJson) as Map<String, dynamic>;
        _settings = WorkoutReminderSettings.fromJson(settingsMap);
      }
    } catch (e) {
      debugPrint('설정 로드 실패: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'workout_reminder_settings',
        jsonEncode(_settings.toJson()),
      );

      // 실제 알림 스케줄링 업데이트
      if (_settings.isEnabled && _settings.activeDays.isNotEmpty) {
        await NotificationService.scheduleDailyWorkoutReminder(
          time: _settings.time,
          activeDays: _settings.activeDays,
        );
      } else {
        await NotificationService.cancelWorkoutReminder();
      }

      _showSnackBar(AppLocalizations.of(context).settingsSaved);
    } catch (e) {
      debugPrint('설정 저장 실패: $e');
      _showSnackBar(AppLocalizations.of(context).settingsSaveFailed);
    }
  }

  void _updateSettings(WorkoutReminderSettings newSettings) {
    setState(() {
      _settings = newSettings;
    });
    _saveSettings();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _settings.time,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).cardColor,
              hourMinuteTextColor: Theme.of(context).textTheme.bodyLarge?.color,
              dialHandColor: Colors.blue,
              dialTextColor: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _updateSettings(_settings.copyWith(time: picked));
    }
  }

  /// 3가지 고정 옵션 선택
  void _selectOption(int optionIndex) {
    WorkoutReminderSettings selectedOption;

    switch (optionIndex) {
      case 0:
        selectedOption = WorkoutReminderSettings.optionMWF;
        break;
      case 1:
        selectedOption = WorkoutReminderSettings.optionTTS;
        break;
      case 2:
        selectedOption = WorkoutReminderSettings.optionMWFSTS;
        break;
      default:
        selectedOption = WorkoutReminderSettings.optionMWF;
    }

    _updateSettings(
      selectedOption.copyWith(
        isEnabled: _settings.isEnabled,
        time: _settings.time,
      ),
    );
  }

  void _selectPreset(WorkoutReminderSettings preset) {
    _updateSettings(
      preset.copyWith(isEnabled: _settings.isEnabled, time: _settings.time),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).workoutReminderSettings),
          backgroundColor: isDark ? Colors.grey[900] : Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).workoutReminderSettings),
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
                  const Icon(Icons.schedule, size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).workoutReminderSettings,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context).chadModeActivate,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 알림 활성화
            _buildSectionHeader(
              AppLocalizations.of(context).chadNotificationSettings,
              Icons.notifications,
            ),
            const SizedBox(height: 8),
            _buildSettingsCard([
              SwitchListTile(
                title: Text(AppLocalizations.of(context).chadReminder),
                subtitle: Text(
                  _settings.isEnabled
                      ? AppLocalizations.of(context).chadModeActive(
                          _settings.activeDaysString,
                          _settings.time.format(context),
                        )
                      : AppLocalizations.of(context).chadModeWaiting,
                ),
                value: _settings.isEnabled,
                onChanged: (value) {
                  _updateSettings(_settings.copyWith(isEnabled: value));
                },
              ),
            ]),

            if (_settings.isEnabled) ...[
              const SizedBox(height: 20),

              // 시간 설정
              _buildSectionHeader(
                AppLocalizations.of(context).chadTimeSettings,
                Icons.access_time,
              ),
              const SizedBox(height: 8),
              _buildSettingsCard([
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(AppLocalizations.of(context).chadAlarmTime),
                  subtitle: Text(
                    AppLocalizations.of(
                      context,
                    ).victoryTime(_settings.time.format(context)),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _selectTime,
                ),
              ]),

              const SizedBox(height: 20),

              // 프리셋 선택
              _buildSectionHeader(
                AppLocalizations.of(context).chadModeSelection,
                Icons.dashboard,
              ),
              const SizedBox(height: 8),
              _buildSettingsCard([
                ListTile(
                  leading: const Icon(Icons.work),
                  title: Text(AppLocalizations.of(context).workerChadMode),
                  subtitle: Text(
                    AppLocalizations.of(context).weekendRestWeekdayInvincible,
                  ),
                  onTap: () =>
                      _selectPreset(WorkoutReminderSettings.defaultWeekdays),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.star),
                  title: Text(AppLocalizations.of(context).strategicChadMode),
                  subtitle: Text(
                    AppLocalizations.of(context).scientificRecovery,
                  ),
                  onTap: () =>
                      _selectPreset(WorkoutReminderSettings.defaultMWF),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: Text(AppLocalizations.of(context).balanceChadMode),
                  subtitle: Text(
                    AppLocalizations.of(context).perfectBalanceOptimized,
                  ),
                  onTap: () =>
                      _selectPreset(WorkoutReminderSettings.defaultTTS),
                ),
              ]),

              const SizedBox(height: 20),

              // 요일별 설정
              _buildSectionHeader(
                AppLocalizations.of(context).victoryDaySelection,
                Icons.calendar_today,
              ),
              const SizedBox(height: 8),
              _buildWorkoutOptionSelector(),

              const SizedBox(height: 20),

              // 주의사항
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context).precautions,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context).workoutPrecautions,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],

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
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildWorkoutOptionSelector() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final options = [
      {
        'title': '월수금 (주 3회)',
        'desc': '월요일, 수요일, 금요일',
        'days': WorkoutReminderSettings.optionMWF.activeDays
      },
      {
        'title': '화목토 (주 3회)',
        'desc': '화요일, 목요일, 토요일',
        'days': WorkoutReminderSettings.optionTTS.activeDays
      },
      {
        'title': '순환 (주 7회)',
        'desc': '월수금일, 화목토 패턴 반복',
        'days': WorkoutReminderSettings.optionMWFSTS.activeDays
      },
    ];

    return _buildSettingsCard([
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '운동 스케줄 선택',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(options.length, (index) {
              final option = options[index];
              final isSelected =
                  _settings.activeDays.toString() == option['days'].toString();

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => _selectOption(index),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.withValues(alpha: 0.1)
                          : (isDark ? Colors.grey[800] : Colors.grey[50]),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.blue
                            : (isDark ? Colors.grey[600]! : Colors.grey[300]!),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: isSelected ? Colors.blue : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option['title']! as String,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.blue
                                      : (isDark
                                          ? Colors.white
                                          : Colors.black87),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                option['desc']! as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            Text(
              '현재 선택: ${_settings.optionName}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ]);
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
}
