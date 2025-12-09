# Google Play Console 인앱 결제 설정 가이드

## DreamFlow (드림플로) - 프리미엄 구독 설정

---

## 📋 목차

1. [개요](#개요)
2. [사전 준비사항](#사전-준비사항)
3. [Google Play Console 설정](#google-play-console-설정)
4. [인앱 상품 등록](#인앱-상품-등록)
5. [테스트 설정](#테스트-설정)
6. [배포 및 검증](#배포-및-검증)
7. [문제 해결](#문제-해결)

---

## 개요

DreamFlow 앱의 프리미엄 구독 기능을 활성화하기 위한 Google Play Console 설정 가이드입니다.

### 구독 상품 정보
- **상품 ID**: `premium_lifetime`
- **상품 유형**: 비소비성 상품 (Non-consumable)
- **가격**: ₩5,900 (KRW)
- **설명**: 평생 프리미엄 구독

### 프리미엄 혜택
1. 광고 제거
2. Lumi 완전 진화 (Week 2-14 단계)
3. 무제한 AI 꿈 분석
4. 고급 통계 분석
5. 데이터 내보내기

---

## 사전 준비사항

### 1. Google Play Console 계정
- ✅ Google Play Developer 계정 등록 완료 (25달러 등록비 결제)
- ✅ 앱이 Google Play Console에 등록됨

### 2. 앱 서명 키
- ✅ 앱 번들(.aab) 업로드용 키스토어 준비
- ✅ 앱 서명 인증서 (SHA-1, SHA-256) 확인

### 3. Firebase 설정
- ✅ Firebase 프로젝트 생성 및 연동
- ✅ Firebase Authentication 활성화
- ✅ Cloud Firestore 데이터베이스 생성

---

## Google Play Console 설정

### 1단계: Google Play Console 접속

1. [Google Play Console](https://play.google.com/console)에 로그인
2. DreamFlow 앱 선택

### 2단계: 인앱 상품 설정 준비

1. 왼쪽 메뉴에서 **"수익 창출" → "상품"** 클릭
2. **"구독"** 또는 **"인앱 상품"** 탭 선택
   - 평생 구독의 경우: **"인앱 상품"** 선택 (비소비성 상품)

---

## 인앱 상품 등록

### 3단계: 상품 생성

#### 비소비성 상품 (Non-consumable) 등록

1. **"상품 만들기"** 버튼 클릭

2. **상품 ID 입력**
   ```
   premium_lifetime
   ```
   ⚠️ **주의**: 상품 ID는 한 번 설정하면 변경 불가능합니다!

3. **상품 세부정보 입력**

   | 필드 | 값 |
   |------|-----|
   | **상품 이름** | DreamFlow Premium (평생) |
   | **설명** | 평생 프리미엄 구독 - 광고 제거, Lumi 완전 진화, 무제한 AI 분석 |
   | **기본 가격** | ₩5,900 (KRW) |

4. **가격 설정**
   - "국가별 가격 추가" 클릭
   - **대한민국 (KRW)**: ₩5,900
   - **미국 (USD)**: $4.99
   - **일본 (JPY)**: ¥650

5. **상태**
   - "활성화" 선택

6. **저장** 클릭

---

## 테스트 설정

### 4단계: 테스트 계정 추가

#### 1. 라이선스 테스터 추가

1. Google Play Console에서 **"설정" → "라이선스 테스트"** 이동
2. **"라이선스 테스터 추가"** 클릭
3. 테스트할 Gmail 계정 입력 (쉼표로 구분)
   ```
   your-test-account@gmail.com
   ```
4. **저장** 클릭

#### 2. 테스트 트랙 생성 (내부 테스트)

1. **"출시" → "테스트" → "내부 테스트"** 이동
2. **"새 버전 만들기"** 클릭
3. **App Bundle (.aab) 업로드**
4. **테스터 추가**
   - "테스터 목록 만들기" 클릭
   - Gmail 주소 입력
5. **버전 검토 후 출시**

#### 3. 테스트 방법

**라이선스 테스터 계정으로 테스트:**
- ✅ **실제 결제 없이** 인앱 결제 테스트 가능
- ✅ Google Play에서 "테스트 카드" 표시
- ✅ 구매 플로우 정상 동작 확인

**일반 사용자 계정으로 테스트:**
- ❌ 실제 결제 발생 (추후 환불 필요)
- ✅ 프로덕션 환경과 동일한 테스트

---

## 배포 및 검증

### 5단계: 앱 배포

#### 1. 프로덕션 배포

1. **"출시" → "프로덕션"** 이동
2. **"새 버전 만들기"** 클릭
3. **App Bundle (.aab) 업로드**
4. **출시 노트 작성**
   ```
   ✨ 새로운 기능:
   - 프리미엄 구독 추가
   - Lumi 캐릭터 진화 시스템
   - AI 기반 꿈 분석
   ```
5. **검토 제출**

#### 2. Google Play 검토 대기
- ⏱️ 검토 시간: 보통 1-3일
- 📧 검토 완료 시 이메일 알림

### 6단계: 상품 활성화 확인

1. **"수익 창출" → "상품"** 이동
2. `premium_lifetime` 상태 확인
   - ✅ **활성화** 상태여야 함
3. Play Store에서 앱 검색 후 인앱 상품 표시 확인

---

## 앱 코드 확인 사항

### BillingService 설정

**파일**: `lib/services/payment/billing_service.dart`

```dart
// 구독 상품 ID 목록
static const Set<String> _subscriptionIds = {
  'premium_monthly',   // 월간 구독 (미사용)
  'premium_yearly',    // 연간 구독 (미사용)
  'premium_lifetime',  // ✅ 평생 구독 (사용 중)
};
```

### AndroidManifest.xml 권한 확인

**파일**: `android/app/src/main/AndroidManifest.xml`

```xml
<!-- 인앱 결제 권한 -->
<uses-permission android:name="com.android.vending.BILLING" />
```

### build.gradle 의존성 확인

**파일**: `android/app/build.gradle`

```gradle
dependencies {
    // Google Play Billing Library (in_app_purchase 플러그인이 자동 포함)
    implementation 'com.android.billingclient:billing:5.0.0'
}
```

---

## 문제 해결

### 일반적인 문제

#### 1. "상품을 불러올 수 없습니다"

**원인:**
- 상품 ID 오타
- 상품이 활성화되지 않음
- 앱 서명 불일치

**해결 방법:**
1. Google Play Console에서 상품 ID 확인: `premium_lifetime`
2. 상품 상태가 "활성화"인지 확인
3. 앱 서명 키 일치 여부 확인
   ```bash
   keytool -list -v -keystore your-keystore.jks
   ```

#### 2. "이 아이템을 구입할 수 없습니다"

**원인:**
- 테스터 계정이 라이선스 테스터에 추가되지 않음
- 앱이 프로덕션/테스트 트랙에 배포되지 않음

**해결 방법:**
1. **"설정" → "라이선스 테스트"**에 Gmail 추가
2. 내부 테스트 트랙에 앱 배포
3. 테스터 계정으로 옵트인 링크 접속

#### 3. "결제 처리 실패"

**원인:**
- Firebase Functions 결제 검증 실패
- 네트워크 연결 문제

**해결 방법:**
1. Logcat 로그 확인
   ```bash
   adb logcat | grep BillingService
   ```
2. Firebase Console에서 Functions 로그 확인
3. 인터넷 연결 상태 확인

#### 4. "구독 상태가 동기화되지 않음"

**원인:**
- Firestore 권한 설정 문제
- 오프라인 상태

**해결 방법:**
1. Firestore 규칙 확인
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       match /subscriptions/{subscriptionId} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```
2. 네트워크 연결 확인
3. 앱 재시작

---

## 테스트 체크리스트

### 결제 플로우 테스트

- [ ] 1. 프리미엄 업그레이드 다이얼로그 표시
- [ ] 2. "프리미엄 시작하기" 버튼 클릭
- [ ] 3. Google Play 결제 화면 표시
- [ ] 4. 결제 정보 입력 (테스터는 "테스트 카드" 표시)
- [ ] 5. 결제 완료 후 Firestore에 구독 정보 저장
- [ ] 6. 앱에서 프리미엄 기능 활성화 확인
- [ ] 7. Week 2+ 단계 해금 확인
- [ ] 8. 광고 제거 확인

### 구독 복원 테스트

- [ ] 1. 앱 삭제
- [ ] 2. 앱 재설치
- [ ] 3. 동일 계정으로 로그인
- [ ] 4. "구독 복원" 버튼 클릭
- [ ] 5. 프리미엄 상태 복원 확인

---

## 참고 자료

### 공식 문서
- [Google Play Billing Library 가이드](https://developer.android.com/google/play/billing)
- [in_app_purchase 플러그인 문서](https://pub.dev/packages/in_app_purchase)
- [Firebase Authentication](https://firebase.google.com/docs/auth)

### 앱 관련 파일
- `lib/services/payment/billing_service.dart` - 결제 서비스
- `lib/screens/settings/subscription_screen.dart` - 구독 화면
- `lib/widgets/common/premium_gate_widget.dart` - 프리미엄 게이트
- `lib/models/user_subscription.dart` - 구독 모델

### 지원
문제 발생 시:
1. Logcat 로그 확인
2. Firebase Console 확인
3. Google Play Console 상태 확인

---

## 마지막 확인 사항

### 배포 전 체크리스트
- [x] Google Play Console에 `premium_lifetime` 상품 등록
- [x] 상품 가격 ₩5,900 설정
- [x] 상품 활성화 완료
- [x] 라이선스 테스터 추가
- [x] 내부 테스트 트랙 배포
- [x] 테스트 계정으로 결제 테스트 완료
- [x] BillingService 정상 동작 확인
- [x] Firestore 구독 저장/로드 정상 동작
- [x] 프리미엄 기능 활성화 확인

---

## 🎉 축하합니다!

DreamFlow 프리미엄 구독 설정이 완료되었습니다!

**다음 단계:**
1. 프로덕션 배포
2. 사용자 피드백 수집
3. 구독 전환율 모니터링

**추가 문의:**
- 개발팀 이메일: support@dreamflow.app
- Firebase Console: https://console.firebase.google.com
- Google Play Console: https://play.google.com/console
