# 🎯 Mission100 사용자 여정 (User Journey)

> **14주 푸시업 프로그램** | 유쾌한 Chad 멘토 | 연속 100개 달성

**최종 업데이트**: 2025-10-19
**앱 버전**: v1.0 (현재 구현 기준)

---

## 📋 목차

- [앱 개요](#앱-개요)
- [핵심 여정 요약](#핵심-여정-요약)
- [상세 화면 흐름](#상세-화면-흐름)
- [알려진 이슈](#알려진-이슈)
- [화면 파일 매핑](#화면-파일-매핑)

---

## 🎯 앱 개요

### 프로그램 구조
- **기간**: 14주 (Week 1-14)
- **목표**: 연속 100개 푸시업 달성
- **운동**: 주 3-5회
- **난이도**: Rookie / Regular / Challenger (3단계)

### Chad 진화 시스템 ⚠️

**현재 상태 (v1.0)**:
```
Stage 0: sleepCapChad (시작)
Stage 1: basicChad (Week 1 완료)
Stage 2: coffeeChad (Week 2 완료)
Stage 3: frontFacingChad (Week 3 완료)
Stage 4: sunglassesChad (Week 4 완료)
Stage 5: glowingEyesChad (Week 5 완료)
Stage 6: doubleChad (Week 6 완료)

⚠️ 문제: Week 7-14는 진화 없음 (doubleChad 유지)
```

**서비스**: `lib/services/chad_evolution_service.dart`
**모델**: `lib/models/chad_evolution.dart`

**개선 계획 (v1.1)**:
```
Option 1: 2주마다 진화
- Week 2, 4, 6, 8, 10, 12, 14에 진화

Option 2: 마일스톤 기반
- 총 푸시업 개수 기준 진화
```

---

## 🚀 핵심 여정 요약

### Day 0: 앱 설치 (3-5분)

```
앱 실행
  ↓
온보딩 (4 슬라이드)
├─ Chad 소개
├─ 14주 프로그램 설명
├─ Chad 진화 시스템
└─ 업적 & 챌린지
  ↓
사용자 정보 입력
├─ 닉네임
├─ 피트니스 레벨 ⭐
│  ├─ 초보자: "푸시업 처음"
│  ├─ 초급: "무릎 대고 10개"
│  ├─ 중급: "정자세 15개"
│  └─ 고급: "정자세 30개+"
├─ 목표 설정
└─ 운동 일정
  ↓
권한 요청
└─ 알림 권한 (필수)
  ↓
메인 화면
```

**화면**:
- ✅ `lib/screens/onboarding/onboarding_screen.dart`
- ✅ `lib/screens/onboarding/user_goals_screen.dart`
- ✅ `lib/screens/permission_screen.dart`

---

### Day 1: 첫 운동 (10-15분)

```
메인 화면
  ↓
[운동 시작하기] 버튼
  ↓
푸시업 튜토리얼 (첫 운동 시)
├─ 올바른 자세
├─ 호흡법
└─ 카운트 방식
  ↓
운동 화면
├─ Set 1: 5개 (Rookie 기준)
├─ 휴식 90초
├─ Set 2: 5개
├─ 휴식 90초
└─ Set 3: 5개
  ↓
운동 완료 화면
├─ 오늘의 기록 (15개, 5분 23초)
├─ 🔥 스트릭: 1일 시작!
├─ ⭐ 경험치: +10 XP
└─ 🏆 업적: "첫 운동 완료"
  ↓
메인 화면
```

**화면**:
- ✅ `lib/screens/home_screen.dart`
- ✅ `lib/screens/pushup_tutorial_screen.dart`
- ✅ `lib/screens/workout_screen.dart`

**자동 처리**:
- ✅ 로컬 DB 저장 (`lib/services/database_service.dart`)
- ✅ Firebase 동기화 (백그라운드)
- ✅ 업적 체크 (`lib/services/achievement_service.dart`)

---

### Week 1-6: 기초 단계

```
Day 1, 3, 5: 운동
  ├─ 알림 수신 (설정 시간)
  ├─ 운동 완료
  ├─ Chad 응원
  └─ 진행률 업데이트

Day 2, 4, 6, 7: 휴식
  ├─ 액티브 리커버리 (선택)
  │  ├─ 스트레칭 (10분)
  │  ├─ 가벼운 산책 (20분)
  │  └─ 요가 (15분)
  └─ 스트릭 유지

주차 완료 시:
  ├─ Chad 진화! 🎉
  ├─ 진화 애니메이션
  ├─ 새 능력 해금
  └─ 업적 달성
```

**화면**:
- ✅ `lib/screens/chad_active_recovery_screen.dart`

**Chad 진화**:
- Week 1 완료 → basicChad
- Week 2 완료 → coffeeChad
- Week 3 완료 → frontFacingChad
- Week 4 완료 → sunglassesChad
- Week 5 완료 → glowingEyesChad
- Week 6 완료 → doubleChad

---

### Week 7-14: 고급 단계 ⚠️

```
⚠️ 현재 이슈:
- doubleChad 유지 (진화 없음)
- 동기부여 저하 가능성

운동:
  ├─ 강도 증가 (개수/세트 증가)
  ├─ 업적 해금 계속
  └─ 100개 목표 달성 준비

Week 14 완료:
  ├─ 🎯 연속 100개 달성!
  ├─ 프로그램 완료 인증서
  ├─ 최종 통계 확인
  └─ 다음 챌린지 선택
```

---

### 프로그램 완료 (14주 후)

```
┌────────────────────────────┐
│  🎉 MISSION COMPLETE!      │
│                            │
│  14주 프로그램 완료!        │
│  🦾 doubleChad (최종 진화)  │
│                            │
│  총 운동일: 42일            │
│  총 푸시업: 3,850개         │
│  시작: 5개 → 종료: 100개    │
│  성장률: +1900%! 🔥        │
│                            │
│  [인증서] [공유] [다음]     │
└────────────────────────────┘

다음 단계:
├─ 🔄 다시 도전 (14주 재시작)
├─ 💪 유지 모드 (주 3회)
└─ 🔜 새 프로그램 (v2.0)
```

---

## 📱 상세 화면 흐름

### 1. 메인 화면

**화면**: ✅ `lib/screens/home_screen.dart`

```
┌──────────────────────────┐
│ [≡]  Mission: 100  [⚙️]  │
├──────────────────────────┤
│      🦾 Chad             │
│   sleepCapChad           │
│  "오늘도 힘내자! 💪"       │
├──────────────────────────┤
│ 📅 Week 1, Day 1         │
│ 오늘의 목표:              │
│ 푸시업 5개 x 3세트        │
│                          │
│ [  🔥 운동 시작하기  ]    │
├──────────────────────────┤
│ 📊 진행 상황              │
│ ████░░░░░ 8% (Week 1/14) │
│                          │
│ 🏆 이번 주: 1/3일        │
│ 🔥 스트릭: 1일           │
│ 💪 총: 15개              │
└──────────────────────────┘

[하단 탭]
🏠 홈 | 📊 진행 | 🏆 업적 | ⚙️ 설정
```

**위젯**:
- ✅ `chad_section_widget.dart` - Chad 영역
- ✅ `today_mission_card_widget.dart` - 오늘 미션
- ✅ `progress_card_widget.dart` - 진행 상황
- ✅ `achievement_stats_widget.dart` - 업적 통계

---

### 2. 운동 화면

**화면**: ✅ `lib/screens/workout_screen.dart`

```
┌──────────────────────────┐
│ Week 1, Day 1 - Set 1/3  │
│ 목표: 5개                 │
├──────────────────────────┤
│      🦾 Chad             │
│  "5개만! 넌 할 수 있어!"  │
├──────────────────────────┤
│     카운트다운            │
│       3 / 5              │
│   ██████░░ 60%           │
├──────────────────────────┤
│ [터치해서 카운트]          │
│ [일시정지] [포기]         │
└──────────────────────────┘

세트 완료:
┌──────────────────────────┐
│  🎉 Set 1 완료!          │
│  휴식: 90초               │
│    ⏱️ 01:28              │
│                          │
│ Chad: "잘했어! 숨 돌려!"  │
│ [휴식 스킵] [계속]        │
└──────────────────────────┘
```

**위젯**:
- ✅ `rep_counter_widget.dart` - 카운터
- ✅ `rest_timer_widget.dart` - 휴식 타이머
- ✅ `workout_controls_widget.dart` - 컨트롤
- ✅ `workout_header_widget.dart` - 헤더

**핸들러**:
- ✅ `workout_completion_handler.dart` - 완료 처리

---

### 3. 진행 상황 화면

**화면**: ✅ `lib/screens/progress_tracking_screen.dart`

```
┌──────────────────────────┐
│ 📊 나의 진행 상황         │
├──────────────────────────┤
│ 전체: ████░░░ 21%        │
│ Week 3, Day 1 / 14주     │
├──────────────────────────┤
│ 📈 통계                  │
│ 총 운동일: 8일            │
│ 총 푸시업: 195개          │
│ 평균: 24개/일             │
├──────────────────────────┤
│ 📅 주별 진행              │
│ Week 1: ✅✅✅ (완료)     │
│ Week 2: ✅✅✅ (완료)     │
│ Week 3: ✅✅⏳          │
│ Week 4-14: ⏳           │
├──────────────────────────┤
│ 🏆 기록                  │
│ 최고 스트릭: 8일          │
│ 하루 최대: 45개           │
└──────────────────────────┘
```

**관련 화면**:
- ✅ `lib/screens/calendar_screen.dart` - 캘린더 뷰
- ✅ `lib/screens/statistics_screen.dart` - 상세 통계

---

### 4. 업적 & 챌린지

**화면**: ✅ `lib/screens/achievements_screen.dart`

```
┌──────────────────────────┐
│ 🏆 업적 & 배지            │
├──────────────────────────┤
│ 진행률: 12/50 (24%)      │
│ 획득 배지: 12개           │
│ 총 XP: 450               │
├──────────────────────────┤
│ 🔥 연속 달성              │
│ ✅ 첫 운동 +10 XP        │
│ ✅ 3일 연속 +20 XP       │
│ ✅ 7일 연속 +50 XP       │
│ 🔒 14일 연속 (8/14)      │
│                          │
│ 💪 총량 달성              │
│ ✅ 100개 달성            │
│ 🔒 500개 (195/500)       │
│                          │
│ 🎯 주차 완료              │
│ ✅ Week 1-2 완료         │
│ 🔒 Week 3 (2/3일)        │
└──────────────────────────┘
```

**챌린지**: ✅ `lib/screens/challenge_screen.dart`

```
데일리:
"오늘 운동 완료" +10 XP ✅

위클리:
"주 3일 이상" +30 XP (2/3)

🔜 v1.1: 커뮤니티 챌린지
```

---

### 5. 설정

**화면**: ✅ `lib/screens/settings_screen.dart`

```
┌──────────────────────────┐
│ ⚙️ 설정                  │
├──────────────────────────┤
│ 🔔 알림                  │
│ > 운동 리마인더           │
│ > 알림 시간               │
│                          │
│ 🎨 앱                    │
│ > 테마 (라이트/다크)      │
│ > 언어                   │
│                          │
│ 💪 운동                  │
│ > 난이도 조정             │
│ > 휴식 시간               │
│ > 음성 피드백             │
│                          │
│ 💾 데이터                │
│ > 백업 & 복원            │
│ > 동기화                 │
│                          │
│ 👤 계정                  │
│ > 프로필                 │
│ > 🔜 구독 (v1.1)        │
│ > 계정 삭제              │
│                          │
│ ℹ️ 정보                  │
│ > 앱 버전 1.0.0          │
│ > 개인정보 처리방침       │
│ > 이용약관               │
└──────────────────────────┘
```

**위젯**:
- ✅ `notification_settings_widget.dart`
- ✅ `appearance_settings_widget.dart`
- ✅ `data_settings_widget.dart`
- ✅ `about_settings_widget.dart`

**관련 화면**:
- ✅ `workout_reminder_settings_screen.dart`
- ✅ `backup_screen.dart`
- ✅ `legal/legal_document_screen.dart`

---

### 6. 특별 기능

#### 액티브 리커버리

**화면**: ✅ `lib/screens/chad_active_recovery_screen.dart`

```
┌──────────────────────────┐
│ 🛌 오늘은 휴식일          │
├──────────────────────────┤
│ 😴 Chad                  │
│ "잘 쉬는 것도 훈련!"      │
├──────────────────────────┤
│ 액티브 리커버리 (선택)    │
│                          │
│ 🧘 스트레칭 (10분)        │
│ +5 XP [시작]             │
│                          │
│ 🚶 산책 (20분)           │
│ +5 XP [시작]             │
│                          │
│ 🧘 요가 (15분)           │
│ +10 XP [시작]            │
├──────────────────────────┤
│ ✅ 휴식일도 스트릭 유지   │
│ [오늘은 푹 쉴래]          │
└──────────────────────────┘
```

#### 푸시업 자세 가이드

**화면**: ✅ `lib/screens/pushup_form_guide_screen.dart`

```
푸시업 자세 가이드

7가지 자세:
1. Standard (표준)
2. Wide (와이드)
3. Diamond (다이아몬드)
4. Knee (무릎)
5. Decline (디클라인)
6. Incline (인클라인)
7. Clap (박수)

⚠️ 이미지 일부 누락
(ASSETS.md 참고)
```

---

## 🚨 알려진 이슈

### 🔴 Critical (v1.1 필수)

1. **Chad 진화 14주 불일치**
   - 현재: Week 1-6만 진화 (7단계)
   - 문제: Week 7-14는 doubleChad 유지
   - 영향: 사용자 동기부여 저하
   - 계획: 14주 맞춤 재설계

2. **온보딩 메시지 수정**
   - 현재: 일부 "6주" 언급
   - 수정: "14주"로 전면 변경

### 🟡 Important (v1.1 권장)

3. **커뮤니티 기능 미구현**
   - 친구 시스템 없음
   - 순위표 없음
   - 커뮤니티 챌린지 없음

4. **구독 시스템 미완성**
   - 화면만 준비됨
   - 결제 연동 필요
   - 광고 시스템 없음

5. **푸시업 자세 이미지 누락**
   - standard, wide, incline 등
   - 상세: [ASSETS.md](ASSETS.md) 참고

### 🟢 Nice to Have (v2.0)

6. **Chad 스킨 시스템**
7. **커스텀 루틴**
8. **추가 운동 프로그램**

---

## 📂 화면 파일 매핑

### ✅ 구현 완료

| 기능 | 파일 | 상태 |
|------|------|------|
| **온보딩** |
| 온보딩 슬라이드 | `onboarding/onboarding_screen.dart` | ✅ |
| 사용자 목표 | `onboarding/user_goals_screen.dart` | ✅ |
| 권한 요청 | `permission_screen.dart` | ✅ |
| **메인** |
| 홈 화면 | `home_screen.dart` | ✅ |
| 메인 네비게이션 | `main_navigation_screen.dart` | ✅ |
| **운동** |
| 운동 화면 | `workout_screen.dart` | ✅ |
| 튜토리얼 | `pushup_tutorial_screen.dart` | ✅ |
| 튜토리얼 상세 | `pushup_tutorial_detail_screen.dart` | ✅ |
| 자세 가이드 | `pushup_form_guide_screen.dart` | ✅ |
| 초기 테스트 | `initial_test_screen.dart` | ✅ |
| **진행** |
| 진행 상황 | `progress_tracking_screen.dart` | ✅ |
| 캘린더 | `calendar_screen.dart` | ✅ |
| 통계 | `statistics_screen.dart` | ✅ |
| **업적** |
| 업적 | `achievements_screen.dart` | ✅ |
| 챌린지 | `challenge_screen.dart` | ✅ |
| **특별** |
| 액티브 리커버리 | `chad_active_recovery_screen.dart` | ✅ |
| **설정** |
| 설정 메인 | `settings_screen.dart` | ✅ |
| 간단 설정 | `simple_settings_screen.dart` | ✅ |
| 알림 설정 | `workout_reminder_settings_screen.dart` | ✅ |
| 일정 설정 | `workout_schedule_setup_screen.dart` | ✅ |
| 백업 | `backup_screen.dart` | ✅ |
| 법률 문서 | `legal/legal_document_screen.dart` | ✅ |
| **기타** |
| 과학적 근거 | `scientific_evidence/scientific_evidence_screen.dart` | ✅ |
| YouTube Shorts | `youtube_shorts_screen.dart` | ✅ |

### 🔜 준비됨 (미완성)

| 기능 | 파일 | 상태 |
|------|------|------|
| 구독 화면 | `subscription_screen.dart` | 🔜 v1.1 |
| 구독 관리 | `subscription_management_screen.dart` | 🔜 v1.1 |

### ❌ 미구현 (계획)

| 기능 | 상태 |
|------|------|
| 친구 목록 | v1.1 계획 |
| 친구 검색 | v1.1 계획 |
| 순위표 | v1.1 계획 |
| Chad 스킨 선택 | v2.0 계획 |
| 커스텀 루틴 | v2.0 계획 |

---

## 🔔 알림 시스템

**서비스**: ✅ `lib/services/notification_service.dart`

### 현재 구현

```
1. ✅ 운동 리마인더
   "오후 6시! 오늘 운동 시간! 💪"

2. ✅ 스트릭 경고
   "아직 오늘 운동 안 했어! ⚠️"
   (오후 10시, 스트릭 7일+ 시만)

3. ✅ 업적 달성
   "축하! '7일 연속' 달성! 🏆"

4. ✅ Chad 진화
   "Chad가 진화했어! 🎉"
```

### 계획 (v1.1)

```
5. Chad 응원 (빈도 제한 필요)
6. 친구 활동
```

---

## 💾 데이터 흐름

```
사용자 액션
    ↓
로컬 저장 (SQLite)
    ├→ UI 즉시 업데이트
    │   ├─ 홈 화면 진행률
    │   ├─ Chad 진화 체크
    │   └─ 업적 해금
    │
    └→ 백그라운드 동기화
         ↓
      Firebase Firestore
         ├─ 운동 기록
         ├─ 사용자 프로필
         ├─ 업적 데이터
         └─ Chad 진화 상태
         ↓
      다른 기기 동기화
```

**서비스**:
- ✅ `lib/services/database_service.dart`
- ✅ Firebase Firestore

---

## 📊 Chad 시스템 정리

### Chad 진화 (영구적)

```
주차 완료 기준 성장:

Stage 0: sleepCapChad (시작)
Stage 1: basicChad (Week 1)
Stage 2: coffeeChad (Week 2)
Stage 3: frontFacingChad (Week 3)
Stage 4: sunglassesChad (Week 4)
Stage 5: glowingEyesChad (Week 5)
Stage 6: doubleChad (Week 6)

⚠️ Week 7-14: 진화 없음
```

**서비스**: `lib/services/chad_evolution_service.dart`
**모델**: `lib/models/chad_evolution.dart`

### Chad 컨디션 (일시적)

```
최근 활동 기준 변화:

😴 피곤함 (2일+ 미운동)
😊 보통 (정상 활동)
💪 활기참 (연속 3일)
🔥 불타는 (스트릭 7일+)
```

**서비스**: `lib/services/chad_condition_service.dart`
**위젯**: `chad_condition_widget.dart`

**⚠️ 중요**: 진화 ≠ 컨디션 (독립적 시스템)

---

## 🎯 핵심 지표

### 사용자 리텐션

```
Day 1: 첫 운동 완료율
Day 3: 3일 연속 달성
Week 1: 첫 주 완료
Week 2: Chad 진화 경험
Week 6: doubleChad 도달
Week 14: 프로그램 완료

⚠️ 위험 구간:
- Week 7-14 (진화 없음)
- 해결: v1.1 진화 재설계
```

### 알림 전략

```
Daily:
- 운동 리마인더
- 데일리 챌린지

Weekly:
- 주간 리포트
- Chad 진화 (Week 1-6)

Milestone:
- 업적 달성
- 스트릭 기록
```

---

## 🔗 관련 문서

- **[ASSETS.md](ASSETS.md)** - 에셋 통합 가이드
- **[CHAD_IMAGE_GENERATION_GUIDE.md](CHAD_IMAGE_GENERATION_GUIDE.md)** - Chad 이미지 생성
- **[DEVELOPMENT.md](DEVELOPMENT.md)** - 개발 가이드
- **[FEATURES.md](FEATURES.md)** - 기능 로드맵

---

**작성일**: 2025-10-19
**버전**: v1.0 (현재 구현 기준)
**다음 업데이트**: v1.1 Chad 진화 재설계 후

**Chad는 유쾌한 멘토입니다. 모든 순간에 따뜻함과 친근함을 잃지 않습니다.** 💪
