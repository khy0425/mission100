import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/xp_calculator.dart';

/// 개발자 테스트용 위젯 - 주차/XP 조정
class DevTestSettingsWidget extends StatefulWidget {
  const DevTestSettingsWidget({super.key});

  @override
  State<DevTestSettingsWidget> createState() => _DevTestSettingsWidgetState();
}

class _DevTestSettingsWidgetState extends State<DevTestSettingsWidget> {
  int _currentXP = 0;
  int _currentWeek = 0;

  @override
  void initState() {
    super.initState();
    _loadCurrentXP();
  }

  Future<void> _loadCurrentXP() async {
    final prefs = await SharedPreferences.getInstance();
    final xp = prefs.getInt('totalXP') ?? 0;
    setState(() {
      _currentXP = xp;
      _currentWeek = XPCalculator.getWeekFromXP(xp);
    });
  }

  Future<void> _setWeek(int week) async {
    final prefs = await SharedPreferences.getInstance();
    final xp = XPCalculator.getXPForWeek(week);
    await prefs.setInt('totalXP', xp);

    setState(() {
      _currentXP = xp;
      _currentWeek = week;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Week $week 로 설정 (XP: $xp)'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // 앱 재시작을 권장하는 다이얼로그
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('설정 완료'),
          content: Text('Week $week 로 설정되었습니다.\n\n앱을 재시작하면 변경사항이 반영됩니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 현재 상태
            Row(
              children: [
                Icon(Icons.science, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text(
                  '현재 상태',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Week $_currentWeek',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  Text(
                    'XP: $_currentXP',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.blue.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // 테스트 버튼들
            Text(
              '주차 테스트 (무료 가이드)',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _setWeek(1),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Week 1'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _setWeek(2),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Week 2'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              '주차 테스트 (프리미엄 잠금)',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _setWeek(3),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Week 3'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _setWeek(5),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Week 5'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _setWeek(10),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Week 10'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _setWeek(14),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Week 14'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // 안내 메시지
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '주차 변경 후 앱을 재시작해야 홈 화면의 가이드 카드가 업데이트됩니다.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
