import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/user_subscription.dart';
import '../../services/ai/conversation_token_service.dart';
import '../../services/auth/auth_service.dart';
import '../../utils/config/constants.dart';
import 'lumi_conversation_screen.dart';
import 'quick_analysis_screen.dart';

/// 꿈 분석 모드 선택 화면
/// - 빠른 분석 (무료)
/// - Lumi와 대화 (토큰 필요)
class AnalysisModeSelectionScreen extends StatelessWidget {
  const AnalysisModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.analysisModeTitle),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 헤더
            Text(
              l10n.analysisModeHeader,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.paddingXL),

            // 빠른 분석 카드
            _buildQuickAnalysisCard(context, theme, isDark, l10n),

            const SizedBox(height: AppConstants.paddingL),

            // Lumi 대화 카드
            _buildLumiConversationCard(context, theme, isDark, l10n),

            const SizedBox(height: AppConstants.paddingXL),

            // 비교 표
            _buildComparisonTable(theme, isDark, l10n),
          ],
        ),
      ),
    );
  }

  /// 빠른 분석 카드
  Widget _buildQuickAnalysisCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.green.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => _navigateToQuickAnalysis(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 아이콘과 제목
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '⚡',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.analysisQuickTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            l10n.analysisQuickBadge,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.paddingM),

              // 설명
              Text(
                l10n.analysisQuickDesc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),

              const SizedBox(height: AppConstants.paddingM),

              // 특징
              _buildFeatureItem(
                l10n.analysisQuickFeature1,
                Colors.green,
                isDark,
              ),
              _buildFeatureItem(
                l10n.analysisQuickFeature2,
                Colors.green,
                isDark,
              ),
              _buildFeatureItem(
                l10n.analysisQuickFeature3,
                Colors.green,
                isDark,
              ),

              const SizedBox(height: AppConstants.paddingM),

              // 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _navigateToQuickAnalysis(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.analysisQuickButton,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Lumi 대화 카드
  Widget _buildLumiConversationCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Consumer<ConversationTokenService>(
      builder: (context, tokenService, _) {
        final balance = tokenService.balance;
        final hasTokens = balance > 0;

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: theme.primaryColor.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: InkWell(
            onTap: hasTokens
                ? () => _navigateToLumiConversation(context)
                : () => _showNoTokensDialog(context, l10n),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 아이콘과 제목
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '💬',
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.analysisLumiTitle,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Text('🎫', style: TextStyle(fontSize: 14)),
                                const SizedBox(width: 4),
                                Text(
                                  l10n.analysisLumiTokens(balance),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: hasTokens
                                        ? theme.primaryColor
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppConstants.paddingM),

                  // 설명
                  Text(
                    l10n.analysisLumiDesc,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: AppConstants.paddingM),

                  // 특징
                  _buildFeatureItem(
                    l10n.analysisLumiFeature1,
                    theme.primaryColor,
                    isDark,
                  ),
                  _buildFeatureItem(
                    l10n.analysisLumiFeature2,
                    theme.primaryColor,
                    isDark,
                  ),
                  _buildFeatureItem(
                    l10n.analysisLumiFeature3,
                    theme.primaryColor,
                    isDark,
                  ),
                  _buildFeatureItem(
                    l10n.analysisLumiFeature4,
                    theme.primaryColor,
                    isDark,
                  ),

                  const SizedBox(height: AppConstants.paddingM),

                  // 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: hasTokens
                          ? () => _navigateToLumiConversation(context)
                          : () => _showNoTokensDialog(context, l10n),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hasTokens
                            ? theme.primaryColor
                            : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        hasTokens ? l10n.analysisLumiButtonStart : l10n.analysisLumiButtonNeedTokens,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 비교 표
  Widget _buildComparisonTable(ThemeData theme, bool isDark, AppLocalizations l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.analysisComparisonTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.paddingM),
            _buildComparisonRow(
              l10n.analysisComparisonSpeed,
              l10n.analysisComparisonSpeedQuick,
              l10n.analysisComparisonSpeedLumi,
              theme,
              isDark,
            ),
            _buildComparisonRow(
              l10n.analysisComparisonDepth,
              l10n.analysisComparisonDepthQuick,
              l10n.analysisComparisonDepthLumi,
              theme,
              isDark,
            ),
            _buildComparisonRow(
              l10n.analysisComparisonFollowUp,
              l10n.analysisComparisonFollowUpQuick,
              l10n.analysisComparisonFollowUpLumi,
              theme,
              isDark,
            ),
            _buildComparisonRow(
              l10n.analysisComparisonCost,
              l10n.analysisComparisonCostQuick,
              l10n.analysisComparisonCostLumi,
              theme,
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  /// 특징 아이템
  Widget _buildFeatureItem(String text, Color color, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[300] : Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 비교 행
  Widget _buildComparisonRow(
    String feature,
    String quick,
    String lumi,
    ThemeData theme,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              feature,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              quick,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              lumi,
              style: TextStyle(
                fontSize: 13,
                color: theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// 빠른 분석으로 이동
  void _navigateToQuickAnalysis(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuickAnalysisScreen(),
      ),
    );
  }

  /// Lumi 대화로 이동
  void _navigateToLumiConversation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LumiConversationScreen(),
      ),
    );
  }

  /// 토큰 부족 다이얼로그
  void _showNoTokensDialog(BuildContext context, AppLocalizations l10n) {
    final authService = context.read<AuthService>();
    final tokenService = context.read<ConversationTokenService>();
    final isPremium = authService.currentSubscription?.type == SubscriptionType.premium;
    final canClaimDaily = tokenService.canClaimDailyReward;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Text('🎫', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(l10n.analysisNoTokensTitle),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.analysisNoTokensMessage,
            ),
            const SizedBox(height: 16),
            if (canClaimDaily) ...[
              _buildDialogOption(
                l10n.analysisNoTokensDaily,
                isPremium ? l10n.analysisNoTokensDailyPremium : l10n.analysisNoTokensDailyFree,
                Colors.green,
              ),
            ],
            _buildDialogOption(
              l10n.analysisNoTokensAd,
              l10n.analysisNoTokensAdReward,
              Colors.blue,
            ),
            if (!isPremium) ...[
              const SizedBox(height: 8),
              _buildDialogOption(
                l10n.analysisNoTokensPremium,
                l10n.analysisNoTokensPremiumBonus,
                Colors.amber,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.analysisNoTokensClose),
          ),
          if (canClaimDaily)
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await tokenService.claimDailyReward(isPremium: isPremium);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.analysisNoTokensClaimedSnackbar),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: Text(l10n.analysisNoTokensClaim),
            ),
        ],
      ),
    );
  }

  /// 다이얼로그 옵션
  Widget _buildDialogOption(String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
