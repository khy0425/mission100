import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/config/constants.dart';
import '../../generated/l10n/app_localizations.dart';

/// 기분 점수 입력 위젯
///
/// 별점 방식으로 기분 점수를 1-5 범위로 입력받는 위젯
class MoodScoreWidget extends StatelessWidget {
  final int? moodScore;
  final Function(int) onChanged;

  const MoodScoreWidget({
    super.key,
    required this.moodScore,
    required this.onChanged,
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
              l10n.moodScoreLabel,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppConstants.fontSizeM,
              ),
            ),
            const SizedBox(height: AppConstants.paddingS),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                final score = index + 1;
                return IconButton(
                  icon: Icon(
                    moodScore != null && moodScore! >= score
                        ? Icons.star
                        : Icons.star_border,
                    size: 32,
                  ),
                  color: Colors.amber,
                  onPressed: () {
                    onChanged(score);
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
