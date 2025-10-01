# Firebase 설정 가이드

## 🚀 Phase 1.3: Firestore 초기 설정

### 1. Firebase 프로젝트 생성

1. **Firebase Console 접속**
   - https://console.firebase.google.com/ 접속
   - Google 계정으로 로그인

2. **새 프로젝트 생성**
   ```bash
   프로젝트 이름: mission100-prod
   프로젝트 ID: mission100-prod-[랜덤ID]
   위치: asia-northeast3 (Seoul)
   ```

3. **Google Analytics 설정**
   - Google Analytics 활성화 (권장)
   - 기존 GA4 속성 연결 또는 새로 생성

### 2. Firestore 데이터베이스 설정

1. **Firestore 데이터베이스 생성**
   ```bash
   콘솔 > Firestore Database > 데이터베이스 만들기

   보안 규칙: 프로덕션 모드에서 시작
   위치: asia-northeast3 (Seoul)
   ```

2. **보안 규칙 배포**
   ```bash
   # Firebase CLI 설치 (Node.js 필요)
   npm install -g firebase-tools

   # Firebase 로그인
   firebase login

   # 프로젝트 초기화
   firebase init firestore

   # 보안 규칙 배포
   firebase deploy --only firestore:rules
   ```

3. **인덱스 배포**
   ```bash
   # 인덱스 설정 배포
   firebase deploy --only firestore:indexes
   ```

### 3. Firebase Authentication 설정

1. **Authentication 활성화**
   ```bash
   콘솔 > Authentication > 시작하기
   ```

2. **로그인 방법 설정**
   - **이메일/비밀번호**: 활성화
   - **Google**: 활성화
     - 프로젝트 지원 이메일 설정
     - 승인된 도메인 추가 (개발/운영)

3. **승인된 도메인 추가**
   ```bash
   # 개발 환경
   localhost

   # 운영 환경 (실제 도메인으로 교체)
   mission100.app
   ```

### 4. Firebase Storage 설정 (선택사항)

1. **Storage 활성화**
   ```bash
   콘솔 > Storage > 시작하기
   위치: asia-northeast3 (Seoul)
   ```

2. **보안 규칙 설정**
   ```javascript
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       // 사용자별 파일 업로드 (프로필 사진 등)
       match /users/{userId}/{allPaths=**} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }

       // 운동 기록 백업 파일
       match /backups/{userId}/{allPaths=**} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }

       // 공개 리소스 (Chad 이미지 등)
       match /public/{allPaths=**} {
         allow read: if true;
         allow write: if false; // 관리자만 업로드
       }
     }
   }
   ```

### 5. Firebase Functions 설정 (결제 검증용)

1. **Functions 활성화**
   ```bash
   firebase init functions

   # TypeScript 선택 권장
   # ESLint 활성화 권장
   ```

2. **결제 검증 함수 기본 구조**
   ```typescript
   // functions/src/index.ts
   import {onCall, HttpsError} from 'firebase-functions/v2/https';
   import {initializeApp} from 'firebase-admin/app';
   import {getFirestore} from 'firebase-admin/firestore';

   initializeApp();

   // Google Play 결제 검증
   export const verifyGooglePlayPurchase = onCall(async (request) => {
     // 구현 예정
   });

   // 구독 상태 확인
   export const checkSubscriptionStatus = onCall(async (request) => {
     // 구현 예정
   });
   ```

### 6. 환경 변수 설정

1. **Flutter 앱용 Firebase 설정**
   ```bash
   # Firebase CLI로 Flutter 앱 등록
   firebase apps:create android com.mission100.app
   firebase apps:create ios com.mission100.app

   # 설정 파일 다운로드
   # Android: google-services.json
   # iOS: GoogleService-Info.plist
   ```

2. **Firebase 설정 파일 위치**
   ```
   android/app/google-services.json
   ios/Runner/GoogleService-Info.plist
   ```

### 7. 개발/운영 환경 분리

1. **개발 환경**
   ```bash
   프로젝트: mission100-dev
   Firestore: (default) 데이터베이스
   ```

2. **운영 환경**
   ```bash
   프로젝트: mission100-prod
   Firestore: (default) 데이터베이스
   ```

3. **Flutter 환경별 설정**
   ```dart
   // lib/config/firebase_config.dart
   class FirebaseConfig {
     static const String devProjectId = 'mission100-dev';
     static const String prodProjectId = 'mission100-prod';

     static String get projectId {
       return kDebugMode ? devProjectId : prodProjectId;
     }
   }
   ```

### 8. 보안 설정

1. **API 키 제한**
   ```bash
   Google Cloud Console > APIs & Services > Credentials

   Android 앱용 API 키:
   - Android 앱으로 제한
   - 패키지 이름: com.mission100.app
   - SHA-1 지문 추가

   iOS 앱용 API 키:
   - iOS 앱으로 제한
   - 번들 ID: com.mission100.app
   ```

2. **Firestore 보안 강화**
   ```javascript
   // 추가 보안 규칙 예시
   function isValidRequest() {
     return request.resource.size < 1048576 && // 1MB 제한
            request.time > timestamp.date(2024, 1, 1); // 과거 날짜 방지
   }
   ```

### 9. 모니터링 설정

1. **Crashlytics 활성화**
   ```bash
   콘솔 > Crashlytics > 시작하기
   ```

2. **Performance Monitoring 활성화**
   ```bash
   콘솔 > Performance > 시작하기
   ```

3. **Analytics 이벤트 설정**
   ```dart
   // 주요 추적 이벤트
   - workout_started
   - workout_completed
   - subscription_purchased
   - achievement_unlocked
   ```

### 10. 백업 및 복구 설정

1. **자동 백업 설정**
   ```bash
   gcloud firestore operations list
   gcloud firestore export gs://[BUCKET_NAME]
   ```

2. **일일 백업 스케줄링** (Cloud Functions)
   ```typescript
   export const dailyBackup = onSchedule('0 2 * * *', async (event) => {
     // Firestore 백업 로직
   });
   ```

---

## 📝 체크리스트

### Firebase 프로젝트 설정
- [ ] Firebase 프로젝트 생성 (mission100-prod)
- [ ] 프로젝트 위치 설정 (asia-northeast3)
- [ ] Google Analytics 연결

### Firestore 설정
- [ ] Firestore 데이터베이스 생성
- [ ] 보안 규칙 배포 (`firestore.rules`)
- [ ] 인덱스 설정 배포 (`firestore.indexes.json`)
- [ ] 컬렉션 구조 확인

### Authentication 설정
- [ ] Authentication 활성화
- [ ] 이메일/비밀번호 로그인 활성화
- [ ] Google 로그인 설정
- [ ] 승인된 도메인 추가

### 앱 연동 설정
- [ ] Android 앱 등록 및 설정 파일 다운로드
- [ ] iOS 앱 등록 및 설정 파일 다운로드
- [ ] Flutter Firebase 플러그인 설정 확인

### 보안 설정
- [ ] API 키 제한 설정
- [ ] Firestore 보안 규칙 테스트
- [ ] 데이터 접근 권한 확인

### 모니터링 설정
- [ ] Crashlytics 활성화
- [ ] Performance Monitoring 활성화
- [ ] Analytics 이벤트 설정

### 백업 설정
- [ ] Storage 버킷 생성
- [ ] 백업 정책 설정
- [ ] 복구 프로세스 테스트

---

## 🔧 다음 단계

이 설정이 완료되면 **Phase 2: 클라우드 동기화 시스템 구현**으로 진행합니다:

1. CloudSyncService 생성
2. 사용자 프로필 동기화
3. 운동 기록 동기화
4. 오프라인 모드 처리

**예상 소요 시간**: 2-3시간