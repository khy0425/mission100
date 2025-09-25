import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'ad_config.dart';

/// 코어 광고 서비스 - 설정 가능한 광고 관리
class CoreAdService {
  static CoreAdService? _instance;
  static CoreAdService get instance => _instance ??= CoreAdService._();
  CoreAdService._();

  AdConfig? _config;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isInterstitialAdReady = false;
  bool _isRewardedAdReady = false;

  // 테스트 광고 ID
  static const String _testBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testRewardedId = 'ca-app-pub-3940256099942544/5224354917';

  /// 광고 서비스 초기화
  Future<void> initialize(AdConfig config) async {
    _config = config;
    
    await MobileAds.instance.initialize();
    
    // 요청 설정
    RequestConfiguration configuration = RequestConfiguration(
      testDeviceIds: kDebugMode ? config.testDeviceIds : [],
    );
    MobileAds.instance.updateRequestConfiguration(configuration);

    // 전면 광고 미리 로드
    if (config.enableInterstitialAds) {
      await loadInterstitialAd();
    }

    // 보상형 광고 미리 로드
    if (config.enableRewardedAds) {
      await loadRewardedAd();
    }
  }

  /// 현재 사용할 배너 광고 ID
  String get bannerAdUnitId {
    if (_config == null) return _testBannerId;
    
    if (kDebugMode) {
      return _testBannerId;
    }
    
    if (Platform.isAndroid) {
      return _config!.androidBannerId.isEmpty ? _testBannerId : _config!.androidBannerId;
    } else if (Platform.isIOS) {
      return _config!.iosBannerId.isEmpty ? _testBannerId : _config!.iosBannerId;
    }
    
    return _testBannerId;
  }

  /// 현재 사용할 전면 광고 ID
  String get interstitialAdUnitId {
    if (_config == null) return _testInterstitialId;
    
    if (kDebugMode) {
      return _testInterstitialId;
    }
    
    if (Platform.isAndroid) {
      return _config!.androidInterstitialId.isEmpty ? _testInterstitialId : _config!.androidInterstitialId;
    } else if (Platform.isIOS) {
      return _config!.iosInterstitialId.isEmpty ? _testInterstitialId : _config!.iosInterstitialId;
    }
    
    return _testInterstitialId;
  }

  /// 현재 사용할 보상형 광고 ID
  String get rewardedAdUnitId {
    if (_config == null) return _testRewardedId;
    
    if (kDebugMode) {
      return _testRewardedId;
    }
    
    if (Platform.isAndroid) {
      return _config!.androidRewardedId.isEmpty ? _testRewardedId : _config!.androidRewardedId;
    } else if (Platform.isIOS) {
      return _config!.iosRewardedId.isEmpty ? _testRewardedId : _config!.iosRewardedId;
    }
    
    return _testRewardedId;
  }

  /// 배너 광고 생성
  BannerAd? createBannerAd({
    required AdSize adSize,
    required void Function(Ad, LoadAdError) onAdFailedToLoad,
    required void Function(Ad) onAdLoaded,
  }) {
    if (_config == null || !_config!.enableBannerAds) {
      return null;
    }

    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdOpened: (Ad ad) => debugPrint('배너 광고 열림'),
        onAdClosed: (Ad ad) => debugPrint('배너 광고 닫힘'),
      ),
    );
  }

  /// 전면 광고 로드
  Future<void> loadInterstitialAd() async {
    if (_config == null || !_config!.enableInterstitialAds) {
      return;
    }

    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('전면 광고 로드 완료');
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('전면 광고 로드 실패: $error');
          _interstitialAd = null;
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  /// 전면 광고 표시
  Future<void> showInterstitialAd({
    VoidCallback? onAdDismissed,
    VoidCallback? onAdFailedToShow,
  }) async {
    if (_config == null || !_config!.enableInterstitialAds) {
      onAdFailedToShow?.call();
      return;
    }

    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          debugPrint('전면 광고 표시됨');
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          debugPrint('전면 광고 닫힘');
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          onAdDismissed?.call();
          // 다음 광고를 미리 로드
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          debugPrint('전면 광고 표시 실패: $error');
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          onAdFailedToShow?.call();
          // 다음 광고를 미리 로드
          loadInterstitialAd();
        },
      );
      
      await _interstitialAd!.show();
    } else {
      debugPrint('전면 광고가 준비되지 않음');
      onAdFailedToShow?.call();
      // 광고 로드 시도
      await loadInterstitialAd();
    }
  }

  /// 보상형 광고 로드
  Future<void> loadRewardedAd() async {
    if (_config == null || !_config!.enableRewardedAds) {
      return;
    }

    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('보상형 광고 로드 완료');
          _rewardedAd = ad;
          _isRewardedAdReady = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('보상형 광고 로드 실패: $error');
          _rewardedAd = null;
          _isRewardedAdReady = false;
        },
      ),
    );
  }

  /// 보상형 광고 표시
  Future<void> showRewardedAd({
    required void Function(AdWithoutView, RewardItem) onUserEarnedReward,
    VoidCallback? onAdDismissed,
    VoidCallback? onAdFailedToShow,
  }) async {
    if (_config == null || !_config!.enableRewardedAds) {
      onAdFailedToShow?.call();
      return;
    }

    if (_isRewardedAdReady && _rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) {
          debugPrint('보상형 광고 표시됨');
        },
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          debugPrint('보상형 광고 닫힘');
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdReady = false;
          onAdDismissed?.call();
          // 다음 광고를 미리 로드
          loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          debugPrint('보상형 광고 표시 실패: $error');
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdReady = false;
          onAdFailedToShow?.call();
          // 다음 광고를 미리 로드
          loadRewardedAd();
        },
      );
      
      await _rewardedAd!.show(onUserEarnedReward: onUserEarnedReward);
    } else {
      debugPrint('보상형 광고가 준비되지 않음');
      onAdFailedToShow?.call();
      // 광고 로드 시도
      await loadRewardedAd();
    }
  }

  /// 전면 광고 준비 상태 확인
  bool get isInterstitialAdReady => _isInterstitialAdReady;

  /// 보상형 광고 준비 상태 확인
  bool get isRewardedAdReady => _isRewardedAdReady;

  /// 리소스 정리
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialAdReady = false;
    
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isRewardedAdReady = false;
  }
}
