import 'package:shared_preferences/shared_preferences.dart';

/// 🚀 첫 실행 관리 서비스
///
/// 앱의 첫 실행 여부를 체크하고 관리하는 서비스
class FirstLaunchService {
  static const String _keyFirstLaunch = 'is_first_launch';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyTutorialCompleted = 'tutorial_completed';

  /// 앱이 첫 실행인지 확인
  ///
  /// Returns: true if first launch, false otherwise
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFirstLaunch) ?? true;
  }

  /// 첫 실행 플래그 설정
  static Future<void> setFirstLaunchCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFirstLaunch, false);
  }

  /// 온보딩 완료 여부 확인
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  /// 온보딩 완료 설정
  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, true);
  }

  /// 튜토리얼 완료 여부 확인
  static Future<bool> isTutorialCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTutorialCompleted) ?? false;
  }

  /// 튜토리얼 완료 설정
  static Future<void> setTutorialCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTutorialCompleted, true);
  }

  /// 모든 설정 초기화 (개발/테스트용)
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFirstLaunch);
    await prefs.remove(_keyOnboardingCompleted);
    await prefs.remove(_keyTutorialCompleted);
  }
}
