import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'payment_verification_service.dart';
import '../data/cloud_sync_service.dart';
import '../../models/user_subscription.dart' as models;

class BillingService {
  static final BillingService _instance = BillingService._internal();
  factory BillingService() => _instance;
  BillingService._internal();

  // 콜백 함수들
  Function? _onAccountRequired; // 회원가입 필요 시 호출
  // TODO: 향후 구매 성공 콜백 기능 구현 시 사용
  Function(String productId, String purchaseToken)? _onPurchaseSuccess; // ignore: unused_field // 구매 성공 시

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  bool _isInitialized = false;
  bool _isAvailable = false;

  // 구독 상품 ID 목록
  static const Set<String> _subscriptionIds = {
    'premium_monthly',
    'premium_yearly',
    'premium_lifetime',
  };

  // 현재 사용 가능한 구독 상품들
  List<ProductDetails> _products = [];

  // 구매 완료 콜백
  Function(PurchaseDetails)? _onPurchaseCompleted;
  Function(String)? _onPurchaseError;

  // 초기화
  Future<bool> initialize() async {
    if (_isInitialized) return _isAvailable;

    try {
      // 인앱 구매 가능 여부 확인
      _isAvailable = await _inAppPurchase.isAvailable();

      if (!_isAvailable) {
        debugPrint('BillingService: In-app purchase not available');
        return false;
      }

      // Android 플랫폼 초기화
      if (Platform.isAndroid) {
        // Android의 pending purchases는 자동으로 처리됨 (최신 버전)
        debugPrint('BillingService: Android platform detected');
      }

      // 구매 스트림 구독
      _subscription = _inAppPurchase.purchaseStream.listen(
        _handlePurchaseUpdates,
        onDone: () => debugPrint('BillingService: Purchase stream closed'),
        onError: (Object error) =>
            debugPrint('BillingService: Purchase stream error: $error'),
      );

      // 상품 정보 로드
      await _loadProducts();

      _isInitialized = true;
      debugPrint('BillingService: Initialized successfully');
      return true;
    } catch (e) {
      debugPrint('BillingService: Initialization failed: $e');
      return false;
    }
  }

  // 상품 정보 로드
  Future<void> _loadProducts() async {
    try {
      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(_subscriptionIds);

      if (response.error != null) {
        debugPrint(
            'BillingService: Failed to load products: ${response.error}');
        return;
      }

      _products = response.productDetails;
      debugPrint('BillingService: Loaded ${_products.length} products');

      for (final product in _products) {
        debugPrint(
            'Product: ${product.id} - ${product.title} - ${product.price}');
      }
    } catch (e) {
      debugPrint('BillingService: Error loading products: $e');
    }
  }

  // 사용 가능한 구독 상품 목록 반환
  List<ProductDetails> getAvailableProducts() {
    return List.unmodifiable(_products);
  }

  // 특정 상품 정보 조회
  ProductDetails? getProduct(String productId) {
    try {
      return _products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  // 구독 구매 시작
  Future<bool> purchaseSubscription(String productId) async {
    if (!_isInitialized || !_isAvailable) {
      debugPrint('BillingService: Not initialized or not available');
      return false;
    }

    final ProductDetails? product = getProduct(productId);
    if (product == null) {
      debugPrint('BillingService: Product not found: $productId');
      return false;
    }

    try {
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);

      final bool success =
          await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

      if (!success) {
        debugPrint(
            'BillingService: Failed to initiate purchase for $productId');
      }

      return success;
    } catch (e) {
      debugPrint('BillingService: Error purchasing $productId: $e');
      return false;
    }
  }

  // 구매 업데이트 처리
  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      debugPrint(
          'BillingService: Purchase update - ${purchaseDetails.productID}: ${purchaseDetails.status}');

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          _handlePendingPurchase(purchaseDetails);
          break;
        case PurchaseStatus.purchased:
          _handleSuccessfulPurchase(purchaseDetails);
          break;
        case PurchaseStatus.error:
          _handleFailedPurchase(purchaseDetails);
          break;
        case PurchaseStatus.canceled:
          _handleCanceledPurchase(purchaseDetails);
          break;
        case PurchaseStatus.restored:
          _handleRestoredPurchase(purchaseDetails);
          break;
      }

      // 처리 완료 표시 (Android)
      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  // 대기 중인 구매 처리
  void _handlePendingPurchase(PurchaseDetails purchaseDetails) {
    debugPrint(
        'BillingService: Purchase pending: ${purchaseDetails.productID}');
  }

  // 성공한 구매 처리
  void _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) {
    debugPrint(
        'BillingService: Purchase successful: ${purchaseDetails.productID}');

    // 구매 검증 수행
    _verifyPurchase(purchaseDetails).then((isValid) {
      if (isValid) {
        _onPurchaseCompleted?.call(purchaseDetails);
        _activateSubscription(purchaseDetails.productID);
      } else {
        debugPrint('BillingService: Purchase verification failed');
        _onPurchaseError?.call('구매 검증에 실패했습니다.');
      }
    });
  }

  // 실패한 구매 처리
  void _handleFailedPurchase(PurchaseDetails purchaseDetails) {
    debugPrint(
        'BillingService: Purchase failed: ${purchaseDetails.productID} - ${purchaseDetails.error}');
    _onPurchaseError
        ?.call('구매에 실패했습니다: ${purchaseDetails.error?.message ?? "알 수 없는 오류"}');
  }

  // 취소된 구매 처리
  void _handleCanceledPurchase(PurchaseDetails purchaseDetails) {
    debugPrint(
        'BillingService: Purchase canceled: ${purchaseDetails.productID}');
  }

  // 복원된 구매 처리
  void _handleRestoredPurchase(PurchaseDetails purchaseDetails) {
    debugPrint(
        'BillingService: Purchase restored: ${purchaseDetails.productID}');
    _activateSubscription(purchaseDetails.productID);
  }

  // 구매 검증 (강화된 검증 시스템 사용)
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      debugPrint(
          'BillingService: Starting purchase verification for ${purchaseDetails.productID}');

      // PaymentVerificationService를 사용한 포괄적 검증
      final verificationResult =
          await PaymentVerificationService.verifyPurchase(purchaseDetails);

      if (verificationResult.isValid) {
        debugPrint('BillingService: Purchase verification successful');

        // 검증 성공 - 구독은 _activateSubscription에서 처리됨
        return true;
      } else {
        debugPrint(
            'BillingService: Purchase verification failed: ${verificationResult.error}');
        return false;
      }
    } catch (e) {
      debugPrint('BillingService: Purchase verification error: $e');
      return false;
    }
  }

  // 구독 활성화
  Future<void> _activateSubscription(String productId) async {
    debugPrint('BillingService: Activating subscription: $productId');

    try {
      final auth = FirebaseAuth.instance;
      final userId = auth.currentUser?.uid;

      // 비회원인 경우 - 회원가입 유도 (구매는 진행됨)
      if (userId == null) {
        debugPrint('⚠️ 비회원 구매 - 회원가입 필요 알림');

        // 구매 토큰 임시 저장 (회원가입 후 처리용)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('pending_purchase_product_id', productId);
        await prefs.setString('pending_purchase_time', DateTime.now().toIso8601String());

        // 콜백으로 회원가입 화면 표시 유도
        if (_onAccountRequired != null) {
          _onAccountRequired!();
        } else {
          debugPrint('⚠️ 회원가입 콜백이 설정되지 않음');
        }

        return;
      }

      // 회원인 경우 - Firestore에 저장
      final cloudSyncService = CloudSyncService();

      // 1. Firestore에 구독 정보 저장 (신뢰할 수 있는 원천)
      final subscription = models.UserSubscription.createPremiumSubscription(userId);
      await cloudSyncService.saveSubscription(subscription);

      // 2. 로컬 캐시 (오프라인 UX 개선용만)
      final prefs = await SharedPreferences.getInstance();
      await cloudSyncService.saveSubscriptionLocally(subscription);
      await prefs.setString('subscription_cache_product_id', productId);
      await prefs.setString('subscription_cache_updated', DateTime.now().toIso8601String());

      // 3. 대기 중인 구매 정보 삭제
      await prefs.remove('pending_purchase_product_id');
      await prefs.remove('pending_purchase_time');

      debugPrint('✅ 구독 상태 Firestore 저장 완료: $productId');
      debugPrint('📱 로컬 캐시 업데이트 완료 (오프라인 UX용)');

      // TODO: Firebase Functions로 영수증 검증 구현 필요
      // await _verifyPurchaseWithServer(productId, purchaseToken);

    } catch (e) {
      debugPrint('❌ 구독 활성화 오류: $e');
      rethrow;
    }
  }

  // 대기 중인 구매 완료 처리 (회원가입 후 호출)
  Future<void> completePendingPurchase() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingProductId = prefs.getString('pending_purchase_product_id');

      if (pendingProductId == null) {
        debugPrint('ℹ️ 대기 중인 구매 없음');
        return;
      }

      debugPrint('🔄 대기 중인 구매 처리 시작: $pendingProductId');

      // 회원가입 후 구독 활성화
      await _activateSubscription(pendingProductId);

      debugPrint('✅ 대기 중인 구매 처리 완료');

    } catch (e) {
      debugPrint('❌ 대기 중인 구매 처리 오류: $e');
    }
  }

  // 구독 복원
  Future<void> restorePurchases() async {
    if (!_isInitialized || !_isAvailable) {
      debugPrint('BillingService: Cannot restore - not initialized');
      return;
    }

    try {
      await _inAppPurchase.restorePurchases();
      debugPrint('BillingService: Restore purchases initiated');
    } catch (e) {
      debugPrint('BillingService: Error restoring purchases: $e');
      _onPurchaseError?.call('구매 복원에 실패했습니다: $e');
    }
  }

  // 현재 구독 상태 확인
  Future<bool> isSubscriptionActive(String productId) async {
    try {
      final auth = FirebaseAuth.instance;
      final userId = auth.currentUser?.uid;

      if (userId == null) {
        debugPrint('BillingService: No user - subscription not active');
        return false;
      }

      final cloudSyncService = CloudSyncService();

      // 1. Firestore에서 구독 상태 확인 (신뢰할 수 있는 원천)
      final subscription = await cloudSyncService.loadSubscription(userId);

      if (subscription == null) {
        debugPrint('BillingService: No subscription found for user');

        // 2. 로컬 캐시 확인 (오프라인 폴백)
        final cachedSubscription = await cloudSyncService.loadSubscriptionLocally();
        if (cachedSubscription != null && cachedSubscription.isValid) {
          debugPrint('⚠️ 오프라인 모드: 캐시된 구독 사용');
          return cachedSubscription.type == models.SubscriptionType.premium;
        }

        return false;
      }

      // 3. 구독 유효성 확인
      final isValid = subscription.isValid;
      final isMatchingProduct = subscription.type == models.SubscriptionType.premium;

      if (isValid && isMatchingProduct) {
        debugPrint('✅ 구독 활성: ${subscription.type}, 남은 일수: ${subscription.remainingDays}');

        // 로컬 캐시 업데이트 (오프라인 대비)
        await cloudSyncService.saveSubscriptionLocally(subscription);

        return true;
      }

      debugPrint('❌ 구독 비활성 또는 만료');
      return false;

    } catch (e) {
      debugPrint('❌ 구독 상태 확인 오류: $e');

      // 오류 시 로컬 캐시 폴백 (네트워크 오류 대응)
      try {
        final cloudSyncService = CloudSyncService();
        final cachedSubscription = await cloudSyncService.loadSubscriptionLocally();
        if (cachedSubscription != null && cachedSubscription.isValid) {
          debugPrint('⚠️ Firestore 오류 - 캐시 사용: ${cachedSubscription.type}');
          return cachedSubscription.type == models.SubscriptionType.premium;
        }
      } catch (cacheError) {
        debugPrint('❌ 캐시 읽기 오류: $cacheError');
      }

      return false;
    }
  }

  // 콜백 설정
  void setPurchaseCallbacks({
    Function(PurchaseDetails)? onPurchaseCompleted,
    Function(String)? onPurchaseError,
  }) {
    _onPurchaseCompleted = onPurchaseCompleted;
    _onPurchaseError = onPurchaseError;
  }

  // 회원가입 필요 콜백 설정
  void setAccountRequiredCallback(Function callback) {
    _onAccountRequired = callback;
  }

  // 구매 성공 콜백 설정
  void setPurchaseSuccessCallback(Function(String, String) callback) {
    _onPurchaseSuccess = callback;
  }

  // 리소스 정리
  void dispose() {
    _subscription.cancel();
    _isInitialized = false;
    debugPrint('BillingService: Disposed');
  }

  // Getter
  bool get isInitialized => _isInitialized;
  bool get isAvailable => _isAvailable;
  List<ProductDetails> get products => List.unmodifiable(_products);

  /// 구독 변경 서비스용 구매 메서드 (alias)
  Future<PurchaseResult> purchaseProduct(String productId) async {
    try {
      final success = await purchaseSubscription(productId);
      if (success) {
        // 성공적인 구매를 시뮬레이션
        return PurchaseResult(
          success: true,
          purchaseDetails: MockPurchaseDetails(productId: productId),
        );
      } else {
        return PurchaseResult(
          success: false,
          error: '구매 실패',
        );
      }
    } catch (e) {
      return PurchaseResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  /// 구독 변경 서비스용 검증 메서드 (alias)
  Future<VerificationResult> verifyPurchase(dynamic purchaseDetails) async {
    try {
      // 기존 _verifyPurchase 메서드 활용
      if (purchaseDetails is PurchaseDetails) {
        final isValid = await _verifyPurchase(purchaseDetails);
        return VerificationResult(isValid: isValid);
      } else if (purchaseDetails is MockPurchaseDetails) {
        // 시뮬레이션 구매 데이터의 경우 항상 valid
        return VerificationResult(
          isValid: true,
          productId: purchaseDetails.productId,
        );
      } else {
        return VerificationResult(isValid: false);
      }
    } catch (e) {
      debugPrint('BillingService: 검증 실패 - $e');
      return VerificationResult(isValid: false);
    }
  }
}

/// 구매 결과 클래스
class PurchaseResult {
  final bool success;
  final String? error;
  final dynamic purchaseDetails;

  PurchaseResult({
    required this.success,
    this.error,
    this.purchaseDetails,
  });
}

/// 검증 결과 클래스
class VerificationResult {
  final bool isValid;
  final String? productId;
  final String? error;

  VerificationResult({
    required this.isValid,
    this.productId,
    this.error,
  });
}

/// 모의 구매 상세정보 (개발용)
class MockPurchaseDetails {
  final String productId;

  MockPurchaseDetails({required this.productId});
}
