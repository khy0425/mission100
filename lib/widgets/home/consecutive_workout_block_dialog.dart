import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';

/// 연속 운동 차단 다이얼로그
class ConsecutiveWorkoutBlockDialog extends StatelessWidget {
  const ConsecutiveWorkoutBlockDialog({super.key});

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ConsecutiveWorkoutBlockDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.warning, color: Colors.orange, size: 28),
          const SizedBox(width: 8),
          Text(
            AppLocalizations.of(context).consecutiveWorkoutBlocked,
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)
                .consecutiveWorkoutMessage
                .replaceAll('\\n', '\n'),
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.of(context).chadRestModeToday,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
