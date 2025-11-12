import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucid_dream_100/generated/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../services/auth/auth_service.dart';
import '../../services/payment/billing_service.dart';
import '../../models/user_subscription.dart';
import '../../widgets/common/vip_badge_widget.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final BillingService _billingService = BillingService();
  bool _isLoading = true;
  UserSubscription? _subscription;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionData();
  }

  Future<void> _loadSubscriptionData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Initialize billing service
      await _billingService.initialize();

      // Load current subscription
      final authService = Provider.of<AuthService>(context, listen: false);
      final subscription = authService.currentSubscription;

      setState(() {
        _subscription = subscription;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _startPremiumPurchase() async {
    try {
      setState(() => _isLoading = true);

      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.currentUser;

      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).msgCannotStartPurchase),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Start purchase flow
      final result = await _billingService.purchaseProduct('premium_lifetime');
      final success = result.success;

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).msgSubscriptionSuccess),
            backgroundColor: Colors.green,
          ),
        );

        // Reload subscription data
        await _loadSubscriptionData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(l10n.subscriptionManagement),
        backgroundColor: isDark ? Colors.grey[900] : const Color(0xFF7B2CBF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorView()
              : _buildSubscriptionContent(isDark, l10n),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadSubscriptionData,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionContent(bool isDark, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current subscription header
          _buildCurrentSubscriptionCard(isDark, l10n),
          const SizedBox(height: 24),

          // Premium benefits section
          _buildSectionTitle(l10n.premiumBenefits, Icons.star),
          const SizedBox(height: 12),
          _buildPremiumBenefitsCard(isDark, l10n),
          const SizedBox(height: 24),

          // Subscription details
          if (_subscription != null) ...[
            _buildSectionTitle(l10n.currentSubscription, Icons.info_outline),
            const SizedBox(height: 12),
            _buildSubscriptionDetailsCard(isDark, l10n),
          ],

          // Upgrade button (if not premium)
          if (_subscription?.type != SubscriptionType.premium) ...[
            const SizedBox(height: 24),
            _buildUpgradeButton(l10n),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentSubscriptionCard(bool isDark, AppLocalizations l10n) {
    final subscription = _subscription;
    final subscriptionName = _getSubscriptionName(subscription?.type, l10n);
    final statusText = _getStatusText(subscription?.status, l10n);
    final isPremium = subscription?.type == SubscriptionType.premium;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPremium
              ? [
                  const Color(0xFF7B2CBF),
                  const Color(0xFF9D4EDD),
                ]
              : isDark
                  ? [Colors.grey[800]!, Colors.grey[700]!]
                  : [
                      const Color(0xFF2196F3),
                      const Color(0xFF1976D2),
                    ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isPremium && subscription != null)
            VIPBadgeWidget(subscription: subscription)
          else
            const Icon(Icons.person, size: 48, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            subscriptionName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          if (subscription?.remainingDays != null) ...[
            const SizedBox(height: 8),
            Text(
              '무료 체험 ${subscription!.remainingDays}일 남음',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPremiumBenefitsCard(bool isDark, AppLocalizations l10n) {
    final benefits = [
      _BenefitItem(Icons.block, '광고 제거', 'Ad-Free Experience'),
      _BenefitItem(Icons.timeline, '60일 확장 프로그램 (Week 1-8)', 'Extended 60-day Program'),
      _BenefitItem(Icons.auto_awesome, 'Lumi 14단계 완전 진화', 'Lumi Full Evolution (14 stages)'),
      _BenefitItem(Icons.psychology, '무제한 AI 꿈 분석', 'Unlimited AI Dream Analysis'),
      _BenefitItem(Icons.analytics, '고급 통계 분석', 'Advanced Analytics'),
      _BenefitItem(Icons.cloud_upload, '데이터 내보내기', 'Export Your Data'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        children: benefits
            .map((benefit) => _buildBenefitItem(benefit, isDark))
            .toList(),
      ),
    );
  }

  Widget _buildBenefitItem(_BenefitItem benefit, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF7B2CBF).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              benefit.icon,
              color: const Color(0xFF7B2CBF),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  benefit.titleKo,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  benefit.titleEn,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle,
            color: Colors.green[600],
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionDetailsCard(bool isDark, AppLocalizations l10n) {
    final subscription = _subscription!;
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            l10n.planLabel,
            _getSubscriptionName(subscription.type, l10n),
            Icons.card_membership,
            isDark,
          ),
          const Divider(height: 24),
          _buildDetailRow(
            l10n.statusLabel,
            _getStatusText(subscription.status, l10n),
            Icons.verified,
            isDark,
          ),
          const Divider(height: 24),
          _buildDetailRow(
            l10n.startDate,
            dateFormat.format(subscription.startDate),
            Icons.calendar_today,
            isDark,
          ),
          const Divider(height: 24),
          _buildDetailRow(
            l10n.expiryDate,
            subscription.endDate != null
                ? dateFormat.format(subscription.endDate!)
                : l10n.unlimited,
            Icons.event,
            isDark,
          ),
          if (subscription.type == SubscriptionType.premium) ...[
            const Divider(height: 24),
            _buildDetailRow(
              '광고 표시',
              subscription.hasAds ? '예' : '아니오 (광고 제거)',
              Icons.block,
              isDark,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: const Color(0xFF7B2CBF)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildUpgradeButton(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7B2CBF),
            Color(0xFF9D4EDD),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B2CBF).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _startPremiumPurchase,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.workspace_premium, size: 24),
            const SizedBox(width: 12),
            Text(
              l10n.btnStartSubscription,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSubscriptionName(SubscriptionType? type, AppLocalizations l10n) {
    if (type == null) return l10n.free;
    switch (type) {
      case SubscriptionType.free:
        return l10n.freePlan;
      case SubscriptionType.launchPromo:
        return l10n.launchPromotion;
      case SubscriptionType.premium:
        return l10n.premium;
    }
  }

  String _getStatusText(SubscriptionStatus? status, AppLocalizations l10n) {
    if (status == null) return l10n.statusExpired;
    switch (status) {
      case SubscriptionStatus.active:
        return l10n.statusActive;
      case SubscriptionStatus.expired:
        return l10n.statusExpired;
      case SubscriptionStatus.cancelled:
        return l10n.statusCancelled;
      case SubscriptionStatus.trial:
        return l10n.statusTrial;
    }
  }
}

class _BenefitItem {
  final IconData icon;
  final String titleKo;
  final String titleEn;

  _BenefitItem(this.icon, this.titleKo, this.titleEn);
}
