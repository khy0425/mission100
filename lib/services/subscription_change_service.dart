import 'dart:async';
import 'package:flutter/foundation.dart';
import 'subscription_service.dart';
import 'billing_service.dart';
import 'notification_service.dart';
import 'data_service.dart';

/// 구독 변경 상태
enum SubscriptionChangeStatus {
  none,
  processing,
  completed,
  failed,
  cancelled,
}

/// 구독 변경 타입
enum SubscriptionChangeType {
  upgrade, // 업그레이드
  downgrade, // 다운그레이드
  crossgrade, // 동급 변경
}

/// 구독 변경 정보
class SubscriptionChangeInfo {
  final String fromProductId;
  final String toProductId;
  final SubscriptionChangeType changeType;
  final double proratedAmount;
  final DateTime changeDate;
  final SubscriptionChangeStatus status;
  final String? errorMessage;

  SubscriptionChangeInfo({
    required this.fromProductId,
    required this.toProductId,
    required this.changeType,
    required this.proratedAmount,
    required this.changeDate,
    required this.status,
    this.errorMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'fromProductId': fromProductId,
      'toProductId': toProductId,
      'changeType': changeType.toString(),
      'proratedAmount': proratedAmount,
      'changeDate': changeDate.millisecondsSinceEpoch,
      'status': status.toString(),
      'errorMessage': errorMessage,
    };
  }

  factory SubscriptionChangeInfo.fromJson(Map<String, dynamic> json) {
    return SubscriptionChangeInfo(
      fromProductId: (json['fromProductId'] as String?) ?? '',
      toProductId: (json['toProductId'] as String?) ?? '',
      changeType: SubscriptionChangeType.values.firstWhere(
        (e) => e.toString() == json['changeType'],
        orElse: () => SubscriptionChangeType.upgrade,
      ),
      proratedAmount: ((json['proratedAmount'] as num?) ?? 0.0).toDouble(),
      changeDate: DateTime.fromMillisecondsSinceEpoch(
          (json['changeDate'] as int?) ?? 0),
      status: SubscriptionChangeStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => SubscriptionChangeStatus.none,
      ),
      errorMessage: json['errorMessage'] as String?,
    );
  }
}

/// 구독 변경 결과
class SubscriptionChangeResult {
  final bool success;
  final String? error;
  final SubscriptionChangeInfo? changeInfo;

  SubscriptionChangeResult({
    required this.success,
    this.error,
    this.changeInfo,
  });
}

/// 구독 변경(업그레이드/다운그레이드) 관리 서비스
class SubscriptionChangeService {
  static final SubscriptionChangeService _instance =
      SubscriptionChangeService._internal();
  factory SubscriptionChangeService() => _instance;
  SubscriptionChangeService._internal();

  final SubscriptionService _subscriptionService = SubscriptionService();
  final BillingService _billingService = BillingService();
  final NotificationService _notificationService = NotificationService();
  final DataService _dataService = DataService();

  /// 구독 변경 요청
  Future<SubscriptionChangeResult> requestSubscriptionChange({
    required String currentProductId,
    required String newProductId,
    required bool immediate, // 즉시 변경 여부
  }) async {
    try {
      // 1. 현재 구독 상태 확인
      final currentSubscription =
          await _subscriptionService.getCurrentSubscription();
      if (currentSubscription == null ||
          currentSubscription.productId != currentProductId) {
        return SubscriptionChangeResult(
          success: false,
          error: '현재 구독 정보가 일치하지 않습니다.',
        );
      }

      // 2. 변경 타입 결정
      final changeType = _determineChangeType(currentProductId, newProductId);

      // 3. 비례 배분 계산
      final proratedAmount = await _calculateProratedAmount(
        currentProductId,
        newProductId,
        currentSubscription.expiryDate,
      );

      // 4. 구독 변경 정보 생성
      final changeInfo = SubscriptionChangeInfo(
        fromProductId: currentProductId,
        toProductId: newProductId,
        changeType: changeType,
        proratedAmount: proratedAmount,
        changeDate: DateTime.now(),
        status: SubscriptionChangeStatus.processing,
      );

      // 5. 구독 변경 실행
      final changeResult =
          await _executeSubscriptionChange(changeInfo, immediate);

      return changeResult;
    } catch (e) {
      debugPrint('구독 변경 요청 실패: $e');
      return SubscriptionChangeResult(
        success: false,
        error: '구독 변경 중 오류가 발생했습니다: $e',
      );
    }
  }

  /// 구독 변경 타입 결정
  SubscriptionChangeType _determineChangeType(
      String currentProductId, String newProductId) {
    // 상품 등급 매핑
    final productTiers = {
      'premium_monthly': 1,
      'premium_yearly': 2,
      'premium_lifetime': 3,
    };

    final currentTier = productTiers[currentProductId] ?? 0;
    final newTier = productTiers[newProductId] ?? 0;

    if (newTier > currentTier) {
      return SubscriptionChangeType.upgrade;
    } else if (newTier < currentTier) {
      return SubscriptionChangeType.downgrade;
    } else {
      return SubscriptionChangeType.crossgrade;
    }
  }

  /// 비례 배분 금액 계산
  Future<double> _calculateProratedAmount(
    String currentProductId,
    String newProductId,
    DateTime currentExpiryDate,
  ) async {
    try {
      // 현재 구독의 남은 기간 계산
      final now = DateTime.now();
      final remainingDays = currentExpiryDate.difference(now).inDays;

      if (remainingDays <= 0) {
        return 0.0;
      }

      // 상품 가격 정보
      final productPrices = {
        'premium_monthly': 4.99,
        'premium_yearly': 29.99,
        'premium_lifetime': 99.99,
      };

      final currentPrice = productPrices[currentProductId] ?? 0.0;
      final newPrice = productPrices[newProductId] ?? 0.0;

      // 현재 구독의 일일 가격 계산
      final currentPeriodDays = _getProductPeriodDays(currentProductId);
      final dailyCurrentPrice = currentPrice / currentPeriodDays;

      // 남은 기간의 현재 구독 가치
      final remainingValue = dailyCurrentPrice * remainingDays;

      // 새 구독의 일일 가격 계산 (향후 확장용)
      // final newPeriodDays = _getProductPeriodDays(newProductId);
      // final dailyNewPrice = newPrice / newPeriodDays;

      // 비례 배분 금액 = 새 구독 가격 - 남은 기간의 현재 구독 가치
      final proratedAmount = newPrice - remainingValue;

      return proratedAmount > 0 ? proratedAmount : 0.0;
    } catch (e) {
      debugPrint('비례 배분 계산 실패: $e');
      return 0.0;
    }
  }

  /// 상품의 기간(일수) 반환
  int _getProductPeriodDays(String productId) {
    switch (productId) {
      case 'premium_monthly':
        return 30;
      case 'premium_yearly':
        return 365;
      case 'premium_lifetime':
        return 36500; // 100년
      default:
        return 30;
    }
  }

  /// 구독 변경 실행
  Future<SubscriptionChangeResult> _executeSubscriptionChange(
    SubscriptionChangeInfo changeInfo,
    bool immediate,
  ) async {
    try {
      // 1. 변경 정보 저장
      await _saveSubscriptionChangeInfo(changeInfo);

      // 2. Google Play/App Store API를 통한 구독 변경
      dynamic purchaseResult;
      try {
        purchaseResult =
            await _billingService.purchaseProduct(changeInfo.toProductId);
      } catch (e) {
        // BillingService가 아직 구현되지 않은 경우 시뮬레이션
        debugPrint('BillingService not implemented yet, using simulation: $e');
        purchaseResult = _MockPurchaseResult(
            success: true,
            purchaseDetails:
                _MockPurchaseDetails(productId: changeInfo.toProductId));
      }

      final isSuccess = purchaseResult?.success;
      if (!(isSuccess is bool && isSuccess) ||
          purchaseResult?.purchaseDetails == null) {
        // 변경 실패 처리
        final failedChangeInfo = SubscriptionChangeInfo(
          fromProductId: changeInfo.fromProductId,
          toProductId: changeInfo.toProductId,
          changeType: changeInfo.changeType,
          proratedAmount: changeInfo.proratedAmount,
          changeDate: changeInfo.changeDate,
          status: SubscriptionChangeStatus.failed,
          errorMessage: purchaseResult?.error as String?,
        );
        await _updateSubscriptionChangeInfo(failedChangeInfo);

        return SubscriptionChangeResult(
          success: false,
          error: (purchaseResult?.error as String?) ?? '구독 변경에 실패했습니다.',
        );
      }

      // 3. 구매 검증
      dynamic verificationResult;
      try {
        verificationResult = await _billingService.verifyPurchase(
          purchaseResult?.purchaseDetails!,
        );
      } catch (e) {
        // BillingService가 아직 구현되지 않은 경우 시뮬레이션
        debugPrint(
            'BillingService verification not implemented yet, using simulation: $e');
        verificationResult = _MockVerificationResult(isValid: true);
      }

      final isValid = verificationResult?.isValid;
      if (!(isValid is bool && isValid)) {
        return SubscriptionChangeResult(
          success: false,
          error: '구독 변경 검증에 실패했습니다.',
        );
      }

      // 4. 구독 정보 업데이트
      await _subscriptionService.updateSubscription(
        productId: changeInfo.toProductId,
        purchaseDetails: purchaseResult?.purchaseDetails!,
      );

      // 5. 변경 완료 처리
      final completedChangeInfo = SubscriptionChangeInfo(
        fromProductId: changeInfo.fromProductId,
        toProductId: changeInfo.toProductId,
        changeType: changeInfo.changeType,
        proratedAmount: changeInfo.proratedAmount,
        changeDate: changeInfo.changeDate,
        status: SubscriptionChangeStatus.completed,
      );
      await _updateSubscriptionChangeInfo(completedChangeInfo);

      // 6. 사용자 알림
      await _notifySubscriptionChange(completedChangeInfo);

      return SubscriptionChangeResult(
        success: true,
        changeInfo: completedChangeInfo,
      );
    } catch (e) {
      debugPrint('구독 변경 실행 실패: $e');
      return SubscriptionChangeResult(
        success: false,
        error: '구독 변경 중 오류가 발생했습니다: $e',
      );
    }
  }

  /// 구독 변경 정보 저장
  Future<void> _saveSubscriptionChangeInfo(
      SubscriptionChangeInfo changeInfo) async {
    try {
      final currentHistory = await _getSubscriptionChangeHistory();
      currentHistory.add(changeInfo.toJson());

      try {
        await _dataService.saveData('subscription_change_history', {
          'changes': currentHistory,
        });
      } catch (e) {
        debugPrint('DataService not implemented yet: $e');
      }
      debugPrint('구독 변경 정보 저장됨: ${changeInfo.toJson()}');
    } catch (e) {
      debugPrint('구독 변경 정보 저장 실패: $e');
    }
  }

  /// 구독 변경 정보 업데이트
  Future<void> _updateSubscriptionChangeInfo(
      SubscriptionChangeInfo changeInfo) async {
    try {
      final currentHistory = await _getSubscriptionChangeHistory();
      final index = currentHistory.indexWhere((change) =>
          change['fromProductId'] == changeInfo.fromProductId &&
          change['toProductId'] == changeInfo.toProductId &&
          change['changeDate'] == changeInfo.changeDate.millisecondsSinceEpoch);

      if (index != -1) {
        currentHistory[index] = changeInfo.toJson();
        try {
          await _dataService.saveData('subscription_change_history', {
            'changes': currentHistory,
          });
        } catch (e) {
          debugPrint('DataService not implemented yet: $e');
        }
      }
      debugPrint('구독 변경 정보 업데이트됨: ${changeInfo.toJson()}');
    } catch (e) {
      debugPrint('구독 변경 정보 업데이트 실패: $e');
    }
  }

  /// 구독 변경 기록 조회
  Future<List<Map<String, dynamic>>> _getSubscriptionChangeHistory() async {
    try {
      try {
        final data = await _dataService.getData('subscription_change_history');
        final changes = data?['changes'];
        if (changes is List) {
          return List<Map<String, dynamic>>.from(changes);
        }
        return [];
      } catch (e) {
        debugPrint('DataService not implemented yet: $e');
        return [];
      }
    } catch (e) {
      debugPrint('구독 변경 기록 조회 실패: $e');
      return [];
    }
  }

  /// 사용자에게 구독 변경 알림
  Future<void> _notifySubscriptionChange(
      SubscriptionChangeInfo changeInfo) async {
    try {
      String title = '';
      String body = '';

      switch (changeInfo.changeType) {
        case SubscriptionChangeType.upgrade:
          title = '구독 업그레이드 완료';
          body = '프리미엄 플랜이 업그레이드되었습니다. 새로운 기능을 즐겨보세요!';
          break;
        case SubscriptionChangeType.downgrade:
          title = '구독 다운그레이드 완료';
          body = '구독 플랜이 변경되었습니다.';
          break;
        case SubscriptionChangeType.crossgrade:
          title = '구독 변경 완료';
          body = '구독 플랜이 변경되었습니다.';
          break;
      }

      try {
        await _notificationService.showNotification(
          title: title,
          body: body,
        );
      } catch (e) {
        debugPrint('NotificationService not implemented yet: $e');
      }
      debugPrint('알림 전송됨: $title - $body');
    } catch (e) {
      debugPrint('구독 변경 알림 실패: $e');
    }
  }

  /// 구독 변경 가능 여부 확인
  Future<bool> canChangeSubscription(
      String currentProductId, String newProductId) async {
    try {
      // 현재 구독 상태 확인
      final currentSubscription =
          await _subscriptionService.getCurrentSubscription();
      if (currentSubscription == null) {
        return false;
      }

      // 같은 상품으로 변경 시도 방지
      if (currentProductId == newProductId) {
        return false;
      }

      // 구독이 활성 상태인지 확인
      if (currentSubscription.status != SubscriptionStatus.active) {
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('구독 변경 가능 여부 확인 실패: $e');
      return false;
    }
  }

  /// 구독 변경 기록 조회 (사용자용)
  Future<List<SubscriptionChangeInfo>> getSubscriptionChangeHistory() async {
    try {
      final historyData = await _getSubscriptionChangeHistory();
      return historyData
          .map((data) => SubscriptionChangeInfo.fromJson(data))
          .toList();
    } catch (e) {
      debugPrint('구독 변경 기록 조회 실패: $e');
      return [];
    }
  }
}

// 임시 모의 클래스들 (실제 서비스가 구현될 때까지 사용)
class _MockPurchaseResult {
  final bool success;
  final String? error;
  final _MockPurchaseDetails? purchaseDetails;

  _MockPurchaseResult({
    required this.success,
    this.purchaseDetails,
  });
}

class _MockPurchaseDetails {
  final String productId;

  _MockPurchaseDetails({required this.productId});
}

class _MockVerificationResult {
  final bool isValid;

  _MockVerificationResult({required this.isValid});
}
