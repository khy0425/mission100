import 'package:flutter/material.dart';

/// 달력의 날짜 셀
class CalendarDay extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final bool isToday;
  final bool hasEvents;
  final Color dayColor;

  const CalendarDay({
    super.key,
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.hasEvents,
    required this.dayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.blue.shade600
            : isToday
                ? Colors.blue.withValues(alpha: 0.2)
                : dayColor,
        shape: BoxShape.circle,
        border: isToday && !isSelected
            ? Border.all(color: Colors.blue.shade600, width: 2)
            : null,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                color: isSelected || dayColor != Colors.transparent
                    ? Colors.white
                    : isToday
                        ? Colors.blue.shade600
                        : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (hasEvents)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isSelected || dayColor != Colors.transparent
                      ? Colors.white
                      : const Color(0xFF00BCD4),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
