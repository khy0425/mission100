import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/chad/chad_active_recovery_service.dart';
import '../screens/recovery/chad_active_recovery_screen.dart';
import '../models/rpe_data.dart';
import '../utils/constants.dart';

/// Chad 액티브 리커버리 위젯
///
/// 기능:
/// - Chad 회복 레벨별 맞춤 활동 표시
/// - 개인화된 Chad 메시지 및 이미지
/// - 활동별 세부 정보 및 완료 처리
/// - 애니메이션 효과
class ChadActiveRecoveryWidget extends StatefulWidget {
  final bool showFullDetails;

  const ChadActiveRecoveryWidget({
    super.key,
    this.showFullDetails = true,
  });

  @override
  State<ChadActiveRecoveryWidget> createState() =>
      _ChadActiveRecoveryWidgetState();
}

class _ChadActiveRecoveryWidgetState extends State<ChadActiveRecoveryWidget>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _cardController;
  late Animation<double> _headerAnimation;
  late Animation<double> _cardAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    // Chad 액티브 리커버리 서비스 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChadActiveRecoveryService>(context, listen: false)
          .initialize();
    });
  }

  void _initializeAnimations() {
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutBack,
    ));

    _cardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutCubic,
    ));

    // 애니메이션 시작 (순차적)
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<ChadActiveRecoveryService>(
      builder: (context, recoveryService, child) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChadActiveRecoveryScreen(),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getGradientStartColor(recoveryService.currentRecoveryLevel),
                  _getGradientEndColor(recoveryService.currentRecoveryLevel),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusL),
              boxShadow: [
                BoxShadow(
                  color: _getGradientStartColor(
                          recoveryService.currentRecoveryLevel)
                      .withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Chad 액티브 리커버리 헤더
                _buildRecoveryHeader(context, recoveryService),

                if (widget.showFullDetails) ...{
                  const SizedBox(height: AppConstants.paddingL),

                  // Chad 추천 메시지
                  _buildChadRecommendation(context, recoveryService),

                  const SizedBox(height: AppConstants.paddingM),

                  // 오늘의 활동 목록
                  _buildTodayActivities(context, recoveryService),
                }
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecoveryHeader(
      BuildContext context, ChadActiveRecoveryService recoveryService) {
    return AnimatedBuilder(
      animation: _headerAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _headerAnimation.value,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: Row(
              children: [
                // Chad 이미지
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      _getChadImageForLevel(
                          recoveryService.currentRecoveryLevel),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.self_improvement,
                            size: 30,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: AppConstants.paddingM),

                // 제목과 설명
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chad 액티브 리커버리',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${recoveryService.currentRecoveryLevel.label} 레벨 ${recoveryService.currentRecoveryLevel.emoji}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // 완료 카운트 배지
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: _getGradientStartColor(
                            recoveryService.currentRecoveryLevel),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${recoveryService.completedActivitiesCount}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getGradientStartColor(
                              recoveryService.currentRecoveryLevel),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChadRecommendation(
      BuildContext context, ChadActiveRecoveryService recoveryService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          recoveryService.getTodayRecoveryRecommendation(),
          style: const TextStyle(
            fontSize: 14,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTodayActivities(
      BuildContext context, ChadActiveRecoveryService recoveryService) {
    if (recoveryService.todayActivities.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppConstants.paddingL),
        child: Text(
          'Chad가 활동을 준비 중이야! 잠시만 기다려줘! 💪',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _cardAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _cardAnimation.value)),
          child: Opacity(
            opacity: _cardAnimation.value,
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppConstants.paddingL,
                right: AppConstants.paddingL,
                bottom: AppConstants.paddingL,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '오늘의 Chad 활동',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingM),
                  ...recoveryService.todayActivities
                      .asMap()
                      .entries
                      .map((entry) {
                    final int index = entry.key;
                    final ActiveRecoveryActivity activity = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom:
                              index < recoveryService.todayActivities.length - 1
                                  ? AppConstants.paddingS
                                  : 0),
                      child: _buildActivityCard(
                          context, activity, recoveryService),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivityCard(
      BuildContext context,
      ActiveRecoveryActivity activity,
      ChadActiveRecoveryService recoveryService) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 활동 헤더
          Row(
            children: [
              Icon(
                _getIconForActivityType(activity.type),
                size: 24,
                color: _getGradientStartColor(
                    recoveryService.currentRecoveryLevel),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _getGradientStartColor(
                            recoveryService.currentRecoveryLevel),
                      ),
                    ),
                    Text(
                      '${activity.durationMinutes}분 • ${activity.caloriesBurn}kcal',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showActivityDetails(context, activity),
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 활동 설명
          Text(
            activity.description,
            style: const TextStyle(
              fontSize: 13,
              height: 1.3,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 12),

          // Chad 메시지 (간단 버전)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  _getGradientStartColor(recoveryService.currentRecoveryLevel)
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              activity.chadMessage.split('\n').first, // 첫 번째 줄만 표시
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: _getGradientStartColor(
                    recoveryService.currentRecoveryLevel),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 완료 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () =>
                  _completeActivity(context, activity, recoveryService),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getGradientStartColor(
                    recoveryService.currentRecoveryLevel),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                '${activity.title} 시작하기',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showActivityDetails(
      BuildContext context, ActiveRecoveryActivity activity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildActivityDetailSheet(context, activity),
    );
  }

  Widget _buildActivityDetailSheet(
      BuildContext context, ActiveRecoveryActivity activity) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 핸들
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 헤더
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: Row(
              children: [
                Icon(
                  _getIconForActivityType(activity.type),
                  size: 30,
                  color: Colors.blue[600],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${activity.durationMinutes}분 • ${activity.caloriesBurn}kcal',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // 내용
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chad 메시지
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppConstants.paddingM),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      activity.chadMessage,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppConstants.paddingL),

                  // 설명
                  const Text(
                    '활동 설명',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activity.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: AppConstants.paddingL),

                  // 진행 방법
                  const Text(
                    '진행 방법',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...activity.instructions.map((instruction) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          instruction,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      )),

                  const SizedBox(height: AppConstants.paddingL),

                  // 효과
                  const Text(
                    '기대 효과',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...activity.benefits.map((benefit) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Colors.green[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              benefit,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: AppConstants.paddingXL),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _completeActivity(BuildContext context, ActiveRecoveryActivity activity,
      ChadActiveRecoveryService recoveryService) {
    recoveryService.completeActivity(activity.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${activity.title} 완료! Chad가 자랑스러워해! 💪'),
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // 헬퍼 메서드들

  Color _getGradientStartColor(RecoveryLevel level) {
    switch (level) {
      case RecoveryLevel.excellent:
        return Colors.green.shade400;
      case RecoveryLevel.good:
        return Colors.blue.shade400;
      case RecoveryLevel.fair:
        return Colors.orange.shade400;
      case RecoveryLevel.poor:
        return Colors.purple.shade400;
    }
  }

  Color _getGradientEndColor(RecoveryLevel level) {
    switch (level) {
      case RecoveryLevel.excellent:
        return Colors.green.shade600;
      case RecoveryLevel.good:
        return Colors.blue.shade600;
      case RecoveryLevel.fair:
        return Colors.orange.shade600;
      case RecoveryLevel.poor:
        return Colors.purple.shade600;
    }
  }

  String _getChadImageForLevel(RecoveryLevel level) {
    switch (level) {
      case RecoveryLevel.excellent:
        return 'assets/images/기본차드.jpg';
      case RecoveryLevel.good:
        return 'assets/images/기본차드.jpg';
      case RecoveryLevel.fair:
        return 'assets/images/기본차드.jpg';
      case RecoveryLevel.poor:
        return 'assets/images/기본차드.jpg';
    }
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
