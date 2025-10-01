import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../services/billing_service.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final BillingService _billingService = BillingService();
  List<ProductDetails> _products = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isProcessingPurchase = false;

  @override
  void initState() {
    super.initState();
    _initializeBilling();
  }

  Future<void> _initializeBilling() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // BillingService 초기화
      final success = await _billingService.initialize();

      if (!success) {
        setState(() {
          _errorMessage = '인앱 구매를 사용할 수 없습니다.';
          _isLoading = false;
        });
        return;
      }

      // 구매 콜백 설정
      _billingService.setPurchaseCallbacks(
        onPurchaseCompleted: _onPurchaseCompleted,
        onPurchaseError: _onPurchaseError,
      );

      // 상품 목록 로드
      _loadProducts();
    } catch (e) {
      setState(() {
        _errorMessage = 'Billing 초기화 실패: $e';
        _isLoading = false;
      });
    }
  }

  void _loadProducts() {
    setState(() {
      _products = _billingService.getAvailableProducts();
      _isLoading = false;
    });

    if (_products.isEmpty) {
      setState(() {
        _errorMessage = '사용 가능한 구독 상품이 없습니다.';
      });
    }
  }

  void _onPurchaseCompleted(PurchaseDetails purchaseDetails) {
    setState(() {
      _isProcessingPurchase = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('구독이 성공적으로 완료되었습니다!'),
        backgroundColor: Colors.green,
      ),
    );

    // 화면 닫기
    Navigator.of(context).pop(true);
  }

  void _onPurchaseError(String error) {
    setState(() {
      _isProcessingPurchase = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _purchaseProduct(ProductDetails product) async {
    if (_isProcessingPurchase) return;

    setState(() {
      _isProcessingPurchase = true;
    });

    final success = await _billingService.purchaseSubscription(product.id);

    if (!success) {
      setState(() {
        _isProcessingPurchase = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('구매를 시작할 수 없습니다.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _restorePurchases() async {
    await _billingService.restorePurchases();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('구매 복원을 시도했습니다.'),
      ),
    );
  }

  String _getProductTitle(String productId) {
    switch (productId) {
      case 'premium_monthly':
        return '월간 프리미엄';
      case 'premium_yearly':
        return '연간 프리미엄';
      case 'premium_lifetime':
        return '평생 프리미엄';
      default:
        return productId;
    }
  }

  String _getProductDescription(String productId) {
    switch (productId) {
      case 'premium_monthly':
        return '• 무제한 운동 기록\n• 고급 통계 분석\n• 광고 제거\n• 프리미엄 기가차드';
      case 'premium_yearly':
        return '• 월간 대비 50% 할인\n• 무제한 운동 기록\n• 고급 통계 분석\n• 광고 제거\n• 프리미엄 기가차드\n• 독점 도전과제';
      case 'premium_lifetime':
        return '• 일회성 결제로 평생 이용\n• 모든 프리미엄 기능\n• 향후 업데이트 무료\n• VIP 고객 지원';
      default:
        return '';
    }
  }

  Color _getProductColor(String productId) {
    switch (productId) {
      case 'premium_monthly':
        return Colors.blue;
      case 'premium_yearly':
        return Colors.purple;
      case 'premium_lifetime':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프리미엄 구독'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _restorePurchases,
            tooltip: '구매 복원',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('구독 상품을 불러오는 중...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeBilling,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // 헤더
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Column(
            children: [
              Icon(
                Icons.workspace_premium,
                size: 64,
                color: Colors.white,
              ),
              SizedBox(height: 16),
              Text(
                '프리미엄으로 업그레이드',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '최고의 운동 경험을 누려보세요',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),

        // 구독 상품 목록
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return _buildProductCard(product);
            },
          ),
        ),

        // 하단 안내
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                '• 언제든지 설정에서 구독을 취소할 수 있습니다\n• 구독은 자동으로 갱신됩니다\n• 취소는 다음 결제 주기 전에 해야 합니다',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  // 이용약관 표시
                },
                child: const Text('이용약관 및 개인정보처리방침'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(ProductDetails product) {
    final color = _getProductColor(product.id);
    final isPopular = product.id == 'premium_yearly';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: isPopular
                  ? BorderSide(color: color, width: 2)
                  : BorderSide.none,
            ),
            child: InkWell(
              onTap: _isProcessingPurchase
                  ? null
                  : () => _purchaseProduct(product),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.workspace_premium,
                            color: color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getProductTitle(product.id),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                product.price,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getProductDescription(product.id),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isProcessingPurchase
                            ? null
                            : () => _purchaseProduct(product),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isProcessingPurchase
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                '구독하기',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isPopular)
            Positioned(
              top: 0,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: const Text(
                  '인기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // 필요시 리소스 정리
    super.dispose();
  }
}
