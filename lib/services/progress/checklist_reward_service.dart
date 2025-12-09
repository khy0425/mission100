import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../auth/auth_service.dart';
import '../workout/checklist_history_service.dart';
import '../../models/character_evolution.dart';
import '../../utils/xp_calculator.dart';
import '../../models/user_subscription.dart';

/// 체크리스트 완료 보상 서비스
///
/// 체크리스트 완료 시 토큰 및 XP 보상을 처리합니다.
class ChecklistRewardService {
  static const int _maxTokens = 100; // 최대 토큰 보유량
  static const int _rewardAmount = 5; // 체크리스트 완료 시 보상 토큰

  /// 체크리스트 완료 보상 지급
  ///
  /// 1. 토큰 5개 지급 (최대 100개까지)
  /// 2. XP 지급 (업적 시스템 통해)
  /// 3. Week 2 도달 체크 (프리미엄 유도)
  ///
  /// Returns: (totalXP, shouldShowPremiumDialog, currentWeek)
  static Future<ChecklistRewardResult?> giveReward() async {
    try {
      final authService = AuthService();
      final user = authService.currentUser;

      if (user == null) {
        debugPrint('❌ 인증된 사용자 없음');
        return null;
      }

      // 1. 토큰 지급
      await _giveTokenReward(user.uid);

      // 2. XP는 체크리스트 기록 저장 시 자동으로 계산됨
      // (ChecklistHistoryService.getTotalXP()가 각 체크리스트 완료율 × 100을 합산)
      debugPrint('✅ 체크리스트 완료 - XP는 기록에서 자동 계산');

      // 3. 최신 XP 조회 (체크리스트 기록 기반)
      final totalXP = await ChecklistHistoryService.getTotalXP();
      final currentWeek = XPCalculator.getWeekFromXP(totalXP);

      // 4. Week 2 도달 체크 (프리미엄 유도)
      final shouldShowPremiumDialog = await _shouldShowPremiumDialog(
        currentWeek,
        authService,
      );

      return ChecklistRewardResult(
        totalXP: totalXP,
        currentWeek: currentWeek,
        shouldShowPremiumDialog: shouldShowPremiumDialog,
      );
    } catch (e) {
      debugPrint('❌ 체크리스트 완료 보상 지급 실패: $e');
      return null;
    }
  }

  /// 토큰 보상 지급 (Firestore)
  static Future<void> _giveTokenReward(String userId) async {
    final tokenRef = FirebaseFirestore.instance
        .collection('conversationTokens')
        .doc(userId);

    final tokenDoc = await tokenRef.get();
    final currentBalance =
        tokenDoc.exists ? (tokenDoc.data()!['balance'] ?? 0) : 0;

    final newBalance = (currentBalance + _rewardAmount).clamp(0, _maxTokens);

    await tokenRef.set({
      'userId': userId,
      'balance': newBalance,
      'totalEarned': FieldValue.increment(_rewardAmount),
      'totalSpent': tokenDoc.exists ? (tokenDoc.data()!['totalSpent'] ?? 0) : 0,
      'currentStreak':
          tokenDoc.exists ? (tokenDoc.data()!['currentStreak'] ?? 0) : 0,
      'lastClaimDate':
          tokenDoc.exists ? tokenDoc.data()!['lastClaimDate'] : null,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // 히스토리 기록
    await tokenRef.collection('history').add({
      'type': 'checklist_complete',
      'amount': _rewardAmount,
      'balanceBefore': currentBalance,
      'balanceAfter': newBalance,
      'createdAt': FieldValue.serverTimestamp(),
    });

    debugPrint(
      '✅ 체크리스트 완료 보상 지급: +$_rewardAmount 토큰 (잔액: $newBalance/$_maxTokens)',
    );
  }

  /// Week 2 도달 시 프리미엄 다이얼로그 표시 여부 확인
  static Future<bool> _shouldShowPremiumDialog(
    int currentWeek,
    AuthService authService,
  ) async {
    // Week 2 미만이면 프리미엄 팝업 불필요
    if (currentWeek < 2) {
      return false;
    }

    final subscription = authService.currentSubscription;
    final isPremium = subscription?.type == SubscriptionType.premium;
    final subscriptionStartDate =
        subscription?.startDate ?? DateTime.now();

    // 프리미엄 유저면 팝업 불필요
    if (isPremium) {
      return false;
    }

    // Week 2 접근 가능 여부 확인
    final canAccess = CharacterEvolution.canAccessWeek(
      currentWeek,
      isPremium,
      subscriptionStartDate,
    );

    // 접근 불가능하면 프리미엄 팝업 표시
    if (!canAccess) {
      debugPrint('🚫 Week 2 레벨업 차단! 프리미엄 팝업 표시 필요');
      return true;
    }

    return false;
  }
}

/// 체크리스트 보상 결과
class ChecklistRewardResult {
  final int totalXP;
  final int currentWeek;
  final bool shouldShowPremiumDialog;

  ChecklistRewardResult({
    required this.totalXP,
    required this.currentWeek,
    required this.shouldShowPremiumDialog,
  });
}
