import 'package:flutter/material.dart';
import '../../generated/app_localizations.dart';
import 'weekly_growth_chart.dart';
import 'weekly_breakdown_item.dart';

/// 주간 세부 정보 카드
class WeeklyBreakdownCard extends StatelessWidget {
  final List<WeeklyProgressData> weeklyData;

  const WeeklyBreakdownCard({
    super.key,
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutBack,
      child: Card(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1A1A1A)
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).weeklyDetails,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4DABF7),
                ),
              ),
              const SizedBox(height: 16),
              ...weeklyData.map((data) => WeeklyBreakdownItem(data: data)),
            ],
          ),
        ),
      ),
    );
  }
}
