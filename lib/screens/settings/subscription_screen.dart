import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucid_dream_100/generated/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../services/auth/auth_service.dart';
import '../../services/payment/billing_service.dart';
import '../../models/user_subscription.dart';
import '../../widgets/common/vip_badge_widget.dart';
import '../../utils/config/constants.dart';

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
      await _billingService.initialize();
      if (!mounted) return;
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

      final result = await _billingService.purchaseProduct('premium_monthly');
      final success = result.success;

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).msgSubscriptionSuccess),
            backgroundColor: Colors.green,
          ),
        );
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
      body: CustomScrollView(
        slivers: [
          // 아름다운 그라데이션 앱바
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                l10n.subscriptionManagement,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF2D1F3D), const Color(0xFF1A1625)]
                        : [
                            const Color(AppColors.primaryColor),
                            const Color(AppColors.secondaryColor),
                            const Color(AppColors.accentColor),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // 장식 원들
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha:0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: -30,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha:0.08),
                        ),
                      ),
                    ),
                    // 프리미엄 아이콘
                    Positioned(
                      top: 50,
                      right: 30,
                      child: Icon(
                        Icons.workspace_premium,
                        size: 36,
                        color: Colors.white.withValues(alpha:0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 컨텐츠
          SliverToBoxAdapter(
            child: _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(60),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _errorMessage != null
                    ? _buildErrorView()
                    : _buildSubscriptionContent(isDark, l10n, theme),
          ),
        ],
      ),
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

  Widget _buildSubscriptionContent(bool isDark, AppLocalizations l10n, ThemeData theme) {
    final isPremium = _subscription?.type == SubscriptionType.premium;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(AppColors.backgroundDark)
            : const Color(AppColors.backgroundLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 현재 구독 상태 카드
            _buildCurrentSubscriptionCard(isDark, l10n, theme),

            const SizedBox(height: 20),

            // 프리미엄이 아닐 때만 업그레이드 버튼 표시 (상단에 배치)
            if (!isPremium) ...[
              _buildUpgradeButton(l10n, theme),
              const SizedBox(height: 24),
            ],

            // 프리미엄 혜택 섹션
            _buildSectionTitle(l10n.premiumBenefits, Icons.star, theme),
            const SizedBox(height: 12),
            _buildPremiumBenefitsCard(isDark, l10n, theme),

            // 구독 상세 정보
            if (_subscription != null) ...[
              const SizedBox(height: 24),
              _buildSectionTitle(l10n.currentSubscription, Icons.info_outline, theme),
              const SizedBox(height: 12),
              _buildSubscriptionDetailsCard(isDark, l10n, theme),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentSubscriptionCard(bool isDark, AppLocalizations l10n, ThemeData theme) {
    final subscription = _subscription;
    final subscriptionName = _getSubscriptionName(subscription?.type, l10n);
    final statusText = _getStatusText(subscription?.status, l10n);
    final isPremium = subscription?.type == SubscriptionType.premium;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPremium
              ? [theme.primaryColor, theme.primaryColor.withValues(alpha:0.7)]
              : isDark
                  ? [Colors.grey[800]!, Colors.grey[700]!]
                  : [Colors.blue[400]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isPremium ? theme.primaryColor : Colors.blue).withValues(alpha:0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isPremium && subscription != null)
            VIPBadgeWidget(subscription: subscription, size: VIPBadgeSize.large)
          else
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha:0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 36, color: Colors.white),
            ),
          const SizedBox(height: 16),
          Text(
            subscriptionName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          if (subscription?.remainingDays != null) ...[
            const SizedBox(height: 12),
            Text(
              l10n.subscriptionFreeTrialRemaining(subscription!.remainingDays.toString()),
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha:0.85),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUpgradeButton(AppLocalizations l10n, ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColor.withValues(alpha:0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha:0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _startPremiumPurchase,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.workspace_premium, size: 26, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              l10n.btnStartSubscription,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumBenefitsCard(bool isDark, AppLocalizations l10n, ThemeData theme) {
    final benefits = [
      _BenefitItem(Icons.block, l10n.subscriptionBenefitAdFree, 'Ad-Free Experience'),
      _BenefitItem(Icons.auto_awesome, l10n.subscriptionBenefitLumiEvolution, 'Lumi Full Evolution'),
      _BenefitItem(Icons.psychology, l10n.subscriptionBenefitUnlimitedAI, 'Unlimited AI Analysis'),
      _BenefitItem(Icons.analytics, l10n.subscriptionBenefitAdvancedAnalytics, 'Advanced Analytics'),
      _BenefitItem(Icons.cloud_upload, l10n.subscriptionBenefitDataExport, 'Export Your Data'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900]!.withValues(alpha:0.5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha:0.3)
                : theme.primaryColor.withValues(alpha:0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey[800]! : theme.primaryColor.withValues(alpha:0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: benefits.asMap().entries.map((entry) {
          final index = entry.key;
          final benefit = entry.value;
          return _buildBenefitItem(benefit, isDark, theme, isLast: index == benefits.length - 1);
        }).toList(),
      ),
    );
  }

  Widget _buildBenefitItem(_BenefitItem benefit, bool isDark, ThemeData theme, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha:0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  benefit.icon,
                  color: theme.primaryColor,
                  size: 22,
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
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      benefit.titleEn,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.check_circle,
                color: Colors.green[500],
                size: 22,
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 76,
            color: isDark ? Colors.grey[800] : Colors.grey[200],
          ),
      ],
    );
  }

  Widget _buildSubscriptionDetailsCard(bool isDark, AppLocalizations l10n, ThemeData theme) {
    final subscription = _subscription!;
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900]!.withValues(alpha:0.5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha:0.3)
                : theme.primaryColor.withValues(alpha:0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey[800]! : theme.primaryColor.withValues(alpha:0.1),
          width: 1,
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
            theme,
          ),
          _buildDivider(isDark),
          _buildDetailRow(
            l10n.statusLabel,
            _getStatusText(subscription.status, l10n),
            Icons.verified,
            isDark,
            theme,
          ),
          _buildDivider(isDark),
          _buildDetailRow(
            l10n.startDate,
            dateFormat.format(subscription.startDate),
            Icons.calendar_today,
            isDark,
            theme,
          ),
          _buildDivider(isDark),
          _buildDetailRow(
            l10n.expiryDate,
            subscription.endDate != null
                ? dateFormat.format(subscription.endDate!)
                : l10n.unlimited,
            Icons.event,
            isDark,
            theme,
          ),
          if (subscription.type == SubscriptionType.premium) ...[
            _buildDivider(isDark),
            _buildDetailRow(
              l10n.subscriptionAdsLabel,
              subscription.hasAds ? l10n.subscriptionAdsYes : l10n.subscriptionAdsNoWithAdFree,
              Icons.block,
              isDark,
              theme,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        height: 1,
        color: isDark ? Colors.grey[800] : Colors.grey[200],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, bool isDark, ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
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

  Widget _buildSectionTitle(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
            letterSpacing: 0.3,
          ),
        ),
      ],
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
