import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/ai/dream_analysis_service_secure.dart';
import '../../services/security/rate_limit_service.dart';
import '../../services/ai/conversation_token_service.dart';
import '../../services/auth/auth_service.dart';
import '../../services/ads/reward_ad_service.dart';
import '../../services/progress/experience_service.dart';
import '../../models/user_subscription.dart';
import '../../utils/config/constants.dart';
import '../../utils/user_title_helper.dart';
import '../../generated/l10n/app_localizations.dart';
import 'lumi_conversation_screen.dart';

/// 빠른 꿈 분석 화면 (1 토큰 사용)
class QuickAnalysisScreen extends StatefulWidget {
  final String? initialDreamText;

  const QuickAnalysisScreen({
    super.key,
    this.initialDreamText,
  });

  @override
  State<QuickAnalysisScreen> createState() => _QuickAnalysisScreenState();
}

class _QuickAnalysisScreenState extends State<QuickAnalysisScreen> {
  final TextEditingController _controller = TextEditingController();
  final DreamAnalysisServiceSecure _aiService = DreamAnalysisServiceSecure();

  String? _analysisResult;
  bool _isAnalyzing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.initialDreamText != null) {
      _controller.text = widget.initialDreamText!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 빠른 분석 실행
  Future<void> _analyzeQuick() async {
    final l10n = AppLocalizations.of(context);
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _error = l10n.quickAnalysisErrorEmpty);
      return;
    }

    if (text.length < 20) {
      setState(() => _error = l10n.quickAnalysisErrorTooShort);
      return;
    }

    // Rate Limiting 체크
    final authService = context.read<AuthService>();
    final isPremium = authService.currentSubscription?.type == SubscriptionType.premium;

    final rateLimitResult = await RateLimitService.checkRateLimit(
      action: 'ai_message',
      isPremium: isPremium,
    );

    if (!rateLimitResult.allowed) {
      setState(() {
        _error = rateLimitResult.reason ?? '요청 제한을 초과했습니다.';
      });

      // 의심스러운 활동이면 경고 다이얼로그 표시
      if (rateLimitResult.isSuspicious) {
        _showSuspiciousActivityDialog(rateLimitResult.reason);
      }
      return;
    }

    // 토큰 확인
    final tokenService = context.read<ConversationTokenService>();
    if (!tokenService.hasEnoughTokensForQuick) {
      _showNoTokenDialog();
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _error = null;
      _analysisResult = null;
    });

    // 키보드 숨기기
    FocusScope.of(context).unfocus();

    try {
      // 사용자 칭호 가져오기 (레벨 기반, 다국어 지원)
      final expService = ExperienceService();
      final totalXP = expService.totalExpEarned;
      final userTitle = UserTitleHelper.getLocalizedTitleForXP(context, totalXP);

      // AI 분석 요청 (서버에서 토큰 차감)
      final result = await _aiService.quickAnalysis(
        dreamText: text,
        userTitle: userTitle,
      );

      setState(() {
        _analysisResult = result;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isAnalyzing = false;
      });
    }
  }

  /// 의심스러운 활동 경고 다이얼로그
  void _showSuspiciousActivityDialog(String? reason) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Text('⚠️ 비정상 활동 감지'),
          ],
        ),
        content: Text(
          reason ?? '비정상적인 활동이 감지되어 일시적으로 제한됩니다.\n\n'
              '계속해서 제한이 발생하면 계정이 정지될 수 있습니다.',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  /// AI 토큰 부족 다이얼로그
  void _showNoTokenDialog() {
    final tokenService = context.read<ConversationTokenService>();
    final balance = tokenService.balance;
    final authService = context.read<AuthService>();
    final isPremium = authService.currentSubscription?.type == SubscriptionType.premium;
    final maxTokens = isPremium ? 50 : 10;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Text('🎫', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('AI 토큰 부족'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 현재 상태
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '현재 토큰',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '$balance / $maxTokens',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                '빠른 AI 분석에는 1 토큰이 필요합니다.',
                style: TextStyle(fontSize: 15),
              ),

              const SizedBox(height: 16),

              // 토큰 획득 방법
              const Text(
                '💡 토큰 획득 방법 (일일):',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),

              _buildCreditOption(
                '✅ 체크리스트 완료',
                '+1 토큰 (매일)',
                Colors.green,
              ),
              _buildCreditOption(
                '📺 광고 시청',
                '+1 토큰/광고 (최대 2개/일)',
                Colors.blue,
              ),

              const SizedBox(height: 12),

              // 토큰 사용
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎯 토큰 사용:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('빠른 분석', style: TextStyle(fontSize: 13)),
                        Text('1 토큰', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('깊은 분석 (Lumi)', style: TextStyle(fontSize: 13)),
                        Text('3 토큰', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              await _watchRewardAd();
            },
            icon: const Icon(Icons.play_circle_outline),
            label: const Text('광고 보고 토큰 받기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// 크레딧 획득 옵션
  Widget _buildCreditOption(String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 광고 시청하고 토큰 받기
  Future<void> _watchRewardAd() async {
    final tokenService = context.read<ConversationTokenService>();
    final authService = context.read<AuthService>();
    final isPremium = authService.currentSubscription?.type == SubscriptionType.premium;
    final adService = RewardAdService();

    try {
      // 광고가 준비되지 않았으면 먼저 로드
      if (!adService.isAdReady) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('광고를 불러오는 중...'),
            duration: Duration(seconds: 2),
          ),
        );

        final bool loaded = await adService.loadAd();

        // 로딩 실패 시 에러
        if (!loaded) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('광고를 불러올 수 없습니다. 잠시 후 다시 시도해주세요.'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }
      }

      // 광고 시청 시작
      bool adWatched = false;

      await adService.showAd(
        onRewarded: () async {
          debugPrint('🎁 광고 시청 완료 - 토큰 획득 시도');
          adWatched = true;

          // 광고 시청 완료 후 서버에 토큰 획득 요청
          try {
            final success = await tokenService.earnFromRewardAd(isPremium: isPremium);

            if (!mounted) return;

            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ 광고 시청 완료! +1 토큰 획득'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('⚠️ 일일 광고 시청 제한에 도달했습니다 (최대 2회/일)'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          } catch (e) {
            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('토큰 획득 중 오류: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        onAdClosed: () {
          debugPrint('❌ 광고 닫힘 (adWatched: $adWatched)');

          if (!adWatched && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('광고를 끝까지 시청해야 토큰을 받을 수 있습니다.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        },
        onAdFailedToShow: (error) {
          debugPrint('❌ 광고 표시 실패: $error');

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('광고 표시 실패: $error'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('광고 시청 중 오류: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// 새로 분석하기
  void _analyzeAgain() {
    setState(() {
      _analysisResult = null;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quickAnalysisAppBar),
        actions: [
          // AI 토큰 표시
          Consumer<ConversationTokenService>(
            builder: (context, tokenService, _) {
              final balance = tokenService.balance;
              final authService = context.read<AuthService>();
              final isPremium = authService.currentSubscription?.type == SubscriptionType.premium;
              final maxTokens = isPremium ? 50 : 10;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: GestureDetector(
                    onTap: () => _showNoTokenDialog(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: balance > 0
                            ? Colors.green.withValues(alpha: 0.2)
                            : Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: balance > 0
                              ? Colors.green.withValues(alpha: 0.5)
                              : Colors.orange.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🎫', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(
                            '$balance/$maxTokens',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: balance > 0 ? Colors.green : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          if (_analysisResult != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _analyzeAgain,
              tooltip: l10n.quickAnalysisRefreshTooltip,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 안내 카드
            if (_analysisResult == null) _buildGuideCard(theme, isDark, l10n),

            // 입력 영역 (결과가 없을 때만 표시)
            if (_analysisResult == null) ...[
              const SizedBox(height: AppConstants.paddingL),
              _buildInputSection(theme, isDark, l10n),
            ],

            // 에러 메시지
            if (_error != null) ...[
              const SizedBox(height: AppConstants.paddingM),
              _buildErrorBanner(theme),
            ],

            // 로딩 인디케이터
            if (_isAnalyzing) ...[
              const SizedBox(height: AppConstants.paddingXL),
              _buildLoadingIndicator(theme, l10n),
            ],

            // 분석 결과
            if (_analysisResult != null) ...[
              const SizedBox(height: AppConstants.paddingL),
              _buildAnalysisResult(theme, isDark, l10n),
            ],
          ],
        ),
      ),
    );
  }

  /// 안내 카드
  Widget _buildGuideCard(ThemeData theme, bool isDark, AppLocalizations l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('⚡', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.quickAnalysisGuideTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l10n.quickAnalysisGuideBadge,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingM),
            Text(
              l10n.quickAnalysisGuideDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: AppConstants.paddingS),
            _buildGuideItem(
              l10n.quickAnalysisGuideNoTokens,
              isDark,
            ),
            _buildGuideItem(
              l10n.quickAnalysisGuideInstantResults,
              isDark,
            ),
            _buildGuideItem(
              l10n.quickAnalysisGuideBasicInterpretation,
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  /// 안내 아이템
  Widget _buildGuideItem(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// 입력 섹션
  Widget _buildInputSection(ThemeData theme, bool isDark, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.quickAnalysisInputTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.paddingM),
        TextField(
          controller: _controller,
          maxLines: 8,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: l10n.quickAnalysisInputHint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
            counterText: l10n.quickAnalysisInputCounter(_controller.text.length, 500),
          ),
          style: const TextStyle(fontSize: 15, height: 1.5),
          onChanged: (value) => setState(() {}),
        ),
        const SizedBox(height: AppConstants.paddingM),
        ElevatedButton(
          onPressed: _isAnalyzing ? null : _analyzeQuick,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: _isAnalyzing
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.auto_awesome, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      l10n.quickAnalysisButtonStart,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  /// 에러 배너
  Widget _buildErrorBanner(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _error!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => setState(() => _error = null),
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  /// 로딩 인디케이터
  Widget _buildLoadingIndicator(ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingXL),
        child: Column(
          children: [
            CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
            ),
            const SizedBox(height: AppConstants.paddingL),
            Text(
              l10n.quickAnalysisLoadingTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingS),
            Text(
              l10n.quickAnalysisLoadingSubtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 분석 결과
  Widget _buildAnalysisResult(ThemeData theme, bool isDark, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 헤더
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.auto_awesome,
                color: theme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.quickAnalysisResultTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppConstants.paddingL),

        // 결과 카드
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: SelectableText(
              _analysisResult!,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: isDark ? Colors.grey[200] : Colors.grey[900],
              ),
            ),
          ),
        ),

        const SizedBox(height: AppConstants.paddingL),

        // 더 깊은 분석 안내
        Card(
          elevation: 1,
          color: theme.primaryColor.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: theme.primaryColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('💬', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Text(
                      l10n.quickAnalysisDeeperTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingM),
                Text(
                  l10n.quickAnalysisDeeperDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: AppConstants.paddingM),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _analyzeAgain,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: theme.primaryColor.withValues(alpha: 0.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.refresh, size: 20),
                        label: Text(l10n.quickAnalysisButtonAnalyzeAgain),
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingM),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // 빠른 분석 화면을 닫고 Lumi 대화 화면으로 이동
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LumiConversationScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.chat_bubble_outline, size: 20),
                        label: Text(l10n.quickAnalysisButtonChatWithLumi),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
