# 구매 모델 결정 - 구독 vs 1회성

## 📊 비교 분석

### Option 1: 구독 모델 (Subscription)

**장점**:
- ✅ **안정적인 반복 수익** (MRR)
- ✅ 사용자 이탈 추적 용이
- ✅ 지속적인 고객 관계
- ✅ 낮은 초기 진입 장벽

**단점**:
- ❌ 사용자 부담 (매달 결제)
- ❌ 구독 피로도
- ❌ 취소/환불 관리 필요

**가격 예시**:
- ₩4,900/월
- ₩49,000/년 (월 ₩4,083, 17% 할인)

**수익 예측** (사용자 1,000명 기준):
```
월간 구독자 100명 × ₩4,900 = ₩490,000/월
연간 구독자 50명 × ₩49,000 = ₩2,450,000 (1회)
                            = ₩204,166/월 평균

→ 월 예상 수익: ₩694,166
→ 연 예상 수익: ₩8,329,992
```

---

### Option 2: 1회성 구매 (One-time Purchase)

**장점**:
- ✅ **높은 심리적 가치** (평생 소유)
- ✅ 사용자 부담 낮음 (1번만 결제)
- ✅ 구독 관리 불필요
- ✅ 환불 관리 단순

**단점**:
- ❌ 반복 수익 없음
- ❌ 높은 초기 가격 장벽
- ❌ 이탈 추적 어려움

**가격 예시**:
- ₩49,000 (평생)

**수익 예측** (사용자 1,000명 기준):
```
구매자 150명 × ₩49,000 = ₩7,350,000 (1회)
→ 이후 신규 유입만 의존

평균 월 신규 50명 × 15% 전환 × ₩49,000 = ₩367,500/월
→ 연 예상 수익: ₩4,410,000 (2년차 이후)
```

---

### Option 3: **하이브리드 모델** (추천! ⭐)

**전략**: 사용자 선택권 제공

```
1. 월간 구독:    ₩4,900/월  (부담 낮음)
2. 연간 구독:    ₩49,000/년 (17% 할인)
3. 평생 구매:    ₩99,000    (평생 소유)
```

**장점**:
- ✅ **최대 전환율** (가격대별 선택)
- ✅ 다양한 수익원
- ✅ 사용자 만족도 ↑
- ✅ 프리미엄 느낌

**수익 예측** (사용자 1,000명 기준):
```
월간 구독:  60명 × ₩4,900 = ₩294,000/월
연간 구독:  30명 × ₩49,000 = ₩1,470,000 (연 1회)
평생 구매:  30명 × ₩99,000 = ₩2,970,000 (1회)

→ 1년차 수익: ₩294,000×12 + ₩1,470,000 + ₩2,970,000
            = ₩7,968,000

→ 2년차+ 수익: ₩294,000×12 + ₩1,470,000 + 신규 유입
             = ₩5,058,000 + α
```

---

## 🎯 권장 모델: 하이브리드

### 이유

1. **사용자 선택권**
   - 학생/저소득: 월 ₩4,900
   - 확신있는 사용자: 평생 ₩99,000

2. **가격 심리학**
   - 월 ₩4,900 = 커피 1잔 (저렴함)
   - 평생 ₩99,000 = 체육관 3개월 (가치있음)

3. **수익 다각화**
   - 반복 수익 (구독)
   - 대형 수익 (평생)

---

## 💳 상품 구성

### Google Play 상품 ID

```dart
// lib/services/billing_service.dart

static const Set<String> _subscriptionIds = {
  'premium_monthly',   // ₩4,900/월
  'premium_yearly',    // ₩49,000/년
};

static const Set<String> _inAppPurchaseIds = {
  'premium_lifetime',  // ₩99,000 (1회)
};
```

### UserSubscription 타입 확장

```dart
// lib/models/user_subscription.dart

enum SubscriptionType {
  free,           // 무료 (Week 1-2)
  launchPromo,    // 런칭 프로모 (1개월 무료)
  monthly,        // 월간 구독 (₩4,900/월)
  yearly,         // 연간 구독 (₩49,000/년)
  lifetime,       // 평생 구매 (₩99,000, 만료 없음)
}
```

---

## 🎨 UI 표현

### Paywall 화면 (Week 2 완료 후)

```dart
showDialog(
  context: context,
  builder: (context) => PremiumPlansDialog(
    plans: [
      PremiumPlan(
        type: 'monthly',
        price: '₩4,900',
        period: '월',
        badge: '부담 없이',
        features: ['Week 3-14 접근', '클라우드 동기화'],
      ),
      PremiumPlan(
        type: 'yearly',
        price: '₩49,000',
        period: '년',
        badge: '17% 할인',
        savings: '₩9,800 절약',
        features: ['Week 3-14 접근', '클라우드 동기화'],
      ),
      PremiumPlan(
        type: 'lifetime',
        price: '₩99,000',
        period: '평생',
        badge: '인기 🔥',
        savings: '구독보다 2년 후 이득',
        features: [
          'Week 3-14 평생 접근',
          '클라우드 동기화',
          '향후 업데이트 무료',
          '프리미엄 배지',
        ],
        highlighted: true, // 추천 강조
      ),
    ],
  ),
);
```

---

## 🔄 비즈니스 로직

### 구독 vs 평생 구매 처리

```dart
// lib/services/billing_service.dart

Future<void> _activateSubscription(String productId) async {
  final auth = FirebaseAuth.instance;
  final userId = auth.currentUser?.uid;

  if (userId == null) {
    // 회원가입 유도
    _onAccountRequired?.call();
    return;
  }

  final cloudSyncService = CloudSyncService();

  // 상품 타입 확인
  UserSubscription subscription;

  if (productId == 'premium_monthly') {
    subscription = UserSubscription.createMonthlySubscription(userId);
  } else if (productId == 'premium_yearly') {
    subscription = UserSubscription.createYearlySubscription(userId);
  } else if (productId == 'premium_lifetime') {
    subscription = UserSubscription.createLifetimeSubscription(userId);
  } else {
    throw Exception('Unknown product ID: $productId');
  }

  // Firestore에 저장
  await cloudSyncService.saveSubscription(subscription);

  debugPrint('✅ 구독 활성화: ${subscription.type}');
}
```

### UserSubscription 생성자 추가

```dart
// lib/models/user_subscription.dart

// 월간 구독
static UserSubscription createMonthlySubscription(String userId) {
  final now = DateTime.now();
  final endDate = now.add(const Duration(days: 30));

  return UserSubscription(
    id: 'monthly_${userId}_${now.millisecondsSinceEpoch}',
    userId: userId,
    type: SubscriptionType.monthly,
    status: SubscriptionStatus.active,
    startDate: now,
    endDate: endDate,
    hasAds: false,
    allowedWeeks: 14,
    allowedFeatures: [...], // 모든 기능
    createdAt: now,
    updatedAt: now,
  );
}

// 연간 구독
static UserSubscription createYearlySubscription(String userId) {
  final now = DateTime.now();
  final endDate = now.add(const Duration(days: 365));

  return UserSubscription(
    id: 'yearly_${userId}_${now.millisecondsSinceEpoch}',
    userId: userId,
    type: SubscriptionType.yearly,
    status: SubscriptionStatus.active,
    startDate: now,
    endDate: endDate,
    hasAds: false,
    allowedWeeks: 14,
    allowedFeatures: [...],
    createdAt: now,
    updatedAt: now,
  );
}

// 평생 구매
static UserSubscription createLifetimeSubscription(String userId) {
  final now = DateTime.now();

  return UserSubscription(
    id: 'lifetime_${userId}_${now.millisecondsSinceEpoch}',
    userId: userId,
    type: SubscriptionType.lifetime,
    status: SubscriptionStatus.active,
    startDate: now,
    endDate: null, // 만료 없음!
    hasAds: false,
    allowedWeeks: 14,
    allowedFeatures: [
      'full_workouts',
      'cloud_sync',
      'advanced_stats',
      'achievement_system',
      'premium_badge',      // 추가!
      'future_updates',     // 추가!
      'priority_support',   // 추가!
    ],
    createdAt: now,
    updatedAt: now,
  );
}
```

---

## 💎 VIP 경험 (회원 로그인 시)

### 로그인 시 자동 처리

```dart
// lib/services/auth_service.dart

Future<void> _onLoginSuccess() async {
  try {
    debugPrint('🎉 로그인 성공 - VIP 경험 시작');

    // 1. 웰컴 메시지
    _showWelcomeMessage();

    // 2. 구독 상태 자동 복원
    await _restoreSubscription();

    // 3. 클라우드 동기화 자동 시작
    await _autoSync();

    // 4. 대기 중인 구매 처리
    await _completePendingPurchases();

    // 5. 프리로드 (빠른 로딩)
    await _preloadUserData();

    debugPrint('✅ VIP 경험 준비 완료');

  } catch (e) {
    debugPrint('⚠️ VIP 경험 준비 오류: $e');
  }
}

// 웰컴 메시지
void _showWelcomeMessage() {
  final user = _currentUser;
  if (user == null) return;

  final subscription = _currentSubscription;

  String message;
  if (subscription?.type == SubscriptionType.lifetime) {
    message = '💎 ${user.displayName}님, 평생 멤버로 돌아오셨네요!';
  } else if (subscription?.type == SubscriptionType.yearly) {
    message = '🎖️ ${user.displayName}님, 연간 멤버로 돌아오셨네요!';
  } else if (subscription?.type == SubscriptionType.monthly) {
    message = '⭐ ${user.displayName}님, 프리미엄 멤버로 돌아오셨네요!';
  } else {
    message = '👋 ${user.displayName}님, 다시 만나서 반갑습니다!';
  }

  // UI에 표시 (SnackBar or Toast)
  _welcomeMessage = message;
  notifyListeners();
}

// 구독 상태 복원
Future<void> _restoreSubscription() async {
  debugPrint('🔄 구독 상태 자동 복원 중...');

  final cloudSync = CloudSyncService();
  final subscription = await cloudSync.loadSubscription(_currentUser!.uid);

  if (subscription != null && subscription.isValid) {
    _currentSubscription = subscription;
    debugPrint('✅ 구독 복원: ${subscription.type}');
  }
}

// 클라우드 동기화
Future<void> _autoSync() async {
  debugPrint('☁️ 클라우드 자동 동기화 중...');

  final cloudSync = CloudSyncService();
  await cloudSync.syncUserData();

  debugPrint('✅ 클라우드 동기화 완료');
}

// 사용자 데이터 프리로드 (빠른 로딩)
Future<void> _preloadUserData() async {
  debugPrint('⚡ 사용자 데이터 프리로딩...');

  // 운동 기록, 진행 상황, 업적 등 미리 로드
  final cloudSync = CloudSyncService();
  await Future.wait([
    cloudSync.preloadWorkoutHistory(_currentUser!.uid),
    cloudSync.preloadProgress(_currentUser!.uid),
    cloudSync.preloadAchievements(_currentUser!.uid),
  ]);

  debugPrint('✅ 프리로드 완료 - 빠른 UI 로딩 준비');
}
```

---

## 🔐 구매 검증 로직

### 클라이언트 측 기본 검증

```dart
// lib/services/purchase_verification_service.dart

class PurchaseVerificationService {

  /// 기본 검증 (클라이언트)
  bool verifyPurchaseLocally(PurchaseDetails purchase) {
    // 1. 상품 ID 확인
    if (!_isValidProductId(purchase.productID)) {
      debugPrint('❌ 잘못된 상품 ID: ${purchase.productID}');
      return false;
    }

    // 2. 구매 상태 확인
    if (purchase.status != PurchaseStatus.purchased) {
      debugPrint('❌ 구매 미완료: ${purchase.status}');
      return false;
    }

    // 3. 타임스탬프 확인 (24시간 이내)
    final purchaseTime = DateTime.parse(purchase.transactionDate ?? '');
    final now = DateTime.now();
    final difference = now.difference(purchaseTime);

    if (difference.inHours > 24) {
      debugPrint('⚠️ 24시간 이상 경과한 구매: ${difference.inHours}시간');
      // 허용은 하되 로그 기록
    }

    debugPrint('✅ 클라이언트 검증 통과');
    return true;
  }

  bool _isValidProductId(String productId) {
    return [
      'premium_monthly',
      'premium_yearly',
      'premium_lifetime',
    ].contains(productId);
  }

  /// 서버 검증 (배포 시 구현)
  Future<bool> verifyPurchaseWithServer(
    String productId,
    String purchaseToken,
  ) async {
    try {
      debugPrint('🔐 서버 검증 시작...');

      // TODO: Firebase Functions 호출
      // final functions = FirebaseFunctions.instance;
      // final result = await functions
      //     .httpsCallable('verifyAndroidPurchase')
      //     .call({
      //   'productId': productId,
      //   'purchaseToken': purchaseToken,
      // });

      // if (result.data['verified'] == true) {
      //   debugPrint('✅ 서버 검증 성공');
      //   return true;
      // }

      // 임시: 클라이언트 검증만 사용
      debugPrint('⚠️ 서버 검증 미구현 - 클라이언트 검증만 사용');
      return true;

    } catch (e) {
      debugPrint('❌ 서버 검증 오류: $e');
      return false;
    }
  }
}
```

### billing_service.dart에 검증 추가

```dart
// lib/services/billing_service.dart

Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
  try {
    // 1. 클라이언트 검증
    final verificationService = PurchaseVerificationService();
    final isValid = verificationService.verifyPurchaseLocally(purchaseDetails);

    if (!isValid) {
      debugPrint('❌ 구매 검증 실패');
      _onPurchaseError?.call('구매 검증에 실패했습니다');
      return;
    }

    // 2. 구독 활성화
    await _activateSubscription(purchaseDetails.productID);

    // 3. (선택) 서버 검증
    // await verificationService.verifyPurchaseWithServer(
    //   purchaseDetails.productID,
    //   purchaseDetails.verificationData.serverVerificationData,
    // );

    debugPrint('✅ 구매 처리 완료');

  } catch (e) {
    debugPrint('❌ 구매 처리 오류: $e');
    _onPurchaseError?.call('구매 처리에 실패했습니다');
  }
}
```

---

## 📊 최종 권장 사항

### 구매 모델: **하이브리드** ⭐

```
1. 월간 구독:  ₩4,900/월   (부담 없음)
2. 연간 구독:  ₩49,000/년  (17% 할인)
3. 평생 구매:  ₩99,000     (평생 소유, 추천!)
```

### 이유:
1. **최대 전환율** - 가격대별 선택
2. **안정적 수익** - 구독 + 1회성
3. **사용자 만족** - 선택권 제공

---

## 🎯 구현 우선순위

### Phase 1: 기본 구조 (현재)
- [x] UserSubscription 모델 확장
- [x] billing_service 구조

### Phase 2: 상품 추가 (다음 작업)
- [ ] 평생 구매 상품 추가
- [ ] VIP 경험 구현
- [ ] 구매 검증 추가

### Phase 3: 서버 검증 (배포 전)
- [ ] Firebase Functions 구현
- [ ] Google Play API 연동

---

**작성자:** Claude
**작성일:** 2025-10-28
**결정:** 하이브리드 모델 (월간/연간/평생)
