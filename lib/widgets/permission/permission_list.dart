import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';
import '../../generated/l10n/app_localizations.dart';
import 'permission_section.dart';

/// 권한 목록 카드
class PermissionList extends StatelessWidget {
  const PermissionList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: Color(isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: const Color(AppColors.primaryColor).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 알림 권한 섹션
          PermissionSection(
            title: AppLocalizations.of(context).notificationPermissionTitle,
            description: AppLocalizations.of(context).notificationPermissionDesc,
            icon: Icons.notifications_active,
            benefits: [
              AppLocalizations.of(context).notificationBenefit1,
              AppLocalizations.of(context).notificationBenefit2,
              AppLocalizations.of(context).notificationBenefit3,
            ],
          ),

          const SizedBox(height: 24),

          // 저장소 권한 섹션
          PermissionSection(
            title: AppLocalizations.of(context).storagePermissionTitle,
            description: AppLocalizations.of(context).storagePermissionDesc,
            icon: Icons.folder,
            benefits: [
              AppLocalizations.of(context).storageBenefit1,
              AppLocalizations.of(context).storageBenefit2,
              AppLocalizations.of(context).storageBenefit3,
            ],
          ),
        ],
      ),
    );
  }
}
