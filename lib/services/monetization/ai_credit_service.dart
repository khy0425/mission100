import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../security/rate_limit_service.dart';
import '../../models/rate_limit.dart';

/// AI 분석 크레딧 관리 서비스
///
/// 무료 사용자용 크레딧 시스템
/// - 광고 시청으로 크레딧 획득
/// - 프리미엄 사용자는 무제한
class AIcreditService {
  static const String _keyCredits = 'ai_analysis_credits';
  static const String _keyLastResetDate = 'ai_credits_last_reset';
  static const String _keyTotalAdsWatched = 'total_ads_watched';

  /// 광고 1회 시청 당 크레딧
  static const int creditsPerAd = 1;

  /// 무료 사용자 기본 제공 크레딧 (주간)
  static const int weeklyFreeCredits = 3;

  /// 7일 완료 보너스 크레딧 (현재 미사용 - 레벨업과 중복)
  static const int weeklyCompletionBonus = 0;

  /// 레벨업 보너스 크레딧
  static const int levelUpBonus = 1;

  /// 최대 누적 크레딧
  static const int maxCredits = 30;

  /// 현재 크레딧 수 가져오기
  static Future<int> getCredits() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 주간 리셋 체크
      await _checkWeeklyReset();

      return prefs.getInt(_keyCredits) ?? weeklyFreeCredits;
    } catch (e) {
      debugPrint('❌ Error getting AI credits: $e');
      return 0;
    }
  }

  /// 크레딧 사용 (AI 분석 요청 시)
  static Future<bool> useCredit() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCredits = await getCredits();

      if (currentCredits <= 0) {
        debugPrint('⚠️ No AI credits available');
        return false;
      }

      await prefs.setInt(_keyCredits, currentCredits - 1);
      debugPrint('💳 AI credit used. Remaining: ${currentCredits - 1}');
      return true;
    } catch (e) {
      debugPrint('❌ Error using AI credit: $e');
      return false;
    }
  }

  /// Rate Limiting과 함께 크레딧 체크 및 사용
  ///
  /// Returns: { 'allowed': bool, 'reason': String? }
  static Future<Map<String, dynamic>> checkRateLimitAndUseCredit({
    bool isPremium = false,
  }) async {
    try {
      // 1. Rate Limiting 체크
      final rateLimitResult = await RateLimitService.checkRateLimit(
        action: 'ai_message',
        isPremium: isPremium,
      );

      if (!rateLimitResult.allowed) {
        debugPrint('🚫 Rate limit exceeded: ${rateLimitResult.reason}');
        return {
          'allowed': false,
          'reason': rateLimitResult.reason ?? '요청 제한을 초과했습니다.',
          'isSuspicious': rateLimitResult.isSuspicious,
        };
      }

      // 2. 크레딧 체크 및 사용
      final prefs = await SharedPreferences.getInstance();
      final currentCredits = await getCredits();

      if (currentCredits <= 0) {
        debugPrint('⚠️ No AI credits available');
        return {
          'allowed': false,
          'reason': 'AI 크레딧이 부족합니다.\n광고 시청으로 크레딧을 얻으세요.',
        };
      }

      await prefs.setInt(_keyCredits, currentCredits - 1);
      debugPrint('💳 AI credit used. Remaining: ${currentCredits - 1}');

      return {
        'allowed': true,
        'remainingCredits': currentCredits - 1,
      };
    } catch (e) {
      debugPrint('❌ Error in checkRateLimitAndUseCredit: $e');
      return {
        'allowed': false,
        'reason': '오류가 발생했습니다.',
      };
    }
  }

  /// 광고 시청으로 크레딧 획득
  static Future<void> earnCreditsFromAd() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCredits = await getCredits();
      final totalAdsWatched = prefs.getInt(_keyTotalAdsWatched) ?? 0;

      // 최대 크레딧 제한
      if (currentCredits >= maxCredits) {
        debugPrint('⚠️ Maximum AI credits reached ($maxCredits)');
        await prefs.setInt(_keyTotalAdsWatched, totalAdsWatched + 1);
        return;
      }

      final newCredits = (currentCredits + creditsPerAd).clamp(0, maxCredits);
      await prefs.setInt(_keyCredits, newCredits);
      await prefs.setInt(_keyTotalAdsWatched, totalAdsWatched + 1);

      debugPrint('🎁 Earned $creditsPerAd AI credit(s). Total: $newCredits');
    } catch (e) {
      debugPrint('❌ Error earning AI credits: $e');
    }
  }

  /// 주간 리셋 체크 (매주 월요일 자정 무료 크레딧 3개 제공)
  static Future<void> _checkWeeklyReset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      final lastResetStr = prefs.getString(_keyLastResetDate);

      if (lastResetStr == null) {
        // 첫 실행 - 무료 크레딧 제공
        await prefs.setString(_keyLastResetDate, now.toIso8601String());
        await prefs.setInt(_keyCredits, weeklyFreeCredits);
        debugPrint('🎁 First launch: Granted $weeklyFreeCredits AI credits');
        return;
      }

      final lastReset = DateTime.parse(lastResetStr);
      final daysSinceReset = now.difference(lastReset).inDays;

      // 7일마다 리셋 (매주 월요일)
      if (daysSinceReset >= 7) {
        final currentCredits = prefs.getInt(_keyCredits) ?? 0;
        final newCredits = (currentCredits + weeklyFreeCredits).clamp(0, maxCredits);

        await prefs.setInt(_keyCredits, newCredits);
        await prefs.setString(_keyLastResetDate, now.toIso8601String());

        debugPrint('🔄 Weekly reset: Added $weeklyFreeCredits AI credits. Total: $newCredits');
      }
    } catch (e) {
      debugPrint('❌ Error in weekly reset: $e');
    }
  }

  /// 레벨업 보너스 크레딧 지급
  static Future<void> earnLevelUpBonus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCredits = await getCredits();
      final newCredits = (currentCredits + levelUpBonus).clamp(0, maxCredits);

      await prefs.setInt(_keyCredits, newCredits);
      debugPrint('🎉 Level up bonus: +$levelUpBonus credit. Total: $newCredits');
    } catch (e) {
      debugPrint('❌ Error earning level up bonus: $e');
    }
  }

  /// 주간 완료 보너스 크레딧 지급
  static Future<void> earnWeeklyCompletionBonus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCredits = await getCredits();
      final newCredits = (currentCredits + weeklyCompletionBonus).clamp(0, maxCredits);

      await prefs.setInt(_keyCredits, newCredits);
      debugPrint('🌟 Weekly completion bonus: +$weeklyCompletionBonus credit. Total: $newCredits');
    } catch (e) {
      debugPrint('❌ Error earning weekly completion bonus: $e');
    }
  }

  /// 크레딧 직접 설정 (테스트/디버그용)
  static Future<void> setCredits(int amount) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyCredits, amount.clamp(0, maxCredits));
      debugPrint('💳 AI credits set to: $amount');
    } catch (e) {
      debugPrint('❌ Error setting AI credits: $e');
    }
  }

  /// 총 시청한 광고 수 가져오기
  static Future<int> getTotalAdsWatched() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_keyTotalAdsWatched) ?? 0;
    } catch (e) {
      debugPrint('❌ Error getting total ads watched: $e');
      return 0;
    }
  }

  /// 다음 주간 리셋까지 남은 일수 (0-6일)
  static Future<int> getDaysUntilReset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastResetStr = prefs.getString(_keyLastResetDate);

      if (lastResetStr == null) {
        return 7; // 첫 실행 - 7일로 표시
      }

      final lastReset = DateTime.parse(lastResetStr);
      final now = DateTime.now();
      final daysSinceReset = now.difference(lastReset).inDays;

      // 7일 주기에서 남은 일수 계산
      return (7 - daysSinceReset).clamp(0, 7);
    } catch (e) {
      debugPrint('❌ Error getting days until reset: $e');
      return 7;
    }
  }

  /// 크레딧 통계 가져오기
  static Future<Map<String, dynamic>> getStats() async {
    return {
      'credits': await getCredits(),
      'maxCredits': maxCredits,
      'totalAdsWatched': await getTotalAdsWatched(),
      'daysUntilReset': await getDaysUntilReset(),
      'weeklyFreeCredits': weeklyFreeCredits,
    };
  }

  /// 리셋 (테스트/디버그용)
  static Future<void> reset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyCredits);
      await prefs.remove(_keyLastResetDate);
      await prefs.remove(_keyTotalAdsWatched);
      debugPrint('🔄 AI credits reset');
    } catch (e) {
      debugPrint('❌ Error resetting AI credits: $e');
    }
  }
}
