import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/rpe_data.dart';
import '../utils/constants.dart';

/// 📊 RPE 트렌드 차트 위젯
///
/// 사용자의 RPE 기록을 시각화하는 라인 차트
/// - 최근 7-30일 데이터 표시
/// - 색상 코딩 (초록/주황/빨강)
/// - 평균 RPE 라인
class RPETrendChart extends StatelessWidget {
  final List<RPEData> rpeHistory;
  final int maxDataPoints;
  final double? targetRPE;

  const RPETrendChart({
    super.key,
    required this.rpeHistory,
    this.maxDataPoints = 14,
    this.targetRPE,
  });

  @override
  Widget build(BuildContext context) {
    if (rpeHistory.isEmpty) {
      return _buildEmptyState(context);
    }

    final displayData = rpeHistory.length > maxDataPoints
        ? rpeHistory.sublist(rpeHistory.length - maxDataPoints)
        : rpeHistory;

    final averageRPE = displayData.isEmpty
        ? 7.0
        : displayData.map((d) => d.value).reduce((a, b) => a + b) /
            displayData.length;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📊 RPE 트렌드',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '평균: ${averageRPE.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: _getRPEColor(averageRPE),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              _buildLegend(),
            ],
          ),

          const SizedBox(height: AppConstants.paddingL),

          // 차트
          SizedBox(
            height: 200,
            child: LineChart(
              _buildChartData(displayData, averageRPE),
            ),
          ),

          const SizedBox(height: AppConstants.paddingM),

          // 통계 요약
          _buildStatsSummary(displayData, averageRPE),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingXL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.show_chart,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            '아직 RPE 기록이 없습니다',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            '운동 완료 후 RPE를 입력하면\n여기에 트렌드가 표시됩니다',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildLegendItem('쉬움', Colors.green),
        _buildLegendItem('적당', Colors.orange),
        _buildLegendItem('힘듦', Colors.red),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildStatsSummary(List<RPEData> data, double averageRPE) {
    final maxRPE = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    final minRPE = data.map((d) => d.value).reduce((a, b) => a < b ? a : b);

    final highIntensity = data.where((d) => d.value >= 8).length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('최고', maxRPE.toStringAsFixed(0), Colors.red),
        _buildStatItem('평균', averageRPE.toStringAsFixed(1), Colors.orange),
        _buildStatItem('최저', minRPE.toStringAsFixed(0), Colors.green),
        _buildStatItem('고강도', '$highIntensity회', Colors.red[300]!),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  LineChartData _buildChartData(List<RPEData> data, double averageRPE) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withValues(alpha: 0.3),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value < 6 || value > 10) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: _getRPEColor(value),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: data.length > 7 ? 2 : 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= data.length) {
                return const SizedBox.shrink();
              }

              final date = data[index].timestamp;
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${date.month}/${date.day}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              );
            },
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
          left: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
        ),
      ),
      minX: 0,
      maxX: (data.length - 1).toDouble(),
      minY: 5,
      maxY: 10.5,
      lineBarsData: [
        // RPE 라인
        LineChartBarData(
          spots: data
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value.value.toDouble()))
              .toList(),
          isCurved: true,
          color: const Color(AppColors.primaryColor),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: _getRPEColor(spot.y),
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                const Color(AppColors.primaryColor).withValues(alpha: 0.2),
                const Color(AppColors.primaryColor).withValues(alpha: 0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // 평균 라인 (점선)
        if (targetRPE != null)
          LineChartBarData(
            spots: [
              FlSpot(0, targetRPE!),
              FlSpot((data.length - 1).toDouble(), targetRPE!),
            ],
            isCurved: false,
            color: Colors.orange,
            barWidth: 2,
            dashArray: [5, 5],
            dotData: const FlDotData(show: false),
          ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black.withValues(alpha: 0.8),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final rpe = spot.y;
              final date = data[spot.x.toInt()].timestamp;
              return LineTooltipItem(
                'RPE: ${rpe.toInt()}\n${date.month}/${date.day}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  Color _getRPEColor(double rpe) {
    if (rpe <= 7) return Colors.green;
    if (rpe <= 8) return Colors.orange;
    return Colors.red;
  }
}
