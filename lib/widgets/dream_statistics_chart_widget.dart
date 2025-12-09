import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/dream_entry.dart';
import '../utils/config/constants.dart';
import '../generated/l10n/app_localizations.dart';

/// 꿈 통계 차트 위젯
///
/// fl_chart를 사용한 다양한 꿈 통계 시각화:
/// - 자각도 추세 (Line Chart)
/// - 자각몽 성공률 (Pie Chart)
/// - 주간 통계 (Bar Chart)
///
/// 모든 차트에 부드러운 애니메이션 적용
class DreamStatisticsChartWidget extends StatefulWidget {
  final List<DreamEntry> dreams;

  const DreamStatisticsChartWidget({
    super.key,
    required this.dreams,
  });

  @override
  State<DreamStatisticsChartWidget> createState() =>
      _DreamStatisticsChartWidgetState();
}

class _DreamStatisticsChartWidgetState
    extends State<DreamStatisticsChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (widget.dreams.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Center(
            child: Text(
              l10n.dreamStatisticsNoData,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 자각몽 성공률 (Pie Chart)
        _buildLucidSuccessRateCard(),
        const SizedBox(height: AppConstants.paddingM),

        // 자각도 추세 (Line Chart)
        if (widget.dreams.length >= 2) _buildLucidityTrendCard(),
        if (widget.dreams.length >= 2) const SizedBox(height: AppConstants.paddingM),

        // 주간 통계 (Bar Chart)
        if (widget.dreams.length >= 3) _buildWeeklyStatsCard(),
      ],
    );
  }

  /// 자각몽 성공률 파이 차트
  Widget _buildLucidSuccessRateCard() {
    final lucidCount = widget.dreams.where((d) => d.wasLucid).length;
    final normalCount = widget.dreams.length - lucidCount;
    final successRate =
        widget.dreams.isEmpty ? 0.0 : (lucidCount / widget.dreams.length) * 100;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final l10n = AppLocalizations.of(context);
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.pie_chart, size: 20, color: Colors.purple),
                    const SizedBox(width: 8),
                    Text(
                      l10n.lucidSuccessRate,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeL,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingM),
                SizedBox(
                  height: 200,
                  child: Row(
                    children: [
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                            sections: [
                              PieChartSectionData(
                                color: Colors.amber,
                                value: lucidCount.toDouble() * _animation.value,
                                title: _animation.value > 0.5
                                    ? '$lucidCount'
                                    : '',
                                radius: 50,
                                titleStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                color: Colors.grey.shade400,
                                value: normalCount.toDouble() * _animation.value,
                                title: _animation.value > 0.5
                                    ? '$normalCount'
                                    : '',
                                radius: 50,
                                titleStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingM),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 8),
                              Text(l10n.lucidDreamCount(lucidCount.toString())),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(width: 8),
                              Text(l10n.normalDreamCount(normalCount.toString())),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Opacity(
                            opacity: _animation.value,
                            child: Text(
                              l10n.successRatePercent(successRate.toStringAsFixed(1)),
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeL,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 자각도 추세 라인 차트
  Widget _buildLucidityTrendCard() {
    // 최근 10개 꿈만 표시
    final recentDreams = widget.dreams.take(10).toList().reversed.toList();

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final l10n = AppLocalizations.of(context);
        // 애니메이션 진행에 따라 점진적으로 보여줄 데이터 포인트 수
        final visibleCount = (recentDreams.length * _animation.value).ceil();
        final spots = recentDreams
            .take(visibleCount)
            .toList()
            .asMap()
            .entries
            .map((e) => FlSpot(
                  e.key.toDouble(),
                  e.value.lucidityLevel.toDouble(),
                ))
            .toList();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.show_chart, size: 20, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      l10n.lucidityTrend,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeL,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingS),
                Text(
                  l10n.recentDreams10,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: AppConstants.paddingM),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 2,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.shade300,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 2,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              );
                            },
                            reservedSize: 28,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < recentDreams.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                            reservedSize: 28,
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                          left: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      minX: 0,
                      maxX: (recentDreams.length - 1).toDouble(),
                      minY: 0,
                      maxY: 10,
                      lineBarsData: spots.isEmpty
                          ? []
                          : [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter: (spot, percent, barData, index) {
                                    if (index >= recentDreams.length) {
                                      return FlDotCirclePainter(
                                        radius: 4,
                                        color: Colors.blue,
                                        strokeWidth: 2,
                                        strokeColor: Colors.white,
                                      );
                                    }
                                    return FlDotCirclePainter(
                                      radius: 4,
                                      color: recentDreams[index].wasLucid
                                          ? Colors.amber
                                          : Colors.blue,
                                      strokeWidth: 2,
                                      strokeColor: Colors.white,
                                    );
                                  },
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.blue.withValues(alpha: 0.1),
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingS),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.circle, size: 12, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(l10n.lucidDream, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 16),
                    const Icon(Icons.circle, size: 12, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(l10n.normalDream, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 주간 통계 바 차트
  Widget _buildWeeklyStatsCard() {
    // 최근 7일간 날짜별 꿈 개수
    final Map<DateTime, int> dreamsByDay = {};
    final now = DateTime.now();

    for (var i = 6; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      dreamsByDay[date] = 0;
    }

    for (final dream in widget.dreams) {
      final dreamDate = DateTime(
        dream.dreamDate.year,
        dream.dreamDate.month,
        dream.dreamDate.day,
      );
      if (dreamsByDay.containsKey(dreamDate)) {
        dreamsByDay[dreamDate] = dreamsByDay[dreamDate]! + 1;
      }
    }

    final sortedDates = dreamsByDay.keys.toList()..sort();

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final l10n = AppLocalizations.of(context);
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bar_chart, size: 20, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      l10n.weeklyStatistics,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeL,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingS),
                Text(
                  l10n.weeklyStatisticsSubtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: AppConstants.paddingM),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (dreamsByDay.values.reduce((a, b) => a > b ? a : b) + 1)
                          .toDouble(),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final date = sortedDates[group.x.toInt()];
                            return BarTooltipItem(
                              '${date.month}/${date.day}\n${(rod.toY / _animation.value).toInt()}개',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              );
                            },
                            reservedSize: 28,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < sortedDates.length) {
                                final date = sortedDates[index];
                                final weekday = ['월', '화', '수', '목', '금', '토', '일'];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    weekday[(date.weekday - 1) % 7],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                            reservedSize: 28,
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                          left: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.shade300,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      barGroups: sortedDates.asMap().entries.map((entry) {
                        // 각 막대에 약간의 지연 적용 (staggered animation)
                        final barDelay = entry.key / sortedDates.length;
                        final barProgress = ((_animation.value - barDelay) / (1 - barDelay))
                            .clamp(0.0, 1.0);

                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: dreamsByDay[entry.value]!.toDouble() * barProgress,
                              color: Colors.green,
                              width: 16,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
