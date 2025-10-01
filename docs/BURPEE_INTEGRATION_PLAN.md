# 버피 운동 통합 계획

## 📋 개요

Mission: 100에 버피 운동을 추가하여 더욱 다양하고 효과적인 전신 운동 프로그램을 제공합니다.

## 🎯 버피 운동의 장점

### 운동 효과
- **전신 운동**: 상체, 하체, 코어 모두 단련
- **고강도 유산소**: 푸시업 대비 2-3배 칼로리 소모
- **시간 효율성**: 짧은 시간에 높은 운동 효과
- **장비 불필요**: 맨몸으로 어디서든 가능

### 목표별 적합성
- **체중감량**: ⭐⭐⭐⭐⭐ (최고 효과)
- **체력향상**: ⭐⭐⭐⭐⭐ (심폐지구력 향상)
- **근육증가**: ⭐⭐⭐ (전신 근력)
- **전반적 건강**: ⭐⭐⭐⭐ (종합 운동)

## 🔧 기술적 구현 방안

### Phase 1: 기본 구조 확장

#### 1.1 운동 타입 시스템 구축
```dart
enum ExerciseType {
  pushup('푸시업'),
  burpee('버피'),
  pushupDiamond('다이아몬드 푸시업'),
  pushupWide('와이드 푸시업'),
  pushupIncline('인클라인 푸시업');

  const ExerciseType(this.displayName);
  final String displayName;
}

class Exercise {
  final ExerciseType type;
  final int targetReps;
  final Duration restBetweenSets;
  final String instruction;
  final String? demonstrationVideoUrl;
  final double caloriesPerRep; // 체중 1kg당 칼로리
  final Difficulty difficulty;
}
```

#### 1.2 운동 세션 모델 확장
```dart
class WorkoutSession {
  // 기존 필드들...

  // 새로 추가할 필드들
  final List<ExerciseSet> exerciseSets; // 여러 운동 타입 지원
  final double totalCaloriesBurned;
  final Duration totalWorkoutTime;
  final Map<ExerciseType, int> exerciseBreakdown; // 운동별 개수
}

class ExerciseSet {
  final ExerciseType type;
  final List<int> repsPerSet;
  final Duration totalSetTime;
  final bool isCompleted;
}
```

### Phase 2: 버피 운동 구현

#### 2.1 버피 운동 정의
```dart
class BurpeeExercise {
  static const Exercise standard = Exercise(
    type: ExerciseType.burpee,
    targetReps: 10, // 기본값
    restBetweenSets: Duration(seconds: 90),
    instruction: '''
1. 스쿼트 자세로 앉기
2. 바닥에 손 대고 다리 뒤로 뻗기
3. 푸시업 1회 실시
4. 다리를 가슴쪽으로 당기기
5. 점프하며 손 위로 올리기
''',
    caloriesPerRep: 0.5, // 체중 1kg당 0.5칼로리
    difficulty: Difficulty.intermediate,
  );
}
```

#### 2.2 버피 카운터 시스템
```dart
class BurpeeCounter {
  // 자세 단계별 감지
  enum BurpeePhase {
    starting,     // 시작 자세
    squatDown,    // 스쿼트 다운
    plankOut,     // 플랭크 자세
    pushupDown,   // 푸시업 다운
    pushupUp,     // 푸시업 업
    plankIn,      // 다리 당기기
    jumpUp,       // 점프 업
    completed     // 완료
  }

  BurpeePhase currentPhase = BurpeePhase.starting;
  int completedReps = 0;

  void detectPhaseChange(SensorData data) {
    // 가속도계/자이로스코프 데이터 기반 자세 인식
    // 또는 수동 탭 기반 카운팅
  }
}
```

### Phase 3: 프로그램 통합

#### 3.1 주차별 버피 도입 전략

| 주차 | 푸시업 비율 | 버피 비율 | 도입 이유 |
|------|-------------|-----------|-----------|
| **1-2주차** | 100% | 0% | 기초 체력 다지기, 푸시업 적응 |
| **3주차** | 80% | 20% | 버피 도입, 전신 운동 시작 |
| **4주차** | 70% | 30% | 강도 증가, 심폐지구력 향상 |
| **5주차** | 60% | 40% | 고강도 인터벌 트레이닝 |
| **6주차** | 50% | 50% | 최고 난이도, 종합 운동 |

#### 3.2 목표별 운동 구성

##### 🔥 체중감량 목표
```dart
WeeklyPlan generateWeightLossPlan(int week, FitnessLevel level) {
  if (week <= 2) {
    return PushupOnlyPlan(week, level);
  }

  // 3주차부터 버피 적극 도입
  double burpeeRatio = math.min(0.6, (week - 2) * 0.15);
  return MixedWorkoutPlan(
    pushupRatio: 1 - burpeeRatio,
    burpeeRatio: burpeeRatio,
    intensityMultiplier: 1.2, // 체중감량은 고강도
  );
}
```

##### 💪 근육증가 목표
```dart
WeeklyPlan generateMuscleGainPlan(int week, FitnessLevel level) {
  // 근육증가는 푸시업 중심, 버피는 보조
  double burpeeRatio = week >= 4 ? 0.2 : 0.0;
  return MixedWorkoutPlan(
    pushupRatio: 1 - burpeeRatio,
    burpeeRatio: burpeeRatio,
    restMultiplier: 1.3, // 근육 회복을 위한 충분한 휴식
  );
}
```

##### ⚡ 체력향상 목표
```dart
WeeklyPlan generateEndurancePlan(int week, FitnessLevel level) {
  // 체력향상은 균형잡힌 구성
  double burpeeRatio = week >= 3 ? 0.5 : 0.0;
  return MixedWorkoutPlan(
    pushupRatio: 1 - burpeeRatio,
    burpeeRatio: burpeeRatio,
    intervalTraining: true, // 인터벌 트레이닝 적용
  );
}
```

#### 3.3 난이도 조정 시스템

```dart
class DifficultyAdjuster {
  static WorkoutSet adjustForLevel(WorkoutSet baseSet, FitnessLevel level) {
    switch (level) {
      case FitnessLevel.beginner:
        return baseSet.copyWith(
          pushupCount: (baseSet.pushupCount * 0.7).round(),
          burpeeCount: (baseSet.burpeeCount * 0.5).round(), // 버피는 더 큰 감소
          restDuration: baseSet.restDuration + Duration(seconds: 30),
        );

      case FitnessLevel.intermediate:
        return baseSet; // 기본값 사용

      case FitnessLevel.advanced:
        return baseSet.copyWith(
          pushupCount: (baseSet.pushupCount * 1.3).round(),
          burpeeCount: (baseSet.burpeeCount * 1.5).round(), // 버피는 더 큰 증가
          restDuration: baseSet.restDuration - Duration(seconds: 15),
        );
    }
  }
}
```

### Phase 4: UI/UX 구현

#### 4.1 운동 선택 화면
```dart
class ExerciseSelectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 오늘의 운동 구성 표시
        ExerciseCompositionCard(
          pushupCount: 15,
          burpeeCount: 10,
          estimatedTime: Duration(minutes: 8),
          estimatedCalories: 85,
        ),

        // 운동별 데모 버튼
        Row(
          children: [
            ExerciseDemoButton(
              type: ExerciseType.pushup,
              onTap: () => showPushupDemo(),
            ),
            ExerciseDemoButton(
              type: ExerciseType.burpee,
              onTap: () => showBurpeeDemo(),
            ),
          ],
        ),
      ],
    );
  }
}
```

#### 4.2 운동 진행 화면 개선
```dart
class MixedWorkoutScreen extends StatefulWidget {
  final List<ExerciseSet> todayExercises;

  @override
  _MixedWorkoutScreenState createState() => _MixedWorkoutScreenState();
}

class _MixedWorkoutScreenState extends State<MixedWorkoutScreen> {
  int currentExerciseIndex = 0;
  ExerciseType get currentExercise => widget.todayExercises[currentExerciseIndex].type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 현재 운동 표시
          CurrentExerciseHeader(
            type: currentExercise,
            setNumber: currentSetNumber,
            totalSets: totalSets,
          ),

          // 운동별 카운터
          if (currentExercise == ExerciseType.pushup)
            PushupCounterWidget()
          else if (currentExercise == ExerciseType.burpee)
            BurpeeCounterWidget(),

          // 진행률 표시
          ExerciseProgressIndicator(
            completed: completedExercises,
            total: widget.todayExercises,
          ),
        ],
      ),
    );
  }
}
```

#### 4.3 통계 화면 확장
```dart
class MixedWorkoutStatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 총 운동량 (푸시업 + 버피)
        TotalExerciseCard(
          totalPushups: 450,
          totalBurpees: 180,
          totalCalories: 2850,
        ),

        // 운동별 차트
        ExerciseBreakdownChart(
          pushupData: weeklyPushupData,
          burpeeData: weeklyBurpeeData,
        ),

        // 개인 기록
        PersonalRecordsSection(
          bestPushupStreak: 25,
          bestBurpeeStreak: 15,
          bestMixedWorkout: "25 푸시업 + 15 버피",
        ),
      ],
    );
  }
}
```

### Phase 5: Chad 진화 시스템 확장

#### 5.1 진화 포인트 계산 확장
```dart
class ChadEvolutionCalculator {
  static int calculateEvolutionPoints(WorkoutSession session) {
    int points = 0;

    for (var exerciseType in session.exerciseBreakdown.keys) {
      int reps = session.exerciseBreakdown[exerciseType]!;

      switch (exerciseType) {
        case ExerciseType.pushup:
          points += reps * 1; // 푸시업 1개당 1포인트
          break;
        case ExerciseType.burpee:
          points += reps * 2; // 버피 1개당 2포인트 (더 어려움)
          break;
        case ExerciseType.pushupDiamond:
          points += reps * 1.5; // 변형 푸시업은 1.5포인트
          break;
      }
    }

    return points.round();
  }
}
```

#### 5.2 새로운 Chad 이미지
- **Cardio Chad**: 버피 특화 Chad (3주차 도입 시)
- **Hybrid Chad**: 혼합 운동 마스터 Chad (5주차)
- **Ultimate Chad**: 모든 운동 완료 Chad (6주차 완료)

### Phase 6: 데이터베이스 확장

#### 6.1 스키마 업데이트
```sql
-- 운동 세션 테이블 확장
ALTER TABLE workout_sessions ADD COLUMN exercise_breakdown TEXT; -- JSON: {"pushup": 15, "burpee": 10}
ALTER TABLE workout_sessions ADD COLUMN total_calories REAL;
ALTER TABLE workout_sessions ADD COLUMN workout_duration INTEGER; -- 초 단위

-- 새로운 운동 기록 테이블
CREATE TABLE exercise_records (
  id INTEGER PRIMARY KEY,
  session_id INTEGER REFERENCES workout_sessions(id),
  exercise_type TEXT NOT NULL,
  set_number INTEGER NOT NULL,
  reps_completed INTEGER NOT NULL,
  set_duration INTEGER, -- 초 단위
  created_at TEXT NOT NULL
);

-- 개인 기록 테이블
CREATE TABLE personal_records (
  id INTEGER PRIMARY KEY,
  user_id TEXT NOT NULL,
  exercise_type TEXT NOT NULL,
  record_type TEXT NOT NULL, -- 'max_reps', 'longest_streak', 'fastest_time'
  record_value INTEGER NOT NULL,
  achieved_at TEXT NOT NULL
);
```

## 🚀 구현 일정

### 🥇 Week 1: 기반 구조
- [ ] ExerciseType enum 및 Exercise 모델 구현
- [ ] WorkoutSession 모델 확장
- [ ] 기본 버피 운동 정의
- [ ] 데이터베이스 스키마 업데이트

### 🥈 Week 2: 버피 운동 구현
- [ ] BurpeeCounterWidget 구현
- [ ] 버피 데모 영상/애니메이션
- [ ] 혼합 운동 세션 로직
- [ ] 3주차 버피 도입 테스트

### 🥉 Week 3: 프로그램 통합
- [ ] 목표별 운동 구성 알고리즘
- [ ] 난이도 조정 시스템
- [ ] 주차별 점진적 도입
- [ ] Chad 진화 시스템 확장

### 🎯 Week 4: UI/UX 완성
- [ ] 혼합 운동 진행 화면
- [ ] 확장된 통계 화면
- [ ] 개인 기록 추적
- [ ] 새로운 Chad 이미지 추가

## 🧪 테스트 시나리오

### 시나리오 1: 체중감량 목표 사용자
- **3주차**: 푸시업 12개 + 버피 3개
- **예상 결과**: 높은 칼로리 소모, 빠른 진행

### 시나리오 2: 근육증가 목표 사용자
- **4주차**: 푸시업 20개 + 버피 5개
- **예상 결과**: 근력 중심, 충분한 휴식

### 시나리오 3: 초보자 사용자
- **3주차**: 푸시업 8개 + 버피 2개
- **예상 결과**: 점진적 적응, 부상 방지

## 📈 성공 지표

### 운동 효과
- **칼로리 소모**: 버피 도입 후 평균 칼로리 소모량 증가율
- **운동 완료율**: 혼합 운동 vs 푸시업만 완료율 비교
- **사용자 만족도**: 운동 다양성에 대한 피드백

### 사용성
- **학습 곡선**: 버피 운동 습득 소요 시간
- **부상률**: 새로운 운동 도입 후 부상 보고
- **리텐션**: 버피 도입 후 사용자 지속률

## 💡 추가 아이디어

### 단기 확장
1. **버피 변형**: 하프 버피, 버피 점프 등
2. **인터벌 모드**: 타바타, HIIT 프로토콜
3. **팀 챌린지**: 친구와 버피 대결
4. **실시간 칼로리**: 운동 중 칼로리 소모량 표시

### 장기 비전
1. **AI 폼 체크**: 카메라로 버피 자세 교정
2. **음성 가이드**: 버피 동작 단계별 음성 안내
3. **VR 연동**: 가상현실 환경에서 운동
4. **웨어러블 통합**: 심박수 기반 강도 조절

---

## 🎯 핵심 목표

> **"Mission: 100을 단순한 푸시업 앱에서 종합 체력 향상 플랫폼으로 진화시키기"**

버피 통합을 통해 더 많은 사용자의 다양한 운동 목표를 만족시키고, 장기적인 운동 습관 형성을 지원합니다.