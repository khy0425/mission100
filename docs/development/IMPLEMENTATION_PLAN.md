# 🚀 Mission100 구현 계획서

## 📋 현재 상황 분석

### ✅ 완료된 작업
1. ✅ 과학적 근거 검증 (8개 논문, 2016-2024)
2. ✅ 이미지 데이터 추출 (6주 × 3일 × 3레벨)
3. ✅ 통합 프로그램 설계 (푸시업 + 버피)
4. ✅ 참고문헌 작성 (상세 + 사용자용)

### ⚠️ 문제점 발견
**현재 workout_data.dart의 구조적 문제**:
1. 🔴 `DailyWorkout`이 `burpees + pushups` 단일 횟수만 저장
2. 🔴 `getWorkout()` 메서드가 `[2,3,2,2,3]` 배열에서 `[0]`과 `[1]`만 사용
3. 🔴 5세트 배열 중 3개 무시됨
4. 🔴 세트간 휴식 시간이 레벨별 고정 (90초)
5. 🔴 주차/일차별 휴식 시간 변경 불가

---

## 🎯 구현 목표

### 1. workout_data.dart 재설계
- 푸시업 세트별 횟수 저장
- 버피 피니셔 분리
- 주차/일차별 휴식 시간
- 과학적 근거 기반 데이터

### 2. ASSET 파일 정리
- 차드 진화 이미지 (7단계)
- 튜토리얼 이미지/동영상
- 푸시업 폼 가이드 (9가지)
- 온보딩 플로우 리소스

### 3. 튜토리얼/온보딩 설계
- 초회 사용자 가이드
- 운동 방법 설명
- 과학적 근거 소개
- 레벨 테스트

---

## 📊 Part 1: 새로운 workout_data.dart 설계

### 현재 구조 (❌ 문제)

```dart
class DailyWorkout {
  final int burpees;   // 단일 횟수
  final int pushups;   // 단일 횟수
}

// 사용: [2, 3, 2, 2, 3] → burpees=2, pushups=3 (나머지 무시!)
```

### 새로운 구조 (✅ 해결책)

```dart
/// 피니셔 타입
enum FinisherType {
  burpee,
  mountainClimber,
  jumpSquat,
  none,  // 피니셔 없음 (옵션)
}

/// 일일 운동 프로그램
class DailyWorkout {
  // 푸시업 세션 (메인)
  final List<int> pushupSets;        // [2, 3, 2, 2, 3] - 각 세트 횟수
  final int pushupRestSeconds;       // 60, 90, 120초

  // 피니셔 (서브)
  final FinisherType finisherType;
  final List<int> finisherSets;      // [5, 5] or [8, 8, 8]
  final int finisherRestSeconds;     // 60초

  // 전환 휴식
  final int transitionRestSeconds;   // 120-180초 (푸시업→피니셔)

  const DailyWorkout({
    required this.pushupSets,
    required this.pushupRestSeconds,
    this.finisherType = FinisherType.burpee,
    this.finisherSets = const [],
    this.finisherRestSeconds = 60,
    this.transitionRestSeconds = 120,
  });

  /// 총 푸시업 횟수
  int get totalPushups => pushupSets.fold(0, (sum, reps) => sum + reps);

  /// 총 피니셔 횟수
  int get totalFinisher => finisherSets.fold(0, (sum, reps) => sum + reps);

  /// 푸시업 세트 수
  int get pushupSetCount => pushupSets.length;

  /// 피니셔 세트 수
  int get finisherSetCount => finisherSets.length;

  /// 예상 총 운동 시간 (초)
  int get estimatedDuration {
    // 푸시업 시간: (세트 수 × 휴식) + (총 횟수 × 3초)
    int pushupTime = (pushupSetCount - 1) * pushupRestSeconds + totalPushups * 3;

    // 피니셔 시간: (세트 수 × 휴식) + (총 횟수 × 4초)
    int finisherTime = finisherSetCount > 0
        ? (finisherSetCount - 1) * finisherRestSeconds + totalFinisher * 4
        : 0;

    // 전환 휴식 (피니셔 있을 때만)
    int transition = finisherSetCount > 0 ? transitionRestSeconds : 0;

    return pushupTime + transition + finisherTime;
  }

  /// 예상 총 운동 시간 (분)
  int get estimatedMinutes => (estimatedDuration / 60).ceil();
}
```

### 데이터 예시

#### Week 1, Day 1 - 레벨 1 (5개 이하)
```dart
DailyWorkout(
  pushupSets: [2, 3, 2, 2, 3],           // 5세트, 총 12개
  pushupRestSeconds: 60,                  // Grgic et al. (2018)

  finisherType: FinisherType.burpee,
  finisherSets: [5, 5],                   // 2세트, 총 10개
  finisherRestSeconds: 60,

  transitionRestSeconds: 180,             // 3분 (초보자)
);
```

#### Week 6, Day 3 - 레벨 3 (60개 초과) - 최종일!
```dart
DailyWorkout(
  pushupSets: [26, 26, 33, 33, 26, 26, 22, 22, 60],  // 9세트, 총 274개
  pushupRestSeconds: 45,                  // Week 5-6 단축

  finisherType: FinisherType.burpee,
  finisherSets: [],                       // AMRAP는 별도 처리
  finisherRestSeconds: 0,

  transitionRestSeconds: 120,             // 2분
);
```

---

## 📂 Part 2: 필요한 ASSET 파일

### 현재 보유 ASSET
✅ `assets/images/기본차드.jpg` (1개만 존재)
✅ `assets/images/pushup_forms/` (9가지 변형)
✅ `assets/data/pushup_form_guide.json`
✅ `assets/legal/*.md` (이용약관, 과학적 근거)

### 🎨 필요한 ASSET (우선순위별)

#### 🔴 Priority 1: 필수 (출시 전)

##### 1. 차드 진화 이미지 (7단계) ⭐⭐⭐⭐⭐
**목적**: 주차별 진행 시각화, 동기부여

**필요 파일**:
```
assets/images/chad/
├── chad_week0_rookie.png      # Week 0: 시작 (Rookie Chad)
├── chad_week1_rookie.png      # Week 1: Rookie Chad
├── chad_week2_rising.png      # Week 2: Rising Chad
├── chad_week3_rising.png      # Week 3: Rising Chad
├── chad_week4_alpha.png       # Week 4: Alpha Chad
├── chad_week5_alpha.png       # Week 5: Alpha Chad
└── chad_week6_giga.png        # Week 6: Giga Chad (최종)
```

**이미지 사양**:
- 크기: 512×512px (PNG, 투명 배경)
- 스타일: 밈 스타일 (재미있고 과장된)
- 진화 단계가 명확히 보이도록
- 각 단계마다 근육 발달, 자세 변화

**디자인 아이디어**:
- Week 0: 앉아서 침대에 누운 차드
- Week 1: 일어나서 스트레칭하는 차드
- Week 2: 가벼운 푸시업 자세
- Week 3: 땀 흘리며 운동 중
- Week 4: 근육 생기기 시작
- Week 5: 자신감 넘치는 포즈
- Week 6: 💪 슈퍼 차드 (금빛 오라)

---

##### 2. 앱 아이콘 ⭐⭐⭐⭐⭐
**목적**: 앱 스토어, 홈 화면

**필요 파일**:
```
assets/icon/
└── mission100_icon.png        # 1024×1024px (마스터)
```

**디자인 요소**:
- "100" 숫자 강조
- 푸시업 실루엣 or 차드 얼굴
- 브랜드 컬러 (빨강, 금색)
- 단순하고 임팩트 있게

**플랫폼별 자동 생성**:
- flutter_launcher_icons 패키지 사용
- iOS: 512×512, 1024×1024
- Android: hdpi, xhdpi, xxhdpi, xxxhdpi
- Web: favicon

---

##### 3. 스크린샷 (스토어용) ⭐⭐⭐⭐⭐
**목적**: Google Play, App Store

**필요 파일**:
```
store_metadata/screenshots/
├── android/
│   └── phone/
│       ├── ko/
│       │   ├── 01_hero.png            # 1080×1920
│       │   ├── 02_workout.png
│       │   ├── 03_progress.png
│       │   ├── 04_calendar.png
│       │   ├── 05_achievements.png
│       │   ├── 06_chad_evolution.png
│       │   ├── 07_scientific.png
│       │   └── 08_darkmode.png
│       └── en/ (same as ko)
└── ios/
    └── iphone_6_7/
        ├── ko/ (1290×2796)
        └── en/
```

**내용** (상세는 [SCREENSHOT_REQUIREMENTS.md](E:/Projects/mission100_v3/store_metadata/SCREENSHOT_REQUIREMENTS.md) 참조):
1. 히어로: "6주 만에 100개 달성!"
2. 운동: 실시간 세트 추적
3. 진행: 차트와 통계
4. 캘린더: 운동 기록
5. 업적: 50+ 달성 시스템
6. 진화: 7단계 차드
7. 과학: "하버드 연구 검증"
8. 다크모드

---

#### 🟡 Priority 2: 중요 (출시 후 빠르게)

##### 4. 튜토리얼 이미지/동영상 ⭐⭐⭐⭐
**목적**: 초회 사용자 온보딩

**필요 파일**:
```
assets/tutorial/
├── onboarding_1_welcome.png       # 환영 화면
├── onboarding_2_science.png       # 과학적 근거
├── onboarding_3_program.png       # 프로그램 소개
├── onboarding_4_level_test.png    # 레벨 테스트
├── pushup_form_demo.mp4           # 올바른 자세 (15초)
├── burpee_form_demo.mp4           # 버피 자세 (10초)
└── app_guide.json                 # 인터랙티브 가이드
```

**이미지 사양**: 1080×1920px (PNG)
**동영상 사양**: 720p, 15fps, MP4

---

##### 5. 푸시업 변형 가이드 이미지 개선 ⭐⭐⭐
**목적**: 9가지 변형 명확한 시각화

**현재**:
```
assets/images/pushup_forms/
├── standard/      # 표준
├── knee/          # 무릎
├── incline/       # 인클라인
├── wide/          # 와이드
├── diamond/       # 다이아몬드
├── decline/       # 디클라인
├── archer/        # 아처
├── pike/          # 파이크
└── clap/          # 박수
```

**개선 필요**:
- 각 변형마다 3단계 이미지 (시작-중간-끝)
- 화살표로 동작 방향 표시
- 주의사항 텍스트 오버레이
- 통일된 배경, 각도, 조명

---

##### 6. 동기부여 이미지 ⭐⭐⭐
**목적**: 운동 중 동기부여

**필요 파일**:
```
assets/images/motivation/
├── workout_start.png          # "Let's Go!"
├── set_complete.png           # "Nice!"
├── halfway.png                # "절반 완료!"
├── almost_done.png            # "거의 다 왔어!"
├── workout_complete.png       # "완료!"
└── new_record.png             # "신기록!"
```

---

#### 🟢 Priority 3: 선택 (추후 업데이트)

##### 7. 프로모션 비디오 ⭐⭐
**목적**: 스토어 홍보

- 15-30초 길이
- 핵심 기능 3가지 강조
- 차드 진화 애니메이션
- BGM + 자막

##### 8. 배지/스티커 ⭐⭐
**목적**: 공유 기능

```
assets/images/badges/
├── badge_week1.png
├── badge_week2.png
├── ...
├── badge_100_achieved.png
└── sticker_giga_chad.png
```

##### 9. 로딩 애니메이션 ⭐
```
assets/animations/
└── loading_pushup.json        # Lottie 애니메이션
```

---

## 🎓 Part 3: 튜토리얼/온보딩 설계

### 온보딩 플로우 (초회 실행 시)

#### Screen 1: 환영 (Welcome)
```
┌─────────────────────────────────┐
│                                 │
│     💪 Mission100               │
│                                 │
│   6주 만에 푸시업 100개 달성!   │
│                                 │
│   [차드 이미지]                 │
│                                 │
│   초보자도 가능합니다!          │
│                                 │
│   [시작하기] ───────────>       │
│   [건너뛰기]                    │
└─────────────────────────────────┘
```

**ASSET**: `onboarding_1_welcome.png`

---

#### Screen 2: 과학적 근거 (Science)
```
┌─────────────────────────────────┐
│   🔬 과학적으로 검증됨           │
│                                 │
│   [하버드 로고]                 │
│                                 │
│   "40개 이상 푸시업              │
│    → 심혈관 질환 96% 감소"      │
│   - Harvard Study (2019)        │
│                                 │
│   ✅ 8개 연구 논문 기반         │
│   ✅ 2016-2024 최신 연구        │
│                                 │
│   [다음] ───────────>           │
└─────────────────────────────────┘
```

**ASSET**: `onboarding_2_science.png`

---

#### Screen 3: 프로그램 소개 (Program)
```
┌─────────────────────────────────┐
│   📅 6주 프로그램                │
│                                 │
│   주 3회 (월/수/금) 운동        │
│   화/목/토/일 휴식              │
│                                 │
│   [Week 1-6 진행 바]            │
│                                 │
│   Week 1  😊 적응기              │
│   Week 2  💪 강화기              │
│   Week 3  🔥 도전기              │
│   Week 4  ⚡ 가속기              │
│   Week 5  🚀 최고조              │
│   Week 6  🏆 100개 달성!         │
│                                 │
│   [다음] ───────────>           │
└─────────────────────────────────┘
```

**ASSET**: `onboarding_3_program.png`

---

#### Screen 4: 레벨 테스트 (Level Test)
```
┌─────────────────────────────────┐
│   🎯 당신의 레벨은?              │
│                                 │
│   현재 최대 푸시업 개수를        │
│   측정해주세요                   │
│                                 │
│   [푸시업 시작]                 │
│                                 │
│   카운터: [   0   ]             │
│   [+1] [+5] [+10]               │
│                                 │
│   또는 직접 입력:               │
│   [____개]                      │
│                                 │
│   [완료] ───────────>           │
└─────────────────────────────────┘
```

**ASSET**: `onboarding_4_level_test.png`

**로직**:
- 0-5개 → 레벨 1 (5개 이하)
- 6-10개 → 레벨 2 (6-10개)
- 11-20개 → 레벨 3 (11-20개)
- 21+개 → 레벨 3 (높은 목표)

---

#### Screen 5: 푸시업 폼 가이드 (Form Guide)
```
┌─────────────────────────────────┐
│   ✅ 올바른 푸시업 자세          │
│                                 │
│   [동영상 또는 GIF]             │
│   ▶ 재생                        │
│                                 │
│   핵심 포인트:                  │
│   ✓ 어깨 너비로 손               │
│   ✓ 몸 일직선 유지               │
│   ✓ 가슴이 바닥 가까이           │
│   ✓ 팔꿈치 45도 각도             │
│                                 │
│   [다음] ───────────>           │
│   [건너뛰기]                    │
└─────────────────────────────────┘
```

**ASSET**: `pushup_form_demo.mp4` (15초)

---

#### Screen 6: 시작 준비 완료 (Ready)
```
┌─────────────────────────────────┐
│   🎉 준비 완료!                  │
│                                 │
│   [차드 이미지 - 준비 자세]     │
│                                 │
│   선택된 레벨: 레벨 2           │
│   시작일: 2025-10-03            │
│   목표: Week 6 (2025-11-14)     │
│                                 │
│   첫 운동: Week 1, Day 1        │
│   푸시업 5세트 (총 ~25개)       │
│   버피 2세트 (총 12개)          │
│   예상 시간: 12분               │
│                                 │
│   [운동 시작하기!] ─────>       │
└─────────────────────────────────┘
```

---

### 인앱 튜토리얼 (Feature Discovery)

#### 첫 운동 세션 시
```
┌─────────────────────────────────┐
│  💡 Tip                         │
│  ┌───────────────────────────┐  │
│  │ 세트 완료 후               │  │
│  │ RPE를 선택하세요          │  │
│  │ (운동 강도 피드백)        │  │
│  └───────────────────────────┘  │
│         ↓                       │
│   [RPE 선택 버튼]               │
└─────────────────────────────────┘
```

#### 첫 완료 시
```
┌─────────────────────────────────┐
│  🎉 첫 운동 완료!                │
│                                 │
│  이제 진행 상황 탭에서          │
│  통계를 확인할 수 있어요!       │
│                                 │
│  [확인]                         │
└─────────────────────────────────┘
```

---

## 🗂️ Part 4: 파일 구조 제안

### 최종 프로젝트 구조
```
mission100_v3/
├── lib/
│   ├── models/
│   │   └── workout_session.dart      # 수정 필요
│   ├── services/
│   │   ├── workout_program_service.dart  # 수정 필요
│   │   └── onboarding_service.dart   # 🆕 신규
│   ├── screens/
│   │   ├── onboarding/               # 🆕 신규
│   │   │   ├── welcome_screen.dart
│   │   │   ├── science_screen.dart
│   │   │   ├── program_screen.dart
│   │   │   ├── level_test_screen.dart
│   │   │   ├── form_guide_screen.dart
│   │   │   └── ready_screen.dart
│   │   └── workout_screen.dart       # 수정 필요
│   └── utils/
│       └── workout_data.dart         # 🔴 전체 재작성
│
├── assets/
│   ├── icon/
│   │   └── mission100_icon.png       # 🆕 필요
│   ├── images/
│   │   ├── chad/                     # 🆕 필요 (7개)
│   │   ├── motivation/               # 🆕 필요 (6개)
│   │   └── pushup_forms/             # ✅ 개선 필요
│   ├── tutorial/                     # 🆕 필요
│   │   ├── onboarding_*.png
│   │   └── *_demo.mp4
│   ├── data/
│   │   ├── pushup_form_guide.json    # ✅ 존재
│   │   └── tutorial_guide.json       # 🆕 필요
│   └── legal/
│       ├── scientific_evidence_ko.md # ✅ 존재
│       └── scientific_evidence_en.md # ✅ 존재
│
├── store_metadata/                   # ✅ 존재
│   ├── screenshots/                  # 🆕 필요 (16개)
│   ├── google_play_ko.md             # ✅ 존재
│   ├── google_play_en.md             # ✅ 존재
│   └── app_store_ios.md              # ✅ 존재
│
└── docs/
    ├── 운동/
    │   ├── WORKOUT_PLAN_EXTRACTED.md # ✅ 존재
    │   ├── INTEGRATED_PUSHUP_BURPEE_PROGRAM.md  # ✅ 존재
    │   └── SCIENTIFIC_EVIDENCE_REVIEW.md        # ✅ 존재
    ├── SCIENTIFIC_REFERENCES.md      # ✅ 존재
    └── IMPLEMENTATION_PLAN.md        # 📄 이 문서
```

---

## 📝 Part 5: ASSET 제작 가이드

### 차드 이미지 제작 방법

#### 옵션 1: AI 생성 (추천)
- **도구**: DALL-E 3, Midjourney, Stable Diffusion
- **프롬프트 예시**:
  ```
  "Muscular chad meme character doing push-ups,
  progression from weak to strong,
  7 stages, cartoon style, white background,
  funny and motivational"
  ```

#### 옵션 2: 직접 제작
- Figma, Illustrator, Photoshop
- 밈 스타일 참고
- 단순화된 선, 과장된 표현

#### 옵션 3: 외주
- Fiverr, Upwork
- "Chad meme character evolution" 검색
- 예산: $50-200

---

### 스크린샷 제작 방법

#### 도구
- **Screenshot Maker**: https://screenshots.pro
- **Figma**: 목업 제작
- **Device Frame**: https://mockuphone.com

#### 프로세스
1. 실제 앱 스크린샷 캡처 (Android/iOS)
2. Device Frame에 삽입
3. 텍스트 오버레이 추가
4. 배경 그라데이션 적용
5. 저장: PNG, 최고 품질

---

### 동영상 제작 방법

#### 푸시업 폼 데모 (15초)
1. **촬영**:
   - 스마트폰 (1080p)
   - 삼각대 고정
   - 측면 각도
   - 밝은 조명

2. **편집**:
   - CapCut, iMovie, DaVinci Resolve
   - 슬로우 모션 (주요 포인트)
   - 화살표/텍스트 오버레이
   - BGM 없음 (또는 조용한 음악)

3. **내보내기**:
   - 720p, 30fps, MP4
   - H.264 코덱
   - 파일 크기 < 5MB

---

## 🚀 Part 6: 구현 로드맵

### Phase 1: 데이터 구조 (3-5일) 🔴
- [ ] `workout_data.dart` 재작성
- [ ] `DailyWorkout` 클래스 수정
- [ ] 54개 세션 데이터 입력
- [ ] 단위 테스트 작성
- [ ] 기존 서비스 연동 테스트

### Phase 2: ASSET 제작 (5-7일) 🟡
- [ ] 차드 이미지 7개 (AI 생성 or 외주)
- [ ] 앱 아이콘 1개
- [ ] 튜토리얼 이미지 6개
- [ ] 푸시업 폼 동영상 1개
- [ ] 버피 폼 동영상 1개

### Phase 3: 온보딩 구현 (3-5일) 🟢
- [ ] 온보딩 화면 6개 구현
- [ ] 레벨 테스트 로직
- [ ] SharedPreferences 저장
- [ ] 건너뛰기 기능

### Phase 4: UI 업데이트 (5-7일) 🔵
- [ ] 운동 화면 수정 (세트별 표시)
- [ ] 전환 휴식 화면 추가
- [ ] 피니셔 선택 화면
- [ ] 차드 진화 표시
- [ ] 과학적 근거 화면

### Phase 5: 스크린샷 & 스토어 (2-3일) 🟣
- [ ] 스크린샷 16개 제작
- [ ] Google Play Console 업로드
- [ ] App Store Connect 업로드
- [ ] 스토어 설명 업데이트

### Phase 6: 테스트 & QA (3-5일) ⚪
- [ ] 전체 플로우 테스트
- [ ] 버그 수정
- [ ] 성능 최적화
- [ ] 베타 테스터 피드백

**총 예상 기간**: 21-32일 (3-4.5주)

---

## 💰 예산 산정 (외주 시)

| 항목 | 수량 | 단가 | 총액 |
|------|------|------|------|
| 차드 이미지 | 7개 | $20 | $140 |
| 앱 아이콘 | 1개 | $50 | $50 |
| 튜토리얼 이미지 | 6개 | $15 | $90 |
| 동영상 촬영/편집 | 2개 | $100 | $200 |
| 스크린샷 디자인 | 8개 | $10 | $80 |
| **총 예산** | | | **$560** |

**자체 제작 시**: $0 (AI 생성 무료 도구 활용)

---

## 🎯 우선순위 권장

### 즉시 시작 (이번 주)
1. 🔴 workout_data.dart 재작성
2. 🔴 차드 이미지 7개 (AI 생성)
3. 🔴 앱 아이콘 1개

### 다음 주
4. 🟡 온보딩 구현
5. 🟡 튜토리얼 이미지 제작
6. 🟡 UI 업데이트

### 출시 전 (마지막 주)
7. 🟢 스크린샷 제작
8. 🟢 스토어 업로드
9. 🟢 QA 및 테스트

---

## 📞 다음 단계

어떤 부분부터 시작할까요?

1. **workout_data.dart 재작성**부터 시작
2. **ASSET 제작** (차드 이미지 먼저)
3. **온보딩 설계** 상세화
4. **전체 논의** 더 진행

---

**작성일**: 2025-10-03
**예상 작업 기간**: 3-4.5주
**총 ASSET 파일**: 약 40-50개
**예산**: $0-560 (자체 제작 vs 외주)
