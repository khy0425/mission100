import 'package:flutter/material.dart';
import '../generated/app_localizations.dart';
import '../utils/constants.dart';
import '../services/workout/workout_resumption_service.dart';

/// 운동 재개 확인 다이얼로그
class WorkoutResumptionDialog extends StatelessWidget {
  final WorkoutResumptionData resumptionData;
  final VoidCallback onResumeWorkout;
  final VoidCallback onStartNewWorkout;

  const WorkoutResumptionDialog({
    super.key,
    required this.resumptionData,
    required this.onResumeWorkout,
    required this.onStartNewWorkout,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final primaryData = resumptionData.primaryData;

    if (primaryData == null) {
      return const SizedBox.shrink();
    }

    // 복원 가능한 데이터 분석
    final workoutTitle = primaryData['workoutTitle'] as String? ?? l10n.workout;
    final currentSet =
        (primaryData['currentSet'] as int? ?? 0) + 1; // 1-based index
    final completedRepsStr = primaryData['completedReps'] as String? ?? '';
    final completedReps = completedRepsStr.isNotEmpty
        ? completedRepsStr.split(',').map(int.parse).toList()
        : <int>[];

    final completedSetsCount = completedReps.where((reps) => reps > 0).length;
    final totalCompletedReps = completedReps.fold(0, (sum, reps) => sum + reps);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: const Icon(
              Icons.restore,
              color: Color(AppColors.primaryColor),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.resumeWorkout,
              style: theme.textTheme.titleLarge?.copyWith(
                color: const Color(AppColors.primaryColor),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (workoutTitle.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.foundWorkout,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('${l10n.workout}: $workoutTitle'),
                  if (currentSet > 0) Text(l10n.progressSetReady(currentSet)),
                  Text(l10n.completedSetsCount(completedSetsCount)),
                  if (totalCompletedReps > 0)
                    Text(l10n.totalCompletedReps(totalCompletedReps)),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning_amber, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.workoutInterruptionDetected,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.continueOrStartNew.replaceAll('\\n', '\n'),
                  style: const TextStyle(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // 새 운동 시작 버튼
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            onStartNewWorkout();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[600],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(l10n.startNewWorkout),
        ),

        // 운동 재개 버튼
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onResumeWorkout();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(AppColors.primaryColor),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.play_arrow, size: 18),
              const SizedBox(width: 4),
              Text(
                l10n.resumeWorkout.replaceAll('💪 ', ''),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
    );
  }
}

/// 운동 재개 다이얼로그를 표시하는 헬퍼 함수
Future<bool?> showWorkoutResumptionDialog({
  required BuildContext context,
  required WorkoutResumptionData resumptionData,
}) async {
  bool? shouldResume;

  await showDialog<void>(
    context: context,
    barrierDismissible: false, // 백그라운드 터치로 닫기 방지
    builder: (BuildContext context) {
      return WorkoutResumptionDialog(
        resumptionData: resumptionData,
        onResumeWorkout: () {
          shouldResume = true;
        },
        onStartNewWorkout: () {
          shouldResume = false;
        },
      );
    },
  );

  return shouldResume;
}

/// 간단한 운동 재개 확인 다이얼로그
Future<bool?> showSimpleResumptionDialog({
  required BuildContext context,
  required String workoutTitle,
  required int completedSets,
  required int totalReps,
}) async {
  final l10n = AppLocalizations.of(context);
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(
        l10n.resumeWorkout,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  l10n.incompleteWorkoutFound,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n
                      .workoutDetailsWithStats(
                        totalReps,
                        completedSets,
                        workoutTitle,
                      )
                      .replaceAll('\\n', '\n'),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.resumeButton),
        ),
      ],
    ),
  );
}
