import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';

/// 에러 상태 위젯
class ErrorView extends StatelessWidget {
  final String errorMessage;
  final String errorTitle;
  final String retryButtonText;
  final VoidCallback onRetry;
  final double height;

  const ErrorView({
    super.key,
    required this.errorMessage,
    required this.errorTitle,
    required this.retryButtonText,
    required this.onRetry,
    this.height = 400,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            errorTitle,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            errorMessage,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingL),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(retryButtonText),
          ),
        ],
      ),
    );
  }
}
