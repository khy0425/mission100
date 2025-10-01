# Firebase 프로덕션 프로젝트 설정 가이드

## 🎯 목표
개발 환경과 분리된 프로덕션 Firebase 프로젝트를 생성하고 Mission100 앱과 연동

---

## 📋 체크리스트

### Phase 1: Firebase 프로젝트 생성
- [ ] Firebase Console에서 새 프로젝트 생성
- [ ] Google Analytics 설정
- [ ] 프로젝트 ID 확인 및 기록
- [ ] 결제 계정 연결 (Blaze 플랜)

### Phase 2: Android 앱 등록
- [ ] Android 앱 추가
- [ ] 패키지명 등록
- [ ] SHA-1 인증서 지문 등록
- [ ] google-services.json 다운로드

### Phase 3: Firebase 서비스 활성화
- [ ] Authentication 설정
- [ ] Firestore Database 생성
- [ ] Cloud Storage 설정
- [ ] Cloud Functions 설정 (선택)

### Phase 4: 보안 규칙 배포
- [ ] Firestore 보안 규칙 배포
- [ ] Firestore 인덱스 배포
- [ ] Storage 보안 규칙 설정

### Phase 5: 앱 통합
- [ ] google-services.json 교체
- [ ] 환경 설정 파일 업데이트
- [ ] 빌드 및 테스트

---

## 🚀 Step-by-Step 가이드

### Step 1: Firebase 프로젝트 생성

#### 1.1 Firebase Console 접속
```
1. https://console.firebase.google.com/ 접속
2. "프로젝트 추가" 클릭
```

#### 1.2 프로젝트 정보 입력
```
프로젝트 이름: Mission100 Production
프로젝트 ID: mission100-prod (또는 자동 생성)

⚠️ 중요: 프로젝트 ID는 변경 불가!
```

#### 1.3 Google Analytics 설정
```
✅ Google Analytics 사용 설정 (권장)

이유:
- 사용자 행동 분석
- 전환율 추적
- A/B 테스트
- 잠재고객 타게팅

계정 선택:
- 기존 계정 사용 또는
- 새 계정 생성: "Mission100 Analytics"
```

#### 1.4 프로젝트 생성 완료
```
"프로젝트 만들기" 클릭
→ 약 30초 소요
→ "프로젝트가 준비되었습니다" 표시
```

---

### Step 2: Blaze 플랜 업그레이드 (필수)

#### 2.1 요금제 변경
```
Firebase Console → 좌측 하단 "업그레이드" 클릭

Spark (무료) → Blaze (종량제)

이유:
- Cloud Functions 사용 (결제 검증)
- Firestore 쿼리 제한 해제
- 프로덕션 수준 성능
```

#### 2.2 예산 알림 설정
```
Firebase Console → 톱니바퀴 → "사용량 및 결제"

예산 알림 설정:
1차 알림: ₩50,000 (50%)
2차 알림: ₩75,000 (75%)
3차 알림: ₩100,000 (100%)

월 예산: ₩100,000 설정 권장
```

#### 2.3 결제 계정 연결
```
Google Cloud Console 자동 연결
→ 신용카드 또는 직불카드 등록
→ 한국 원화(KRW) 결제
```

---

### Step 3: Android 앱 등록

#### 3.1 Android 앱 추가
```
Firebase Console → 프로젝트 개요 → "앱 추가"
→ Android 아이콘 선택
```

#### 3.2 패키지명 등록
```
Android 패키지 이름:
com.mission100.app

⚠️ 주의:
- Google Play Console의 패키지명과 동일해야 함
- 등록 후 변경 불가
- 정확히 입력하세요!

앱 닉네임 (선택):
Mission100 Android

Debug 서명 인증서 SHA-1 (선택):
→ 나중에 추가 가능 (Google 로그인 시 필요)
```

#### 3.3 SHA-1 인증서 지문 생성

##### 개발용 SHA-1 (디버그)
```bash
# Windows (PowerShell)
cd C:\Users\%USERNAME%\.android
keytool -list -v -keystore debug.keystore -alias androiddebugkey -storepass android -keypass android

# macOS/Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# 출력 예시:
SHA1: A1:B2:C3:D4:E5:F6:G7:H8:I9:J0:K1:L2:M3:N4:O5:P6:Q7:R8:S9:T0
```

##### 프로덕션용 SHA-1 (릴리즈)
```bash
# Windows
keytool -list -v -keystore E:\Projects\mission100_v3\android\keystore\mission100-release.jks -alias mission100

# 비밀번호 입력 필요
Enter keystore password: [YOUR_KEYSTORE_PASSWORD]

# SHA-1 지문 복사
SHA1: [복사할 값]
```

#### 3.4 SHA-1 등록
```
Firebase Console → 프로젝트 설정 → 내 앱 → Mission100 Android

"SHA 인증서 지문 추가" 클릭
→ 디버그 SHA-1 입력 (개발용)
→ 릴리즈 SHA-1 입력 (프로덕션용)

✅ 두 개 모두 등록 권장!
```

#### 3.5 google-services.json 다운로드
```
"google-services.json 다운로드" 버튼 클릭

저장 위치:
E:\Projects\mission100_v3\android\app\google-services.json

⚠️ 중요:
- 기존 파일 백업 (개발용)
- 새 파일로 교체
- Git에 커밋하지 말 것 (.gitignore 확인)
```

---

### Step 4: Firebase Authentication 설정

#### 4.1 Authentication 활성화
```
Firebase Console → 빌드 → Authentication → "시작하기"
```

#### 4.2 로그인 제공업체 설정

##### 이메일/비밀번호 로그인
```
Sign-in method 탭 → "이메일/비밀번호" 클릭

✅ 사용 설정 활성화
✅ 이메일 링크 (비밀번호 없는 로그인) - 선택 사항

"저장" 클릭
```

##### Google 로그인 (권장)
```
Sign-in method 탭 → "Google" 클릭

✅ 사용 설정 활성화

프로젝트 지원 이메일:
→ 본인 Gmail 주소 입력

공개용 프로젝트 이름:
→ "Mission100"

"저장" 클릭

⚠️ Google 로그인 동작을 위해 SHA-1 필수!
```

##### 익명 로그인 (선택)
```
Sign-in method 탭 → "익명" 클릭

✅ 사용 설정 활성화

용도: 게스트 사용자, 테스트
```

#### 4.3 승인된 도메인 추가
```
Settings 탭 → "승인된 도메인"

기본 포함:
- localhost (개발용)
- [프로젝트ID].firebaseapp.com

추가 필요 시:
- mission100.app (사용자 도메인)
- www.mission100.app
```

---

### Step 5: Firestore Database 생성

#### 5.1 Firestore 초기화
```
Firebase Console → 빌드 → Firestore Database → "데이터베이스 만들기"
```

#### 5.2 보안 규칙 모드 선택
```
⚠️ 프로덕션 모드 선택 (권장)

프로덕션 모드:
- 모든 읽기/쓰기 거부 (기본)
- 보안 규칙 직접 설정
- 안전함 ✅

테스트 모드:
- 30일간 모든 접근 허용
- 보안 취약 ❌
- 절대 사용 금지!
```

#### 5.3 위치 선택
```
Cloud Firestore 위치 선택:

권장: asia-northeast3 (서울)

이유:
- 한국 사용자 타겟
- 낮은 지연시간
- 가장 가까운 리전

⚠️ 주의: 위치 변경 불가!

대안 (글로벌):
- asia-northeast1 (도쿄) - 2순위
- us-central1 (아이오와) - 미국 타겟 시
```

#### 5.4 데이터베이스 생성 완료
```
"사용 설정" 클릭
→ 약 1분 소요
→ 빈 데이터베이스 생성됨
```

---

### Step 6: Firestore 보안 규칙 배포

#### 6.1 Firebase CLI 설치 (로컬에서)
```bash
# Node.js가 설치되어 있어야 함
npm install -g firebase-tools

# 설치 확인
firebase --version
```

#### 6.2 Firebase 로그인
```bash
firebase login

# 브라우저 자동 열림
→ Google 계정으로 로그인
→ Firebase CLI 권한 허용
→ 터미널에 "Success!" 표시
```

#### 6.3 Firebase 프로젝트 초기화
```bash
cd E:\Projects\mission100_v3

# Firebase 초기화
firebase init

# 선택 메뉴:
? Which Firebase features do you want to set up?
✅ Firestore: Configure security rules and indexes files
✅ Functions: Configure a Cloud Functions directory (선택)
✅ Hosting: Configure files for Firebase Hosting (선택)
✅ Storage: Configure a security rules file for Cloud Storage (선택)

# 프로젝트 선택:
? Select a default Firebase project for this directory:
→ mission100-prod (방금 생성한 프로젝트)

# Firestore 파일 선택:
? What file should be used for Firestore Rules?
→ firestore.rules (기본값, 이미 존재)

? What file should be used for Firestore indexes?
→ firestore.indexes.json (기본값, 이미 존재)
```

#### 6.4 보안 규칙 배포
```bash
# Firestore 규칙 및 인덱스 배포
firebase deploy --only firestore

# 출력 예시:
=== Deploying to 'mission100-prod'...

i  deploying firestore
i  firestore: reading indexes from firestore.indexes.json...
i  firestore: reading rules from firestore.rules...
✔  firestore: deployed indexes in firestore.indexes.json successfully
✔  firestore: released rules firestore.rules to cloud.firestore

✔  Deploy complete!

Project Console: https://console.firebase.google.com/project/mission100-prod/overview
```

#### 6.5 규칙 배포 확인
```
Firebase Console → Firestore Database → 규칙 탭

배포된 규칙 확인:
- 339줄의 보안 규칙 표시
- isAuthenticated(), isOwner(), isPremiumUser() 함수 확인
- 게시 날짜/시간 표시

인덱스 탭:
- 복합 인덱스 목록 표시
- 상태: "사용 설정됨"
```

---

### Step 7: Cloud Storage 설정 (선택)

#### 7.1 Storage 활성화
```
Firebase Console → 빌드 → Storage → "시작하기"

보안 규칙 모드:
→ 프로덕션 모드 선택 (권장)

위치:
→ asia-northeast3 (서울) - Firestore와 동일
```

#### 7.2 Storage 보안 규칙
```javascript
// storage.rules
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // 사용자 프로필 이미지
    match /users/{userId}/profile/{fileName} {
      allow read: if true; // 공개
      allow write: if request.auth != null && request.auth.uid == userId
                   && request.resource.size < 5 * 1024 * 1024 // 5MB 제한
                   && request.resource.contentType.matches('image/.*');
    }

    // 운동 사진 (선택)
    match /users/{userId}/workouts/{fileName} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId
                   && request.resource.size < 10 * 1024 * 1024; // 10MB
    }

    // 기본: 모든 접근 거부
    match /{allPaths=**} {
      allow read, write: if false;
    }
  }
}
```

#### 7.3 Storage 규칙 배포
```bash
firebase deploy --only storage

# 또는 전체 배포
firebase deploy
```

---

### Step 8: 환경 설정 파일 업데이트

#### 8.1 프로덕션 설정 파일 수정
```json
// assets/config/prod_config.json
{
  "environment": "production",
  "firebase": {
    "projectId": "mission100-prod",  // ← 새 프로젝트 ID
    "apiKey": "AIza...",              // ← google-services.json에서 복사
    "appId": "1:123...:android:abc",  // ← google-services.json에서 복사
    "messagingSenderId": "123456789",
    "storageBucket": "mission100-prod.appspot.com"
  },
  "api": {
    "baseUrl": "https://mission100.app/api",
    "timeout": 30000
  },
  "admob": {
    "androidAppId": "ca-app-pub-YOUR_PROD_ID~YOUR_APP_ID",
    "bannerAdUnitId": "ca-app-pub-YOUR_PROD_ID/YOUR_BANNER_ID",
    "interstitialAdUnitId": "ca-app-pub-YOUR_PROD_ID/YOUR_INTERSTITIAL_ID"
  },
  "features": {
    "enableAnalytics": true,
    "enableCrashlytics": true,
    "enablePerformanceMonitoring": true
  }
}
```

#### 8.2 google-services.json 값 확인
```json
// android/app/google-services.json (다운로드한 파일 확인)
{
  "project_info": {
    "project_number": "123456789",
    "firebase_url": "https://mission100-prod.firebaseio.com",
    "project_id": "mission100-prod",
    "storage_bucket": "mission100-prod.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:123456789:android:abc123def456",
        "android_client_info": {
          "package_name": "com.mission100.app"
        }
      },
      "api_key": [
        {
          "current_key": "AIzaSy..."  // ← 이 값을 prod_config.json에 복사
        }
      ]
    }
  ]
}
```

---

### Step 9: 프로덕션 빌드 및 테스트

#### 9.1 개발용 파일 백업
```bash
# 기존 개발용 파일 백업
copy android\app\google-services.json android\app\google-services-dev.json

# .gitignore 확인
echo android/app/google-services.json >> .gitignore
echo assets/config/prod_config.json >> .gitignore
```

#### 9.2 프로덕션 빌드
```bash
# 캐시 정리
flutter clean

# 패키지 다시 받기
flutter pub get

# 프로덕션 빌드 (디버그)
flutter build apk --debug --dart-define=ENV=production

# 빌드 성공 확인
# ✓ Built build\app\outputs\flutter-apk\app-debug.apk
```

#### 9.3 실제 디바이스 테스트
```bash
# 디바이스 연결 확인
flutter devices

# 앱 설치 및 실행
flutter run --debug --dart-define=ENV=production

# 테스트 항목:
✅ 1. 앱 시작 (크래시 없음)
✅ 2. Firebase 연결 (로그 확인)
✅ 3. 회원가입 (이메일/비밀번호)
✅ 4. 로그인 (Google 로그인 포함)
✅ 5. Firestore 읽기/쓰기
✅ 6. 로그아웃
```

#### 9.4 Firebase Console에서 확인
```
1. Authentication:
   → 사용자 탭에서 테스트 계정 확인

2. Firestore:
   → 데이터 탭에서 컬렉션 생성 확인
   → users, userProfiles, workoutRecords 등

3. Analytics (24시간 후):
   → 대시보드에서 이벤트 확인
   → 사용자 수, 세션 수 등
```

---

### Step 10: Cloud Functions 설정 (선택)

#### 10.1 Functions 디렉토리 생성
```bash
cd E:\Projects\mission100_v3

# Functions 초기화
firebase init functions

? What language would you like to use?
→ TypeScript (권장)

? Do you want to use ESLint?
→ Yes

? Do you want to install dependencies now?
→ Yes (npm install)
```

#### 10.2 결제 검증 Function 작성
```typescript
// functions/src/index.ts
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

// 구독 검증 Function
export const verifySubscription = functions
  .region("asia-northeast3") // 서울 리전
  .https.onCall(async (data, context) => {
    // 인증 확인
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "사용자 인증이 필요합니다."
      );
    }

    const { purchaseToken, productId } = data;
    const userId = context.auth.uid;

    try {
      // Google Play Billing API 검증
      // (실제 구현은 Google Play Developer API 사용)

      // Firestore에 구독 정보 저장
      await admin.firestore().collection("subscriptions").doc(userId).set({
        userId,
        productId,
        purchaseToken,
        status: "active",
        platform: "google_play",
        verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
      }, { merge: true });

      return { success: true, verified: true };
    } catch (error) {
      console.error("Verification error:", error);
      throw new functions.https.HttpsError(
        "internal",
        "구독 검증 실패"
      );
    }
  });
```

#### 10.3 Functions 배포
```bash
# Functions 디렉토리로 이동
cd functions

# TypeScript 빌드
npm run build

# Functions 배포
firebase deploy --only functions

# 배포 확인
# ✔  functions[asia-northeast3-verifySubscription]: Successful create operation.
```

---

## 🔒 보안 체크리스트

### 중요 파일 보호
```bash
# .gitignore 확인
cat .gitignore

# 포함되어야 할 항목:
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
assets/config/prod_config.json
android/key.properties
android/keystore/*.jks
.env
```

### API 키 제한 (선택)
```
Google Cloud Console → API 및 서비스 → 사용자 인증 정보

각 API 키 클릭:
1. "애플리케이션 제한사항"
   → Android 앱
   → 패키지명: com.mission100.app
   → SHA-1 지문 추가

2. "API 제한사항"
   → 키 제한
   → 필요한 API만 선택:
     ✅ Cloud Firestore API
     ✅ Firebase Authentication API
     ✅ Firebase Installations API
```

---

## 📊 Firebase 사용량 모니터링

### 알림 설정
```
Firebase Console → 프로젝트 설정 → 사용량 및 결제

알림 이메일 설정:
✅ 일일 사용량 보고서
✅ 예산 알림
✅ 할당량 알림

대시보드 확인:
- Firestore: 읽기/쓰기/삭제 횟수
- Authentication: 활성 사용자 수
- Storage: 저장 용량 및 다운로드
- Functions: 호출 횟수 및 실행 시간
```

### 비용 추정 (구독자 10,000명 기준)
```
Firestore:
- 읽기: 50M 회/월 → $18
- 쓰기: 10M 회/월 → $27
- 저장: 50GB → $9
- 합계: $54

Authentication:
- 무료 (SMS 인증 제외)

Functions:
- 호출: 1M 회/월 → $8

Storage:
- 저장: 10GB → $3
- 다운로드: 50GB → $5

총 예상 비용: $70/월 (≈ ₩94,000)
```

---

## ✅ 완료 체크리스트

### Firebase 프로젝트
- [ ] 프로덕션 프로젝트 생성 완료
- [ ] Blaze 플랜 업그레이드
- [ ] 예산 알림 설정

### Android 앱 연동
- [ ] 앱 등록 (com.mission100.app)
- [ ] SHA-1 인증서 등록 (디버그 + 릴리즈)
- [ ] google-services.json 다운로드 및 적용

### Firebase 서비스
- [ ] Authentication 활성화 (이메일, Google)
- [ ] Firestore Database 생성 (asia-northeast3)
- [ ] 보안 규칙 배포 (339줄)
- [ ] 인덱스 배포

### 환경 설정
- [ ] prod_config.json 업데이트
- [ ] .gitignore 설정
- [ ] 개발/프로덕션 파일 분리

### 테스트
- [ ] 프로덕션 빌드 성공
- [ ] 실제 디바이스 테스트
- [ ] 회원가입/로그인 동작
- [ ] Firestore 읽기/쓰기 확인

---

## 🔧 트러블슈팅

### 문제 1: SHA-1 오류
```
증상: Google 로그인 시 "12500: DEVELOPER_ERROR"

해결:
1. SHA-1 지문 재확인
2. Firebase Console에 올바른 SHA-1 등록
3. 앱 재빌드 (flutter clean → flutter build)
4. 10-15분 대기 (Firebase 전파 시간)
```

### 문제 2: Firestore 권한 거부
```
증상: "Missing or insufficient permissions"

해결:
1. firestore.rules 배포 확인
2. 사용자 로그인 상태 확인 (request.auth)
3. Firebase Console → 규칙 탭에서 시뮬레이터 테스트
```

### 문제 3: google-services.json 오류
```
증상: "No matching client found for package name"

해결:
1. 패키지명 확인: com.mission100.app
2. google-services.json 재다운로드
3. android/app/ 디렉토리에 정확히 위치
4. 앱 재빌드
```

### 문제 4: Functions 배포 실패
```
증상: "Error: HTTP Error: 403"

해결:
1. Google Cloud Console → API 라이브러리
2. "Cloud Functions API" 활성화
3. "Cloud Build API" 활성화
4. 재배포: firebase deploy --only functions
```

---

## 📞 지원 및 문서

### Firebase 공식 문서
- 시작하기: https://firebase.google.com/docs/android/setup
- Firestore: https://firebase.google.com/docs/firestore
- Authentication: https://firebase.google.com/docs/auth
- Functions: https://firebase.google.com/docs/functions

### Google Play Billing
- 문서: https://developer.android.com/google/play/billing
- 테스트: https://developer.android.com/google/play/billing/test

### 커뮤니티 지원
- Stack Overflow: [firebase] [android] 태그
- Firebase 커뮤니티: https://firebase.community

---

## 🎉 다음 단계

Firebase 프로덕션 설정 완료 후:

1. ✅ **실제 디바이스 결제 테스트**
   - Google Play Console 테스트 계정 추가
   - 테스트 결제 진행
   - 구독 활성화 확인

2. ✅ **내부 테스트 트랙 배포**
   - AAB 빌드 생성
   - Play Console에 업로드
   - 내부 테스터 초대

3. ✅ **모니터링 및 최적화**
   - Firebase Analytics 대시보드 확인
   - Crashlytics 크래시 리포트
   - 성능 모니터링

---

**문서 버전**: 1.0.0
**최종 업데이트**: 2025-10-01
**작성자**: Mission100 개발팀
