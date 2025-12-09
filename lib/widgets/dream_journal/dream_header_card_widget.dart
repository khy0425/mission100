import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';
import '../../models/dream_entry.dart';
import '../../generated/l10n/app_localizations.dart';

/// 꿈 일기 헤더 카드 위젯
///
/// 날짜, 자각도 레벨, 자각몽 여부 표시
class DreamHeaderCardWidget extends StatelessWidget {
  final DreamEntry dream;

  const DreamHeaderCardWidget({
    super.key,
    required this.dream,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      color: dream.wasLucid ? Colors.amber.shade50 : null,
      elevation: AppConstants.elevationM,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Row(
          children: [
            // 자각도 아이콘
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _getLucidityColor(),
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    dream.wasLucid ? Icons.star : Icons.bedtime,
                    size: 32,
                    color: Colors.white,
                  ),
                  Text(
                    '${dream.lucidityLevel}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppConstants.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dream.dateLabel,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeL,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dream.lucidityLevelText,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeM,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (dream.wasLucid)
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          l10n.lucidDreamBadge,
                          style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getLucidityColor() {
    if (dream.lucidityLevel == 0) return Colors.grey.shade400;
    if (dream.lucidityLevel <= 3) return Colors.blue.shade300;
    if (dream.lucidityLevel <= 6) return Colors.blue.shade500;
    if (dream.lucidityLevel <= 9) return Colors.blue.shade700;
    return Colors.blue.shade900;
  }
}
