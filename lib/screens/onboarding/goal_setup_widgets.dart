// ignore_for_file: deprecated_member_use
// TODO: Migrate Radio widgets to RadioGroup when refactoring onboarding screens

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/onboarding_step.dart';
import '../../services/core/onboarding_service.dart';
import '../../services/chad/chad_onboarding_service.dart';
import '../../widgets/chad/chad_onboarding_widget.dart';
import '../../utils/config/constants.dart';
import '../../generated/l10n/app_localizations.dart';

// 체중 설정 위젯
class GoalSetupWeightWidget extends StatefulWidget {
  final OnboardingStep step;
  final OnboardingService onboardingService;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const GoalSetupWeightWidget({
    super.key,
    required this.step,
    required this.onboardingService,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<GoalSetupWeightWidget> createState() => _GoalSetupWeightWidgetState();
}

class _GoalSetupWeightWidgetState extends State<GoalSetupWeightWidget> {
  final _currentWeightController = TextEditingController();
  final _targetWeightController = TextEditingController();

  @override
  void dispose() {
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  Future<void> _saveAndNext() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentWeightController.text.isNotEmpty) {
      await prefs.setDouble(
          'current_weight', double.parse(_currentWeightController.text));
    }
    if (_targetWeightController.text.isNotEmpty) {
      await prefs.setDouble(
          'target_weight', double.parse(_targetWeightController.text));
    }
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChadOnboardingService>(
          create: (_) => ChadOnboardingService(),
        ),
      ],
      child: ChadOnboardingWidget(
        stepType: 'goalSetupWeight',
        title: widget.step.title,
        description: widget.step.description,
        customContent: Column(
          children: [
            TextField(
              controller: _currentWeightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.goalSetupCurrentWeight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.white,
                suffixText: 'kg',
              ),
              onChanged: (value) {
                final chadService =
                    Provider.of<ChadOnboardingService>(context, listen: false);
                if (value.isNotEmpty) {
                  chadService.collectData(
                      'current_weight', double.tryParse(value));
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _targetWeightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.goalSetupTargetWeight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.white,
                suffixText: 'kg',
              ),
              onChanged: (value) {
                final chadService =
                    Provider.of<ChadOnboardingService>(context, listen: false);
                if (value.isNotEmpty) {
                  chadService.collectData(
                      'target_weight', double.tryParse(value));
                }
              },
            ),
          ],
        ),
        onNext: _currentWeightController.text.isNotEmpty ? _saveAndNext : null,
        buttonText: l10n.goalSetupNextButton,
      ),
    );
  }
}

// 운동 경험 설정 위젯
class GoalSetupFitnessLevelWidget extends StatefulWidget {
  final OnboardingStep step;
  final OnboardingService onboardingService;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const GoalSetupFitnessLevelWidget({
    super.key,
    required this.step,
    required this.onboardingService,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<GoalSetupFitnessLevelWidget> createState() =>
      _GoalSetupFitnessLevelWidgetState();
}

class _GoalSetupFitnessLevelWidgetState
    extends State<GoalSetupFitnessLevelWidget> {
  String? _selectedLevel;

  List<Map<String, String>> _getLevels(AppLocalizations l10n) {
    return [
      {
        'key': 'beginner',
        'title': l10n.goalSetupLevelBeginnerTitle,
        'description': l10n.goalSetupLevelBeginnerDesc,
      },
      {
        'key': 'intermediate',
        'title': l10n.goalSetupLevelIntermediateTitle,
        'description': l10n.goalSetupLevelIntermediateDesc,
      },
      {
        'key': 'advanced',
        'title': l10n.goalSetupLevelAdvancedTitle,
        'description': l10n.goalSetupLevelAdvancedDesc,
      },
    ];
  }

  Future<void> _saveAndNext() async {
    if (_selectedLevel != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fitness_level', _selectedLevel!);
    }
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final levels = _getLevels(l10n);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChadOnboardingService>(
          create: (_) => ChadOnboardingService(),
        ),
      ],
      child: ChadOnboardingWidget(
        stepType: 'goalSetupFitnessLevel',
        title: widget.step.title,
        description: widget.step.description,
        customContent: Column(
          children: levels.map((level) {
            final isSelected = _selectedLevel == level['key'];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: isSelected ? 4 : 1,
                color: isSelected
                    ? const Color(AppColors.primaryColor).withValues(alpha: 0.1)
                    : null,
                child: ListTile(
                  title: Text(
                    level['title']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? const Color(AppColors.primaryColor)
                          : null,
                    ),
                  ),
                  subtitle: Text(level['description']!),
                  leading: Radio<String>(
                    value: level['key']!,
                    groupValue: _selectedLevel,
                    onChanged: (value) {
                      setState(() => _selectedLevel = value);
                      final chadService = Provider.of<ChadOnboardingService>(
                          context,
                          listen: false);
                      chadService.collectData('fitness_level', value);
                    },
                    activeColor: const Color(AppColors.primaryColor),
                  ),
                  onTap: () {
                    setState(() => _selectedLevel = level['key']);
                    final chadService = Provider.of<ChadOnboardingService>(
                        context,
                        listen: false);
                    chadService.collectData('fitness_level', level['key']);
                  },
                ),
              ),
            );
          }).toList(),
        ),
        onNext: _selectedLevel != null ? _saveAndNext : null,
        buttonText: l10n.goalSetupNextButton,
      ),
    );
  }
}

// 목표 설정 위젯
class GoalSetupGoalWidget extends StatefulWidget {
  final OnboardingStep step;
  final OnboardingService onboardingService;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const GoalSetupGoalWidget({
    super.key,
    required this.step,
    required this.onboardingService,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<GoalSetupGoalWidget> createState() => _GoalSetupGoalWidgetState();
}

class _GoalSetupGoalWidgetState extends State<GoalSetupGoalWidget> {
  String? _selectedGoal;

  List<Map<String, String>> _getGoals(AppLocalizations l10n) {
    return [
      {
        'key': 'weightLoss',
        'title': l10n.goalSetupGoalWeightLossTitle,
        'description': l10n.goalSetupGoalWeightLossDesc,
        'emoji': '🔥',
      },
      {
        'key': 'muscleGain',
        'title': l10n.goalSetupGoalMuscleGainTitle,
        'description': l10n.goalSetupGoalMuscleGainDesc,
        'emoji': '💪',
      },
      {
        'key': 'endurance',
        'title': l10n.goalSetupGoalStaminaTitle,
        'description': l10n.goalSetupGoalStaminaDesc,
        'emoji': '⚡',
      },
      {
        'key': 'general',
        'title': l10n.goalSetupGoalHealthTitle,
        'description': l10n.goalSetupGoalHealthDesc,
        'emoji': '🌟',
      },
    ];
  }

  Future<void> _saveAndNext() async {
    if (_selectedGoal != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fitness_goal', _selectedGoal!);
    }
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final goals = _getGoals(l10n);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChadOnboardingService>(
          create: (_) => ChadOnboardingService(),
        ),
      ],
      child: ChadOnboardingWidget(
        stepType: 'goalSetupGoal',
        title: widget.step.title,
        description: widget.step.description,
        customContent: Column(
          children: goals.map((goal) {
            final isSelected = _selectedGoal == goal['key'];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: isSelected ? 4 : 1,
                color: isSelected
                    ? const Color(AppColors.primaryColor).withValues(alpha: 0.1)
                    : null,
                child: ListTile(
                  title: Row(
                    children: [
                      Text(goal['emoji']!,
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        goal['title']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? const Color(AppColors.primaryColor)
                              : null,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(goal['description']!),
                  leading: Radio<String>(
                    value: goal['key']!,
                    groupValue: _selectedGoal,
                    onChanged: (value) {
                      setState(() => _selectedGoal = value);
                      final chadService = Provider.of<ChadOnboardingService>(
                          context,
                          listen: false);
                      chadService.collectData('fitness_goal', value);
                    },
                    activeColor: const Color(AppColors.primaryColor),
                  ),
                  onTap: () {
                    setState(() => _selectedGoal = goal['key']);
                    final chadService = Provider.of<ChadOnboardingService>(
                        context,
                        listen: false);
                    chadService.collectData('fitness_goal', goal['key']);
                  },
                ),
              ),
            );
          }).toList(),
        ),
        onNext: _selectedGoal != null ? _saveAndNext : null,
        buttonText: l10n.goalSetupNextButton,
      ),
    );
  }
}

// 운동 시간 설정 위젯
class GoalSetupWorkoutTimeWidget extends StatefulWidget {
  final OnboardingStep step;
  final OnboardingService onboardingService;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const GoalSetupWorkoutTimeWidget({
    super.key,
    required this.step,
    required this.onboardingService,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<GoalSetupWorkoutTimeWidget> createState() =>
      _GoalSetupWorkoutTimeWidgetState();
}

class _GoalSetupWorkoutTimeWidgetState
    extends State<GoalSetupWorkoutTimeWidget> {
  final List<String> _selectedTimes = [];

  List<String> _getTimes(AppLocalizations l10n) {
    return [
      l10n.goalSetupTimeDawn,
      l10n.goalSetupTimeMorning,
      l10n.goalSetupTimeLateMorning,
      l10n.goalSetupTimeLunch,
      l10n.goalSetupTimeAfternoon,
      l10n.goalSetupTimeEvening,
      l10n.goalSetupTimeNight,
    ];
  }

  Future<void> _saveAndNext() async {
    if (_selectedTimes.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('workout_times', _selectedTimes);
    }
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final times = _getTimes(l10n);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChadOnboardingService>(
          create: (_) => ChadOnboardingService(),
        ),
      ],
      child: ChadOnboardingWidget(
        stepType: 'goalSetupWorkoutTime',
        title: widget.step.title,
        description: widget.step.description,
        customContent: Column(
          children: times.map((time) {
            final isSelected = _selectedTimes.contains(time);
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Card(
                elevation: isSelected ? 4 : 1,
                color: isSelected
                    ? const Color(AppColors.primaryColor).withValues(alpha: 0.1)
                    : null,
                child: CheckboxListTile(
                  title: Text(
                    time,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? const Color(AppColors.primaryColor)
                          : null,
                    ),
                  ),
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedTimes.add(time);
                      } else {
                        _selectedTimes.remove(time);
                      }
                    });
                    final chadService = Provider.of<ChadOnboardingService>(
                        context,
                        listen: false);
                    chadService.collectData('workout_times', _selectedTimes);
                  },
                  activeColor: const Color(AppColors.primaryColor),
                ),
              ),
            );
          }).toList(),
        ),
        onNext: _selectedTimes.isNotEmpty ? _saveAndNext : null,
        buttonText: l10n.goalSetupNextButton,
      ),
    );
  }
}

// 동기부여 방식 설정 위젯
class GoalSetupMotivationWidget extends StatefulWidget {
  final OnboardingStep step;
  final OnboardingService onboardingService;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const GoalSetupMotivationWidget({
    super.key,
    required this.step,
    required this.onboardingService,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<GoalSetupMotivationWidget> createState() =>
      _GoalSetupMotivationWidgetState();
}

class _GoalSetupMotivationWidgetState extends State<GoalSetupMotivationWidget> {
  bool? _likesCompetition;

  Future<void> _saveAndNext() async {
    if (_likesCompetition != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('likes_competition', _likesCompetition!);
    }
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChadOnboardingService>(
          create: (_) => ChadOnboardingService(),
        ),
      ],
      child: ChadOnboardingWidget(
        stepType: 'goalSetupMotivation',
        title: widget.step.title,
        description: widget.step.description,
        customContent: Column(
          children: [
            Card(
              elevation: _likesCompetition == true ? 4 : 1,
              color: _likesCompetition == true
                  ? const Color(AppColors.primaryColor).withValues(alpha: 0.1)
                  : null,
              child: ListTile(
                title: Row(
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context).competitionTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                subtitle: Text(AppLocalizations.of(context).competitionGoalDescription),
                leading: Radio<bool>(
                  value: true,
                  groupValue: _likesCompetition,
                  onChanged: (value) {
                    setState(() => _likesCompetition = value);
                    final chadService = Provider.of<ChadOnboardingService>(
                        context,
                        listen: false);
                    chadService.collectData('likes_competition', value);
                  },
                  activeColor: const Color(AppColors.primaryColor),
                ),
                onTap: () {
                  setState(() => _likesCompetition = true);
                  final chadService = Provider.of<ChadOnboardingService>(
                      context,
                      listen: false);
                  chadService.collectData('likes_competition', true);
                },
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: _likesCompetition == false ? 4 : 1,
              color: _likesCompetition == false
                  ? const Color(AppColors.primaryColor).withValues(alpha: 0.1)
                  : null,
              child: ListTile(
                title: Row(
                  children: [
                    const Text('📈', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context).personalRecordTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                subtitle: Text(AppLocalizations.of(context).personalRecordGoalDescription),
                leading: Radio<bool>(
                  value: false,
                  groupValue: _likesCompetition,
                  onChanged: (value) {
                    setState(() => _likesCompetition = value);
                    final chadService = Provider.of<ChadOnboardingService>(
                        context,
                        listen: false);
                    chadService.collectData('likes_competition', value);
                  },
                  activeColor: const Color(AppColors.primaryColor),
                ),
                onTap: () {
                  setState(() => _likesCompetition = false);
                  final chadService = Provider.of<ChadOnboardingService>(
                      context,
                      listen: false);
                  chadService.collectData('likes_competition', false);
                },
              ),
            ),
          ],
        ),
        onNext: _likesCompetition != null ? _saveAndNext : null,
        buttonText: AppLocalizations.of(context).goalSetupNextButton,
      ),
    );
  }
}

// 목표 설정 완료 위젯
class GoalSetupCompleteWidget extends StatelessWidget {
  final OnboardingStep step;
  final OnboardingService onboardingService;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const GoalSetupCompleteWidget({
    super.key,
    required this.step,
    required this.onboardingService,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChadOnboardingService>(
          create: (_) => ChadOnboardingService(),
        ),
      ],
      child: ChadOnboardingWidget(
        stepType: 'goalSetupComplete',
        title: step.title,
        description: step.description,
        customContent: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Text(
                l10n.goalSetupCompleteTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(AppColors.primaryColor),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.goalSetupWelcomeMessage,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        onNext: () async {
          final chadService =
              Provider.of<ChadOnboardingService>(context, listen: false);
          await chadService.applyPersonalizationImmediately();
          onNext();
        },
        buttonText: l10n.goalSetupStartJourney,
      ),
    );
  }
}

