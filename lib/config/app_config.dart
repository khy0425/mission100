import 'package:flutter/material.dart';
import '../core/ads/ad_config.dart';

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
      name: json['name'] ?? '',
      packageName: json['package_name'] ?? '',
      version: json['version'] ?? '1.0.0',
      description: json['description'] ?? '',
      author: json['author'] ?? '',
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
      primaryColor: Color(int.parse(json['primary_color'].toString().replaceFirst('#', '0xFF'))),
      secondaryColor: Color(int.parse(json['secondary_color'].toString().replaceFirst('#', '0xFF'))),
      accentColor: Color(int.parse(json['accent_color'].toString().replaceFirst('#', '0xFF'))),
      fontFamily: json['font_family'] ?? 'Roboto',
      isDarkMode: json['is_dark_mode'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primary_color': '#${primaryColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
      'secondary_color': '#${secondaryColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
      'accent_color': '#${accentColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
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
      timerEnabled: json['timer_enabled'] ?? true,
      habitTrackingEnabled: json['habit_tracking_enabled'] ?? true,
      statisticsEnabled: json['statistics_enabled'] ?? true,
      achievementsEnabled: json['achievements_enabled'] ?? true,
      socialSharingEnabled: json['social_sharing_enabled'] ?? true,
      backupEnabled: json['backup_enabled'] ?? true,
      notificationsEnabled: json['notifications_enabled'] ?? true,
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
      subscriptionEnabled: json['subscription_enabled'] ?? false,
      oneTimePurchaseEnabled: json['one_time_purchase_enabled'] ?? false,
      subscriptionProductIds: List<String>.from(json['subscription_product_ids'] ?? []),
      oneTimeProductIds: List<String>.from(json['one_time_product_ids'] ?? []),
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

/// 메인 앱 설정 클래스
class AppConfig {
  final AppInfo appInfo;
  final ThemeConfig themeConfig;
  final FeatureFlags featureFlags;
  final AdConfig adConfig;
  final PaymentConfig paymentConfig;

  const AppConfig({
    required this.appInfo,
    required this.themeConfig,
    required this.featureFlags,
    required this.adConfig,
    required this.paymentConfig,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      appInfo: AppInfo.fromJson(json['app'] ?? {}),
      themeConfig: ThemeConfig.fromJson(json['theme'] ?? {}),
      featureFlags: FeatureFlags.fromJson(json['features'] ?? {}),
      adConfig: AdConfig.fromJson(json['ads'] ?? {}),
      paymentConfig: PaymentConfig.fromJson(json['payment'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app': appInfo.toJson(),
      'theme': themeConfig.toJson(),
      'features': featureFlags.toJson(),
      'ads': adConfig.toJson(),
      'payment': paymentConfig.toJson(),
    };
  }

  /// 기본 Mission100 설정
  static AppConfig get defaultMission100 {
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
      adConfig: const AdConfig(
        androidAppId: 'ca-app-pub-1075071967728463~6042582986',
        androidBannerId: 'ca-app-pub-1075071967728463/9498612269',
        androidInterstitialId: 'ca-app-pub-1075071967728463/7039728635',
        androidRewardedId: '',
        iosAppId: '',
        iosBannerId: '',
        iosInterstitialId: '',
        iosRewardedId: '',
        enableBannerAds: true,
        enableInterstitialAds: true,
        enableRewardedAds: false,
      ),
      paymentConfig: const PaymentConfig(
        subscriptionEnabled: false,
        oneTimePurchaseEnabled: false,
      ),
    );
  }
}
