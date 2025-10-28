import 'package:flutter/material.dart';
import '../services/subscription_service.dart';
import '../services/subscription_change_service.dart';
import '../services/subscription_cancellation_service.dart';

/// 구독 관리 화면
class SubscriptionManagementScreen extends StatefulWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  State<SubscriptionManagementScreen> createState() =>
      _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState
    extends State<SubscriptionManagementScreen> {
  final SubscriptionService _subscriptionService = SubscriptionService();
  // final SubscriptionChangeService _changeService = SubscriptionChangeService();
  // final SubscriptionCancellationService _cancellationService = SubscriptionCancellationService();

  UserSubscription? _currentSubscription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionInfo();
  }

  Future<void> _loadSubscriptionInfo() async {
    setState(() => _isLoading = true);

    try {
      final subscription = await _subscriptionService.getCurrentSubscription();
      setState(() {
        _currentSubscription = subscription;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('구독 정보를 불러오는 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('구독 관리'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentSubscription == null
              ? _buildNoSubscriptionView()
              : _buildSubscriptionManagementView(),
    );
  }

  Widget _buildNoSubscriptionView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.card_membership,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '활성 구독이 없습니다',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            '프리미엄 기능을 이용하려면 구독을 시작하세요',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // 구독 화면으로 이동
              Navigator.pushNamed(context, '/subscription');
            },
            child: const Text('구독 시작하기'),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionManagementView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentSubscriptionCard(),
          const SizedBox(height: 24),
          _buildSubscriptionActionsSection(),
          const SizedBox(height: 24),
          _buildSubscriptionHistorySection(),
        ],
      ),
    );
  }

  Widget _buildCurrentSubscriptionCard() {
    final subscription = _currentSubscription!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.workspace_premium,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  '현재 구독',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSubscriptionDetail(
                '플랜', _getProductName(subscription.productId)),
            _buildSubscriptionDetail('상태', _getStatusText(subscription.status)),
            _buildSubscriptionDetail(
                '시작일', _formatDate(subscription.startDate)),
            _buildSubscriptionDetail(
                '만료일', _formatDate(subscription.expiryDate)),
            if (subscription.autoRenewing) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '자동 갱신 활성화',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '구독 관리',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          icon: Icons.upgrade,
          title: '플랜 변경',
          subtitle: '다른 구독 플랜으로 변경하기',
          onTap: _showChangeSubscriptionDialog,
        ),
        const SizedBox(height: 8),
        _buildActionCard(
          icon: Icons.cancel,
          title: '구독 취소',
          subtitle: '구독을 취소하고 자동 갱신 중단',
          onTap: _showCancelSubscriptionDialog,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isDestructive
              ? Colors.red.withValues(alpha: 0.1)
              : Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : Theme.of(context).primaryColor,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSubscriptionHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '구독 기록',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          icon: Icons.history,
          title: '변경 기록',
          subtitle: '구독 플랜 변경 이력 보기',
          onTap: _showChangeHistory,
        ),
        const SizedBox(height: 8),
        _buildActionCard(
          icon: Icons.receipt,
          title: '결제 기록',
          subtitle: '결제 및 환불 기록 보기',
          onTap: _showPaymentHistory,
        ),
      ],
    );
  }

  void _showChangeSubscriptionDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => _SubscriptionChangeDialog(
        currentProductId: _currentSubscription!.productId,
        onChanged: () {
          _loadSubscriptionInfo();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showCancelSubscriptionDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => _SubscriptionCancelDialog(
        currentSubscription: _currentSubscription!,
        onCancelled: () {
          _loadSubscriptionInfo();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showChangeHistory() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const _SubscriptionHistoryScreen(
          historyType: _HistoryType.changes,
        ),
      ),
    );
  }

  void _showPaymentHistory() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const _SubscriptionHistoryScreen(
          historyType: _HistoryType.payments,
        ),
      ),
    );
  }

  String _getProductName(String productId) {
    switch (productId) {
      case 'premium_monthly':
        return '프리미엄 월간';
      case 'premium_yearly':
        return '프리미엄 연간';
      case 'premium_lifetime':
        return '프리미엄 평생';
      default:
        return '알 수 없음';
    }
  }

  String _getStatusText(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.active:
        return '활성';
      case SubscriptionStatus.expired:
        return '만료됨';
      case SubscriptionStatus.cancelled:
        return '취소됨';
      case SubscriptionStatus.cancelledAtPeriodEnd:
        return '취소 예정';
      case SubscriptionStatus.paused:
        return '일시정지';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}

/// 구독 변경 다이얼로그
class _SubscriptionChangeDialog extends StatefulWidget {
  final String currentProductId;
  final VoidCallback onChanged;

  const _SubscriptionChangeDialog({
    required this.currentProductId,
    required this.onChanged,
  });

  @override
  State<_SubscriptionChangeDialog> createState() =>
      _SubscriptionChangeDialogState();
}

class _SubscriptionChangeDialogState extends State<_SubscriptionChangeDialog> {
  final SubscriptionChangeService _changeService = SubscriptionChangeService();
  String? _selectedProductId;
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _availableProducts = [
    {
      'id': 'premium_monthly',
      'name': '프리미엄 월간',
      'price': '₩4,990',
      'description': '매월 결제',
    },
    {
      'id': 'premium_yearly',
      'name': '프리미엄 연간',
      'price': '₩29,990',
      'description': '연간 결제 (50% 할인)',
    },
    {
      'id': 'premium_lifetime',
      'name': '프리미엄 평생',
      'price': '₩99,990',
      'description': '한 번 결제로 평생 이용',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final availableProducts = _availableProducts
        .where((product) => product['id'] != widget.currentProductId)
        .toList();

    return AlertDialog(
      title: const Text('구독 플랜 변경'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('변경할 구독 플랜을 선택하세요'),
            const SizedBox(height: 16),
            ...availableProducts.map((product) => _buildProductOption(product)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _isProcessing || _selectedProductId == null
              ? null
              : _processSubscriptionChange,
          child: _isProcessing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('변경하기'),
        ),
      ],
    );
  }

  Widget _buildProductOption(Map<String, dynamic> product) {
    return
        // ignore: deprecated_member_use
        RadioListTile<String>(
      value: product['id'] as String,
      // ignore: deprecated_member_use
      groupValue: _selectedProductId,
      // ignore: deprecated_member_use
      onChanged: (value) {
        setState(() => _selectedProductId = value);
      },
      title: Text(product['name'] as String),
      subtitle: Text('${product['price']} - ${product['description']}'),
    );
  }

  Future<void> _processSubscriptionChange() async {
    if (_selectedProductId == null) return;

    setState(() => _isProcessing = true);

    try {
      final result = await _changeService.requestSubscriptionChange(
        currentProductId: widget.currentProductId,
        newProductId: _selectedProductId!,
        immediate: true,
      );

      if (result.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('구독 플랜이 변경되었습니다.')),
          );
          widget.onChanged();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.error ?? '구독 변경에 실패했습니다.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }
}

/// 구독 취소 다이얼로그
class _SubscriptionCancelDialog extends StatefulWidget {
  final UserSubscription currentSubscription;
  final VoidCallback onCancelled;

  const _SubscriptionCancelDialog({
    required this.currentSubscription,
    required this.onCancelled,
  });

  @override
  State<_SubscriptionCancelDialog> createState() =>
      _SubscriptionCancelDialogState();
}

class _SubscriptionCancelDialogState extends State<_SubscriptionCancelDialog> {
  final SubscriptionCancellationService _cancellationService =
      SubscriptionCancellationService();
  final TextEditingController _reasonController = TextEditingController();

  CancellationType _cancellationType = CancellationType.endOfPeriod;
  CancellationReason _reason = CancellationReason.other;
  bool _requestRefund = false;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('구독 취소'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('구독을 취소하시겠습니까?'),
              const SizedBox(height: 16),
              _buildCancellationTypeSection(),
              const SizedBox(height: 16),
              _buildCancellationReasonSection(),
              const SizedBox(height: 16),
              _buildRefundSection(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _isProcessing ? null : _processCancellation,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: _isProcessing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('구독 취소'),
        ),
      ],
    );
  }

  Widget _buildCancellationTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('취소 방식', style: TextStyle(fontWeight: FontWeight.w500)),
        // ignore: deprecated_member_use
        RadioListTile<CancellationType>(
          value: CancellationType.endOfPeriod,
          // ignore: deprecated_member_use
          groupValue: _cancellationType,
          // ignore: deprecated_member_use
          onChanged: (value) {
            setState(() => _cancellationType = value!);
          },
          title: const Text('현재 구독 기간 종료 후 취소'),
          subtitle: Text(
              '${widget.currentSubscription.expiryDate.year}.${widget.currentSubscription.expiryDate.month}.${widget.currentSubscription.expiryDate.day}까지 이용 가능'),
        ),
        // ignore: deprecated_member_use
        RadioListTile<CancellationType>(
          value: CancellationType.immediate,
          // ignore: deprecated_member_use
          groupValue: _cancellationType,
          // ignore: deprecated_member_use
          onChanged: (value) {
            setState(() => _cancellationType = value!);
          },
          title: const Text('즉시 취소'),
          subtitle: const Text('지금 바로 구독을 취소합니다'),
        ),
      ],
    );
  }

  Widget _buildCancellationReasonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('취소 사유', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        DropdownButtonFormField<CancellationReason>(
          // ignore: deprecated_member_use
          value: _reason,
          onChanged: (value) {
            setState(() => _reason = value!);
          },
          items: CancellationReason.values.map((reason) {
            return DropdownMenuItem(
              value: reason,
              child:
                  Text(_cancellationService.getCancellationReasonText(reason)),
            );
          }).toList(),
        ),
        if (_reason == CancellationReason.other) ...[
          const SizedBox(height: 8),
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(
              labelText: '상세 사유',
              hintText: '취소 사유를 입력해주세요',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ],
    );
  }

  Widget _buildRefundSection() {
    return CheckboxListTile(
      value: _requestRefund,
      onChanged: (value) {
        setState(() => _requestRefund = value ?? false);
      },
      title: const Text('환불 요청'),
      subtitle: const Text('환불 처리는 3-5일이 소요될 수 있습니다'),
    );
  }

  Future<void> _processCancellation() async {
    setState(() => _isProcessing = true);

    try {
      final result = await _cancellationService.requestCancellation(
        productId: widget.currentSubscription.productId,
        type: _cancellationType,
        reason: _reason,
        reasonText:
            _reason == CancellationReason.other ? _reasonController.text : null,
        requestRefund: _requestRefund,
      );

      if (result.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('구독이 취소되었습니다.')),
          );
          widget.onCancelled();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.error ?? '구독 취소에 실패했습니다.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}

/// 구독 기록 화면
enum _HistoryType { changes, payments }

class _SubscriptionHistoryScreen extends StatefulWidget {
  final _HistoryType historyType;

  const _SubscriptionHistoryScreen({
    required this.historyType,
  });

  @override
  State<_SubscriptionHistoryScreen> createState() =>
      _SubscriptionHistoryScreenState();
}

class _SubscriptionHistoryScreenState
    extends State<_SubscriptionHistoryScreen> {
  final SubscriptionChangeService _changeService = SubscriptionChangeService();
  final SubscriptionCancellationService _cancellationService =
      SubscriptionCancellationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.historyType == _HistoryType.changes ? '변경 기록' : '결제 기록'),
      ),
      body: widget.historyType == _HistoryType.changes
          ? _buildChangeHistory()
          : _buildPaymentHistory(),
    );
  }

  Widget _buildChangeHistory() {
    return FutureBuilder<List<SubscriptionChangeInfo>>(
      future: _changeService.getSubscriptionChangeHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('오류: ${snapshot.error}'));
        }

        final changes = snapshot.data ?? [];

        if (changes.isEmpty) {
          return const Center(child: Text('변경 기록이 없습니다.'));
        }

        return ListView.builder(
          itemCount: changes.length,
          itemBuilder: (context, index) {
            final change = changes[index];
            return ListTile(
              title: Text('${change.fromProductId} → ${change.toProductId}'),
              subtitle: Text(change.changeDate.toString()),
              trailing: Text(change.status.toString()),
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentHistory() {
    return FutureBuilder<List<CancellationInfo>>(
      future: _cancellationService.getCancellationHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('오류: ${snapshot.error}'));
        }

        final cancellations = snapshot.data ?? [];

        if (cancellations.isEmpty) {
          return const Center(child: Text('취소 기록이 없습니다.'));
        }

        return ListView.builder(
          itemCount: cancellations.length,
          itemBuilder: (context, index) {
            final cancellation = cancellations[index];
            return ListTile(
              title: Text(cancellation.productId),
              subtitle: Text(cancellation.cancellationDate.toString()),
              trailing: Text(cancellation.status.toString()),
            );
          },
        );
      },
    );
  }
}
