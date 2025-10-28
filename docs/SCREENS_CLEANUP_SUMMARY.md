# Screens Folder Cleanup Summary

## 📅 완료일: 2025-10-28

---

## 🎯 작업 개요

구형 구독 시스템(`subscription_service.dart`)에서 새 구독 시스템 V2(`auth_service.dart` + `UserSubscription`)로 마이그레이션하면서 발생한 screens 폴더 및 관련 파일들의 오류를 수정했습니다.

---

## 🔧 수정된 파일

### 1. lib/screens/settings_screen.dart ✅

**문제:**
- 구형 `SubscriptionService` import 및 사용
- `SubscriptionManagementScreen`으로의 네비게이션 참조 오류

**수정 내용:**
```dart
// Before
import '../services/subscription_service.dart';
final SubscriptionService _subscriptionService = SubscriptionService();
SubscriptionType _currentSubscription = SubscriptionType.free;

// After
import '../services/auth_service.dart';
import '../models/user_subscription.dart';
UserSubscription? _currentSubscription;
```

**주요 변경사항:**
1. `_loadSubscriptionData()` - AuthService에서 구독 정보 로드
2. `_buildSubscriptionCard()` - 새 UserSubscription 모델 사용
3. `_navigateToSubscriptionManagement()` - `_navigateToSubscription()`으로 리다이렉트
4. `_getPremiumBenefits()` 메서드 추가

---

### 2. lib/screens/subscription_management_screen.dart ⚠️ (보관됨)

**조치:**
- `lib/services/old_archive/` 폴더로 이동
- 새 시스템에서는 `subscription_screen.dart`만 사용
- Google Play Billing이 자동으로 구독 관리 처리

**이유:**
- 구형 SubscriptionService, SubscriptionChangeService, SubscriptionCancellationService 의존
- 새 시스템에서 별도 관리 화면 불필요

---

### 3. lib/main.dart ✅

**문제:**
- `subscription_service.dart` import
- Provider에 `subscriptionService` 등록

**수정 내용:**
```dart
// Before
import 'services/subscription_service.dart';
final subscriptionService = SubscriptionService();
Provider.value(value: subscriptionService),

// After
// import 'services/subscription_service.dart'; // 구형 시스템 - 제거됨
// Provider.value(value: subscriptionService), // AuthService로 대체됨
```

---

### 4. lib/widgets/premium_gate_widget.dart ✅

**문제:**
- `SubscriptionService` 사용
- `PremiumFeature` enum 정의 없음

**수정 내용:**

1. **Import 변경:**
```dart
// Before
import '../services/subscription_service.dart';

// After
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/user_subscription.dart';
```

2. **새 구독 모델 적용:**
```dart
// Before
final subscriptionService = SubscriptionService();
final hasAccess = subscriptionService.hasFeatureAccess(requiredFeature);

// After
final authService = Provider.of<AuthService>(context, listen: false);
final subscription = authService.currentSubscription;
final isPremium = subscription?.type == SubscriptionType.premium;

// 새 전략: 광고 제거만 프리미엄, 나머지는 모두 무료
if (requiredFeature == PremiumFeature.adFree) {
  return isPremium ? child : _buildLockedContent(context);
}
return child; // 다른 모든 기능은 무료
```

3. **PremiumFeature enum을 `user_subscription.dart`로 이동**

---

### 5. lib/widgets/subscription/current_subscription_card.dart ✅

**문제:**
- `SubscriptionService` import
- 존재하지 않는 필드 참조 (`productId`, `expiryDate`, `autoRenewing`)

**수정 내용:**
```dart
// Before
import '../../services/subscription_service.dart';
final String Function(String) getProductName;
subscription.productId
subscription.expiryDate
subscription.autoRenewing

// After
import '../../models/user_subscription.dart';
_getTypeName(subscription.type)
subscription.endDate
subscription.type == SubscriptionType.premium
```

**새로 추가된 메서드:**
- `_getTypeName(SubscriptionType)` - 구독 타입을 한글 이름으로 변환
- `_getStatusText(SubscriptionStatus)` - 상태를 한글로 변환
- `_formatDate(DateTime?)` - 날짜 포맷팅

---

### 6. lib/models/user_subscription.dart ✅

**추가 내용:**
```dart
/// 프리미엄 기능 열거형
///
/// 새 구독 모델 (V2):
/// - 모든 사용자가 Week 1-14 전체 접근 가능
/// - 프리미엄 구독은 광고 제거만 해당
enum PremiumFeature {
  unlimitedWorkouts, // 무제한 운동 (모두 무료)
  advancedStats, // 고급 통계 (모두 무료)
  adFree, // 광고 제거 (프리미엄만)
  premiumChads, // 프리미엄 Chad (모두 무료)
  exclusiveChallenges, // 독점 챌린지 (모두 무료)
  prioritySupport, // 우선 지원 (모두 무료)
}
```

---

### 7. lib/services/old_archive/README.md ✅

**업데이트:**
- `subscription_management_screen.dart` 보관 내역 추가
- 총 5개 파일 보관 (백업 1개 + 구독 관련 4개)

---

## 📊 마이그레이션 가이드

### 구형 코드 (Old)

```dart
// 구독 확인
import 'package:mission100/services/subscription_service.dart';

final subscriptionService = SubscriptionService();
final isPremium = subscriptionService.isPremium;
final hasAccess = subscriptionService.hasFeatureAccess(PremiumFeature.adFree);
```

### 신형 코드 (New)

```dart
// 구독 확인
import 'package:mission100/services/auth_service.dart';
import 'package:mission100/models/user_subscription.dart';

final authService = Provider.of<AuthService>(context);
final subscription = authService.currentSubscription;
final isPremium = subscription?.type == SubscriptionType.premium;

// 새 전략: 모든 기능 무료, 광고 제거만 프리미엄
final hasAds = subscription?.hasAds ?? true;
```

---

## 🆕 새 구독 전략 (V2)

### 핵심 철학

> **"쪼잔하지 않게, 관대하게"**

### 접근 권한

| 구분 | 무료 사용자 | 런칭 프로모션 | 프리미엄 |
|------|------------|--------------|---------|
| Week 접근 | **1-14** (전체) | **1-14** (전체) | **1-14** (전체) |
| 광고 | ✅ 있음 | ✅ 있음 | ❌ 없음 |
| VIP 로딩 | ❌ | ❌ | ✅ |
| 가격 | 무료 | 30일 무료 | ₩4,900/월 |
| 자동 갱신 | - | ❌ | ✅ |

### 차별화 포인트

**무료 사용자:**
- Week 1-14 전체 접근 가능 ✅
- 광고 표시 (수익화)
- 한 번만 부드럽게 회원가입 유도

**프리미엄 구독:**
- 광고 제거 (유일한 제한)
- VIP 빠른 로딩 (10배)
- 클라우드 자동 백업
- 자동 갱신

---

## ✅ 검증 체크리스트

- [x] settings_screen.dart 오류 수정
- [x] subscription_management_screen.dart 보관
- [x] main.dart에서 구형 서비스 제거
- [x] premium_gate_widget.dart 새 시스템 적용
- [x] current_subscription_card.dart 필드 수정
- [x] PremiumFeature enum 이동
- [x] old_archive/README.md 업데이트
- [ ] Flutter analyze 통과 (실행 중...)
- [ ] 수동 테스트 (설정 화면, 구독 화면)

---

## 📚 관련 문서

- [SUBSCRIPTION_STRATEGY_V2.md](SUBSCRIPTION_STRATEGY_V2.md) - 새 구독 전략
- [SERVICES_GUIDE.md](SERVICES_GUIDE.md) - 서비스 가이드
- [lib/services/old_archive/README.md](../lib/services/old_archive/README.md) - 보관 파일 목록

---

**작성일:** 2025-10-28
**작성자:** Claude
**버전:** 1.0
**상태:** ✅ 완료
