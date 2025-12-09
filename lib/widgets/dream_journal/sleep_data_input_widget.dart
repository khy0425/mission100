import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/config/constants.dart';
import '../../generated/l10n/app_localizations.dart';

/// 수면 데이터 입력 위젯
///
/// 수면 시작 시간, 기상 시간, 수면 품질을 입력받는 위젯
class SleepDataInputWidget extends StatelessWidget {
  final DateTime dreamDate;
  final DateTime? sleepTime;
  final DateTime? wakeTime;
  final int? sleepQuality;
  final Function(DateTime) onSleepTimeChanged;
  final Function(DateTime) onWakeTimeChanged;
  final Function(int) onSleepQualityChanged;

  const SleepDataInputWidget({
    super.key,
    required this.dreamDate,
    required this.sleepTime,
    required this.wakeTime,
    required this.sleepQuality,
    required this.onSleepTimeChanged,
    required this.onWakeTimeChanged,
    required this.onSleepQualityChanged,
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
            Text(
              l10n.sleepInfoOptional,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppConstants.fontSizeM,
              ),
            ),
            const SizedBox(height: AppConstants.paddingM),
            ListTile(
              leading: const Icon(Icons.bedtime),
              title: Text(l10n.sleepStart),
              subtitle: Text(sleepTime != null
                  ? '${sleepTime!.hour}:${sleepTime!.minute.toString().padLeft(2, '0')}'
                  : l10n.notEntered),
              trailing: const Icon(Icons.edit),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  onSleepTimeChanged(DateTime(
                    dreamDate.year,
                    dreamDate.month,
                    dreamDate.day,
                    time.hour,
                    time.minute,
                  ));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.wb_sunny),
              title: Text(l10n.wakeTime),
              subtitle: Text(wakeTime != null
                  ? '${wakeTime!.hour}:${wakeTime!.minute.toString().padLeft(2, '0')}'
                  : l10n.notEntered),
              trailing: const Icon(Icons.edit),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  onWakeTimeChanged(DateTime(
                    dreamDate.year,
                    dreamDate.month,
                    dreamDate.day + 1,
                    time.hour,
                    time.minute,
                  ));
                }
              },
            ),
            const SizedBox(height: AppConstants.paddingS),
            Text(l10n.sleepQualityLabel),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                final score = index + 1;
                return IconButton(
                  icon: Icon(
                    sleepQuality != null && sleepQuality! >= score
                        ? Icons.hotel
                        : Icons.hotel_outlined,
                    size: 28,
                  ),
                  color: Colors.indigo,
                  onPressed: () {
                    onSleepQualityChanged(score);
                    HapticFeedback.selectionClick();
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
