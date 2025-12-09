import 'package:flutter/foundation.dart';
import '../../models/checklist_history.dart';
import '../../models/lucid_dream_task.dart';
import '../../models/conversation_token.dart';
import '../../models/user_subscription.dart';
import '../workout/checklist_history_service.dart';
import '../ai/conversation_token_service.dart';
import '../auth/auth_service.dart';
import '../progress/level_up_service.dart';
import '../progress/dream_statistics_service.dart';
import '../firebase_functions_service.dart';

/// 체크리스트 완료 처리 서비스
///
/// 체크리스트 완료 시 필요한 모든 비즈니스 로직을 처리합니다:
/// - 체크리스트 히스토리 저장
/// - 토큰 보상 지급
/// - XP 및 레벨업 체크
class ChecklistCompletionService {
  /// 체크리스트 완료 데이터 저장
  static Future<void> saveChecklistHistory({
    required int dayNumber,
    required List<bool> taskCompletionStatus,
    required DailyLucidDreamChecklist checklist,
    required Duration timeElapsed,
  }) async {
    // 완료된 태스크 타입들 수집
    final completedTaskTypes = <String>[];
    int completedTaskCount = 0;
    for (int i = 0; i < checklist.tasks.length; i++) {
      if (taskCompletionStatus[i]) {
        completedTaskTypes.add(checklist.tasks[i].type.name);
        completedTaskCount++;
      }
    }

    // ChecklistHistory 객체 생성
    final history = ChecklistHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      dayNumber: dayNumber,
      completedTasks: completedTaskTypes,
      totalTasksCompleted: completedTaskCount,
      totalRequiredTasks: checklist.requiredTaskCount,
      completionRate: completedTaskCount / checklist.tasks.length,
      duration: timeElapsed,
      isWbtbDay: checklist.isWbtbDay,
    );

    // 데이터베이스에 저장
    try {
      await ChecklistHistoryService.saveChecklistHistory(history);
      debugPrint('✅ 체크리스트 데이터 저장 완료: Day $dayNumber');
    } catch (e) {
      debugPrint('❌ 체크리스트 데이터 저장 실패: $e');
    }
  }

  /// 체크리스트 완료 시 AI 대화 토큰 지급
  ///
  /// Returns: TokenRewardResult 또는 null
  static Future<TokenRewardResult?> rewardTokensForChecklistCompletion({
    required AuthService authService,
  }) async {
    try {
      final tokenService = ConversationTokenService();
      await tokenService.initialize();

      // 하루에 한 번만 토큰 지급 가능
      if (!tokenService.canClaimDailyReward) {
        debugPrint('⏰ 이미 오늘 토큰을 받았습니다.');
        return null;
      }

      // 프리미엄 여부 확인
      final isPremium = authService.currentSubscription?.type == SubscriptionType.premium;

      // 현재 streak 및 보너스 확인
      final currentTokens = tokenService.tokens;
      final bonusTokens = currentTokens.calculateBonusTokens();
      final baseTokens = isPremium
          ? 5 // 5토큰
          : 1; // 1토큰
      final totalTokens = baseTokens + bonusTokens;

      // 토큰 지급
      await tokenService.claimDailyReward(isPremium: isPremium);

      // 새로운 streak 정보
      final newTokens = tokenService.tokens;
      final newStreak = newTokens.currentStreak;

      debugPrint('✅ 체크리스트 완료 보상: +$totalTokens 토큰 지급 (기본 $baseTokens + 보너스 $bonusTokens)');

      return TokenRewardResult(
        baseTokens: baseTokens,
        bonusTokens: bonusTokens,
        totalTokens: totalTokens,
        currentStreak: newStreak,
        isPremium: isPremium,
      );
    } catch (e) {
      debugPrint('❌ 토큰 지급 실패: $e');
      return null;
    }
  }

  /// 체크리스트 완료 시 경험치 획득 및 레벨업 체크
  ///
  /// Returns: XPRewardResult 또는 null
  static Future<XPRewardResult?> checkXPAndLevelUp({
    required int completedTaskCount,
    required int totalTaskCount,
    required AuthService authService,
    int weekNumber = 1,
    int dayNumber = 1,
  }) async {
    try {
      // 완료율 기반 경험치 계산
      final completionRate = completedTaskCount / totalTaskCount;
      final xpEarned = (completionRate * 100).round();

      debugPrint('✨ 체크리스트 완료: 경험치 +$xpEarned 획득 (완료율 ${(completionRate * 100).toStringAsFixed(0)}%)');

      // 레벨업 체크
      final isPremium = authService.currentSubscription?.type == SubscriptionType.premium;
      final maxLevel = isPremium ? 9 : 1;

      final levelUpResult = await LevelUpService.checkForLevelUp(maxAllowedLevel: maxLevel);

      // 레벨업이 발생했으면 추가 정보 로드
      int? daysToNextLevel;
      if (levelUpResult.leveledUp) {
        debugPrint('🎉 레벨업 감지! ${levelUpResult.oldLevel} → ${levelUpResult.newLevel}');

        // 다음 레벨까지 필요한 일수 계산
        final stats = await DreamStatisticsService.getStatistics();
        daysToNextLevel = DreamStatisticsService.daysToNextLevel(stats);
      } else {
        debugPrint('✓ 레벨업 없음 (현재 레벨: ${levelUpResult.newLevel})');
      }

      // Firebase Functions로 체크리스트 완료 보고 및 진행도 동기화 (백그라운드)
      _reportChecklistCompletionAsync(
        weekNumber: weekNumber,
        dayNumber: dayNumber,
        xpEarned: xpEarned,
        newLevel: levelUpResult.newLevel,
      );

      return XPRewardResult(
        xpEarned: xpEarned,
        completionRate: completionRate,
        levelUpResult: levelUpResult,
        daysToNextLevel: daysToNextLevel,
      );
    } catch (e) {
      debugPrint('❌ 경험치/레벨업 체크 실패: $e');
      return null;
    }
  }

  /// Firebase Functions로 체크리스트 완료 보고 (백그라운드)
  /// TODO: FirebaseFunctionsService에 completeChecklist, syncUserProgress 메서드 구현 필요
  static void _reportChecklistCompletionAsync({
    required int weekNumber,
    required int dayNumber,
    required int xpEarned,
    required int newLevel,
  }) {
    // 서버 동기화 기능 임시 비활성화
    debugPrint('📤 체크리스트 완료: Week $weekNumber, Day $dayNumber, XP $xpEarned, Level $newLevel (서버 동기화 대기 중)');
  }
}

/// 토큰 보상 결과
class TokenRewardResult {
  final int baseTokens;
  final int bonusTokens;
  final int totalTokens;
  final int currentStreak;
  final bool isPremium;

  TokenRewardResult({
    required this.baseTokens,
    required this.bonusTokens,
    required this.totalTokens,
    required this.currentStreak,
    required this.isPremium,
  });
}

/// XP 보상 결과
class XPRewardResult {
  final int xpEarned;
  final double completionRate;
  final dynamic levelUpResult; // LevelUpResult from level_up_service
  final int? daysToNextLevel;

  XPRewardResult({
    required this.xpEarned,
    required this.completionRate,
    required this.levelUpResult,
    this.daysToNextLevel,
  });
}
