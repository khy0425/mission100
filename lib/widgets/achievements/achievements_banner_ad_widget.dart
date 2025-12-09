import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../utils/config/constants.dart';
import '../../generated/l10n/app_localizations.dart';

/// 업적 화면 배너 광고 위젯
///
/// 광고가 로드되면 표시, 그렇지 않으면 플레이스홀더
class AchievementsBannerAdWidget extends StatelessWidget {
  final BannerAd? bannerAd;

  const AchievementsBannerAdWidget({
    super.key,
    this.bannerAd,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      height: 60,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(color: Color(AppColors.primaryColor), width: 1),
        ),
      ),
      child: bannerAd != null
          ? AdWidget(ad: bannerAd!)
          : Container(
              height: 60,
              color: const Color(0xFF1A1A1A),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: Color(AppColors.primaryColor),
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.achievementsBannerText,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
