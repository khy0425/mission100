import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/dream_conversation.dart';
import '../../services/ai/dream_analysis_service_secure.dart';
import '../../services/ai/conversation_token_service.dart';
import '../../services/ai/conversation_storage_service.dart';
import '../../services/auth/auth_service.dart';
import '../../services/security/rate_limit_service.dart';
import '../../services/ads/reward_ad_service.dart';
import '../../services/progress/experience_service.dart';
import '../../models/user_subscription.dart';
import '../../utils/config/constants.dart';
import '../../utils/user_title_helper.dart';
import '../../generated/l10n/app_localizations.dart';

/// Lumi와의 대화형 꿈 분석 화면
class LumiConversationScreen extends StatefulWidget {
  final String? conversationId;

  const LumiConversationScreen({
    super.key,
    this.conversationId,
  });

  @override
  State<LumiConversationScreen> createState() => _LumiConversationScreenState();
}

class _LumiConversationScreenState extends State<LumiConversationScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final DreamAnalysisServiceSecure _aiService = DreamAnalysisServiceSecure();
  final ConversationStorageService _storageService =
      ConversationStorageService();

  String? _conversationId;
  List<ConversationMessage> _messages = [];
  bool _isLoading = false;
  bool _isInitializing = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _conversationId = widget.conversationId;
    _loadConversation();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// 대화 로드 (기존 대화 또는 새 대화)
  Future<void> _loadConversation() async {
    setState(() => _isInitializing = true);

    try {
      final authService = context.read<AuthService>();
      final userId = authService.currentUser?.uid ?? 'anonymous';

      if (_conversationId != null) {
        // 기존 대화 로드
        final conversation =
            await _storageService.loadConversation(_conversationId!);
        if (conversation != null) {
          setState(() {
            _messages = conversation.messages;
            _isInitializing = false;
          });
          _scrollToBottom();
          return;
        }
      }

      // 새 대화 시작
      final conversation = await _storageService.startNewConversation(userId);
      setState(() {
        _conversationId = conversation.id;
        _messages = [];
        _isInitializing = false;
      });
    } catch (e) {
      final l10n = AppLocalizations.of(context);
      setState(() {
        _error = l10n.lumiConversationLoadError;
        _isInitializing = false;
      });
    }
  }

  /// 메시지 전송
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

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

    // 토큰 확인 (깊은 분석: 3토큰 필요)
    final tokenService = context.read<ConversationTokenService>();
    if (!tokenService.hasEnoughTokensForDeep) {
      _showTokenDialog();
      return;
    }

    // UI 업데이트
    final userMessage = ConversationMessage.user(text);
    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
      _error = null;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      // 사용자 칭호 가져오기 (레벨 기반, 다국어 지원)
      final expService = ExperienceService();
      final totalXP = expService.totalExpEarned;
      final userTitle = UserTitleHelper.getLocalizedTitleForXP(context, totalXP);

      // AI 응답 받기
      final result = await _aiService.analyzeWithConversation(
        conversationId: _conversationId,
        userMessage: text,
        userTitle: userTitle,
      );

      // 토큰은 서버에서 자동 차감됨

      // AI 응답 추가
      final aiMessage = ConversationMessage.assistant(result.response);
      setState(() {
        _conversationId = result.conversationId;
        _messages.add(aiMessage);
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });

      // 에러 시 사용자 메시지 제거
      if (_messages.last.role == 'user') {
        setState(() => _messages.removeLast());
      }
    }
  }

  /// 토큰 부족 다이얼로그
  void _showTokenDialog() {
    final l10n = AppLocalizations.of(context);
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
        content: Column(
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
              'Lumi 깊은 분석에는 3 토큰이 필요합니다.',
              style: TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 12),

            const Text(
              '💡 토큰 획득 방법 (일일):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text('✅ 체크리스트 완료: +1 토큰', style: TextStyle(fontSize: 13)),
            const Text('📺 광고 시청: +1 토큰/광고 (최대 2개/일)', style: TextStyle(fontSize: 13)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.lumiConversationTokenDialogClose),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _watchRewardAd();
            },
            child: const Text('광고 보고 토큰 받기'),
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
            duration: Duration(seconds: 1),
          ),
        );

        await adService.loadAd();

        // 로딩 후에도 광고가 준비되지 않았으면 에러
        if (!adService.isAdReady) {
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

  /// 하단으로 스크롤
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isInitializing) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.lumiConversationAppBar)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.lumiConversationAppBar),
        actions: [
          // 토큰 잔액 표시
          Consumer<ConversationTokenService>(
            builder: (context, tokenService, _) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🎫', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 4),
                        Text(
                          '${tokenService.balance}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 에러 메시지
          if (_error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.red.withValues(alpha: 0.1),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => setState(() => _error = null),
                  ),
                ],
              ),
            ),

          // 메시지 리스트
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState(theme, l10n)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppConstants.paddingM),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      if (message.role == 'system') return const SizedBox();
                      return _buildMessageBubble(message, theme, isDark);
                    },
                  ),
          ),

          // 로딩 인디케이터
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(l10n.lumiConversationThinking),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // 입력창
          _buildInputField(theme, isDark, l10n),
        ],
      ),
    );
  }

  /// 빈 상태 (대화 시작 전)
  Widget _buildEmptyState(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '✨',
            style: TextStyle(fontSize: 64, color: theme.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.lumiConversationEmptyTitle,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.lumiConversationEmptySubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// 메시지 버블
  Widget _buildMessageBubble(
    ConversationMessage message,
    ThemeData theme,
    bool isDark,
  ) {
    final isUser = message.role == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? theme.primaryColor
              : (isDark ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: isUser ? Colors.white : (isDark ? Colors.white : Colors.black87),
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  /// 입력 필드
  Widget _buildInputField(ThemeData theme, bool isDark, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: l10n.lumiConversationInputHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  counterText: '',
                ),
                maxLength: 500,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: theme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _isLoading ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
