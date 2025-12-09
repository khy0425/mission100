import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/config/constants.dart';
import '../../models/dream_sign.dart';

/// 자각도 슬라이더 위젯
///
/// 꿈의 자각도(Lucidity Level)를 0-10 범위로 입력받는 위젯
class LucidityScoreWidget extends StatelessWidget {
  final int lucidityLevel;
  final Function(int) onChanged;

  const LucidityScoreWidget({
    super.key,
    required this.lucidityLevel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '자각도 (Lucidity Level)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppConstants.fontSizeM,
                  ),
                ),
                Chip(
                  label: Text(
                    '$lucidityLevel',
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeL,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: _getLucidityColor(),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingS),
            Text(
              _getLucidityLevelText(),
              style: const TextStyle(
                fontSize: AppConstants.fontSizeS,
                color: Colors.grey,
              ),
            ),
            Slider(
              value: lucidityLevel.toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              label: '$lucidityLevel',
              onChanged: (value) {
                onChanged(value.toInt());
                HapticFeedback.selectionClick();
              },
            ),
            const Text(
              '0: 일반 꿈 | 5: 꿈임을 인식 | 10: 완전한 통제',
              style: TextStyle(
                fontSize: AppConstants.fontSizeXS,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getLucidityColor() {
    if (lucidityLevel == 0) return Colors.grey.shade300;
    if (lucidityLevel <= 3) return Colors.blue.shade200;
    if (lucidityLevel <= 6) return Colors.blue.shade400;
    if (lucidityLevel <= 9) return Colors.blue.shade600;
    return Colors.blue.shade800;
  }

  String _getLucidityLevelText() {
    final level = LucidityLevelExtension.fromScore(lucidityLevel);
    return level.description;
  }
}
