import 'package:flutter/material.dart';

/// 휴식일/운동일 메시지 위젯
class RestDayMessage extends StatelessWidget {
  final bool isTomorrowRestDay;

  const RestDayMessage({
    super.key,
    required this.isTomorrowRestDay,
  });

  @override
  Widget build(BuildContext context) {
    if (isTomorrowRestDay) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.purple.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.purple, width: 2),
        ),
        child: Column(
          children: [
            Text(
              '😴 내일은 CHAD 휴식일! 😴',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '🌴 완전한 회복으로 더 강한 CHAD가 되자! 💪',
              style: TextStyle(
                fontSize: 12,
                color: Colors.purple[600],
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange, width: 2),
        ),
        child: const Column(
          children: [
            Text(
              '🔥 TOMORROW: BEAST MODE AGAIN! 🔥',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '💀 LEGENDARY 경지로의 여정은 계속된다! 💀',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }
}
