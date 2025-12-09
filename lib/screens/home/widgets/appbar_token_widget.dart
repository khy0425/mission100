import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/ai/conversation_token_service.dart';
import '../../../generated/l10n/app_localizations.dart';

/// AppBar에 표시되는 토큰 잔액 위젯 (Factory App 버전)
class AppBarTokenWidget extends StatefulWidget {
  const AppBarTokenWidget({super.key});

  @override
  State<AppBarTokenWidget> createState() => _AppBarTokenWidgetState();
}

class _AppBarTokenWidgetState extends State<AppBarTokenWidget>
    with SingleTickerProviderStateMixin {
  int? _previousBalance;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  int _incrementAmount = 0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0, end: -40).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _checkBalanceChange(int currentBalance) {
    if (_previousBalance != null && currentBalance > _previousBalance!) {
      final increment = currentBalance - _previousBalance!;
      if (!_isAnimating) {
        _triggerIncrementAnimation(increment);
      }
    }
    _previousBalance = currentBalance;
  }

  void _triggerIncrementAnimation(int amount) {
    if (!mounted) return;

    setState(() {
      _incrementAmount = amount;
      _isAnimating = true;
    });

    _animationController.forward(from: 0).then((_) {
      if (mounted) {
        setState(() {
          _isAnimating = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConversationTokenService>(
      builder: (context, tokenService, _) {
        final balance = tokenService.balance;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkBalanceChange(balance);
        });

        return GestureDetector(
          onTap: () => _showTokenInfoDialog(context, tokenService),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.amber,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '🪙',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$balance',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),

              if (_incrementAmount > 0)
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Positioned(
                      right: 0,
                      top: _slideAnimation.value,
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Text(
                          '+$_incrementAmount',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(1, 1),
                                blurRadius: 2,
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
        );
      },
    );
  }

  void _showTokenInfoDialog(
    BuildContext context,
    ConversationTokenService tokenService,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final canClaimDaily = tokenService.canClaimDailyReward;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Text('🪙', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('AI 토큰'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.withValues(alpha: 0.2),
                    Colors.orange.withValues(alpha: 0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    '현재 잔액',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${tokenService.balance}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              '토큰 획득 방법',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _buildEarnMethod(
              context,
              icon: canClaimDaily ? '✅' : '⏰',
              title: '일일 무료 보상',
              status: canClaimDaily ? '받기 가능' : '내일 다시',
              isAvailable: canClaimDaily,
            ),

            const SizedBox(height: 8),

            _buildEarnMethod(
              context,
              icon: '📺',
              title: '리워드 광고 시청',
              status: '언제든 가능',
              isAvailable: true,
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '토큰으로 AI 캐릭터와 대화할 수 있어요!',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  Widget _buildEarnMethod(
    BuildContext context, {
    required String icon,
    required String title,
    required String status,
    required bool isAvailable,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAvailable
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isAvailable
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: isAvailable ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
