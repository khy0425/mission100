import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/conversation_token.dart';

/// 대화 토큰 관리 서비스
class ConversationTokenService extends ChangeNotifier {
  static final ConversationTokenService _instance =
      ConversationTokenService._internal();
  factory ConversationTokenService() => _instance;
  ConversationTokenService._internal();

  static const String _storageKey = 'conversation_tokens';

  ConversationTokens _tokens = ConversationTokens.initial();
  bool _isInitialized = false;

  /// 현재 토큰 상태
  ConversationTokens get tokens => _tokens;

  /// 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _loadTokens();
    _isInitialized = true;
    notifyListeners();
  }

  /// 토큰 로드
  Future<void> _loadTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokensJson = prefs.getString(_storageKey);

      if (tokensJson != null) {
        final tokensMap = json.decode(tokensJson) as Map<String, dynamic>;
        _tokens = ConversationTokens.fromJson(tokensMap);
        debugPrint('✅ Loaded conversation tokens: ${_tokens.balance}');
      } else {
        _tokens = ConversationTokens.initial();
        debugPrint('✅ Initialized new conversation tokens');
      }
    } catch (e) {
      debugPrint('❌ Failed to load conversation tokens: $e');
      _tokens = ConversationTokens.initial();
    }
  }

  /// 토큰 저장
  Future<void> _saveTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokensJson = json.encode(_tokens.toJson());
      await prefs.setString(_storageKey, tokensJson);
      debugPrint('✅ Saved conversation tokens: ${_tokens.balance}');
    } catch (e) {
      debugPrint('❌ Failed to save conversation tokens: $e');
    }
  }

  /// 일일 보상 받기
  Future<void> claimDailyReward({required bool isPremium}) async {
    if (!canClaimDailyReward) {
      throw Exception('일일 보상은 하루에 한 번만 받을 수 있습니다.');
    }

    _tokens = _tokens.claimDailyReward(isPremium: isPremium);
    await _saveTokens();
    notifyListeners();

    final tokensEarned = isPremium
        ? ConversationTokenSystem.premiumUserDailyTokens
        : ConversationTokenSystem.freeUserDailyTokens;
    debugPrint('✅ Claimed daily reward: +$tokensEarned tokens');
  }

  /// 리워드 광고로 토큰 획득
  Future<void> earnFromRewardAd({required bool isPremium}) async {
    _tokens = _tokens.earnFromAd(isPremium: isPremium);
    await _saveTokens();
    notifyListeners();

    debugPrint(
        '✅ Earned tokens from ad: +${ConversationTokenSystem.rewardAdTokens} token');
  }

  /// 대화 시작 (토큰 소모)
  Future<bool> startConversation() async {
    final newTokens = _tokens.startConversation();

    if (newTokens == null) {
      debugPrint('❌ Not enough tokens to start conversation');
      return false;
    }

    _tokens = newTokens;
    await _saveTokens();
    notifyListeners();

    debugPrint('✅ Started conversation: -1 token (${_tokens.balance} remaining)');
    return true;
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

  /// 테스트용: 토큰 추가
  Future<void> addTokensForTesting(int amount) async {
    _tokens = ConversationTokens(
      balance: (_tokens.balance + amount).clamp(0, 999),
      lastDailyReward: _tokens.lastDailyReward,
      lifetimeEarned: _tokens.lifetimeEarned + amount,
      lifetimeSpent: _tokens.lifetimeSpent,
    );
    await _saveTokens();
    notifyListeners();
  }

  /// 테스트용: 토큰 초기화
  Future<void> resetTokensForTesting() async {
    _tokens = ConversationTokens.initial();
    await _saveTokens();
    notifyListeners();
  }
}
