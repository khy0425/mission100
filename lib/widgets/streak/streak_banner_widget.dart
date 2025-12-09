import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../services/progress/streak_service.dart';

/// 홈 화면용 스트릭 강조 배너 위젯
///
/// "🔥 7일 연속! 오늘 체크리스트를 완료하면 보너스 토큰!"
/// - 현재 스트릭 표시
/// - 위험 상태 시 강조 (오늘 안하면 스트릭 중단)
/// - 다음 마일스톤까지 남은 일수
class StreakBannerWidget extends StatefulWidget {
  final VoidCallback? onTap;

  const StreakBannerWidget({
    super.key,
    this.onTap,
  });

  @override
  State<StreakBannerWidget> createState() => _StreakBannerWidgetState();
}

class _StreakBannerWidgetState extends State<StreakBannerWidget>
    with SingleTickerProviderStateMixin {
  final _streakService = StreakService();

  int _currentStreak = 0;
  int _longestStreak = 0;
  bool _isAtRisk = false;
  int? _daysToNextMilestone;
  bool _isLoading = true;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _loadStreakData();
  }

  void _setupAnimation() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  Future<void> _loadStreakData() async {
    try {
      final currentStreak = await _streakService.getCurrentStreak();
      final longestStreak = await _streakService.getLongestStreak();
      final isAtRisk = await _streakService.isStreakAtRisk();
      final daysToNext = await _streakService.getDaysToNextMilestone();

      if (mounted) {
        setState(() {
          _currentStreak = currentStreak;
          _longestStreak = longestStreak;
          _isAtRisk = isAtRisk;
          _daysToNextMilestone = daysToNext;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('스트릭 데이터 로드 오류: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox.shrink();
    }

    // 스트릭이 0이면 시작 유도 메시지
    if (_currentStreak == 0) {
      return _buildStartBanner(context);
    }

    // 위험 상태면 경고 배너
    if (_isAtRisk) {
      return _buildRiskBanner(context);
    }

    // 일반 스트릭 배너
    return _buildNormalBanner(context);
  }

  /// 스트릭 시작 유도 배너
  Widget _buildStartBanner(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Colors.indigo.shade100,
                    Colors.purple.shade100,
                    Colors.blue.shade100,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withValues(alpha: 0.2 * (_pulseAnimation.value - 0.85)),
                    blurRadius: 12 * (_pulseAnimation.value - 0.85),
                    spreadRadius: 2 * (_pulseAnimation.value - 0.85),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: child,
            );
          },
          child: Row(
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.9 + (_pulseAnimation.value - 1.0) * 0.3,
                    child: child,
                  );
                },
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade400, Colors.indigo.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🌙', style: TextStyle(fontSize: 26)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.homeStreakStartTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.indigo.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.homeStreakStartSubtitle,
                          style: TextStyle(
                            color: Colors.purple.shade700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.indigo.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 스트릭 위험 경고 배너
  Widget _buildRiskBanner(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.orange.shade50,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade300, width: 2),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: child,
                  );
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade400, Colors.red.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 20)),
                      Text(
                        '$_currentStreak',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                              color: Colors.orange, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              l10n.streakDaysOngoing(_currentStreak),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.streakRiskMessage,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.orange.shade800,
                          ),
                        ),
                        if (_daysToNextMilestone != null && _daysToNextMilestone! <= 7)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              l10n.streakMilestoneProgress(_currentStreak + _daysToNextMilestone!, _daysToNextMilestone!),
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 일반 스트릭 배너
  Widget _buildNormalBanner(BuildContext context) {
    // 스트릭에 따른 색상 그라데이션
    final (Color startColor, Color endColor, String emoji) = switch (_currentStreak) {
      >= 100 => (Colors.purple.shade400, Colors.pink.shade400, '💎'),
      >= 50 => (Colors.amber.shade600, Colors.orange.shade600, '⭐'),
      >= 30 => (Colors.orange.shade500, Colors.red.shade500, '👑'),
      >= 14 => (Colors.orange.shade400, Colors.deepOrange.shade400, '🏆'),
      >= 7 => (Colors.orange.shade300, Colors.orange.shade500, '💪'),
      >= 3 => (Colors.orange.shade200, Colors.orange.shade400, '🔥'),
      _ => (Colors.blue.shade300, Colors.blue.shade500, '🔥'),
    };

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [startColor.withValues(alpha: 0.15), endColor.withValues(alpha: 0.15)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [startColor, endColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: startColor.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 18)),
                    Text(
                      '$_currentStreak',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$emoji ${l10n.streakDaysAchieved(_currentStreak)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: endColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (_daysToNextMilestone != null)
                          Text(
                            l10n.streakDaysUntilMilestone(_daysToNextMilestone!),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          )
                        else
                          Text(
                            l10n.streakBestRecord(_longestStreak),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        const SizedBox(height: 6),
                        // 마일스톤 진행바
                        if (_daysToNextMilestone != null)
                          _buildMilestoneProgress(startColor, endColor),
                      ],
                    );
                  },
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMilestoneProgress(Color startColor, Color endColor) {
    // 다음 마일스톤 계산
    final milestones = [3, 7, 14, 30, 50, 100, 200, 365];
    int? nextMilestone;
    int previousMilestone = 0;

    for (final m in milestones) {
      if (_currentStreak < m) {
        nextMilestone = m;
        break;
      }
      previousMilestone = m;
    }

    if (nextMilestone == null) return const SizedBox.shrink();

    final range = nextMilestone - previousMilestone;
    final progress = (_currentStreak - previousMilestone) / range;

    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(endColor),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.streakDays(previousMilestone),
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
                Text(
                  l10n.streakDaysTarget(nextMilestone!),
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// 컴팩트 스트릭 위젯 (AppBar 등에서 사용)
class CompactStreakWidget extends StatefulWidget {
  const CompactStreakWidget({super.key});

  @override
  State<CompactStreakWidget> createState() => _CompactStreakWidgetState();
}

class _CompactStreakWidgetState extends State<CompactStreakWidget> {
  final _streakService = StreakService();
  int _currentStreak = 0;
  bool _isAtRisk = false;

  @override
  void initState() {
    super.initState();
    _loadStreak();
  }

  Future<void> _loadStreak() async {
    final streak = await _streakService.getCurrentStreak();
    final isAtRisk = await _streakService.isStreakAtRisk();
    if (mounted) {
      setState(() {
        _currentStreak = streak;
        _isAtRisk = isAtRisk;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentStreak == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _isAtRisk
            ? Colors.orange.withValues(alpha: 0.2)
            : Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: _isAtRisk
            ? Border.all(color: Colors.orange.shade300)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _isAtRisk ? '⚠️' : '🔥',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 4),
          Text(
            '$_currentStreak',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _isAtRisk ? Colors.orange : null,
            ),
          ),
        ],
      ),
    );
  }
}
