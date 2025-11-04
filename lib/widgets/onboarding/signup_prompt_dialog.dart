import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../utils/config/constants.dart';

/// 회원가입 안내 다이얼로그
class SignupPromptDialog extends StatelessWidget {
  final String goalText;
  final VoidCallback onSkip;
  final VoidCallback onSignup;

  const SignupPromptDialog({
    super.key,
    required this.goalText,
    required this.onSkip,
    required this.onSignup,
  });

  static void show(
    BuildContext context, {
    required String goalText,
    required VoidCallback onSkip,
    required VoidCallback onSignup,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SignupPromptDialog(
        goalText: goalText,
        onSkip: onSkip,
        onSignup: onSignup,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.stars, color: Color(AppColors.primaryColor)),
          const SizedBox(width: 8),
          Text(localizations.signupPromptTitle),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.signupPromptMessage(goalText),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(localizations.signupPromptLaunchEvent),
          Text(localizations.signupPromptBenefit1),
          Text(localizations.signupPromptBenefit2),
          Text(localizations.signupPromptBenefit3),
          Text(localizations.signupPromptBenefit4),
          const SizedBox(height: 16),
          Text(
            localizations.signupPromptCallToAction,
            style: const TextStyle(
              color: Color(AppColors.primaryColor),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onSkip,
          child: Text(localizations.later),
        ),
        ElevatedButton(
          onPressed: onSignup,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(AppColors.primaryColor),
            foregroundColor: Colors.white,
          ),
          child: Text(localizations.startForFree),
        ),
      ],
    );
  }
}
