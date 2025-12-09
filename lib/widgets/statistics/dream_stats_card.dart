import 'package:flutter/material.dart';
import '../../services/progress/dream_statistics_service.dart';
import '../../utils/config/constants.dart';
import '../../generated/l10n/app_localizations.dart';

/// 자각몽 훈련 통계 카드 위젯 (Phase 2 - 레벨 & 배지 포함)
///
/// 표시 정보:
/// - 레벨 시스템 (훈련 일수와 완료율 기반)
/// - 성과 레벨 배지 (초보자/숙련자/마스터)
/// - 총 훈련 일수
/// - 현재 연속 기록 (streak)
/// - 평균 완료율
/// - 프로그램 진행 상황 (30일 중 X일)
/// - 주간 활동 미니 차트
class DreamStatsCard extends StatelessWidget {
  const DreamStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DreamStatistics>(
      future: DreamStatisticsService.getStatistics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard();
        }

        final stats = snapshot.data ?? DreamStatistics.empty();
        return _buildStatsCard(context, stats);
      },
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Color(AppColors.primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, DreamStatistics stats) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 with 레벨 & 배지
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // 레벨 원형 배지
                _buildLevelBadge(stats),
                const SizedBox(width: 16),
                // 타이틀 & 성과 배지
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.trainingProgress,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(AppColors.primaryColor),
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildPerformanceBadge(l10n, stats),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 통계 그리드
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        context,
                        icon: Icons.calendar_today,
                        label: l10n.totalDays,
                        value: '${stats.totalTrainingDays}',
                        unit: l10n.daysUnit,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        icon: Icons.local_fire_department,
                        label: l10n.currentStreak,
                        value: '${stats.currentStreak}',
                        unit: l10n.daysUnit,
                        highlight: stats.currentStreak >= 3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        context,
                        icon: Icons.book_outlined,
                        label: l10n.dreamJournals,
                        value: '${stats.dreamJournalCount}',
                        unit: l10n.timesUnit,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        icon: Icons.trending_up,
                        label: l10n.avgCompletion,
                        value: '${stats.completionPercent}',
                        unit: '%',
                        highlight: stats.averageCompletionRate >= 0.8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 프로그램 진행 바
          if (stats.programProgress > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.programProgress,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${stats.programProgress}/${stats.programTotal}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: stats.programCompletionRate,
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(AppColors.primaryColor),
                      ),
                    ),
                  ),
                  if (stats.isProgramComplete)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.celebration,
                            size: 16,
                            color: Color(AppColors.primaryColor),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.programCompleted,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(AppColors.primaryColor),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

          // 빈 상태 메시지
          if (stats.totalTrainingDays == 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(AppColors.primaryColor).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(AppColors.primaryColor).withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: const Color(AppColors.primaryColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.startTrainingMessage,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 레벨 원형 배지 (Phase 2)
  Widget _buildLevelBadge(DreamStatistics stats) {
    final level = DreamStatisticsService.calculateLevel(stats);

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(AppColors.primaryColor),
            const Color(AppColors.primaryColor).withValues(alpha: 0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Lv',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '$level',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 성과 레벨 배지 (Phase 2)
  Widget _buildPerformanceBadge(AppLocalizations l10n, DreamStatistics stats) {
    final level = stats.performanceLevel;
    String label;
    Color color;
    IconData icon;

    switch (level) {
      case 'master':
        label = l10n.levelMaster;
        color = const Color(0xFF7B1FA2); // 진한 보라
        icon = Icons.stars;
        break;
      case 'skilled':
        label = l10n.levelSkilled;
        color = const Color(AppColors.primaryColor);
        icon = Icons.star;
        break;
      default: // 'novice'
        label = l10n.levelNovice;
        color = Colors.grey[600]!;
        icon = Icons.auto_awesome;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    bool highlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight
            ? const Color(AppColors.primaryColor).withValues(alpha: 0.05)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight
              ? const Color(AppColors.primaryColor).withValues(alpha: 0.3)
              : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: highlight
                    ? const Color(AppColors.primaryColor)
                    : Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: highlight
                      ? const Color(AppColors.primaryColor)
                      : Colors.grey[800],
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
