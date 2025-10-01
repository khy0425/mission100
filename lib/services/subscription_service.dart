import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'billing_service.dart';
import '../models/subscription_tier.dart';

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
  static const String _userSignupDateKey = 'user_signup_date';
  static const String _trialStartDateKey = 'trial_start_date';

  SubscriptionType _currentSubscription = SubscriptionType.free;
  DateTime? _expiryDate;
  DateTime? _purchaseDate;
  DateTime? _userSignupDate;
  DateTime? _trialStartDate;

  final StreamController<SubscriptionType> _subscriptionController =
      StreamController<SubscriptionType>.broadcast();

  // 구독 상태 변경 스트림
  Stream<SubscriptionType> get subscriptionStream => _subscriptionController.stream;

  // 현재 구독 타입 반환
  SubscriptionType get currentSubscription => _currentSubscription;

  // 프리미엄 구독 여부 확인 (Early Adopter, Trial, Paid Premium 모두 포함)
  bool get isPremium => getCurrentTier() != SubscriptionTier.free;

  // 현재 구독 Tier 반환
  SubscriptionTier getCurrentTier() {
    // 1. Paid Premium 구독자
    if (_currentSubscription != SubscriptionType.free && !isExpired) {
      return SubscriptionTier.premium;
    }

    // 2. Early Adopter (2025년 10월 가입자)
    if (_userSignupDate != null && _isEarlyAdopter(_userSignupDate!)) {
      return SubscriptionTier.earlyAdopter;
    }

    // 3. Trial (1주 무료 체험 중)
    if (_trialStartDate != null && _isTrialActive(_trialStartDate!)) {
      return SubscriptionTier.trial;
    }

    // 4. Free
    return SubscriptionTier.free;
  }

  // 10월 가입자 확인
  bool _isEarlyAdopter(DateTime signupDate) {
    return signupDate.year == 2025 && signupDate.month == 10;
  }

  // Trial 활성 상태 확인 (가입 후 7일 이내)
  bool _isTrialActive(DateTime trialStartDate) {
    final now = DateTime.now();
    final diff = now.difference(trialStartDate);
    return diff.inDays < 7;
  }

  // 사용자 가입일 설정
  Future<void> setUserSignupDate(DateTime signupDate) async {
    _userSignupDate = signupDate;

    // 10월 가입자가 아닌 경우에만 Trial 시작
    if (!_isEarlyAdopter(signupDate)) {
      _trialStartDate = signupDate;
    }

    await _saveSubscriptionData();
  }

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

      final signupTimestamp = prefs.getInt(_userSignupDateKey);
      if (signupTimestamp != null) {
        _userSignupDate = DateTime.fromMillisecondsSinceEpoch(signupTimestamp);
      }

      final trialTimestamp = prefs.getInt(_trialStartDateKey);
      if (trialTimestamp != null) {
        _trialStartDate = DateTime.fromMillisecondsSinceEpoch(trialTimestamp);
      }

      debugPrint('SubscriptionService: Loaded subscription data - ${_currentSubscription.name}, tier: ${getCurrentTier()}');

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

      if (_userSignupDate != null) {
        await prefs.setInt(_userSignupDateKey, _userSignupDate!.millisecondsSinceEpoch);
      }

      if (_trialStartDate != null) {
        await prefs.setInt(_trialStartDateKey, _trialStartDate!.millisecondsSinceEpoch);
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
    final tier = getCurrentTier();
    final features = SubscriptionFeatures(tier);

    switch (feature) {
      case PremiumFeature.unlimitedWorkouts:
        return features.hasUnlimitedWorkouts;
      case PremiumFeature.advancedStats:
        return features.hasAdvancedStats;
      case PremiumFeature.adFree:
        return features.hasAdFree;
      case PremiumFeature.premiumChads:
        return features.hasPremiumChad;
      case PremiumFeature.exclusiveChallenges:
        return features.hasExclusiveChallenges;
      case PremiumFeature.prioritySupport:
        return tier == SubscriptionTier.premium &&
               _currentSubscription == SubscriptionType.lifetime;
    }
  }

  // 광고 제거 여부 (유료 프리미엄만)
  bool get isAdFree => getCurrentTier() == SubscriptionTier.premium;

  // 구독 상태 문자열 반환
  String getSubscriptionStatusText() {
    final tier = getCurrentTier();
    final features = SubscriptionFeatures(tier);

    // Tier 이름 + 아이콘 반환
    return '${features.tierIcon} ${features.tierName}';
  }

  // 구독 상세 정보 반환
  String getSubscriptionDetailsText() {
    final tier = getCurrentTier();

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
        return '$typeText ($daysLeft일 남음)';
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

  // 현재 구독 정보 반환 (새로운 구독 관리용)
  Future<UserSubscription?> getCurrentSubscription() async {
    if (_currentSubscription == SubscriptionType.free) {
      return null;
    }

    return UserSubscription(
      productId: _getProductIdFromType(_currentSubscription),
      status: isExpired ? SubscriptionStatus.expired : SubscriptionStatus.active,
      startDate: _purchaseDate ?? DateTime.now(),
      expiryDate: _expiryDate ?? DateTime.now(),
      autoRenewing: _currentSubscription != SubscriptionType.lifetime && !isExpired,
    );
  }

  // 구독 타입에서 상품 ID 변환
  String _getProductIdFromType(SubscriptionType type) {
    switch (type) {
      case SubscriptionType.monthly:
        return 'premium_monthly';
      case SubscriptionType.yearly:
        return 'premium_yearly';
      case SubscriptionType.lifetime:
        return 'premium_lifetime';
      default:
        return '';
    }
  }

  // 구독 상태 업데이트 (새로운 구독 관리용)
  Future<void> updateSubscriptionStatus(SubscriptionStatus status) async {
    // 실제 구현에서는 상태에 따른 로직 추가
    debugPrint('구독 상태 업데이트: $status');
  }


  // 자동 갱신 방지
  Future<void> preventAutoRenewal() async {
    // 실제 구현에서는 플랫폼별 자동 갱신 중단 로직 추가
    debugPrint('자동 갱신 방지됨');
  }

  // 구독 정보 업데이트 (구매 완료 시)
  Future<void> updateSubscription({
    required String productId,
    required dynamic purchaseDetails, // PurchaseDetails
  }) async {
    SubscriptionType type;
    switch (productId) {
      case 'premium_monthly':
        type = SubscriptionType.monthly;
        break;
      case 'premium_yearly':
        type = SubscriptionType.yearly;
        break;
      case 'premium_lifetime':
        type = SubscriptionType.lifetime;
        break;
      default:
        type = SubscriptionType.free;
    }

    DateTime? expiry;
    if (type != SubscriptionType.lifetime) {
      final now = DateTime.now();
      expiry = type == SubscriptionType.monthly
          ? now.add(const Duration(days: 30))
          : now.add(const Duration(days: 365));
    }

    _currentSubscription = type;
    _expiryDate = expiry;
    _purchaseDate = DateTime.now();

    await _saveSubscriptionData();
    _subscriptionController.add(_currentSubscription);
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

// 구독 상태 열거형
enum SubscriptionStatus {
  active,              // 활성
  expired,             // 만료됨
  cancelled,           // 취소됨
  cancelledAtPeriodEnd,// 기간 종료 후 취소 예정
  paused,              // 일시정지
}

// 사용자 구독 정보 클래스
class UserSubscription {
  final String productId;
  final SubscriptionStatus status;
  final DateTime startDate;
  final DateTime expiryDate;
  final bool autoRenewing;

  UserSubscription({
    required this.productId,
    required this.status,
    required this.startDate,
    required this.expiryDate,
    required this.autoRenewing,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'status': status.toString(),
      'startDate': startDate.millisecondsSinceEpoch,
      'expiryDate': expiryDate.millisecondsSinceEpoch,
      'autoRenewing': autoRenewing,
    };
  }

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      productId: (json['productId'] as String?) ?? '',
      status: SubscriptionStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => SubscriptionStatus.expired,
      ),
      startDate: DateTime.fromMillisecondsSinceEpoch((json['startDate'] as int?) ?? 0),
      expiryDate: DateTime.fromMillisecondsSinceEpoch((json['expiryDate'] as int?) ?? 0),
      autoRenewing: (json['autoRenewing'] as bool?) ?? false,
    );
  }
}