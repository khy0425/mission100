import 'package:flutter/material.dart';
import '../../models/chad_evolution.dart';

/// Chad 통계 카드 위젯 - 밈 스타일로 통계 표시
class ChadStatsCard extends StatelessWidget {
  final ChadStats stats;
  final bool compact;

  const ChadStatsCard({
    super.key,
    required this.stats,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactCard(context);
    }
    return _buildFullCard(context);
  }

  Widget _buildFullCard(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[900]!,
              Colors.grey[850]!,
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'CHAD STATS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                _buildMemePowerBadge(),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Chad는 완성형이다. 남은 것은 뇌절뿐.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),

            // 메인 스탯
            Row(
              children: [
                Expanded(
                  child: _buildMainStat(
                    icon: '💪',
                    label: 'Chad Level',
                    value: stats.chadLevel.toString(),
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMainStat(
                    icon: '🧠',
                    label: 'Brainjolt',
                    value: '${stats.brainjoltDegree}°',
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 프로그레스 바들
            _buildProgressStat(
              label: 'Chad Aura',
              value: stats.chadAura,
              maxValue: 100,
              color: Colors.cyan,
              icon: '✨',
            ),
            const SizedBox(height: 12),
            _buildProgressStat(
              label: 'Jawline Sharpness',
              value: stats.jawlineSharpness,
              maxValue: 100,
              color: Colors.orange,
              icon: '🗿',
            ),
            const SizedBox(height: 16),

            // 추가 스탯들
            Row(
              children: [
                Expanded(
                  child: _buildSmallStat(
                    icon: '👥',
                    label: 'Crowd Admiration',
                    value: stats.crowdAdmiration.toString(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSmallStat(
                    icon: '⚡',
                    label: 'Voltage',
                    value: '${stats.brainjoltVoltage}V',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSmallStat(
                    icon: '🔥',
                    label: 'Consistency',
                    value: '${stats.chadConsistency} days',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSmallStat(
                    icon: '⏱️',
                    label: 'Total Hours',
                    value: '${stats.totalChadHours}h',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.grey[900]!,
              Colors.grey[850]!,
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 레벨 + 뇌절
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '💪',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Lv.${stats.chadLevel}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '🧠 Brainjolt ${stats.brainjoltDegree}°',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            const Spacer(),
            // 밈 파워 배지
            _buildMemePowerBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainStat({
    required String icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat({
    required String label,
    required double value,
    required double maxValue,
    required Color color,
    required String icon,
  }) {
    final percentage = (value / maxValue).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  icon,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Text(
              '${value.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Container(
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withValues(alpha: 0.6),
                        color,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallStat({
    required String icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemePowerBadge() {
    Color badgeColor;
    String emoji;

    switch (stats.memePower) {
      case 'GOD TIER':
        badgeColor = Colors.purple;
        emoji = '👑';
        break;
      case 'LEGENDARY':
        badgeColor = Colors.amber;
        emoji = '🌟';
        break;
      case 'EPIC':
        badgeColor = Colors.deepPurple;
        emoji = '⚡';
        break;
      case 'RARE':
        badgeColor = Colors.blue;
        emoji = '💎';
        break;
      default:
        badgeColor = Colors.grey;
        emoji = '🔰';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            badgeColor,
            badgeColor.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 4),
          Text(
            stats.memePower,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Chad 통계 그리드 (여러 스탯을 그리드로 표시)
class ChadStatsGrid extends StatelessWidget {
  final ChadStats stats;

  const ChadStatsGrid({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildGridItem(
          icon: '💪',
          label: 'Chad Level',
          value: stats.chadLevel.toString(),
          color: Colors.blue,
        ),
        _buildGridItem(
          icon: '🧠',
          label: 'Brainjolt',
          value: '${stats.brainjoltDegree}°',
          color: Colors.purple,
        ),
        _buildGridItem(
          icon: '✨',
          label: 'Chad Aura',
          value: '${stats.chadAura.toStringAsFixed(0)}%',
          color: Colors.cyan,
        ),
        _buildGridItem(
          icon: '🗿',
          label: 'Jawline',
          value: '${stats.jawlineSharpness.toStringAsFixed(0)}%',
          color: Colors.orange,
        ),
        _buildGridItem(
          icon: '👥',
          label: 'Admiration',
          value: stats.crowdAdmiration.toString(),
          color: Colors.pink,
        ),
        _buildGridItem(
          icon: '⚡',
          label: 'Voltage',
          value: '${stats.brainjoltVoltage}V',
          color: Colors.yellow,
        ),
      ],
    );
  }

  Widget _buildGridItem({
    required String icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[900]!,
            Colors.grey[850]!,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[400],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
