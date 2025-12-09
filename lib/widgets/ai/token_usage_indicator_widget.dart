import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/ai/conversation_token_service.dart';
import '../../services/auth/auth_service.dart';
import '../../models/user_subscription.dart';
import '../../generated/l10n/app_localizations.dart';

/// 토큰 사용량 표시 위젯
///
/// 현재 보유 토큰, 최대 토큰, 프리미엄 여부를 시각적으로 표시
class TokenUsageIndicatorWidget extends StatelessWidget {
  const TokenUsageIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Consumer<ConversationTokenService>(
      builder: (context, tokenService, _) {
        final balance = tokenService.balance;
        final authService = Provider.of<AuthService>(context, listen: false);
        final isPremium = authService.currentSubscription?.type == SubscriptionType.premium;
        final maxTokens = isPremium ? 30 : 5;

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                isPremium ? Colors.purple[400]! : Colors.teal[400]!,
                isPremium ? Colors.purple[600]! : Colors.teal[600]!,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                isPremium ? Icons.workspace_premium : Icons.psychology,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPremium ? l10n.tokenUserTypePremium : l10n.tokenUserTypeFree,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      l10n.tokenBalanceDisplay(balance, maxTokens),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (balance > 0)
                SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    value: balance / maxTokens,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
