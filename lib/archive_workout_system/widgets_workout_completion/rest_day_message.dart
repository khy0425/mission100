import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';

/// 휴식일/운동일 메시지 위젯
class RestDayMessage extends StatelessWidget {
  final bool isTomorrowRestDay;

  const RestDayMessage({
    super.key,
    required this.isTomorrowRestDay,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (isTomorrowRestDay) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.purple.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.purple, width: 2),
        ),
        child: Column(
          children: [
            Text(
              l10n.tomorrowIsRestDay,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.recoverToBeStronger,
              style: TextStyle(
                fontSize: 12,
                color: Colors.purple[600],
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange, width: 2),
        ),
        child: Column(
          children: [
            Text(
              l10n.tomorrowBeastMode,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.legendaryJourneyContinues,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.orange,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }
}
