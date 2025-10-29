# Screens Folder 분석 보고서

## 📊 현재 구조

### 폴더 구조
```
lib/screens/
├── archive_old/              # 보관된 오래된 파일들 (gitignore됨)
├── auth/                     # 인증 관련 screens (4개)
├── demo/                     # 데모/투자자용 screens (2개)
├── home/                     # 홈 화면 위젯들
│   └── widgets/             (7개 위젯)
├── legal/                   # 법적 문서 screens (1개)
├── onboarding/              # 온보딩 관련 (3개)
├── scientific_evidence/     # 과학적 근거 screens (1개)
├── settings/                # 설정 관련
│   └── widgets/            (4개 위젯)
├── tutorial/                # 튜토리얼 screens (1개)
├── workout/                 # 운동 관련
│   ├── handlers/           (1개 핸들러)
│   └── widgets/            (4개 위젯)
└── [루트 레벨 파일들]      (26개 파일)
```

## 🔴 중복 파일 발견

### 1. legal_document_screen.dart
- **위치**: 
  - `lib/screens/legal_document_screen.dart` (3.9K, 루트)
  - `lib/screens/legal/legal_document_screen.dart` (2.9K, 서브폴더)
- **클래스명**: 둘 다 `LegalDocumentScreen`
- **사용처**: 루트 파일이 `settings/widgets/about_settings_widget.dart`에서 사용됨
- **문제**: 같은 클래스명의 다른 구현체 2개
- **권장**: 서브폴더 파일 삭제하고 루트 파일을 legal/ 폴더로 이동

### 2. onboarding_screen.dart
- **위치**:
  - `lib/screens/onboarding_screen.dart` (33K, 루트)
  - `lib/screens/onboarding/onboarding_screen.dart` (6.6K, 서브폴더)
- **클래스명**: 둘 다 `OnboardingScreen`
- **사용처**:
  - 루트: `main.dart`, `simple_settings_screen.dart`
  - 서브폴더: `workout_screen.dart`
- **문제**: 둘 다 활발히 사용 중! 완전히 다른 구현
- **권장**: 클래스명 구분 필요 (예: `MainOnboardingScreen` vs `QuickOnboardingScreen`)

### 3. workout_screen 시리즈 (심각!)
- **위치**:
  - `workout_screen.dart` (893줄)
  - `workout_screen_backup.dart` (665줄)
  - `workout_screen_simple.dart` (403줄)
- **클래스명**: 셋 다 `WorkoutScreen` ⚠️
- **사용처**: 
  - `workout_screen.dart`: `home_screen.dart`에서 사용
  - backup/simple: 사용처 불명확
- **문제**: 같은 클래스명의 3개 구현체!
- **권장**: 
  - backup → archive_old로 이동
  - simple → 클래스명 변경 또는 삭제
  - 메인 파일만 유지

## 📁 루트 레벨 파일 정리 필요

현재 루트에 26개 파일이 있음. 서브폴더로 이동 권장:

### 추천 이동:
```
achievements/ 폴더로:
  - achievements_screen.dart

calendar/ 폴더로:
  - calendar_screen.dart

statistics/ 폴더로:
  - statistics_screen.dart

backup/ 또는 data/ 폴더로:
  - backup_screen.dart

recovery/ 폴더로:
  - chad_active_recovery_screen.dart

challenge/ 폴더로:
  - challenge_screen.dart

evolution/ 폴더로:
  - evolution_celebration_screen.dart

subscription/ 폴더로:
  - subscription_screen.dart
  - signup_for_purchase_screen.dart

pushup/ 또는 exercise/ 폴더로:
  - pushup_form_guide_screen.dart
  - pushup_tutorial_screen.dart
  - pushup_tutorial_detail_screen.dart

progress/ 폴더로:
  - progress_tracking_screen.dart
  - statistics_screen.dart

settings/ 폴더로 (이미 settings 폴더 있음):
  - simple_settings_screen.dart
  - workout_reminder_settings_screen.dart

test/ 또는 onboarding/ 폴더로:
  - initial_test_screen.dart

misc/ 폴더로:
  - youtube_shorts_screen.dart
  - permission_screen.dart
```

## ✅ 잘 구조화된 부분

1. **auth/** - 로그인/회원가입 screens 잘 정리됨
2. **home/widgets/** - 홈 화면 위젯들 잘 분리됨
3. **workout/widgets/** - 운동 관련 위젯들 잘 분리됨
4. **settings/widgets/** - 설정 위젯들 잘 분리됨
5. **demo/** - 데모 screens 분리됨
6. **tutorial/** - 튜토리얼 분리됨

## 🎯 권장 개선 사항

### 1단계: 중복 제거 (우선순위: 높음)
- [ ] workout_screen_backup.dart → archive_old로 이동
- [ ] workout_screen_simple.dart 사용처 확인 후 제거 또는 클래스명 변경
- [ ] legal/legal_document_screen.dart 제거, 루트 파일을 legal/로 이동
- [ ] onboarding 파일들 클래스명 구분

### 2단계: 폴더 구조 개선 (우선순위: 중간)
- [ ] achievements, calendar, statistics, challenge 등 새 폴더 생성
- [ ] 루트 레벨 파일들을 적절한 서브폴더로 이동
- [ ] 관련 widgets도 함께 이동

### 3단계: 네이밍 정리 (우선순위: 낮음)
- [ ] 일관된 네이밍 컨벤션 적용
- [ ] Screen 접미사 통일
- [ ] 폴더명과 파일명 일관성 확보

## 📈 통계

- 총 파일 수: 54개 (archive_old 제외)
- 서브폴더: 13개
- 루트 레벨 파일: 26개
- 중복 가능 파일: 5개
- 위젯 파일: 15개

## 🚨 즉시 해결 필요

**workout_screen 3중 중복** - 같은 클래스명으로 인한 잠재적 충돌 위험!
