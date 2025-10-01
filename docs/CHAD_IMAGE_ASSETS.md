# 🎨 Chad AI 트레이너 이미지 에셋 요구사항

## 📋 코드 기반 Chad 이미지 매핑 가이드

### 🎯 Chad 캐릭터 기본 설정
**기본 스타일**: 근육질의 친근한 남성 캐릭터, 만화/애니메이션 스타일, 밝고 에너지 넘치는 분위기
**일관성**: 모든 Chad는 같은 캐릭터이지만 상황에 맞는 표정과 포즈
**해상도**: 1:1 비율, 고품질 (최소 512x512px)

---

## 🔥 우선순위 1: 핵심 Chad 이미지 (필수)

### 1. **기본차드.jpg** ⭐⭐⭐
- **현재 상태**: ✅ 존재함, 현재 모든 위치에서 사용 중 (완벽한 상태)
- **용도**: 기본 상태, 보통 컨디션, 일반적인 상황 (현재 모든 Chad 상황의 대표)
- **사용 위치**: 현재 모든 Chad 표시 위치에서 통일적으로 사용
- **상태**: 기존 이미지 완벽 - 추가 작업 불필요
- **기존 MidJourney 스타일**: 친근한 근육질 만화 캐릭터, 자신감 넘치는 미소, 기본 탱크탑, 깔끔한 배경, 애니메 스타일, 밝은 색상, 에너지 넘치는 포즈

---

## 💪 우선순위 2: 컨디션 Chad 이미지 (홈화면 핵심)

### 2. **수면차드.jpg** ⭐⭐⭐
- **용도**:
  - 😴 매우 피곤한 컨디션 (ChadConditionService)
  - 휴식 필요 상태 (ChadRecoveryService - poor)
  - 완전 휴식 활동 (ChadActiveRecoveryService - rest)
- **사용 코드**:
  - `chad_condition_service.dart:173` (veryTired)
  - `chad_recovery_service.dart:283` (poor level)
  - `chad_active_recovery_service.dart:253, 270` (rest activities)
- **MidJourney 프롬프트**:
```
Chad character wearing a sleep cap or beanie, tired but friendly expression, sleepy eyes, yawning, still muscular, cozy/comfortable theme, cartoon anime style, soft blue/purple colors, relaxed pose --ar 1:1
```

### 3. **파워차드.jpg** ⭐⭐⭐
- **용도**:
  - 💪 강한 컨디션 (ChadConditionService)
- **사용 코드**:
  - `chad_condition_service.dart:177` (strong)
- **MidJourney 프롬프트**:
```
Chad character flexing muscles, strong and confident pose, determined expression, peak physical form, workout clothes, cartoon anime style, bold red/orange colors, power stance --ar 1:1
```

### 4. **비스트차드.jpg** ⭐⭐⭐
- **용도**:
  - 🥵 불타는 컨디션 (ChadConditionService)
  - 최고 회복 상태 (ChadRecoveryService - excellent)
- **사용 코드**:
  - `chad_condition_service.dart:181` (onFire)
  - `chad_recovery_service.dart:277` (excellent level)
- **MidJourney 프롬프트**:
```
Chad character in "beast mode", extremely muscular and energetic, fire effects around him, intense determined expression, glowing eyes, workout clothes, cartoon anime style, red/orange fire colors, powerful explosive pose --ar 1:1
```

### 5. **땀차드.jpg** ⭐⭐
- **용도**:
  - 😅 땀나는 컨디션 (ChadConditionService)
- **사용 코드**:
  - `chad_condition_service.dart:179` (sweaty)
- **MidJourney 프롬프트**:
```
Chad character sweating but energetic, droplets of sweat, active and ready expression, workout in progress, athletic clothes, cartoon anime style, bright yellow/orange colors, dynamic action pose --ar 1:1
```

### 6. **쿨차드.jpg** ⭐⭐
- **용도**:
  - 좋은 회복 상태 (ChadRecoveryService - good)
- **사용 코드**:
  - `chad_recovery_service.dart:279` (good level)
- **MidJourney 프롬프트**:
```
Cool Chad character wearing sunglasses, confident smirk, relaxed but strong pose, casual athletic outfit, cartoon anime style, cool blue/green colors, stylish confident stance --ar 1:1
```

---

## 🧘 우선순위 3: 액티브 리커버리 Chad 이미지

### 7. **스트레칭차드.jpg** ⭐⭐
- **용도**:
  - 스트레칭 활동 (ChadActiveRecoveryService - stretching)
- **사용 코드**:
  - `chad_active_recovery_service.dart:149` (stretching activities)
- **MidJourney 프롬프트**:
```
Chad character doing stretching exercises, flexible pose, calm and focused expression, yoga mat, reaching and stretching, cartoon anime style, soft green/blue colors, wellness theme --ar 1:1
```

### 8. **명상차드.jpg** ⭐⭐
- **용도**:
  - 호흡 운동 (ChadActiveRecoveryService - breathing)
  - 마음챙김 (ChadActiveRecoveryService - mindfulness)
- **사용 코드**:
  - `chad_active_recovery_service.dart:189, 231` (breathing, mindfulness)
- **MidJourney 프롬프트**:
```
Chad character in meditation pose, peaceful expression, sitting cross-legged, eyes closed, zen atmosphere, gentle breathing, cartoon anime style, soft purple/blue colors, calming aura effects --ar 1:1
```

### 9. **산책차드.jpg** ⭐⭐
- **용도**:
  - 산책 활동 (ChadActiveRecoveryService - walking)
- **사용 코드**:
  - `chad_active_recovery_service.dart:168` (walking)
- **MidJourney 프롬프트**:
```
Chad character walking casually, relaxed and happy expression, outdoor walking pose, comfortable walking clothes, nature background, cartoon anime style, natural green colors, peaceful mood --ar 1:1
```

### 10. **운동차드.jpg** ⭐
- **용도**:
  - 가벼운 운동 (ChadActiveRecoveryService - lightMovement)
- **사용 코드**:
  - `chad_active_recovery_service.dart:132` (light movement)
- **MidJourney 프롬프트**:
```
Chad character doing light exercise, gentle workout pose, encouraging expression, basic gym clothes, light weights or bodyweight exercise, cartoon anime style, energetic but not intense colors --ar 1:1
```

---

## 🎯 우선순위 4: 온보딩 Chad 이미지 (사용자 첫 경험)

### 11. **환영차드.jpg** ⭐⭐
- **용도**: 온보딩 시작 인사 (ChadOnboardingService - welcome)
- **사용 코드**: `chad_onboarding_service.dart` (welcome step)
- **MidJourney 프롬프트**:
```
Chad character waving hello, big friendly smile, welcoming gesture, approachable pose, casual but fit appearance, cartoon anime style, bright welcoming colors, first meeting vibe --ar 1:1
```

### 12. **완료차드.jpg** ⭐⭐
- **용도**: 온보딩 완료 축하 (ChadOnboardingService - goalSetupComplete)
- **사용 코드**: `chad_onboarding_service.dart` (goalSetupComplete step)
- **MidJourney 프롬프트**:
```
Chad character celebrating success, thumbs up, victorious expression, confetti or celebration effects around him, cartoon anime style, gold/yellow celebration colors, achievement pose --ar 1:1
```

### 13. **목표차드.jpg** ⭐
- **용도**: 목표 설정 단계들 (ChadOnboardingService - goal related)
- **사용 코드**: `chad_onboarding_service.dart` (goal setup steps)
- **MidJourney 프롬프트**:
```
Chad character pointing forward, determined expression, goal-oriented pose, motivational gesture, cartoon anime style, inspiring blue/gold colors, leadership stance --ar 1:1
```

---

## ⚡ 우선순위 5: Chad 진화 이미지 (장기 동기부여)

### 14. **성장차드.jpg** ⭐
- **용도**: Chad 진화 Stage 2 (ChadEvolution)
- **사용 코드**: `chad_evolution.dart` (evolution stages)
- **MidJourney 프롬프트**:
```
Chad character showing growth, slightly more muscular than basic, proud expression, progression theme, cartoon anime style, growth green colors, developing strength pose --ar 1:1
```

### 15. **마스터차드.jpg** ⭐
- **용도**: Chad 진화 Stage 5 (ChadEvolution)
- **사용 코드**: `chad_evolution.dart` (advanced stages)
- **MidJourney 프롬프트**:
```
Chad character as master trainer, very muscular and wise, mentor expression, training others pose, advanced gear, cartoon anime style, master gold/platinum colors, teaching stance --ar 1:1
```

---

## 📁 파일 구조 및 적용 가이드

### 현재 디렉토리 구조
```
assets/
└── images/
    ├── 기본차드.jpg        ✅ (현재 존재 - 완벽함)
    ├── 수면차드.jpg        🆕 (새로 제작 필요 - 우선순위 1)
    ├── 파워차드.jpg        🆕 (새로 제작 필요 - 우선순위 1)
    ├── 비스트차드.jpg      🆕 (새로 제작 필요 - 우선순위 1)
    ├── 땀차드.jpg          🆕 (새로 제작 필요 - 우선순위 2)
    ├── 쿨차드.jpg          🆕 (새로 제작 필요 - 우선순위 2)
    ├── 스트레칭차드.jpg    🆕 (새로 제작 필요 - 우선순위 3)
    ├── 명상차드.jpg        🆕 (새로 제작 필요 - 우선순위 3)
    ├── 산책차드.jpg        🆕 (새로 제작 필요 - 우선순위 3)
    ├── 운동차드.jpg        🆕 (새로 제작 필요 - 우선순위 3)
    ├── 환영차드.jpg        🆕 (새로 제작 필요 - 우선순위 4)
    ├── 완료차드.jpg        🆕 (새로 제작 필요 - 우선순위 4)
    ├── 목표차드.jpg        🆕 (새로 제작 필요 - 우선순위 4)
    ├── 성장차드.jpg        🆕 (새로 제작 필요 - 우선순위 5)
    └── 마스터차드.jpg      🆕 (새로 제작 필요 - 우선순위 5)
```

### 🧹 정리 완료 상태
- ❌ 제거된 부적절한 이미지들: 정면차드.jpg, 더블차드.jpg, 썬글차드.jpg, 수면모자차드.jpg, 눈빔차드.jpg, 커피차드.png
- ✅ 현재 상태: 기본차드.jpg만 남음 (모든 Chad 상황에서 통일적으로 사용 중)
- 🎯 향후 계획: 코드의 실제 용도에 맞는 Chad 이미지들을 순차적으로 제작

### 자동 적용 방법

이미지를 `assets/images/` 폴더에 추가한 후, 다음 명령어로 자동 적용:

```bash
# Chad 이미지 매핑 스크립트 실행 (향후 제공)
dart apply_chad_mapping.dart
```

또는 개별 적용:
1. 해당 파일명으로 이미지를 `assets/images/` 폴더에 저장
2. `flutter clean && flutter pub get` 실행
3. 앱 재시작

---

## 🎨 디자인 일관성 가이드

### Chad 캐릭터 특징 유지
- **얼굴**: 항상 같은 Chad 캐릭터 (일관된 얼굴 형태)
- **체형**: 근육질이지만 친근함 (과도하게 크지 않게)
- **표정**: 상황에 맞지만 항상 긍정적이고 동기부여적
- **색상**: 각 용도별 테마 색상 적용

### 기술적 요구사항
- **형식**: JPG (최적화된 용량)
- **크기**: 1:1 비율 (정사각형)
- **해상도**: 최소 512x512px (권장 1024x1024px)
- **최적화**: 모바일 앱용으로 용량 최적화

---

## 📊 새로운 Chad 이미지 제작 우선순위

### 🔥 Phase 1: 출시용 핵심 이미지 (즉시 필요)
1. **수면차드.jpg** - 피곤한 컨디션, 회복 필요, 휴식 활동 (사용량 최대)
2. **파워차드.jpg** - 강한 컨디션 표현 (홈화면 핵심)
3. **비스트차드.jpg** - 최고 상태, 불타는 컨디션 표현 (동기부여 핵심)

### ⚡ Phase 2: 사용자 경험 향상용
4. **땀차드.jpg** - 운동 중/후 컨디션 표현
5. **쿨차드.jpg** - 좋은 회복 상태 표현
6. **스트레칭차드.jpg** - 액티브 리커버리 스트레칭 활동

### 🎯 Phase 3: 완성도 향상용
7. **명상차드.jpg** - 호흡 운동, 마음챙김 활동
8. **산책차드.jpg** - 산책 활동
9. **환영차드.jpg** - 온보딩 첫 만남

### 🌟 Phase 4: 시스템 완성용
10. **완료차드.jpg** - 성취 축하, 온보딩 완료
11. **운동차드.jpg** - 가벼운 운동 활동
12. **목표차드.jpg** - 목표 설정 단계
13. **성장차드.jpg** - Chad 진화 Stage 2
14. **마스터차드.jpg** - Chad 진화 최고 단계

### 💡 제작 가이드라인
- **일관성**: 모든 Chad는 기본차드.jpg와 같은 캐릭터 (얼굴, 체형 일치)
- **상황별 표현**: 각 상황에 맞는 표정, 포즈, 의상, 배경색
- **품질**: 기본차드.jpg와 동일한 품질 및 스타일 유지

---

**💡 이 문서의 모든 이미지 파일명과 용도는 현재 코드와 1:1 매핑되어 있어, 해당 이름으로 파일을 추가하면 즉시 앱에 반영됩니다!**