import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/app_config.dart';
import 'common/config_manager.dart';
import 'ads/core_ad_service.dart';

/// 앱 팩토리 - 설정에 따라 앱을 초기화하는 핵심 클래스
class AppFactory {
  static AppFactory? _instance;
  static AppFactory get instance => _instance ??= AppFactory._();
  AppFactory._();

  bool _isInitialized = false;
  AppConfig? _currentConfig;

  AppConfig get currentConfig => _currentConfig ?? AppConfig.defaultMission100;

  /// 앱 팩토리 초기화
  Future<void> initialize({String? configPath}) async {
    if (_isInitialized) return;

    debugPrint('🏭 AppFactory 초기화 시작...');

    // 1. 설정 관리자 초기화
    await ConfigManager.instance.initialize(
      configPath: configPath ?? 'assets/config/app_config.json'
    );
    _currentConfig = ConfigManager.instance.currentConfig;
    debugPrint('✅ 설정 로드 완료: ${_currentConfig!.appInfo.name}');

    // 2. 화면 방향 설정
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    debugPrint('✅ 화면 방향 설정 완료');

    // 3. 광고 서비스 초기화
    if (_currentConfig!.adConfig.enableBannerAds || 
        _currentConfig!.adConfig.enableInterstitialAds || 
        _currentConfig!.adConfig.enableRewardedAds) {
      await CoreAdService().initialize(_currentConfig!.adConfig);
      debugPrint('✅ 광고 서비스 초기화 완료');
    }

    _isInitialized = true;
    debugPrint('🏭 AppFactory 초기화 완료!');
  }

  /// 테마 데이터 생성
  ThemeData createTheme() {
    final themeConfig = _currentConfig!.themeConfig;
    
    return ThemeData(
      primarySwatch: _createMaterialColor(themeConfig.primaryColor),
      primaryColor: themeConfig.primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeConfig.primaryColor,
        secondary: themeConfig.secondaryColor,
        brightness: themeConfig.isDarkMode ? Brightness.dark : Brightness.light,
      ),
      fontFamily: themeConfig.fontFamily,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: themeConfig.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeConfig.primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: themeConfig.accentColor,
      ),
    );
  }

  /// MaterialColor 생성 헬퍼
  MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  /// 앱 타이틀 생성
  String getAppTitle() {
    return _currentConfig?.appInfo.name ?? 'Mission 100';
  }

  /// 패키지 이름 가져오기
  String getPackageName() {
    return _currentConfig?.appInfo.packageName ?? 'com.example.mission100';
  }

  /// 버전 정보 가져오기
  String getVersion() {
    return _currentConfig?.appInfo.version ?? '1.0.0';
  }

  /// 기능 플래그 확인
  bool isFeatureEnabled(String feature) {
    final features = _currentConfig?.featureFlags;
    if (features == null) return false;

    switch (feature) {
      case 'timer':
        return features.timerEnabled;
      case 'habit_tracking':
        return features.habitTrackingEnabled;
      case 'statistics':
        return features.statisticsEnabled;
      case 'achievements':
        return features.achievementsEnabled;
      case 'social_sharing':
        return features.socialSharingEnabled;
      case 'backup':
        return features.backupEnabled;
      case 'notifications':
        return features.notificationsEnabled;
      default:
        return false;
    }
  }

  /// 설정 업데이트
  Future<void> updateConfig(AppConfig newConfig) async {
    await ConfigManager.instance.updateConfig(newConfig);
    _currentConfig = newConfig;
    
    // 광고 서비스 재초기화
    if (newConfig.adConfig.enableBannerAds || 
        newConfig.adConfig.enableInterstitialAds || 
        newConfig.adConfig.enableRewardedAds) {
      await CoreAdService().initialize(newConfig.adConfig);
    }
  }

  /// 새로운 앱 설정으로 전환
  Future<void> switchToApp(String configPath) async {
    _isInitialized = false;
    await initialize(configPath: configPath);
  }
}
