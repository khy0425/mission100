import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/dream_conversation.dart';
import '../../services/ai/dream_analysis_service_secure.dart';
import '../../services/ai/conversation_token_service.dart';
import '../../services/ai/conversation_storage_service.dart';
import '../../services/auth/auth_service.dart';
import '../../utils/config/constants.dart';
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

    // 토큰 확인
    final tokenService = context.read<ConversationTokenService>();
    if (!tokenService.hasEnoughTokens) {
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
      // AI 응답 받기
      final result = await _aiService.analyzeWithConversation(
        conversationId: _conversationId,
        userMessage: text,
      );

      // 토큰 차감
      await tokenService.startConversation();

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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.lumiConversationTokenDialogTitle),
        content: Text(l10n.lumiConversationTokenDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.lumiConversationTokenDialogClose),
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
