import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';
import '../../generated/app_localizations.dart';

/// 업적 탭 바
class AchievementsTabBar extends StatelessWidget {
  final TabController controller;
  final int unlockedCount;
  final int lockedCount;

  const AchievementsTabBar({
    super.key,
    required this.controller,
    required this.unlockedCount,
    required this.lockedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
      decoration: BoxDecoration(
        color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: TabBar(
        controller: controller,
        labelColor: const Color(AppColors.primaryColor),
        unselectedLabelColor: Colors.grey,
        indicator: BoxDecoration(
          color: const Color(AppColors.primaryColor),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        tabs: [
          Tab(
            text: AppLocalizations.of(context).unlockedAchievements(unlockedCount),
          ),
          Tab(
            text: AppLocalizations.of(context).lockedAchievements(lockedCount),
          ),
        ],
      ),
    );
  }
}
