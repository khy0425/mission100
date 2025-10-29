import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';

/// 온보딩 진행 표시기
class ProgressIndicatorBar extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const ProgressIndicatorBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(totalSteps, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index <= currentStep
                    ? const Color(AppColors.primaryColor)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
