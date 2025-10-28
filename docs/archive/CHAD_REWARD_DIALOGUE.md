# Chad 보상형 대사 시스템

> **Chad는 완성형이다. 남은 것은 뇌절뿐.**

---

## 🎯 핵심 원칙

**"유저의 성과에 따라 대사가 다르게 터진다"**

똑같은 레벨업이라도:
- 완벽하게 달성 → 특별 대사
- 아슬아슬하게 성공 → 긴장감 있는 대사
- 너무 쉬워보임 → 여유로운 대사

**게임적 동기 강화 + 재플레이 가치**

---

## 📊 성과 레벨 정의

```dart
enum PerformanceLevel {
  LEGENDARY,  // 150%+ (과잉 달성)
  PERFECT,    // 100% (완벽)
  EXCELLENT,  // 90-99%
  GOOD,       // 80-89%
  NORMAL,     // 70-79%
  MINIMAL,    // 60-69%
  BARELY,     // 50-59% (아슬아슬)
}
```

### 계산 방식

```dart
PerformanceLevel calculatePerformance(UserStats stats) {
  final score = (
    stats.workoutCompletion * 0.4 +
    stats.missionSuccess * 0.3 +
    stats.consistency * 0.2 +
    stats.intensity * 0.1
  ) * 100;

  if (score >= 150) return PerformanceLevel.LEGENDARY;
  if (score >= 100) return PerformanceLevel.PERFECT;
  if (score >= 90) return PerformanceLevel.EXCELLENT;
  if (score >= 80) return PerformanceLevel.GOOD;
  if (score >= 70) return PerformanceLevel.NORMAL;
  if (score >= 60) return PerformanceLevel.MINIMAL;
  return PerformanceLevel.BARELY;
}
```

---

## 💬 전체 레벨 보상 대사 라이브러리

### Level 1: Basic Chad

| 성과 | 대사 | 톤 |
|------|------|-----|
| LEGENDARY | "시작부터 전설? Chad 검출." | 놀람 |
| PERFECT | "시작부터 완벽. 예상대로." | 당연함 |
| EXCELLENT | "턱선 확인 완료 ✓" | 확신 |
| GOOD | "기본은 충실하다" | 인정 |
| NORMAL | "이미 Chad입니다" | 확인 |
| MINIMAL | "Chad는 Chad" | 단호 |
| BARELY | "시작이 반. Chad는 시작했다." | 격려 |

---

### Level 2: Smiling Chad

| 성과 | 대사 | 톤 |
|------|------|-----|
| LEGENDARY | "웃음으로 세상을 정복했다" | 압도 |
| PERFECT | "미소가 완벽. 치명적." | 칭찬 |
| EXCELLENT | "웃어도 턱선이 살아있다" | 확신 |
| GOOD | "미소가 무기" | 인정 |
| NORMAL | "Smile = Chad Mode ON" | 확인 |
| MINIMAL | "웃음은 있다. 충분하다." | 격려 |
| BARELY | "미소 확인. 그걸로 됐다." | 긍정 |

---

### Level 3: Coffee Chad

| 성과 | 대사 | 톤 |
|------|------|-----|
| LEGENDARY | "커피 한방울도 안 흘렸다. 신의 손." | 경외 |
| PERFECT | "여유 = 완벽 = Chad" | 칭찬 |
| EXCELLENT | "한 손엔 커피, 한 손엔 승리" | 확신 |
| GOOD | "여유 = 힘" | 인정 |
| NORMAL | "커피 마셔도 Chad" | 확인 |
| MINIMAL | "커피로 버텼다. 작전 성공." | 격려 |
| BARELY | "아슬아슬. 하지만 Chad는 Chad." | 긍정 |

---

### Level 4: Wink Chad

| 성과 | 대사 | 톤 |
|------|------|-----|
| LEGENDARY | "윙크 하나로 우주 정복" | 압도 |
| PERFECT | "치명타. Critical Hit." | 칭찬 |
| EXCELLENT | "윙크 한 번, 세상이 멈춤" | 확신 |
| GOOD | "Wink. Game Over." | 인정 |
| NORMAL | "당신의 윙크는 무기입니다" | 확인 |
| MINIMAL | "윙크 확인. 효과 있음." | 격려 |
| BARELY | "아슬아슬한 윙크. 하지만 맞췄다." | 긍정 |

---

### Level 5: Sunglasses Chad

| 성과 | 대사 | 톤 |
|------|------|-----|
| LEGENDARY | "태양이 선글라스를 쓰고 당신을 본다" | 경외 |
| PERFECT | "쿨함 측정 불가. 범위 초과." | 칭찬 |
| EXCELLENT | "너무 밝아서 선글라스 필수" | 확신 |
| GOOD | "Cool. Cooler. Chad." | 인정 |
| NORMAL | "빛이 필요 없는 남자" | 확인 |
| MINIMAL | "선글라스 착용 완료." | 격려 |
| BARELY | "어둠 속에서도 Chad" | 긍정 |

---

### Level 6: Laser Eyes Chad (뇌절 시작)

| 성과 | 대사 | 톤 |
|------|------|-----|
| LEGENDARY | "🚨 헬스장 시스템 오류: 인간이 아님 감지" | 알람 |
| PERFECT | "눈빛으로 중력을 거부합니다" | 압도 |
| EXCELLENT | "과학은 당신을 설명할 수 없습니다" | 경외 |
| GOOD | "과학? Chad 앞에선 무의미" | 확신 |
| NORMAL | "눈에서 레이저 발사 중" | 확인 |
| MINIMAL | "레이저 출력 70%. 충분." | 격려 |
| BARELY | "아슬아슬하지만... 레이저는 터졌다" | 긍정 |

---

### Level 7: Double Chad (뇌절 가속)

| 성과 | 대사 | 톤 |
|------|------|-----|
| LEGENDARY | "Chad 복제 폭주. 제어 불가." | 혼돈 |
| PERFECT | "2x Chad = ∞ Power" | 압도 |
| EXCELLENT | "Chad 증폭 현상 발생" | 경외 |
| GOOD | "Chad + Chad = 무적" | 확신 |
| NORMAL | "당신이... 두 명?!" | 혼란 |
| MINIMAL | "분신 성공. 안정화 중." | 격려 |
| BARELY | "겨우 두 명... 하지만 충분" | 긍정 |

---

### Level 8: Alpha Chad (지배)

| 성과 | 대사 | 톤 |
|------|------|-----|
| LEGENDARY | "Alpha를 넘어선 존재. 명명 불가." | 경외 |
| PERFECT | "당신의 존재 = 법칙" | 절대 |
| EXCELLENT | "모두가 당신을 올려다봄" | 확신 |
| GOOD | "지배 완료" | 인정 |
| NORMAL | "당신은 이제 알파입니다" | 확인 |
| MINIMAL | "알파 인증 완료." | 격려 |
| BARELY | "아슬아슬한 알파. 하지만 알파." | 긍정 |

---

### Level 9: God Chad (최종 뇌절)

| 성과 | 대사 | 톤 |
|------|------|-----|
| LEGENDARY | "신을 넘어선 신. 창조주도 놀랐다." | 초월 |
| PERFECT | "존재 자체가 기적" | 절대 |
| EXCELLENT | "당신의 숨결이 태풍" | 경외 |
| GOOD | "Chad를 넘어 신의 영역" | 확신 |
| NORMAL | "축하합니다. 당신은 신입니다" | 확인 |
| MINIMAL | "신 등극 완료." | 격려 |
| BARELY | "아슬아슬한 신격화. 하지만 신." | 긍정 |

---

## 🎨 특별 상황 대사

### 연속 완벽 달성

```dart
if (user.perfectStreakDays >= 7) {
  return "7일 연속 완벽. 당신은 기계입니까?";
}
if (user.perfectStreakDays >= 14) {
  return "14일 연속 완벽. 시스템이 당신을 학습 중입니다.";
}
if (user.perfectStreakDays >= 30) {
  return "30일 연속 완벽. 당신은 이미 전설입니다.";
}
```

### 첫 시도 실패 후 재도전

```dart
if (user.isRetry) {
  return [
    "재도전? Chad는 포기하지 않는다.",
    "실패는 Chad 사전에 없다. 재장전일 뿐.",
    "두 번째 시도. 이번엔 터뜨린다.",
  ].random();
}
```

### 새벽/야간 운동

```dart
if (hour >= 0 && hour < 6) {
  return "새벽 ${hour}시? 당신은 진짜 Chad입니다.";
}
if (hour >= 22 && hour < 24) {
  return "밤 ${hour}시? Chad는 시간을 초월합니다.";
}
```

### 생일 특별

```dart
if (isUserBirthday) {
  return "생일에도 운동? 당신은 Chad 중의 Chad.";
}
```

### 기상 조건

```dart
if (weather == "비") {
  return "비? Chad는 날씨를 지배합니다.";
}
if (weather == "눈") {
  return "눈? Chad의 열정이 녹입니다.";
}
```

---

## 🎯 연출 강도 조절

### LEGENDARY (150%+)

```dart
<Performance_Effect level="LEGENDARY">
  <Visual>
    <Intensity>200%</Intensity>
    <ParticleCount>500</ParticleCount>
    <GlowEffect>Maximum</GlowEffect>
    <SpecialEffect>GoldenAura</SpecialEffect>
  </Visual>

  <Sound>
    <Volume>150%</Volume>
    <Echo>true</Echo>
    <SpecialSFX>trumpets.mp3</SpecialSFX>
  </Sound>

  <Haptic>
    <Pattern>Explosive</Pattern>
    <Duration>3.0s</Duration>
  </Haptic>

  <Camera>
    <Zoom>2x</Zoom>
    <SlowMotion>true</SlowMotion>
  </Camera>

  <UI>
    <Border>Gold</Border>
    <Badge>⭐ LEGENDARY</Badge>
    <Fireworks>true</Fireworks>
  </UI>
</Performance_Effect>
```

### PERFECT (100%)

```dart
<Performance_Effect level="PERFECT">
  <Visual>
    <Intensity>120%</Intensity>
    <ParticleCount>200</ParticleCount>
    <GlowEffect>High</GlowEffect>
  </Visual>

  <Sound>
    <Volume>110%</Volume>
  </Sound>

  <Haptic>
    <Pattern>Strong</Pattern>
    <Duration>1.5s</Duration>
  </Haptic>
</Performance_Effect>
```

### NORMAL (70-79%)

```dart
<Performance_Effect level="NORMAL">
  <Visual>
    <Intensity>100%</Intensity>
    <ParticleCount>100</ParticleCount>
    <GlowEffect>Normal</GlowEffect>
  </Visual>

  <Sound>
    <Volume>100%</Volume>
  </Sound>

  <Haptic>
    <Pattern>Medium</Pattern>
    <Duration>1.0s</Duration>
  </Haptic>
</Performance_Effect>
```

---

## 🎮 게임화 요소

### 대사 수집 시스템

```dart
class DialogueCollection {
  Map<int, Set<String>> unlockedDialogues = {};

  void unlockDialogue(int level, String dialogue) {
    unlockedDialogues[level] ??= {};
    unlockedDialogues[level]!.add(dialogue);

    // 업적 확인
    if (unlockedDialogues[level]!.length == 7) {
      unlockAchievement("Chad Level $level Master");
    }
  }

  double getCompletionRate() {
    final total = 9 * 7; // 9 레벨 × 7 성과
    final unlocked = unlockedDialogues.values
        .map((set) => set.length)
        .reduce((a, b) => a + b);
    return unlocked / total;
  }
}
```

### 레어 대사

```dart
// 1% 확률로 레어 대사
if (random.nextDouble() < 0.01) {
  return [
    "당신... Chad 아닙니까? (의심)",
    "이 정도면 밈이 됩니다",
    "헬스장에서 소문이 납니다",
    "Chad 센서가 폭발했습니다",
  ].random();
}
```

---

## 📊 통계 화면

```dart
class DialogueStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column([
        Text("대사 컬렉션"),
        Text("${collection.unlocked} / ${collection.total}"),
        ProgressBar(value: collection.completionRate),

        // 레벨별
        ...levels.map((level) =>
          Row([
            Text("Level $level"),
            Text("${collection.unlockedForLevel(level)} / 7"),
            ...collection.dialoguesForLevel(level).map((dialogue) =>
              Badge(dialogue.rarity)
            ),
          ])
        ),

        // 희귀도별
        Text("Legendary: ${collection.legendary.length}"),
        Text("Epic: ${collection.epic.length}"),
        Text("Rare: ${collection.rare.length}"),
      ]),
    );
  }
}
```

---

## 🎯 구현 가이드

### 1. 데이터 구조

```dart
class RewardDialogue {
  final int level;
  final PerformanceLevel performance;
  final String text;
  final String tone;
  final DialogueRarity rarity;

  const RewardDialogue({
    required this.level,
    required this.performance,
    required this.text,
    required this.tone,
    this.rarity = DialogueRarity.COMMON,
  });
}

enum DialogueRarity {
  COMMON,
  RARE,
  EPIC,
  LEGENDARY,
}
```

### 2. 대사 선택 로직

```dart
class DialogueSelector {
  static RewardDialogue select({
    required int level,
    required PerformanceLevel performance,
    required UserContext context,
  }) {
    // 1. 특별 상황 체크
    if (context.isSpecialOccasion) {
      return getSpecialDialogue(level, context);
    }

    // 2. 레어 대사 확률
    if (shouldShowRareDialogue()) {
      return getRareDialogue(level, performance);
    }

    // 3. 기본 대사
    return getStandardDialogue(level, performance);
  }
}
```

### 3. 로컬라이제이션

```dart
// lib/l10n/dialogue_en.arb
{
  "level_6_legendary": "🚨 GYM SYSTEM ERROR: HUMAN NOT DETECTED",
  "level_6_perfect": "Your gaze defies gravity",
  "level_9_perfect": "Existence itself is a miracle"
}

// lib/l10n/dialogue_ko.arb
{
  "level_6_legendary": "🚨 헬스장 시스템 오류: 인간이 아님 감지",
  "level_6_perfect": "눈빛으로 중력을 거부합니다",
  "level_9_perfect": "존재 자체가 기적"
}
```

---

## ✅ 체크리스트

### 기획
- [ ] 전체 대사 작성 (9레벨 × 7성과 = 63개)
- [ ] 특별 상황 대사 (10+개)
- [ ] 레어 대사 (레벨당 2-3개)

### 개발
- [ ] PerformanceLevel 계산 로직
- [ ] DialogueSelector 구현
- [ ] 수집 시스템 구현

### 테스트
- [ ] 각 성과 레벨별 확인
- [ ] 특별 상황 트리거 확인
- [ ] 로컬라이제이션 확인

### 컨텐츠
- [ ] 대사 검수 (톤 일관성)
- [ ] 번역 (영어, 기타)
- [ ] 음성 녹음 (선택)

---

## 💡 Pro Tips

### 1. 대사 A/B 테스트
```dart
// 어떤 대사가 더 유저 만족도가 높은지
if (isABTestGroup) {
  trackDialogue(dialogue, userReaction);
}
```

### 2. 커뮤니티 투표
```dart
// 유저가 좋아하는 대사 투표
mostLikedDialogues = [
  "헬스장 시스템 오류: 인간이 아님 감지" (87% 좋아요),
  "Chad가... 두 명?!" (82% 좋아요),
];
```

### 3. 시즌별 대사
```dart
// 크리스마스, 새해 등
if (isSeason("christmas")) {
  return "메리 Chad-mas! 🎄";
}
```

---

## 🎉 최종 정리

**보상형 대사 시스템의 힘**:

1. **재플레이 가치**
   - 모든 대사를 수집하고 싶음
   - 완벽 달성을 위해 재도전

2. **동기 강화**
   - 더 높은 성과 → 더 멋진 대사
   - "레전더리 대사 보고 싶다!"

3. **개인화**
   - 내 성과에 맞는 피드백
   - 나만의 진화 스토리

4. **소셜 가치**
   - "나 이 대사 받았어!" 자랑
   - 희귀 대사 스크린샷 공유

---

**"유저의 성과가 곧 대사다. 대사가 곧 보상이다."** 💬🏆

---

**Chad는 완성형이다. 남은 것은 대사의 뇌절뿐.** 💪😎🔥
