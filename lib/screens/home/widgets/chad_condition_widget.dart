import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../generated/app_localizations.dart';
import '../../../services/chad/chad_condition_service.dart';
import '../../../utils/config/constants.dart';

/// Chad 컨디션 체크 위젯
///
/// 기능:
/// - 오늘의 Chad 컨디션 체크
/// - 개인화된 Chad 메시지 표시
/// - 컨디션별 운동 추천
/// - 이모지 버튼으로 간편한 입력
class ChadConditionWidget extends StatefulWidget {
  const ChadConditionWidget({super.key});

  @override
  State<ChadConditionWidget> createState() => _ChadConditionWidgetState();
}

class _ChadConditionWidgetState extends State<ChadConditionWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    // Chad 컨디션 서비스 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChadConditionService>(context, listen: false).initialize();
    });
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // 애니메이션 시작
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _slideController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<ChadConditionService>(
      builder: (context, chadService, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              margin: const EdgeInsets.all(AppConstants.paddingM),
              padding: const EdgeInsets.all(AppConstants.paddingL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade50,
                    Colors.purple.shade50,
                  ],
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Chad 이미지 + 말풍선 섹션
                  _buildChadSection(context, chadService),

                  const SizedBox(height: AppConstants.paddingL),

                  // 컨디션 입력 또는 추천 섹션
                  chadService.hasCheckedToday
                      ? _buildRecommendationSection(context, chadService)
                      : _buildConditionInputSection(context, chadService),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChadSection(
      BuildContext context, ChadConditionService chadService) {
    return Row(
      children: [
        // Chad 이미지
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(
              chadService.getChadImageForCondition(),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(width: AppConstants.paddingM),

        // Chad 말풍선
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chad 라벨
                Row(
                  children: [
                    Icon(
                      Icons.chat_bubble,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context).chadSays,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Chad 메시지
                Text(
                  chadService.getChadConditionMessage(),
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConditionInputSection(
      BuildContext context, ChadConditionService chadService) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context).selectTodayCondition,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),

        const SizedBox(height: AppConstants.paddingM),

        // 컨디션 선택 버튼들
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: ChadCondition.values.map((condition) {
            return _buildConditionButton(
              condition,
              () => _selectCondition(chadService, condition),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildConditionButton(ChadCondition condition, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              condition.emoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              condition.koreanName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationSection(
      BuildContext context, ChadConditionService chadService) {
    return Column(
      children: [
        // 오늘 컨디션 표시
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).todayCondition,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              '${chadService.currentCondition?.emoji} ${chadService.currentCondition?.koreanName}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(AppColors.primaryColor),
                  ),
            ),
          ],
        ),

        const SizedBox(height: AppConstants.paddingM),

        // Chad 운동 추천
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.paddingM),
          decoration: BoxDecoration(
            color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).chadRecommendedWorkout,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(AppColors.primaryColor),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                chadService.getTodayWorkoutRecommendation(),
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.paddingM),

        // 컨디션 다시 체크 버튼
        TextButton.icon(
          onPressed: () => _resetCondition(chadService),
          icon: const Icon(Icons.refresh, size: 18),
          label: Text(AppLocalizations.of(context).recheckCondition),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Future<void> _selectCondition(
      ChadConditionService chadService, ChadCondition condition) async {
    await chadService.updateCondition(condition);

    // 성공 피드백
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).chadConfirmedCondition(condition.koreanName),
          ),
          backgroundColor: const Color(AppColors.primaryColor),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _resetCondition(ChadConditionService chadService) async {
    await chadService.resetCondition();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).canRecheckCondition),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
