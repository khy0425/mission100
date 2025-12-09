import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// 리워드 광고 관리 서비스
///
/// Google AdMob 리워드 광고를 로드하고 재생합니다.
class RewardAdService {
  static final RewardAdService _instance = RewardAdService._internal();
  factory RewardAdService() => _instance;
  RewardAdService._internal();

  RewardedAd? _rewardedAd;
  bool _isAdLoading = false;
  bool _isAdReady = false;
  Completer<bool>? _loadCompleter;

  /// Android 리워드 광고 단위 ID
  /// TODO: AdMob 콘솔에서 발급받은 실제 광고 단위 ID로 교체 필요
  static const String _androidAdUnitId = 'ca-app-pub-3940256099942544/5224354917'; // 테스트 ID

  /// iOS 리워드 광고 단위 ID
  /// TODO: AdMob 콘솔에서 발급받은 실제 광고 단위 ID로 교체 필요
  static const String _iosAdUnitId = 'ca-app-pub-3940256099942544/1712485313'; // 테스트 ID

  /// 플랫폼별 광고 단위 ID 가져오기
  String get _adUnitId {
    if (kDebugMode) {
      // 디버그 모드에서는 항상 테스트 광고 ID 사용
      return Platform.isAndroid ? _androidAdUnitId : _iosAdUnitId;
    }

    // 프로덕션에서는 실제 광고 ID 사용
    // TODO: 실제 광고 ID로 교체 필요
    return Platform.isAndroid ? _androidAdUnitId : _iosAdUnitId;
  }

  /// 광고가 로드되어 재생 가능한지 여부
  bool get isAdReady => _isAdReady;

  /// 광고가 현재 로딩 중인지 여부
  bool get isLoading => _isAdLoading;

  /// 광고 로드
  Future<bool> loadAd() async {
    if (_isAdLoading && _loadCompleter != null) {
      debugPrint('⚠️ 광고가 이미 로딩 중입니다 - 기존 Completer 반환');
      return _loadCompleter!.future;
    }

    if (_isAdReady) {
      debugPrint('✅ 광고가 이미 로드되어 있습니다');
      return true;
    }

    _isAdLoading = true;
    _loadCompleter = Completer<bool>();
    debugPrint('📥 리워드 광고 로딩 시작...');

    try {
      await RewardedAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            debugPrint('✅ 리워드 광고 로드 완료');
            _rewardedAd = ad;
            _isAdReady = true;
            _isAdLoading = false;

            // 광고 전체 화면 콜백 설정
            _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                debugPrint('🎬 광고 전체 화면 표시');
              },
              onAdDismissedFullScreenContent: (ad) {
                debugPrint('❌ 광고 닫힘');
                ad.dispose();
                _rewardedAd = null;
                _isAdReady = false;

                // 다음 광고 미리 로드
                loadAd();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                debugPrint('❌ 광고 표시 실패: $error');
                ad.dispose();
                _rewardedAd = null;
                _isAdReady = false;

                // 실패 시 다시 로드
                loadAd();
              },
            );

            // Completer 완료
            if (!_loadCompleter!.isCompleted) {
              _loadCompleter!.complete(true);
            }
          },
          onAdFailedToLoad: (error) {
            debugPrint('❌ 리워드 광고 로드 실패: $error');
            _isAdLoading = false;
            _isAdReady = false;
            _rewardedAd = null;

            // Completer 완료 (실패)
            if (!_loadCompleter!.isCompleted) {
              _loadCompleter!.complete(false);
            }
          },
        ),
      );
    } catch (e) {
      debugPrint('❌ 광고 로드 중 예외 발생: $e');
      _isAdLoading = false;
      _isAdReady = false;
      _rewardedAd = null;

      // Completer 완료 (실패)
      if (!_loadCompleter!.isCompleted) {
        _loadCompleter!.complete(false);
      }
    }

    return _loadCompleter!.future;
  }

  /// 광고 표시 및 보상 콜백
  ///
  /// [onRewarded] 광고 시청 완료 시 호출되는 콜백 (토큰 획득 로직)
  /// [onAdClosed] 광고가 닫힐 때 호출되는 콜백 (성공/실패 관계없이)
  /// [onAdFailedToShow] 광고 표시 실패 시 호출되는 콜백
  Future<void> showAd({
    required Function() onRewarded,
    Function()? onAdClosed,
    Function(String error)? onAdFailedToShow,
  }) async {
    if (!_isAdReady || _rewardedAd == null) {
      debugPrint('❌ 광고가 준비되지 않았습니다');
      onAdFailedToShow?.call('광고가 로드되지 않았습니다. 잠시 후 다시 시도해주세요.');
      return;
    }

    debugPrint('🎬 리워드 광고 표시 시작');

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        debugPrint('🎁 사용자가 보상을 받았습니다: ${reward.type} ${reward.amount}');
        onRewarded();
      },
    );

    // 광고가 닫힐 때 콜백 호출
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        debugPrint('🎬 광고 전체 화면 표시');
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('❌ 광고 닫힘');
        ad.dispose();
        _rewardedAd = null;
        _isAdReady = false;

        onAdClosed?.call();

        // 다음 광고 미리 로드
        loadAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('❌ 광고 표시 실패: $error');
        ad.dispose();
        _rewardedAd = null;
        _isAdReady = false;

        onAdFailedToShow?.call(error.message);

        // 실패 시 다시 로드
        loadAd();
      },
    );
  }

  /// 서비스 정리
  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isAdReady = false;
    _isAdLoading = false;
  }
}
