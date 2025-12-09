import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import 'elegant_settings_tile.dart';

/// 앱 정보 섹션 위젯
///
/// 버전, 개발자, 라이센스, 평가 정보
class AppInfoSection extends StatelessWidget {
  final Function(String) showSnackBar;

  const AppInfoSection({
    super.key,
    required this.showSnackBar,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ElegantSettingsTile(
            icon: Icons.info_outline,
            iconColor: Colors.blue,
            title: l10n.version,
            subtitle: '1.0.0',
            trailing: const SizedBox.shrink(),
          ),
          ElegantSettingsTile(
            icon: Icons.code,
            iconColor: Colors.teal,
            title: l10n.developer,
            subtitle: l10n.mission100Team,
            trailing: const SizedBox.shrink(),
          ),
          ElegantSettingsTile(
            icon: Icons.description,
            iconColor: Colors.orange,
            title: l10n.license,
            subtitle: l10n.openSourceLicense,
            onTap: () {
              showSnackBar(l10n.licenseInfoComingSoon);
            },
          ),
          ElegantSettingsTile(
            icon: Icons.star,
            iconColor: Colors.amber,
            title: l10n.appRating,
            subtitle: l10n.rateOnPlayStore,
            showDivider: false,
            onTap: () {
              showSnackBar(l10n.appRatingComingSoon);
            },
          ),
        ],
      ),
    );
  }
}
