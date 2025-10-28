import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../generated/app_localizations.dart';
import '../../models/workout_session.dart';

/// 워크아웃 캘린더 카드
class CalendarCard extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final List<WorkoutSession> Function(DateTime) eventLoader;
  final void Function(DateTime, DateTime) onDaySelected;

  const CalendarCard({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.eventLoader,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      child: Card(
        color: isDark ? const Color(0xFF1A1A1A) : theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).workoutCalendar,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4DABF7),
                ),
              ),
              const SizedBox(height: 16),
              TableCalendar<WorkoutSession>(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: focusedDay,
                selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                eventLoader: eventLoader,
                onDaySelected: onDaySelected,
                locale: Localizations.localeOf(context).toString(),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  weekendTextStyle: TextStyle(
                    color: isDark ? Colors.red[300] : Colors.red,
                  ),
                  holidayTextStyle: TextStyle(
                    color: isDark ? Colors.red[300] : Colors.red,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Color(0xFF4DABF7),
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: const Color(0xFF4DABF7).withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: Color(0xFF51CF66),
                    shape: BoxShape.circle,
                  ),
                  markersMaxCount: 1,
                  canMarkersOverflow: false,
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? theme.colorScheme.surface : theme.colorScheme.onSurface,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: isDark ? theme.colorScheme.surface : theme.colorScheme.onSurface,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: isDark ? theme.colorScheme.surface : theme.colorScheme.onSurface,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: isDark ? theme.colorScheme.surfaceContainerHighest : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                  ),
                  weekendStyle: TextStyle(
                    color: isDark ? Colors.red[300] : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
