import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../utils/config/constants.dart';

/// 운동 스케줄 설정 헤더
class ScheduleHeader extends StatelessWidget {
  const ScheduleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(AppColors.primaryColor).withValues(alpha: 0.1),
            Colors.orange.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month, color: Colors.orange, size: 32),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context).setWorkoutSchedule,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).workoutScheduleDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
