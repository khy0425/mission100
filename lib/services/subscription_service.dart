import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'billing_service.dart';

enum SubscriptionType {
  free,
  monthly,
  yearly,
  lifetime,
}

class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  static const String _subscriptionTypeKey = 'subscription_type';
  static const String _subscriptionExpiryKey = 'subscription_expiry';
  static const String _subscriptionPurchaseDateKey = 'subscription_purchase_date';

  SubscriptionType _currentSubscription = SubscriptionType.free;
  DateTime? _expiryDate;
  DateTime? _purchaseDate;

  final StreamController<SubscriptionType> _subscriptionController =
      StreamController<SubscriptionType>.broadcast();

  // 구독 상태 변경 스트림
  Stream<SubscriptionType> get subscriptionStream => _subscriptionController.stream;

  // 현재 구독 타입 반환
  SubscriptionType get currentSubscription => _currentSubscription;

  // 프리미엄 구독 여부 확인
  bool get isPremium => _currentSubscription != SubscriptionType.free && !isExpired;

  // 구독 만료 여부 확인
  bool get isExpired {
    if (_currentSubscription == SubscriptionType.lifetime) return false;
    if (_expiryDate == null) return true;
    return DateTime.now().isAfter(_expiryDate!);
  }

  // 구독 만료일 반환
  DateTime? get expiryDate => _expiryDate;

  // 구매일 반환
  DateTime? get purchaseDate => _purchaseDate;

  // 초기화
  Future<void> initialize() async {
    await _loadSubscriptionData();
    await _checkActiveSubscriptions();
  }

  // 저장된 구독 데이터 로드
  Future<void> _loadSubscriptionData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final subscriptionTypeIndex = prefs.getInt(_subscriptionTypeKey) ?? 0;
      _currentSubscription = SubscriptionType.values[subscriptionTypeIndex];

      final expiryTimestamp = prefs.getInt(_subscriptionExpiryKey);
      if (expiryTimestamp != null) {
        _expiryDate = DateTime.fromMillisecondsSinceEpoch(expiryTimestamp);
      }

      final purchaseTimestamp = prefs.getInt(_subscriptionPurchaseDateKey);
      if (purchaseTimestamp != null) {
        _purchaseDate = DateTime.fromMillisecondsSinceEpoch(purchaseTimestamp);
      }

      debugPrint('SubscriptionService: Loaded subscription data - ${_currentSubscription.name}');

    } catch (e) {
      debugPrint('SubscriptionService: Error loading subscription data: $e');
    }
  }

  // 구독 데이터 저장
  Future<void> _saveSubscriptionData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt(_subscriptionTypeKey, _currentSubscription.index);

      if (_expiryDate != null) {
        await prefs.setInt(_subscriptionExpiryKey, _expiryDate!.millisecondsSinceEpoch);
      }

      if (_purchaseDate != null) {
        await prefs.setInt(_subscriptionPurchaseDateKey, _purchaseDate!.millisecondsSinceEpoch);
      }

      debugPrint('SubscriptionService: Saved subscription data');

    } catch (e) {
      debugPrint('SubscriptionService: Error saving subscription data: $e');
    }
  }

  // 활성 구독 확인
  Future<void> _checkActiveSubscriptions() async {
    try {
      final billingService = BillingService();

      if (!billingService.isInitialized) {
        await billingService.initialize();
      }

      // 각 구독 상품의 활성 상태 확인
      for (final productId in ['premium_monthly', 'premium_yearly', 'premium_lifetime']) {
        final isActive = await billingService.isSubscriptionActive(productId);
        if (isActive) {
          await activateSubscription(productId);
          break;
        }
      }

    } catch (e) {
      debugPrint('SubscriptionService: Error checking active subscriptions: $e');
    }
  }

  // 구독 활성화 (공개 메서드로 변경)
  Future<void> activateSubscription(String productId) async {
    SubscriptionType newType;
    DateTime? newExpiryDate;

    switch (productId) {
      case 'premium_monthly':
        newType = SubscriptionType.monthly;
        newExpiryDate = DateTime.now().add(const Duration(days: 30));
        break;
      case 'premium_yearly':
        newType = SubscriptionType.yearly;
        newExpiryDate = DateTime.now().add(const Duration(days: 365));
        break;
      case 'premium_lifetime':
        newType = SubscriptionType.lifetime;
        newExpiryDate = null; // 평생 구독은 만료일이 없음
        break;
      default:
        return;
    }

    _currentSubscription = newType;
    _expiryDate = newExpiryDate;
    _purchaseDate = DateTime.now();

    await _saveSubscriptionData();
    _subscriptionController.add(_currentSubscription);

    debugPrint('SubscriptionService: Activated subscription: ${newType.name}');
  }

  // 구독 취소/만료 처리
  Future<void> deactivateSubscription() async {
    _currentSubscription = SubscriptionType.free;
    _expiryDate = null;
    _purchaseDate = null;

    await _saveSubscriptionData();
    _subscriptionController.add(_currentSubscription);

    debugPrint('SubscriptionService: Deactivated subscription');
  }

  // 특정 기능의 프리미엄 권한 확인
  bool hasFeatureAccess(PremiumFeature feature) {
    if (!isPremium) return false;

    switch (feature) {
      case PremiumFeature.unlimitedWorkouts:
        return true;
      case PremiumFeature.advancedStats:
        return true;
      case PremiumFeature.adFree:
        return true;
      case PremiumFeature.premiumChads:
        return true;
      case PremiumFeature.exclusiveChallenges:
        return _currentSubscription == SubscriptionType.yearly ||
               _currentSubscription == SubscriptionType.lifetime;
      case PremiumFeature.prioritySupport:
        return _currentSubscription == SubscriptionType.lifetime;
    }
  }

  // 구독 상태 문자열 반환
  String getSubscriptionStatusText() {
    if (!isPremium) {
      return '무료 계정';
    }

    String typeText;
    switch (_currentSubscription) {
      case SubscriptionType.monthly:
        typeText = '월간 프리미엄';
        break;
      case SubscriptionType.yearly:
        typeText = '연간 프리미엄';
        break;
      case SubscriptionType.lifetime:
        typeText = '평생 프리미엄';
        break;
      default:
        typeText = '무료 계정';
    }

    if (_currentSubscription == SubscriptionType.lifetime) {
      return typeText;
    }

    if (_expiryDate != null) {
      final daysLeft = _expiryDate!.difference(DateTime.now()).inDays;
      if (daysLeft > 0) {
        return '$typeText (${daysLeft}일 남음)';
      } else {
        return '$typeText (만료됨)';
      }
    }

    return typeText;
  }

  // 구독 갱신 안내 필요 여부
  bool shouldShowRenewalReminder() {
    if (_currentSubscription == SubscriptionType.lifetime) return false;
    if (_expiryDate == null) return false;

    final daysLeft = _expiryDate!.difference(DateTime.now()).inDays;
    return daysLeft <= 7 && daysLeft > 0;
  }

  // 구독 혜택 목록 반환
  List<String> getSubscriptionBenefits() {
    switch (_currentSubscription) {
      case SubscriptionType.monthly:
        return [
          '무제한 운동 기록',
          '고급 통계 분석',
          '광고 제거',
          '프리미엄 기가차드',
        ];
      case SubscriptionType.yearly:
        return [
          '무제한 운동 기록',
          '고급 통계 분석',
          '광고 제거',
          '프리미엄 기가차드',
          '독점 도전과제',
          '월간 대비 50% 할인',
        ];
      case SubscriptionType.lifetime:
        return [
          '모든 프리미엄 기능',
          '향후 업데이트 무료',
          'VIP 고객 지원',
          '평생 이용 가능',
        ];
      default:
        return [];
    }
  }

  // 사용량 제한 확인
  bool checkUsageLimit(UsageType usageType, int currentUsage) {
    if (isPremium) return true; // 프리미엄은 무제한

    switch (usageType) {
      case UsageType.workoutsPerDay:
        return currentUsage < 3;
      case UsageType.workoutsPerWeek:
        return currentUsage < 10;
      case UsageType.customChallenges:
        return currentUsage < 1;
      case UsageType.dataExport:
        return currentUsage < 1;
    }
  }

  // 리소스 정리
  void dispose() {
    _subscriptionController.close();
  }
}

// 프리미엄 기능 열거형
enum PremiumFeature {
  unlimitedWorkouts,
  advancedStats,
  adFree,
  premiumChads,
  exclusiveChallenges,
  prioritySupport,
}

// 사용량 타입 열거형
enum UsageType {
  workoutsPerDay,
  workoutsPerWeek,
  customChallenges,
  dataExport,
}