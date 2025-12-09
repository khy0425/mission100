import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';
import '../../generated/l10n/app_localizations.dart';

/// 감정 및 기분 카드 위젯
///
/// 감정 태그와 기분 점수 표시
class DreamEmotionsCardWidget extends StatelessWidget {
  final List<String> emotions;
  final int? moodScore;

  const DreamEmotionsCardWidget({
    super.key,
    required this.emotions,
    this.moodScore,
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
                const Icon(Icons.mood, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.emotionsAndMoodTitle,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            if (emotions.isNotEmpty) ...[
              Wrap(
                spacing: AppConstants.paddingS,
                runSpacing: AppConstants.paddingS,
                children: emotions
                    .map((emotion) => Chip(
                          label: Text(emotion),
                          avatar: const Icon(Icons.mood, size: 16),
                          backgroundColor: Colors.pink.shade100,
                        ))
                    .toList(),
              ),
              const SizedBox(height: AppConstants.paddingS),
            ],
            if (moodScore != null) ...[
              Text('${l10n.moodScore} '),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < moodScore!
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
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
