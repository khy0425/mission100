/// 광고 설정 클래스
class AdConfig {
  final String androidAppId;
  final String androidBannerId;
  final String androidInterstitialId;
  final String androidRewardedId;
  final String iosAppId;
  final String iosBannerId;
  final String iosInterstitialId;
  final String iosRewardedId;
  final bool enableBannerAds;
  final bool enableInterstitialAds;
  final bool enableRewardedAds;
  final List<String> testDeviceIds;

  const AdConfig({
    required this.androidAppId,
    required this.androidBannerId,
    required this.androidInterstitialId,
    required this.androidRewardedId,
    required this.iosAppId,
    required this.iosBannerId,
    required this.iosInterstitialId,
    required this.iosRewardedId,
    this.enableBannerAds = true,
    this.enableInterstitialAds = true,
    this.enableRewardedAds = false,
    this.testDeviceIds = const [],
  });

  factory AdConfig.fromJson(Map<String, dynamic> json) {
    return AdConfig(
      androidAppId: json['android_app_id'] ?? '',
      androidBannerId: json['android_banner_id'] ?? '',
      androidInterstitialId: json['android_interstitial_id'] ?? '',
      androidRewardedId: json['android_rewarded_id'] ?? '',
      iosAppId: json['ios_app_id'] ?? '',
      iosBannerId: json['ios_banner_id'] ?? '',
      iosInterstitialId: json['ios_interstitial_id'] ?? '',
      iosRewardedId: json['ios_rewarded_id'] ?? '',
      enableBannerAds: json['enable_banner_ads'] ?? true,
      enableInterstitialAds: json['enable_interstitial_ads'] ?? true,
      enableRewardedAds: json['enable_rewarded_ads'] ?? false,
      testDeviceIds: List<String>.from(json['test_device_ids'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'android_app_id': androidAppId,
      'android_banner_id': androidBannerId,
      'android_interstitial_id': androidInterstitialId,
      'android_rewarded_id': androidRewardedId,
      'ios_app_id': iosAppId,
      'ios_banner_id': iosBannerId,
      'ios_interstitial_id': iosInterstitialId,
      'ios_rewarded_id': iosRewardedId,
      'enable_banner_ads': enableBannerAds,
      'enable_interstitial_ads': enableInterstitialAds,
      'enable_rewarded_ads': enableRewardedAds,
      'test_device_ids': testDeviceIds,
    };
  }
}
