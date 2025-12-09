import 'package:flutter/material.dart';
import '../../services/monetization/ad_service.dart';
import '../../services/monetization/ai_credit_service.dart';
import '../../utils/config/constants.dart';

/// 광고 시청으로 AI 크레딧 받기 버튼
///
/// 무료 사용자가 광고를 시청하고 AI 분석 크레딧을 얻을 수 있는 버튼
class WatchAdButton extends StatefulWidget {
  /// 광고 시청 후 콜백 (크레딧 획득 성공 시)
  final Function()? onAdWatched;

  /// 버튼 스타일 (elevated | outlined | text)
  final String style;

  /// 버튼 텍스트 커스터마이징
  final String? customText;

  const WatchAdButton({
    super.key,
    this.onAdWatched,
    this.style = 'elevated',
    this.customText,
  });

  @override
  State<WatchAdButton> createState() => _WatchAdButtonState();
}

class _WatchAdButtonState extends State<WatchAdButton> {
  final AdService _adService = AdService();
  bool _isLoading = false;
  int _currentCredits = 0;

  @override
  void initState() {
    super.initState();
    _loadCredits();
  }

  Future<void> _loadCredits() async {
    final credits = await AIcreditService.getCredits();
    if (mounted) {
      setState(() {
        _currentCredits = credits;
      });
    }
  }

  Future<void> _watchAd() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // 광고가 준비되지 않았으면 로드 시도
      if (!_adService.isRewardedAdReady) {
        _showMessage('광고를 불러오는 중입니다... 잠시 후 다시 시도해주세요.');
        await _adService.loadRewardedAd();
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 광고 표시
      await _adService.showRewardedAd(
        onRewardEarned: (amount, type) async {
          // 광고 시청 완료 - 크레딧 지급
          await AIcreditService.earnCreditsFromAd();
          await _loadCredits();

          if (mounted) {
            _showMessage(
              '✨ AI 분석 크레딧 ${AIcreditService.creditsPerAd}개를 받았습니다!\n현재 크레딧: $_currentCredits개',
              isSuccess: true,
            );

            widget.onAdWatched?.call();
          }
        },
        onAdClosed: () {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        },
      );
    } catch (e) {
      debugPrint('❌ Error watching ad: $e');
      _showMessage('광고 표시 중 오류가 발생했습니다.');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message, {bool isSuccess = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : null,
        duration: Duration(seconds: isSuccess ? 3 : 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonText = widget.customText ?? '📺 광고 보고 크레딧 받기';

    if (widget.style == 'outlined') {
      return OutlinedButton.icon(
        onPressed: _isLoading ? null : _watchAd,
        icon: _isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.play_circle_outline),
        label: Text(buttonText),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(AppColors.primaryColor),
          side: const BorderSide(color: Color(AppColors.primaryColor)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      );
    }

    if (widget.style == 'text') {
      return TextButton.icon(
        onPressed: _isLoading ? null : _watchAd,
        icon: _isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.play_circle_outline),
        label: Text(buttonText),
        style: TextButton.styleFrom(
          foregroundColor: const Color(AppColors.primaryColor),
        ),
      );
    }

    // Default: elevated button
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _watchAd,
      icon: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Icon(Icons.play_circle_filled),
      label: Text(buttonText),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(AppColors.primaryColor),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// AI 크레딧 표시 위젯
///
/// 현재 보유 크레딧과 광고 시청 버튼을 함께 표시
class AIcreditDisplay extends StatefulWidget {
  /// 광고 시청 후 콜백
  final Function()? onAdWatched;

  /// 프리미엄 사용자 여부
  final bool isPremium;

  const AIcreditDisplay({
    super.key,
    this.onAdWatched,
    this.isPremium = false,
  });

  @override
  State<AIcreditDisplay> createState() => _AIcreditDisplayState();
}

class _AIcreditDisplayState extends State<AIcreditDisplay> {
  int _credits = 0;
  int _maxCredits = AIcreditService.maxCredits;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await AIcreditService.getStats();
    if (mounted) {
      setState(() {
        _credits = stats['credits'] as int;
        _maxCredits = stats['maxCredits'] as int;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPremium) {
      return Card(
        color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber[700],
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '프리미엄 회원',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'AI 분석 무제한 사용 가능',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 크레딧 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'AI 분석 크레딧',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(AppColors.primaryColor).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$_credits / $_maxCredits',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(AppColors.primaryColor),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 진행 바
            LinearProgressIndicator(
              value: _credits / _maxCredits,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(AppColors.primaryColor),
              ),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),

            const SizedBox(height: 12),

            // 정보 텍스트
            Text(
              '• 매주 월요일 무료 크레딧 ${AIcreditService.weeklyFreeCredits}개 지급',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '• 레벨업 시 보너스 크레딧 ${AIcreditService.levelUpBonus}개 획득',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '• 광고 시청으로 추가 크레딧 획득 가능',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 16),

            // 광고 시청 버튼
            if (_credits < _maxCredits)
              WatchAdButton(
                onAdWatched: () {
                  _loadStats();
                  widget.onAdWatched?.call();
                },
              ),
          ],
        ),
      ),
    );
  }
}
