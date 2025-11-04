import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';

/// 운동 종료 확인 다이얼로그
class ExitConfirmationDialog extends StatelessWidget {
  const ExitConfirmationDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => const ExitConfirmationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).exitWorkout),
      content: Text(AppLocalizations.of(context).exitWorkoutConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(AppLocalizations.of(context).cancelButton),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(AppLocalizations.of(context).exitButton),
        ),
      ],
    );
  }
}
