import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'stage_unlock_service.dart';
import '../../widgets/stage/stage_up_celebration_dialog.dart';

/// 스테이지 변경 감지 및 알림 서비스
///
/// XP가 변경될 때 스테이지 변경을 감지하고
/// 스테이지가 올라가면 축하 다이얼로그를 표시합니다.
class StageChangeNotifier extends ChangeNotifier {
  static final StageChangeNotifier _instance = StageChangeNotifier._internal();
  factory StageChangeNotifier() => _instance;
  StageChangeNotifier._internal();

  static const String _lastKnownXPKey = 'last_known_xp';
  static const String _lastKnownStageKey = 'last_known_stage';

  int _currentXP = 0;
  int _currentStage = 1;
  bool _isPremium = false;
  bool _isInitialized = false;

  int get currentXP => _currentXP;
  int get currentStage => _currentStage;
  StageInfo get currentStageInfo => StageUnlockService.getStageInfo(_currentStage);

  /// 초기화
  Future<void> initialize({
    required int totalXP,
    required bool isPremium,
  }) async {
    _currentXP = totalXP;
    _isPremium = isPremium;
    _currentStage = StageUnlockService.getEffectiveStage(totalXP, isPremium: isPremium);

    final prefs = await SharedPreferences.getInstance();

    // 이전에 저장된 스테이지가 없으면 현재 스테이지 저장
    if (!prefs.containsKey(_lastKnownStageKey)) {
      await prefs.setInt(_lastKnownXPKey, totalXP);
      await prefs.setInt(_lastKnownStageKey, _currentStage);
    }

    _isInitialized = true;
    notifyListeners();
  }

  /// XP 업데이트 및 스테이지 변경 확인
  ///
  /// [context]가 제공되면 스테이지 업 시 축하 다이얼로그를 자동 표시합니다.
  /// 반환값: 스테이지가 변경되었으면 StageChangeResult, 아니면 null
  Future<StageChangeResult?> updateXP(
    int newXP, {
    bool isPremium = false,
    BuildContext? context,
  }) async {
    if (!_isInitialized) {
      await initialize(totalXP: newXP, isPremium: isPremium);
      return null;
    }

    final oldXP = _currentXP;

    _currentXP = newXP;
    _isPremium = isPremium;
    _currentStage = StageUnlockService.getEffectiveStage(newXP, isPremium: isPremium);

    // 스테이지 변경 확인
    final stageChange = StageUnlockService.checkStageChange(oldXP, newXP);

    if (stageChange != null && stageChange.isStageUp) {
      // 스테이지 업 발생!
      // ignore: avoid_print
      print('🎉 Stage Up! ${stageChange.oldStage} → ${stageChange.newStage}');

      // 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastKnownXPKey, newXP);
      await prefs.setInt(_lastKnownStageKey, _currentStage);

      // 축하 알림 표시 (SnackBar)
      if (context != null && context.mounted) {
        _showCelebrationDialog(context, stageChange);
      }

      notifyListeners();
      return stageChange;
    }

    // XP만 변경됨
    if (oldXP != newXP) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastKnownXPKey, newXP);
      notifyListeners();
    }

    return null;
  }

  /// 축하 알림 표시 (SnackBar 스타일 - 자연스러움)
  void _showCelebrationDialog(
    BuildContext context,
    StageChangeResult stageChange,
  ) {
    // 자연스러운 SnackBar 스타일로 표시
    StageUpCelebrationDialog.showSnackBar(
      context,
      stageChange: stageChange,
    );
  }

  /// 다이얼로그로 축하 표시 (명시적으로 호출 시)
  Future<void> showCelebrationDialog(
    BuildContext context,
    StageChangeResult stageChange,
  ) async {
    await StageUpCelebrationDialog.show(
      context,
      stageChange: stageChange,
    );
  }

  /// 수동으로 축하 다이얼로그 표시 (테스트/디버그용)
  void showCelebrationManually(
    BuildContext context, {
    required int fromStage,
    required int toStage,
  }) {
    final stageChange = StageChangeResult(
      oldStage: fromStage,
      newStage: toStage,
      newlyUnlockedFeatures: StageUnlockService.getNewlyUnlockedFeatures(toStage),
      newStageInfo: StageUnlockService.getStageInfo(toStage),
    );

    _showCelebrationDialog(context, stageChange);
  }

  /// 현재 스테이지 진행률 (0.0 ~ 1.0)
  double get stageProgress => StageUnlockService.getStageProgress(_currentXP);

  /// 다음 스테이지까지 필요한 XP
  int get xpToNextStage => StageUnlockService.getXPToNextStage(_currentXP);

  /// 다음 스테이지까지 필요한 일수
  int get daysToNextStage => StageUnlockService.getDaysToNextStage(_currentXP);

  /// 특정 기능이 해금되었는지 확인
  bool isFeatureUnlocked(UnlockableFeature feature) {
    return StageUnlockService.isFeatureUnlocked(
      feature,
      totalXP: _currentXP,
      isPremium: _isPremium,
    );
  }

  /// 모든 해금된 기능 목록
  List<UnlockableFeature> get unlockedFeatures {
    final effectiveStage = StageUnlockService.getEffectiveStage(
      _currentXP,
      isPremium: _isPremium,
    );

    final unlocked = <UnlockableFeature>[];
    for (int i = 0; i < effectiveStage; i++) {
      unlocked.addAll(StageUnlockService.stages[i].unlockedFeatures);
    }
    return unlocked;
  }

  /// 다음 스테이지에서 해금될 기능 목록
  List<UnlockableFeature> get nextStageFeatures {
    if (_currentStage >= 6) return [];
    return StageUnlockService.getNewlyUnlockedFeatures(_currentStage + 1);
  }

  /// 스테이지 정보 요약
  Map<String, dynamic> get stageSummary {
    final info = currentStageInfo;
    return {
      'stage': _currentStage,
      'stageName': info.name,
      'stageNameKo': info.nameKo,
      'emoji': info.emoji,
      'currentXP': _currentXP,
      'progress': stageProgress,
      'xpToNextStage': xpToNextStage,
      'daysToNextStage': daysToNextStage,
      'dailyTokens': info.dailyTokens,
      'isPremium': _isPremium,
      'requiresPremiumForNext': _currentStage >= 2 && !_isPremium,
    };
  }

  /// 디버그 출력
  void printDebugInfo() {
    StageUnlockService.debugPrintStageInfo(_currentXP, isPremium: _isPremium);
  }
}

/// 스테이지 진행 상황 위젯
///
/// 현재 스테이지와 다음 스테이지까지의 진행 상황을 표시합니다.
class StageProgressWidget extends StatelessWidget {
  final int totalXP;
  final bool isPremium;
  final bool showDetails;
  final Color? primaryColor;

  const StageProgressWidget({
    super.key,
    required this.totalXP,
    required this.isPremium,
    this.showDetails = true,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStage = StageUnlockService.getEffectiveStage(
      totalXP,
      isPremium: isPremium,
    );
    final stageInfo = StageUnlockService.getStageInfo(effectiveStage);
    final progress = StageUnlockService.getStageProgress(totalXP);
    final xpToNext = StageUnlockService.getXPToNextStage(totalXP);
    final daysToNext = StageUnlockService.getDaysToNextStage(totalXP);

    final color = primaryColor ?? _getStageColor(effectiveStage);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 스테이지 정보
          Row(
            children: [
              Text(stageInfo.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stageInfo.nameKo,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      'Stage ${stageInfo.stage}',
                      style: TextStyle(
                        fontSize: 12,
                        color: color.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.token, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${stageInfo.dailyTokens}/일',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (showDetails && effectiveStage < 6) ...[
            const SizedBox(height: 16),
            // 진행 바
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            // 다음 스테이지까지 정보
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '다음 스테이지까지 ${xpToNext}XP (약 $daysToNext일)',
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
          // 프리미엄 필요 알림
          if (!isPremium && effectiveStage >= 2) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Stage 3+ 진행을 위해 프리미엄이 필요합니다',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStageColor(int stage) {
    switch (stage) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.teal;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.indigo;
      case 5:
        return Colors.purple;
      case 6:
        return Colors.amber;
      default:
        return Colors.blue;
    }
  }
}
