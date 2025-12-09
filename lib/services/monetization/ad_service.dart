import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// 광고 관리 서비스
///
/// Google AdMob을 통한 수익화 관리
/// - 보상형 광고 (Rewarded Ads)
/// - 전면 광고 (Interstitial Ads)
/// - 배너 광고 (Banner Ads)
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  // 광고 초기화 완료 여부
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // 보상형 광고
  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;
  bool get isRewardedAdReady => _isRewardedAdReady;

  // 전면 광고
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  bool get isInterstitialAdReady => _isInterstitialAdReady;

  /// 테스트 광고 단위 ID
  ///
  /// TODO: 테스트 완료 후 실제 광고 ID로 교체
  /// 현재는 Google 테스트 광고 ID 사용 (배너 광고와 일관성 유지)
  static String get _rewardedAdUnitId {
    // TODO: 테스트 완료 후 kDebugMode 조건 복원
    // 현재는 모든 빌드에서 테스트 광고 사용
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917'; // Android 테스트 보상형 광고
      // return 'ca-app-pub-1075071967728463/9479960264'; // 실제 보상형 광고 ID (배포 시 주석 해제)
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313'; // iOS 테스트 보상형 광고
      // return 'ca-app-pub-1075071967728463/9479960264'; // 실제 보상형 광고 ID (배포 시 주석 해제)
    }

    return '';
  }

  static String get _interstitialAdUnitId {
    // TODO: 테스트 완료 후 kDebugMode 조건 복원
    // 현재는 모든 빌드에서 테스트 광고 사용
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Android 테스트 전면 광고
      // return 'ca-app-pub-1075071967728463/4723243403'; // 실제 전면 광고 ID (배포 시 주석 해제)
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // iOS 테스트 전면 광고
      // return 'ca-app-pub-1075071967728463/4723243403'; // 실제 전면 광고 ID (배포 시 주석 해제)
    }

    return '';
  }

  /// AdMob 초기화
  Future<void> initialize() async {
    try {
      if (_isInitialized) {
        debugPrint('📢 AdMob already initialized');
        return;
      }

      await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('✅ AdMob initialized successfully');

      // 첫 광고 미리 로드
      loadRewardedAd();
      loadInterstitialAd();
    } catch (e) {
      debugPrint('❌ AdMob initialization error: $e');
      _isInitialized = false;
    }
  }

  /// 보상형 광고 로드
  Future<void> loadRewardedAd() async {
    if (!_isInitialized) {
      debugPrint('⚠️ AdMob not initialized');
      return;
    }

    try {
      debugPrint('📢 Loading rewarded ad...');

      await RewardedAd.load(
        adUnitId: _rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            _isRewardedAdReady = true;
            debugPrint('✅ Rewarded ad loaded');

            // 광고 이벤트 리스너 설정
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                debugPrint('📺 Rewarded ad shown');
              },
              onAdDismissedFullScreenContent: (ad) {
                debugPrint('🚪 Rewarded ad dismissed');
                ad.dispose();
                _rewardedAd = null;
                _isRewardedAdReady = false;

                // 다음 광고 미리 로드
                loadRewardedAd();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                debugPrint('❌ Rewarded ad failed to show: $error');
                ad.dispose();
                _rewardedAd = null;
                _isRewardedAdReady = false;

                // 다시 로드 시도
                loadRewardedAd();
              },
            );
          },
          onAdFailedToLoad: (error) {
            debugPrint('❌ Rewarded ad failed to load: $error');
            _rewardedAd = null;
            _isRewardedAdReady = false;

            // 10초 후 재시도
            Future.delayed(const Duration(seconds: 10), () {
              loadRewardedAd();
            });
          },
        ),
      );
    } catch (e) {
      debugPrint('❌ Error loading rewarded ad: $e');
      _isRewardedAdReady = false;
    }
  }

  /// 보상형 광고 표시
  ///
  /// [onRewardEarned]: 보상 획득 시 콜백
  /// [onAdClosed]: 광고 닫힌 후 콜백 (보상 획득 여부와 무관)
  Future<void> showRewardedAd({
    required Function(int amount, String type) onRewardEarned,
    Function()? onAdClosed,
  }) async {
    if (!_isRewardedAdReady || _rewardedAd == null) {
      debugPrint('⚠️ Rewarded ad not ready');
      onAdClosed?.call();
      return;
    }

    try {
      bool rewardEarned = false;

      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          debugPrint('🎁 User earned reward: ${reward.amount} ${reward.type}');
          rewardEarned = true;
          onRewardEarned(reward.amount.toInt(), reward.type);
        },
      );

      // 광고가 닫힌 후 콜백 (fullScreenContentCallback에서 처리됨)
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          debugPrint('🚪 Rewarded ad dismissed (reward: $rewardEarned)');
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdReady = false;

          onAdClosed?.call();

          // 다음 광고 로드
          loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint('❌ Rewarded ad failed to show: $error');
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdReady = false;

          onAdClosed?.call();

          // 재로드
          loadRewardedAd();
        },
      );
    } catch (e) {
      debugPrint('❌ Error showing rewarded ad: $e');
      onAdClosed?.call();
    }
  }

  /// 전면 광고 로드
  Future<void> loadInterstitialAd() async {
    if (!_isInitialized) {
      debugPrint('⚠️ AdMob not initialized');
      return;
    }

    try {
      debugPrint('📢 Loading interstitial ad...');

      await InterstitialAd.load(
        adUnitId: _interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isInterstitialAdReady = true;
            debugPrint('✅ Interstitial ad loaded');

            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                debugPrint('📺 Interstitial ad shown');
              },
              onAdDismissedFullScreenContent: (ad) {
                debugPrint('🚪 Interstitial ad dismissed');
                ad.dispose();
                _interstitialAd = null;
                _isInterstitialAdReady = false;

                // 다음 광고 미리 로드
                loadInterstitialAd();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                debugPrint('❌ Interstitial ad failed to show: $error');
                ad.dispose();
                _interstitialAd = null;
                _isInterstitialAdReady = false;

                loadInterstitialAd();
              },
            );
          },
          onAdFailedToLoad: (error) {
            debugPrint('❌ Interstitial ad failed to load: $error');
            _interstitialAd = null;
            _isInterstitialAdReady = false;

            // 10초 후 재시도
            Future.delayed(const Duration(seconds: 10), () {
              loadInterstitialAd();
            });
          },
        ),
      );
    } catch (e) {
      debugPrint('❌ Error loading interstitial ad: $e');
      _isInterstitialAdReady = false;
    }
  }

  /// 전면 광고 표시
  ///
  /// [onAdClosed]: 광고 닫힌 후 콜백
  Future<void> showInterstitialAd({
    Function()? onAdClosed,
  }) async {
    if (!_isInterstitialAdReady || _interstitialAd == null) {
      debugPrint('⚠️ Interstitial ad not ready');
      onAdClosed?.call();
      return;
    }

    try {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          debugPrint('🚪 Interstitial ad dismissed');
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;

          onAdClosed?.call();

          // 다음 광고 로드
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint('❌ Interstitial ad failed to show: $error');
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;

          onAdClosed?.call();

          loadInterstitialAd();
        },
      );

      await _interstitialAd!.show();
    } catch (e) {
      debugPrint('❌ Error showing interstitial ad: $e');
      onAdClosed?.call();
    }
  }

  /// 리소스 정리
  void dispose() {
    _rewardedAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd = null;
    _interstitialAd = null;
    _isRewardedAdReady = false;
    _isInterstitialAdReady = false;
  }
}
