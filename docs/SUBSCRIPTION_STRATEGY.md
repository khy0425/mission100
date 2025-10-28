# 구독 전략 완전 가이드

## 📅 최종 확정일: 2025-10-28

---

## 🎯 비즈니스 모델

### 수익 구조

1. **1차 수익: 광고** (80-90% 사용자)
2. **2차 수익: 프리미엄 구독** (10-20% 사용자)

---

## 👥 사용자 타입별 혜택

### 1. 게스트 (비회원) 🚶

**특징:**
- 회원가입 안 함
- 앱 바로 사용 가능

**혜택:**
```
✅ Week 1-2 운동 프로그램
✅ 기본 진행 추적
✅ 로컬 데이터 저장
⚠️ 광고 표시
```

**제한:**
```
❌ Week 3-14 잠김
❌ 클라우드 동기화 불가
❌ 기기 간 데이터 이동 불가
❌ 데이터 백업 불가
```

**코드 구현:**
```dart
UserSubscription.createFreeSubscription('guest')

// 속성:
hasAds: true
allowedWeeks: 2
type: SubscriptionType.free
endDate: null (무제한)
```

---

### 2. 회원 (런칭 프로모션) 🎉

**특징:**
- 회원가입 필수
- **첫 30일 무료 체험**
- 광고는 계속 표시

**혜택:**
```
✅ Week 1-14 전체 프로그램 (30일간)
✅ 클라우드 동기화
✅ 기기 간 데이터 이동
✅ 데이터 백업
✅ 고급 통계
✅ VIP 로딩 속도 (10배 빠름)
⚠️ 광고 표시 (무료이므로)
```

**제한:**
```
⚠️ 광고 있음
⏰ 30일 후 만료
```

**30일 후 자동 처리:**
```
만료 시 → 무료 구독으로 자동 다운그레이드
- Week 1-2만 접근 가능
- 광고 계속 표시
- 클라우드 동기화 유지
```

**코드 구현:**
```dart
UserSubscription.createLaunchPromoSubscription(userId)

// 속성:
hasAds: true          // 광고 있음!
allowedWeeks: 14      // 전체 프로그램
type: SubscriptionType.launchPromo
endDate: now + 30일
```

**만료 후 자동 다운그레이드:**
```dart
// auth_service.dart:281-291
if (subscription.isExpired && subscription.type == SubscriptionType.launchPromo) {
  debugPrint('⚠️ 런칭 프로모션 만료 - 무료 구독으로 다운그레이드');

  subscription = UserSubscription.createFreeSubscription(userId);

  await cloudSyncService.saveSubscription(subscription);
  await cloudSyncService.saveSubscriptionLocally(subscription);

  debugPrint('✅ 무료 구독으로 자동 전환 완료 (Week 1-2, 광고 있음)');
}
```

---

### 3. 프리미엄 구독 💎

**특징:**
- 유료 결제 필요
- **광고 완전 제거**
- 자동 갱신

**혜택:**
```
✅ Week 1-14 전체 프로그램
✅ 클라우드 동기화
✅ 기기 간 데이터 이동
✅ 데이터 백업
✅ 고급 통계
✅ VIP 로딩 속도 (10배 빠름)
✅ 광고 없음 ⭐
✅ 프리미엄 분석
✅ 데이터 내보내기
✅ 자동 갱신
```

**제한:**
```
없음 🎉
```

**가격 옵션 (예정):**
```
월간: ₩4,900/월
연간: ₩49,000/년 (17% 할인)
평생: ₩99,000 (1회 결제)
```

**코드 구현:**
```dart
UserSubscription.createPremiumSubscription(userId)

// 속성:
hasAds: false         // 광고 없음!
allowedWeeks: 14      // 전체 프로그램
type: SubscriptionType.premium
endDate: now + 30일   // 월간 구독
```

**자동 갱신 처리:**
```dart
// auth_service.dart:292-315
if (subscription.isExpired && subscription.type == SubscriptionType.premium) {
  debugPrint('⚠️ 프리미엄 구독 만료 - 자동 갱신 확인 중...');

  final isRenewed = await _checkAndRenewSubscription(userId);

  if (isRenewed) {
    // 자동 갱신 성공 - 새로운 구독 생성
    subscription = UserSubscription.createPremiumSubscription(userId);

    await cloudSyncService.saveSubscription(subscription);
    await cloudSyncService.saveSubscriptionLocally(subscription);

    debugPrint('✅ 프리미엄 구독 자동 갱신 완료 (30일 연장)');
  } else {
    // 자동 갱신 실패 또는 취소 - 무료로 다운그레이드
    subscription = UserSubscription.createFreeSubscription(userId);

    await cloudSyncService.saveSubscription(subscription);
    await cloudSyncService.saveSubscriptionLocally(subscription);

    debugPrint('✅ 무료 구독으로 자동 전환 완료 (갱신 실패)');
  }
}
```

---

## 📊 비교표

| 항목 | 게스트 | 회원 (런칭 프로모션) | 프리미엄 |
|------|--------|---------------------|---------|
| **가입** | 불필요 | 필수 | 필수 + 결제 |
| **가격** | 무료 | 무료 (30일) | ₩4,900/월 |
| **광고** | ⚠️ 있음 | ⚠️ 있음 | ✅ 없음 |
| **프로그램** | Week 1-2 | Week 1-14 (30일) | Week 1-14 |
| **클라우드** | ❌ | ✅ | ✅ |
| **VIP 속도** | ❌ | ✅ | ✅ |
| **고급 통계** | ❌ | ✅ | ✅ |
| **데이터 백업** | ❌ | ✅ | ✅ |
| **만료 후** | - | Week 1-2 다운그레이드 | 자동 갱신 또는 다운그레이드 |

---

## 🔄 사용자 전환 플로우

### Flow 1: 게스트 → 회원 → 프리미엄

```
📱 앱 설치
    ↓
🚶 게스트로 시작
    - 광고 ⚠️
    - Week 1-2만
    - 로컬 데이터만
    ↓
👤 회원가입 (이메일/Google)
    - 광고 ⚠️ (계속)
    - Week 1-14 전체 (30일)
    - 클라우드 동기화 ✅
    - VIP 속도 ⚡
    ↓
⏰ 30일 경과
    - 무료 구독으로 자동 다운그레이드
    - Week 1-2만 다시 제한
    - 광고 계속 ⚠️
    ↓
💳 프리미엄 구독 결제
    - 광고 제거 ✅
    - Week 1-14 전체 (영구)
    - 모든 프리미엄 기능
    - 자동 갱신 🔄
```

### Flow 2: 게스트 → 바로 프리미엄

```
📱 앱 설치
    ↓
🚶 게스트로 시작
    ↓
💳 Week 3 구매 시도
    ↓
⚠️ 회원가입 필요 알림
    ↓
👤 회원가입 + 구매 완료
    ↓
💎 프리미엄 회원 (바로 시작)
    - 광고 없음 ✅
    - Week 1-14 전체
```

---

## 💰 수익 예상

### 사용자 분포 (가정)

```
총 사용자: 10,000명

게스트 (비회원): 5,000명 (50%)
- 광고 수익만

회원 (무료): 4,000명 (40%)
- 광고 수익
- 30일 후 프리미엄 전환 가능성

프리미엄: 1,000명 (10%)
- 구독 수익
- 광고 없음
```

### 월간 수익 계산

**광고 수익:**
```
게스트: 5,000명 × ₩500/월 = ₩2,500,000
회원:   4,000명 × ₩500/월 = ₩2,000,000
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
광고 총수익:                 ₩4,500,000
```

**구독 수익:**
```
프리미엄: 1,000명 × ₩4,900/월 = ₩4,900,000
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
구독 총수익:                 ₩4,900,000
```

**총 수익:**
```
광고:     ₩4,500,000 (48%)
구독:     ₩4,900,000 (52%)
━━━━━━━━━━━━━━━━━━━━━━━━
총합:     ₩9,400,000/월
연간:    ₩112,800,000/년
```

---

## 🎯 전환 전략

### 런칭 프로모션 → 프리미엄 전환

**타이밍:**

1. **25일차 알림**: "5일 후 Week 3-14가 잠깁니다"
2. **28일차 알림**: "2일 후 Week 3-14가 잠깁니다 - 지금 구독하면 계속 사용 가능"
3. **30일차 알림**: "Week 3-14가 잠겼습니다 - 광고 없이 계속하려면 프리미엄 구독"

**전환 메시지 예시:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎉 30일 무료 체험이 종료되었습니다

Week 3-14 프로그램을 계속 이용하려면
프리미엄 구독을 시작하세요!

✨ 프리미엄 혜택:
✅ 광고 제거
✅ 전체 14주 프로그램
✅ 자동 백업
✅ 기기 간 동기화

💳 월 ₩4,900
💎 연 ₩49,000 (17% 할인)
🏆 평생 ₩99,000

[프리미엄 시작하기] [나중에]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**예상 전환율:**

```
회원 4,000명 중:
- 즉시 전환: 5% (200명)
- 재가입: 3% (120명)
- 이탈: 92% (3,680명)

월간 추가 수익:
200명 × ₩4,900 = ₩980,000
```

---

## 🔒 보안 고려사항

### 구독 상태 검증

**신뢰할 수 있는 원천: Firestore**

```
구독 상태 확인 우선순위:
1. Firestore (서버, 조작 불가) ✅
2. SharedPreferences (로컬 캐시, 오프라인 UX용만)
```

**코드:**
```dart
// billing_service.dart:382-443
Future<bool> isSubscriptionActive(String productId) async {
  final userId = auth.currentUser?.uid;
  if (userId == null) return false;

  // 1. Firestore 확인 (신뢰할 수 있는 원천)
  final subscription = await cloudSyncService.loadSubscription(userId);

  if (subscription == null) {
    // 2. 로컬 캐시 (오프라인 폴백만)
    final cachedSubscription = await cloudSyncService.loadSubscriptionLocally();
    if (cachedSubscription != null && cachedSubscription.isValid) {
      debugPrint('⚠️ 오프라인 모드: 캐시된 구독 사용');
      return cachedSubscription.type == SubscriptionType.premium;
    }
    return false;
  }

  // 3. 유효성 확인
  return subscription.isValid && subscription.type == SubscriptionType.premium;
}
```

### Security Rules (필수)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/subscription/{subscriptionId} {
      // 읽기: 본인만 가능
      allow read: if request.auth != null && request.auth.uid == userId;

      // 쓰기: 클라이언트 차단 (서버만 가능)
      allow write: if false;
    }
  }
}
```

---

## 📝 구현 체크리스트

### ✅ 완료된 기능

- [x] 게스트 무료 구독 (Week 1-2, 광고)
- [x] 회원 런칭 프로모션 (30일, Week 1-14, 광고)
- [x] 프리미엄 구독 (광고 없음, Week 1-14)
- [x] 30일 만료 후 자동 다운그레이드
- [x] 구독 상태 Firestore 저장
- [x] 로컬 캐시 (오프라인 UX)
- [x] VIP 로딩 경험

### ⏳ TODO (배포 전 필수)

- [ ] Google Play Billing 자동 갱신 연동
- [ ] Firebase Functions 영수증 검증
- [ ] Firestore Security Rules 설정
- [ ] 만료 알림 시스템 (25/28/30일)
- [ ] 전환 UI/UX (페이월)

---

## 🎨 광고 표시 로직

### 광고 표시 조건

```dart
// auth_service.dart:398
bool get hasAds {
  return _currentSubscription?.hasAds ?? true;
}
```

**광고가 표시되는 경우:**
```
✅ 게스트 (비회원)
✅ 회원 (런칭 프로모션)
✅ 회원 (프로모션 만료 후 무료 전환)
```

**광고가 표시되지 않는 경우:**
```
❌ 프리미엄 구독
```

### 광고 SDK 통합 (예정)

```dart
// 광고 표시 예시
if (authService.hasAds) {
  // AdMob 광고 로드
  _loadInterstitialAd();
  _loadBannerAd();
} else {
  // 광고 숨김
  _hideAllAds();
}
```

---

## 📈 성공 지표 (KPI)

### 목표

| 지표 | 목표 |
|------|------|
| 회원 가입율 | 50% |
| 30일 리텐션 | 40% |
| 프리미엄 전환율 | 5-8% |
| 월간 ARPU | ₩940 |
| 연간 LTV | ₩15,000 |

### 측정 방법

```dart
// Firebase Analytics 이벤트
- user_signup (회원가입)
- premium_purchase (프리미엄 구매)
- promo_expired (프로모션 만료)
- premium_renewed (자동 갱신)
- user_downgraded (다운그레이드)
```

---

## 🎯 요약

### 핵심 전략

1. **진입 장벽 낮춤**: 게스트로 바로 시작
2. **가치 경험**: 회원가입 → 30일 전체 프로그램 무료
3. **광고 수익 유지**: 무료 기간에도 광고 표시
4. **전환 유도**: 30일 후 Week 3-14 잠금
5. **프리미엄 차별화**: 광고 제거 + 모든 기능

### 수익 밸런스

```
광고 수익: 48% (게스트 + 회원)
구독 수익: 52% (프리미엄)
━━━━━━━━━━━━━━━━━━━━━━━━
안정적인 듀얼 수익 모델
```

---

**작성자:** Claude
**최종 확정일:** 2025-10-28
**상태:** ✅ 완료
**우선순위:** 🔴 Production Critical
