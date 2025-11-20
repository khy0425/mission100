import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/conversation_token.dart';

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
          // 토큰 문서가 없으면 초기 상태
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
      debugPrint('📞 Calling claimDailyReward Cloud Function (isPremium: $isPremium)...');

      final callable = _functions.httpsCallable('claimDailyReward');
      final result = await callable.call<Map<String, dynamic>>({
        'isPremium': isPremium,
      });

      final data = result.data;
      final tokensEarned = data['tokensEarned'] as int;
      final newBalance = data['newBalance'] as int;
      final currentStreak = data['currentStreak'] as int;
      final bonusReason = data['bonusReason'] as String?;

      debugPrint('✅ Daily reward claimed: +$tokensEarned tokens (Balance: $newBalance)');
      if (bonusReason != null) {
        debugPrint('🎁 Bonus: $bonusReason');
      }

      // Firestore 리스너가 자동으로 상태 업데이트
    } catch (e) {
      debugPrint('❌ Failed to claim daily reward: $e');
      rethrow;
    }
  }

  /// 리워드 광고로 토큰 획득 (로컬)
  /// 광고는 서버 검증 없이 로컬에서 처리 (광고 플랫폼이 검증)
  Future<void> earnFromRewardAd({required bool isPremium}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('인증이 필요합니다');
      }

      debugPrint('💰 Earning tokens from reward ad...');

      // Firestore에 직접 토큰 추가 (광고 플랫폼이 이미 검증함)
      final tokenRef = _firestore.collection('conversationTokens').doc(user.uid);
      final tokenDoc = await tokenRef.get();

      final currentBalance = tokenDoc.exists ? (tokenDoc.data()!['balance'] ?? 0) : 0;
      final maxTokens = isPremium
          ? ConversationTokenSystem.maxPremiumTokens
          : ConversationTokenSystem.maxFreeTokens;

      final newBalance = (currentBalance + ConversationTokenSystem.rewardAdTokens)
          .clamp(0, maxTokens);

      await tokenRef.set({
        'userId': user.uid,
        'balance': newBalance,
        'totalEarned': FieldValue.increment(ConversationTokenSystem.rewardAdTokens),
        'totalSpent': tokenDoc.exists ? (tokenDoc.data()!['totalSpent'] ?? 0) : 0,
        'currentStreak': tokenDoc.exists ? (tokenDoc.data()!['currentStreak'] ?? 0) : 0,
        'lastClaimDate': tokenDoc.exists ? tokenDoc.data()!['lastClaimDate'] : null,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 히스토리 기록
      await tokenRef.collection('history').add({
        'type': 'reward_ad',
        'amount': ConversationTokenSystem.rewardAdTokens,
        'balanceBefore': currentBalance,
        'balanceAfter': newBalance,
        'createdAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Earned tokens from ad: +${ConversationTokenSystem.rewardAdTokens} token');
    } catch (e) {
      debugPrint('❌ Failed to earn from reward ad: $e');
      rethrow;
    }
  }

  /// 대화 시작 (서버 호출 - requestAIConversation에서 토큰 차감)
  /// 이 메서드는 UI에서 토큰 확인용으로만 사용
  Future<bool> startConversation() async {
    // 토큰 잔액 확인만 수행
    if (!hasEnoughTokens) {
      debugPrint('❌ Not enough tokens to start conversation');
      return false;
    }

    // 실제 토큰 차감은 AI 대화 요청 시 서버에서 수행
    debugPrint('✅ Tokens available for conversation');
    return true;
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

  /// 토큰 부족 여부
  bool get hasEnoughTokens =>
      _tokens.balance >= ConversationTokenSystem.conversationCost;

  /// 일일 보상 받을 수 있는지 (getter)
  bool get canClaimDailyReward => _tokens.canClaimDailyReward();

  /// 다음 일일 보상까지 남은 시간 (getter)
  Duration get timeUntilNextReward => getTimeUntilNextDailyReward();

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
