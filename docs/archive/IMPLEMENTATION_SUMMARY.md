# 🎯 Mission100 통합 프로그램 구현 요약

## 📋 완료된 작업

### 1. ✅ 이미지 데이터 추출
- **파일**: [WORKOUT_PLAN_EXTRACTED.md](WORKOUT_PLAN_EXTRACTED.md)
- 6주 × 3일 × 3레벨 = 54개 세션 정확히 추출
- 세트별 횟수, 휴식 시간, 진행 패턴 분석

### 2. ✅ 앱 코드 비교 분석
- **파일**: [DATA_COMPARISON_REPORT.md](DATA_COMPARISON_REPORT.md)
- 버피+푸시업 혼합 vs 푸시업 단독 불일치 발견
- 데이터 파싱 로직 오류 발견
- 수정 필요 사항 정리

### 3. ✅ 통합 프로그램 설계
- **파일**: [INTEGRATED_PUSHUP_BURPEE_PROGRAM.md](INTEGRATED_PUSHUP_BURPEE_PROGRAM.md)
- 푸시업 메인 + 버피 피니셔 구조
- 6주 체계적 진행
- 다양성 추가 (마운틴 클라이머, 점프 스쿼트)

---

## 🎨 최종 프로그램 설계

### 핵심 철학
```
Mission100 = 푸시업 100개 달성 (메인 목표)
            + 버피 피니셔 (전신·심폐 강화)
            + 점진적 과부하 (6주)
```

### 운동 구조
```
┌─────────────────────────────────────────────┐
│  1. 푸시업 세션 (5-9세트)                     │
│     - Week 1-4: 5세트                        │
│     - Week 5-6: 8-9세트                      │
│     - 세트간 휴식: 45-120초                   │
│     - 최종 목표: 100개 연속                   │
├─────────────────────────────────────────────┤
│  2. 전환 휴식 (2-3분)                        │
│     - 심박수 회복                            │
│     - 상체 근육 회복                         │
│     - 수분 섭취                              │
├─────────────────────────────────────────────┤
│  3. 피니셔 (2-3세트)                         │
│     DAY 1: 버피                              │
│     DAY 2: 마운틴 클라이머 (옵션)            │
│     DAY 3: 점프 스쿼트 (옵션)               │
│     - Week 1-2: 10-16개                      │
│     - Week 3-4: 24-36개                      │
│     - Week 5-6: 36-60개 or AMRAP             │
└─────────────────────────────────────────────┘
```

### 버피 진행 전략

| 주차 | 세트 구성 | 휴식 | 목적 |
|------|----------|------|------|
| Week 1-2 | 5-8회 × 2세트 | 60초 | 동작 익히기 + 심폐 적응 |
| Week 3-4 | 8-12회 × 3세트 | 60초 | 칼로리 소모 + 지구력 향상 |
| Week 5 | 12-15회 × 3세트 | 45초 | 근력 + 전신 폭발력 |
| Week 6 | 15-20회 × 3세트 or AMRAP | 45초 | 최대치 도전 |

---

## 💻 앱 구현 데이터 구조

### 현재 문제점
```dart
// ❌ 현재 (잘못됨)
class DailyWorkout {
  final int burpees;   // 단일 횟수
  final int pushups;   // 단일 횟수
}

// 파싱: [2, 3, 2, 2, 3] → burpees=2, pushups=3 (나머지 무시!)
```

### 올바른 구조 (권장)
```dart
/// 운동 종목
enum ExerciseType {
  pushup,
  burpee,
  mountainClimber,
  jumpSquat,
}

/// 개별 세트
class ExerciseSet {
  final ExerciseType type;
  final int reps;           // 반복 횟수
  final int? duration;      // 시간 기반 운동 (초)

  const ExerciseSet({
    required this.type,
    required this.reps,
    this.duration,
  });
}

/// 일일 운동 프로그램
class DailyWorkout {
  // 메인 운동 (푸시업)
  final List<ExerciseSet> mainExercise;
  final int mainRestSeconds;

  // 피니셔 (버피 등)
  final FinisherType finisherType;
  final List<ExerciseSet> finisherSets;
  final int finisherRestSeconds;

  // 전환 휴식
  final int transitionRestSeconds;  // 기본 120-180초

  const DailyWorkout({
    required this.mainExercise,
    required this.mainRestSeconds,
    required this.finisherType,
    required this.finisherSets,
    required this.finisherRestSeconds,
    this.transitionRestSeconds = 120,
  });

  /// 총 푸시업 횟수
  int get totalPushups => mainExercise
      .where((s) => s.type == ExerciseType.pushup)
      .fold(0, (sum, s) => sum + s.reps);

  /// 총 피니셔 횟수
  int get totalFinisher => finisherSets.fold(0, (sum, s) => sum + s.reps);

  /// 예상 총 운동 시간 (분)
  int get estimatedTimeMinutes {
    int pushupTime = mainExercise.length * mainRestSeconds;
    int finisherTime = finisherSets.length * finisherRestSeconds;
    int exerciseTime = (totalPushups + totalFinisher) * 3; // 1회당 3초 가정
    return ((pushupTime + transitionRestSeconds + finisherTime + exerciseTime) / 60).ceil();
  }
}

/// 피니셔 종류
enum FinisherType {
  burpee,
  mountainClimber,
  jumpSquat,
  amrap,   // As Many Reps As Possible
  tabata,  // 20s work / 10s rest
  none,    // 피니셔 없음 (옵션)
}

/// AMRAP 설정
class AMRAPConfig {
  final int durationSeconds;  // 120-180초
  final ExerciseType type;

  const AMRAPConfig({
    required this.durationSeconds,
    required this.type,
  });
}

/// Tabata 설정
class TabataConfig {
  final int workSeconds;      // 기본 20초
  final int restSeconds;      // 기본 10초
  final int rounds;           // 기본 8라운드
  final ExerciseType type;

  const TabataConfig({
    required this.type,
    this.workSeconds = 20,
    this.restSeconds = 10,
    this.rounds = 8,
  });
}
```

---

## 📊 데이터 예시

### Week 1, Day 1 (레벨 1: 5개 이하)

```dart
final week1Day1Level1 = DailyWorkout(
  mainExercise: [
    ExerciseSet(type: ExerciseType.pushup, reps: 2),
    ExerciseSet(type: ExerciseType.pushup, reps: 3),
    ExerciseSet(type: ExerciseType.pushup, reps: 2),
    ExerciseSet(type: ExerciseType.pushup, reps: 2),
    ExerciseSet(type: ExerciseType.pushup, reps: 3), // 3+ (최대한)
  ],
  mainRestSeconds: 60,

  finisherType: FinisherType.burpee,
  finisherSets: [
    ExerciseSet(type: ExerciseType.burpee, reps: 5),
    ExerciseSet(type: ExerciseType.burpee, reps: 5),
  ],
  finisherRestSeconds: 60,

  transitionRestSeconds: 180, // 3분
);

// 총 푸시업: 12개
// 총 버피: 10개
// 예상 시간: ~10분
```

### Week 6, Day 3 (레벨 3: 60개 초과) - 최종일!

```dart
final week6Day3Level3 = DailyWorkout(
  mainExercise: [
    ExerciseSet(type: ExerciseType.pushup, reps: 26),
    ExerciseSet(type: ExerciseType.pushup, reps: 26),
    ExerciseSet(type: ExerciseType.pushup, reps: 33),
    ExerciseSet(type: ExerciseType.pushup, reps: 33),
    ExerciseSet(type: ExerciseType.pushup, reps: 26),
    ExerciseSet(type: ExerciseType.pushup, reps: 26),
    ExerciseSet(type: ExerciseType.pushup, reps: 22),
    ExerciseSet(type: ExerciseType.pushup, reps: 22),
    ExerciseSet(type: ExerciseType.pushup, reps: 60), // 60+ 최대한!
  ],
  mainRestSeconds: 45,

  finisherType: FinisherType.amrap,
  finisherSets: [], // AMRAP는 세트 미리 정의 안 함
  finisherRestSeconds: 0,

  transitionRestSeconds: 120, // 2분
);

// 총 푸시업: ~274개
// AMRAP 버피: 3분 최대 반복
// 예상 시간: ~20분
```

---

## 🎨 UI 플로우

### 1. 운동 시작 화면
```
┌─────────────────────────────────┐
│  Mission100 - Week 3, Day 1     │
│  ─────────────────────────────  │
│  📊 오늘의 목표                  │
│  • 푸시업: 5세트 (~45개)         │
│  • 버피 피니셔: 24개             │
│  • 예상 시간: 15분               │
│                                 │
│  [운동 시작하기] 버튼            │
└─────────────────────────────────┘
```

### 2. 푸시업 세션 (진행 중)
```
┌─────────────────────────────────┐
│  푸시업 세트 2/5                 │
│  ─────────────────────────────  │
│  🎯 목표: 12개                   │
│                                 │
│     [   12   ]                  │
│                                 │
│  [ - ]    [ 완료 ]    [ + ]     │
│                                 │
│  ✅ SET 1: 10개 완료             │
│  🔥 현재: SET 2                  │
│  ⏳ 남은 세트: 3개               │
└─────────────────────────────────┘
```

### 3. 전환 휴식 화면
```
┌─────────────────────────────────┐
│  🎉 푸시업 완료!                 │
│  ─────────────────────────────  │
│  완료: 47개 / 목표: 45개         │
│                                 │
│  💪 피니셔 준비 중...            │
│                                 │
│     02:35                       │
│  ═════════════════              │
│                                 │
│  • 물 마시기 💧                 │
│  • 심호흡하기 🌬️                │
│  • 근육 이완하기 🧘              │
│                                 │
│  [피니셔 건너뛰기] [지금 시작]   │
└─────────────────────────────────┘
```

### 4. 피니셔 선택 화면 (옵션)
```
┌─────────────────────────────────┐
│  오늘의 피니셔를 선택하세요      │
│  ─────────────────────────────  │
│                                 │
│  ┌─────────────────────┐        │
│  │  🔥 버피             │        │
│  │  8개 × 3세트         │  ◀︎ 추천│
│  └─────────────────────┘        │
│                                 │
│  ┌─────────────────────┐        │
│  │  🏔️ 마운틴 클라이머  │        │
│  │  30초 × 3세트        │        │
│  └─────────────────────┘        │
│                                 │
│  ┌─────────────────────┐        │
│  │  🦵 점프 스쿼트       │        │
│  │  12개 × 3세트        │        │
│  └─────────────────────┘        │
│                                 │
│  [선택 안 함]                   │
└─────────────────────────────────┘
```

### 5. 버피 세션 (진행 중)
```
┌─────────────────────────────────┐
│  버피 세트 2/3                   │
│  ─────────────────────────────  │
│  🎯 목표: 8개                    │
│                                 │
│     [    8   ]                  │
│                                 │
│  [ - ]    [ 완료 ]    [ + ]     │
│                                 │
│  다음 세트까지 휴식: 00:52       │
└─────────────────────────────────┘
```

### 6. 완료 화면
```
┌─────────────────────────────────┐
│  🏆 Mission100 완료!             │
│  ─────────────────────────────  │
│  Week 3, Day 1 완료              │
│                                 │
│  💪 푸시업: 47개                 │
│  🔥 버피: 24개                   │
│  ⏱️ 총 시간: 16분 32초           │
│                                 │
│  📈 진행률: 33% (6/18일)         │
│                                 │
│  "만삣삐! 오늘도 찢었다!"        │
│                                 │
│  [RPE 기록] [공유하기] [완료]    │
└─────────────────────────────────┘
```

---

## 🚀 구현 우선순위

### Phase 1: 데이터 구조 수정 🔴 (1-2일)
1. `workout_data.dart` 전체 재작성
2. 새 데이터 모델 적용
3. 54개 세션 데이터 입력
4. 단위 테스트 작성

### Phase 2: UI 업데이트 🟡 (2-3일)
1. 운동 시작 화면 수정
2. 전환 휴식 화면 추가
3. 피니셔 선택 화면 추가
4. 완료 화면 통계 업데이트

### Phase 3: 피니셔 로직 구현 🟢 (2-3일)
1. 버피 세션 구현
2. 마운틴 클라이머 구현
3. 점프 스쿼트 구현
4. AMRAP 타이머 구현
5. Tabata 타이머 구현

### Phase 4: 테스트 및 QA 🔵 (1-2일)
1. 전체 플로우 테스트
2. 데이터 무결성 검증
3. 사용자 피드백 수집
4. 버그 수정

---

## 📝 다음 단계

### 즉시 조치 필요
1. **workout_data.dart 재작성**
   - 새 데이터 구조 적용
   - 54개 세션 정확한 데이터 입력
   - 버피 피니셔 데이터 추가

2. **workout_program_service.dart 수정**
   - 파싱 로직 업데이트
   - 피니셔 처리 로직 추가

3. **UI 화면 업데이트**
   - workout_screen.dart 수정
   - 전환 휴식 화면 추가
   - 피니셔 화면 추가

### 장기 개선
- 피니셔 선택 기능 (사용자가 DAY별로 다르게 선택)
- AMRAP 기록 추적
- 피니셔 통계 별도 표시
- 커뮤니티 챌린지 (버피 AMRAP 랭킹)

---

## 📚 참고 문서

- ✅ [WORKOUT_PLAN_EXTRACTED.md](WORKOUT_PLAN_EXTRACTED.md) - 이미지에서 추출한 원본 데이터
- ✅ [DATA_COMPARISON_REPORT.md](DATA_COMPARISON_REPORT.md) - 현재 코드 vs 이미지 비교
- ✅ [INTEGRATED_PUSHUP_BURPEE_PROGRAM.md](INTEGRATED_PUSHUP_BURPEE_PROGRAM.md) - 통합 프로그램 전체
- 🔄 `workout_data_new.dart` - 새로운 구현 (작성 예정)

---

**작성일**: 2025-10-03
**상태**: 설계 완료, 구현 대기
**예상 작업 시간**: 6-10일
