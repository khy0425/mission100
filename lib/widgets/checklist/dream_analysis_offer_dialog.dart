import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../utils/config/constants.dart';

/// Lumi AI 꿈 분석 제안 다이얼로그
///
/// 체크리스트 완료 후 꿈 분석 제안 Bottom Sheet
class DreamAnalysisOfferDialog extends StatelessWidget {
  final bool isPremium;
  final bool canUseFree;
  final TextEditingController dreamController;
  final Function(String dreamText) onPremiumAnalysis;
  final Function(String dreamText) onFreeAnalysis;
  final Function(String dreamText) onRewardedAnalysis;

  const DreamAnalysisOfferDialog({
    super.key,
    required this.isPremium,
    required this.canUseFree,
    required this.dreamController,
    required this.onPremiumAnalysis,
    required this.onFreeAnalysis,
    required this.onRewardedAnalysis,
  });

  /// 정적 메서드: 다이얼로그 표시
  static Future<void> show({
    required BuildContext context,
    required bool isPremium,
    required bool canUseFree,
    required Function(String dreamText) onPremiumAnalysis,
    required Function(String dreamText) onFreeAnalysis,
    required Function(String dreamText) onRewardedAnalysis,
  }) async {
    final TextEditingController dreamController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DreamAnalysisOfferDialog(
        isPremium: isPremium,
        canUseFree: canUseFree,
        dreamController: dreamController,
        onPremiumAnalysis: onPremiumAnalysis,
        onFreeAnalysis: onFreeAnalysis,
        onRewardedAnalysis: onRewardedAnalysis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 핸들 바
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppConstants.paddingL),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // 헤더
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(AppColors.lucidGradient[0]),
                        Color(AppColors.lucidGradient[1]),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🧠', style: TextStyle(fontSize: 32)),
                  ),
                ),
                const SizedBox(width: AppConstants.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.checklistDreamAnalysisTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isPremium
                            ? l10n.checklistDreamAnalysisPremiumUnlimited
                            : canUseFree
                                ? l10n.checklistDreamAnalysisAvailable
                                : l10n.checklistDreamAnalysisWatchAd,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isPremium ? const Color(AppColors.successColor) : Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.paddingL),

            // 꿈 내용 입력
            TextField(
              controller: dreamController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: l10n.checklistDreamInputHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),

            const SizedBox(height: AppConstants.paddingL),

            // 버튼
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.checklistLater),
                  ),
                ),
                const SizedBox(width: AppConstants.paddingM),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => _handleAnalysis(context, l10n),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPremium
                          ? const Color(AppColors.successColor)
                          : canUseFree
                              ? const Color(AppColors.primaryColor)
                              : Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingM),
                    ),
                    child: Text(
                      isPremium
                          ? l10n.checklistPremiumAnalysisStart
                          : canUseFree
                              ? l10n.checklistFreeAnalysisStart
                              : l10n.checklistWatchAdAnalysis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.paddingL),

            // 사용 가능 횟수 안내
            if (isPremium)
              _buildPremiumBadge(l10n)
            else if (canUseFree)
              _buildFreeBadge(l10n)
            else
              _buildAdBadge(l10n),
          ],
        ),
      ),
    );
  }

  /// 분석 시작 처리
  void _handleAnalysis(BuildContext context, AppLocalizations l10n) {
    final dreamText = dreamController.text.trim();
    if (dreamText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.checklistEnterDream),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.of(context).pop();

    if (isPremium) {
      // 프리미엄 사용자: 무제한 분석
      onPremiumAnalysis(dreamText);
    } else if (canUseFree) {
      // 무료 사용자: 무료 분석
      onFreeAnalysis(dreamText);
    } else {
      // 쿨다운 중: 리워드 광고 시청 후 분석
      onRewardedAnalysis(dreamText);
    }
  }

  /// 프리미엄 배지
  Widget _buildPremiumBadge(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(AppColors.successGradient[0]),
            Color(AppColors.successGradient[1]),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Row(
        children: [
          const Icon(Icons.diamond, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.checklistPremiumUnlimited,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 무료 분석 가능 배지
  Widget _buildFreeBadge(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.checklistFreeAnalysisAvailable,
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 광고 시청 배지
  Widget _buildAdBadge(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: Colors.orange, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.checklistWatchAdForAnalysis,
              style: TextStyle(
                color: Colors.orange[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
