import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import 'weekly_growth_chart.dart';

/// 주간 성장 차트 카드
class WeeklyGrowthChartCard extends StatelessWidget {
  final List<WeeklyProgressData> weeklyData;

  const WeeklyGrowthChartCard({
    super.key,
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
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
                AppLocalizations.of(context).weeklyGrowthChart,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4DABF7),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: WeeklyGrowthChart(weeklyData: weeklyData),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
