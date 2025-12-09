import 'package:flutter/material.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../utils/config/constants.dart';
import '../../settings/simple_settings_screen.dart';

/// 홈 화면 빈 상태 위젯
///
/// 사용자 프로필이 없을 때 표시되는 위젯
class HomeEmptyStateWidget extends StatelessWidget {
  const HomeEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add, size: 64, color: Colors.blue[400]),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            AppLocalizations.of(context).pleaseCreateProfile,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            AppLocalizations.of(context).userProfileRequired,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingL),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (context) => const SimpleSettingsScreen()),
            ),
            child: Text(AppLocalizations.of(context).goToSettings),
          ),
        ],
      ),
    );
  }
}
