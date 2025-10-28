import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/user_subscription.dart';
import '../screens/subscription_screen.dart';

class PremiumGateWidget extends StatelessWidget {
  final Widget child;
  final PremiumFeature requiredFeature;
  final String? featureName;
  final String? description;
  final VoidCallback? onPremiumRequired;

  const PremiumGateWidget({
    super.key,
    required this.child,
    required this.requiredFeature,
    this.featureName,
    this.description,
    this.onPremiumRequired,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final subscription = authService.currentSubscription;

    // 새 시스템: 모든 사용자가 Week 1-14 접근 가능
    // 프리미엄 기능은 광고 제거만 해당
    final isPremium = subscription?.type == SubscriptionType.premium;

    // 광고 제거 기능만 프리미엄 제한
    if (requiredFeature == PremiumFeature.adFree) {
      if (isPremium) {
        return child;
      }
      return _buildLockedContent(context);
    }

    // 다른 모든 기능은 무료로 제공
    return child;
  }

  Widget _buildLockedContent(BuildContext context) {
    return Stack(
      children: [
        // 원본 콘텐츠를 흐리게 표시
        Opacity(
          opacity: 0.3,
          child: IgnorePointer(
            child: child,
          ),
        ),
        // 프리미엄 안내 오버레이
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.workspace_premium,
                    size: 48,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    featureName ?? '프리미엄 기능',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  if (description != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        description!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showUpgradeDialog(context),
                    icon: const Icon(Icons.upgrade),
                    label: const Text('업그레이드'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    if (onPremiumRequired != null) {
      onPremiumRequired!();
      return;
    }

    showDialog(
      context: context,
      builder: (context) => PremiumUpgradeDialog(
        featureName: featureName ?? '이 기능',
        requiredFeature: requiredFeature,
      ),
    );
  }
}

class PremiumUpgradeDialog extends StatelessWidget {
  final String featureName;
  final PremiumFeature requiredFeature;

  const PremiumUpgradeDialog({
    super.key,
    required this.featureName,
    required this.requiredFeature,
  });

  @override
  Widget build(BuildContext context) {
    final requiredPlan = _getRequiredPlan();

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.workspace_premium, color: Colors.amber),
          SizedBox(width: 8),
          Text('프리미엄 기능'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$featureName을 사용하려면 프리미엄 구독이 필요합니다.',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          if (requiredPlan != null) ...[
            Text(
              '필요한 구독: $requiredPlan',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '프리미엄 혜택:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ..._getPremiumBenefits().map(
                      (benefit) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                benefit,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('나중에'),
        ),
        ElevatedButton(
          onPressed: () => _navigateToSubscription(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
          child: const Text('구독하기'),
        ),
      ],
    );
  }

  String? _getRequiredPlan() {
    // 새 구독 모델에서는 광고 제거만 프리미엄
    switch (requiredFeature) {
      case PremiumFeature.adFree:
        return '프리미엄 구독 (₩4,900/월)';
      case PremiumFeature.unlimitedWorkouts:
      case PremiumFeature.advancedStats:
      case PremiumFeature.premiumChads:
      case PremiumFeature.exclusiveChallenges:
      case PremiumFeature.prioritySupport:
        return null; // 모두 무료
    }
  }

  List<String> _getPremiumBenefits() {
    return [
      '✨ 모든 광고 제거',
      '⚡ VIP 빠른 로딩',
      '☁️ 클라우드 백업',
    ];
  }

  void _navigateToSubscription(BuildContext context) {
    Navigator.of(context).pop(); // 다이얼로그 닫기
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SubscriptionScreen(),
      ),
    );
  }
}

// 프리미엄 기능 버튼 위젯
class PremiumFeatureButton extends StatelessWidget {
  final String text;
  final PremiumFeature requiredFeature;
  final VoidCallback onPressed;
  final IconData? icon;
  final String? featureDescription;

  const PremiumFeatureButton({
    super.key,
    required this.text,
    required this.requiredFeature,
    required this.onPressed,
    this.icon,
    this.featureDescription,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final subscription = authService.currentSubscription;
    final isPremium = subscription?.type == SubscriptionType.premium;

    // 새 구독 모델: 광고 제거만 프리미엄, 나머지는 모두 무료
    final hasAccess = requiredFeature != PremiumFeature.adFree || isPremium;

    return ElevatedButton.icon(
      onPressed: hasAccess ? onPressed : () => _showUpgradeDialog(context),
      icon: Icon(
        hasAccess ? (icon ?? Icons.play_arrow) : Icons.lock,
        size: 20,
      ),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: hasAccess ? null : Colors.grey[300],
        foregroundColor: hasAccess ? null : Colors.grey[600],
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PremiumUpgradeDialog(
        featureName: text,
        requiredFeature: requiredFeature,
      ),
    );
  }
}

// 프리미엄 제한 안내 위젯
class PremiumLimitWidget extends StatelessWidget {
  final String limitMessage;
  final PremiumFeature upgradeFeature;

  const PremiumLimitWidget({
    super.key,
    required this.limitMessage,
    required this.upgradeFeature,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.info, color: Colors.orange),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  limitMessage,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _navigateToSubscription(context),
              icon: const Icon(Icons.workspace_premium),
              label: const Text('프리미엄으로 업그레이드'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToSubscription(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SubscriptionScreen(),
      ),
    );
  }
}
