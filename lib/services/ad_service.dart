import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  // 실제 AdMob 광고 ID - 수익 발생!
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1075071967728463/8071566014'; // 실제 배너
    } else {
      return 'ca-app-pub-3940256099942544/2934735716'; // iOS 테스트
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1075071967728463/1378165152'; // 실제 전면
    } else {
      return 'ca-app-pub-3940256099942544/4411468910'; // iOS 테스트
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1075071967728463/3586074831'; // 실제 리워드
    } else {
      return 'ca-app-pub-3940256099942544/1712485313'; // iOS 테스트
    }
  }

  // 설정 화면용 배너 광고 ID
  static String get settingsBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1075071967728463/8071566014'; // 실제 배너
    } else {
      return 'ca-app-pub-3940256099942544/2934735716'; // iOS 테스트
    }
  }

  // 테스트 모드 확인 (개발 단계에서 사용)
  bool get isTestMode {
    // 디버그 모드이거나 테스트 환경인지 확인
    return const bool.fromEnvironment('dart.vm.product') == false;
  }

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  // Singleton instance 접근자
  static AdService get instance => _instance;

  // 초기화 메서드
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // 배너 광고 생성
  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => print('Banner loaded: ${ad.adUnitId}'),
        onAdFailedToLoad: (ad, error) {
          print('Banner failed: $error');
          ad.dispose();
        },
      ),
    );
  }

  // 전면 광고 로드
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          print('Interstitial loaded');
        },
        onAdFailedToLoad: (error) => print('Interstitial failed: $error'),
      ),
    );
  }

  // 전면 광고 표시
  Future<void> showInterstitialAd() async {
    if (_interstitialAd != null) {
      await _interstitialAd!.show();
      _interstitialAd = null;
      loadInterstitialAd();
    }
  }

  // 리워드 광고 로드
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          print('Rewarded loaded');
        },
        onAdFailedToLoad: (error) => print('Rewarded failed: $error'),
      ),
    );
  }

  // 리워드 광고 표시
  void showRewardedAd(Function(int, String) onRewarded) {
    if (_rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          onRewarded(reward.amount.toInt(), reward.type);
        },
      );
      _rewardedAd = null;
      loadRewardedAd();
    }
  }
}
