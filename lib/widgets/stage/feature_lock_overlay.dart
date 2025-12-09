import 'package:flutter/material.dart';
import '../../services/progress/stage_unlock_service.dart';

/// 기능 잠금 오버레이 위젯
///
/// 잠긴 기능 위에 반투명 오버레이와 자물쇠 아이콘을 표시합니다.
/// 탭하면 해금 조건을 안내하는 다이얼로그를 표시합니다.
class FeatureLockOverlay extends StatelessWidget {
  final Widget child;
  final UnlockableFeature feature;
  final int totalXP;
  final bool isPremium;
  final VoidCallback? onLockedTap;

  const FeatureLockOverlay({
    super.key,
    required this.child,
    required this.feature,
    required this.totalXP,
    required this.isPremium,
    this.onLockedTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlocked = StageUnlockService.isFeatureUnlocked(
      feature,
      totalXP: totalXP,
      isPremium: isPremium,
    );

    if (isUnlocked) {
      return child;
    }

    // 이 기능이 해금되는 스테이지 찾기
    final unlockStage = _findUnlockStage(feature);
    final stageInfo = StageUnlockService.getStageInfo(unlockStage);

    return Stack(
      children: [
        // 원본 위젯 (흐리게)
        Opacity(
          opacity: 0.4,
          child: IgnorePointer(child: child),
        ),
        // 잠금 오버레이
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              if (onLockedTap != null) {
                onLockedTap!();
              } else {
                _showUnlockDialog(context, stageInfo);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 자물쇠 아이콘
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 해금 조건 텍스트
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${stageInfo.emoji} ${stageInfo.nameKo}에서 해금',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  int _findUnlockStage(UnlockableFeature feature) {
    for (final stage in StageUnlockService.stages) {
      if (stage.unlockedFeatures.contains(feature)) {
        return stage.stage;
      }
    }
    return 1;
  }

  void _showUnlockDialog(BuildContext context, StageInfo stageInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Text(stageInfo.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${stageInfo.nameKo} 단계에서 해금',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이 기능은 ${stageInfo.nameKo}(Stage ${stageInfo.stage}) 단계에 도달하면 해금됩니다.',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            _buildProgressInfo(stageInfo),
            if (stageInfo.requiresPremium) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '프리미엄 구독이 필요합니다',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.amber,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressInfo(StageInfo stageInfo) {
    final currentStage = StageUnlockService.getStageFromXP(totalXP);
    final xpNeeded = stageInfo.minXP - totalXP;
    final daysNeeded = (xpNeeded / 100).ceil();

    if (currentStage >= stageInfo.stage) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 20),
            SizedBox(width: 8),
            Text(
              '이미 해금 조건을 충족했습니다!',
              style: TextStyle(color: Colors.green),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                '현재: Stage $currentStage → 목표: Stage ${stageInfo.stage}',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '약 $daysNeeded일 후 해금 (${xpNeeded}XP 필요)',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

/// 간단한 잠금 아이콘 배지
///
/// 기능 아이콘 위에 작은 자물쇠 배지를 표시합니다.
class LockBadge extends StatelessWidget {
  final Widget child;
  final bool isLocked;
  final double badgeSize;

  const LockBadge({
    super.key,
    required this.child,
    required this.isLocked,
    this.badgeSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLocked) return child;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Opacity(opacity: 0.5, child: child),
        Positioned(
          right: -4,
          top: -4,
          child: Container(
            width: badgeSize,
            height: badgeSize,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: Icon(
              Icons.lock,
              size: badgeSize * 0.6,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
