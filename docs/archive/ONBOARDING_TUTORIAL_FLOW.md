# 🎓 Mission100 온보딩 & 튜토리얼 플로우

## 📋 목차

1. [온보딩 플로우 (초회 실행)](#온보딩-플로우)
2. [레벨 테스트 로직](#레벨-테스트-로직)
3. [인앱 튜토리얼 (Feature Discovery)](#인앱-튜토리얼)
4. [UI/UX 상세 스펙](#uiux-상세-스펙)
5. [구현 체크리스트](#구현-체크리스트)

---

## 🚀 온보딩 플로우

### 플로우 다이어그램

```
앱 실행
    ↓
[초회?] ─NO→ 메인 화면
    ↓
   YES
    ↓
Screen 1: Welcome          (환영)
    ↓
Screen 2: Science          (과학적 근거)
    ↓
Screen 3: Program          (프로그램 소개)
    ↓
Screen 4: Level Test       (레벨 테스트)
    ↓
Screen 5: Form Guide       (푸시업 자세)
    ↓
Screen 6: Ready            (시작 준비)
    ↓
메인 화면 (첫 운동)
```

---

## 📱 Screen 1: Welcome (환영)

### 🎨 디자인 목업

```
┌─────────────────────────────────┐
│ [건너뛰기]                       │ ← 우상단
├─────────────────────────────────┤
│                                 │
│         💪                      │
│      Mission100                 │
│                                 │
│   [차드 일러스트]                │
│   (시작하는 자세)                │
│                                 │
│   6주 만에                      │
│   푸시업 100개 달성!             │
│                                 │
│   초보자도 가능합니다            │
│   과학적으로 검증된 프로그램     │
│                                 │
│                                 │
│   [● ○ ○ ○ ○ ○]  ← 페이지네이션│
│                                 │
│   [시작하기] ──────────>        │
│                                 │
└─────────────────────────────────┘
```

### 📝 텍스트 내용

**제목**: Mission100
**부제**: 6주 만에 푸시업 100개 달성!
**설명**:
- 초보자도 가능합니다
- 과학적으로 검증된 프로그램
- 주 3회, 20분

**버튼**:
- 시작하기 (Primary)
- 건너뛰기 (Text Button, 우상단)

### 🎨 ASSET 필요
- `assets/tutorial/onboarding_1_welcome.png`
- 차드 일러스트 (환영 포즈)
- 1080×1920px, PNG

---

## 📱 Screen 2: Science (과학적 근거)

### 🎨 디자인 목업

```
┌─────────────────────────────────┐
│ [건너뛰기]                       │
├─────────────────────────────────┤
│                                 │
│   🔬 과학적으로 검증됨            │
│                                 │
│   ┌─────────────────────┐      │
│   │  [하버드 로고]       │      │
│   │                      │      │
│   │  "40개 이상 푸시업    │      │
│   │   → CVD 위험         │      │
│   │   96% 감소"          │      │
│   │                      │      │
│   │  Harvard Study       │      │
│   │  (2019)              │      │
│   └─────────────────────┘      │
│                                 │
│   ✅ 8개 연구 논문 기반          │
│   ✅ 2016-2024 최신 연구        │
│   ✅ 주 3회 훈련 최적화          │
│   ✅ 48시간 회복 보장            │
│                                 │
│   [● ● ○ ○ ○ ○]               │
│                                 │
│   [< 이전]    [다음 >]          │
│                                 │
└─────────────────────────────────┘
```

### 📝 텍스트 내용

**제목**: 🔬 과학적으로 검증됨

**하버드 연구**:
- "40개 이상 푸시업 → CVD 위험 96% 감소"
- Harvard T.H. Chan School of Public Health (2019)
- 10년 추적 연구, 1,104명

**검증 항목**:
- ✅ 8개 연구 논문 기반
- ✅ 2016-2024 최신 연구
- ✅ 주 3회 훈련 최적화
- ✅ 48시간 회복 보장

**링크**: [자세히 보기] → 과학적 근거 화면

### 🎨 ASSET 필요
- `assets/tutorial/onboarding_2_science.png`
- 하버드 로고 (라이선스 확인 필요)
- 연구 논문 아이콘

---

## 📱 Screen 3: Program (프로그램 소개)

### 🎨 디자인 목업

```
┌─────────────────────────────────┐
│ [건너뛰기]                       │
├─────────────────────────────────┤
│                                 │
│   📅 6주 프로그램                │
│                                 │
│   주 3회 (월/수/금) 운동        │
│   화/목/토/일 휴식              │
│                                 │
│   ┌─────────────────────┐      │
│   │ [진행 바]            │      │
│   │ Week 1 → Week 6      │      │
│   └─────────────────────┘      │
│                                 │
│   Week 1  😊 적응기              │
│   Week 2  💪 강화기              │
│   Week 3  🔥 도전기              │
│   Week 4  ⚡ 가속기              │
│   Week 5  🚀 최고조              │
│   Week 6  🏆 100개 달성!         │
│                                 │
│   + 버피 피니셔로                │
│     전신 운동 효과               │
│                                 │
│   [● ● ● ○ ○ ○]               │
│                                 │
│   [< 이전]    [다음 >]          │
│                                 │
└─────────────────────────────────┘
```

### 📝 텍스트 내용

**제목**: 📅 6주 프로그램

**운동 일정**:
- 주 3회 (월/수/금) 운동
- 화/목/토/일 휴식
- 세션당 15-20분

**주차별 설명**:
1. Week 1: 😊 적응기 - 기초 체력 형성
2. Week 2: 💪 강화기 - 근력 발달 시작
3. Week 3: 🔥 도전기 - 중급 단계 돌파
4. Week 4: ⚡ 가속기 - 빠른 진전
5. Week 5: 🚀 최고조 - 최고 강도
6. Week 6: 🏆 100개 달성!

**추가 정보**:
- 버피 피니셔로 전신 운동 효과
- RPE 기반 자동 난이도 조정
- 50+ 업적 시스템

### 🎨 ASSET 필요
- `assets/tutorial/onboarding_3_program.png`
- 6주 진행 바 그래픽
- 주차별 아이콘

---

## 📱 Screen 4: Level Test (레벨 테스트)

### 🎨 디자인 목업

```
┌─────────────────────────────────┐
│ [< 뒤로]                         │
├─────────────────────────────────┤
│                                 │
│   🎯 당신의 레벨은?              │
│                                 │
│   현재 최대 푸시업 개수를        │
│   측정해주세요                   │
│                                 │
│   ┌─────────────────────┐      │
│   │  [푸시업 자세 이미지] │      │
│   │                      │      │
│   │  [▶ 자세 동영상 보기] │      │
│   └─────────────────────┘      │
│                                 │
│   ┌─────────────────────┐      │
│   │                      │      │
│   │      [    0    ]     │      │
│   │                      │      │
│   │  [ -1 ] [ +1 ] [+5]  │      │
│   │                      │      │
│   └─────────────────────┘      │
│                                 │
│   또는 직접 입력:               │
│   [______] 개                   │
│                                 │
│   💡 한 개도 못해도 괜찮아요!    │
│                                 │
│   [● ● ● ● ○ ○]               │
│                                 │
│   [다음 >]                      │
│                                 │
└─────────────────────────────────┘
```

### 📝 로직

#### 입력 방식
1. **카운터**: +1, -1, +5 버튼
2. **직접 입력**: 텍스트 필드
3. **최솟값**: 0개
4. **최댓값**: 999개

#### 레벨 분류
```dart
int pushupCount = userInput;
UserLevel level;

if (pushupCount <= 5) {
  level = UserLevel.rookie;  // 레벨 1: 5개 이하
  initialWeek = 1;
} else if (pushupCount <= 10) {
  level = UserLevel.rising;  // 레벨 2: 6-10개
  initialWeek = 1;
} else if (pushupCount <= 20) {
  level = UserLevel.alpha;   // 레벨 3: 11-20개
  initialWeek = 1;
} else {
  // 21개 이상
  level = UserLevel.alpha;
  // 주차 건너뛰기 옵션 제공
  suggestSkipWeeks = true;
}
```

#### 검증
- 0개 입력: "한 개도 못해도 괜찮아요! 무릎 푸시업부터 시작합니다."
- 50개 이상: "이미 고급자시네요! Week 3부터 시작할까요?"

### 🎨 ASSET 필요
- `assets/tutorial/onboarding_4_level_test.png`
- 푸시업 자세 사진

---

## 📱 Screen 5: Form Guide (푸시업 자세)

### 🎨 디자인 목업

```
┌─────────────────────────────────┐
│ [< 뒤로]                         │
├─────────────────────────────────┤
│                                 │
│   ✅ 올바른 푸시업 자세           │
│                                 │
│   ┌─────────────────────┐      │
│   │                      │      │
│   │  [동영상 플레이어]    │      │
│   │                      │      │
│   │  [▶ 재생] 00:15      │      │
│   │                      │      │
│   └─────────────────────┘      │
│                                 │
│   핵심 포인트:                  │
│                                 │
│   ✓ 어깨 너비로 손을 벌림        │
│   ✓ 몸을 일직선으로 유지         │
│   ✓ 가슴이 바닥에 가까이         │
│   ✓ 팔꿈치는 45도 각도           │
│                                 │
│   ⚠️ 주의사항:                  │
│   • 엉덩이가 처지지 않게         │
│   • 고개를 들지 않기              │
│                                 │
│   [9가지 변형 보기]             │
│                                 │
│   [● ● ● ● ● ○]               │
│                                 │
│   [건너뛰기]    [다음 >]        │
│                                 │
└─────────────────────────────────┘
```

### 📝 내용

**제목**: ✅ 올바른 푸시업 자세

**동영상**: 15초, 720p
- 시작 자세 (3초)
- 내려가기 (3초, 슬로우)
- 올라가기 (3초, 슬로우)
- 반복 (3회)

**핵심 포인트**:
1. ✓ 어깨 너비로 손을 벌림
2. ✓ 몸을 일직선으로 유지
3. ✓ 가슴이 바닥에 가까이
4. ✓ 팔꿈치는 45도 각도

**주의사항**:
- ⚠️ 엉덩이가 처지지 않게
- ⚠️ 고개를 들지 않기
- ⚠️ 너무 빨리 하지 않기

**링크**: [9가지 변형 보기] → 푸시업 폼 가이드 화면

### 🎨 ASSET 필요
- `assets/tutorial/pushup_form_demo.mp4` (15초)
- 핵심 포인트 일러스트

---

## 📱 Screen 6: Ready (시작 준비)

### 🎨 디자인 목업

```
┌─────────────────────────────────┐
│                                 │
├─────────────────────────────────┤
│                                 │
│   🎉 준비 완료!                  │
│                                 │
│   ┌─────────────────────┐      │
│   │                      │      │
│   │  [차드 일러스트]      │      │
│   │  (준비 완료 포즈)     │      │
│   │                      │      │
│   └─────────────────────┘      │
│                                 │
│   선택된 레벨: 레벨 2 (중급)    │
│   시작일: 2025-10-03            │
│   목표일: 2025-11-14 (6주 후)   │
│                                 │
│   ┌─────────────────────┐      │
│   │ 📅 첫 운동            │      │
│   │                      │      │
│   │ Week 1, Day 1        │      │
│   │ • 푸시업 5세트 (25개)│      │
│   │ • 버피 2세트 (12개)  │      │
│   │ • 예상 시간: 12분    │      │
│   │                      │      │
│   └─────────────────────┘      │
│                                 │
│   💡 언제든지 설정에서          │
│      레벨을 변경할 수 있어요    │
│                                 │
│   [● ● ● ● ● ●]               │
│                                 │
│   [운동 시작하기!] ─────>       │
│                                 │
└─────────────────────────────────┘
```

### 📝 내용

**제목**: 🎉 준비 완료!

**선택 정보 표시**:
- 선택된 레벨: 레벨 X (초급/중급/고급)
- 시작일: YYYY-MM-DD
- 목표일: YYYY-MM-DD (6주 후)

**첫 운동 정보**:
```dart
final firstWorkout = WorkoutData.getWorkout(userLevel, 1, 1);
```
- Week 1, Day 1
- 푸시업 X세트 (총 Y개)
- 버피 Z세트 (총 W개)
- 예상 시간: M분

**안내 메시지**:
- 💡 언제든지 설정에서 레벨을 변경할 수 있어요
- 💡 운동 일정은 자동으로 알림 설정됩니다

**버튼**: [운동 시작하기!] (Primary, Full Width)

### 📦 데이터 저장 (SharedPreferences)
```dart
await prefs.setBool('onboarding_completed', true);
await prefs.setString('user_level', userLevel.toString());
await prefs.setInt('initial_pushup_count', pushupCount);
await prefs.setString('start_date', DateTime.now().toIso8601String());
await prefs.setInt('current_week', 1);
await prefs.setInt('current_day', 1);
```

### 🎨 ASSET 필요
- `assets/tutorial/onboarding_6_ready.png`
- 차드 일러스트 (준비 완료)

---

## 🎯 레벨 테스트 로직

### 플로차트

```
사용자 입력
    ↓
┌─────────────────┐
│ 푸시업 개수 확인 │
└─────────────────┘
    ↓
    ├─ 0-5개  → 레벨 1 (5개 이하)    → Week 1부터
    ├─ 6-10개 → 레벨 2 (6-10개)      → Week 1부터
    ├─ 11-20개 → 레벨 3 (11-20개)    → Week 1부터
    └─ 21+개  → 레벨 3               → 주차 건너뛰기 옵션
                                        (Week 2 or 3부터?)
```

### 코드 예시

```dart
class LevelTestLogic {
  static LevelTestResult calculateLevel(int pushupCount) {
    UserLevel level;
    int startWeek = 1;
    String message;

    if (pushupCount <= 5) {
      level = UserLevel.rookie;
      message = '초보자 프로그램으로 시작합니다.\n무릎 푸시업부터 시작할 수 있어요!';
    } else if (pushupCount <= 10) {
      level = UserLevel.rising;
      message = '중급 프로그램으로 시작합니다.\n체계적으로 100개를 향해 가봐요!';
    } else if (pushupCount <= 20) {
      level = UserLevel.alpha;
      message = '고급 프로그램으로 시작합니다.\n이미 좋은 실력이네요!';
    } else if (pushupCount <= 35) {
      level = UserLevel.alpha;
      startWeek = 1;
      message = '고급 프로그램으로 시작합니다.\n곧 100개를 달성할 수 있을 거예요!';
    } else {
      level = UserLevel.alpha;
      // 주차 건너뛰기 제안
      message = '이미 고급자시네요!\nWeek 2부터 시작할까요?';
      // 사용자에게 선택 옵션 제공
    }

    return LevelTestResult(
      level: level,
      startWeek: startWeek,
      message: message,
      pushupCount: pushupCount,
    );
  }
}

class LevelTestResult {
  final UserLevel level;
  final int startWeek;
  final String message;
  final int pushupCount;

  LevelTestResult({
    required this.level,
    required this.startWeek,
    required this.message,
    required this.pushupCount,
  });
}
```

---

## 🎓 인앱 튜토리얼 (Feature Discovery)

### 1. 첫 운동 세션 시작

```
┌─────────────────────────────────┐
│  💡 Tip: 세트 기록              │
│  ┌───────────────────────────┐  │
│  │                            │  │
│  │ 각 세트 완료 후            │  │
│  │ 실제 완료한 횟수를         │  │
│  │ 입력하세요                 │  │
│  │                            │  │
│  │ 목표보다 많이 하면         │  │
│  │ 더 빠르게 성장해요!        │  │
│  │                            │  │
│  └───────────────────────────┘  │
│         ↓                       │
│   [SET 1: 6개 목표]             │
│   [__개 완료]                   │
│                                 │
│   [확인]                        │
└─────────────────────────────────┘
```

**트리거**: 첫 운동 세션 시작 시
**지속**: 3초 후 자동 사라짐 or 탭으로 닫기

---

### 2. RPE 선택

```
┌─────────────────────────────────┐
│  💡 Tip: RPE 피드백              │
│  ┌───────────────────────────┐  │
│  │                            │  │
│  │ 운동 후 느낀 강도를        │  │
│  │ 선택해주세요               │  │
│  │                            │  │
│  │ 다음 운동 난이도가         │  │
│  │ 자동으로 조정됩니다        │  │
│  │                            │  │
│  └───────────────────────────┘  │
│         ↓                       │
│   [RPE 선택]                    │
│   😊 😐 😰                     │
│                                 │
│   [확인]                        │
└─────────────────────────────────┘
```

**트리거**: 첫 세트 완료 후 RPE 선택 화면
**지속**: 사용자가 확인 누를 때까지

---

### 3. 전환 휴식

```
┌─────────────────────────────────┐
│  💡 Tip: 전환 휴식               │
│  ┌───────────────────────────┐  │
│  │                            │  │
│  │ 푸시업 완료! 🎉            │  │
│  │                            │  │
│  │ 2-3분 휴식 후              │  │
│  │ 버피 피니셔가 시작됩니다   │  │
│  │                            │  │
│  │ 물을 마시고 심호흡하세요   │  │
│  │                            │  │
│  └───────────────────────────┘  │
│                                 │
│   [휴식 중: 02:35]              │
│                                 │
│   [피니셔 건너뛰기] [지금 시작]│
└─────────────────────────────────┘
```

**트리거**: 첫 푸시업 세션 완료 후
**지속**: 전환 휴식 시간 동안

---

### 4. 첫 운동 완료

```
┌─────────────────────────────────┐
│  🎉 첫 운동 완료!                │
│  ┌───────────────────────────┐  │
│  │                            │  │
│  │ 대단해요! 첫 걸음을         │  │
│  │ 떼셨습니다!                │  │
│  │                            │  │
│  │ 이제 진행 상황 탭에서      │  │
│  │ 통계를 확인할 수 있어요    │  │
│  │                            │  │
│  │ 다음 운동: 10월 5일 (월)   │  │
│  │                            │  │
│  └───────────────────────────┘  │
│                                 │
│   [통계 보기] [확인]            │
└─────────────────────────────────┘
```

**트리거**: 첫 운동 (푸시업 + 버피) 완료 후
**지속**: 사용자가 확인 누를 때까지

---

### 5. 캘린더 발견

```
┌─────────────────────────────────┐
│  💡 Tip: 운동 기록               │
│  ┌───────────────────────────┐  │
│  │                            │  │
│  │ 캘린더에서 운동 기록을     │  │
│  │ 한눈에 볼 수 있어요        │  │
│  │                            │  │
│  │ ✓ 완료일: 초록색           │  │
│  │ ○ 예정일: 회색             │  │
│  │                            │  │
│  └───────────────────────────┘  │
│         ↓                       │
│   [캘린더 뷰]                   │
│                                 │
│   [확인]                        │
└─────────────────────────────────┘
```

**트리거**: 사용자가 처음 캘린더 탭 방문 시
**지속**: 1회만 표시

---

### 6. 업적 획득

```
┌─────────────────────────────────┐
│  🏆 새로운 업적!                 │
│  ┌───────────────────────────┐  │
│  │                            │  │
│  │  [배지 이미지]             │  │
│  │                            │  │
│  │  "첫 걸음"                 │  │
│  │                            │  │
│  │  첫 운동을 완료했습니다    │  │
│  │                            │  │
│  │  +10 XP                    │  │
│  │                            │  │
│  └───────────────────────────┘  │
│                                 │
│   [공유하기] [확인]             │
└─────────────────────────────────┘
```

**트리거**: 업적 달성 시
**지속**: 사용자가 확인 누를 때까지
**애니메이션**: 페이드 인 + 배지 확대

---

## 📐 UI/UX 상세 스펙

### 색상

```dart
class OnboardingColors {
  static const primary = Color(0xFFE53E3E);        // 빨강 (액션)
  static const secondary = Color(0xFFFFB000);      // 금색 (강조)
  static const background = Color(0xFFF7FAFC);     // 밝은 회색
  static const text = Color(0xFF2D3748);           // 진한 회색
  static const textSecondary = Color(0xFF718096);  // 중간 회색
  static const success = Color(0xFF51CF66);        // 초록
  static const indicator = Color(0xFFCBD5E0);      // 인디케이터 (비활성)
}
```

### 타이포그래피

```dart
class OnboardingTextStyles {
  // 제목 (큰)
  static const title = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: OnboardingColors.text,
    height: 1.2,
  );

  // 제목 (중간)
  static const subtitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: OnboardingColors.text,
    height: 1.3,
  );

  // 본문
  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: OnboardingColors.textSecondary,
    height: 1.5,
  );

  // 버튼
  static const button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
```

### 애니메이션

```dart
class OnboardingAnimations {
  // 페이지 전환
  static const pageTransitionDuration = Duration(milliseconds: 300);
  static const pageTransitionCurve = Curves.easeInOut;

  // Tip 표시
  static const tipFadeInDuration = Duration(milliseconds: 500);
  static const tipAutoHideDuration = Duration(seconds: 5);

  // 배지 획득
  static const badgeScaleDuration = Duration(milliseconds: 600);
  static const badgeScaleCurve = Curves.elasticOut;
}
```

### 간격

```dart
class OnboardingSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 16.0;
  static const md = 24.0;
  static const lg = 32.0;
  static const xl = 48.0;
  static const xxl = 64.0;
}
```

---

## ✅ 구현 체크리스트

### Phase 1: 온보딩 화면 (6개)

- [ ] **Screen 1: Welcome**
  - [ ] UI 레이아웃
  - [ ] 차드 일러스트 배치
  - [ ] 애니메이션 (페이드 인)
  - [ ] 건너뛰기 기능
  - [ ] 다음 버튼

- [ ] **Screen 2: Science**
  - [ ] UI 레이아웃
  - [ ] 하버드 연구 카드
  - [ ] 체크리스트 항목
  - [ ] 자세히 보기 링크
  - [ ] 이전/다음 버튼

- [ ] **Screen 3: Program**
  - [ ] UI 레이아웃
  - [ ] 6주 진행 바
  - [ ] 주차별 설명
  - [ ] 이전/다음 버튼

- [ ] **Screen 4: Level Test**
  - [ ] UI 레이아웃
  - [ ] 카운터 (+1, -1, +5)
  - [ ] 직접 입력 필드
  - [ ] 레벨 계산 로직
  - [ ] 검증 (0-999)
  - [ ] 다음 버튼

- [ ] **Screen 5: Form Guide**
  - [ ] UI 레이아웃
  - [ ] 동영상 플레이어
  - [ ] 핵심 포인트 리스트
  - [ ] 9가지 변형 링크
  - [ ] 건너뛰기/다음 버튼

- [ ] **Screen 6: Ready**
  - [ ] UI 레이아웃
  - [ ] 선택 정보 표시
  - [ ] 첫 운동 정보
  - [ ] 데이터 저장 (SharedPreferences)
  - [ ] 시작 버튼

### Phase 2: 데이터 & 로직

- [ ] **레벨 테스트 로직**
  - [ ] `LevelTestLogic` 클래스
  - [ ] `calculateLevel()` 메서드
  - [ ] 0-5개: 레벨 1
  - [ ] 6-10개: 레벨 2
  - [ ] 11-20개: 레벨 3
  - [ ] 21+개: 주차 건너뛰기 옵션

- [ ] **데이터 저장**
  - [ ] `onboarding_completed` 플래그
  - [ ] `user_level` 저장
  - [ ] `initial_pushup_count` 저장
  - [ ] `start_date` 저장
  - [ ] `current_week`, `current_day` 초기화

### Phase 3: 인앱 튜토리얼

- [ ] **Feature Discovery**
  - [ ] 첫 운동: 세트 기록 Tip
  - [ ] 첫 운동: RPE 선택 Tip
  - [ ] 첫 운동: 전환 휴식 Tip
  - [ ] 첫 완료: 축하 메시지
  - [ ] 캘린더: 기록 보기 Tip
  - [ ] 업적: 획득 애니메이션

- [ ] **Tooltip 시스템**
  - [ ] `showFeatureDiscovery()` 헬퍼
  - [ ] 자동 숨김 (5초)
  - [ ] 탭으로 닫기
  - [ ] 1회만 표시 플래그

### Phase 4: ASSET

- [ ] **이미지** (6개)
  - [ ] onboarding_1_welcome.png
  - [ ] onboarding_2_science.png
  - [ ] onboarding_3_program.png
  - [ ] onboarding_4_level_test.png
  - [ ] onboarding_5_form_guide.png
  - [ ] onboarding_6_ready.png

- [ ] **동영상** (1개)
  - [ ] pushup_form_demo.mp4 (15초)

- [ ] **차드 일러스트** (3개)
  - [ ] 환영 포즈
  - [ ] 준비 완료 포즈
  - [ ] 레벨 테스트 포즈

### Phase 5: 테스트

- [ ] **기능 테스트**
  - [ ] 모든 화면 전환
  - [ ] 건너뛰기 기능
  - [ ] 레벨 계산 정확도
  - [ ] 데이터 저장/불러오기
  - [ ] Tip 표시/숨김

- [ ] **UX 테스트**
  - [ ] 애니메이션 부드러움
  - [ ] 버튼 터치 영역
  - [ ] 가독성 (다크모드 포함)
  - [ ] 접근성 (TalkBack, VoiceOver)

---

## 📝 추가 고려사항

### 1. 건너뛰기 기능
- 온보딩 모든 화면에 "건너뛰기" 버튼
- 건너뛰기 시 레벨 선택 화면으로 바로 이동
- "나중에 다시 보기" 옵션

### 2. 언어 지원
- 한국어/영어 모든 텍스트 i18n
- 동영상 자막 (한국어/영어)

### 3. 접근성
- Screen Reader 지원
- 고대비 모드
- 큰 터치 영역

### 4. 분석
- 온보딩 완료율 추적
- 각 화면 체류 시간
- 건너뛰기율
- 레벨 분포

---

**작성일**: 2025-10-03
**온보딩 화면**: 6개
**인앱 튜토리얼**: 6개
**예상 작업 기간**: 5-7일
