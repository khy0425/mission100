import 'package:flutter/material.dart';
import 'dart:async';
import '../../utils/config/constants.dart';
import 'onboarding_level_badge.dart';

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
            '당신의 레벨에 맞춘\n맞춤형 프로그램',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingXL),
          const OnboardingLevelBadge(
            level: 'Rookie',
            label: '초보자',
            range: '5개 이하',
            color: Color(AppColors.primaryColor),
          ),
          const SizedBox(height: AppConstants.paddingM),
          const OnboardingLevelBadge(
            level: 'Rising',
            label: '중급자',
            range: '6-10개',
            color: Colors.green,
          ),
          const SizedBox(height: AppConstants.paddingM),
          const OnboardingLevelBadge(
            level: 'Alpha',
            label: '고급자',
            range: '11개 이상',
            color: Colors.orange,
          ),
          const SizedBox(height: AppConstants.paddingXL),
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(AppColors.primaryColor),
                  size: 32,
                ),
                const SizedBox(width: AppConstants.paddingM),
                Expanded(
                  child: Text(
                    '걱정 마세요!\n어떤 레벨이든 14주 후\n100개를 달성할 수 있습니다',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.5,
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
}
