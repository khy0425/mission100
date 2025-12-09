# Level Up System Design - DreamFlow

**작성일:** 2025-11-13
**버전:** 1.0
**상태:** Phase 2 Gamification

---

## 📋 개요

DreamFlow의 레벨업 시스템은 사용자의 자각몽 훈련 진행 상황을 시각화하고 동기부여를 제공하는 핵심 게임화 요소입니다.

### 목표
1. **진행 상황 시각화**: 레벨 숫자로 명확한 성취감 제공
2. **동기 부여**: 레벨업 축하 및 보상으로 지속적인 참여 유도
3. **캐릭터 진화 연동**: Lumi 캐릭터 진화와 레벨업 동기화
4. **공정한 평가**: 훈련 일수와 완료율을 모두 고려한 균형잡힌 레벨 산정

---

## 🎯 레벨 계산 공식

### 기본 공식
```
레벨 스코어 = 총 훈련 일수 × 평균 완료율
레벨 = floor(레벨 스코어 / 3) + 1
```

### 예시
| 훈련 일수 | 평균 완료율 | 스코어 | 레벨 |
|---------|-----------|-------|-----|
| 3일 | 80% (0.8) | 2.4 | **1** |
| 7일 | 70% (0.7) | 4.9 | **2** |
| 14일 | 75% (0.75) | 10.5 | **4** |
| 21일 | 80% (0.8) | 16.8 | **6** |
| 30일 | 85% (0.85) | 25.5 | **9** |
| 60일 | 90% (0.9) | 54.0 | **18** |

### 레벨 범위
- **최소 레벨**: 1 (시작 시)
- **일반 범위**: 1-10 (30일 무료 사용자)
- **프리미엄 범위**: 10-20+ (60일 프리미엄 사용자)
- **최대 이론 레벨**: 제한 없음

---

## 🎮 레벨업 시스템 구조

### 1. Level Tracking (레벨 추적)

**SharedPreferences 저장 데이터:**
```dart
{
  "last_known_level": 5,           // 마지막으로 알려진 레벨
  "last_level_check_date": "2025-11-13",  // 마지막 체크 날짜
  "level_up_count": 12,            // 총 레벨업 횟수
  "highest_level_reached": 8       // 최고 도달 레벨
}
```

### 2. Level Up Detection (레벨업 감지)

**감지 시점:**
1. 앱 시작 시 (홈 화면 로드)
2. 체크리스트 완료 시
3. 통계 화면 진입 시

**감지 로직:**
```dart
Future<LevelUpResult> checkForLevelUp() async {
  final currentLevel = calculateLevel(stats);
  final lastKnownLevel = await getLastKnownLevel();

  if (currentLevel > lastKnownLevel) {
    // 레벨업 발생!
    await saveLastKnownLevel(currentLevel);
    return LevelUpResult(
      leveledUp: true,
      oldLevel: lastKnownLevel,
      newLevel: currentLevel,
      characterEvolved: _checkCharacterEvolution(currentLevel),
    );
  }

  return LevelUpResult.noLevelUp();
}
```

### 3. Level Up Celebration (레벨업 축하)

**UI 요소:**
1. **축하 다이얼로그**: Confetti 애니메이션과 함께 표시
2. **레벨 배지 강조**: 새 레벨 번호를 애니메이션으로 강조
3. **캐릭터 진화 알림**: 주차가 바뀌면 캐릭터 진화 메시지 표시

**표시 정보:**
- 이전 레벨 → 새 레벨
- 축하 메시지
- 다음 레벨까지 필요한 일수
- (선택) 캐릭터 진화 정보

---

## 🌟 캐릭터 진화와 연동

### 레벨업 vs 캐릭터 진화

| 요소 | 기준 | 빈도 |
|-----|------|-----|
| **레벨업** | 훈련 일수 × 완료율 | 가변적 (2-5일마다) |
| **캐릭터 진화** | 주차 (Week) | 고정적 (주간) |

### 연동 로직

```dart
// Week 0 → 1 진화 시:
// - 레벨 2-3 정도 예상
// - 레벨업 + 캐릭터 진화 동시 축하

// Week 1 → 2 진화 시:
// - 레벨 4-5 정도 예상
// - 레벨업 + 캐릭터 진화 동시 축하
```

**특별 축하 메시지:**
```dart
if (characterEvolved && leveledUp) {
  // "축하합니다! 레벨 5 달성 & Lumi가 Lucid Lumi로 진화했습니다! 🌟"
} else if (leveledUp) {
  // "레벨 업! 레벨 5 달성! 다음 레벨까지 3일 남았습니다."
}
```

---

## 📊 진행 상황 표시

### 1. 홈 화면 레벨 배지
- 위치: DreamStatsCard 상단 좌측
- 크기: 56x56px 원형
- 내용: "Lv X"
- 애니메이션: 레벨업 시 펄스/글로우 효과

### 2. 레벨 진행 바 (선택)
```dart
LinearProgressIndicator(
  value: (currentScore % 3) / 3,  // 다음 레벨까지 진행률
  backgroundColor: Colors.grey[300],
  color: AppColors.primaryColor,
)
```

### 3. 다음 레벨까지 정보
```
"다음 레벨까지 X일 필요"
"XX% 진행 중"
```

---

## 🔔 알림 시스템

### 레벨업 알림 (Local Notification)

**트리거:**
- 체크리스트 완료 후 레벨업 감지 시

**내용:**
```
제목: "🎉 레벨 업!"
내용: "축하합니다! 레벨 5에 도달했습니다!"
액션: 앱 열기 → 레벨업 축하 화면 표시
```

---

## 💾 데이터 저장 구조

### SharedPreferences Keys

```dart
class LevelUpPreferences {
  static const String lastKnownLevel = 'last_known_level';
  static const String lastCheckDate = 'last_level_check_date';
  static const String levelUpCount = 'level_up_count';
  static const String highestLevel = 'highest_level_reached';
}
```

### 저장 시점
1. 레벨업 감지 직후
2. 레벨 계산 시마다 (캐시용)
3. 앱 종료 시

---

## 🎨 UI/UX 설계

### 레벨업 다이얼로그 구성

```
┌─────────────────────────────┐
│   🎉 Confetti Animation     │
│                              │
│      Lv 4 → Lv 5            │
│                              │
│   축하합니다! 레벨업!        │
│                              │
│   ✨ 자각몽 마스터로의 여정   │
│      계속해서 전진하고 있어요! │
│                              │
│   [다음 레벨까지 3일 필요]   │
│                              │
│        [확인] 버튼           │
└─────────────────────────────┘
```

### 캐릭터 진화 동시 발생 시

```
┌─────────────────────────────┐
│   🎉 Confetti Animation     │
│                              │
│  [Lumi 캐릭터 이미지]        │
│                              │
│   🎊 더블 축하! 🎊           │
│                              │
│   레벨 5 달성!               │
│   Aware Lumi → Lucid Lumi!  │
│                              │
│   "이제 꿈을 인식할 수 있어요!"│
│                              │
│        [확인] 버튼           │
└─────────────────────────────┘
```

---

## 🔧 구현 파일 구조

### 새로 생성할 파일

```
lib/
├── services/
│   └── progress/
│       └── level_up_service.dart        # 레벨업 감지 및 추적
├── widgets/
│   └── gamification/
│       ├── level_up_dialog.dart         # 레벨업 축하 다이얼로그
│       └── character_evolution_dialog.dart  # 캐릭터 진화 다이얼로그
└── models/
    └── level_up_result.dart             # 레벨업 결과 데이터 모델
```

### 수정할 파일

```
lib/
├── screens/
│   └── home_screen.dart                 # 레벨업 체크 통합
└── services/
    └── progress/
        └── dream_statistics_service.dart  # 레벨 관련 메서드 추가
```

---

## 🚀 구현 단계

### Phase 2.1: 기본 레벨업 시스템
- [x] 레벨 계산 공식 (이미 구현됨)
- [ ] 레벨업 감지 서비스
- [ ] SharedPreferences 저장/로드
- [ ] 레벨업 다이얼로그 UI

### Phase 2.2: 캐릭터 진화 연동
- [ ] 캐릭터 진화 감지 로직
- [ ] 통합 축하 다이얼로그
- [ ] 캐릭터 이미지 표시

### Phase 2.3: 알림 및 세부 개선
- [ ] 레벨업 로컬 알림
- [ ] 레벨 진행 바
- [ ] 애니메이션 효과
- [ ] 통계 화면에 레벨 히스토리

---

## 📈 성공 지표

### 사용자 참여
- 레벨업을 경험한 사용자 비율
- 레벨업 후 7일 내 재방문율
- 평균 도달 레벨

### 시스템 성능
- 레벨 계산 속도 (<100ms)
- 레벨업 감지 정확도 (100%)
- UI 응답 시간 (<200ms)

---

## 🎯 예상 사용자 경험

### Day 1
- 앱 설치
- 첫 체크리스트 완료
- **레벨 1** (시작)

### Day 3-5
- 꾸준히 훈련 (완료율 70%+)
- **레벨 2 달성!** 🎉
- "축하합니다! 계속 훈련하세요!"

### Day 7 (Week 1 완료)
- Week 1 완료
- **레벨 3 달성 + Lumi → Aware Lumi 진화!** 🌟🎊
- "이중 축하! 꿈의 세계를 인식하기 시작했어요!"

### Day 14 (Week 2 완료)
- **레벨 5-6**
- **Aware Lumi → Lucid Lumi 진화!**
- "자각몽을 인식할 수 있어요!"

### Day 30 (무료 프로그램 완료)
- **레벨 8-10**
- **Lucid Lumi → Dream Walker 진화!**
- "30일 프로그램 완료! 꿈을 자유롭게 걸을 수 있어요!"

### Day 60 (프리미엄 완료)
- **레벨 16-20**
- **Dream Master 도달!** 👑
- "전설 달성! 꿈의 완전한 마스터!"

---

## 🔒 Edge Cases 처리

### 1. 레벨 감소 (완료율 하락)
- **정책**: 레벨은 절대 내려가지 않음
- **이유**: 부정적 경험 방지
- **대신**: "최고 레벨" 기록 유지

### 2. 데이터 동기화 오류
- **복구**: 통계 재계산으로 정확한 레벨 복원
- **경고**: 사용자에게 "레벨 동기화 중" 메시지

### 3. 여러 레벨 동시 상승
- **처리**: 각 레벨마다 개별 축하 (연속 다이얼로그)
- **예**: Lv 3 → Lv 6 (3레벨 상승)
  - "레벨 4 달성!"
  - "레벨 5 달성!"
  - "레벨 6 달성!"

### 4. 오프라인 → 온라인 복귀
- **체크**: 마지막 체크 날짜 확인
- **처리**: 누락된 레벨업 모두 축하

---

## 📝 개발 노트

### 기술 스택
- **상태 관리**: StatefulWidget + FutureBuilder
- **로컬 저장**: SharedPreferences
- **애니메이션**: Confetti package + Flutter 기본 애니메이션
- **알림**: flutter_local_notifications

### 성능 최적화
- 레벨 계산 결과 캐싱 (1분)
- 레벨 체크는 필요 시점에만 실행
- 다이얼로그는 사용자 인터랙션 후에만 표시

---

**설계 작성:** Claude Code Assistant
**마지막 업데이트:** 2025-11-13
**다음 단계:** 레벨업 감지 서비스 구현
