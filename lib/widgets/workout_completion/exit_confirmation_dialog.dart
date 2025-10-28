import 'package:flutter/material.dart';
import '../../generated/app_localizations.dart';

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
      title: Text(
        Localizations.localeOf(context).languageCode == 'ko'
            ? '운동 종료'
            : 'Exit Workout',
      ),
      content: Text(
        Localizations.localeOf(context).languageCode == 'ko'
            ? '운동을 종료하시겠습니까? 진행 상황이 저장되지 않습니다.'
            : 'Are you sure you want to exit? Your progress will not be saved.',
      ),
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
