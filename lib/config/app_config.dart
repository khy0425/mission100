import 'package:flutter/material.dart';
import '../core/ads/ad_config.dart';
import '../core/security/api_key_manager.dart';

/// 앱 기본 정보
class AppInfo {
  final String name;
  final String packageName;
  final String version;
  final String description;
  final String author;

  const AppInfo({
    required this.name,
    required this.packageName,
    required this.version,
    this.description = '',
    this.author = '',
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      name: (json['name'] as String?) ?? '',
      packageName: (json['package_name'] as String?) ?? '',
      version: (json['version'] as String?) ?? '1.0.0',
      description: (json['description'] as String?) ?? '',
      author: (json['author'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'package_name': packageName,
      'version': version,
      'description': description,
      'author': author,
    };
  }
}

/// 테마 설정
class ThemeConfig {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final String fontFamily;
  final bool isDarkMode;

  const ThemeConfig({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    this.fontFamily = 'Roboto',
    this.isDarkMode = false,
  });

  factory ThemeConfig.fromJson(Map<String, dynamic> json) {
    return ThemeConfig(
      primaryColor: Color(
        int.parse(json['primary_color'].toString().replaceFirst('#', '0xFF')),
      ),
      secondaryColor: Color(
        int.parse(json['secondary_color'].toString().replaceFirst('#', '0xFF')),
      ),
      accentColor: Color(
        int.parse(json['accent_color'].toString().replaceFirst('#', '0xFF')),
      ),
      fontFamily: (json['font_family'] as String?) ?? 'Roboto',
      isDarkMode: (json['is_dark_mode'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primary_color':
          '#${primaryColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}',
      'secondary_color':
          '#${secondaryColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}',
      'accent_color':
          '#${accentColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}',
      'font_family': fontFamily,
      'is_dark_mode': isDarkMode,
    };
  }
}

/// 기능 플래그
class FeatureFlags {
  final bool timerEnabled;
  final bool habitTrackingEnabled;
  final bool statisticsEnabled;
  final bool achievementsEnabled;
  final bool socialSharingEnabled;
  final bool backupEnabled;
  final bool notificationsEnabled;

  const FeatureFlags({
    this.timerEnabled = true,
    this.habitTrackingEnabled = true,
    this.statisticsEnabled = true,
    this.achievementsEnabled = true,
    this.socialSharingEnabled = true,
    this.backupEnabled = true,
    this.notificationsEnabled = true,
  });

  factory FeatureFlags.fromJson(Map<String, dynamic> json) {
    return FeatureFlags(
      timerEnabled: (json['timer_enabled'] as bool?) ?? true,
      habitTrackingEnabled: (json['habit_tracking_enabled'] as bool?) ?? true,
      statisticsEnabled: (json['statistics_enabled'] as bool?) ?? true,
      achievementsEnabled: (json['achievements_enabled'] as bool?) ?? true,
      socialSharingEnabled: (json['social_sharing_enabled'] as bool?) ?? true,
      backupEnabled: (json['backup_enabled'] as bool?) ?? true,
      notificationsEnabled: (json['notifications_enabled'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timer_enabled': timerEnabled,
      'habit_tracking_enabled': habitTrackingEnabled,
      'statistics_enabled': statisticsEnabled,
      'achievements_enabled': achievementsEnabled,
      'social_sharing_enabled': socialSharingEnabled,
      'backup_enabled': backupEnabled,
      'notifications_enabled': notificationsEnabled,
    };
  }
}

/// 결제 설정
class PaymentConfig {
  final bool subscriptionEnabled;
  final bool oneTimePurchaseEnabled;
  final List<String> subscriptionProductIds;
  final List<String> oneTimeProductIds;

  const PaymentConfig({
    this.subscriptionEnabled = false,
    this.oneTimePurchaseEnabled = false,
    this.subscriptionProductIds = const [],
    this.oneTimeProductIds = const [],
  });

  factory PaymentConfig.fromJson(Map<String, dynamic> json) {
    return PaymentConfig(
      subscriptionEnabled: (json['subscription_enabled'] as bool?) ?? false,
      oneTimePurchaseEnabled:
          (json['one_time_purchase_enabled'] as bool?) ?? false,
      subscriptionProductIds: List<String>.from(
        (json['subscription_product_ids'] as List?) ?? [],
      ),
      oneTimeProductIds:
          List<String>.from((json['one_time_product_ids'] as List?) ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscription_enabled': subscriptionEnabled,
      'one_time_purchase_enabled': oneTimePurchaseEnabled,
      'subscription_product_ids': subscriptionProductIds,
      'one_time_product_ids': oneTimeProductIds,
    };
  }
}

/// 보안 설정
class SecurityConfig {
  final bool apiKeyEncryptionEnabled;
  final bool runtimeKeyValidation;
  final bool keyRotationEnabled;
  final Duration keyRotationInterval;
  final int maxApiKeyAttempts;

  const SecurityConfig({
    this.apiKeyEncryptionEnabled = true,
    this.runtimeKeyValidation = true,
    this.keyRotationEnabled = true,
    this.keyRotationInterval = const Duration(days: 30),
    this.maxApiKeyAttempts = 5,
  });

  factory SecurityConfig.fromJson(Map<String, dynamic> json) {
    return SecurityConfig(
      apiKeyEncryptionEnabled:
          (json['api_key_encryption_enabled'] as bool?) ?? true,
      runtimeKeyValidation: (json['runtime_key_validation'] as bool?) ?? true,
      keyRotationEnabled: (json['key_rotation_enabled'] as bool?) ?? true,
      keyRotationInterval: Duration(
        days: (json['key_rotation_days'] as int?) ?? 30,
      ),
      maxApiKeyAttempts: (json['max_api_key_attempts'] as int?) ?? 5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'api_key_encryption_enabled': apiKeyEncryptionEnabled,
      'runtime_key_validation': runtimeKeyValidation,
      'key_rotation_enabled': keyRotationEnabled,
      'key_rotation_days': keyRotationInterval.inDays,
      'max_api_key_attempts': maxApiKeyAttempts,
    };
  }
}

/// 메인 앱 설정 클래스
class AppConfig {
  final AppInfo appInfo;
  final ThemeConfig themeConfig;
  final FeatureFlags featureFlags;
  final AdConfig adConfig;
  final PaymentConfig paymentConfig;
  final SecurityConfig securityConfig;

  const AppConfig({
    required this.appInfo,
    required this.themeConfig,
    required this.featureFlags,
    required this.adConfig,
    required this.paymentConfig,
    required this.securityConfig,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      appInfo: AppInfo.fromJson((json['app'] as Map<String, dynamic>?) ?? {}),
      themeConfig:
          ThemeConfig.fromJson((json['theme'] as Map<String, dynamic>?) ?? {}),
      featureFlags: FeatureFlags.fromJson(
          (json['features'] as Map<String, dynamic>?) ?? {}),
      adConfig: AdConfig.fromJson((json['ads'] as Map<String, dynamic>?) ?? {}),
      paymentConfig: PaymentConfig.fromJson(
          (json['payment'] as Map<String, dynamic>?) ?? {}),
      securityConfig: SecurityConfig.fromJson(
          (json['security'] as Map<String, dynamic>?) ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app': appInfo.toJson(),
      'theme': themeConfig.toJson(),
      'features': featureFlags.toJson(),
      'ads': adConfig.toJson(),
      'payment': paymentConfig.toJson(),
      'security': securityConfig.toJson(),
    };
  }

  /// 보안 API 키 로드
  static Future<AppConfig> loadSecureConfig() async {
    final apiKeyManager = ApiKeyManager();
    final apiKeys = await apiKeyManager.loadEnvironmentKeys();

    // API 키 유효성 검증
    for (final entry in apiKeys.entries) {
      if (!apiKeyManager.validateApiKey(entry.key, entry.value)) {
        debugPrint('유효하지 않은 API 키: ${entry.key}');
      }
    }

    return AppConfig(
      appInfo: const AppInfo(
        name: 'Mission 100',
        packageName: 'com.example.mission100',
        version: '2.1.0',
        description: '100일 푸쉬업 챌린지 앱',
        author: 'Mission 100 Team',
      ),
      themeConfig: const ThemeConfig(
        primaryColor: Color(0xFF2196F3),
        secondaryColor: Color(0xFFFF5722),
        accentColor: Color(0xFFFFC107),
        fontFamily: 'Roboto',
        isDarkMode: false,
      ),
      featureFlags: const FeatureFlags(
        timerEnabled: true,
        habitTrackingEnabled: true,
        statisticsEnabled: true,
        achievementsEnabled: true,
        socialSharingEnabled: true,
        backupEnabled: true,
        notificationsEnabled: true,
      ),
      adConfig: AdConfig(
        androidAppId: apiKeys['admob_app_id'] ?? '',
        androidBannerId: apiKeys['admob_banner_id'] ?? '',
        androidInterstitialId: apiKeys['admob_interstitial_id'] ?? '',
        androidRewardedId: apiKeys['admob_rewarded_id'] ?? '',
        iosAppId: apiKeys['ios_admob_app_id'] ?? '',
        iosBannerId: apiKeys['ios_admob_banner_id'] ?? '',
        iosInterstitialId: apiKeys['ios_admob_interstitial_id'] ?? '',
        iosRewardedId: apiKeys['ios_admob_rewarded_id'] ?? '',
        enableBannerAds: apiKeys['admob_banner_id']?.isNotEmpty == true,
        enableInterstitialAds:
            apiKeys['admob_interstitial_id']?.isNotEmpty == true,
        enableRewardedAds: apiKeys['admob_rewarded_id']?.isNotEmpty == true,
      ),
      paymentConfig: const PaymentConfig(
        subscriptionEnabled: true,
        oneTimePurchaseEnabled: false,
        subscriptionProductIds: [
          'premium_monthly',
          'premium_yearly',
          'premium_lifetime',
        ],
      ),
      securityConfig: SecurityConfig(
        apiKeyEncryptionEnabled:
            ApiSecurityConfig.currentSecurityLevel == SecurityLevel.production,
        runtimeKeyValidation: true,
        keyRotationEnabled:
            ApiSecurityConfig.currentSecurityLevel == SecurityLevel.production,
        keyRotationInterval: ApiSecurityConfig.keyRotationInterval,
        maxApiKeyAttempts: ApiSecurityConfig.maxKeyAttempts,
      ),
    );
  }

  /// 기본 Mission100 설정 (보안 강화 - API 키 제거)
  static AppConfig get defaultMission100 {
    return const AppConfig(
      appInfo: AppInfo(
        name: 'Mission 100',
        packageName: 'com.example.mission100',
        version: '2.1.0',
        description: '100일 푸쉬업 챌린지 앱',
        author: 'Mission 100 Team',
      ),
      themeConfig: ThemeConfig(
        primaryColor: Color(0xFF2196F3),
        secondaryColor: Color(0xFFFF5722),
        accentColor: Color(0xFFFFC107),
        fontFamily: 'Roboto',
        isDarkMode: false,
      ),
      featureFlags: FeatureFlags(
        timerEnabled: true,
        habitTrackingEnabled: true,
        statisticsEnabled: true,
        achievementsEnabled: true,
        socialSharingEnabled: true,
        backupEnabled: true,
        notificationsEnabled: true,
      ),
      // API 키는 보안상 제거, loadSecureConfig() 사용 권장
      adConfig: AdConfig(
        androidAppId: '',
        androidBannerId: '',
        androidInterstitialId: '',
        androidRewardedId: '',
        iosAppId: '',
        iosBannerId: '',
        iosInterstitialId: '',
        iosRewardedId: '',
        enableBannerAds: false,
        enableInterstitialAds: false,
        enableRewardedAds: false,
      ),
      paymentConfig: PaymentConfig(
        subscriptionEnabled: true,
        oneTimePurchaseEnabled: false,
        subscriptionProductIds: [
          'premium_monthly',
          'premium_yearly',
          'premium_lifetime',
        ],
      ),
      securityConfig: SecurityConfig(
        apiKeyEncryptionEnabled: true,
        runtimeKeyValidation: true,
        keyRotationEnabled: false, // 기본값에서는 비활성화
        keyRotationInterval: Duration(days: 30),
        maxApiKeyAttempts: 5,
      ),
    );
  }
}
