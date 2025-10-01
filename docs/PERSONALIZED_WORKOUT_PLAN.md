# 개인화 운동 계획 시스템 설계

## 📋 개요

온보딩에서 수집한 사용자 데이터를 바탕으로 맞춤형 운동 프로그램을 제공하는 시스템을 구축합니다.

## 🎯 수집된 사용자 데이터

### 저장된 SharedPreferences 키
- `current_weight`: 현재 체중 (double)
- `target_weight`: 목표 체중 (double, 선택사항)
- `fitness_level`: 운동 경험 (string: beginner/intermediate/advanced)
- `fitness_goal`: 주요 목표 (string: weightLoss/muscleGain/endurance/general)
- `workout_times`: 선호 운동 시간 (List<String>)
- `likes_competition`: 동기부여 방식 (bool)

## 🔧 구현 단계

### Phase 1: 데이터 활용 기반 구축

#### 1.1 UserProfile 모델 확장
```dart
class UserProfile {
  // 기존 필드들...

  // 새로 추가할 필드들
  final double? currentWeight;
  final double? targetWeight;
  final FitnessLevel fitnessLevel;
  final FitnessGoal fitnessGoal;
  final List<String> preferredWorkoutTimes;
  final bool likesCompetition;
  final DateTime? onboardingCompletedAt;
}

enum FitnessLevel { beginner, intermediate, advanced }
enum FitnessGoal { weightLoss, muscleGain, endurance, general }
```

#### 1.2 PersonalizedWorkoutService 생성
```dart
class PersonalizedWorkoutService {
  // 사용자 프로필 기반 운동 계획 생성
  WorkoutPlan generatePersonalizedPlan(UserProfile profile);

  // 난이도 조정 계산
  WorkoutDifficulty calculateDifficulty(FitnessLevel level, int week);

  // 목표별 운동 추천
  List<ExerciseType> recommendExercises(FitnessGoal goal, int week);

  // 칼로리 소모량 계산
  double calculateCalories(double weight, ExerciseType type, int reps);
}
```

### Phase 2: 개인화 로직 구현

#### 2.1 난이도 조정 알고리즘

| 경험 수준 | 기본 목표 대비 | 휴식 시간 | 세트 수 조정 |
|-----------|----------------|-----------|--------------|
| **초보자** | 70% | +30초 | -1세트 |
| **중급자** | 100% | 표준 | 표준 |
| **고급자** | 130% | -15초 | +1세트 |

#### 2.2 목표별 운동 계획

##### 🔥 체중 감량 (Weight Loss)
- **특징**: 고강도, 짧은 휴식, 칼로리 소모 최대화
- **운동 구성**: 푸시업 60% + 버피 40% (4주차부터)
- **휴식**: 기본 휴식 시간 -20%
- **추가 혜택**: 칼로리 소모량 실시간 표시

##### 💪 근육 증가 (Muscle Gain)
- **특징**: 점진적 오버로드, 충분한 휴식
- **운동 구성**: 푸시업 80% + 변형 푸시업 20%
- **휴식**: 기본 휴식 시간 +30%
- **추가 혜택**: 근력 향상 그래프 제공

##### ⚡ 체력 향상 (Endurance)
- **특징**: 지구력 중심, 인터벌 트레이닝
- **운동 구성**: 푸시업 50% + 버피 50% (3주차부터)
- **휴식**: 기본 휴식 시간 표준
- **추가 혜택**: 심박수 구간 가이드

##### 🌟 전반적 건강 (General)
- **특징**: 균형잡힌 프로그램
- **운동 구성**: 표준 프로그램 + 선택적 변형
- **휴식**: 기본 휴식 시간 표준
- **추가 혜택**: 종합 건강 점수

#### 2.3 주차별 개인화 적용

```dart
// 예시: 3주차 체중감량 목표 초보자
Week 3 Plan for Weight Loss Beginner:
- 기본 목표: 15개 × 3세트
- 개인화 적용: 11개 × 2세트 (70% × -1세트)
- 휴식: 90초 (기본 60초 + 30초 + 20% 감소)
- 운동 구성: 푸시업 8개 + 버피 3개
```

### Phase 3: UI/UX 개선

#### 3.1 개인화 표시
- **홈 화면**: "당신의 체중감량 계획" 등 목표 기반 메시지
- **운동 화면**: 개인화된 목표 개수와 이유 설명
- **통계 화면**: 목표별 맞춤 차트 (칼로리/근력/지구력)

#### 3.2 동기부여 시스템
- **경쟁 선호자**: 리더보드, 친구와 비교
- **개인 기록 선호자**: 개인 베스트, 성장 그래프

### Phase 4: 버피 운동 통합

#### 4.1 ExerciseType 확장
```dart
enum ExerciseType {
  pushup,
  burpee,
  pushupVariation, // 다이아몬드, 와이드 등
}

class Exercise {
  final ExerciseType type;
  final int targetReps;
  final Duration restDuration;
  final String instruction;
  final String? videoUrl;
}
```

#### 4.2 버피 도입 전략
- **1-2주차**: 푸시업만 (적응 기간)
- **3주차**: 버피 도입 (체중감량/체력향상 목표만)
- **4주차 이후**: 목표별 최적 비율 적용

#### 4.3 Chad 진화 확장
- **기존**: 푸시업 완료로만 진화
- **확장**: 총 운동량 기반 진화 (푸시업 + 버피)
- **신규 Chad**: 버피 특화 Chad 추가

## 📊 데이터 구조 설계

### 새로운 모델들

```dart
class PersonalizedWorkoutPlan {
  final String userId;
  final FitnessGoal goal;
  final FitnessLevel level;
  final Map<int, WeeklyPlan> weeklyPlans; // 주차별 계획
  final DateTime createdAt;
  final DateTime lastUpdated;
}

class WeeklyPlan {
  final int week;
  final List<DailyWorkout> dailyWorkouts;
  final double difficultyMultiplier;
  final String motivationalMessage;
}

class DailyWorkout {
  final int day;
  final List<Exercise> exercises;
  final Duration totalEstimatedTime;
  final double estimatedCalories;
}
```

### 데이터베이스 스키마 확장

```sql
-- 사용자 프로필 테이블 확장
ALTER TABLE user_profiles ADD COLUMN current_weight REAL;
ALTER TABLE user_profiles ADD COLUMN target_weight REAL;
ALTER TABLE user_profiles ADD COLUMN fitness_level TEXT;
ALTER TABLE user_profiles ADD COLUMN fitness_goal TEXT;
ALTER TABLE user_profiles ADD COLUMN preferred_workout_times TEXT; -- JSON 배열
ALTER TABLE user_profiles ADD COLUMN likes_competition INTEGER DEFAULT 0;

-- 개인화된 운동 계획 테이블
CREATE TABLE personalized_workout_plans (
  id INTEGER PRIMARY KEY,
  user_id TEXT NOT NULL,
  goal TEXT NOT NULL,
  level TEXT NOT NULL,
  plan_data TEXT NOT NULL, -- JSON 데이터
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

-- 운동 기록 테이블 확장
ALTER TABLE workout_sessions ADD COLUMN exercise_type TEXT DEFAULT 'pushup';
ALTER TABLE workout_sessions ADD COLUMN calories_burned REAL;
```

## 🚀 구현 우선순위

### 🥇 1단계 (1주): 기반 구축
- [ ] UserProfile 모델 확장
- [ ] SharedPreferences 데이터 로드 서비스
- [ ] PersonalizedWorkoutService 기본 구조
- [ ] 간단한 난이도 조정 로직

### 🥈 2단계 (1주): 개인화 적용
- [ ] 목표별 운동 계획 알고리즘
- [ ] 기존 WorkoutProgramService와 통합
- [ ] 개인화된 목표 개수 적용
- [ ] UI에 개인화 메시지 표시

### 🥉 3단계 (1주): 고도화
- [ ] 칼로리 계산 시스템
- [ ] 동기부여 시스템 (경쟁 vs 개인)
- [ ] 상세한 통계 및 분석
- [ ] 개인화 설정 변경 기능

### 🎯 4단계 (1주): 버피 통합
- [ ] ExerciseType 시스템 구축
- [ ] 버피 운동 구현
- [ ] 혼합 운동 프로그램
- [ ] Chad 진화 시스템 확장

## 🧪 테스트 시나리오

### 시나리오 1: 체중감량 초보자
- **프로필**: 70kg → 65kg, 초보자, 체중감량
- **예상 결과**: 70% 난이도, 버피 포함, 칼로리 중심 피드백

### 시나리오 2: 근육증가 고급자
- **프로필**: 80kg, 고급자, 근육증가
- **예상 결과**: 130% 난이도, 푸시업 중심, 근력 중심 피드백

### 시나리오 3: 목표 없음 (기존 사용자)
- **프로필**: 온보딩 데이터 없음
- **예상 결과**: 기존 표준 프로그램 유지

## 📈 성공 지표

- **개인화 적용률**: 온보딩 완료 사용자의 개인화 프로그램 사용률
- **운동 완료율**: 개인화 vs 표준 프로그램 완료율 비교
- **사용자 만족도**: 개인화된 계획에 대한 피드백
- **리텐션**: 개인화 사용자의 7일/30일 리텐션률

---

## 💡 추가 아이디어

### 장기적 확장 가능성
1. **AI 학습**: 사용자 행동 패턴 학습으로 계획 자동 조정
2. **커뮤니티**: 같은 목표 사용자들과의 그룹 챌린지
3. **웨어러블 연동**: 심박수, 칼로리 실측값 활용
4. **영양 가이드**: 목표별 식단 추천 시스템
5. **PT 연결**: 고급 사용자를 위한 전문가 매칭

### 수익화 연계
- **프리미엄 개인화**: 고급 분석, 전문가 계획
- **개인 트레이너 매칭**: 목표별 전문가 추천
- **영양제/장비 추천**: 목표에 맞는 제품 제안