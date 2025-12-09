import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../services/payment/ad_service.dart';
import '../../services/auth/auth_service.dart';
import '../../generated/l10n/app_localizations.dart';

class AdBannerWidget extends StatefulWidget {
  final AdSize adSize;
  final EdgeInsets? margin;
  final bool showOnError;

  const AdBannerWidget({
    super.key,
    this.adSize = AdSize.banner,
    this.margin,
    this.showOnError = false,
  });

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    // 프리미엄 구독자는 광고를 로드하지 않음
    final authService = context.read<AuthService>();
    if (!authService.hasAds) {
      return;
    }

    debugPrint('🔍 AdBannerWidget _loadBannerAd() 시작');

    _bannerAd = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      size: widget.adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
            _hasError = false;
          });
          debugPrint('✅ 배너 광고 로드 완료: ${ad.adUnitId}');
        },
        onAdFailedToLoad: (ad, error) {
          setState(() {
            _isAdLoaded = false;
            _hasError = true;
          });
          debugPrint('❌ 배너 광고 로드 실패: $error');
          ad.dispose();
        },
      ),
    );
    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 프리미엄 구독자는 광고를 표시하지 않음
    final authService = context.watch<AuthService>();
    if (!authService.hasAds) {
      return const SizedBox.shrink();
    }

    debugPrint('🔍 AdBannerWidget build() - _isAdLoaded: $_isAdLoaded, _hasError: $_hasError');

    // 광고 로드 실패 시 에러 표시 여부에 따라 처리
    if (_hasError && !widget.showOnError) {
      debugPrint('⚠️ AdBannerWidget - 광고 로드 실패로 숨김');
      return const SizedBox.shrink();
    }

    // 광고가 로드되지 않았을 때
    if (!_isAdLoaded) {
      if (_hasError && widget.showOnError) {
        return Container(
          margin: widget.margin,
          height: widget.adSize.height.toDouble(),
          child: Center(
            child: Text(
              AppLocalizations.of(context).adLoadFailed,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        );
      }

      // 로딩 중일 때
      return Container(
        margin: widget.margin,
        height: widget.adSize.height.toDouble(),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    // 광고 표시
    return Container(
      margin: widget.margin,
      alignment: Alignment.center,
      width: widget.adSize.width.toDouble(),
      height: widget.adSize.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
