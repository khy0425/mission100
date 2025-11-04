import 'package:flutter/material.dart';
import '../../utils/config/constants.dart';
import '../../generated/l10n/app_localizations.dart';

/// 운동 요일 선택 섹션
class DaySelectionSection extends StatelessWidget {
  final List<bool> selectedDays;
  final Function(int) onDayToggle;

  const DaySelectionSection({
    super.key,
    required this.selectedDays,
    required this.onDayToggle,
  });

  int get selectedDaysCount => selectedDays.where((selected) => selected).length;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dayNames = [
      l10n.dayMon,
      l10n.dayTue,
      l10n.dayWed,
      l10n.dayThu,
      l10n.dayFri,
      l10n.daySat,
      l10n.daySun,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.fitness_center,
              color: Color(AppColors.primaryColor),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).selectWorkoutDaysMin3,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(AppColors.primaryColor),
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context).selectedDaysCount(selectedDaysCount),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: selectedDaysCount >= 3 ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(7, (index) {
            final isSelected = selectedDays[index];
            return GestureDetector(
              onTap: () => onDayToggle(index),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(AppColors.primaryColor)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? const Color(AppColors.primaryColor)
                        : Colors.grey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    dayNames[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
