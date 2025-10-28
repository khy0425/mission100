import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_goals.dart';

/// 사용자 목표 설정 관리 서비스
class UserGoalsService {
  static const String _prefsKey = 'user_goals';

  // 싱글톤 인스턴스
  static UserGoalsService? _instance;
  static UserGoalsService get instance {
    _instance ??= UserGoalsService._();
    return _instance!;
  }

  UserGoalsService._();

  // 캐시된 목표
  UserGoals? _cachedGoals;

  /// 사용자 목표 로드
  Future<UserGoals> loadGoals() async {
    // 캐시가 있으면 반환
    if (_cachedGoals != null) {
      return _cachedGoals!;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_prefsKey);

      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        _cachedGoals = UserGoals.fromJson(json);
        return _cachedGoals!;
      }
    } catch (e) {
      _log('⚠️ 목표 로드 실패: $e');
    }

    // 기본값 반환
    _cachedGoals = UserGoals.defaultGoals;
    return _cachedGoals!;
  }

  /// 사용자 목표 저장
  Future<bool> saveGoals(UserGoals goals) async {
    // 유효성 검증
    if (!goals.isValid) {
      _log('⚠️ 유효하지 않은 목표: $goals');
      return false;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(goals.toJson());
      final success = await prefs.setString(_prefsKey, jsonString);

      if (success) {
        _cachedGoals = goals;
        _log('✅ 목표 저장 성공: $goals');
        return true;
      }
    } catch (e) {
      _log('⚠️ 목표 저장 실패: $e');
    }

    return false;
  }

  /// 목표 초기화 (기본값으로)
  Future<bool> resetGoals() async {
    return await saveGoals(UserGoals.defaultGoals);
  }

  /// 주간 목표만 업데이트
  Future<bool> updateWeeklyGoal(int value) async {
    final current = await loadGoals();
    return await saveGoals(current.copyWith(weeklyGoal: value));
  }

  /// 월간 목표만 업데이트
  Future<bool> updateMonthlyGoal(int value) async {
    final current = await loadGoals();
    return await saveGoals(current.copyWith(monthlyGoal: value));
  }

  /// 연속 목표만 업데이트
  Future<bool> updateStreakTarget(int value) async {
    final current = await loadGoals();
    return await saveGoals(current.copyWith(streakTarget: value));
  }

  /// 캐시 초기화
  void clearCache() {
    _cachedGoals = null;
  }

  /// 디버그용 - 현재 목표 출력
  Future<void> printCurrentGoals() async {
    final goals = await loadGoals();
    _log('📊 현재 목표: $goals');
  }

  /// 내부 로그 함수
  void _log(String message) {
    // ignore: avoid_print
    print(message);
  }
}
