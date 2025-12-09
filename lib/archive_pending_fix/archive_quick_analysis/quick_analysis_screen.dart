import 'package:flutter/material.dart';
import '../../services/ai/dream_analysis_service_secure.dart';
import '../../utils/config/constants.dart';
import '../../generated/l10n/app_localizations.dart';
import 'lumi_conversation_screen.dart';

/// 빠른 꿈 분석 화면 (무료, 토큰 불필요)
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

    setState(() {
      _isAnalyzing = true;
      _error = null;
      _analysisResult = null;
    });

    // 키보드 숨기기
    FocusScope.of(context).unfocus();

    try {
      final result = await _aiService.quickAnalysis(dreamText: text);

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
