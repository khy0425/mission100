import 'package:flutter/material.dart';
import '../../models/rpe_data.dart';
import '../../models/user_profile.dart';
import '../../widgets/rpe/rpe_input_widget.dart';
import '../../widgets/common/recovery_dashboard_widget.dart';
import '../../widgets/workout/workout_adjustment_card.dart';
import '../../services/progress/rpe_adaptation_service.dart';

/// 투자자용 데모 화면
class InvestorDemoScreen extends StatefulWidget {
  const InvestorDemoScreen({super.key});

  @override
  State<InvestorDemoScreen> createState() => _InvestorDemoScreenState();
}

class _InvestorDemoScreenState extends State<InvestorDemoScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final RPEAdaptationService _rpeService = RPEAdaptationService();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int _currentPage = 0;
  int _currentScenario = 0;

  // 데모 시나리오들
  final List<DemoScenario> _scenarios = [
    DemoScenario(
      userType: '초보자 A',
      description: '체중감량 목표, 첫 운동 후 RPE 9 기록',
      goal: FitnessGoal.weightLoss,
      level: FitnessLevel.beginner,
      rpeValue: 9,
      expectedAdjustment: '강도 감소 (-15%)',
      originalReps: 10,
      backgroundColor: Colors.red.shade50,
      accentColor: Colors.red,
    ),
    DemoScenario(
      userType: '중급자 B',
      description: '근육증가 목표, 운동 후 RPE 5 기록',
      goal: FitnessGoal.muscleGain,
      level: FitnessLevel.intermediate,
      rpeValue: 5,
      expectedAdjustment: '강도 증가 (+10%)',
      originalReps: 15,
      backgroundColor: Colors.orange.shade50,
      accentColor: Colors.orange,
    ),
    DemoScenario(
      userType: '고급자 C',
      description: '3일 연속 고강도 운동 (RPE 8-9)',
      goal: FitnessGoal.endurance,
      level: FitnessLevel.advanced,
      rpeValue: 8,
      expectedAdjustment: '휴식일 권장',
      originalReps: 20,
      backgroundColor: Colors.amber.shade50,
      accentColor: Colors.amber,
    ),
  ];

  // 가상 사용자 데이터
  final List<List<RPEData>> _scenarioRPEHistory = [
    // 초보자 A - 첫 운동
    [],
    // 중급자 B - 적당한 강도
    [
      RPEData(
          value: 6,
          description: '적당함',
          emoji: '💪',
          timestamp: DateTime.now().subtract(const Duration(days: 2))),
      RPEData(
          value: 5,
          description: '쉬움',
          emoji: '😊',
          timestamp: DateTime.now().subtract(const Duration(days: 1))),
    ],
    // 고급자 C - 연속 고강도
    [
      RPEData(
          value: 8,
          description: '힘듦',
          emoji: '😅',
          timestamp: DateTime.now().subtract(const Duration(days: 3))),
      RPEData(
          value: 9,
          description: '매우 힘듦',
          emoji: '🥵',
          timestamp: DateTime.now().subtract(const Duration(days: 2))),
      RPEData(
          value: 8,
          description: '힘듦',
          emoji: '😅',
          timestamp: DateTime.now().subtract(const Duration(days: 1))),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextScenario() {
    if (_currentScenario < _scenarios.length - 1) {
      setState(() => _currentScenario++);
      _resetDemo();
    }
  }

  void _previousScenario() {
    if (_currentScenario > 0) {
      setState(() => _currentScenario--);
      _resetDemo();
    }
  }

  void _resetDemo() {
    setState(() => _currentPage = 0);
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _fadeController.reset();
    _fadeController.forward();
  }

  // RPE 선택 핸들러 (향후 인터랙션 추가 시 사용)
  // void _onRPESelected(RPEData rpe) {
  //   HapticFeedback.mediumImpact();
  //   Future.delayed(const Duration(milliseconds: 500), () {
  //     _pageController.nextPage(
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeInOut,
  //     );
  //   });
  // }

  WorkoutAdjustment _calculateDemoAdjustment() {
    final scenario = _scenarios[_currentScenario];
    return _rpeService.calculateNextAdjustment(
      currentRPE: scenario.rpeValue.toDouble(),
      goal: scenario.goal,
      level: scenario.level,
    );
  }

  RecoveryStatus _calculateDemoRecovery() {
    final rpeHistory = _scenarioRPEHistory[_currentScenario];

    if (rpeHistory.isEmpty) {
      return RecoveryStatus(
        score: 85,
        level: RecoveryLevel.excellent,
        recommendation: '첫 운동이에요! 컨디션이 좋습니다.',
        shouldReduceIntensity: false,
        suggestedRestDays: 0,
        assessedAt: DateTime.now(),
      );
    }

    final avgRPE = rpeHistory.map((r) => r.value).reduce((a, b) => a + b) /
        rpeHistory.length;
    int score = 70;

    if (avgRPE > 8) score -= 20;
    if (avgRPE < 6) score += 10;
    if (rpeHistory.length > 3) score -= 10; // 빈번한 운동

    return RecoveryStatus(
      score: score.clamp(0, 100),
      level: RecoveryLevel.fromScore(score),
      recommendation:
          score > 70 ? '좋은 컨디션이에요! 계획대로 운동하세요.' : '휴식이 필요해 보여요. 강도를 낮춰주세요.',
      shouldReduceIntensity: score < 60,
      suggestedRestDays: score < 50 ? 1 : 0,
      assessedAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scenario = _scenarios[_currentScenario];

    return Scaffold(
      backgroundColor: scenario.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🚀 AI 개인화 코칭 데모',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: scenario.accentColor,
              ),
            ),
            Text(
              '투자자용 실시간 시연',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Column(
        children: [
          // 시나리오 선택
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: scenario.accentColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'DEMO ${_currentScenario + 1}/3',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (_currentScenario > 0)
                      IconButton(
                        onPressed: _previousScenario,
                        icon: const Icon(Icons.chevron_left),
                        iconSize: 20,
                      ),
                    if (_currentScenario < _scenarios.length - 1)
                      IconButton(
                        onPressed: _nextScenario,
                        icon: const Icon(Icons.chevron_right),
                        iconSize: 20,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  scenario.userType,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  scenario.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: scenario.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '예상 결과: ${scenario.expectedAdjustment}',
                    style: TextStyle(
                      fontSize: 12,
                      color: scenario.accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 데모 플로우
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  // 1. RPE 입력
                  _buildRPEInputPage(),
                  // 2. 자동 조정 결과
                  _buildAdjustmentPage(),
                  // 3. 회복 상태 분석
                  _buildRecoveryPage(),
                ],
              ),
            ),
          ),

          // 페이지 인디케이터
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? scenario.accentColor
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRPEInputPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.psychology,
                  size: 48,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                Text(
                  '1단계: RPE 피드백 수집',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '사용자의 운동 강도를 RPE 척도로 수집합니다',
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          RPESliderWidget(
            initialValue: _scenarios[_currentScenario].rpeValue,
            onRPEChanged: (rpe) {
              // 자동으로 다음 단계로 이동 (데모용)
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (mounted) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustmentPage() {
    final adjustment = _calculateDemoAdjustment();
    final scenario = _scenarios[_currentScenario];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.auto_fix_high,
                  size: 48,
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                Text(
                  '2단계: AI 자동 조정',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'RPE 데이터를 바탕으로 다음 운동을 자동 조정합니다',
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          WorkoutAdjustmentCard(
            adjustment: adjustment,
            originalReps: scenario.originalReps,
            originalRest: const Duration(seconds: 60),
            onAccept: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecoveryPage() {
    final recovery = _calculateDemoRecovery();
    final rpeHistory = _scenarioRPEHistory[_currentScenario];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.favorite,
                  size: 48,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  '3단계: 회복 상태 분석',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '누적 데이터로 회복 상태를 분석하고 조언을 제공합니다',
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          RecoveryDashboardWidget(
            recoveryStatus: recovery,
            recentRPE: rpeHistory,
            showChart: rpeHistory.isNotEmpty,
          ),
          const SizedBox(height: 20),
          _buildDemoSummary(),
        ],
      ),
    );
  }

  Widget _buildDemoSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50,
            Colors.purple.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.stars,
                color: Colors.blue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                '🚀 투자 포인트',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildKeyPoint(
            '🧠 과학적 근거',
            'RPE 기반 운동 강도 조정 (스포츠과학 논문 근거)',
          ),
          _buildKeyPoint(
            '🎯 개인화 AI',
            '사용자별 맞춤 운동 계획 자동 생성',
          ),
          _buildKeyPoint(
            '📊 데이터 기반',
            '회복 상태 분석으로 오버트레이닝 방지',
          ),
          _buildKeyPoint(
            '💰 수익 모델',
            '개인화 = 높은 리텐션 = 안정적 구독 수익',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.trending_up,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '예상 효과: 일반 운동앱 대비 2-3배 높은 사용자 유지율',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.green[700],
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

  Widget _buildKeyPoint(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
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

/// 데모 시나리오 데이터 클래스
class DemoScenario {
  final String userType;
  final String description;
  final FitnessGoal goal;
  final FitnessLevel level;
  final int rpeValue;
  final String expectedAdjustment;
  final int originalReps;
  final Color backgroundColor;
  final Color accentColor;

  const DemoScenario({
    required this.userType,
    required this.description,
    required this.goal,
    required this.level,
    required this.rpeValue,
    required this.expectedAdjustment,
    required this.originalReps,
    required this.backgroundColor,
    required this.accentColor,
  });
}
