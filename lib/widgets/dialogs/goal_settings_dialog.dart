import 'package:flutter/material.dart';
import '../../models/user_goals.dart';
import '../../generated/app_localizations.dart';

/// 목표 설정 다이얼로그
class GoalSettingsDialog extends StatefulWidget {
  final UserGoals currentGoals;

  const GoalSettingsDialog({
    super.key,
    required this.currentGoals,
  });

  @override
  State<GoalSettingsDialog> createState() => _GoalSettingsDialogState();
}

class _GoalSettingsDialogState extends State<GoalSettingsDialog> {
  late int _weeklyGoal;
  late int _monthlyGoal;
  late int _streakTarget;

  @override
  void initState() {
    super.initState();
    _weeklyGoal = widget.currentGoals.weeklyGoal;
    _monthlyGoal = widget.currentGoals.monthlyGoal;
    _streakTarget = widget.currentGoals.streakTarget;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                Icon(Icons.tune, color: Theme.of(context).primaryColor, size: 28),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context).goalSettings,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 주간 목표
            _buildGoalSlider(
              title: AppLocalizations.of(context).weeklyGoal,
              value: _weeklyGoal,
              min: 1,
              max: 7,
              divisions: 6,
              unit: AppLocalizations.of(context).times,
              icon: Icons.calendar_view_week,
              color: const Color(0xFF00BCD4),
              onChanged: (value) {
                setState(() {
                  _weeklyGoal = value.round();
                });
              },
            ),

            const SizedBox(height: 20),

            // 월간 목표
            _buildGoalSlider(
              title: AppLocalizations.of(context).monthlyGoal,
              value: _monthlyGoal,
              min: 4,
              max: 31,
              divisions: 27,
              unit: AppLocalizations.of(context).times,
              icon: Icons.calendar_month,
              color: Colors.green,
              onChanged: (value) {
                setState(() {
                  _monthlyGoal = value.round();
                });
              },
            ),

            const SizedBox(height: 20),

            // 연속 목표
            _buildGoalSlider(
              title: AppLocalizations.of(context).consecutiveGoal,
              value: _streakTarget,
              min: 3,
              max: 30,
              divisions: 27,
              unit: AppLocalizations.of(context).days,
              icon: Icons.local_fire_department,
              color: Colors.orange,
              onChanged: (value) {
                setState(() {
                  _streakTarget = value.round();
                });
              },
            ),

            const SizedBox(height: 32),

            // 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 초기화 버튼
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _weeklyGoal = UserGoals.defaultGoals.weeklyGoal;
                      _monthlyGoal = UserGoals.defaultGoals.monthlyGoal;
                      _streakTarget = UserGoals.defaultGoals.streakTarget;
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(AppLocalizations.of(context).reset),
                ),
                const SizedBox(width: 12),

                // 취소 버튼
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context).cancel),
                ),
                const SizedBox(width: 8),

                // 저장 버튼
                ElevatedButton(
                  onPressed: () {
                    final newGoals = UserGoals(
                      weeklyGoal: _weeklyGoal,
                      monthlyGoal: _monthlyGoal,
                      streakTarget: _streakTarget,
                    );
                    Navigator.of(context).pop(newGoals);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(AppLocalizations.of(context).save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalSlider({
    required String title,
    required int value,
    required int min,
    required int max,
    required int divisions,
    required String unit,
    required IconData icon,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Text(
                '$value$unit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.2),
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.2),
            valueIndicatorColor: color,
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Slider(
            value: value.toDouble(),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: divisions,
            label: '$value$unit',
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
