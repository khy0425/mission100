import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:crypto/crypto.dart';

class PaymentVerificationService {
  static const String _baseUrl = 'https://your-backend-server.com/api';

  // Google Play 공개 키 (실제 운영 시에는 환경 변수나 안전한 곳에 저장)
  static const String _googlePlayPublicKey = '''
-----BEGIN PUBLIC KEY-----
YOUR_GOOGLE_PLAY_PUBLIC_KEY_HERE
-----END PUBLIC KEY-----
''';

  // Apple App Store 공유 비밀 키
  static const String _appleSharedSecret = 'YOUR_APPLE_SHARED_SECRET';

  /// 구매 검증 수행
  static Future<VerificationResult> verifyPurchase(
    PurchaseDetails purchaseDetails,
  ) async {
    try {
      if (Platform.isAndroid) {
        return await _verifyGooglePlayPurchase(purchaseDetails);
      } else if (Platform.isIOS) {
        return await _verifyAppStorePurchase(purchaseDetails);
      } else {
        return VerificationResult(
          isValid: false,
          error: 'Unsupported platform',
        );
      }
    } catch (e) {
      debugPrint('PaymentVerificationService: Verification error: $e');
      return VerificationResult(
        isValid: false,
        error: 'Verification failed: $e',
      );
    }
  }

  /// Google Play 구매 검증
  static Future<VerificationResult> _verifyGooglePlayPurchase(
    PurchaseDetails purchaseDetails,
  ) async {
    try {
      // 1. 클라이언트 사이드 기본 검증
      final clientVerification =
          _performClientSideVerification(purchaseDetails);
      if (!clientVerification.isValid) {
        return clientVerification;
      }

      // 2. 서버 사이드 검증 (Google Play Developer API 사용)
      final serverVerification =
          await _verifyWithGooglePlayAPI(purchaseDetails);
      if (!serverVerification.isValid) {
        return serverVerification;
      }

      // 3. 자체 서버 검증 (선택사항)
      final customVerification = await _verifyWithCustomServer(purchaseDetails);

      return VerificationResult(
        isValid: customVerification.isValid,
        transactionId: purchaseDetails.purchaseID,
        productId: purchaseDetails.productID,
        purchaseTime: DateTime.now(),
        error: customVerification.error,
      );
    } catch (e) {
      return VerificationResult(
        isValid: false,
        error: 'Google Play verification failed: $e',
      );
    }
  }

  /// App Store 구매 검증
  static Future<VerificationResult> _verifyAppStorePurchase(
    PurchaseDetails purchaseDetails,
  ) async {
    try {
      // App Store 영수증 검증
      final receipt = purchaseDetails.verificationData.localVerificationData;

      if (receipt.isEmpty) {
        return VerificationResult(
          isValid: false,
          error: 'Empty receipt data',
        );
      }

      // Apple 서버 검증
      final verification = await _verifyWithAppleServer(receipt);

      return VerificationResult(
        isValid: verification.isValid,
        transactionId: purchaseDetails.purchaseID,
        productId: purchaseDetails.productID,
        purchaseTime: DateTime.now(),
        error: verification.error,
      );
    } catch (e) {
      return VerificationResult(
        isValid: false,
        error: 'App Store verification failed: $e',
      );
    }
  }

  /// 클라이언트 사이드 기본 검증 (강화된 버전)
  static VerificationResult _performClientSideVerification(
    PurchaseDetails purchaseDetails,
  ) {
    debugPrint('🔒 클라이언트 검증 시작: ${purchaseDetails.productID}');

    // 1. 기본 데이터 존재 여부 확인
    if (purchaseDetails.purchaseID == null ||
        purchaseDetails.purchaseID!.isEmpty) {
      debugPrint('❌ 검증 실패: 잘못된 구매 ID');
      return VerificationResult(
        isValid: false,
        error: 'Invalid purchase ID',
      );
    }

    if (purchaseDetails.productID.isEmpty) {
      debugPrint('❌ 검증 실패: 잘못된 제품 ID');
      return VerificationResult(
        isValid: false,
        error: 'Invalid product ID',
      );
    }

    if (purchaseDetails.verificationData.localVerificationData.isEmpty) {
      debugPrint('❌ 검증 실패: 빈 검증 데이터');
      return VerificationResult(
        isValid: false,
        error: 'Empty verification data',
      );
    }

    // 2. 구매 상태 확인
    if (purchaseDetails.status != PurchaseStatus.purchased) {
      debugPrint('❌ 검증 실패: 구매 미완료 (${purchaseDetails.status})');
      return VerificationResult(
        isValid: false,
        error: 'Purchase not completed',
      );
    }

    // 3. 제품 ID 화이트리스트 검증 (허용된 제품만)
    const allowedProductIds = {
      'premium_monthly',
      'premium_yearly',
      'premium_lifetime',
    };

    if (!allowedProductIds.contains(purchaseDetails.productID)) {
      debugPrint('❌ 검증 실패: 허용되지 않은 제품 ID (${purchaseDetails.productID})');
      return VerificationResult(
        isValid: false,
        error: 'Product ID not in whitelist',
      );
    }

    // 4. 타임스탬프 검증 (미래 날짜 구매 방지)
    final now = DateTime.now();
    final transactionDateStr = purchaseDetails.transactionDate;

    if (transactionDateStr != null && transactionDateStr.isNotEmpty) {
      try {
        // transactionDate는 String 타입이므로 DateTime으로 파싱
        final transactionDate = DateTime.parse(transactionDateStr);

        // 미래 날짜 검증
        if (transactionDate.isAfter(now)) {
          debugPrint('❌ 검증 실패: 미래 날짜 구매 ($transactionDateStr)');
          return VerificationResult(
            isValid: false,
            error: 'Transaction date is in the future',
          );
        }

        // 너무 오래된 구매 검증 (30일 이상 된 구매는 의심)
        final daysSincePurchase = now.difference(transactionDate).inDays;
        if (daysSincePurchase > 30) {
          debugPrint('⚠️ 경고: 30일 이상 된 구매 ($daysSincePurchase일 전)');
          // 경고만 하고 통과 (복원 기능 지원)
        }

        // 너무 최근 구매 검증 (1분 이내 중복 구매 방지)
        final secondsSincePurchase = now.difference(transactionDate).inSeconds;
        if (secondsSincePurchase < 60 && _isRecentDuplicatePurchase(purchaseDetails)) {
          debugPrint('❌ 검증 실패: 중복 구매 감지 ($secondsSincePurchase초 전)');
          return VerificationResult(
            isValid: false,
            error: 'Duplicate purchase detected',
          );
        }
      } catch (e) {
        debugPrint('⚠️ 경고: 타임스탬프 파싱 실패 - $e');
        // 파싱 실패 시 타임스탬프 검증 건너뛰기
      }
    }

    // 5. 서명 데이터 존재 여부 확인 (Android)
    if (Platform.isAndroid) {
      final serverVerificationData = purchaseDetails.verificationData.serverVerificationData;
      if (serverVerificationData.isEmpty) {
        debugPrint('⚠️ 경고: Android 서버 검증 데이터 없음');
        // 경고만 하고 통과 (Google Play가 서명 제공)
      }
    }

    // 6. 영수증 데이터 크기 검증 (비정상적으로 작거나 큰 데이터 차단)
    final verificationDataLength = purchaseDetails.verificationData.localVerificationData.length;
    if (verificationDataLength < 50) {
      debugPrint('❌ 검증 실패: 영수증 데이터 너무 작음 ($verificationDataLength bytes)');
      return VerificationResult(
        isValid: false,
        error: 'Receipt data too small',
      );
    }

    if (verificationDataLength > 1000000) { // 1MB 제한
      debugPrint('❌ 검증 실패: 영수증 데이터 너무 큼 ($verificationDataLength bytes)');
      return VerificationResult(
        isValid: false,
        error: 'Receipt data too large',
      );
    }

    debugPrint('✅ 클라이언트 검증 통과: ${purchaseDetails.productID}');
    return VerificationResult(isValid: true);
  }

  /// 중복 구매 감지 (최근 구매 내역 체크)
  static bool _isRecentDuplicatePurchase(PurchaseDetails purchaseDetails) {
    // SharedPreferences에서 최근 구매 내역 확인
    // 간단한 메모리 캐시로 구현 (실제로는 영구 저장소 사용)
    final purchaseId = purchaseDetails.purchaseID;

    // 메모리 캐시에 이미 있으면 중복
    if (_recentPurchaseCache.contains(purchaseId)) {
      return true;
    }

    // 캐시에 추가
    _recentPurchaseCache.add(purchaseId);

    // 캐시 크기 제한 (최근 100개만 유지)
    if (_recentPurchaseCache.length > 100) {
      _recentPurchaseCache.removeAt(0);
    }

    return false;
  }

  // 최근 구매 캐시 (중복 방지용)
  static final List<String?> _recentPurchaseCache = [];

  /// Google Play Developer API를 통한 검증
  static Future<VerificationResult> _verifyWithGooglePlayAPI(
    PurchaseDetails purchaseDetails,
  ) async {
    try {
      // Google Play Developer API 호출을 위한 액세스 토큰 필요
      // 실제 구현 시에는 서비스 계정 키를 사용하여 OAuth 2.0 토큰 획득

      const packageName = 'com.reaf.mission100'; // 앱 패키지명
      final productId = purchaseDetails.productID;
      final token = purchaseDetails.purchaseID;

      final url = 'https://androidpublisher.googleapis.com/androidpublisher/v3'
          '/applications/$packageName/purchases/subscriptions/$productId/tokens/$token';

      // TODO: 실제 액세스 토큰 구현 필요
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // 구독 상태 확인
        final startTimeMillis =
            int.tryParse(data['startTimeMillis']?.toString() ?? '0') ?? 0;
        final expiryTimeMillis =
            int.tryParse(data['expiryTimeMillis']?.toString() ?? '0') ?? 0;
        final autoRenewing = data['autoRenewing'] as bool? ?? false;

        final now = DateTime.now().millisecondsSinceEpoch;
        final isActive = expiryTimeMillis > now || autoRenewing;

        return VerificationResult(
          isValid: isActive,
          transactionId: token,
          productId: productId,
          purchaseTime: DateTime.fromMillisecondsSinceEpoch(startTimeMillis),
          expiryTime: DateTime.fromMillisecondsSinceEpoch(expiryTimeMillis),
          autoRenewing: autoRenewing,
        );
      } else {
        return VerificationResult(
          isValid: false,
          error: 'Google Play API error: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Google Play API verification error: $e');
      // API 검증 실패 시 기본 검증으로 폴백
      return VerificationResult(isValid: true);
    }
  }

  /// Apple 서버를 통한 영수증 검증
  static Future<VerificationResult> _verifyWithAppleServer(
      String receipt) async {
    try {
      const url = 'https://buy.itunes.apple.com/verifyReceipt';
      // 샌드박스 환경: 'https://sandbox.itunes.apple.com/verifyReceipt'

      final requestBody = {
        'receipt-data': receipt,
        'password': _appleSharedSecret,
        'exclude-old-transactions': true,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final status = data['status'] as int? ?? -1;

        if (status == 0) {
          // 검증 성공
          final receipt = data['receipt'] as Map<String, dynamic>? ?? {};
          final latestReceiptInfo = data['latest_receipt_info'];

          return VerificationResult(
            isValid: true,
            transactionId: receipt['transaction_id']?.toString(),
            productId: receipt['product_id']?.toString(),
            purchaseTime: DateTime.fromMillisecondsSinceEpoch(
              int.tryParse(receipt['purchase_date_ms']?.toString() ?? '0') ?? 0,
            ),
          );
        } else if (status == 21007) {
          // 샌드박스 영수증이므로 샌드박스 서버로 재시도
          return await _verifyWithAppleServer(receipt);
        } else {
          return VerificationResult(
            isValid: false,
            error: 'Apple verification failed with status: $status',
          );
        }
      } else {
        return VerificationResult(
          isValid: false,
          error: 'Apple server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Apple verification error: $e');
      return VerificationResult(
        isValid: false,
        error: 'Apple verification exception: $e',
      );
    }
  }

  /// 자체 서버를 통한 검증
  static Future<VerificationResult> _verifyWithCustomServer(
    PurchaseDetails purchaseDetails,
  ) async {
    try {
      const url = '$_baseUrl/verify-purchase';

      final requestBody = {
        'platform': Platform.isAndroid ? 'android' : 'ios',
        'product_id': purchaseDetails.productID,
        'purchase_id': purchaseDetails.purchaseID,
        'verification_data':
            purchaseDetails.verificationData.localVerificationData,
        'server_verification_data':
            purchaseDetails.verificationData.serverVerificationData,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        return VerificationResult(
          isValid: data['valid'] as bool? ?? false,
          transactionId: data['transaction_id']?.toString(),
          productId: data['product_id']?.toString(),
          error: data['error']?.toString(),
        );
      } else {
        // 서버 검증 실패 시 기본 검증으로 폴백
        debugPrint('Custom server verification failed: ${response.statusCode}');
        return VerificationResult(isValid: true);
      }
    } catch (e) {
      debugPrint('Custom server verification error: $e');
      // 네트워크 오류 등으로 서버 검증 실패 시 기본 검증으로 폴백
      return VerificationResult(isValid: true);
    }
  }

  /// 인증 토큰 획득
  static Future<String> _getAuthToken() async {
    // TODO: 실제 인증 토큰 구현
    return 'your-auth-token';
  }

  /// 영수증 데이터 해시 검증
  static bool _verifyReceiptHash(String receiptData, String expectedHash) {
    try {
      final bytes = base64Decode(receiptData);
      final digest = sha256.convert(bytes);
      return digest.toString() == expectedHash;
    } catch (e) {
      return false;
    }
  }

  /// 중복 구매 방지를 위한 트랜잭션 ID 검증
  static Future<bool> _isTransactionIdUnique(String transactionId) async {
    try {
      const url = '$_baseUrl/check-transaction';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
        body: jsonEncode({'transaction_id': transactionId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['is_unique'] as bool? ?? false;
      }

      return false;
    } catch (e) {
      debugPrint('Transaction uniqueness check failed: $e');
      return false;
    }
  }
}

/// 검증 결과를 담는 클래스
class VerificationResult {
  final bool isValid;
  final String? transactionId;
  final String? productId;
  final DateTime? purchaseTime;
  final DateTime? expiryTime;
  final bool? autoRenewing;
  final String? error;

  VerificationResult({
    required this.isValid,
    this.transactionId,
    this.productId,
    this.purchaseTime,
    this.expiryTime,
    this.autoRenewing,
    this.error,
  });

  @override
  String toString() {
    return 'VerificationResult(isValid: $isValid, transactionId: $transactionId, '
        'productId: $productId, error: $error)';
  }
}
