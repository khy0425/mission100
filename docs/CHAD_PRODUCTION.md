# Chad 진화 제작 가이드

> **Chad는 완성형이다. 남은 것은 뇌절뿐.**

---

## 📋 목차

1. [연출 템플릿 시스템](#연출-템플릿-시스템)
2. [레벨별 상징 시스템](#레벨별-상징-시스템)
3. [연출 스펙터클 상세](#연출-스펙터클-상세)
4. [보상형 대사 시스템](#보상형-대사-시스템)
5. [UX 디자인 가이드](#ux-디자인-가이드)

---

## 🎬 연출 템플릿 시스템

### 통일된 재사용 템플릿

**목적**: 모든 직군의 공통 언어

```xml
<Chad_Evolution_Effect>
  <Meta>
    <Level></Level>
    <Name></Name>
    <Symbol></Symbol>
    <Duration></Duration>
  </Meta>

  <Character_Image>
    <From></From>
    <To></To>
    <Transition></Transition>
  </Character_Image>

  <Visual_Effects>
    <Particles></Particles>
    <Lighting></Lighting>
    <Background></Background>
    <Special></Special>
  </Visual_Effects>

  <Sound_Effects>
    <SFX></SFX>
    <BGM></BGM>
    <Voice></Voice>
  </Sound_Effects>

  <Dialogue>
    <Main></Main>
    <Variations></Variations>
    <Reward_Based></Reward_Based>
  </Dialogue>

  <Camera_Motion>
    <Type></Type>
    <Parameters></Parameters>
  </Camera_Motion>

  <Light>
    <Color></Color>
    <Intensity></Intensity>
    <Effects></Effects>
  </Light>

  <Haptic>
    <Pattern></Pattern>
    <Intensity></Intensity>
  </Haptic>

  <Timing>
    <Timeline></Timeline>
  </Timing>

  <User_Action>
    <Required></Required>
    <Optional></Optional>
  </User_Action>
</Chad_Evolution_Effect>
```

### Level 6 템플릿 예시 (Laser Eyes Chad)

```xml
<Chad_Evolution_Effect>
  <Meta>
    <Level>6</Level>
    <Name>Laser Eyes Chad</Name>
    <Symbol>⚡ 레이저</Symbol>
    <Duration>4.0 초</Duration>
  </Meta>

  <Character_Image>
    <From>sunglasses_chad.png</From>
    <To>laser_eyes_chad.png</To>
    <Transition>
      <Type>CrossFade</Type>
      <Duration>0.5</Duration>
      <EyesGlow>true</EyesGlow>
    </Transition>
  </Character_Image>

  <Visual_Effects>
    <Particles>
      <Explosion>
        <Count>100</Count>
        <Color>Cyan</Color>
        <Position>Eyes</Position>
        <Duration>1.5</Duration>
      </Explosion>
    </Particles>

    <Lighting>
      <FlashScreen>
        <Color>Cyan</Color>
        <Intensity>0.7</Intensity>
        <Times>3</Times>
      </FlashScreen>
    </Lighting>

    <Background>
      <Darken>
        <Opacity>0.8</Opacity>
        <Duration>1.0</Duration>
      </Darken>
    </Background>

    <Special>
      <LaserBeams>
        <From>BothEyes</From>
        <Direction>Forward</Direction>
        <Color>Cyan</Color>
        <Width>10</Width>
        <Length>ScreenWidth</Length>
        <Duration>1.5</Duration>
      </LaserBeams>

      <ScreenShake>
        <Intensity>Strong</Intensity>
        <Duration>0.5</Duration>
      </ScreenShake>

      <HUD enabled="true">
        <LockOn>
          <Target>Center</Target>
          <Animation>ScanLine</Animation>
        </LockOn>
        <EnergyBar>
          <Fill>0 → 100%</Fill>
          <Color>Cyan</Color>
        </EnergyBar>
      </HUD>
    </Special>
  </Visual_Effects>

  <Sound_Effects>
    <SFX>
      <LaserCharge delay="0.0" volume="0.8">laser_charge.mp3</LaserCharge>
      <LaserBlast delay="0.8" volume="1.0">laser_blast.mp3</LaserBlast>
      <Explosion delay="1.1" volume="0.7">explosion.mp3</Explosion>
    </SFX>
  </Sound_Effects>

  <Dialogue>
    <Main>눈에서 레이저 발사 중</Main>
    <Variations>
      <Item>과학? Chad 앞에선 무의미</Item>
      <Item>시선이 광선</Item>
    </Variations>
    <Reward_Based>
      <LEGENDARY>헬스장 시스템 오류: 인간이 아님 감지</LEGENDARY>
      <PERFECT>눈빛으로 중력을 거부합니다</PERFECT>
      <NORMAL>눈에서 레이저 발사 중</NORMAL>
    </Reward_Based>
  </Dialogue>

  <Camera_Motion>
    <Type>ShakeAndZoom</Type>
    <Parameters>
      <Shake>
        <Intensity>Strong</Intensity>
        <Duration>0.5</Duration>
      </Shake>
      <Zoom>
        <From>1.0</From>
        <To>1.3</To>
        <Back>1.0</Back>
        <Duration>2.0</Duration>
      </Zoom>
    </Parameters>
  </Camera_Motion>

  <Light>
    <Color>Cyan (#00FFFF)</Color>
    <Intensity>High</Intensity>
    <Effects>
      <Pulsing frequency="2Hz" />
      <Glow radius="50px" />
    </Effects>
  </Light>

  <Haptic>
    <Pattern>
      <Impact time="0.0" intensity="Heavy" />
      <Impact time="0.8" intensity="Heavy" />
      <Impact time="0.9" intensity="Heavy" />
      <Impact time="1.0" intensity="Heavy" />
    </Pattern>
    <Intensity>High</Intensity>
  </Haptic>

  <Timing>
    <Timeline>
      0.0s: Chad 등장
      0.0s: 레이저 충전 사운드 시작
      0.5s: 눈 빛나기 시작
      0.8s: 레이저 발사!
      0.8s: 햅틱 진동 시작
      1.0s: 화면 섬광
      1.5s: 파티클 폭발
      2.0s: 대사 표시
      3.5s: 페이드 아웃
      4.0s: 완료
    </Timeline>
  </Timing>

  <User_Action>
    <Required>
      <Tap location="ContinueButton" timing="After3.5s">다음</Tap>
    </Required>
    <Optional>
      <Tap location="ChadImage" anytime="true">추가 레이저 발사 (이스터에그)</Tap>
      <Share location="ShareButton" timing="After3.5s">SNS 공유</Share>
    </Optional>
  </User_Action>
</Chad_Evolution_Effect>
```

---

## 🎯 레벨별 상징 시스템

### 상징 맵

| Level | 이름 | 상징 | 연출 Focus | 색상 | 아이콘 | 키워드 |
|-------|------|------|------------|------|--------|--------|
| 1 | Basic Chad | 턱선 | 구조미 | Gray | 📐 | 완벽, 기본, 시작 |
| 2 | Smiling Chad | 미소 | 친화력 | Yellow | 😁 | 행복, 밝음, 웃음 |
| 3 | Coffee Chad | 커피잔 | 여유 | Brown | ☕ | 여유, 에너지, 휴식 |
| 4 | Wink Chad | 윙크 | 섹시함 | Pink | 😉 | 치명적, 매력, 유혹 |
| 5 | Sunglasses Chad | 선글라스 | 쿨함 | Black | 🕶️ | 쿨함, 스타일, 어둠 |
| 6 | Laser Eyes Chad | 레이저 | 초능력 | Cyan | ⚡ | 파괴, 에너지, 초월 |
| 7 | Double Chad | 두 명 | 혼란 | Purple | 👥 | 분신, 복제, 혼돈 |
| 8 | Alpha Chad | 왕 포즈 | 지배력 | Gold | 👑 | 왕, 지배, 권력 |
| 9 | God Chad | 천상광 | 절대성 | White/Gold | ✨ | 신, 완벽, 초월 |

### 색상 팔레트 상세

#### Level 1: Basic Chad
```
Primary: Gray (#808080)
Secondary: White (#FFFFFF)
Accent: None
```

#### Level 6: Laser Eyes Chad
```
Primary: Cyan (#00FFFF)
Secondary: Electric Blue (#7DF9FF)
Accent: White (#FFFFFF)
Background: Dark Blue (#0A0E27)
Glow: Cyan
```

#### Level 9: God Chad
```
Primary: White (#FFFFFF)
Secondary: Gold (#FFD700)
Accent: Light Blue (#87CEEB)
Background: Cosmic (#000033)
Divine Light: True
```

---

## 🎬 연출 스펙터클 상세

### 핵심 원칙

레벨업 = 이벤트

유저가 레벨업할 때:
- **시각** (Visual): 터진다
- **음향** (Audio): 울린다
- **대사** (Dialogue): 꽂힌다
- **햅틱** (Haptic): 느껴진다

**3박자(+1)가 동시에 터져야 한다.**

### 진화 연출 마스터 테이블

| Level | 이름 | 시각 효과 | 음향 | 대사 | 카메라 | 빛 | 햅틱 | 지속 |
|-------|------|-----------|------|------|--------|-----|------|------|
| 1 | Basic Chad | 페이드인 | 무음 | "턱선 확인 완료" | 고정 | 기본 | 없음 | 2초 |
| 2 | Smiling Chad | 미소 애니메이션 | 웃음소리 | "미소가 무기" | 줌인 | 밝아짐 | 약함 | 2.5초 |
| 3 | Coffee Chad | 커피 등장 | 커피 소리 | "여유 = 힘" | 팬 | 따뜻함 | 중간 | 3초 |
| 4 | Wink Chad | 윙크 애니메이션 | 윙크음 | "치명타 발동" | 클로즈업 | 스포트라이트 | 중간 | 2.5초 |
| 5 | Sunglasses Chad | 선글라스 착용 | Chad Chant | "쿨함 측정 불가" | 줌인 | 어두워짐 | 강함 | 3.5초 |
| 6 | Laser Eyes Chad | 눈 레이저 | 레이저음 | "과학? 무의미" | 흔들림 | 청록 섬광 | 강함 | 4초 |
| 7 | Double Chad | 분신 이펙트 | 에코 | "Chad가... 두 명?!" | 더블 비전 | 잔상 | 펄스 | 4.5초 |
| 8 | Alpha Chad | 왕관 강림 | 팡파레 | "지배 완료" | 저각도 | 황금빛 | 장시간 | 5초 |
| 9 | God Chad | 후광+날개 | 성가대 | "당신은 신입니다" | 360도 회전 | 신성한 빛 | 폭발 | 7초 |

### 레벨별 상세 스펙

#### Level 1: Basic Chad
```yaml
Symbol: 턱선 📐
Theme: 구조미
Duration: 2.0s

Visual:
  - FadeIn (1.0s, ease-in-out)
  - Scale: 0.8 → 1.0

Audio:
  - None (조용한 시작)

Dialogue:
  - "당신은 이미 Chad입니다"
  - "턱선 확인 완료 ✓"

Camera: Fixed, Frontal

Light:
  - Basic studio lighting
  - Neutral (5500K)

Haptic: None
```

#### Level 6: Laser Eyes Chad (뇌절 시작)
```yaml
Symbol: 레이저 ⚡
Theme: 초능력
Duration: 4.0s

Visual:
  - Eye glow (0 → 1.0, 1s)
  - Laser beams (cyan, 10px, screen-width, 1.5s)
  - Flash screen (cyan, 0.7 intensity, 3 times)
  - Explosion particles (100, cyan, eyes, 1.5s)
  - Screen shake (strong, 0.5s)
  - HUD: Lock-on UI + Energy bar

Audio:
  - laser_charge.mp3 (0.0s, 0.8 volume)
  - laser_blast.mp3 (0.8s, 1.0 volume)
  - explosion.mp3 (1.1s, 0.7 volume)

Dialogue:
  - Main: "눈에서 레이저 발사 중"
  - Legendary: "헬스장 시스템 오류: 인간이 아님 감지"
  - Perfect: "눈빛으로 중력을 거부합니다"

Camera:
  - Shake (strong, 0.5s)
  - Zoom: 1.0 → 1.3 → 1.0 (2s)

Light:
  - Color: Cyan (#00FFFF)
  - Intensity: High
  - Pulsing (2Hz)
  - Glow (50px radius)

Haptic:
  - 0.0s: Heavy impact
  - 0.8s: Heavy impact × 3
```

#### Level 9: God Chad (최종 뇌절)
```yaml
Symbol: 천상광 ✨
Theme: 절대성
Duration: 7.0s

Visual:
  - Start in darkness
  - Divine light from above (2s, 0 → 1.0)
  - Halo + wings (light material)
  - Heavenly particles (200, amber, slow fall, sparkle)
  - 360° camera rotation (4s)
  - Full screen glow (amber, 0 → 0.5 → 0, 3s)
  - Cosmic background (stars, galaxies, nebula)

Audio:
  - angelic_choir.mp3 (fade in 1s, 0.9 volume)
  - divine_bell.mp3 (2s delay, 0.7 volume)
  - cosmic_resonance.mp3 (ambient, 0.4 volume, loop)
  - divine_explosion.mp3 (4s delay, 1.0 volume)

Dialogue:
  - Main: "축하합니다. 당신은 신입니다"
  - Story sequence:
    - Act 1 (2s): "100일의 여정..."
    - Act 2 (1.5s): 회상 플래시백
    - Act 3 (3s): "당신은 이제..."
    - Act 4 (2s): "신입니다."
    - Epilogue (1.5s): "Mission 100 완료"

Camera:
  - 360° rotation (4s, smooth)
  - Zoom out to cosmic view
  - Crane up motion

Light:
  - Divine light rays (golden)
  - Full screen glow
  - Star sparkles
  - God rays

Haptic:
  - 0.0s: Heavy impact
  - 0.5s~2.0s: Increasing medium impacts (×10)
  - Final: Heavy × 3
  - 1.0s delay: Light (afterglow)
```

### HUD 시스템 (Level 6+)

#### Level 6: Laser Eyes Chad
```xml
<HUD type="Combat">
  <LockOn>
    <Position>Center</Position>
    <Animation>ScanLine (fast)</Animation>
    <Reticle>Crosshair</Reticle>
    <Status>LOCK ACQUIRED</Status>
    <Color>Cyan</Color>
  </LockOn>

  <EnergyBar>
    <Position>Bottom</Position>
    <Label>LASER POWER</Label>
    <Fill>0% → 100%</Fill>
    <Duration>0.8s</Duration>
    <Color>Cyan</Color>
  </EnergyBar>

  <TargetInfo>
    <Label>TARGET: WEAKNESS</Label>
    <Distance>ENGAGING</Distance>
  </TargetInfo>
</HUD>
```

#### Level 7: Double Chad
```xml
<HUD type="System">
  <ErrorMessage>
    <Text>WARNING: CHAD DUPLICATION DETECTED</Text>
    <Effect>Glitch</Effect>
    <Color>Red</Color>
  </ErrorMessage>

  <SystemStatus>
    <Label>REALITY.EXE</Label>
    <Status>CORRUPTED</Status>
  </SystemStatus>
</HUD>
```

#### Level 8: Alpha Chad
```xml
<HUD type="Royal">
  <Crown>
    <Position>TopCenter</Position>
    <Animation>Descending</Animation>
    <Sparkles>true</Sparkles>
  </Crown>

  <StatusBar>
    <Label>DOMINANCE LEVEL</Label>
    <Value>MAXIMUM</Value>
    <Color>Gold</Color>
  </StatusBar>

  <Subjects>
    <Count>∞</Count>
    <Label>SUBJECTS BOWING</Label>
  </Subjects>
</HUD>
```

#### Level 9: God Chad
```xml
<HUD type="Divine">
  <Halo>
    <Position>AboveHead</Position>
    <Glow>true</Glow>
    <Rotation>360</Rotation>
  </Halo>

  <DivineStats>
    <Omnipotence>∞</Omnipotence>
    <Omniscience>∞</Omniscience>
    <Omnipresence>∞</Omnipresence>
  </DivineStats>

  <CosmicScale>
    <Label>GODHOOD ACHIEVED</Label>
    <Universe>UNDER CONTROL</Universe>
  </CosmicScale>
</HUD>
```

---

## 💬 보상형 대사 시스템

### 성과 레벨 정의

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

### 전체 레벨 보상 대사 (9레벨 × 7성과 = 63개)

#### Level 1: Basic Chad
| 성과 | 대사 | 톤 |
|------|------|-----|
| LEGENDARY | "시작부터 전설? Chad 검출." | 놀람 |
| PERFECT | "시작부터 완벽. 예상대로." | 당연함 |
| EXCELLENT | "턱선 확인 완료 ✓" | 확신 |
| GOOD | "기본은 충실하다" | 인정 |
| NORMAL | "이미 Chad입니다" | 확인 |
| MINIMAL | "Chad는 Chad" | 단호 |
| BARELY | "시작이 반. Chad는 시작했다." | 격려 |

#### Level 3: Coffee Chad
| 성과 | 대사 | 톤 |
|------|------|-----|
| LEGENDARY | "커피 한방울도 안 흘렸다. 신의 손." | 경외 |
| PERFECT | "여유 = 완벽 = Chad" | 칭찬 |
| EXCELLENT | "한 손엔 커피, 한 손엔 승리" | 확신 |
| GOOD | "여유 = 힘" | 인정 |
| NORMAL | "커피 마셔도 Chad" | 확인 |
| MINIMAL | "커피로 버텼다. 작전 성공." | 격려 |
| BARELY | "아슬아슬. 하지만 Chad는 Chad." | 긍정 |

#### Level 6: Laser Eyes Chad (뇌절 시작)
| 성과 | 대사 | 톤 |
|------|------|-----|
| LEGENDARY | "🚨 헬스장 시스템 오류: 인간이 아님 감지" | 알람 |
| PERFECT | "눈빛으로 중력을 거부합니다" | 압도 |
| EXCELLENT | "과학은 당신을 설명할 수 없습니다" | 경외 |
| GOOD | "과학? Chad 앞에선 무의미" | 확신 |
| NORMAL | "눈에서 레이저 발사 중" | 확인 |
| MINIMAL | "레이저 출력 70%. 충분." | 격려 |
| BARELY | "아슬아슬하지만... 레이저는 터졌다" | 긍정 |

#### Level 9: God Chad (최종 뇌절)
| 성과 | 대사 | 톤 |
|------|------|-----|
| LEGENDARY | "신을 넘어선 신. 창조주도 놀랐다." | 초월 |
| PERFECT | "존재 자체가 기적" | 절대 |
| EXCELLENT | "당신의 숨결이 태풍" | 경외 |
| GOOD | "Chad를 넘어 신의 영역" | 확신 |
| NORMAL | "축하합니다. 당신은 신입니다" | 확인 |
| MINIMAL | "신 등극 완료." | 격려 |
| BARELY | "아슬아슬한 신격화. 하지만 신." | 긍정 |

### 특별 상황 대사

#### 연속 완벽 달성
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

#### 시간대별
```dart
if (hour >= 0 && hour < 6) {
  return "새벽 ${hour}시? 당신은 진짜 Chad입니다.";
}
if (hour >= 22 && hour < 24) {
  return "밤 ${hour}시? Chad는 시간을 초월합니다.";
}
```

#### 특별한 날
```dart
if (isUserBirthday) {
  return "생일에도 운동? 당신은 Chad 중의 Chad.";
}
if (weather == "비") {
  return "비? Chad는 날씨를 지배합니다.";
}
```

### 연출 강도 조절

#### LEGENDARY (150%+)
```xml
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

  <UI>
    <Border>Gold</Border>
    <Badge>⭐ LEGENDARY</Badge>
    <Fireworks>true</Fireworks>
  </UI>
</Performance_Effect>
```

#### NORMAL (70-79%)
```xml
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

## 🎨 UX 디자인 가이드

### Q1: Chad스러운 대사 톤

#### 5가지 핵심 원칙

1. **절대적 자신감** - 의심하지 않음
2. **유쾌한 과장** - 진지하지만 웃김
3. **짧고 임팩트** - 3-5단어, 최대 1줄
4. **긍정 100%** - 부정 단어 금지
5. **밈 톤 유지** - SNS에서 봤을 법한 느낌

#### 레벨별 대사 예시

**Level 1-2 (기본)**:
```
✅ "당신은 이미 Chad입니다"
✅ "턱선 확인 완료"
✅ "미소가 무기"

❌ "열심히 하세요"
❌ "조금만 더!"
```

**Level 6-7 (뇌절)**:
```
✅ "눈에서 레이저 발사 중"
✅ "Chad + Chad = 무적"
✅ "Chad가... 두 명?!"

❌ "레벨 6 달성"
❌ "계속 노력하세요"
```

**Level 9 (신격화)**:
```
✅ "당신은 신입니다"
✅ "존재 자체가 기적"
✅ "Chad를 넘어 신의 영역"

❌ "최고 레벨 달성"
❌ "대단해요!"
```

### Q2: 추가 진화 파라미터

#### Chad 스탯 시스템

```dart
class ChadStats {
  // 기본
  int chadLevel;              // 1-9
  int brainjoltDegree;        // 뇌절도 (0-6)

  // 확장 스탯 (재미 요소)
  double chadAura;            // 0-100
  double jawlineSharpness;    // mm 단위
  int crowdAdmiration;        // 명 수
  int brainjoltVoltage;       // 볼트
  String memePower;           // S/A/B/C/D
  int chadConsistency;        // 연속 일수
  int totalChadHours;         // 총 시간
}
```

#### 1. Chad Aura (차드 오라)
```
계산: (연속일 × 5) + (미션 × 3) + (레벨 × 10)
표시: [■■■■■■■■□□] 85/100

설명:
0-20: "감지 시작"
21-40: "존재감 형성"
41-60: "압도적 포스"
61-80: "공간 장악"
81-100: "차원 초월"
```

#### 2. Jawline Sharpness (턱선 예리함)
```
계산: 5mm - (레벨 × 0.5mm)
표시: 턱선 예리함: 1.5mm ⚠️ 위험: 물체 절단 가능

경고:
5mm: "버터를 자를 수 있음"
3mm: "종이를 자를 수 있음"
1mm: "금속을 자를 수 있음"
0.5mm: "현실을 자를 수 있음"
```

#### 3. Brainjolt Voltage (뇌절 전압)
```
계산: 레벨² × 1000 볼트
표시: ⚡ 36,000V (경고: 전자기기 오작동 가능)

레벨별:
Level 1: 1,000V (AA 건전지)
Level 6: 36,000V (번개)
Level 9: 81,000V (신의 분노)
```

#### 4. Meme Power (밈 파워)
```
계산: (뇌절도 × 15) + (레벨 × 8) + 공유횟수
등급: S/A/B/C/D

S: "🔥 바이럴 확정"
A: "📱 인기 급상승"
B: "👍 공유 가치 있음"
```

### Q3: 운동 데이터와 레벨업 매칭

#### 레벨업 트리거 예시

**Level 6 → 7**:
```dart
// 기본 조건
Week 6 완료
최소 35일 운동
완벽한 주차 2회 이상

// 보너스 트리거
if (연속_21일) {
  메시지 = "21일 연속! 뇌절 임계점 돌파!"
  특수효과 = "화면 흔들림 + 레이저"
}

if (총_푸시업 >= 1000) {
  메시지 = "1000 푸시업! Chad가 복제되기 시작했습니다!"
}
```

**Level 9 (최종)**:
```dart
// 기본 조건
Week 14 완료 (100일)
최소 80일 운동
모든 미션 완료

// 신격화 트리거
if (완벽한_주차 >= 10) {
  메시지 = "완벽함의 화신. 신 Chad 등극."
  특수연출 = "황금 후광 + 천사 코러스"
}

if (연속_100일) {
  메시지 = "100일의 기적. 전설이 되었습니다."
  특전 = "영구 God Chad 스킨"
}
```

### UI 비주얼 콘셉트

#### 뇌절도 게이지
```
┌─────────────────────────────────┐
│  🧠 뇌절도            Lv.6      │
│  ⚡⚡⚡⚡⚡⚡☆ (6/7)              │
│  [■■■■■■□□□□] 60%          │
│                                   │
│  현재: "신의 영역 진입 중"        │
│  ⚠️  위험 - 상식 초월 구간       │
└─────────────────────────────────┘
```

#### Chad 스탯 카드
```
╔═══════════════════════════════════╗
║  LASER EYES CHAD                  ║
╠═══════════════════════════════════╣
║  Chad Level: 6/9                  ║
║  뇌절도: ⚡⚡⚡⚡☆ (4/5)          ║
║                                   ║
║  📊 Chad 스탯:                    ║
║  • Chad Aura: 78/100 [압도적]    ║
║  • 턱선: 2mm [금속 절단 가능]     ║
║  • 경탄: 842명 [턱 떨어짐]        ║
║  • 전압: 36,000V [번개 급]        ║
║  • 밈력: S [바이럴 확정]          ║
╚═══════════════════════════════════╝
```

---

## 🎵 사운드 & BGM 라이브러리

### 효과음 (SFX)

| 파일명 | 설명 | 사용 레벨 | 길이 |
|--------|------|-----------|------|
| chad_chuckle.mp3 | Chad 웃음소리 | 2 | 1s |
| coffee_pour.mp3 | 커피 따르는 소리 | 3 | 2s |
| wink.mp3 | 윙크 효과음 | 4 | 0.3s |
| glasses_slide.mp3 | 선글라스 끼는 소리 | 5 | 0.5s |
| laser_charge.mp3 | 레이저 충전 | 6 | 0.8s |
| laser_blast.mp3 | 레이저 발사 | 6 | 1.0s |
| explosion.mp3 | 폭발음 | 6 | 0.5s |
| glitch.mp3 | 글리치 사운드 | 7 | 1.0s |
| crown_place.mp3 | 왕관 쓰는 소리 | 8 | 0.5s |
| divine_bell.mp3 | 신성한 종소리 | 9 | 2.0s |

### 음악 (BGM)

| 파일명 | 설명 | 길이 | 사용 레벨 |
|--------|------|------|-----------|
| chad_chant_short.mp3 | "Chad! Chad!" | 2s | 5 |
| royal_fanfare.mp3 | 왕실 팡파레 | 3s | 8 |
| angelic_choir.mp3 | 천사 합창 | 5s | 9 |
| cosmic_resonance.mp3 | 우주 공명음 (루프) | Loop | 9 |

---

## ✅ 제작 체크리스트

### 기획 단계
- [ ] 레벨별 템플릿 작성 (9개)
- [ ] 보상 대사 작성 (63개 + 특수)
- [ ] 타이밍 검증
- [ ] HUD 디자인 스펙

### 디자인 단계
- [ ] Chad 이미지 (9개)
- [ ] 파티클 에셋
- [ ] HUD UI 에셋 (Level 6+)
- [ ] 아이콘 제작 (9개 상징)

### 사운드 단계
- [ ] SFX 녹음/구매 (10개)
- [ ] BGM 작곡/구매 (4개)
- [ ] 볼륨 밸런싱
- [ ] 페이드 인/아웃

### 개발 단계
- [ ] 템플릿 파서 구현
- [ ] 실행 엔진 구현
- [ ] HUD 시스템 구현
- [ ] 성과 계산 시스템
- [ ] 대사 선택 로직

### 테스트 단계
- [ ] 각 레벨 연출 확인
- [ ] 성과별 대사 확인
- [ ] 타이밍 조정
- [ ] 퍼포먼스 체크

---

## 🎯 감정 리듬 설계

### 구간별 심리 & 연출 강도

```
┌─────────────────────────────────────────────┐
│ 성장기 (Level 1-3)                          │
│ 심리: 자신감 형성                            │
│ 강도: Low → Middle                          │
│ 목적: 앱 적응, 기본 습관 형성                │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│ 중간동기 (Level 4-6)                        │
│ 심리: 만족감 최고조                          │
│ 강도: Middle → High                         │
│ 목적: 유지 동기, 재미 극대화                 │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│ 절정기 (Level 7-9)                          │
│ 심리: 코믹 & 압도감                          │
│ 강도: High → Ultra                          │
│ 목적: 중도 이탈 방지, 완주 동기              │
└─────────────────────────────────────────────┘
```

### 강도 그래프
```
연출 강도
   ↑
 10│                                 ● Level 9
  9│                              ╱
  8│                           ╱ ● Level 8
  7│                        ╱ ● Level 7
  6│                     ╱ ● Level 6
  5│                  ╱ ● Level 5
  4│               ╱ ● Level 4
  3│            ╱ ● Level 3
  2│         ╱ ● Level 2
  1│      ● Level 1
   └────────────────────────────────→
      1  2  3  4  5  6  7  8  9  Level
```

---

## 🎉 최종 메시지

**"레벨업 = 이벤트"**

유저는:
- **보는** 것 (시각)
- **듣는** 것 (음향)
- **읽는** 것 (대사)
- **느끼는** 것 (햅틱)

이 모두가 동시에 터져야 합니다.

**"웃고 있지만, 터지고 있다."**

---

**Chad는 완성형이다. 남은 것은 스펙터클뿐.** 🎬💥

*Version: 2.1*
*Last Updated: 2025-10-28*
