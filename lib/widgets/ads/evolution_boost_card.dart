import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/rewarded_ad_reward.dart';
import '../../services/payment/rewarded_ad_reward_service.dart';
import '../../services/chad/chad_evolution_service.dart';
import '../../utils/config/constants.dart';

/// 진화 가속권 카드 위젯
class EvolutionBoostCard extends StatelessWidget {
  final int completedDays;

  const EvolutionBoostCard({
    super.key,
    required this.completedDays,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final rewardService = context.watch<RewardedAdRewardService>();
    final evolutionService = context.watch<ChadEvolutionService>();

    final canUse = rewardService.canUseReward(RewardedAdType.evolutionBoost);
    final remaining = rewardService.getRemainingUsage(RewardedAdType.evolutionBoost);
    final nextAvailable = rewardService.getNextAvailableTime(RewardedAdType.evolutionBoost);

    // 진화까지 남은 일수 (가속 적용)
    final daysLeft = evolutionService.getDaysUntilNextEvolution(completedDays);
    final boostDays = evolutionService.evolutionBoostDays;

    // 이미 최종 진화 완료
    if (evolutionService.isMaxEvolution) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(AppColors.successGradient[0]),
              Color(AppColors.successGradient[1]),
            ],
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 아이콘 + 제목
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('⚡', style: TextStyle(fontSize: 32)),
                ),
                const SizedBox(width: AppConstants.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.evolutionBoostTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.evolutionBoostDescription,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.paddingL),

            // 진화 정보
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.evolutionBoostNextEvolution,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        l10n.evolutionBoostDaysLeft(daysLeft),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (boostDays > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.flash_on, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          l10n.evolutionBoostApplied(boostDays),
                          style: TextStyle(
                            color: Colors.amber[100],
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: AppConstants.paddingM),

            // 사용 정보
            Row(
              children: [
                const Icon(Icons.confirmation_number, size: 16, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  l10n.evolutionBoostRemaining(remaining),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            // 쿨다운 정보
            if (!canUse && nextAvailable != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    _getCooldownText(context, nextAvailable),
                    style: TextStyle(
                      color: Colors.orange[100],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: AppConstants.paddingL),

            // 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: canUse ? () => _useEvolutionBoost(context) : null,
                icon: const Icon(Icons.play_circle_outline, color: Colors.white),
                label: Text(
                  l10n.evolutionBoostWatchAd,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.paddingM,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                  disabledBackgroundColor: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 진화 가속권 사용
  Future<void> _useEvolutionBoost(BuildContext context) async {
    final rewardService = context.read<RewardedAdRewardService>();
    final evolutionService = context.read<ChadEvolutionService>();
    final l10n = AppLocalizations.of(context);

    await rewardService.watchAdAndReward(
      RewardedAdType.evolutionBoost,
      onRewardGranted: () async {
        // 광고 시청 성공 - 진화 가속 적용
        final success = await evolutionService.applyEvolutionBoost();

        if (success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.evolutionBoostSuccess),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.evolutionBoostMaxLevel),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      onError: (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }

  String _getCooldownText(BuildContext context, DateTime nextAvailable) {
    final l10n = AppLocalizations.of(context);
    final remaining = nextAvailable.difference(DateTime.now());

    if (remaining.inDays > 0) {
      return l10n.evolutionBoostCooldownDays(remaining.inDays);
    } else if (remaining.inHours > 0) {
      return l10n.evolutionBoostCooldownHours(remaining.inHours);
    } else {
      return l10n.evolutionBoostComingSoon;
    }
  }
}
