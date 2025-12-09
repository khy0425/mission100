import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../utils/config/constants.dart';
import '../../models/achievement.dart';
import '../../services/achievements/achievement_service.dart';
import '../../services/payment/ad_service.dart';
import '../../widgets/achievements/enhanced_achievement_card.dart';
import '../../widgets/achievements/achievement_unlock_animation.dart';
import '../../widgets/achievements/achievement_detail_dialog.dart';
import '../../widgets/achievements/achievements_stats_header_widget.dart';
import '../../widgets/achievements/achievements_tab_bar_widget.dart';
import '../../widgets/achievements/achievements_empty_state_widget.dart';
import '../../widgets/achievements/achievements_banner_ad_widget.dart';
import '../../generated/l10n/app_localizations.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Achievement> _unlockedAchievements = [];
  List<Achievement> _lockedAchievements = [];
  int _totalXP = 0;
  int _unlockedCount = 0;
  int _totalCount = 0;
  Map<AchievementRarity, int> _rarityCount = {};
  bool _isLoading = true;

  // 업적 화면 전용 배너 광고
  BannerAd? _achievementsBannerAd;

  // 업적 달성 애니메이션 상태
  bool _showUnlockAnimation = false;
  Achievement? _currentUnlockedAchievement;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAchievements();
    _createAchievementsBannerAd();

    // 업적 달성 시 업적 목록 새로고침을 위한 콜백 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AchievementService.setOnAchievementUnlocked(() {
        if (mounted) {
          _loadAchievements();
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _achievementsBannerAd?.dispose();
    super.dispose();
  }

  Future<void> _loadAchievements() async {
    setState(() => _isLoading = true);

    try {
      // 업적 서비스 초기화
      await AchievementService.initialize();

      // 업적 진행도 체크 및 업데이트 (새로 달성된 업적 확인)
      await _checkForNewAchievements();

      // 데이터 로드
      final unlocked = await AchievementService.getUnlockedAchievements();
      final locked = await AchievementService.getLockedAchievements();
      final totalXP = await AchievementService.getTotalXP();
      final unlockedCount = await AchievementService.getUnlockedCount();
      final totalCount = await AchievementService.getTotalCount();
      final rarityCount = await AchievementService.getUnlockedCountByRarity();

      setState(() {
        _unlockedAchievements = unlocked;
        _lockedAchievements = locked;
        _totalXP = totalXP;
        _unlockedCount = unlockedCount;
        _totalCount = totalCount;
        _rarityCount = rarityCount;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('')));
      }
    }
  }

  /// 업적 화면 전용 배너 광고 생성
  void _createAchievementsBannerAd() {
    _achievementsBannerAd = AdService().createBannerAd();
    _achievementsBannerAd?.load();
  }

  /// 업적 달성 애니메이션 표시
  void _showAchievementUnlockAnimation(Achievement achievement) {
    setState(() {
      _currentUnlockedAchievement = achievement;
      _showUnlockAnimation = true;
    });

    // 3초 후 애니메이션 숨김
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showUnlockAnimation = false;
          _currentUnlockedAchievement = null;
        });
      }
    });
  }

  /// 업적 진행도 체크 및 새로 달성된 업적 확인
  Future<void> _checkForNewAchievements() async {
    final newlyUnlocked = await AchievementService.checkAndUpdateAchievements();

    // 새로 달성된 업적이 있으면 애니메이션 표시
    for (final achievement in newlyUnlocked) {
      _showAchievementUnlockAnimation(achievement);
      // 여러 업적이 동시에 달성된 경우 순차적으로 표시
      await Future<void>.delayed(const Duration(seconds: 4));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Color(
        isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      ),
      body: Stack(
        children: [
          // 메인 콘텐츠
          Column(
            children: [
              // 메인 콘텐츠
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // 헤더 통계
                    SliverToBoxAdapter(
                      child: AchievementsStatsHeaderWidget(
                        isLoading: _isLoading,
                        totalXP: _totalXP,
                        unlockedCount: _unlockedCount,
                        totalCount: _totalCount,
                        rarityCount: _rarityCount,
                      ),
                    ),

                    // 탭바
                    SliverToBoxAdapter(
                      child: AchievementsTabBarWidget(
                        controller: _tabController,
                        unlockedCount: _unlockedAchievements.length,
                        lockedCount: _lockedAchievements.length,
                      ),
                    ),

                    // 업적 리스트
                    SliverFillRemaining(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildUnlockedAchievements(),
                          _buildLockedAchievements(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 하단 배너 광고
              AchievementsBannerAdWidget(bannerAd: _achievementsBannerAd),
            ],
          ),

          // 업적 달성 애니메이션 오버레이
          if (_showUnlockAnimation && _currentUnlockedAchievement != null)
            AchievementUnlockAnimation(
              achievement: _currentUnlockedAchievement!,
              onComplete: () {
                setState(() {
                  _showUnlockAnimation = false;
                  _currentUnlockedAchievement = null;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildUnlockedAchievements() {
    if (_unlockedAchievements.isEmpty) {
      return AchievementsEmptyStateWidget(
        icon: Icons.emoji_events_outlined,
        title: AppLocalizations.of(context).noAchievementsYet,
        message: AppLocalizations.of(context).startWorkoutForAchievements,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      itemCount: _unlockedAchievements.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.paddingM),
          child: EnhancedAchievementCard(
            achievement: _unlockedAchievements[index],
            showProgress: false, // 완료된 업적이므로 진행도 바 숨김
            onTap: () => _showAchievementDetail(_unlockedAchievements[index]),
          ),
        );
      },
    );
  }

  Widget _buildLockedAchievements() {
    if (_lockedAchievements.isEmpty) {
      return AchievementsEmptyStateWidget(
        icon: Icons.lock_outline,
        title: AppLocalizations.of(context).allAchievementsUnlocked,
        message: AppLocalizations.of(context).congratulationsChad,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      itemCount: _lockedAchievements.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.paddingM),
          child: EnhancedAchievementCard(
            achievement: _lockedAchievements[index],
            showProgress: true, // 미완료 업적이므로 진행도 바 표시
            onTap: () => _showAchievementDetail(_lockedAchievements[index]),
          ),
        );
      },
    );
  }

  /// 업적 상세 정보 다이얼로그 표시
  void _showAchievementDetail(Achievement achievement) {
    showDialog<void>(
      context: context,
      builder: (context) => AchievementDetailDialog(achievement: achievement),
    );
  }
}
