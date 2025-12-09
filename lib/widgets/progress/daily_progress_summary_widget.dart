import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 일일/주간 진행 상황 요약 위젯
///
/// "오늘: ✅ 3/3 완료, 이번 주: 5일/7일, 이번 달: 87% 달성률"
/// - 오늘 체크리스트 현황
/// - 이번 주 연속 기록
/// - 이번 달 달성률
class DailyProgressSummaryWidget extends StatefulWidget {
  final int todayCompleted;
  final int todayTotal;
  final VoidCallback? onTap;

  const DailyProgressSummaryWidget({
    super.key,
    required this.todayCompleted,
    required this.todayTotal,
    this.onTap,
  });

  @override
  State<DailyProgressSummaryWidget> createState() => _DailyProgressSummaryWidgetState();
}

class _DailyProgressSummaryWidgetState extends State<DailyProgressSummaryWidget> {
  int _weeklyDays = 0;
  double _monthlyRate = 0.0;

  @override
  void initState() {
    super.initState();
    _loadProgressData();
  }

  Future<void> _loadProgressData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 이번 주 완료 일수 계산
      final weeklyDays = await _calculateWeeklyDays(prefs);

      // 이번 달 달성률 계산
      final monthlyRate = await _calculateMonthlyRate(prefs);

      if (mounted) {
        setState(() {
          _weeklyDays = weeklyDays;
          _monthlyRate = monthlyRate;
        });
      }
    } catch (e) {
      debugPrint('진행 상황 로드 오류: $e');
    }
  }

  Future<int> _calculateWeeklyDays(SharedPreferences prefs) async {
    // checklist_dates 키에서 완료된 날짜들 가져오기
    final completedDates = prefs.getStringList('checklist_completed_dates') ?? [];

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    int count = 0;
    for (final dateStr in completedDates) {
      try {
        final date = DateTime.parse(dateStr);
        if (date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
            date.isBefore(now.add(const Duration(days: 1)))) {
          count++;
        }
      } catch (e) {
        // 파싱 오류 무시
      }
    }

    return count;
  }

  Future<double> _calculateMonthlyRate(SharedPreferences prefs) async {
    final completedDates = prefs.getStringList('checklist_completed_dates') ?? [];

    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final daysInMonth = now.day;

    int count = 0;
    for (final dateStr in completedDates) {
      try {
        final date = DateTime.parse(dateStr);
        if (date.isAfter(monthStart.subtract(const Duration(days: 1))) &&
            date.isBefore(now.add(const Duration(days: 1)))) {
          count++;
        }
      } catch (e) {
        // 파싱 오류 무시
      }
    }

    return daysInMonth > 0 ? (count / daysInMonth) * 100 : 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todayProgress = widget.todayTotal > 0
        ? widget.todayCompleted / widget.todayTotal
        : 0.0;
    final isTodayComplete = widget.todayCompleted >= widget.todayTotal && widget.todayTotal > 0;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              Row(
                children: [
                  Icon(Icons.insights, color: theme.primaryColor, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    '진행 현황',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  if (isTodayComplete)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 14),
                          SizedBox(width: 4),
                          Text(
                            '오늘 완료!',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // 3가지 진행 지표
              Row(
                children: [
                  // 오늘 체크리스트
                  Expanded(
                    child: _buildProgressItem(
                      icon: isTodayComplete ? Icons.check_circle : Icons.today,
                      iconColor: isTodayComplete ? Colors.green : theme.primaryColor,
                      label: '오늘',
                      value: '${widget.todayCompleted}/${widget.todayTotal}',
                      progress: todayProgress,
                      progressColor: isTodayComplete ? Colors.green : theme.primaryColor,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey.shade200,
                  ),
                  // 이번 주
                  Expanded(
                    child: _buildProgressItem(
                      icon: Icons.date_range,
                      iconColor: Colors.blue,
                      label: '이번 주',
                      value: '$_weeklyDays/7일',
                      progress: _weeklyDays / 7,
                      progressColor: Colors.blue,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey.shade200,
                  ),
                  // 이번 달
                  Expanded(
                    child: _buildProgressItem(
                      icon: Icons.calendar_month,
                      iconColor: Colors.purple,
                      label: '이번 달',
                      value: '${_monthlyRate.toInt()}%',
                      progress: _monthlyRate / 100,
                      progressColor: Colors.purple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required double progress,
    required Color progressColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ],
      ),
    );
  }
}

/// 간단한 진행 상황 배지 (AppBar용)
class ProgressBadge extends StatelessWidget {
  final int completed;
  final int total;

  const ProgressBadge({
    super.key,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final isComplete = completed >= total && total > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isComplete
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isComplete ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: isComplete ? Colors.green : Colors.blue,
          ),
          const SizedBox(width: 4),
          Text(
            '$completed/$total',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isComplete ? Colors.green : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
