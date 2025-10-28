# 🎓 Mission100 온보딩 & 튜토리얼 플로우 (v3 - 14주 프로그램)

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
Screen 3: Program          (14주 프로그램 소개)
    ↓
Screen 4: Ready            (시작 준비)
    ↓
메인 화면 (첫 운동)
    ↓
[첫 운동 시작 시]
    ↓
In-App Tutorial: 푸시업 자세 가이드
```

**변경사항**:
- 온보딩을 4개 화면으로 간소화
- Level Test와 Form Guide를 온보딩에서 제거
- 푸시업 자세 가이드는 **첫 운동 시작 시** 인앱 튜토리얼로 제공
- 레벨은 앱 내부 설정에서 선택 (또는 기본값: 초급)

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
│   14주 만에                     │
│   푸시업 100개 달성!             │
│                                 │
│   초보자도 가능합니다            │
│   과학적으로 검증된 프로그램     │
│                                 │
│                                 │
│   [● ○ ○ ○]  ← 페이지네이션│
│                                 │
│   [시작하기] ──────────>        │
│                                 │
└─────────────────────────────────┘
```

### 📝 텍스트 내용

**제목**: Mission100
**부제**: 14주 만에 푸시업 100개 달성!
**설명**:
- 초보자도 가능합니다
- 과학적으로 검증된 프로그램
- 주 3회, 하루 20분

**버튼**:
- 시작하기 (Primary)
- 건너뛰기 (Text Button, 우상단)

### 🎨 ASSET 필요
- `assets/images/chad/온보딩/welcome_chad.png`
- 차드 일러스트 (환영 포즈)
- 1080×1920px, PNG

### 📝 Localization Keys

```json
{
  "onboardingWelcomeTitle": "Mission100",
  "onboardingWelcomeSubtitle": "14주 만에 푸시업 100개 달성!",
  "onboardingWelcomeDesc1": "초보자도 가능합니다",
  "onboardingWelcomeDesc2": "과학적으로 검증된 프로그램",
  "onboardingWelcomeDesc3": "주 3회, 하루 20분",
  "onboardingStart": "시작하기",
  "skip": "건너뛰기"
}
```

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
│   ✅ 14주 점진적 증가 시스템     │
│   ✅ 2016-2024 최신 연구        │
│   ✅ 주 3회 훈련 최적화          │
│   ✅ 48시간 회복 보장            │
│                                 │
│   [● ● ○ ○]               │
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
- ✅ 14주 점진적 증가 시스템 (평균 +17.5% 증가)
- ✅ 2016-2024 최신 연구 기반
- ✅ 주 3회 훈련 최적화
- ✅ 48시간 회복 보장

**링크**: [자세히 보기] → 과학적 근거 화면

### 🎨 ASSET 필요
- `assets/images/chad/온보딩/science_chad.png`
- 연구 논문 아이콘

### 📝 Localization Keys

```json
{
  "onboardingScienceTitle": "🔬 과학적으로 검증됨",
  "onboardingScienceHarvard": "40개 이상 푸시업 → CVD 위험 96% 감소",
  "onboardingScienceSource": "Harvard Study (2019)",
  "onboardingScience1": "14주 점진적 증가 시스템",
  "onboardingScience2": "2016-2024 최신 연구 기반",
  "onboardingScience3": "주 3회 훈련 최적화",
  "onboardingScience4": "48시간 회복 보장"
}
```

---

## 📱 Screen 3: Program (14주 프로그램 소개)

### 🎨 디자인 목업

```
┌─────────────────────────────────┐
│ [건너뛰기]                       │
├─────────────────────────────────┤
│                                 │
│   📅 14주 프로그램               │
│                                 │
│   주 3회 (월/수/금) 운동        │
│   화/목/토/일 휴식              │
│                                 │
│   ┌─────────────────────┐      │
│   │ [진행 바]            │      │
│   │ Week 0 → Week 14     │      │
│   │                      │      │
│   │ [Chad 진화 7단계]    │      │
│   └─────────────────────┘      │
│                                 │
│   🎯 진화 시스템                │
│                                 │
│   Week 0  😴 수면모자차드        │
│   Week 2  💪 기본차드            │
│   Week 4  ☕ 커피차드            │
│   Week 6  👀 정면차드            │
│   Week 8  😎 썬글라스차드        │
│   Week 10 ✨ 빛나는눈차드        │
│   Week 14 👑 더블차드 (최종!)    │
│                                 │
│   [● ● ● ○]               │
│                                 │
│   [< 이전]    [다음 >]          │
│                                 │
└─────────────────────────────────┘
```

### 📝 텍스트 내용

**제목**: 📅 14주 프로그램

**운동 일정**:
- 주 3회 (월/수/금) 운동
- 화/목/토/일 휴식
- 세션당 15-25분

**진화 시스템 (2주마다)**:
1. Week 0: 😴 수면모자차드 - 시작 단계
2. Week 2: 💪 기본차드 - 2주차 완료
3. Week 4: ☕ 커피차드 - 4주차 완료
4. Week 6: 👀 정면차드 - 6주차 완료 (중간 지점!)
5. Week 8: 😎 썬글라스차드 - 8주차 완료
6. Week 10: ✨ 빛나는눈차드 - 10주차 완료
7. Week 14: 👑 더블차드 - 100개 달성! (최종 진화)

**추가 정보**:
- 평균 +17.5% 점진적 증가
- RPE 기반 자동 난이도 조정
- 50+ 업적 시스템

### 🎨 ASSET 필요
- `assets/images/chad/온보딩/program_chad.png`
- 14주 진행 바 그래픽
- Chad 7단계 진화 미리보기 이미지

### 📝 Localization Keys

```json
{
  "onboardingProgramTitle": "📅 14주 프로그램",
  "onboardingProgramSchedule": "주 3회 (월/수/금) 운동",
  "onboardingProgramRest": "화/목/토/일 휴식",
  "onboardingProgramDuration": "세션당 15-25분",
  "onboardingEvolutionTitle": "🎯 진화 시스템",
  "onboardingEvolution0": "Week 0: 😴 수면모자차드",
  "onboardingEvolution2": "Week 2: 💪 기본차드",
  "onboardingEvolution4": "Week 4: ☕ 커피차드",
  "onboardingEvolution6": "Week 6: 👀 정면차드",
  "onboardingEvolution8": "Week 8: 😎 썬글라스차드",
  "onboardingEvolution10": "Week 10: ✨ 빛나는눈차드",
  "onboardingEvolution14": "Week 14: 👑 더블차드 (최종!)"
}
```

---

## 📱 Screen 4: Ready (시작 준비)

**변경사항**: 레벨 테스트를 온보딩에서 제거하고, 기본값(초급)으로 시작합니다. 사용자는 설정에서 레벨을 변경할 수 있습니다.

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
│   시작 레벨: 초급               │
│   시작일: 2025-10-20            │
│   목표일: 2026-01-25 (14주 후)  │
│                                 │
│   ┌─────────────────────┐      │
│   │ 📅 첫 운동            │      │
│   │                      │      │
│   │ Week 0, Day 1        │      │
│   │ • 푸시업 5세트       │      │
│   │ • 예상 시간: 15분    │      │
│   │                      │      │
│   │ 💡 2주마다 Chad가    │      │
│   │    진화합니다!       │      │
│   └─────────────────────┘      │
│                                 │
│   💡 언제든지 설정에서          │
│      레벨을 변경할 수 있어요    │
│                                 │
│   [● ● ● ●]               │
│                                 │
│   [운동 시작하기!] ─────>       │
│                                 │
└─────────────────────────────────┘
```

### 📝 내용 (14주 버전)

**제목**: 🎉 준비 완료!

**선택 정보 표시**:
- 시작 레벨: 초급 (기본값)
- 시작일: YYYY-MM-DD
- 목표일: YYYY-MM-DD (14주 후)

**첫 운동 정보**:
- Week 0, Day 1
- 푸시업 5세트
- 예상 시간: 12-20분

**진화 안내**:
- 💡 2주마다 Chad가 진화합니다!
- 💡 총 7단계 진화 시스템

**안내 메시지**:
- 💡 언제든지 설정에서 레벨을 변경할 수 있어요
- 💡 운동 일정은 자동으로 알림 설정됩니다

**버튼**: [운동 시작하기!] (Primary, Full Width)

### 📦 데이터 저장 (SharedPreferences)
```dart
await prefs.setBool('onboarding_completed', true);
await prefs.setString('user_level', UserLevel.beginner.toString());  // 기본값: 초급
await prefs.setInt('initial_pushup_count', 0);  // 레벨 테스트 없음
await prefs.setString('start_date', DateTime.now().toIso8601String());
await prefs.setInt('current_week', 0);
await prefs.setInt('current_day', 1);
await prefs.setInt('program_duration_weeks', 14);
```

### 🎨 ASSET 필요
- `assets/images/chad/온보딩/ready_chad.png` (이미 생성됨: onboarding_6_ready.png)

### 📝 Localization Keys

```json
{
  "readyTitle": "🎉 준비 완료!",
  "readyLevel": "시작 레벨:",
  "readyLevelBeginner": "초급",
  "readyStartDate": "시작일:",
  "readyTargetDate": "목표일:",
  "readyFirstWorkout": "📅 첫 운동",
  "readyWeek0Day1": "Week 0, Day 1",
  "readyPushupSets": "푸시업 5세트",
  "readyEstimatedTime": "예상 시간:",
  "readyEvolutionTip": "💡 2주마다 Chad가 진화합니다!",
  "readySettingsTip": "💡 언제든지 설정에서 레벨을 변경할 수 있어요",
  "readyStartButton": "운동 시작하기!"
}
```

---

## 🚫 제거된 화면들

### ~~Screen 4: Level Test (레벨 테스트)~~ → **제거됨**
**이유**: 온보딩을 간소화하고, 기본 레벨(초급)로 시작. 설정에서 변경 가능.

### ~~Screen 5: Form Guide (푸시업 자세)~~ → **인앱 튜토리얼로 이동**
**이유**: 첫 운동 시작 시 자세 가이드를 보여주는 것이 더 효과적.

---

## 📱 ~~Screen 4 (Old): Level Test (레벨 테스트)~~ - DEPRECATED

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

### 📝 로직 (14주 버전)

#### 입력 방식
1. **카운터**: +1, -1, +5 버튼
2. **직접 입력**: 텍스트 필드
3. **최솟값**: 0개
4. **최댓값**: 999개

#### 레벨 분류 (14주 프로그램)

```dart
int pushupCount = userInput;
UserLevel level;
int initialWeek = 0;

if (pushupCount <= 10) {
  level = UserLevel.beginner;  // 초급: 0-10개
  initialWeek = 0;
  message = '초보자 프로그램으로 시작합니다.\n차근차근 100개를 향해 가봐요!';
} else if (pushupCount <= 25) {
  level = UserLevel.intermediate;  // 중급: 11-25개
  initialWeek = 0;
  message = '중급 프로그램으로 시작합니다.\n이미 좋은 기초가 있으시네요!';
} else if (pushupCount <= 50) {
  level = UserLevel.advanced;   // 고급: 26-50개
  initialWeek = 0;
  message = '고급 프로그램으로 시작합니다.\n100개가 멀지 않았어요!';
} else if (pushupCount <= 75) {
  level = UserLevel.expert;     // 전문가: 51-75개
  initialWeek = 0;
  message = '전문가 프로그램으로 시작합니다!\n곧 100개를 달성하실 거예요!';
  // 주차 건너뛰기 옵션 제공
  suggestSkipWeeks = true;
} else {
  // 76개 이상
  level = UserLevel.expert;
  message = '이미 매우 높은 수준이시네요!\nWeek 4부터 시작할까요?';
  suggestSkipWeeks = true;
  suggestedStartWeek = 4;
}
```

#### 검증
- 0개 입력: "한 개도 못해도 괜찮아요! 무릎 푸시업부터 시작합니다."
- 50개 이상: "이미 고급자시네요! Week 2부터 시작할까요?"
- 75개 이상: "대단한 실력이네요! Week 4부터 시작하시겠어요?"

### 🎨 ASSET 필요
- `assets/images/chad/온보딩/level_test_chad.png`
- 푸시업 자세 사진

### 📝 Localization Keys

```json
{
  "levelTestTitle": "🎯 당신의 레벨은?",
  "levelTestDescription": "현재 최대 푸시업 개수를 측정해주세요",
  "levelTestVideoLink": "▶ 자세 동영상 보기",
  "levelTestManualInput": "또는 직접 입력:",
  "levelTestTip": "💡 한 개도 못해도 괜찮아요!",
  "levelTestNext": "다음"
}
```

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
│   • 2초 내려가기, 1초 올라오기   │
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
- ⚠️ 2초 내려가기, 1초 올라오기

**링크**: [9가지 변형 보기] → 푸시업 폼 가이드 화면

### 🎨 ASSET 필요
- `assets/videos/pushup_form_demo.mp4` (15초)
- 핵심 포인트 일러스트

### 📝 Localization Keys

```json
{
  "formGuideTitle": "✅ 올바른 푸시업 자세",
  "formGuidePoint1": "어깨 너비로 손을 벌림",
  "formGuidePoint2": "몸을 일직선으로 유지",
  "formGuidePoint3": "가슴이 바닥에 가까이",
  "formGuidePoint4": "팔꿈치는 45도 각도",
  "formGuideWarning1": "엉덩이가 처지지 않게",
  "formGuideWarning2": "고개를 들지 않기",
  "formGuideWarning3": "2초 내려가기, 1초 올라오기",
  "formGuideVariations": "9가지 변형 보기"
}
```

---

## 📱 ~~Screen 6 (Old): Ready (시작 준비)~~ - DEPRECATED

**이 화면은 이제 Screen 4로 이동되었습니다.**

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
│   선택된 레벨: 중급 (11-25개)   │
│   시작일: 2025-10-19            │
│   목표일: 2026-01-25 (14주 후)  │
│                                 │
│   ┌─────────────────────┐      │
│   │ 📅 첫 운동            │      │
│   │                      │      │
│   │ Week 0, Day 1        │      │
│   │ • 푸시업 5세트       │      │
│   │ • 예상 시간: 15분    │      │
│   │                      │      │
│   │ 💡 2주마다 Chad가    │      │
│   │    진화합니다!       │      │
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

### 📝 내용 (14주 버전)

**제목**: 🎉 준비 완료!

**선택 정보 표시**:
- 선택된 레벨: 초급/중급/고급/전문가 (X-Y개)
- 시작일: YYYY-MM-DD
- 목표일: YYYY-MM-DD (14주 후)

**첫 운동 정보**:
- Week 0, Day 1
- 푸시업 5세트
- 예상 시간: 12-20분 (레벨에 따라)

**진화 안내**:
- 💡 2주마다 Chad가 진화합니다!
- 💡 총 7단계 진화 시스템

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
await prefs.setInt('current_week', 0);  // 14주 프로그램은 Week 0부터
await prefs.setInt('current_day', 1);
await prefs.setInt('program_duration_weeks', 14);
```

### 🎨 ASSET 필요
- `assets/images/chad/온보딩/ready_chad.png`
- 차드 일러스트 (준비 완료)

### 📝 Localization Keys

```json
{
  "readyTitle": "🎉 준비 완료!",
  "readyLevel": "선택된 레벨:",
  "readyStartDate": "시작일:",
  "readyTargetDate": "목표일:",
  "readyFirstWorkout": "📅 첫 운동",
  "readyWeek0Day1": "Week 0, Day 1",
  "readyPushupSets": "푸시업 5세트",
  "readyEstimatedTime": "예상 시간:",
  "readyEvolutionTip": "💡 2주마다 Chad가 진화합니다!",
  "readySettingsTip": "💡 언제든지 설정에서 레벨을 변경할 수 있어요",
  "readyStartButton": "운동 시작하기!"
}
```

---

## 🎯 레벨 테스트 로직 (14주 프로그램)

### 플로차트

```
사용자 입력
    ↓
┌─────────────────┐
│ 푸시업 개수 확인 │
└─────────────────┘
    ↓
    ├─ 0-10개   → 초급 (Beginner)      → Week 0부터
    ├─ 11-25개  → 중급 (Intermediate)  → Week 0부터
    ├─ 26-50개  → 고급 (Advanced)      → Week 0부터
    ├─ 51-75개  → 전문가 (Expert)      → Week 0부터 (건너뛰기 옵션)
    └─ 76+개    → 전문가 (Expert)      → Week 2 or 4부터 건너뛰기
```

### 코드 예시 (14주 버전)

```dart
class LevelTestLogic {
  static LevelTestResult calculateLevel(int pushupCount) {
    UserLevel level;
    int startWeek = 0;  // 14주 프로그램은 Week 0부터
    String message;
    bool suggestSkipWeeks = false;
    int? suggestedStartWeek;

    if (pushupCount <= 10) {
      level = UserLevel.beginner;
      message = '초보자 프로그램으로 시작합니다.\n'
               '차근차근 100개를 향해 가봐요!';
    } else if (pushupCount <= 25) {
      level = UserLevel.intermediate;
      message = '중급 프로그램으로 시작합니다.\n'
               '이미 좋은 기초가 있으시네요!';
    } else if (pushupCount <= 50) {
      level = UserLevel.advanced;
      message = '고급 프로그램으로 시작합니다.\n'
               '100개가 멀지 않았어요!';
    } else if (pushupCount <= 75) {
      level = UserLevel.expert;
      message = '전문가 프로그램으로 시작합니다!\n'
               '곧 100개를 달성하실 거예요!';
      suggestSkipWeeks = true;
      suggestedStartWeek = 2;  // Week 2부터 시작 제안
    } else {
      level = UserLevel.expert;
      message = '이미 매우 높은 수준이시네요!\n'
               'Week 4부터 시작할까요?';
      suggestSkipWeeks = true;
      suggestedStartWeek = 4;  // Week 4부터 시작 제안
    }

    return LevelTestResult(
      level: level,
      startWeek: startWeek,
      message: message,
      pushupCount: pushupCount,
      suggestSkipWeeks: suggestSkipWeeks,
      suggestedStartWeek: suggestedStartWeek,
    );
  }
}

class LevelTestResult {
  final UserLevel level;
  final int startWeek;
  final String message;
  final int pushupCount;
  final bool suggestSkipWeeks;
  final int? suggestedStartWeek;

  LevelTestResult({
    required this.level,
    required this.startWeek,
    required this.message,
    required this.pushupCount,
    this.suggestSkipWeeks = false,
    this.suggestedStartWeek,
  });
}

enum UserLevel {
  beginner,      // 0-10개
  intermediate,  // 11-25개
  advanced,      // 26-50개
  expert,        // 51+개
}
```

---

## 🎓 인앱 튜토리얼 (Feature Discovery)

### 0. 첫 운동 전: 푸시업 자세 가이드 (NEW!)

**온보딩에서 제거된 자세 가이드를 첫 운동 시작 전에 표시합니다.**

```
┌─────────────────────────────────┐
│  ✅ 올바른 푸시업 자세           │
│  ┌───────────────────────────┐  │
│  │                            │  │
│  │  [근육 강조 이미지]        │  │
│  │                            │  │
│  │  기본 푸시업 자세:         │  │
│  │                            │  │
│  │  가슴: 60% 🔴            │  │
│  │  삼두근: 25% 🟠          │  │
│  │  어깨: 15% 🟡            │  │
│  │                            │  │
│  └───────────────────────────┘  │
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
│   • 2초 내려가기, 1초 올라오기   │
│                                 │
│   [9가지 변형 보기] [시작하기]  │
└─────────────────────────────────┘
```

**트리거**: Week 0, Day 1 운동 시작 전 (온보딩 완료 직후)
**지속**: 사용자가 [시작하기] 버튼 누를 때까지
**필요 이미지**:
- `pushup_basic_muscles.png` - 근육 하이라이트 이미지
- 또는 `onboarding_4_level_test.png` / `onboarding_5_form_guide.png` 재활용

**링크**: [9가지 변형 보기] → 푸시업 변형 가이드 화면 (나중에 구현)

---

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

**트리거**: 첫 운동 세션 시작 시 (Week 0, Day 1)
**지속**: 3초 후 자동 사라짐 or 탭으로 닫기

---

### 2. RPE 선택 (난이도 피드백)

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
│  │ (평균 +17.5% 증가)         │  │
│  │                            │  │
│  └───────────────────────────┘  │
│         ↓                       │
│   [RPE 선택]                    │
│   😊 너무 쉬워요               │
│   😐 적당해요                  │
│   😰 힘들어요                  │
│                                 │
│   [확인]                        │
└─────────────────────────────────┘
```

**트리거**: 첫 세트 완료 후 RPE 선택 화면
**지속**: 사용자가 확인 누를 때까지

---

### 3. Chad 진화 알림

```
┌─────────────────────────────────┐
│  🎉 Chad 진화!                   │
│  ┌───────────────────────────┐  │
│  │                            │  │
│  │  [진화 애니메이션]         │  │
│  │                            │  │
│  │  😴 → 💪                  │  │
│  │                            │  │
│  │  수면모자차드              │  │
│  │  → 기본차드                │  │
│  │                            │  │
│  │  Week 2 완료!              │  │
│  │                            │  │
│  │  다음 진화: Week 4         │  │
│  │  (☕ 커피차드)              │  │
│  │                            │  │
│  └───────────────────────────┘  │
│                                 │
│   [공유하기] [확인]             │
└─────────────────────────────────┘
```

**트리거**: Week 2, 4, 6, 8, 10, 14 완료 시
**지속**: 사용자가 확인 누를 때까지
**애니메이션**: 이전 Chad → 새 Chad (페이드 + 확대)

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
│  │ 다음 운동: 10월 21일 (월)  │  │
│  │                            │  │
│  │ 💡 14주 후면 100개!        │  │
│  │                            │  │
│  └───────────────────────────┘  │
│                                 │
│   [통계 보기] [확인]            │
└─────────────────────────────────┘
```

**트리거**: 첫 운동 (Week 0, Day 1) 완료 후
**지속**: 사용자가 확인 누를 때까지

---

### 5. 캘린더 발견

```
┌─────────────────────────────────┐
│  💡 Tip: 14주 운동 기록          │
│  ┌───────────────────────────┐  │
│  │                            │  │
│  │ 캘린더에서 14주 전체       │  │
│  │ 운동 기록을 볼 수 있어요   │  │
│  │                            │  │
│  │ ✓ 완료일: 초록색           │  │
│  │ ○ 예정일: 회색             │  │
│  │ ⭐ 진화 주: 금색           │  │
│  │                            │  │
│  └───────────────────────────┘  │
│         ↓                       │
│   [캘린더 뷰]                   │
│   Week 0, 2, 4, 6, 8, 10, 14   │
│   표시                          │
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
│  │  진행률: 1/42 완료         │  │
│  │  (14주 × 3일/주 = 42일)   │  │
│  │                            │  │
│  └───────────────────────────┘  │
│                                 │
│   [공유하기] [확인]             │
└─────────────────────────────────┘
```

**트리거**: 업적 달성 시
**지속**: 사용자가 확인 누를 때까지
**애니메이션**: 페이드 인 + 배지 확대

**14주 프로그램 주요 업적**:
- 첫 걸음 (Day 1 완료)
- 첫 주 완료 (Week 0 완료)
- 첫 진화 (Week 2 완료 - 기본차드)
- 중간 지점 (Week 6 완료 - 정면차드)
- 10주 돌파 (Week 10 완료 - 빛나는눈차드)
- 100개 달성! (Week 14 완료 - 더블차드)

---

## 📐 UI/UX 상세 스펙 (14주 버전)

### 색상

```dart
class OnboardingColors {
  static const primary = Color(0xFFE53E3E);        // 빨강 (액션)
  static const secondary = Color(0xFFFFB000);      // 금색 (강조, 진화)
  static const background = Color(0xFFF7FAFC);     // 밝은 회색
  static const text = Color(0xFF2D3748);           // 진한 회색
  static const textSecondary = Color(0xFF718096);  // 중간 회색
  static const success = Color(0xFF51CF66);        // 초록 (완료)
  static const evolutionGold = Color(0xFFFFB000);  // 진화 표시
  static const indicator = Color(0xFFCBD5E0);      // 인디케이터 (비활성)
}
```

### 타이포그래피

```dart
class OnboardingTextStyles {
  // 제목 (큰) - 14주 강조
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

  // 진화 텍스트 (금색)
  static const evolution = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: OnboardingColors.evolutionGold,
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

  // Chad 진화 애니메이션 (2주마다)
  static const evolutionDuration = Duration(milliseconds: 1200);
  static const evolutionScaleCurve = Curves.elasticOut;

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

## ✅ 구현 체크리스트 (14주 버전 - 4개 화면)

### Phase 1: 온보딩 화면 (4개)

- [ ] **Screen 1: Welcome**
  - [ ] UI 레이아웃
  - [ ] "14주 만에" 텍스트 강조
  - [ ] 차드 일러스트 배치
  - [ ] 애니메이션 (페이드 인)
  - [ ] 건너뛰기 기능
  - [ ] 다음 버튼

- [ ] **Screen 2: Science**
  - [ ] UI 레이아웃
  - [ ] 하버드 연구 카드
  - [ ] "14주 점진적 증가" 체크리스트
  - [ ] 자세히 보기 링크
  - [ ] 이전/다음 버튼

- [ ] **Screen 3: Program (14주 프로그램)**
  - [ ] UI 레이아웃
  - [ ] 14주 진행 바
  - [ ] Chad 7단계 진화 미리보기
  - [ ] Week 0, 2, 4, 6, 8, 10, 14 표시
  - [ ] 2주마다 진화 설명
  - [ ] 이전/다음 버튼

- [ ] **Screen 4: Ready**
  - [ ] UI 레이아웃
  - [ ] 기본 레벨 표시 (초급)
  - [ ] 14주 목표일 계산
  - [ ] 첫 운동 정보 (Week 0, Day 1)
  - [ ] Chad 진화 안내 (2주마다)
  - [ ] 설정에서 레벨 변경 안내
  - [ ] 데이터 저장 (SharedPreferences)
  - [ ] 시작 버튼

### Phase 2: 데이터 & 로직 (14주 버전)

- [ ] **데이터 저장 (14주 버전)**
  - [ ] `onboarding_completed` 플래그
  - [ ] `user_level` = beginner (기본값: 초급)
  - [ ] `initial_pushup_count` = 0 (레벨 테스트 없음)
  - [ ] `start_date` 저장
  - [ ] `program_duration_weeks` = 14
  - [ ] `current_week` = 0 (Week 0부터 시작)
  - [ ] `current_day` = 1

- [ ] **레벨 선택 (설정 화면)**
  - [ ] 설정 화면에서 레벨 변경 기능
  - [ ] 초급/중급/고급/전문가 선택
  - [ ] 레벨 변경 시 프로그램 리셋 옵션

### Phase 3: 인앱 튜토리얼 (14주 버전)

- [ ] **첫 운동 전 자세 가이드 (NEW!)**
  - [ ] 푸시업 자세 가이드 화면
  - [ ] 근육 강조 이미지 표시
  - [ ] 핵심 포인트 리스트
  - [ ] 주의사항 안내
  - [ ] [9가지 변형 보기] 링크
  - [ ] Week 0, Day 1 시작 전에만 1회 표시

- [ ] **Feature Discovery**
  - [ ] 첫 운동 (Week 0, Day 1): 세트 기록 Tip
  - [ ] 첫 운동: RPE 선택 Tip (평균 +17.5% 언급)
  - [ ] Chad 진화 알림 (Week 2, 4, 6, 8, 10, 14)
  - [ ] 첫 완료: 축하 메시지 (14주 진행률 표시)
  - [ ] 캘린더: 14주 기록 보기 Tip (진화 주 금색 표시)
  - [ ] 업적: 획득 애니메이션 (14주 진행률)

- [ ] **Tooltip 시스템**
  - [ ] `showFeatureDiscovery()` 헬퍼
  - [ ] 자동 숨김 (5초)
  - [ ] 탭으로 닫기
  - [ ] 1회만 표시 플래그

- [ ] **진화 애니메이션**
  - [ ] Chad 이미지 전환 애니메이션
  - [ ] 진화 축하 화면
  - [ ] 다음 진화까지 주차 표시

### Phase 4: ASSET (14주 버전 - 간소화)

- [x] **온보딩 이미지** (4개 - 완료!)
  - [x] onboarding_1_welcome.png ✅
  - [x] onboarding_2_science.png ✅
  - [x] onboarding_3_program_14weeks.png ✅
  - [x] onboarding_6_ready.png (Screen 4에서 사용) ✅

- [ ] **인앱 튜토리얼 이미지** (선택사항)
  - [ ] pushup_basic_muscles.png (근육 강조 이미지)
  - [ ] 또는 MidJourney로 생성한 PUSHUP_FORM_GUIDE 이미지들 활용

- [x] **Chad 진화 이미지** (7개 - 이미 완료)
  - [x] Week 0, 2, 4, 6, 8, 10, 14 진화 이미지

- [ ] **~~동영상~~ (제거됨)**
  - ~~pushup_form_demo.mp4~~ → 정적 이미지로 대체

### Phase 5: 테스트 (14주 버전)

- [ ] **기능 테스트**
  - [ ] 4개 화면 전환 (Welcome → Science → Program → Ready)
  - [ ] 건너뛰기 기능
  - [ ] 기본 레벨(초급) 적용 확인
  - [ ] 14주 목표일 계산
  - [ ] Week 0부터 시작 확인
  - [ ] 데이터 저장/불러오기
  - [ ] 첫 운동 전 자세 가이드 표시
  - [ ] Tip 표시/숨김
  - [ ] Chad 진화 알림 (Week 2, 4, 6, 8, 10, 14)
  - [ ] 설정에서 레벨 변경

- [ ] **UX 테스트**
  - [ ] 애니메이션 부드러움
  - [ ] 버튼 터치 영역
  - [ ] 14주 진행 바 가독성
  - [ ] 진화 애니메이션 자연스러움
  - [ ] 접근성 (TalkBack, VoiceOver)

---

## 📝 추가 고려사항 (14주 버전 - 간소화)

### 1. 14주 프로그램 특화 기능
- Week 0부터 시작 (0-based indexing)
- 2주마다 진화 알림 (Week 2, 4, 6, 8, 10, 14)
- 평균 +17.5% 점진적 증가 시스템 설명
- 총 42일 운동 (14주 × 3일/주)

### 2. 레벨 시스템 (간소화)
- **온보딩**: 모든 사용자는 초급(Beginner)으로 시작
- **설정에서 변경**: 초급/중급/고급/전문가 선택 가능
- 초급 (Beginner): 0-10개 권장
- 중급 (Intermediate): 11-25개 권장
- 고급 (Advanced): 26-50개 권장
- 전문가 (Expert): 51+개 권장

### 3. 건너뛰기 기능 (간소화)
- 온보딩 모든 화면에 "건너뛰기" 버튼
- 온보딩 건너뛰면 바로 Week 0, Day 1 시작
- ~~주차 건너뛰기 옵션 제거~~ (모두 Week 0부터 시작)

### 4. 언어 지원
- 한국어/영어 모든 텍스트 i18n
- ~~동영상 자막 제거~~ (동영상 없음)

### 5. 접근성
- Screen Reader 지원
- 고대비 모드
- 큰 터치 영역

### 6. 분석 (14주 프로그램)
- 온보딩 완료율 추적
- 각 화면 체류 시간
- 건너뛰기율
- 레벨 변경 빈도 (설정에서)
- 진화 단계별 유지율

---

## 📊 변경사항 요약

### v3.1 (2025-10-20) - 온보딩 간소화

**변경 내용**:
- ✅ 온보딩 화면을 6개 → 4개로 축소
- ✅ 레벨 테스트 제거 (기본값: 초급)
- ✅ 자세 가이드를 인앱 튜토리얼로 이동
- ✅ 필요 이미지 6개 → 4개로 감소
- ✅ 동영상 제작 불필요

**장점**:
1. 🚀 더 빠른 온보딩 (6화면 → 4화면)
2. 🎨 이미지 제작 간소화 (4개만 필요, 이미 완료!)
3. 📹 동영상 제작 불필요
4. 💡 자세 가이드를 실제 필요한 시점에 표시
5. ⚙️ 레벨은 설정에서 자유롭게 변경 가능

**필요한 추가 작업**:
1. 설정 화면에 레벨 선택 기능 추가
2. 첫 운동 시작 시 자세 가이드 팝업 구현
3. 푸시업 근육 강조 이미지 (선택사항)

---

**작성일**: 2025-10-20 (v3.1 - 14주 프로그램 간소화 버전)
**온보딩 화면**: 4개 (Welcome, Science, Program, Ready)
**인앱 튜토리얼**: 7개 (자세 가이드 + 기존 6개)
**프로그램 기간**: 14주 (Week 0-14)
**진화 시스템**: 7단계 (2주마다)
**레벨 시스템**: 4단계 (초급/중급/고급/전문가) - 설정에서 변경
**예상 작업 기간**: 3-4일 (간소화됨!)
