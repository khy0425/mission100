import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../utils/config/constants.dart';
import '../../models/lucid_dream_task.dart';

/// 체크리스트 완료 다이얼로그
///
/// 체크리스트 완료 시 표시되는 축하 다이얼로그
class ChecklistCompletionDialog extends StatelessWidget {
  final int dayNumber;
  final int completedTaskCount;
  final int totalTaskCount;
  final int requiredTaskCount;
  final bool isWbtbDay;
  final Duration timeElapsed;
  final VoidCallback onConfirm;

  const ChecklistCompletionDialog({
    super.key,
    required this.dayNumber,
    required this.completedTaskCount,
    required this.totalTaskCount,
    required this.requiredTaskCount,
    required this.isWbtbDay,
    required this.timeElapsed,
    required this.onConfirm,
  });

  /// 정적 메서드: 다이얼로그 표시
  static Future<void> show({
    required BuildContext context,
    required int dayNumber,
    required int completedTaskCount,
    required int totalTaskCount,
    required int requiredTaskCount,
    required bool isWbtbDay,
    required Duration timeElapsed,
    required VoidCallback onConfirm,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ChecklistCompletionDialog(
        dayNumber: dayNumber,
        completedTaskCount: completedTaskCount,
        totalTaskCount: totalTaskCount,
        requiredTaskCount: requiredTaskCount,
        isWbtbDay: isWbtbDay,
        timeElapsed: timeElapsed,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(AppColors.successColor)),
          const SizedBox(width: 8),
          Text(l10n.checklistDayComplete(dayNumber)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.checklistCompleteMessage,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            l10n.checklistCompletedTasks,
            l10n.checklistCompletedTasksValue(completedTaskCount, totalTaskCount),
          ),
          _buildStatRow(
            l10n.checklistRequiredTasks,
            l10n.checklistRequiredTasksValue(requiredTaskCount, requiredTaskCount),
          ),
          if (isWbtbDay)
            _buildStatRow('WBTB', l10n.checklistWbtbDayBadge),
          _buildStatRow(
            l10n.checklistTimeSpent,
            l10n.checklistTimeSpentValue(timeElapsed.inMinutes),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onConfirm,
          child: Text(l10n.checklistConfirm),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
