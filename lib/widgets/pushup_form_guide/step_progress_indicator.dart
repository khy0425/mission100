import 'package:flutter/material.dart';
import '../../utils/helpers/accessibility_utils.dart';

/// 단계 진행률 표시기 위젯
class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String swipeHint;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.swipeHint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Semantics(
        label: AccessibilityUtils.formatProgress(
          currentStep + 1,
          totalSteps,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '단계 ${currentStep + 1} / $totalSteps',
                  style: const TextStyle(
                    color: Color(0xFF4DABF7),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  swipeHint,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Semantics(
              excludeSemantics: true,
              child: LinearProgressIndicator(
                value: (currentStep + 1) / totalSteps,
                backgroundColor: Colors.grey.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF4DABF7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
