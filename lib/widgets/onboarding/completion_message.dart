import 'package:flutter/material.dart';
import '../../generated/app_localizations.dart';
import '../../utils/constants.dart';

/// 목표 설정 완료 메시지
class CompletionMessage extends StatelessWidget {
  const CompletionMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context).goalSetupComplete,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.primaryColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).goalSetupCompleteMessage,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
