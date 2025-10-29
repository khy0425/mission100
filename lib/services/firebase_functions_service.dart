import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Firebase Functions 호출 서비스
///
/// 서버 사이드 작업을 처리합니다:
/// - IAP 영수증 검증
/// - 구독 상태 확인
class FirebaseFunctionsService {
  static final FirebaseFunctionsService _instance =
      FirebaseFunctionsService._internal();
  factory FirebaseFunctionsService() => _instance;
  FirebaseFunctionsService._internal();

  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// 구매 영수증을 서버에서 검증합니다
  ///
  /// [packageName]: 앱 패키지명 (예: com.mission100.app)
  /// [productId]: 제품 ID (예: premium_monthly)
  /// [purchaseToken]: Google Play 구매 토큰
  /// [userId]: 사용자 ID
  ///
  /// Returns: 검증 결과 (성공 여부, 만료 시간 등)
  Future<PurchaseVerificationResult> verifyPurchaseOnServer({
    required String packageName,
    required String productId,
    required String purchaseToken,
    required String userId,
  }) async {
    try {
      debugPrint('🔐 서버 영수증 검증 시작...');
      debugPrint('   Package: $packageName');
      debugPrint('   Product: $productId');
      debugPrint('   User: $userId');

      // Firebase Functions 호출
      final callable = _functions.httpsCallable('verifyPurchase');
      final result = await callable.call({
        'packageName': packageName,
        'productId': productId,
        'purchaseToken': purchaseToken,
        'userId': userId,
      });

      final data = result.data as Map<String, dynamic>;

      if (data['success'] == true) {
        if (data['verified'] == true) {
          debugPrint('✅ 서버 검증 성공!');
          debugPrint('   만료: ${data['expiryTime']}');

          return PurchaseVerificationResult(
            success: true,
            verified: true,
            expiryTime: data['expiryTime'],
          );
        } else {
          debugPrint('❌ 서버 검증 실패: ${data['reason']}');
          return PurchaseVerificationResult(
            success: true,
            verified: false,
            errorMessage: data['reason'],
          );
        }
      } else {
        debugPrint('❌ 서버 검증 오류: ${data['error']}');
        return PurchaseVerificationResult(
          success: false,
          verified: false,
          errorMessage: data['error'],
        );
      }
    } catch (e) {
      debugPrint('❌ 서버 검증 예외: $e');
      return PurchaseVerificationResult(
        success: false,
        verified: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// PurchaseDetails에서 정보를 추출하여 서버 검증
  Future<PurchaseVerificationResult> verifyPurchase({
    required PurchaseDetails purchaseDetails,
    required String userId,
  }) async {
    try {
      // Google Play 구매 정보 추출
      final verificationData = purchaseDetails.verificationData;
      final serverVerificationData = verificationData.serverVerificationData;

      // 패키지명 추출 (Android만 해당)
      const packageName = 'com.mission100.app'; // 기본값

      // 실제 구현에서는 packageName을 동적으로 가져와야 함
      // package_info_plus 패키지 사용 권장

      return await verifyPurchaseOnServer(
        packageName: packageName,
        productId: purchaseDetails.productID,
        purchaseToken: serverVerificationData,
        userId: userId,
      );
    } catch (e) {
      debugPrint('❌ 구매 정보 추출 실패: $e');
      return PurchaseVerificationResult(
        success: false,
        verified: false,
        errorMessage: e.toString(),
      );
    }
  }
}

/// 구매 검증 결과
class PurchaseVerificationResult {
  final bool success; // API 호출 성공 여부
  final bool verified; // 영수증 검증 성공 여부
  final String? expiryTime; // 만료 시간 (ISO8601)
  final String? errorMessage; // 오류 메시지

  PurchaseVerificationResult({
    required this.success,
    required this.verified,
    this.expiryTime,
    this.errorMessage,
  });

  bool get isValid => success && verified;

  @override
  String toString() {
    return 'PurchaseVerificationResult(success: $success, verified: $verified, '
        'expiryTime: $expiryTime, error: $errorMessage)';
  }
}
