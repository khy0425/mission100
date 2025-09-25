import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../../config/app_config.dart';

/// 앱 설정 관리자
class ConfigManager {
  static ConfigManager? _instance;
  static ConfigManager get instance => _instance ??= ConfigManager._();
  ConfigManager._();

  AppConfig? _currentConfig;
  AppConfig get currentConfig => _currentConfig ?? AppConfig.defaultMission100;

  /// 설정 초기화 - assets에서 설정 파일을 로드하거나 기본값 사용
  Future<void> initialize({String configPath = 'assets/config/app_config.json'}) async {
    try {
      // assets에서 설정 파일 로드 시도
      final configString = await rootBundle.loadString(configPath);
      final configJson = jsonDecode(configString) as Map<String, dynamic>;
      _currentConfig = AppConfig.fromJson(configJson);
      print('설정 파일 로드 완료: $configPath');
    } catch (e) {
      // 설정 파일이 없으면 기본 설정 사용
      print('설정 파일 로드 실패, 기본 설정 사용: $e');
      _currentConfig = AppConfig.defaultMission100;
      
      // 기본 설정을 파일로 저장
      await _saveConfigToFile();
    }
  }

  /// 런타임에 설정 변경
  Future<void> updateConfig(AppConfig newConfig) async {
    _currentConfig = newConfig;
    await _saveConfigToFile();
  }

  /// 특정 기능 플래그 업데이트
  Future<void> updateFeatureFlag({
    bool? timerEnabled,
    bool? habitTrackingEnabled,
    bool? statisticsEnabled,
    bool? achievementsEnabled,
    bool? socialSharingEnabled,
    bool? backupEnabled,
    bool? notificationsEnabled,
  }) async {
    final currentFeatures = currentConfig.featureFlags;
    final newFeatures = FeatureFlags(
      timerEnabled: timerEnabled ?? currentFeatures.timerEnabled,
      habitTrackingEnabled: habitTrackingEnabled ?? currentFeatures.habitTrackingEnabled,
      statisticsEnabled: statisticsEnabled ?? currentFeatures.statisticsEnabled,
      achievementsEnabled: achievementsEnabled ?? currentFeatures.achievementsEnabled,
      socialSharingEnabled: socialSharingEnabled ?? currentFeatures.socialSharingEnabled,
      backupEnabled: backupEnabled ?? currentFeatures.backupEnabled,
      notificationsEnabled: notificationsEnabled ?? currentFeatures.notificationsEnabled,
    );

    final newConfig = AppConfig(
      appInfo: currentConfig.appInfo,
      themeConfig: currentConfig.themeConfig,
      featureFlags: newFeatures,
      adConfig: currentConfig.adConfig,
      paymentConfig: currentConfig.paymentConfig,
    );

    await updateConfig(newConfig);
  }

  /// 테마 설정 업데이트
  Future<void> updateTheme(ThemeConfig newTheme) async {
    final newConfig = AppConfig(
      appInfo: currentConfig.appInfo,
      themeConfig: newTheme,
      featureFlags: currentConfig.featureFlags,
      adConfig: currentConfig.adConfig,
      paymentConfig: currentConfig.paymentConfig,
    );

    await updateConfig(newConfig);
  }

  /// 설정을 로컬 파일에 저장
  Future<void> _saveConfigToFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/app_config.json');
      final configJson = jsonEncode(currentConfig.toJson());
      await file.writeAsString(configJson);
      print('설정 파일 저장 완료: ${file.path}');
    } catch (e) {
      print('설정 파일 저장 실패: $e');
    }
  }

  /// 로컬 설정 파일에서 로드
  Future<void> loadFromLocalFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/app_config.json');
      
      if (await file.exists()) {
        final configString = await file.readAsString();
        final configJson = jsonDecode(configString) as Map<String, dynamic>;
        _currentConfig = AppConfig.fromJson(configJson);
        print('로컬 설정 파일 로드 완료');
      }
    } catch (e) {
      print('로컬 설정 파일 로드 실패: $e');
    }
  }

  /// 새로운 앱을 위한 설정 템플릿 생성
  static AppConfig createAppTemplate({
    required String appName,
    required String packageName,
    required String version,
    String description = '',
    String author = '',
    required ThemeConfig theme,
    FeatureFlags? features,
    AdConfig? adConfig,
    PaymentConfig? paymentConfig,
  }) {
    return AppConfig(
      appInfo: AppInfo(
        name: appName,
        packageName: packageName,
        version: version,
        description: description,
        author: author,
      ),
      themeConfig: theme,
      featureFlags: features ?? const FeatureFlags(),
      adConfig: adConfig ?? const AdConfig(
        androidAppId: '',
        androidBannerId: '',
        androidInterstitialId: '',
        androidRewardedId: '',
        iosAppId: '',
        iosBannerId: '',
        iosInterstitialId: '',
        iosRewardedId: '',
      ),
      paymentConfig: paymentConfig ?? const PaymentConfig(),
    );
  }

  /// 설정 초기화
  void reset() {
    _currentConfig = AppConfig.defaultMission100;
  }
}
