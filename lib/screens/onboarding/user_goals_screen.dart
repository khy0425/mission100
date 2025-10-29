import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';
import '../auth/login_screen.dart';
import '../misc/permission_screen.dart';

enum FitnessLevel { beginner, intermediate, advanced }

enum FitnessGoal { weightLoss, muscleGain, endurance, general }

class UserGoalsScreen extends StatefulWidget {
  const UserGoalsScreen({super.key});

  @override
  State<UserGoalsScreen> createState() => _UserGoalsScreenState();
}

class _UserGoalsScreenState extends State<UserGoalsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 사용자 정보
  double? _currentWeight;
  // TODO: 향후 목표 체중 기능 추가 시 사용
  double? _targetWeight; // ignore: unused_field
  FitnessLevel? _fitnessLevel;
  FitnessGoal? _fitnessGoal;
  final List<String> _workoutTimes = [];
  bool _likesCompetition = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showSignupPrompt();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showSignupPrompt() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.stars, color: Color(AppColors.primaryColor)),
            SizedBox(width: 8),
            Text('맞춤형 프로그램 준비완료!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_getGoalText()}를 위한 개인화된 프로그램이 준비되었습니다!',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('🎁 런칭 이벤트 혜택:'),
            const Text('• 1개월 무료 프리미엄'),
            const Text('• 개인화된 운동 계획'),
            const Text('• 진행상황 클라우드 백업'),
            const Text('• 상세한 체성분 분석'),
            const SizedBox(height: 16),
            const Text(
              '지금 가입하고 목표를 달성해보세요! 💪',
              style: TextStyle(
                color: Color(AppColors.primaryColor),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // 목표 설정 건너뛰고 권한 설정으로 이동
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const PermissionScreen()),
              );
            },
            child: const Text('나중에'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // 목표 설정 완료 후 로그인 화면으로 이동
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(AppColors.primaryColor),
              foregroundColor: Colors.white,
            ),
            child: const Text('무료로 시작하기'),
          ),
        ],
      ),
    );
  }

  String _getGoalText() {
    switch (_fitnessGoal) {
      case FitnessGoal.weightLoss:
        return '체중 감량';
      case FitnessGoal.muscleGain:
        return '근육 증가';
      case FitnessGoal.endurance:
        return '체력 향상';
      case FitnessGoal.general:
      default:
        return '건강한 몸만들기';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor:
            isDark ? Colors.grey[900] : const Color(AppColors.primaryColor),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('목표 설정'),
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousPage,
              )
            : null,
      ),
      body: Column(
        children: [
          // 진행 표시기
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: List.generate(5, (index) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: index <= _currentPage
                          ? const Color(AppColors.primaryColor)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),

          // 페이지 내용
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() => _currentPage = page);
              },
              children: [
                _buildWeightPage(),
                _buildFitnessLevelPage(),
                _buildGoalPage(),
                _buildWorkoutTimePage(),
                _buildMotivationPage(),
              ],
            ),
          ),

          // 다음 버튼
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canProceed() ? _nextPage : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(AppColors.primaryColor),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentPage < 4 ? '다음' : '완료',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentPage) {
      case 0:
        return _currentWeight != null;
      case 1:
        return _fitnessLevel != null;
      case 2:
        return _fitnessGoal != null;
      case 3:
        return _workoutTimes.isNotEmpty;
      case 4:
        return true;
      default:
        return false;
    }
  }

  Widget _buildWeightPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.monitor_weight,
            size: 60,
            color: Color(AppColors.primaryColor),
          ),
          const SizedBox(height: 24),
          Text(
            '현재 체중을 알려주세요',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '더 정확한 칼로리 소모량과 진행상황을 계산해드려요',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '현재 체중 (kg)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixText: 'kg',
            ),
            onChanged: (value) {
              setState(() {
                _currentWeight = double.tryParse(value);
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '목표 체중 (kg, 선택사항)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixText: 'kg',
            ),
            onChanged: (value) {
              setState(() {
                _targetWeight = double.tryParse(value);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFitnessLevelPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.fitness_center,
            size: 60,
            color: Color(AppColors.primaryColor),
          ),
          const SizedBox(height: 24),
          Text(
            '운동 경험이 어느정도인가요?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '레벨에 맞는 운동 강도로 조절해드려요',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          ...FitnessLevel.values.map((level) {
            String title, description;
            switch (level) {
              case FitnessLevel.beginner:
                title = '초보자';
                description = '운동을 처음 시작하거나 오랜만에 하는 경우';
                break;
              case FitnessLevel.intermediate:
                title = '중급자';
                description = '꾸준히 운동을 해왔고 기본 동작에 익숙한 경우';
                break;
              case FitnessLevel.advanced:
                title = '고급자';
                description = '강도 높은 운동을 원하고 다양한 변형을 시도하고 싶은 경우';
                break;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: _fitnessLevel == level ? 4 : 1,
                color: _fitnessLevel == level
                    ? const Color(AppColors.primaryColor).withValues(alpha: 0.1)
                    : null,
                child: ListTile(
                  title: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _fitnessLevel == level
                          ? const Color(AppColors.primaryColor)
                          : null,
                    ),
                  ),
                  subtitle: Text(description),
                  leading: Radio<FitnessLevel>(
                    value: level,
                    groupValue: _fitnessLevel,
                    onChanged: (value) {
                      setState(() => _fitnessLevel = value);
                    },
                    activeColor: const Color(AppColors.primaryColor),
                  ),
                  onTap: () {
                    setState(() => _fitnessLevel = level);
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGoalPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.track_changes,
            size: 60,
            color: Color(AppColors.primaryColor),
          ),
          const SizedBox(height: 24),
          Text(
            '주요 목표를 선택해주세요',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '목표에 맞는 운동 계획과 팁을 제공해드려요',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          ...FitnessGoal.values.map((goal) {
            String title, description, emoji;
            switch (goal) {
              case FitnessGoal.weightLoss:
                title = '체중 감량';
                description = '체지방을 줄이고 날씬한 몸매 만들기';
                emoji = '🔥';
                break;
              case FitnessGoal.muscleGain:
                title = '근육 증가';
                description = '탄탄한 근육과 매력적인 상체 라인 만들기';
                emoji = '💪';
                break;
              case FitnessGoal.endurance:
                title = '체력 향상';
                description = '지구력과 전반적인 체력 개선하기';
                emoji = '⚡';
                break;
              case FitnessGoal.general:
                title = '전반적인 건강';
                description = '건강한 생활습관과 균형잡힌 몸만들기';
                emoji = '🌟';
                break;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: _fitnessGoal == goal ? 4 : 1,
                color: _fitnessGoal == goal
                    ? const Color(AppColors.primaryColor).withValues(alpha: 0.1)
                    : null,
                child: ListTile(
                  title: Row(
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _fitnessGoal == goal
                              ? const Color(AppColors.primaryColor)
                              : null,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(description),
                  leading: Radio<FitnessGoal>(
                    value: goal,
                    groupValue: _fitnessGoal,
                    onChanged: (value) {
                      setState(() => _fitnessGoal = value);
                    },
                    activeColor: const Color(AppColors.primaryColor),
                  ),
                  onTap: () {
                    setState(() => _fitnessGoal = goal);
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWorkoutTimePage() {
    final times = [
      '새벽 (5-7시)',
      '아침 (7-9시)',
      '오전 (9-12시)',
      '점심 (12-14시)',
      '오후 (14-17시)',
      '저녁 (17-20시)',
      '밤 (20-22시)',
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.schedule,
            size: 60,
            color: Color(AppColors.primaryColor),
          ),
          const SizedBox(height: 24),
          Text(
            '주로 언제 운동하시나요?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '선호하는 시간대에 맞춰 알림을 설정해드려요 (복수선택 가능)',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          ...times.map((time) {
            final isSelected = _workoutTimes.contains(time);
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
                        _workoutTimes.add(time);
                      } else {
                        _workoutTimes.remove(time);
                      }
                    });
                  },
                  activeColor: const Color(AppColors.primaryColor),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMotivationPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.psychology,
            size: 60,
            color: Color(AppColors.primaryColor),
          ),
          const SizedBox(height: 24),
          Text(
            '어떤 방식이 더 동기부여가 되나요?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '선호하는 방식으로 맞춤형 격려와 도전을 제공해드려요',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          Card(
            elevation: _likesCompetition ? 4 : 1,
            color: _likesCompetition
                ? const Color(AppColors.primaryColor).withValues(alpha: 0.1)
                : null,
            child: ListTile(
              title: const Row(
                children: [
                  Text('🏆', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text('경쟁과 순위', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              subtitle: const Text('다른 사용자와 비교하고 순위를 확인하며 동기부여'),
              leading: Radio<bool>(
                value: true,
                groupValue: _likesCompetition,
                onChanged: (value) {
                  setState(() => _likesCompetition = value!);
                },
                activeColor: const Color(AppColors.primaryColor),
              ),
              onTap: () {
                setState(() => _likesCompetition = true);
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: !_likesCompetition ? 4 : 1,
            color: !_likesCompetition
                ? const Color(AppColors.primaryColor).withValues(alpha: 0.1)
                : null,
            child: ListTile(
              title: const Row(
                children: [
                  Text('📈', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text('개인 기록', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              subtitle: const Text('나만의 목표 달성과 개인 기록 향상에 집중'),
              leading: Radio<bool>(
                value: false,
                groupValue: _likesCompetition,
                onChanged: (value) {
                  setState(() => _likesCompetition = value!);
                },
                activeColor: const Color(AppColors.primaryColor),
              ),
              onTap: () {
                setState(() => _likesCompetition = false);
              },
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    const Color(AppColors.primaryColor).withValues(alpha: 0.3),
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
        ],
      ),
    );
  }
}
