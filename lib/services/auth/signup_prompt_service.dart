import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 회원가입 유도 서비스
///
/// 비회원 사용자에게 회원가입을 유도하되, 한 번만 표시합니다.
/// 너무 강압적이지 않고 자연스러운 유도를 위한 서비스입니다.
class SignupPromptService {
  static final SignupPromptService _instance = SignupPromptService._internal();
  factory SignupPromptService() => _instance;
  SignupPromptService._internal();

  static const String _promptShownKey = 'signup_prompt_shown';
  static const String _promptDismissedAtKey = 'signup_prompt_dismissed_at';

  /// 회원가입 유도를 표시해야 하는지 확인
  ///
  /// 반환값:
  /// - true: 유도 표시 가능 (아직 안 보여줬거나, 오래 전에 거부함)
  /// - false: 유도 표시 불가 (이미 보여줬음)
  Future<bool> shouldShowPrompt() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 이미 유도를 보여줬는지 확인
      final hasShown = prefs.getBool(_promptShownKey) ?? false;

      if (!hasShown) {
        debugPrint('✅ 회원가입 유도 가능 - 아직 한 번도 안 보여줌');
        return true;
      }

      debugPrint('ℹ️ 회원가입 유도 불가 - 이미 보여줌');
      return false;

    } catch (e) {
      debugPrint('❌ 회원가입 유도 확인 오류: $e');
      return false;
    }
  }

  /// 회원가입 유도를 표시했음을 기록
  Future<void> markPromptShown() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool(_promptShownKey, true);
      await prefs.setString(
        _promptDismissedAtKey,
        DateTime.now().toIso8601String(),
      );

      debugPrint('✅ 회원가입 유도 표시 기록 완료');
    } catch (e) {
      debugPrint('❌ 회원가입 유도 기록 오류: $e');
    }
  }

  /// 회원가입 유도 표시 기록 초기화 (테스트용)
  Future<void> resetPrompt() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(_promptShownKey);
      await prefs.remove(_promptDismissedAtKey);

      debugPrint('✅ 회원가입 유도 기록 초기화 완료');
    } catch (e) {
      debugPrint('❌ 회원가입 유도 초기화 오류: $e');
    }
  }

  /// 회원가입 유도를 마지막으로 거부한 날짜
  Future<DateTime?> getLastDismissedAt() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateStr = prefs.getString(_promptDismissedAtKey);

      if (dateStr == null) return null;

      return DateTime.parse(dateStr);
    } catch (e) {
      debugPrint('❌ 마지막 거부 날짜 조회 오류: $e');
      return null;
    }
  }

  /// 회원가입 유도 적절한 타이밍 확인
  ///
  /// 추천 타이밍:
  /// - 앱 사용 3일차 (충분한 경험 후)
  /// - Week 3 시작 전
  /// - 운동 10회 완료 후
  Future<SignupPromptTiming> getRecommendedTiming() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 앱 첫 사용 날짜
      final firstUseDateStr = prefs.getString('first_use_date');
      if (firstUseDateStr == null) {
        // 첫 사용 날짜 기록
        await prefs.setString('first_use_date', DateTime.now().toIso8601String());
        return SignupPromptTiming.notYet;
      }

      final firstUseDate = DateTime.parse(firstUseDateStr);
      final daysSinceFirstUse = DateTime.now().difference(firstUseDate).inDays;

      // 운동 완료 횟수
      final workoutCount = prefs.getInt('completed_workout_count') ?? 0;

      // 타이밍 판단
      if (daysSinceFirstUse >= 3 && workoutCount >= 5) {
        debugPrint('✅ 회원가입 유도 최적 타이밍 ($daysSinceFirstUse일 사용, $workoutCount회 운동)');
        return SignupPromptTiming.optimal;
      } else if (daysSinceFirstUse >= 1 && workoutCount >= 10) {
        debugPrint('✅ 회원가입 유도 좋은 타이밍 (열심히 사용 중)');
        return SignupPromptTiming.good;
      } else {
        debugPrint('ℹ️ 회원가입 유도 아직 이름 (더 사용 후 제안)');
        return SignupPromptTiming.notYet;
      }

    } catch (e) {
      debugPrint('❌ 회원가입 유도 타이밍 확인 오류: $e');
      return SignupPromptTiming.notYet;
    }
  }
}

/// 회원가입 유도 타이밍
enum SignupPromptTiming {
  notYet, // 아직 아님 (더 사용 후)
  good, // 좋은 타이밍
  optimal, // 최적 타이밍
}
