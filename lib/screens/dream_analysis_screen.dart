import 'package:flutter/material.dart';
import '../services/ai/dream_analysis_service.dart';
import '../utils/config/constants.dart';
import '../generated/l10n/app_localizations.dart';

/// Lumi AI 꿈 분석 결과 화면
class DreamAnalysisScreen extends StatelessWidget {
  final DreamAnalysisResult result;

  const DreamAnalysisScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dreamAnalysisAppBar),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            _buildHeader(context, theme, isDark),

            const SizedBox(height: AppConstants.paddingXL),

            // 자각몽 가능성 게이지
            _buildLucidPotentialGauge(context, theme),

            const SizedBox(height: AppConstants.paddingXL),

            // 키워드
            if (result.keywords.isNotEmpty) ...[
              _buildSection(
                context,
                theme,
                l10n.dreamAnalysisKeywordsTitle,
                _buildKeywordChips(context),
              ),
              const SizedBox(height: AppConstants.paddingL),
            ],

            // 감정
            if (result.emotions.isNotEmpty) ...[
              _buildSection(
                context,
                theme,
                l10n.dreamAnalysisEmotionsTitle,
                _buildEmotionChips(context),
              ),
              const SizedBox(height: AppConstants.paddingL),
            ],

            // 상징
            if (result.symbols.isNotEmpty) ...[
              _buildSection(
                context,
                theme,
                l10n.dreamAnalysisSymbolsTitle,
                _buildSymbolsList(context, theme),
              ),
              const SizedBox(height: AppConstants.paddingL),
            ],

            // 해석
            _buildSection(
              context,
              theme,
              l10n.dreamAnalysisInterpretationTitle,
              _buildInterpretation(context, theme),
            ),

            const SizedBox(height: AppConstants.paddingL),

            // 추천 사항
            _buildSection(
              context,
              theme,
              l10n.dreamAnalysisRecommendationsTitle,
              _buildRecommendations(context, theme),
            ),

            const SizedBox(height: AppConstants.paddingXL),

            // 프리미엄 안내 (무료 분석일 경우)
            if (!result.isPremiumAnalysis) _buildPremiumPromo(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(AppColors.lucidGradient[0]),
            Color(AppColors.lucidGradient[1]),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🌙', style: TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(width: AppConstants.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).dreamAnalysisHeaderTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context).dreamAnalysisHeaderSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLucidPotentialGauge(BuildContext context, ThemeData theme) {
    final percentage = (result.lucidDreamPotential * 100).toInt();
    final color = result.lucidDreamPotential > 0.7
        ? Colors.green
        : result.lucidDreamPotential > 0.4
            ? Colors.orange
            : Colors.grey;

    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dreamAnalysisLucidPotentialTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.paddingM),
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingL),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$percentage%',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getLucidPotentialLabel(result.lucidDreamPotential, context),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingM),
              LinearProgressIndicator(
                value: result.lucidDreamPotential,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getLucidPotentialLabel(double potential, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (potential > 0.7) return l10n.dreamAnalysisLucidPotentialHigh;
    if (potential > 0.4) return l10n.dreamAnalysisLucidPotentialMedium;
    return l10n.dreamAnalysisLucidPotentialLow;
  }

  Widget _buildSection(
    BuildContext context,
    ThemeData theme,
    String title,
    Widget content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.paddingM),
        content,
      ],
    );
  }

  Widget _buildKeywordChips(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: result.keywords.map((keyword) {
        return Chip(
          label: Text(keyword),
          backgroundColor: const Color(AppColors.primaryColor).withValues(alpha: 0.2),
          labelStyle: const TextStyle(
            color: Color(AppColors.primaryColor),
            fontWeight: FontWeight.w600,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmotionChips(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: result.emotions.map((emotion) {
        return Chip(
          label: Text(emotion),
          backgroundColor: const Color(AppColors.accentColor).withValues(alpha: 0.2),
          labelStyle: const TextStyle(
            color: Color(AppColors.accentColor),
            fontWeight: FontWeight.w600,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSymbolsList(BuildContext context, ThemeData theme) {
    return Column(
      children: result.symbols.map((symbol) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(AppConstants.paddingM),
          decoration: BoxDecoration(
            color: symbol.lucidDreamSignal
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            border: Border.all(
              color: symbol.lucidDreamSignal
                  ? Colors.green.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              if (symbol.lucidDreamSignal)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.star, color: Colors.white, size: 16),
                ),
              if (symbol.lucidDreamSignal) const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      symbol.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      symbol.meaning,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInterpretation(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: const Color(AppColors.primaryColor).withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        result.interpretation,
        style: theme.textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildRecommendations(BuildContext context, ThemeData theme) {
    return Column(
      children: result.recommendations.asMap().entries.map((entry) {
        final index = entry.key;
        final recommendation = entry.value;
        final isPremium = recommendation.contains('💎');

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(AppConstants.paddingM),
          decoration: BoxDecoration(
            color: isPremium
                ? const Color(AppColors.accentColor).withValues(alpha: 0.1)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            border: Border.all(
              color: isPremium
                  ? const Color(AppColors.accentColor).withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${index + 1}.',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  recommendation,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPremiumPromo(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(AppColors.successGradient[0]),
            Color(AppColors.successGradient[1]),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Column(
        children: [
          const Text(
            '💎',
            style: TextStyle(fontSize: 48),
          ),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            l10n.dreamAnalysisPremiumPromoTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            l10n.dreamAnalysisPremiumFeatures,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingL),
          ElevatedButton(
            onPressed: () {
              // 프리미엄 구매 화면으로 이동
              Navigator.pushNamed(context, '/subscription');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(AppColors.primaryColor),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingXL,
                vertical: AppConstants.paddingM,
              ),
            ),
            child: Text(
              l10n.dreamAnalysisPremiumButton,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
