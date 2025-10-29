import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/chad/chad_active_recovery_service.dart';
import '../../widgets/chad/chad_active_recovery_widget.dart';
import '../../utils/constants.dart';

/// Chad 액티브 리커버리 전용 화면
class ChadActiveRecoveryScreen extends StatefulWidget {
  const ChadActiveRecoveryScreen({super.key});

  @override
  State<ChadActiveRecoveryScreen> createState() =>
      _ChadActiveRecoveryScreenState();
}

class _ChadActiveRecoveryScreenState extends State<ChadActiveRecoveryScreen>
    with TickerProviderStateMixin {
  late AnimationController _pageController;
  late Animation<double> _pageAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pageController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pageAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageController,
      curve: Curves.easeOutCubic,
    ));

    _pageController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChadActiveRecoveryService>(
      create: (_) => ChadActiveRecoveryService(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chad 액티브 리커버리'),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Consumer<ChadActiveRecoveryService>(
              builder: (context, recoveryService, child) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => recoveryService.initialize(),
                  tooltip: 'Chad 활동 새로고침',
                );
              },
            ),
          ],
        ),
        body: AnimatedBuilder(
          animation: _pageAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - _pageAnimation.value)),
              child: Opacity(
                opacity: _pageAnimation.value,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.paddingM),
                  child: Column(
                    children: [
                      // Chad 메인 액티브 리커버리 위젯
                      const ChadActiveRecoveryWidget(showFullDetails: true),

                      const SizedBox(height: AppConstants.paddingL),

                      // 추가 기능들
                      _buildAdditionalFeatures(context),

                      const SizedBox(height: AppConstants.paddingL),

                      // Chad 회복 팁 섹션
                      _buildRecoveryTips(context),

                      const SizedBox(height: AppConstants.paddingXL),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAdditionalFeatures(BuildContext context) {
    return Consumer<ChadActiveRecoveryService>(
      builder: (context, recoveryService, child) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chad 회복 관리 도구',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingM),

                // 주간 리포트
                _buildFeatureCard(
                  context,
                  icon: Icons.analytics,
                  title: '주간 회복 리포트',
                  subtitle: recoveryService.getWeeklyRecoveryReport(),
                  onTap: () => _showWeeklyReport(context, recoveryService),
                ),

                const SizedBox(height: AppConstants.paddingS),

                // 내일 미리보기
                _buildFeatureCard(
                  context,
                  icon: Icons.preview,
                  title: '내일 활동 미리보기',
                  subtitle: 'Chad가 내일 추천할 활동들을 미리 확인하세요',
                  onTap: () => _showTomorrowPreview(context, recoveryService),
                ),

                const SizedBox(height: AppConstants.paddingS),

                // Chad 회복 설정
                _buildFeatureCard(
                  context,
                  icon: Icons.settings,
                  title: 'Chad 회복 설정',
                  subtitle: '개인화된 회복 활동 조정',
                  onTap: () => _showRecoverySettings(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusM),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.blue[600],
                size: 20,
              ),
            ),
            const SizedBox(width: AppConstants.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecoveryTips(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.lightbulb,
                    color: Colors.green[600],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Chad의 회복 꿀팁',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingM),
            ..._getChadRecoveryTips().map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 6, right: 12),
                        decoration: BoxDecoration(
                          color: Colors.green[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          tip,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  List<String> _getChadRecoveryTips() {
    return [
      '💧 충분한 수분 섭취: Chad도 물을 많이 마셔! 하루 2L 이상 마시자!',
      '😴 질 좋은 수면: Chad의 비밀은 7-8시간 숙면! 근육이 자라는 시간이야!',
      '🥗 균형잡힌 영양: Chad는 단백질과 탄수화물의 황금비율을 알고 있어!',
      '🧘‍♂️ 스트레스 관리: Chad도 명상해! 마음이 편해야 몸도 회복돼!',
      '🌡️ 적절한 온도: Chad는 시원한 샤워 후 따뜻한 휴식을 추천해!',
      '⏰ 규칙적인 루틴: Chad처럼 일정한 생활 패턴이 회복의 핵심!',
    ];
  }

  void _showWeeklyReport(
      BuildContext context, ChadActiveRecoveryService recoveryService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chad 주간 회복 리포트'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recoveryService.getWeeklyRecoveryReport()),
            const SizedBox(height: 16),
            const Text(
              'Chad가 분석한 이번 주 회복 패턴:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '• 꾸준한 회복 활동으로 컨디션 유지 중\n'
              '• 개인화된 활동이 효과적으로 작용\n'
              '• 다음 주도 Chad와 함께 완주하자!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showTomorrowPreview(
      BuildContext context, ChadActiveRecoveryService recoveryService) {
    final tomorrowActivities = recoveryService.getTomorrowPreview();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('내일의 Chad 활동'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Chad가 내일 추천할 활동들이야! 미리 준비해두자! 💪'),
              const SizedBox(height: 16),
              ...tomorrowActivities.take(2).map((activity) => ListTile(
                    leading: Icon(_getIconForActivityType(activity.type)),
                    title: Text(activity.title),
                    subtitle: Text('${activity.durationMinutes}분'),
                    dense: true,
                  )),
              if (tomorrowActivities.length > 2)
                Text(
                  '외 ${tomorrowActivities.length - 2}개 활동...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showRecoverySettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chad 회복 설정'),
        content: const Text(
          'Chad 회복 설정 기능은 곧 추가될 예정이야!\n\n'
          '• 개인화된 활동 강도 조정\n'
          '• Chad 알림 시간 설정\n'
          '• 선호하는 회복 활동 선택\n\n'
          'Chad와 함께 더 스마트한 회복 관리를 기대해줘! 💪',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  IconData _getIconForActivityType(ActiveRecoveryType type) {
    switch (type) {
      case ActiveRecoveryType.lightMovement:
        return Icons.fitness_center;
      case ActiveRecoveryType.stretching:
        return Icons.self_improvement;
      case ActiveRecoveryType.breathing:
        return Icons.air;
      case ActiveRecoveryType.walking:
        return Icons.directions_walk;
      case ActiveRecoveryType.mindfulness:
        return Icons.psychology;
      case ActiveRecoveryType.rest:
        return Icons.bed;
    }
  }
}
