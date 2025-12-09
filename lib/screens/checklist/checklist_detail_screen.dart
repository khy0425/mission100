import 'package:flutter/material.dart';
import '../../utils/checklist_data.dart';
import 'breathing_exercise_screen.dart';
import 'grounding_exercise_screen.dart';
import 'worry_time_screen.dart';
import 'body_scan_screen.dart';
import 'gratitude_screen.dart';

/// 체크리스트 항목 상세 화면
///
/// 각 체크리스트 항목에 대한 설명과 인터랙티브 가이드를 제공합니다.
class ChecklistDetailScreen extends StatelessWidget {
  final ChecklistItem item;
  final VoidCallback? onCompleted;

  const ChecklistDetailScreen({
    super.key,
    required this.item,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    // 항목 타입에 따라 적절한 화면으로 라우팅
    switch (item.id) {
      case 'breath_exercise':
        return BreathingExerciseScreen(item: item, onCompleted: onCompleted);
      case 'morning_grounding':
        return GroundingExerciseScreen(item: item, onCompleted: onCompleted);
      case 'worry_time':
        return WorryTimeScreen(item: item, onCompleted: onCompleted);
      case 'body_scan':
        return BodyScanScreen(item: item, onCompleted: onCompleted);
      case 'gratitude_3':
        return GratitudeScreen(item: item, onCompleted: onCompleted);
      default:
        return _buildGenericDetailScreen(context);
    }
  }

  Widget _buildGenericDetailScreen(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.nameKo),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 아이콘과 제목
            Center(
              child: Column(
                children: [
                  Text(item.icon, style: const TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text(
                    item.nameKo,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 완료 버튼
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  onCompleted?.call();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('완료', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
