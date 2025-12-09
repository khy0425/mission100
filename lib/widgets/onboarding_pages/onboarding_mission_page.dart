import 'package:flutter/material.dart';
import 'dart:async';
import '../../utils/config/constants.dart';
import '../../generated/l10n/app_localizations.dart';

/// 온보딩 미션 페이지
class OnboardingMissionPage extends StatefulWidget {
  const OnboardingMissionPage({super.key});

  @override
  State<OnboardingMissionPage> createState() => _OnboardingMissionPageState();
}

class _OnboardingMissionPageState extends State<OnboardingMissionPage> {
  late ScrollController _scrollController;
  Timer? _scrollHintTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startScrollHintAnimation();
  }

  void _startScrollHintAnimation() {
    // 화면 로드 완료 후 1.5초 뒤에 스크롤 힌트 애니메이션 시작
    _scrollHintTimer = Timer(const Duration(milliseconds: 1500), () {
      if (_scrollController.hasClients) {
        _performScrollHint();
      }
    });
  }

  void _performScrollHint() async {
    if (!_scrollController.hasClients) return;

    try {
      // 현재 위치 저장
      final currentPosition = _scrollController.offset;

      // 살짝 아래로 스크롤 (100px 정도)
      _scrollController.animateTo(
        currentPosition + 100,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      // 0.8초 대기 (사용자가 인지할 시간)
      await Future<void>.delayed(const Duration(milliseconds: 800));

      // 원래 위치로 부드럽게 돌아가기
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          currentPosition,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
        );
      }
    } catch (e) {
      // 애니메이션 중 에러 발생 시 무시 (사용자가 스크롤하는 경우 등)
      debugPrint('스크롤 힌트 애니메이션 에러: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollHintTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppConstants.paddingXL),
      child: Column(
        children: [
          const SizedBox(height: AppConstants.paddingXL),
          const Icon(
            Icons.track_changes,
            size: 100,
            color: Color(AppColors.primaryColor),
          ),
          const SizedBox(height: AppConstants.paddingXL),
          Text(
            l10n.onboardingMissionPersonalizedProgram,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingXL),
          _buildDreamStageCard(
            context,
            icon: '💤',
            title: l10n.onboardingMissionWeek12Title,
            description: l10n.onboardingMissionWeek12Desc,
            color: const Color(AppColors.primaryColor),
          ),
          const SizedBox(height: AppConstants.paddingM),
          _buildDreamStageCard(
            context,
            icon: '🌙',
            title: l10n.onboardingMissionWeek34Title,
            description: l10n.onboardingMissionWeek34Desc,
            color: Colors.blue,
          ),
          const SizedBox(height: AppConstants.paddingM),
          _buildDreamStageCard(
            context,
            icon: '✨',
            title: l10n.onboardingMissionWeek58Title,
            description: l10n.onboardingMissionWeek58Desc,
            color: Colors.purple,
          ),
          const SizedBox(height: AppConstants.paddingXL),
        ],
      ),
    );
  }

  /// 자각몽 단계 카드 빌더
  Widget _buildDreamStageCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String description,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Row(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 36),
          ),
          const SizedBox(width: AppConstants.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
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
