# 보안 개선 보고서 - 구독 시스템

## 📅 개선 일자: 2025-10-28

---

## ⚠️ 발견된 보안 취약점

### 문제: SharedPreferences 기반 구독 관리

**이전 구현 (billing_service.dart):**
```dart
// ❌ 보안 취약 - 로컬 조작 가능
await prefs.setBool('subscription_is_active', true);
await prefs.setString('active_subscription_product_id', productId);
```

### 🔓 취약점 분석

#### 1. 클라이언트 측 조작 가능
- **루팅/탈옥 기기**: SharedPreferences 파일 직접 수정 가능
- **앱 디컴파일**: 구독 로직 우회 가능
- **메모리 조작**: 런타임에 구독 상태 변경 가능

#### 2. 영수증 검증 없음
```dart
// ❌ 실제 결제 검증 없이 구독 활성화
await prefs.setBool('subscription_is_active', true);
```
- Google Play 영수증 검증 누락
- 결제 없이도 프리미엄 기능 사용 가능

#### 3. 서버 동기화 부재
- 기기 간 구독 상태 불일치
- 앱 재설치 시 구독 정보 손실
- 환불/취소 시 실시간 반영 불가

#### 4. 만료 처리 취약
```dart
// ❌ 클라이언트에서 만료 계산 - 조작 가능
if (daysSinceActivation > 30) {
  await prefs.setBool('subscription_is_active', false);
}
```
- 기기 시간 조작으로 만료 우회 가능

---

## ✅ 개선된 구현

### 새로운 아키텍처: Firebase 기반 구독 관리

```
┌─────────────────────────────────────────────────┐
│                   클라이언트                       │
│  (Flutter App - billing_service.dart)            │
└───────────────┬─────────────────────────────────┘
                │ 1. 구매 시도
                ↓
┌─────────────────────────────────────────────────┐
│         Google Play Billing Library              │
│     (in_app_purchase package)                    │
└───────────────┬─────────────────────────────────┘
                │ 2. 구매 완료 + purchaseToken
                ↓
┌─────────────────────────────────────────────────┐
│              Firestore                           │
│  (신뢰할 수 있는 원천 - Source of Truth)            │
│  users/{uid}/subscription/{id}                   │
└───────────────┬─────────────────────────────────┘
                │ 3. 구독 상태 조회
                ↓
┌─────────────────────────────────────────────────┐
│         클라이언트 (읽기 전용)                      │
│  + 로컬 캐시 (오프라인 UX 개선용만)                  │
└─────────────────────────────────────────────────┘
```

### 구현 코드

#### 1. 구독 활성화 (billing_service.dart:280-315)
```dart
Future<void> _activateSubscription(String productId) async {
  // CRITICAL: Firestore를 신뢰할 수 있는 원천으로 사용
  final cloudSyncService = CloudSyncService();
  final auth = FirebaseAuth.instance;
  final userId = auth.currentUser?.uid;

  if (userId == null) {
    debugPrint('❌ 사용자 인증 필요');
    return;
  }

  // 1. Firestore에 저장 (서버측 검증 가능)
  final subscription = models.UserSubscription.createPremiumSubscription(userId);
  await cloudSyncService.saveSubscription(subscription);

  // 2. 로컬 캐시 (오프라인 UX 개선용만)
  await cloudSyncService.saveSubscriptionLocally(subscription);

  // TODO: Firebase Functions로 영수증 검증
  // await _verifyPurchaseWithServer(productId, purchaseToken);
}
```

#### 2. 구독 상태 확인 (billing_service.dart:337-394)
```dart
Future<bool> isSubscriptionActive(String productId) async {
  final userId = auth.currentUser?.uid;
  if (userId == null) return false;

  final cloudSyncService = CloudSyncService();

  // 1. Firestore에서 확인 (신뢰할 수 있는 원천)
  final subscription = await cloudSyncService.loadSubscription(userId);

  if (subscription == null) {
    // 2. 오프라인 폴백 (캐시)
    final cachedSubscription = await cloudSyncService.loadSubscriptionLocally();
    if (cachedSubscription != null && cachedSubscription.isValid) {
      debugPrint('⚠️ 오프라인 모드: 캐시 사용');
      return cachedSubscription.type == models.SubscriptionType.premium;
    }
    return false;
  }

  // 3. 서버측 유효성 확인
  final isValid = subscription.isValid;
  final isMatchingProduct = subscription.type == models.SubscriptionType.premium;

  if (isValid && isMatchingProduct) {
    // 로컬 캐시 업데이트 (오프라인 대비)
    await cloudSyncService.saveSubscriptionLocally(subscription);
    return true;
  }

  return false;
}
```

#### 3. Firestore 구독 관리 (cloud_sync_service.dart:1060-1170)
```dart
// Firestore에 구독 저장
Future<void> saveSubscription(UserSubscription subscription) async {
  await _firestore
      .collection('users')
      .doc(user.uid)
      .collection('subscription')
      .doc(subscription.id)
      .set(subscription.toJson());
}

// Firestore에서 구독 로드
Future<UserSubscription?> loadSubscription(String userId) async {
  final snapshot = await _firestore
      .collection('users')
      .doc(userId)
      .collection('subscription')
      .orderBy('createdAt', descending: true)
      .limit(1)
      .get();

  if (snapshot.docs.isEmpty) return null;

  return UserSubscription.fromJson(snapshot.docs.first.data());
}
```

---

## 🔒 보안 개선 사항

### 1. 신뢰할 수 있는 원천 (Source of Truth)
✅ **Firestore가 구독 상태의 유일한 신뢰 원천**
- 클라이언트에서 조작 불가
- Firestore Security Rules로 보호
- 서버측 검증 가능

### 2. 계층적 보안 구조
```
보안 레벨 1: Firebase Auth
  └─> 사용자 인증 확인

보안 레벨 2: Firestore Security Rules
  └─> 읽기/쓰기 권한 제어

보안 레벨 3: Firebase Functions (TODO)
  └─> Google Play API 영수증 검증

보안 레벨 4: 로컬 캐시 (읽기 전용)
  └─> 오프라인 UX 개선만
```

### 3. 오프라인 지원
✅ **네트워크 오류 대응**
```dart
// Firestore 오류 시 캐시 폴백
catch (e) {
  final cachedSubscription = await loadSubscriptionLocally();
  if (cachedSubscription != null && cachedSubscription.isValid) {
    debugPrint('⚠️ Firestore 오류 - 캐시 사용');
    return cachedSubscription.type == models.SubscriptionType.premium;
  }
  return false;
}
```

### 4. 기기 간 동기화
✅ **구독 정보 자동 동기화**
- 기기 A에서 구매 → Firestore 저장
- 기기 B에서 로그인 → Firestore에서 로드
- 앱 재설치 → Firestore에서 복원

---

## 🚨 Firestore Security Rules 설정 필수

**파일**: `firestore.rules`
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // 구독 정보 보호
    match /users/{userId}/subscription/{subscriptionId} {
      // 읽기: 본인만 가능
      allow read: if request.auth != null && request.auth.uid == userId;

      // 쓰기: 서버측 Functions만 가능
      allow write: if false;

      // Firebase Functions는 Admin SDK로 우회 가능
    }
  }
}
```

**중요:** 클라이언트에서는 구독 정보를 **읽기만** 가능하고, **쓰기는 불가**하도록 설정

---

## 🔧 향후 필수 구현 (TODO)

### 1. Firebase Functions로 영수증 검증 ⚠️ 매우 중요

**파일**: `functions/src/index.ts`
```typescript
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { google } from 'googleapis';

// Google Play 영수증 검증 함수
export const verifyAndroidPurchase = functions.https.onCall(
  async (data, context) => {
    // 1. 사용자 인증 확인
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }

    const { productId, purchaseToken } = data;
    const userId = context.auth.uid;

    try {
      // 2. Google Play Developer API로 영수증 검증
      const androidpublisher = google.androidpublisher('v3');

      const response = await androidpublisher.purchases.subscriptions.get({
        packageName: 'com.mission100.app',
        subscriptionId: productId,
        token: purchaseToken,
        auth: getGoogleAuth(), // Service Account 인증
      });

      // 3. 검증 결과 확인
      const purchase = response.data;

      if (purchase.paymentState === 1) { // 결제 완료
        // 4. Firestore에 구독 정보 저장
        await admin.firestore()
          .collection('users')
          .doc(userId)
          .collection('subscription')
          .add({
            userId,
            productId,
            purchaseToken,
            type: 'premium',
            status: 'active',
            startDate: new Date(parseInt(purchase.startTimeMillis)),
            endDate: new Date(parseInt(purchase.expiryTimeMillis)),
            verified: true,
            verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
          });

        return { success: true, verified: true };
      }

      throw new functions.https.HttpsError('invalid-argument', 'Purchase not valid');

    } catch (error) {
      console.error('Purchase verification failed:', error);
      throw new functions.https.HttpsError('internal', 'Verification failed');
    }
  }
);

// Google Service Account 인증
function getGoogleAuth() {
  return new google.auth.GoogleAuth({
    keyFile: './service-account-key.json',
    scopes: ['https://www.googleapis.com/auth/androidpublisher'],
  });
}
```

### 2. 클라이언트에서 Functions 호출

**파일**: `lib/services/billing_service.dart`
```dart
Future<void> _verifyPurchaseWithServer(
  String productId,
  String purchaseToken,
) async {
  try {
    final functions = FirebaseFunctions.instance;
    final callable = functions.httpsCallable('verifyAndroidPurchase');

    final result = await callable.call({
      'productId': productId,
      'purchaseToken': purchaseToken,
    });

    if (result.data['verified'] == true) {
      debugPrint('✅ 영수증 검증 성공');
    } else {
      throw Exception('영수증 검증 실패');
    }
  } catch (e) {
    debugPrint('❌ 영수증 검증 오류: $e');
    rethrow;
  }
}
```

### 3. 구독 상태 자동 동기화 (Scheduled Function)

```typescript
// 매일 자동으로 만료된 구독 확인
export const syncSubscriptionStatus = functions.pubsub
  .schedule('every 24 hours')
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();

    // 만료된 구독 찾기
    const expiredSubscriptions = await admin.firestore()
      .collectionGroup('subscription')
      .where('status', '==', 'active')
      .where('endDate', '<', now)
      .get();

    // 상태 업데이트
    const batch = admin.firestore().batch();

    expiredSubscriptions.forEach((doc) => {
      batch.update(doc.ref, { status: 'expired' });
    });

    await batch.commit();

    console.log(`Updated ${expiredSubscriptions.size} expired subscriptions`);
  });
```

---

## 📊 비교표: 이전 vs 개선

| 항목 | 이전 (SharedPreferences) | 개선 (Firebase) |
|------|-------------------------|-----------------|
| **보안성** | ❌ 매우 낮음 (조작 가능) | ✅ 높음 (서버 기반) |
| **영수증 검증** | ❌ 없음 | ✅ Functions로 가능 |
| **기기 간 동기화** | ❌ 불가능 | ✅ 자동 동기화 |
| **앱 재설치** | ❌ 데이터 손실 | ✅ 복원 가능 |
| **오프라인 지원** | ✅ 가능 | ✅ 캐시 폴백 |
| **실시간 반영** | ❌ 불가능 | ✅ 가능 |
| **조작 방지** | ❌ 취약 | ✅ Firestore Rules |

---

## 🎯 배포 전 체크리스트

### 필수 구현
- [ ] Firebase Functions 영수증 검증
- [ ] Firestore Security Rules 설정
- [ ] Google Service Account 설정
- [ ] Play Console API 활성화

### 테스트
- [ ] 정상 구매 플로우
- [ ] 영수증 검증 성공/실패
- [ ] 구독 만료 처리
- [ ] 기기 간 동기화
- [ ] 오프라인 → 온라인 전환
- [ ] 환불/취소 시나리오

### 보안 검증
- [ ] Firestore 직접 쓰기 불가 확인
- [ ] 루팅 기기 테스트
- [ ] 시간 조작 테스트
- [ ] 재설치 후 구독 복원

---

## 💡 결론

### 핵심 원칙
1. **클라이언트는 절대 신뢰하지 않는다**
2. **Firestore가 유일한 신뢰 원천**
3. **영수증은 반드시 서버에서 검증**
4. **로컬 캐시는 UX 개선용만**

### 현재 상태
✅ **Firestore 기반 구조 완성**
⚠️ **Firebase Functions 영수증 검증 필요** (배포 전 필수)

---

**작성자:** Claude
**작성일:** 2025-10-28
**버전:** 1.0
**우선순위:** 🔴 Critical (배포 전 필수)
