# Signup Prompt Integration Summary

## 📅 완료일: 2025-10-28

---

## 🎯 작업 개요

비회원 사용자에게 회원가입을 부드럽게 유도하는 시스템을 운동 완료 흐름에 통합했습니다.
"한 번만, 자연스럽게" 원칙을 따라 구현되었습니다.

---

## 🔧 통합된 파일

### 1. [lib/screens/workout_screen.dart](../lib/screens/workout_screen.dart)

**추가된 Import:**
```dart
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/signup_prompt_service.dart';
import '../widgets/dialogs/gentle_signup_prompt_dialog.dart';
import '../screens/onboarding/onboarding_screen.dart';
```

**수정된 메서드:**

#### `_finishWorkout()` (Lines 681-687)
- 운동 완료 후 `_checkAndShowSignupPrompt()` 호출
- 비차단 방식으로 백그라운드에서 실행

```dart
void _finishWorkout() async {
  // 회원가입 유도 체크 (비차단, 백그라운드)
  _checkAndShowSignupPrompt();

  widget.onWorkoutCompleted?.call();
  Navigator.pop(context);
}
```

**새로 추가된 메서드:**

#### `_checkAndShowSignupPrompt()` (Lines 695-763)
회원가입 유도를 체크하고 표시하는 메인 로직

**체크 조건:**
1. ✅ 사용자가 비로그인 상태
2. ✅ 아직 유도를 보여주지 않음 (한 번만)
3. ✅ 적절한 타이밍 (3일 사용 + 5회 운동 이상)

**흐름:**
```
운동 완료
  ↓
로그인 상태 확인 (AuthService)
  ↓
이미 표시했는지 확인 (SignupPromptService.shouldShowPrompt)
  ↓
적절한 타이밍인지 확인 (SignupPromptService.getRecommendedTiming)
  ↓
운동 완료 횟수 증가 (SharedPreferences)
  ↓
500ms 딜레이 (UX 개선)
  ↓
GentleSignupPromptDialog 표시
  ↓
표시 기록 (SignupPromptService.markPromptShown)
```

---

## 📚 기존 파일 (이미 구현됨)

### 2. [lib/services/signup_prompt_service.dart](../lib/services/signup_prompt_service.dart)

**주요 메서드:**
- `shouldShowPrompt()` - 유도 표시 가능 여부 확인
- `markPromptShown()` - 유도 표시 기록
- `getRecommendedTiming()` - 적절한 타이밍 판단
- `resetPrompt()` - 테스트용 초기화

**타이밍 기준:**
```dart
enum SignupPromptTiming {
  notYet,   // 아직 아님 (더 사용 후)
  good,     // 좋은 타이밍 (1일 + 10회 운동)
  optimal,  // 최적 타이밍 (3일 + 5회 운동)
}
```

### 3. [lib/widgets/dialogs/gentle_signup_prompt_dialog.dart](../lib/widgets/dialogs/gentle_signup_prompt_dialog.dart)

**디자인 특징:**
- ✨ 부드러운 그라디언트 아이콘
- 💎 명확한 혜택 설명 (자동 백업, 동기화, VIP 빠른 로딩)
- 📝 "회원가입 없이도 모든 기능 사용 가능" 명시
- 🎨 "나중에" / "회원가입 (30초)" 버튼

**혜택 목록:**
1. 🔒 자동 백업 - 휴대폰을 바꿔도 데이터 유지
2. 📱 여러 기기 동기화 - 태블릿, 폰 어디서나 이어하기
3. ⚡ VIP 빠른 로딩 - 앱 시작 시 10배 빠른 속도

---

## 🎯 유도 전략

### "쪼잔하지 않게, 한 번만" 철학

| 특징 | 설명 |
|------|------|
| **비강압적** | 거부해도 앱 사용에 아무 제한 없음 |
| **한 번만** | 한 번 거부하면 다시 보여주지 않음 |
| **적절한 타이밍** | 충분히 경험한 후에만 표시 (3일 + 5회 운동) |
| **명확한 혜택** | 데이터 백업, 동기화, VIP 속도의 실질적 가치 |
| **UX 개선** | 500ms 딜레이로 자연스러운 흐름 |

### 타이밍 기준

```
┌─────────────────────────────────────────┐
│  Day 0-2: notYet (아직 안 보여줌)       │
│  - 앱 탐색 기간                          │
│  - 운동 0-4회                            │
└─────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────┐
│  Day 3+, 5회+ 운동: optimal (최적)      │
│  - 충분한 경험 후                        │
│  - 가치를 이해한 상태                    │
│  → 유도 표시 ✅                          │
└─────────────────────────────────────────┘
              OR
┌─────────────────────────────────────────┐
│  Day 1+, 10회+ 운동: good (좋음)        │
│  - 열심히 사용 중                        │
│  - 이탈 방지                             │
│  → 유도 표시 ✅                          │
└─────────────────────────────────────────┘
```

---

## 🔄 사용자 플로우

### 비로그인 사용자 (처음 5회 운동)

```
1. 운동 시작 ▶️
2. 운동 완료 ✅
3. "WORKOUT DESTROYED!" 다이얼로그
4. "FXXK YEAH!" 버튼 클릭
5. 홈으로 복귀
   ⚠️ 아직 유도 안 보여줌 (타이밍 not yet)
```

### 비로그인 사용자 (6회째 운동, 3일 사용)

```
1. 운동 시작 ▶️
2. 운동 완료 ✅
3. "WORKOUT DESTROYED!" 다이얼로그
4. "FXXK YEAH!" 버튼 클릭
5. 500ms 딜레이...
6. ✨ "데이터를 안전하게 보관하세요" 다이얼로그 표시
   - 혜택 설명 (백업, 동기화, VIP 속도)
   - "나중에" / "회원가입 (30초)" 버튼
7a. "나중에" 클릭 → 홈으로 복귀, 표시 기록
7b. "회원가입" 클릭 → OnboardingScreen으로 이동
```

### 이미 로그인한 사용자

```
1. 운동 시작 ▶️
2. 운동 완료 ✅
3. "WORKOUT DESTROYED!" 다이얼로그
4. "FXXK YEAH!" 버튼 클릭
5. 홈으로 복귀
   ℹ️ 유도 표시 안 함 (이미 로그인)
```

---

## 💾 데이터 저장

### SharedPreferences Keys

| Key | 타입 | 설명 |
|-----|------|------|
| `signup_prompt_shown` | bool | 유도를 보여줬는지 여부 |
| `signup_prompt_dismissed_at` | String (ISO8601) | 마지막 거부 날짜 |
| `first_use_date` | String (ISO8601) | 앱 첫 사용 날짜 |
| `completed_workout_count` | int | 운동 완료 횟수 (타이밍 판단용) |

---

## ✅ 구현 완료 체크리스트

- [x] SignupPromptService 생성 (이미 존재)
- [x] GentleSignupPromptDialog 생성 (이미 존재)
- [x] workout_screen.dart에 통합
- [x] 로그인 상태 체크
- [x] 타이밍 로직 구현
- [x] 운동 완료 횟수 추적
- [x] 표시 기록 기능
- [x] 한 번만 표시 보장
- [x] 비차단 방식 구현
- [x] UX 딜레이 추가
- [x] OnboardingScreen 네비게이션

---

## 🧪 테스트 시나리오

### 1. 첫 운동 완료 (비로그인)
**예상 결과:** 유도 표시 안 함 (타이밍 not yet)

### 2. 6회째 운동 완료 (비로그인, 3일 사용)
**예상 결과:** 유도 표시 ✅

### 3. 유도 표시 후 "나중에" 클릭
**예상 결과:**
- 다음 운동부터 유도 표시 안 함
- `signup_prompt_shown = true` 저장됨

### 4. 유도 표시 후 "회원가입" 클릭
**예상 결과:**
- OnboardingScreen으로 이동
- `signup_prompt_shown = true` 저장됨

### 5. 이미 로그인한 사용자
**예상 결과:** 항상 유도 표시 안 함

### 6. 테스트 초기화
```dart
await SignupPromptService().resetPrompt();
```
**예상 결과:** 다시 유도 표시 가능

---

## 🎨 UI/UX 고려사항

### ✅ 좋은 점
1. **비강압적** - "나중에" 버튼이 명확하게 보임
2. **명확한 가치** - 실질적 혜택을 구체적으로 설명
3. **안심 문구** - "회원가입 없이도 모든 기능 사용 가능"
4. **적절한 딜레이** - 운동 완료 다이얼로그 후 500ms 대기
5. **한 번만** - 귀찮지 않게 딱 한 번만 표시

### 🎯 최적화 포인트
- 500ms 딜레이로 사용자가 운동 완료를 충분히 인지한 후 표시
- "회원가입 (30초)" 문구로 간단함 강조
- 그라디언트 아이콘으로 시각적 매력도 향상

---

## 📊 예상 효과

### 전환율 목표
- **1차 목표:** 20% 회원가입 전환
  - 100명 중 20명이 "회원가입" 클릭
- **2차 목표:** 80% 거부율 수용
  - 거부해도 앱 사용 지속 가능 (제한 없음)

### 데이터 백업 혜택
- 사용자 이탈 방지 (휴대폰 변경 시)
- 프리미엄 전환 가능성 증가 (로그인 유저 → 구독 유도)
- 클라우드 동기화로 멀티 디바이스 경험

---

## 🔮 향후 개선 계획

### Phase 1: 모니터링 (현재)
- 유도 표시 횟수 추적
- 회원가입 전환율 측정
- "나중에" 클릭률 분석

### Phase 2: A/B 테스트 (나중에)
- 다양한 타이밍 실험 (3일 vs 5일)
- 다양한 메시지 테스트
- 아이콘 디자인 변형

### Phase 3: 개인화 (미래)
- 사용자 패턴 기반 최적 타이밍 예측
- 운동 강도에 따른 메시지 조정
- 챌린지 완료 시점 유도 추가

---

## 🚀 배포 준비

### ✅ 완료된 항목
- [x] 서비스 구현
- [x] UI 구현
- [x] 통합 완료
- [x] 한 번만 표시 보장
- [x] 비차단 방식
- [x] 문서화

### 📋 배포 전 확인사항
- [ ] 실제 디바이스 테스트
- [ ] 다양한 타이밍 시나리오 테스트
- [ ] OnboardingScreen 네비게이션 검증
- [ ] SharedPreferences 데이터 지속성 확인
- [ ] 에러 핸들링 검증

---

## 📚 관련 문서

- [SUBSCRIPTION_STRATEGY_V2.md](SUBSCRIPTION_STRATEGY_V2.md) - 새 구독 전략
- [VIP_IMPLEMENTATION_SUMMARY.md](VIP_IMPLEMENTATION_SUMMARY.md) - VIP 기능 구현
- [SERVICES_GUIDE.md](SERVICES_GUIDE.md) - 서비스 가이드

---

**작성일:** 2025-10-28
**작성자:** Claude
**버전:** 1.0
**상태:** ✅ 완료 (통합 및 문서화)
