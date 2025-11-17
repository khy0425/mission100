import 'package:flutter/material.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../models/user_profile.dart';
import '../../../models/character_evolution.dart';
import '../../../models/user_subscription.dart';
import '../../../utils/config/constants.dart';
import '../../../utils/xp_calculator.dart';
import '../../../services/auth/auth_service.dart';
import '../../settings/subscription_screen.dart';

/// Dream Spirit 진화 단계 카드 위젯
class LevelCardWidget extends StatelessWidget {
  final UserProfile userProfile;
  final int totalXP;

  const LevelCardWidget({
    super.key,
    required this.userProfile,
    required this.totalXP,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    // XP 기반 레벨 계산
    final levelInfo = XPCalculator.getLevelInfo(totalXP);
    final currentWeek = levelInfo.week;

    // Week에 따른 Dream Spirit 단계 가져오기
    final currentStage = CharacterEvolution.getStageForWeek(currentWeek);
    final nextStage = CharacterEvolution.getNextStageForWeek(currentWeek);
    final nextStageWeek = CharacterEvolution.getNextStageUnlockWeek(currentWeek);

    // 프리미엄 체크
    final authService = AuthService();
    final subscription = authService.currentSubscription;
    final isPremium = subscription?.type == SubscriptionType.premium;
    final subscriptionStartDate = subscription?.startDate ?? userProfile.startDate;
    final canAccess = CharacterEvolution.canAccessWeek(
      currentWeek,
      isPremium,
      subscriptionStartDate,
    );
    final isFirstMonthFree = CharacterEvolution.isFirstMonthFree(subscriptionStartDate);

    // 색상 파싱
    final stageColor = Color(
      int.parse(currentStage.color.substring(1), radix: 16) + 0xFF000000,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingM,
        vertical: AppConstants.paddingS,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            stageColor.withValues(alpha: 0.2),
            stageColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: stageColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Dream Spirit 캐릭터 이미지
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: stageColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              'assets/images/character/${currentStage.imageFilename}',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // 이미지 로드 실패 시 기본 아이콘 표시
                return Icon(
                  Icons.stars,
                  color: stageColor,
                  size: 40,
                );
              },
            ),
          ),
          const SizedBox(width: AppConstants.paddingM),

          // Dream Spirit 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentStage.nameShort,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: stageColor,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'Week $currentWeek',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(' • ', style: TextStyle(fontSize: 10)),
                    Text(
                      'XP: $totalXP',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // 주차 진행률 바
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: levelInfo.weekProgress,
                          minHeight: 4,
                          backgroundColor: stageColor.withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(stageColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${levelInfo.currentWeekXP}/${XPCalculator.xpPerWeek}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                if (nextStage != null && nextStageWeek != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Next: ${nextStage.nameShort} (Week $nextStageWeek)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // 락 아이콘 또는 화살표
          if (!canAccess)
            GestureDetector(
              onTap: () => _showPremiumUpgradeDialog(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isFirstMonthFree ? l10n.trialEnded : l10n.premium,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Icon(
              Icons.keyboard_arrow_right,
              color: stageColor.withValues(alpha: 0.5),
            ),
        ],
      ),
    );
  }

  void _showPremiumUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PremiumUpgradeBottomSheet(
        currentWeek: XPCalculator.getLevelInfo(totalXP).week,
      ),
    );
  }
}

/// 프리미엄 업그레이드 다이얼로그
class PremiumUpgradeBottomSheet extends StatelessWidget {
  final int currentWeek;

  const PremiumUpgradeBottomSheet({
    super.key,
    required this.currentWeek,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF7B2CBF),
              const Color(0xFF9D4EDD),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            _buildHeader(context),

            // 혜택 섹션
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.premiumBenefitsTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBenefit(
                    Icons.block,
                    l10n.premiumBenefitAdFree,
                    l10n.premiumBenefitAdFreeDesc,
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildBenefit(
                    Icons.auto_awesome,
                    l10n.premiumBenefitLumi,
                    l10n.premiumBenefitLumiDesc,
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildBenefit(
                    Icons.psychology,
                    l10n.premiumBenefitUnlimitedAI,
                    l10n.premiumBenefitAIDesc,
                    isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildBenefit(
                    Icons.analytics,
                    l10n.premiumBenefitAdvancedStats,
                    l10n.premiumBenefitStatsDesc,
                    isDark,
                  ),
                  const SizedBox(height: 24),

                  // 가격 및 구독 버튼
                  _buildPriceSection(context, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40),
              const Icon(
                Icons.workspace_premium,
                color: Colors.amber,
                size: 48,
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).premiumDialogTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              AppLocalizations.of(context).premiumUnlockWeeks(currentWeek + 1),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefit(IconData icon, String title, String subtitle, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF7B2CBF).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF7B2CBF), size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.check_circle,
          color: Colors.green[600],
          size: 20,
        ),
      ],
    );
  }

  Widget _buildPriceSection(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        // 가격 표시
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF7B2CBF).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF7B2CBF).withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.premiumPriceMonthly,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.premiumPricePerMonth,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 구독 버튼
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _startPurchase(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B2CBF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_cart, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.premiumStartNowButton,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.premiumSubscriptionInfo,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[500] : Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _startPurchase(BuildContext context) async {
    Navigator.pop(context); // 다이얼로그 닫기

    // SubscriptionScreen으로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SubscriptionScreen(),
      ),
    );
  }
}
