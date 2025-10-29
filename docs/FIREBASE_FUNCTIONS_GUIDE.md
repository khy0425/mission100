# Firebase Functions 배포 가이드

## 📅 작성일: 2025-10-28

---

## 🎯 개요

Mission100 앱의 Firebase Cloud Functions는 다음 기능을 제공합니다:
1. **IAP 영수증 검증** - Google Play 구매 검증
2. **운동 알림** - 매일 오전 8시 알림
3. **Chad 레벨업 알림** - 레벨 업 시 푸시 알림
4. **업적 달성 알림** - 업적 완료 시 알림
5. **스트릭 경고** - 매일 오후 9시 스트릭 위험 알림

---

## 📁 프로젝트 구조

```
mission100_v3/
├── functions/
│   ├── index.js              # 모든 Functions 코드
│   ├── package.json          # Node.js 의존성
│   ├── .gitignore
│   └── README.md
├── lib/
│   └── services/
│       └── firebase_functions_service.dart  # Flutter에서 Functions 호출
└── pubspec.yaml              # cloud_functions: ^6.0.3 추가됨
```

---

## 🚀 배포 전 준비사항

### 1. Firebase CLI 설치

```bash
npm install -g firebase-tools
```

### 2. Firebase 로그인

```bash
firebase login
```

### 3. Firebase 프로젝트 초기화 (이미 완료된 경우 스킵)

```bash
cd mission100_v3
firebase init functions
```

### 4. Google Play Developer API 서비스 계정 생성

**⚠️ 중요: IAP 검증을 위해 필수!**

#### Step 1: Google Cloud Console에서 서비스 계정 생성
1. [Google Cloud Console](https://console.cloud.google.com/) 접속
2. Firebase 프로젝트 선택
3. **IAM & Admin** → **Service Accounts** 이동
4. **CREATE SERVICE ACCOUNT** 클릭
5. 정보 입력:
   - Name: `mission100-iap-validator`
   - Description: `IAP purchase verification`
6. **Create and Continue** 클릭
7. Role 선택: 없음 (skip)
8. **Done** 클릭

#### Step 2: 서비스 계정 키 생성
1. 생성한 서비스 계정 클릭
2. **KEYS** 탭 이동
3. **ADD KEY** → **Create new key**
4. **Key type**: JSON 선택
5. **CREATE** 클릭
6. 다운로드된 JSON 파일을 `functions/service-account-key.json` 으로 저장

#### Step 3: Google Play Console 연동
1. [Google Play Console](https://play.google.com/console/) 접속
2. 앱 선택
3. **Settings** → **API access** 이동
4. **Link** 클릭 (Google Cloud Project 연결)
5. **Service accounts** 섹션에서 방금 만든 서비스 계정 찾기
6. **Grant access** 클릭
7. Permissions:
   - **Financial data**: View (읽기 전용)
   - **Orders and subscriptions**: View
8. **Invite user** 클릭

---

## 🔐 환경 변수 설정

### 방법 1: service-account-key.json 파일 사용 (권장)

```bash
# functions/ 디렉토리에 파일 배치
cp ~/Downloads/service-account-key.json functions/
```

**⚠️ .gitignore에 추가 필수!**
```
# functions/.gitignore
service-account-key.json
```

### 방법 2: Firebase Functions Config 사용 (구형, 권장 안 함)

```bash
firebase functions:config:set googleapi.key="$(cat service-account-key.json)"
```

---

## 📦 의존성 설치

### Node.js 패키지 설치

```bash
cd functions
npm install
```

**package.json 의존성:**
```json
{
  "dependencies": {
    "firebase-admin": "^12.0.0",
    "firebase-functions": "^5.0.0",
    "googleapis": "^128.0.0"
  }
}
```

### Flutter 패키지 추가됨

```yaml
# pubspec.yaml
dependencies:
  cloud_functions: ^6.0.3
```

---

## 🛠️ Functions 코드 설명

### 1. verifyPurchase - IAP 영수증 검증

**위치:** `functions/index.js:22-87`

**기능:**
- Google Play Developer API로 구매 검증
- Firestore에 검증 결과 저장
- 클라이언트에 검증 결과 반환

**요청 파라미터:**
```json
{
  "packageName": "com.mission100.app",
  "productId": "premium_monthly",
  "purchaseToken": "opaque-token-string",
  "userId": "firebase-user-id"
}
```

**응답:**
```json
{
  "success": true,
  "verified": true,
  "expiryTime": "2025-11-28T10:00:00.000Z"
}
```

### 2. sendWorkoutReminders - 매일 운동 알림

**위치:** `functions/index.js:92-164`

**스케줄:** 매일 오전 8시 (KST)

**기능:**
- 오늘 운동 안 한 사용자 조회
- FCM 푸시 알림 전송

### 3. onUserLevelUp - Chad 레벨업 이벤트

**위치:** `functions/index.js:169-216`

**트리거:** `chadProgress/{userId}` 문서 변경 시

**기능:**
- 레벨이 올랐는지 확인
- 축하 푸시 알림 전송

### 4. onAchievementUnlocked - 업적 달성 이벤트

**위치:** `functions/index.js:221-270`

**트리거:** `achievements/{achievementId}` 문서 변경 시

**기능:**
- 업적 완료 확인
- 축하 푸시 알림 전송 (+XP 정보)

### 5. sendStreakWarnings - 스트릭 위험 알림

**위치:** `functions/index.js:275-342`

**스케줄:** 매일 오후 9시 (KST)

**기능:**
- 오늘 운동 안 한 사용자 중 스트릭이 있는 사용자 조회
- 스트릭 끊길 위기 경고 알림 전송

---

## 🚀 배포

### 1. 로컬 테스트 (선택)

```bash
cd functions
npm run serve
```

**테스트 URL:** `http://localhost:5001/YOUR_PROJECT_ID/us-central1/verifyPurchase`

### 2. 프로덕션 배포

```bash
cd mission100_v3
firebase deploy --only functions
```

**배포되는 Functions:**
- `verifyPurchase`
- `sendWorkoutReminders`
- `onUserLevelUp`
- `onAchievementUnlocked`
- `sendStreakWarnings`

### 3. 특정 Function만 배포

```bash
firebase deploy --only functions:verifyPurchase
```

### 4. 배포 확인

```bash
firebase functions:log
```

---

## 📱 Flutter 앱에서 Functions 호출

### FirebaseFunctionsService 사용

**위치:** `lib/services/firebase_functions_service.dart`

**예제:**
```dart
final functionsService = FirebaseFunctionsService();

// 구매 검증
final result = await functionsService.verifyPurchaseOnServer(
  packageName: 'com.mission100.app',
  productId: 'premium_monthly',
  purchaseToken: purchaseDetails.verificationData.serverVerificationData,
  userId: currentUser.uid,
);

if (result.isValid) {
  print('✅ 구매 검증 성공!');
  print('만료 시간: ${result.expiryTime}');
} else {
  print('❌ 검증 실패: ${result.errorMessage}');
}
```

### BillingService 통합

**TODO:** BillingService에서 FirebaseFunctionsService 호출하도록 통합

```dart
// lib/services/billing_service.dart
Future<void> _verifyPurchaseWithServer(
  String productId,
  String purchaseToken,
) async {
  final functionsService = FirebaseFunctionsService();
  final result = await functionsService.verifyPurchaseOnServer(
    packageName: 'com.mission100.app',
    productId: productId,
    purchaseToken: purchaseToken,
    userId: _authService.currentUser!.uid,
  );

  if (!result.isValid) {
    throw Exception('Server verification failed: ${result.errorMessage}');
  }
}
```

---

## 🧪 테스트

### 1. verifyPurchase 테스트

```bash
# cURL로 테스트
curl -X POST https://YOUR_REGION-YOUR_PROJECT_ID.cloudfunctions.net/verifyPurchase \
  -H "Content-Type: application/json" \
  -d '{
    "packageName": "com.mission100.app",
    "productId": "premium_monthly",
    "purchaseToken": "test-token",
    "userId": "test-user-id"
  }'
```

### 2. 스케줄된 Functions 수동 실행

Firebase Console에서:
1. **Functions** 탭 이동
2. `sendWorkoutReminders` 클릭
3. **Test function** 버튼 클릭

---

## 📊 모니터링

### 1. Functions 로그 확인

```bash
firebase functions:log
```

### 2. 특정 Function 로그만 보기

```bash
firebase functions:log --only verifyPurchase
```

### 3. Firebase Console에서 모니터링

1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 프로젝트 선택
3. **Functions** 메뉴 클릭
4. 각 Function의 실행 통계, 에러 확인

---

## ⚠️ 주의사항

### 1. 비용

Firebase Functions는 사용량에 따라 과금됩니다:
- **무료 할당량** (Blaze 플랜):
  - 호출: 2,000,000 회/월
  - 실행 시간: 400,000 GB-초/월
  - 네트워크: 5GB/월

- **초과 시 과금:**
  - 호출: $0.40 / 백만 회
  - 실행 시간: $0.0000025 / GB-초
  - 네트워크: $0.12 / GB

### 2. 보안

- ✅ `service-account-key.json`을 .gitignore에 추가 필수
- ✅ Functions는 인증된 사용자만 호출하도록 설정 (TODO)
- ✅ Firestore Security Rules 설정 필수

### 3. 에러 처리

Functions에서 에러가 발생하면:
1. 로그 확인: `firebase functions:log`
2. Crashlytics에서 확인 (설정된 경우)
3. 클라이언트에서 재시도 로직 구현

---

## 🔄 업데이트

### Functions 코드 수정 후

```bash
# 1. 로컬 테스트
npm run serve

# 2. 배포
firebase deploy --only functions

# 3. 로그 확인
firebase functions:log
```

---

## 📚 관련 문서

- [VIP_IMPLEMENTATION_SUMMARY.md](VIP_IMPLEMENTATION_SUMMARY.md) - VIP 기능 구현
- [VIP_UI_INTEGRATION.md](VIP_UI_INTEGRATION.md) - VIP UI 구현
- [SUBSCRIPTION_STRATEGY_V2.md](SUBSCRIPTION_STRATEGY_V2.md) - 구독 전략

---

## 🆘 문제 해결

### 문제 1: "service-account-key.json not found"

**원인:** 서비스 계정 키 파일이 없음

**해결:**
```bash
cp ~/Downloads/service-account-key.json functions/
```

### 문제 2: "Permission denied accessing Google Play API"

**원인:** 서비스 계정에 권한이 없음

**해결:**
1. Google Play Console → API access
2. 서비스 계정에 권한 부여 (Financial data, Orders)

### 문제 3: "Function execution failed"

**원인:** 함수 실행 중 에러 발생

**해결:**
```bash
firebase functions:log
# 에러 메시지 확인 후 코드 수정
```

### 문제 4: "Module not found"

**원인:** npm 패키지 설치 안 됨

**해결:**
```bash
cd functions
rm -rf node_modules
npm install
firebase deploy --only functions
```

---

## ✅ 배포 체크리스트

- [ ] Firebase CLI 설치 완료
- [ ] Firebase 프로젝트 초기화 완료
- [ ] Google Play Developer API 서비스 계정 생성
- [ ] service-account-key.json 파일 배치
- [ ] .gitignore에 service-account-key.json 추가
- [ ] npm install 완료
- [ ] flutter pub get 완료 (cloud_functions 패키지)
- [ ] 로컬 테스트 완료
- [ ] 프로덕션 배포 완료
- [ ] 배포 후 로그 확인
- [ ] IAP 검증 테스트 완료

---

**작성일:** 2025-10-28
**작성자:** Claude
**버전:** 1.0
**상태:** ✅ 배포 준비 완료
