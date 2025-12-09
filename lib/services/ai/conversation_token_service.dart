import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/conversation_token.dart';
import '../progress/stage_unlock_service.dart';

/// 대화 토큰 관리 서비스 (Firestore + Cloud Functions)
///
/// 서버측 검증을 통해 토큰 조작 방지
class ConversationTokenService extends ChangeNotifier {
  static final ConversationTokenService _instance =
      ConversationTokenService._internal();
  factory ConversationTokenService() => _instance;
  ConversationTokenService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription<DocumentSnapshot>? _tokenSubscription;
  ConversationTokens _tokens = ConversationTokens.initial();
  bool _isInitialized = false;

  /// 현재 토큰 상태
  ConversationTokens get tokens => _tokens;

  /// 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _setupTokenListener();
    _isInitialized = true;
    notifyListeners();
  }

  /// 토큰 실시간 리스너 설정
  Future<void> _setupTokenListener() async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint('❌ No authenticated user for token listener');
      return;
    }

    debugPrint('🔄 Setting up token listener for user: ${user.uid}');

    // 먼저 문서 존재 여부 확인 (신규 사용자 체크)
    final tokenRef = _firestore.collection('conversationTokens').doc(user.uid);
    final initialSnapshot = await tokenRef.get();

    if (!initialSnapshot.exists) {
      // 🎁 신규 사용자! 환영 보너스 1토큰 지급
      debugPrint('🎉 NEW USER DETECTED! Granting welcome bonus...');

      bool bonusGranted = false;

      // 먼저 Cloud Function 시도
      try {
        final callable = _functions.httpsCallable('grantWelcomeBonus');
        final result = await callable.call<Map<String, dynamic>>();

        final data = result.data;
        final success = data['success'] as bool;
        final message = data['message'] as String?;

        if (success) {
          debugPrint('✅ Welcome bonus granted via Cloud Function: +1 token!');
          debugPrint('   Message: $message');
          bonusGranted = true;
        } else {
          debugPrint('ℹ️ Welcome bonus already granted');
          bonusGranted = true; // 이미 지급됨
        }
      } catch (e) {
        debugPrint('⚠️ Cloud Function failed: $e');
        debugPrint('🔄 Trying local fallback...');
      }

      // Cloud Function 실패 시 로컬에서 직접 토큰 문서 생성
      if (!bonusGranted) {
        try {
          await tokenRef.set({
            'balance': 1,
            'totalEarned': 1,
            'totalSpent': 0,
            'lastClaimDate': FieldValue.serverTimestamp(),
            'currentStreak': 0,
            'createdAt': FieldValue.serverTimestamp(),
            'welcomeBonusGranted': true,
          });
          debugPrint('✅ Welcome bonus granted via local fallback: +1 token!');
        } catch (fallbackError) {
          debugPrint('❌ Local fallback also failed: $fallbackError');
        }
      }
    }

    // Firestore 실시간 리스너
    _tokenSubscription = _firestore
        .collection('conversationTokens')
        .doc(user.uid)
        .snapshots()
        .listen(
      (snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data()!;
          _tokens = ConversationTokens.fromJson({
            'balance': data['balance'] ?? 0,
            'lastDailyReward': data['lastClaimDate'] ?? DateTime.now().toIso8601String(),
            'lifetimeEarned': data['totalEarned'] ?? 0,
            'lifetimeSpent': data['totalSpent'] ?? 0,
            'currentStreak': data['currentStreak'] ?? 0,
          });
          debugPrint('✅ Token balance updated: ${_tokens.balance}');
          notifyListeners();
        } else {
          // 토큰 문서가 없으면 초기 상태 (일반적으로 발생하지 않음)
          _tokens = ConversationTokens.initial();
          debugPrint('ℹ️ No token document - using initial state');
          notifyListeners();
        }
      },
      onError: (error) {
        debugPrint('❌ Token listener error: $error');
      },
    );
  }

  /// 일일 보상 받기 (서버 호출)
  Future<void> claimDailyReward({required bool isPremium}) async {
    try {
      debugPrint('📞 Calling claimDailyReward Cloud Function...');

      final callable = _functions.httpsCallable('claimDailyReward');
      final result = await callable.call<Map<String, dynamic>>({
        'isPremium': isPremium,
      });

      final data = result.data;
      final tokensEarned = data['tokensEarned'] as int;
      final newBalance = data['newBalance'] as int;
      final currentStreak = data['currentStreak'] as int;

      debugPrint('✅ Daily reward claimed: +$tokensEarned tokens (Balance: $newBalance, Streak: $currentStreak)');

      // Firestore 리스너가 자동으로 상태 업데이트
    } catch (e) {
      debugPrint('❌ Failed to claim daily reward: $e');
      rethrow;
    }
  }

  /// 리워드 광고로 토큰 획득 (서버 호출)
  Future<bool> earnFromRewardAd({required bool isPremium}) async {
    try {
      debugPrint('📞 Calling earnRewardAdTokens Cloud Function...');

      final callable = _functions.httpsCallable('earnRewardAdTokens');
      final result = await callable.call<Map<String, dynamic>>({
        'isPremium': isPremium,
      });

      final data = result.data;
      final tokensEarned = data['tokensEarned'] as int;
      final newBalance = data['newBalance'] as int;
      final adsWatchedToday = data['adsWatchedToday'] as int;
      final maxDailyAds = data['maxDailyAds'] as int;

      debugPrint('✅ Earned tokens from ad: +$tokensEarned token ($adsWatchedToday/$maxDailyAds today, Balance: $newBalance)');

      // Firestore 리스너가 자동으로 상태 업데이트
      return true;
    } catch (e) {
      debugPrint('❌ Failed to earn from reward ad: $e');

      // 일일 제한 초과는 정상적인 에러이므로 false 반환
      if (e.toString().contains('일일 광고 시청 제한')) {
        return false;
      }

      rethrow;
    }
  }

  /// 일일 체크리스트 완료로 토큰 획득 (Optimistic UI)
  ///
  /// 3개 필수 태스크 (꿈일기, 현실확인, MILD) 완료 시 호출됩니다.
  /// **Optimistic UI**: 먼저 로컬에서 토큰을 추가하고 UI를 즉시 업데이트한 후,
  /// 서버 동기화는 백그라운드에서 진행합니다.
  Future<bool> earnFromDailyChecklist() async {
    const tokensToAdd = 1; // 체크리스트 완료 보상

    // 1️⃣ Optimistic Update: 로컬 먼저 업데이트 → UI 즉시 반영
    final oldBalance = _tokens.balance;
    _tokens = ConversationTokens(
      balance: oldBalance + tokensToAdd,
      lastDailyReward: _tokens.lastDailyReward,
      lifetimeEarned: _tokens.lifetimeEarned + tokensToAdd,
      lifetimeSpent: _tokens.lifetimeSpent,
      currentStreak: _tokens.currentStreak,
    );
    notifyListeners();
    debugPrint('✨ Optimistic UI: +$tokensToAdd token (${oldBalance} → ${_tokens.balance})');

    // 2️⃣ 서버 동기화 (백그라운드)
    _syncTokensToServerAsync(tokensToAdd);

    return true;
  }

  /// 서버와 토큰 동기화 (백그라운드)
  void _syncTokensToServerAsync(int tokensToAdd) {
    Future.microtask(() async {
      try {
        debugPrint('📞 [Background] Syncing tokens to server...');

        final callable = _functions.httpsCallable('earnRewardAdTokens');
        final result = await callable.call<Map<String, dynamic>>({
          'isPremium': false,
        });

        final data = result.data;
        final serverBalance = data['newBalance'] as int;

        debugPrint('✅ [Background] Server sync complete (Server balance: $serverBalance)');

        // Firestore 리스너가 서버 값으로 자동 조정
      } catch (e) {
        debugPrint('⚠️ [Background] Server sync failed: $e');
        // 실패해도 로컬 값 유지 (다음 앱 재시작 시 서버 값으로 조정됨)
      }
    });
  }

  /// AI 대화 시작 가능 여부 (토큰 확인) - 레거시
  Future<bool> canStartConversation() async {
    if (_tokens.balance < ConversationTokenSystem.conversationCost) {
      debugPrint('❌ Not enough tokens for conversation');
      return false;
    }
    debugPrint('✅ Tokens available for conversation');
    return true;
  }

  /// 토큰 부족 여부 - 레거시
  bool get hasEnoughTokens =>
      _tokens.balance >= ConversationTokenSystem.conversationCost;

  // ========== 티어 기반 메서드 ==========

  /// 빠른 상담 가능 여부
  bool get hasEnoughTokensForQuick =>
      _tokens.balance >= ConversationTokenSystem.quickChatCost;

  /// 깊은 상담 가능 여부
  bool get hasEnoughTokensForDeep =>
      _tokens.balance >= ConversationTokenSystem.deepChatCost;

  /// 특정 티어로 대화 시작 가능 여부
  bool canStartChatWithTier(ConversationTier tier) {
    return _tokens.canStartChat(tier);
  }

  /// AI 대화 요청 (서버 호출 - 토큰 차감 포함)
  Future<Map<String, dynamic>> requestAIConversation({
    required List<Map<String, String>> messages,
    String? conversationId,
    String? model,
  }) async {
    try {
      debugPrint('📞 Calling requestAIConversation Cloud Function...');

      final callable = _functions.httpsCallable('requestAIConversation');
      final result = await callable.call<Map<String, dynamic>>({
        'messages': messages,
        'conversationId': conversationId,
        'model': model,
      });

      final data = result.data;
      final response = data['response'] as String;
      final newConversationId = data['conversationId'] as String;
      final tokensRemaining = data['tokensRemaining'] as int;

      debugPrint('✅ AI conversation success: $tokensRemaining tokens remaining');

      return {
        'response': response,
        'conversationId': newConversationId,
        'tokensRemaining': tokensRemaining,
      };
    } catch (e) {
      debugPrint('❌ AI conversation failed: $e');
      rethrow;
    }
  }

  /// 체크리스트 완료 보상 (서버 호출)
  Future<void> completeChecklist({
    required int week,
    required int day,
    required int xpEarned,
  }) async {
    try {
      debugPrint('📞 Calling completeChecklist Cloud Function...');

      final callable = _functions.httpsCallable('completeChecklist');
      final result = await callable.call<Map<String, dynamic>>({
        'week': week,
        'day': day,
        'xpEarned': xpEarned,
      });

      final data = result.data;
      final tokensEarned = data['tokensEarned'] as int;
      final newBalance = data['newBalance'] as int;

      debugPrint('✅ Checklist completed: +$tokensEarned tokens (Balance: $newBalance)');

      // Firestore 리스너가 자동으로 상태 업데이트
    } catch (e) {
      debugPrint('❌ Failed to complete checklist: $e');
      rethrow;
    }
  }

  /// 토큰 잔액 확인
  int get balance => _tokens.balance;

  /// 일일 보상 받을 수 있는지 (getter)
  bool get canClaimDailyReward => _tokens.canClaimDailyReward();

  /// 다음 일일 보상까지 남은 시간 (getter)
  Duration get timeUntilNextReward => getTimeUntilNextDailyReward();

  // ========== 스테이지 기반 메서드 (NEW) ==========

  /// 스테이지 정보 가져오기
  StageInfo getStageInfo(int totalXP, {required bool isPremium}) {
    final effectiveStage = StageUnlockService.getEffectiveStage(
      totalXP,
      isPremium: isPremium,
    );
    return StageUnlockService.getStageInfo(effectiveStage);
  }

  /// 스테이지 기반 일일 토큰 수
  int getDailyTokensForXP(int totalXP, {required bool isPremium}) {
    return ConversationTokenSystem.getDailyTokensFromXP(
      totalXP,
      isPremium: isPremium,
    );
  }

  /// 스테이지 기반 최대 토큰 수
  int getMaxTokensForXP(int totalXP, {required bool isPremium}) {
    final effectiveStage = StageUnlockService.getEffectiveStage(
      totalXP,
      isPremium: isPremium,
    );
    return ConversationTokenSystem.getMaxTokensForStage(effectiveStage);
  }

  /// 스테이지 기반 일일 보상 받기 (서버 호출)
  ///
  /// [totalXP]: 현재 총 경험치
  /// [isPremium]: 프리미엄 구독 여부
  Future<void> claimDailyRewardWithStage({
    required int totalXP,
    required bool isPremium,
  }) async {
    try {
      final effectiveStage = StageUnlockService.getEffectiveStage(
        totalXP,
        isPremium: isPremium,
      );
      final dailyTokens = StageUnlockService.getDailyTokensForStage(effectiveStage);

      debugPrint('📞 Calling claimDailyReward with Stage $effectiveStage ($dailyTokens tokens)...');

      final callable = _functions.httpsCallable('claimDailyReward');
      final result = await callable.call<Map<String, dynamic>>({
        'isPremium': isPremium,
        'stage': effectiveStage, // 서버에 스테이지 전달
        'totalXP': totalXP,
      });

      final data = result.data;
      final tokensEarned = data['tokensEarned'] as int;
      final newBalance = data['newBalance'] as int;
      final currentStreak = data['currentStreak'] as int;

      debugPrint('✅ Stage-based daily reward: +$tokensEarned tokens (Stage $effectiveStage, Balance: $newBalance, Streak: $currentStreak)');
    } catch (e) {
      debugPrint('❌ Failed to claim stage-based daily reward: $e');
      rethrow;
    }
  }

  /// 현재 스테이지 정보 요약
  Map<String, dynamic> getStageTokenInfo(int totalXP, {required bool isPremium}) {
    final effectiveStage = StageUnlockService.getEffectiveStage(
      totalXP,
      isPremium: isPremium,
    );
    final stageInfo = StageUnlockService.getStageInfo(effectiveStage);
    final rawStage = StageUnlockService.getStageFromXP(totalXP);

    return {
      'effectiveStage': effectiveStage,
      'rawStage': rawStage,
      'stageName': stageInfo.name,
      'stageNameKo': stageInfo.nameKo,
      'stageEmoji': stageInfo.emoji,
      'dailyTokens': stageInfo.dailyTokens,
      'maxTokens': ConversationTokenSystem.getMaxTokensForStage(effectiveStage),
      'isPremiumRequired': stageInfo.requiresPremium,
      'stageProgress': StageUnlockService.getStageProgress(totalXP),
      'xpToNextStage': StageUnlockService.getXPToNextStage(totalXP),
      'daysToNextStage': StageUnlockService.getDaysToNextStage(totalXP),
    };
  }

  /// 다음 일일 보상까지 남은 시간
  Duration getTimeUntilNextDailyReward() {
    final now = DateTime.now();
    final lastReward = _tokens.lastDailyReward;

    // 다음 날 0시
    final nextReward = DateTime(
      lastReward.year,
      lastReward.month,
      lastReward.day + 1,
      0,
      0,
      0,
    );

    final remaining = nextReward.difference(now);
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// 토큰 통계
  Map<String, int> get stats => {
        'balance': _tokens.balance,
        'lifetimeEarned': _tokens.lifetimeEarned,
        'lifetimeSpent': _tokens.lifetimeSpent,
      };

  /// 튜토리얼 완료로 토큰 획득
  ///
  /// 튜토리얼 완료 시 1회만 호출됩니다.
  /// 기본 보상: +1 토큰
  Future<bool> earnFromTutorialCompletion({int amount = 1}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('❌ Tutorial reward failed: User not authenticated');
        return false;
      }

      debugPrint('🎓 Awarding tutorial completion reward: +$amount token...');

      final tokenRef = _firestore.collection('conversationTokens').doc(user.uid);
      await tokenRef.update({
        'balance': FieldValue.increment(amount),
        'totalEarned': FieldValue.increment(amount),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Tutorial completion reward: +$amount token');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to award tutorial reward: $e');
      return false;
    }
  }

  /// 테스트용: 토큰 추가 (서버 호출)
  Future<void> addTokensForTesting(int amount) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('인증이 필요합니다');
      }

      debugPrint('🧪 Adding $amount tokens for testing...');

      final tokenRef = _firestore.collection('conversationTokens').doc(user.uid);
      await tokenRef.update({
        'balance': FieldValue.increment(amount),
        'totalEarned': FieldValue.increment(amount),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Added $amount tokens for testing');
    } catch (e) {
      debugPrint('❌ Failed to add test tokens: $e');
      rethrow;
    }
  }

  /// 테스트용: 토큰 초기화 (서버 호출)
  Future<void> resetTokensForTesting() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('인증이 필요합니다');
      }

      debugPrint('🧪 Resetting tokens for testing...');

      final tokenRef = _firestore.collection('conversationTokens').doc(user.uid);
      await tokenRef.set({
        'userId': user.uid,
        'balance': 0,
        'totalEarned': 0,
        'totalSpent': 0,
        'currentStreak': 0,
        'lastClaimDate': null,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Tokens reset for testing');
    } catch (e) {
      debugPrint('❌ Failed to reset test tokens: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _tokenSubscription?.cancel();
    super.dispose();
  }
}
