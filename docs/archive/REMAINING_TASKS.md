# Mission: 100 Push-Ups - 남은 작업 목록

> 마지막 업데이트: 2025-10-08

## 📊 현재 상태

### ✅ 완료된 작업
- [x] 14주 완만한 프로그레션 프로그램 (평균 +17.5% 증가)
- [x] 푸시업 단일 운동 리스킨
- [x] Firebase 백엔드 연동 (Auth, Firestore, Analytics)
- [x] Chad AI 코칭 시스템
- [x] 구독/결제 시스템 (In-App Purchase)
- [x] 업적 시스템
- [x] 통계 및 진행률 추적
- [x] 법적 문서 (Privacy Policy, Terms of Service)

### 🔧 코드 품질
- Flutter Analyze: 0 errors, 19 warnings (unused variables/methods)
- 모든 경고는 non-blocking (기능에 영향 없음)

---

## 🎨 1. 에셋 작업 (우선순위: 높음)

### 1.1 운동 프로그램 이미지 (Week 7-14)

**필요 이미지: 8개**

| 주차 | Day 1 | Day 2 | Day 3 | 파일명 |
|------|-------|-------|-------|--------|
| Week 7 | 31개 | 36개 | 41개 | 7주차_수정-7.jpg |
| Week 8 | 37개 | 43개 | 48개 | 8주차_수정-8.jpg |
| Week 9 | 44개 | 50개 | 57개 | 9주차_수정-9.jpg |
| Week 10 | 52개 | 59개 | 67개 | 10주차_수정-10.jpg |
| Week 11 | 61개 | 70개 | 79개 | 11주차_수정-11.jpg |
| Week 12 | 72개 | 82개 | 93개 | 12주차_수정-12.jpg |
| Week 13 | 84개 | 97개 | 110개 | 13주차_수정-13.jpg |
| Week 14 | **100개** 🎯 | 114개 | 130개 | 14주차_수정-14.jpg |

**작업 방법:**
- 기존 1~6주차 디자인 참고
- Figma/Canva로 제작
- 해상도: 1600x2150px
- 예상 시간: 2-3시간

**위치:** `docs/운동/`

### 1.2 Chad 캐릭터 이미지

**필수 (최소 2개):**
1. **기본차드.jpg** - 기본 상태
2. **운동차드.jpg** - 푸시업 운동 중 ⭐

**추가 (권장):**
3. 수면차드.jpg - 피곤한 상태
4. 파워차드.jpg - 강한 컨디션
5. 비스트차드.jpg - 최강 컨디션
6. 축하차드.jpg - 목표 달성

**진화 Chad (4개):**
7. 진화1차드.jpg - Rookie Chad
8. 진화2차드.jpg - Rising Chad
9. 진화3차드.jpg - Alpha Chad
10. 진화최종차드.jpg - Giga Chad

**작업 방법:**
- MidJourney + Character Reference (--cref --cw 100)
- 해상도: 1024x1024px
- 예상 비용: $10/월 (Basic Plan)
- 예상 시간: 3-4시간

**위치:** `assets/images/chad/`

### 1.3 푸시업 자세 가이드 (선택사항)

**7가지 자세:**
1. standard_pushup.jpg - 표준 푸시업
2. knee_pushup.jpg - 무릎 푸시업 (초보자)
3. wide_pushup.jpg - 와이드 푸시업
4. close_pushup.jpg - 좁은 푸시업
5. diamond_pushup.jpg - 다이아몬드 푸시업
6. decline_pushup.jpg - 디클라인 푸시업
7. incline_pushup.jpg - 인클라인 푸시업

**작업 방법:**
- 실사 사진 또는 3D 일러스트
- 해상도: 800x600px
- 예상 시간: 2-3시간

**위치:** `assets/images/pushup_forms/`

---

## 🐛 2. 코드 정리 (우선순위: 중간)

### 2.1 Unused Variables/Methods 제거

**19개 경고 수정:**
```dart
// lib/core/cache/cache_manager.dart:101
- final int _maxDiskCacheSize = 50 * 1024 * 1024; // 제거 또는 사용

// lib/core/network/network_error_handler.dart:115
- catch (error, stackTrace) -> catch (error) // stackTrace 제거

// lib/core/security/data_encryption_service.dart
- final String _saltKey // 사용 또는 제거
- oldEncryptionResult, dataType 변수 제거

// lib/screens/ 여러 파일
- unused methods (_onRPESelected, _titleFontSize 등) 제거
```

**예상 시간:** 30분-1시간

### 2.2 pubspec.yaml 정리

**현재 문제:**
- ~~중복 flutter_markdown 키~~ (해결됨)
- dependency_overrides 정리 필요

**작업:**
```yaml
# 불필요한 overrides 제거 확인
dependency_overrides:
  webview_flutter: 4.8.0
  webview_flutter_android: 3.16.7
  webview_flutter_wkwebview: 3.15.0
```

**예상 시간:** 15분

### 2.3 테스트 커버리지 향상 (선택사항)

**현재 상태:**
- 테스트 파일 존재: `test/services/` 디렉토리
- 커버리지: 알 수 없음

**작업:**
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

**예상 시간:** 2-3시간

---

## 🔥 3. Firebase 최종 설정 (우선순위: 높음)

### 3.1 google-services.json 확인

**현재:**
- ✅ 파일 존재: `android/app/google-services.json`

**작업:**
- Firebase Console에서 최신 버전 확인
- SHA-1/SHA-256 fingerprint 등록 확인

### 3.2 Firestore 인덱스 생성

**필요한 인덱스:**
```javascript
// 사용자 진행 상황 쿼리
workoutProgress: (userId, week, day) -> composite index

// 업적 쿼리
achievements: (userId, unlockedAt DESC) -> composite index
```

**작업:**
```bash
# 앱 실행 중 인덱스 오류 발생 시
# Firebase Console 링크 클릭하여 자동 생성

# 또는 수동 배포
firebase deploy --only firestore:indexes
```

### 3.3 Authentication 메서드 활성화

**Firebase Console > Authentication:**
- [x] Email/Password (활성화 확인)
- [ ] Google Sign-In (권장)
- [ ] Apple Sign-In (iOS 필수, 선택사항)

---

## 📱 4. 앱 스토어 준비 (우선순위: 중간)

### 4.1 앱 아이콘

**현재 상태:**
- `flutter_launcher_icons` 설정 완료

**작업:**
```bash
# 아이콘 이미지 준비 (1024x1024px)
# pubspec.yaml 확인:
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"

# 아이콘 생성
flutter pub run flutter_launcher_icons:main
```

**필요 작업:**
- 푸시업 테마 아이콘 디자인
- 예상 시간: 1-2시간

### 4.2 스플래시 스크린

**Android:**
- `android/app/src/main/res/drawable/launch_background.xml`
- 푸시업 브랜딩 추가

**iOS:**
- LaunchScreen.storyboard 수정

**예상 시간:** 1시간

### 4.3 스토어 스크린샷

**필요 이미지:**
- 5-8개 스크린샷 (1080x1920px 또는 1242x2688px)
- 주요 기능 강조:
  1. 홈 화면 (Chad + 진행률)
  2. 운동 화면 (실시간 코칭)
  3. 통계 화면 (그래프)
  4. Chad 진화 화면
  5. 업적 화면

**작업 방법:**
- 실제 앱 실행 후 캡처
- Figma로 텍스트 오버레이 추가
- 예상 시간: 2-3시간

### 4.4 앱 설명 (ASO)

**참고:** `docs/ASO_KEYWORDS.md`

**작업:**
- Google Play 설명 작성 (4000자 제한)
- 짧은 설명 작성 (80자)
- 키워드 최적화

**예상 시간:** 1-2시간

---

## 🚀 5. 배포 준비 (우선순위: 높음)

### 5.1 Release Build 테스트

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Google Play 권장)
flutter build appbundle --release

# 설치 테스트
adb install build/app/outputs/flutter-apk/app-release.apk
```

**체크리스트:**
- [ ] 앱 정상 실행 확인
- [ ] Firebase 연결 확인
- [ ] 구독/결제 테스트 (테스트 카드)
- [ ] 푸시 알림 테스트
- [ ] 오프라인 모드 테스트

### 5.2 ProGuard 설정 확인

**파일:** `android/app/proguard-rules.pro`

**작업:**
- Firebase 규칙 확인
- 난독화 예외 처리
- 크래시 테스트

### 5.3 버전 관리

**pubspec.yaml:**
```yaml
version: 2.1.0+9

# 출시 시:
version: 3.0.0+10  # 14주 프로그램 메이저 업데이트
```

---

## 🧪 6. 테스트 (우선순위: 중간)

### 6.1 기능 테스트

**필수 시나리오:**
- [ ] 회원가입/로그인 (Email, Google)
- [ ] 초기 테스트 (5개 이하 → Rookie 배정)
- [ ] 운동 기록 (Day 1, Week 1)
- [ ] Chad 레벨업 확인
- [ ] 업적 해금
- [ ] 구독 구매 (테스트)
- [ ] 데이터 동기화 (여러 기기)

### 6.2 성능 테스트

```bash
# 프로파일 모드 실행
flutter run --profile

# 메모리 사용량 확인
# DevTools에서 모니터링
```

**목표:**
- 앱 시작 시간: < 3초
- 메모리 사용: < 150MB
- 프레임 드롭: < 5%

### 6.3 오류 추적

**Firebase Crashlytics:**
- [ ] 설정 확인
- [ ] 테스트 크래시 발생시켜 확인
- [ ] 대시보드 확인

---

## 📄 7. 문서 업데이트 (우선순위: 낮음)

### 7.1 README.md

**추가 내용:**
- 14주 프로그램 설명
- 완만한 증가율 강조
- 설치 방법
- 스크린샷

### 7.2 CHANGELOG.md

**v3.0.0 항목 추가:**
```markdown
## [3.0.0] - 2025-10-XX

### Added
- 14주 완만한 프로그레션 프로그램 (6주 → 14주)
- 푸시업 단일 운동 집중
- Week 7-14 운동 데이터

### Changed
- 주간 증가율: +175% → +17.5% (완만한 증가)
- 앱 이름: Mission: 100 Push-Ups
- 브랜딩: 100일 푸시업 챌린지

### Fixed
- pubspec.yaml 중복 키 제거
```

---

## ⏱️ 작업 예상 시간

### Phase 1: MVP 출시 필수 (총 6-8시간)
1. Week 7-14 이미지 생성: 2-3시간 ⭐
2. 기본 Chad 2개: 2-3시간 ⭐
3. Firebase 최종 확인: 30분
4. Release Build 테스트: 1시간
5. 기능 테스트: 1-2시간

### Phase 2: 완성도 향상 (총 8-10시간)
6. 전체 Chad 캐릭터 (15개): 4-5시간
7. 스토어 스크린샷: 2-3시간
8. 앱 아이콘/스플래시: 2시간
9. ASO 최적화: 1-2시간

### Phase 3: 품질 개선 (총 4-6시간)
10. 코드 경고 제거: 1시간
11. 테스트 커버리지: 2-3시간
12. 푸시업 자세 가이드: 2-3시간

**총 예상 시간: 18-24시간** (3-4일 집중 작업)

---

## 🎯 권장 작업 순서

### Week 1 (MVP 출시)
1. **Day 1-2**: Week 7-14 운동 이미지 생성
2. **Day 3**: 기본 Chad 캐릭터 2개 생성
3. **Day 4**: Firebase 확인 + Release Build
4. **Day 5**: 전체 기능 테스트 + 스토어 제출

### Week 2 (완성도 향상)
5. **Day 6-7**: 전체 Chad 캐릭터 생성
6. **Day 8**: 스토어 스크린샷 제작
7. **Day 9**: ASO 최적화
8. **Day 10**: 코드 정리

---

## 📋 체크리스트

### 출시 전 필수
- [ ] Week 7-14 이미지 생성 (8개)
- [ ] 기본 Chad 캐릭터 (2개)
- [ ] Firebase google-services.json 최신화
- [ ] Release APK/Bundle 빌드 성공
- [ ] 전체 기능 테스트 통과
- [ ] Privacy Policy 확인
- [ ] Terms of Service 확인

### 출시 후 추가
- [ ] 전체 Chad 캐릭터 (15개)
- [ ] 스토어 스크린샷 (5-8개)
- [ ] 앱 아이콘 최종 디자인
- [ ] 푸시업 자세 가이드 (7개)
- [ ] 코드 경고 제거
- [ ] 테스트 커버리지 > 70%

---

**마지막 업데이트**: 2025-10-08
**현재 상태**: 에셋 작업 필요 (코어 기능 완성)
**목표**: 2025-10 내 MVP 출시
