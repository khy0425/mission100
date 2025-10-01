# Firebase 인증 시스템 구현 계획

## 📋 개요
Mission100 앱에 Firebase Authentication을 통한 회원가입/로그인 시스템을 구현하여 향후 프리미엄 기능을 위한 기반을 마련합니다.

## 🎯 목표
- 사용자 계정 관리 시스템 구축
- 로컬 데이터와 클라우드 데이터 동기화 준비
- 프리미엄 구독 관리 기반 마련
- 크로스 플랫폼 데이터 동기화 지원

## 🏗️ 구현 단계

### 1단계: Firebase 프로젝트 설정
```bash
# Firebase CLI 설치 및 프로젝트 초기화
npm install -g firebase-tools
firebase login
firebase init
```

#### 필요한 Firebase 서비스
- **Authentication**: 회원가입/로그인
- **Firestore**: 사용자 데이터 저장
- **Storage**: 프로필 이미지 등 파일 저장 (선택)
- **Analytics**: 사용자 행동 분석 (선택)

### 2단계: Flutter Firebase 패키지 추가
```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_auth: ^4.15.0
  cloud_firestore: ^4.13.0
  google_sign_in: ^6.1.5
  sign_in_with_apple: ^5.0.0
```

### 3단계: 플랫폼별 설정
#### Android 설정
- `android/app/google-services.json` 추가
- `android/app/build.gradle` 수정
- SHA-1 인증서 fingerprint 등록

#### iOS 설정
- `ios/Runner/GoogleService-Info.plist` 추가
- `ios/Runner/Info.plist` URL scheme 설정
- Apple Sign In 설정

### 4단계: 인증 서비스 구현

#### 4.1 Firebase Service 클래스
```dart
// lib/services/firebase_auth_service.dart
class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 이메일/비밀번호 회원가입
  Future<UserCredential?> signUpWithEmail(String email, String password);

  // 이메일/비밀번호 로그인
  Future<UserCredential?> signInWithEmail(String email, String password);

  // Google 로그인
  Future<UserCredential?> signInWithGoogle();

  // Apple 로그인 (iOS만)
  Future<UserCredential?> signInWithApple();

  // 로그아웃
  Future<void> signOut();

  // 사용자 정보 업데이트
  Future<void> updateUserProfile(Map<String, dynamic> userData);

  // 사용자 데이터 동기화
  Future<void> syncUserData();
}
```

#### 4.2 사용자 모델 확장
```dart
// lib/models/user_profile.dart 확장
class UserProfile {
  final String? uid; // Firebase UID 추가
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool isPremium; // 프리미엄 사용자 여부
  final DateTime? premiumExpiryDate;
  final DateTime createdAt;
  final DateTime lastSyncAt;

  // 기존 필드들...
  final String name;
  final int age;
  final String gender;
  // ...
}
```

### 5단계: UI 구현

#### 5.1 인증 화면들
```
lib/screens/auth/
├── auth_gate_screen.dart          # 인증 상태 체크
├── login_screen.dart              # 로그인 화면
├── signup_screen.dart             # 회원가입 화면
├── forgot_password_screen.dart    # 비밀번호 찾기
└── profile_setup_screen.dart      # 프로필 설정
```

#### 5.2 주요 화면 컴포넌트
- **로그인 화면**: 이메일/비밀번호, Google, Apple 로그인
- **회원가입 화면**: 이메일 인증, 프로필 설정
- **설정 화면**: 계정 관리, 로그아웃 추가

### 6단계: 데이터 동기화 시스템

#### 6.1 로컬-클라우드 데이터 동기화
```dart
// lib/services/data_sync_service.dart
class DataSyncService {
  // 운동 기록 동기화
  Future<void> syncWorkoutHistory();

  // 업적 동기화
  Future<void> syncAchievements();

  // Chad 진화 상태 동기화
  Future<void> syncChadEvolution();

  // 설정 동기화
  Future<void> syncSettings();

  // 전체 데이터 백업
  Future<void> backupAllData();

  // 데이터 복원
  Future<void> restoreAllData();
}
```

#### 6.2 Firestore 데이터 구조
```
users/{uid}/
├── profile                 # 사용자 프로필
├── workoutHistory/        # 운동 기록
├── achievements/          # 업적 상태
├── chadEvolution/         # Chad 진화 상태
├── settings/              # 앱 설정
└── subscription/          # 구독 정보
```

### 7단계: 프리미엄 기능 준비

#### 7.1 구독 상태 관리
```dart
// lib/services/subscription_service.dart
class SubscriptionService {
  // 구독 상태 확인
  Future<bool> isPremiumUser();

  // 구독 만료일 확인
  Future<DateTime?> getPremiumExpiryDate();

  // 프리미엄 기능 접근 권한 체크
  bool canAccessPremiumFeature(String featureId);
}
```

#### 7.2 프리미엄 기능 목록 (계획)
- **고급 통계**: 상세한 운동 분석
- **개인화된 운동 프로그램**: AI 기반 맞춤 프로그램
- **클라우드 백업**: 무제한 데이터 백업
- **광고 제거**: 전체 광고 제거
- **프리미엄 Chad 스킨**: 특별한 Chad 이미지

### 8단계: 보안 및 개인정보보호

#### 8.1 보안 규칙 (Firestore Security Rules)
```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 사용자는 자신의 데이터만 접근 가능
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

#### 8.2 개인정보보호
- 최소한의 필수 정보만 수집
- 데이터 암호화
- GDPR 준수 (데이터 삭제 요청 지원)

### 9단계: 마이그레이션 전략

#### 9.1 기존 사용자 데이터 보존
```dart
// lib/services/migration_service.dart
class MigrationService {
  // 로컬 데이터를 Firebase로 마이그레이션
  Future<void> migrateLocalDataToFirebase();

  // 익명 사용자를 계정 사용자로 전환
  Future<void> convertAnonymousToAccount();

  // 데이터 무결성 검증
  Future<bool> validateMigratedData();
}
```

#### 9.2 점진적 도입
1. **Phase 1**: 선택적 회원가입 (기존 기능 유지)
2. **Phase 2**: 회원가입 인센티브 제공 (클라우드 백업 등)
3. **Phase 3**: 프리미엄 기능 출시
4. **Phase 4**: 일부 기능 회원 전용으로 전환

### 10단계: 테스트 및 배포

#### 10.1 테스트 계획
- 단위 테스트: 인증 서비스 기능
- 통합 테스트: Firebase 연동
- UI 테스트: 로그인/회원가입 플로우
- 성능 테스트: 데이터 동기화

#### 10.2 점진적 배포
1. **베타 테스트**: 제한된 사용자 그룹
2. **소프트 론칭**: 일부 지역 먼저 출시
3. **전체 배포**: 모든 사용자에게 제공

## 🔧 구현 순서 (우선순위)

### 높은 우선순위
1. Firebase 프로젝트 설정 및 기본 인증 구현
2. 로그인/회원가입 UI 구현
3. 사용자 프로필 관리
4. 기본 데이터 동기화

### 중간 우선순위
5. Google/Apple 소셜 로그인
6. 데이터 마이그레이션 도구
7. 오프라인 지원
8. 보안 규칙 설정

### 낮은 우선순위 (추후 구현)
9. 고급 동기화 기능
10. 프리미엄 구독 시스템
11. 고급 분석 및 통계
12. 다국어 지원 확장

## 📱 사용자 경험 (UX) 고려사항

### 비회원 사용자
- 앱의 핵심 기능은 여전히 사용 가능
- 회원가입 없이도 완전한 운동 경험 제공
- 선택적 회원가입 (강제 X)

### 회원 사용자
- 클라우드 백업 및 동기화
- 디바이스 간 데이터 동기화
- 프리미엄 기능 접근 권한

### 마이그레이션 UX
- 기존 데이터 보존 보장
- 원클릭 마이그레이션 지원
- 진행 상황 표시

## ⚡ 예상 개발 기간

- **1-2주**: Firebase 설정 및 기본 인증
- **2-3주**: UI 구현 및 사용자 관리
- **1-2주**: 데이터 동기화 시스템
- **1주**: 테스트 및 버그 수정
- **총 5-8주** (약 1.5-2개월)

## 💡 추가 고려사항

### 비용 관리
- Firebase 무료 티어 한도 모니터링
- 사용량 기반 비용 최적화
- 필요시 Firebase Blaze 플랜 전환

### 성능 최적화
- 오프라인 우선 설계
- 배치 동기화 구현
- 필요한 데이터만 동기화

### 사용자 피드백
- 베타 테스터 그룹 운영
- 사용자 피드백 수집 및 반영
- A/B 테스트를 통한 UX 개선

---

이 계획에 대해 어떻게 생각하시나요? 특정 부분에 대해 더 자세한 설명이 필요하거나 수정하고 싶은 부분이 있으시면 말씀해주세요!