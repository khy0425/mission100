# 🛠️ Mission100 개발 가이드

## 📋 목차
- [기술 스택](#기술-스택)
- [Firebase 설정](#firebase-설정)
- [Firestore 스키마](#firestore-스키마)
- [로컬 개발](#로컬-개발)

---

## 🔧 기술 스택

### Frontend
- **Flutter** 3.35.4
- **Dart** 3.6.0
- **State Management**: Provider
- **i18n**: flutter_localizations

### Backend
- **Firebase Authentication** (Google, Apple 로그인)
- **Cloud Firestore** (사용자 데이터, 운동 기록)
- **Firebase Storage** (이미지, 백업 파일)
- **Cloud Functions** (결제 검증, 알림)

### 결제
- **In-App Purchase** (iOS/Android)
- **RevenueCat** 또는 직접 구현

---

## 🔥 Firebase 설정

### 1. 프로젝트 생성
1. [Firebase Console](https://console.firebase.google.com) 접속
2. 새 프로젝트 생성: `mission100-app`
3. Google Analytics 활성화 (선택)

### 2. Android 앱 추가
```
패키지명: com.reaf.mission100
SHA-1: (로컬 keystore 지문)
```

**google-services.json 다운로드**:
```bash
# 저장 위치
android/app/google-services.json

# ⚠️ .gitignore에 포함되어야 함
```

### 3. iOS 앱 추가 (향후)
```
Bundle ID: com.reaf.mission100
```

### 4. Firebase SDK 설정

**pubspec.yaml** (이미 구성됨):
```yaml
dependencies:
  firebase_core: ^3.8.1
  firebase_auth: ^5.3.3
  cloud_firestore: ^5.5.0
  firebase_storage: ^12.3.6
```

**초기화 코드** (`lib/main.dart`):
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

---

## 📊 Firestore 스키마

### users
```
users/{userId}
├── email: string
├── displayName: string
├── photoURL: string
├── subscriptionTier: string (free|premium|unlimited)
├── subscriptionExpiry: timestamp
├── level: string (beginner|intermediate|advanced|chad)
├── currentWeek: number
├── totalWorkouts: number
├── createdAt: timestamp
└── updatedAt: timestamp
```

### workouts
```
workouts/{workoutId}
├── userId: string (ref)
├── date: timestamp
├── exerciseType: string (burpee|pushup)
├── sets: array[
│   ├── type: string
│   ├── reps: number
│   └── rpe: number (1-10)
│   ]
├── totalReps: number
├── duration: number (seconds)
├── completed: boolean
└── createdAt: timestamp
```

### achievements
```
achievements/{achievementId}
├── userId: string (ref)
├── type: string (streak|total|milestone)
├── level: number
├── unlockedAt: timestamp
└── metadata: map
```

### backups
```
backups/{backupId}
├── userId: string (ref)
├── data: map (전체 사용자 데이터)
├── version: string
├── createdAt: timestamp
└── encrypted: boolean
```

### Firestore 규칙

**firestore.rules**:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 사용자 데이터
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // 운동 기록
    match /workouts/{workoutId} {
      allow read, write: if request.auth != null &&
                           resource.data.userId == request.auth.uid;
    }

    // 업적
    match /achievements/{achievementId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null &&
                     resource.data.userId == request.auth.uid;
    }

    // 백업
    match /backups/{backupId} {
      allow read, write: if request.auth != null &&
                           resource.data.userId == request.auth.uid;
    }
  }
}
```

---

## 💻 로컬 개발

### 환경 설정

**필수 도구**:
- Flutter SDK 3.35.4
- Android Studio / Xcode
- Firebase CLI

**설치**:
```bash
# Firebase CLI
npm install -g firebase-tools

# 로그인
firebase login

# 프로젝트 연결
firebase use mission100-app
```

### 개발 서버 실행

```bash
# 의존성 설치
flutter pub get

# i18n 생성
flutter gen-l10n

# 개발 모드 실행
flutter run

# Hot Reload: r 키
# Hot Restart: R 키
```

### 환경별 설정

**개발 환경** (`assets/config/dev_config.json`):
```json
{
  "apiBaseUrl": "https://dev-api.mission100.app",
  "enableDebugLog": true,
  "useEmulator": true
}
```

**프로덕션 환경** (`assets/config/prod_config.json`):
```json
{
  "apiBaseUrl": "https://api.mission100.app",
  "enableDebugLog": false,
  "useEmulator": false
}
```

### 디버깅

**Firebase Emulator Suite** (선택):
```bash
# 설치
firebase init emulators

# 실행
firebase emulators:start

# Flutter에서 연결
await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
await FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
```

---

## 🧪 테스트

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests (향후)
```bash
flutter drive --target=test_driver/app.dart
```

---

## 🔐 보안 체크리스트

### API 키 관리
- [x] google-services.json은 .gitignore에 포함
- [x] 환경 변수로 민감 정보 관리
- [x] GitHub Secrets로 CI/CD 설정

### Firestore 보안
- [ ] 모든 컬렉션에 보안 규칙 설정
- [ ] userId 기반 접근 제어
- [ ] 읽기/쓰기 권한 분리

### 인증
- [x] Firebase Auth 사용
- [ ] 토큰 만료 시간 설정
- [ ] 재인증 플로우 구현

---

## 📦 의존성 관리

### 주요 패키지
```yaml
# Core
firebase_core: ^3.8.1
firebase_auth: ^5.3.3
cloud_firestore: ^5.5.0

# 상태 관리
provider: ^6.1.2

# 로컬 저장소
shared_preferences: ^2.3.3
sqflite: ^2.4.1

# UI
flutter_svg: ^2.0.10+1
cached_network_image: ^3.4.1
```

### 업데이트
```bash
# 최신 버전 확인
flutter pub outdated

# 업데이트
flutter pub upgrade

# 특정 패키지만
flutter pub upgrade firebase_core
```

---

## 🐛 문제 해결

### Firebase 연결 실패
```bash
# google-services.json 확인
ls android/app/google-services.json

# Firebase 초기화 로그 확인
flutter run --verbose
```

### 빌드 오류
```bash
# Clean 후 재빌드
flutter clean
flutter pub get
flutter run
```

### Firestore 권한 오류
- Firestore 규칙 확인
- userId 일치 여부 확인
- 인증 상태 확인

---

**마지막 업데이트**: 2025-10-02
