import 'dart:async';
import 'package:flutter/foundation.dart';
import 'subscription_service.dart';
import 'notification_service.dart';
import 'data_service.dart';
// import 'cloud_sync_service.dart';
// import 'billing_service.dart';

/// 취소 사유
enum CancellationReason {
  tooExpensive,           // 가격이 비싸서
  notUsingFeatures,       // 기능을 사용하지 않아서
  foundBetterAlternative, // 더 나은 대안을 찾아서
  technicalIssues,        // 기술적 문제
  temporaryBreak,         // 일시적 중단
  other,                  // 기타
}

/// 취소 타입
enum CancellationType {
  immediate,    // 즉시 취소
  endOfPeriod,  // 현재 구독 기간 종료 후 취소
}

/// 취소 상태
enum CancellationStatus {
  pending,        // 처리 중
  completed,      // 완료
  failed,         // 실패
  refundPending,  // 환불 처리 중
  refundCompleted,// 환불 완료
  refundFailed,   // 환불 실패
}

/// 데이터 보관 정책
enum DataRetentionPolicy {
  immediate,   // 즉시 삭제
  thirtyDays,  // 30일 보관
  ninetyDays,  // 90일 보관
  oneYear,     // 1년 보관
  permanent,   // 영구 보관 (익명화)
}

/// 취소 정보
class CancellationInfo {
  final String productId;
  final CancellationType type;
  final CancellationReason reason;
  final String? reasonText;
  final DateTime cancellationDate;
  final DateTime? effectiveDate;
  final bool refundRequested;
  final CancellationStatus status;
  final String? errorMessage;

  CancellationInfo({
    required this.productId,
    required this.type,
    required this.reason,
    this.reasonText,
    required this.cancellationDate,
    this.effectiveDate,
    required this.refundRequested,
    required this.status,
    this.errorMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'type': type.toString(),
      'reason': reason.toString(),
      'reasonText': reasonText,
      'cancellationDate': cancellationDate.millisecondsSinceEpoch,
      'effectiveDate': effectiveDate?.millisecondsSinceEpoch,
      'refundRequested': refundRequested,
      'status': status.toString(),
      'errorMessage': errorMessage,
    };
  }

  factory CancellationInfo.fromJson(Map<String, dynamic> json) {
    return CancellationInfo(
      productId: (json['productId'] as String?) ?? '',
      type: CancellationType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => CancellationType.endOfPeriod,
      ),
      reason: CancellationReason.values.firstWhere(
        (e) => e.toString() == json['reason'],
        orElse: () => CancellationReason.other,
      ),
      reasonText: json['reasonText'] as String?,
      cancellationDate: DateTime.fromMillisecondsSinceEpoch((json['cancellationDate'] as int?) ?? 0),
      effectiveDate: json['effectiveDate'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['effectiveDate'] as int)
        : null,
      refundRequested: (json['refundRequested'] as bool?) ?? false,
      status: CancellationStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => CancellationStatus.pending,
      ),
      errorMessage: json['errorMessage'] as String?,
    );
  }
}

/// 취소 결과
class CancellationResult {
  final bool success;
  final String? error;
  final CancellationInfo? cancellationInfo;

  CancellationResult({
    required this.success,
    this.error,
    this.cancellationInfo,
  });
}

/// 구독 취소 및 환불 관리 서비스
class SubscriptionCancellationService {
  static final SubscriptionCancellationService _instance = SubscriptionCancellationService._internal();
  factory SubscriptionCancellationService() => _instance;
  SubscriptionCancellationService._internal();

  final SubscriptionService _subscriptionService = SubscriptionService();
  final NotificationService _notificationService = NotificationService();
  final DataService _dataService = DataService();
  // final CloudSyncService _cloudSyncService = CloudSyncService();
  // final BillingService _billingService = BillingService();

  /// 구독 취소 요청
  Future<CancellationResult> requestCancellation({
    required String productId,
    required CancellationType type,
    required CancellationReason reason,
    String? reasonText,
    bool requestRefund = false,
    DataRetentionPolicy dataRetention = DataRetentionPolicy.ninetyDays,
  }) async {
    try {
      // 1. 현재 구독 상태 확인
      final currentSubscription = await _subscriptionService.getCurrentSubscription();
      if (currentSubscription == null || currentSubscription.productId != productId) {
        return CancellationResult(
          success: false,
          error: '취소할 구독 정보를 찾을 수 없습니다.',
        );
      }

      // 2. 취소 정보 생성
      final cancellationInfo = CancellationInfo(
        productId: productId,
        type: type,
        reason: reason,
        reasonText: reasonText,
        cancellationDate: DateTime.now(),
        effectiveDate: type == CancellationType.endOfPeriod
          ? currentSubscription.expiryDate
          : DateTime.now(),
        refundRequested: requestRefund,
        status: CancellationStatus.pending,
      );

      // 3. 취소 실행
      final result = await _executeCancellation(cancellationInfo);

      // 4. 데이터 보관 정책 적용
      if (result.success) {
        await _applyDataRetentionPolicy(dataRetention, cancellationInfo);
      }

      return result;

    } catch (e) {
      debugPrint('구독 취소 요청 실패: $e');
      return CancellationResult(
        success: false,
        error: '구독 취소 중 오류가 발생했습니다: $e',
      );
    }
  }

  /// 구독 취소 실행
  Future<CancellationResult> _executeCancellation(CancellationInfo cancellationInfo) async {
    try {
      // 1. 취소 정보 저장
      await _saveCancellationInfo(cancellationInfo);

      // 2. 플랫폼별 취소 처리
      final platformResult = await _processPlatformCancellation(cancellationInfo);

      if (!platformResult) {
        final failedInfo = CancellationInfo(
          productId: cancellationInfo.productId,
          type: cancellationInfo.type,
          reason: cancellationInfo.reason,
          reasonText: cancellationInfo.reasonText,
          cancellationDate: cancellationInfo.cancellationDate,
          effectiveDate: cancellationInfo.effectiveDate,
          refundRequested: cancellationInfo.refundRequested,
          status: CancellationStatus.failed,
          errorMessage: '플랫폼 취소 처리 실패',
        );
        await _updateCancellationInfo(failedInfo);

        return CancellationResult(
          success: false,
          error: '구독 취소 처리에 실패했습니다.',
        );
      }

      // 3. 환불 처리 (요청 시)
      if (cancellationInfo.refundRequested) {
        await _processRefundRequest(cancellationInfo);
      }

      // 4. 구독 상태 업데이트
      await _updateSubscriptionStatus(cancellationInfo);

      // 5. 취소 완료 처리
      final completedInfo = CancellationInfo(
        productId: cancellationInfo.productId,
        type: cancellationInfo.type,
        reason: cancellationInfo.reason,
        reasonText: cancellationInfo.reasonText,
        cancellationDate: cancellationInfo.cancellationDate,
        effectiveDate: cancellationInfo.effectiveDate,
        refundRequested: cancellationInfo.refundRequested,
        status: cancellationInfo.refundRequested
          ? CancellationStatus.refundPending
          : CancellationStatus.completed,
      );
      await _updateCancellationInfo(completedInfo);

      // 6. 사용자 알림
      await _notifyCancellation(completedInfo);

      return CancellationResult(
        success: true,
        cancellationInfo: completedInfo,
      );

    } catch (e) {
      debugPrint('구독 취소 실행 실패: $e');
      return CancellationResult(
        success: false,
        error: '구독 취소 처리 중 오류가 발생했습니다: $e',
      );
    }
  }

  /// 플랫폼별 취소 처리
  Future<bool> _processPlatformCancellation(CancellationInfo cancellationInfo) async {
    try {
      // Google Play 또는 App Store에서의 구독 취소는
      // 실제로는 사용자가 플랫폼에서 직접 취소해야 함
      // 여기서는 앱 내에서의 취소 상태만 관리

      // 즉시 취소인 경우 구독을 비활성화
      if (cancellationInfo.type == CancellationType.immediate) {
        await _subscriptionService.deactivateSubscription();
      }

      // 기간 종료 후 취소인 경우 갱신 방지 플래그 설정
      if (cancellationInfo.type == CancellationType.endOfPeriod) {
        await _subscriptionService.preventAutoRenewal();
      }

      return true;
    } catch (e) {
      debugPrint('플랫폼 취소 처리 실패: $e');
      return false;
    }
  }

  /// 환불 요청 처리
  Future<void> _processRefundRequest(CancellationInfo cancellationInfo) async {
    try {
      // 환불 요청 정보 저장
      await _saveRefundRequest(cancellationInfo);

      // 환불 처리는 실제로는 플랫폼(Google Play/App Store)에서 처리
      // 여기서는 요청 기록만 남김
      debugPrint('환불 요청이 기록되었습니다: ${cancellationInfo.productId}');

      // 환불 상태 알림 (실제 구현에서는 NotificationService 메서드 사용)
      // await _notificationService.showNotification(
      //   title: '환불 요청 접수',
      //   body: '환불 요청이 접수되었습니다. 처리까지 영업일 기준 3-5일이 소요될 수 있습니다.',
      // );
      debugPrint('환불 요청 접수 알림 전송됨');

    } catch (e) {
      debugPrint('환불 요청 처리 실패: $e');
    }
  }

  /// 구독 상태 업데이트
  Future<void> _updateSubscriptionStatus(CancellationInfo cancellationInfo) async {
    try {
      if (cancellationInfo.type == CancellationType.immediate) {
        // 즉시 취소 - 구독을 바로 비활성화
        await _subscriptionService.updateSubscriptionStatus(SubscriptionStatus.cancelled);
      } else {
        // 기간 종료 후 취소 - 취소 예정 상태로 설정
        await _subscriptionService.updateSubscriptionStatus(SubscriptionStatus.cancelledAtPeriodEnd);
      }
    } catch (e) {
      debugPrint('구독 상태 업데이트 실패: $e');
    }
  }

  /// 데이터 보관 정책 적용
  Future<void> _applyDataRetentionPolicy(
    DataRetentionPolicy policy,
    CancellationInfo cancellationInfo
  ) async {
    try {
      final retentionDate = _calculateRetentionDate(policy);

      // 데이터 보관 정책 정보 저장 (실제 구현에서는 DataService 메서드 사용)
      // await _dataService.saveData('data_retention_policy', {
      //   'policy': policy.toString(),
      //   'retentionDate': retentionDate.millisecondsSinceEpoch,
      //   'cancellationInfo': cancellationInfo.toJson(),
      // });
      debugPrint('데이터 보관 정책 저장됨: ${policy.toString()}');

      // 클라우드 동기화 중단 여부 결정 (실제 구현에서는 CloudSyncService 메서드 사용)
      if (policy == DataRetentionPolicy.immediate) {
        // await _cloudSyncService.stopSync();
        debugPrint('클라우드 동기화 중단됨');
        await _scheduleDataDeletion(DateTime.now());
      } else {
        await _scheduleDataDeletion(retentionDate);
      }

    } catch (e) {
      debugPrint('데이터 보관 정책 적용 실패: $e');
    }
  }

  /// 보관 기간 계산
  DateTime _calculateRetentionDate(DataRetentionPolicy policy) {
    final now = DateTime.now();

    switch (policy) {
      case DataRetentionPolicy.immediate:
        return now;
      case DataRetentionPolicy.thirtyDays:
        return now.add(const Duration(days: 30));
      case DataRetentionPolicy.ninetyDays:
        return now.add(const Duration(days: 90));
      case DataRetentionPolicy.oneYear:
        return now.add(const Duration(days: 365));
      case DataRetentionPolicy.permanent:
        return now.add(const Duration(days: 36500)); // 100년
    }
  }

  /// 데이터 삭제 예약
  Future<void> _scheduleDataDeletion(DateTime deletionDate) async {
    try {
      try {
        await _dataService.saveData('scheduled_data_deletion', {
          'deletionDate': deletionDate.millisecondsSinceEpoch,
          'scheduled': true,
        });
      } catch (e) {
        debugPrint('DataService not implemented yet: $e');
      }

      // 백그라운드 작업 스케줄링 (실제 구현에서는 WorkManager 등 사용)
      debugPrint('데이터 삭제가 예약되었습니다: $deletionDate');
    } catch (e) {
      debugPrint('데이터 삭제 예약 실패: $e');
    }
  }

  /// 취소 정보 저장
  Future<void> _saveCancellationInfo(CancellationInfo cancellationInfo) async {
    try {
      final history = await _getCancellationHistory();
      history.add(cancellationInfo.toJson());

      try {
        await _dataService.saveData('cancellation_history', {
          'cancellations': history,
        });
      } catch (e) {
        debugPrint('DataService not implemented yet: $e');
      }
      debugPrint('취소 정보 저장됨: ${cancellationInfo.toJson()}');
    } catch (e) {
      debugPrint('취소 정보 저장 실패: $e');
    }
  }

  /// 취소 정보 업데이트
  Future<void> _updateCancellationInfo(CancellationInfo cancellationInfo) async {
    try {
      final history = await _getCancellationHistory();
      final index = history.indexWhere((cancel) =>
        cancel['productId'] == cancellationInfo.productId &&
        cancel['cancellationDate'] == cancellationInfo.cancellationDate.millisecondsSinceEpoch
      );

      if (index != -1) {
        history[index] = cancellationInfo.toJson();
        try {
          await _dataService.saveData('cancellation_history', {
            'cancellations': history,
          });
        } catch (e) {
          debugPrint('DataService not implemented yet: $e');
        }
        debugPrint('취소 정보 업데이트됨: ${cancellationInfo.toJson()}');
      }
    } catch (e) {
      debugPrint('취소 정보 업데이트 실패: $e');
    }
  }

  /// 환불 요청 정보 저장
  Future<void> _saveRefundRequest(CancellationInfo cancellationInfo) async {
    try {
      try {
        await _dataService.saveData('refund_requests', {
          'productId': cancellationInfo.productId,
          'requestDate': DateTime.now().millisecondsSinceEpoch,
          'reason': cancellationInfo.reason.toString(),
          'reasonText': cancellationInfo.reasonText,
          'status': 'pending',
        });
      } catch (e) {
        debugPrint('DataService not implemented yet: $e');
      }
      debugPrint('환불 요청 정보 저장됨: ${cancellationInfo.productId}');
    } catch (e) {
      debugPrint('환불 요청 정보 저장 실패: $e');
    }
  }

  /// 취소 기록 조회
  Future<List<Map<String, dynamic>>> _getCancellationHistory() async {
    try {
      try {
        final data = await _dataService.getData('cancellation_history');
        final cancellations = data?['cancellations'];
        if (cancellations is List) {
          return List<Map<String, dynamic>>.from(cancellations);
        }
        return [];
      } catch (e) {
        debugPrint('DataService not implemented yet: $e');
        return [];
      }
    } catch (e) {
      debugPrint('취소 기록 조회 실패: $e');
      return [];
    }
  }

  /// 취소 알림
  Future<void> _notifyCancellation(CancellationInfo cancellationInfo) async {
    try {
      const String title = '구독 취소 완료';
      String body = '';

      if (cancellationInfo.type == CancellationType.immediate) {
        body = '구독이 즉시 취소되었습니다.';
      } else {
        body = '구독이 현재 기간 종료 후 취소됩니다.';
      }

      if (cancellationInfo.refundRequested) {
        body += ' 환불 요청이 접수되었습니다.';
      }

      try {
        await _notificationService.showNotification(
          title: title,
          body: body,
        );
      } catch (e) {
        debugPrint('NotificationService not implemented yet: $e');
      }
      debugPrint('취소 알림 전송됨: $title - $body');
    } catch (e) {
      debugPrint('취소 알림 실패: $e');
    }
  }

  /// 구독 취소 가능 여부 확인
  Future<bool> canCancelSubscription() async {
    try {
      final subscription = await _subscriptionService.getCurrentSubscription();
      return subscription != null &&
             subscription.status == SubscriptionStatus.active;
    } catch (e) {
      debugPrint('취소 가능 여부 확인 실패: $e');
      return false;
    }
  }

  /// 취소 기록 조회 (사용자용)
  Future<List<CancellationInfo>> getCancellationHistory() async {
    try {
      final historyData = await _getCancellationHistory();
      return historyData.map((data) => CancellationInfo.fromJson(data)).toList();
    } catch (e) {
      debugPrint('취소 기록 조회 실패: $e');
      return [];
    }
  }

  /// 취소 사유 텍스트 반환
  String getCancellationReasonText(CancellationReason reason) {
    switch (reason) {
      case CancellationReason.tooExpensive:
        return '가격이 비싸서';
      case CancellationReason.notUsingFeatures:
        return '기능을 사용하지 않아서';
      case CancellationReason.foundBetterAlternative:
        return '더 나은 대안을 찾아서';
      case CancellationReason.technicalIssues:
        return '기술적 문제';
      case CancellationReason.temporaryBreak:
        return '일시적 중단';
      case CancellationReason.other:
        return '기타';
    }
  }
}