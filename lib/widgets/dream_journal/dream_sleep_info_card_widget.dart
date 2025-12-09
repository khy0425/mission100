import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';
import '../../generated/l10n/app_localizations.dart';

/// 수면 정보 카드 위젯
///
/// 수면 시작, 기상 시간, 수면 시간, 수면 품질 표시
class DreamSleepInfoCardWidget extends StatelessWidget {
  final DateTime? sleepTime;
  final DateTime? wakeTime;
  final Duration? sleepDuration;
  final int? sleepQuality;

  const DreamSleepInfoCardWidget({
    super.key,
    this.sleepTime,
    this.wakeTime,
    this.sleepDuration,
    this.sleepQuality,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bedtime, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.sleepInfoTitle,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            if (sleepTime != null)
              ListTile(
                leading: const Icon(Icons.bedtime),
                title: Text(l10n.sleepStart),
                subtitle: Text(
                  '${sleepTime!.hour}:${sleepTime!.minute.toString().padLeft(2, '0')}',
                ),
                contentPadding: EdgeInsets.zero,
              ),
            if (wakeTime != null)
              ListTile(
                leading: const Icon(Icons.wb_sunny),
                title: Text(l10n.wakeTime),
                subtitle: Text(
                  '${wakeTime!.hour}:${wakeTime!.minute.toString().padLeft(2, '0')}',
                ),
                contentPadding: EdgeInsets.zero,
              ),
            if (sleepDuration != null)
              ListTile(
                leading: const Icon(Icons.timelapse),
                title: Text(l10n.sleepDurationLabel),
                subtitle: Text(
                  l10n.sleepDurationValue(
                    sleepDuration!.inHours.toString(),
                    (sleepDuration!.inMinutes % 60).toString(),
                  ),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            if (sleepQuality != null) ...[
              Text('${l10n.sleepQuality} '),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < sleepQuality!
                        ? Icons.hotel
                        : Icons.hotel_outlined,
                    color: Colors.indigo,
                  );
                }),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
