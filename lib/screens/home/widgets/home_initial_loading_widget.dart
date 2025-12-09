import 'package:flutter/material.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../utils/config/constants.dart';

/// 홈 화면 초기 로딩 위젯
///
/// 앱 시작 시 데이터를 로드하는 동안 표시되는 전체 화면 로딩 화면
class HomeInitialLoadingWidget extends StatelessWidget {
  final double subtitleFontSize;

  const HomeInitialLoadingWidget({
    super.key,
    this.subtitleFontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Color(
        isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    Color(AppColors.lucidGradient[0]),
                    Color(AppColors.lucidGradient[1]),
                  ]
                : [Colors.white, const Color(0xFFF5F5F5)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(
                  AppColors.primaryColor,
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.nightlight_round,
                size: 50,
                color: Color(AppColors.primaryColor),
              ),
            ),
            const SizedBox(height: AppConstants.paddingL),
            Text(
              AppLocalizations.of(context).loadingText,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: subtitleFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
