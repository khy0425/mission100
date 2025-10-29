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
                labelText: '현재 체중 (kg)',
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
                labelText: '목표 체중 (kg, 선택사항)',
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
        buttonText: '다음',
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

  final List<Map<String, String>> _levels = [
    {
      'key': 'beginner',
      'title': '초보자',
      'description': '운동을 처음 시작하거나 오랜만에 하는 경우',
    },
    {
      'key': 'intermediate',
      'title': '중급자',
      'description': '꾸준히 운동을 해왔고 기본 동작에 익숙한 경우',
    },
    {
      'key': 'advanced',
      'title': '고급자',
      'description': '강도 높은 운동을 원하고 다양한 변형을 시도하고 싶은 경우',
    },
  ];

  Future<void> _saveAndNext() async {
    if (_selectedLevel != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fitness_level', _selectedLevel!);
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
        stepType: 'goalSetupFitnessLevel',
        title: widget.step.title,
        description: widget.step.description,
        customContent: Column(
          children: _levels.map((level) {
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
        buttonText: '다음',
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

  final List<Map<String, String>> _goals = [
    {
      'key': 'weightLoss',
      'title': '체중 감량',
      'description': '체지방을 줄이고 날씬한 몸매 만들기',
      'emoji': '🔥',
    },
    {
      'key': 'muscleGain',
      'title': '근육 증가',
      'description': '탄탄한 근육과 매력적인 상체 라인 만들기',
      'emoji': '💪',
    },
    {
      'key': 'endurance',
      'title': '체력 향상',
      'description': '지구력과 전반적인 체력 개선하기',
      'emoji': '⚡',
    },
    {
      'key': 'general',
      'title': '전반적인 건강',
      'description': '건강한 생활습관과 균형잡힌 몸만들기',
      'emoji': '🌟',
    },
  ];

  Future<void> _saveAndNext() async {
    if (_selectedGoal != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fitness_goal', _selectedGoal!);
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
        stepType: 'goalSetupGoal',
        title: widget.step.title,
        description: widget.step.description,
        customContent: Column(
          children: _goals.map((goal) {
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
        buttonText: '다음',
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

  final List<String> _times = [
    '새벽 (5-7시)',
    '아침 (7-9시)',
    '오전 (9-12시)',
    '점심 (12-14시)',
    '오후 (14-17시)',
    '저녁 (17-20시)',
    '밤 (20-22시)',
  ];

  Future<void> _saveAndNext() async {
    if (_selectedTimes.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('workout_times', _selectedTimes);
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
        stepType: 'goalSetupWorkoutTime',
        title: widget.step.title,
        description: widget.step.description,
        customContent: Column(
          children: _times.map((time) {
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
        buttonText: '다음',
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
                title: const Row(
                  children: [
                    Text('🏆', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('경쟁과 순위',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                subtitle: const Text('다른 사용자와 비교하고 순위를 확인하며 동기부여'),
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
                title: const Row(
                  children: [
                    Text('📈', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('개인 기록',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                subtitle: const Text('나만의 목표 달성과 개인 기록 향상에 집중'),
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
        buttonText: '다음',
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
          child: const Column(
            children: [
              Text(
                '🎉 목표 설정 완료!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(AppColors.primaryColor),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '이제 당신만의 맞춤형 Mission: 100이 시작됩니다.\n런칭 이벤트로 1개월 무료 체험해보세요!',
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
        buttonText: '시작하기',
      ),
    );
  }
}

