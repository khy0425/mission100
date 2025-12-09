import 'package:flutter/material.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../utils/config/constants.dart';

/// 홈 화면 에러 위젯
///
/// 데이터 로드 실패 시 표시되는 에러 상태 위젯
class HomeErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback onRetry;

  const HomeErrorWidget({
    super.key,
    this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            AppLocalizations.of(context).errorOccurred,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            errorMessage ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingL),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(AppLocalizations.of(context).retryButton),
          ),
        ],
      ),
    );
  }
}
