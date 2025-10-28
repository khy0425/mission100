# 🎨 Mission100 온보딩 이미지 - MidJourney 프롬프트

> Chad 캐릭터의 일관성을 유지하며 온보딩 화면용 이미지 생성

## 📋 목차

1. [캐릭터 일관성 가이드](#캐릭터-일관성-가이드)
2. [온보딩 이미지 6개](#온보딩-이미지-6개)
3. [앱 아이콘](#앱-아이콘)
4. [Feature Graphic](#feature-graphic)
5. [생성 순서 및 팁](#생성-순서-및-팁)

---

## 🎯 캐릭터 일관성 가이드

### Chad 캐릭터 핵심 특징

기존 진화 이미지에서 추출한 Chad의 핵심 특징:

```
✅ 유지해야 할 특징:
- 근육질 남성 캐릭터
- 유쾌하고 긍정적인 표정
- 만화/일러스트 스타일 (realistic하지 않음)
- 심플하고 깔끔한 배경
- 밝은 색상 (보라색, 파란색, 금색 계열)

❌ 피해야 할 것:
- 너무 사실적인 표현 (realistic photo)
- 어두운 분위기
- 복잡한 배경
- 무서운 표정 (Chad는 유쾌해야 함!)
```

### Character Reference 전략

**옵션 1: 기존 Chad 이미지 사용 (권장)**
```
--cref [기존 Chad 이미지 URL]
--cw 80  (Character Weight: 약간 유연하게)
```

**옵션 2: 텍스트 설명만 사용**
```
"cheerful muscular character, cartoon style, friendly smile,
simple clean design, positive energy, bright colors"
```

---

## 📱 온보딩 이미지 6개

### 1️⃣ onboarding_1_welcome.png (환영 포즈)

**목적**: 앱의 첫인상, 따뜻한 환영

**MidJourney 프롬프트:**

```
Chad character welcoming pose, cheerful muscular man waving hello,
friendly smile, cartoon illustration style, simple gradient background
purple to blue, motivational and inviting, clean modern design,
mobile app onboarding illustration --ar 9:16 --s 40
```

**--cref 사용 시:**
```
Chad character welcoming pose, waving hello with big smile,
cartoon illustration style, simple gradient background purple to blue,
motivational and inviting --ar 9:16 --cref [rookie_chad.png URL] --cw 80 --s 40
```

**배경색**: 보라색 → 파란색 그라데이션
**크기**: 1080×1920 (9:16 비율)
**분위기**: 따뜻하고 환영하는

---

### 2️⃣ onboarding_2_science.png (과학적 근거)

**목적**: 신뢰성 전달, 연구 기반

**MidJourney 프롬프트:**

```
Chad character in scientist pose, holding clipboard or tablet,
confident expression, cartoon style, background with subtle science
elements (molecules, graphs), professional yet friendly,
blue and white color scheme, mobile app illustration --ar 9:16 --s 40
```

**--cref 사용 시:**
```
Chad character holding clipboard with confident smile,
scientist pose but friendly, cartoon style, blue background
with subtle graph elements --ar 9:16 --cref [alpha_chad.png URL] --cw 80 --s 40
```

**배경색**: 파란색 → 흰색 (전문적)
**크기**: 1080×1920
**분위기**: 신뢰할 수 있는, 전문적

**추가 요소**:
- 그래프 아이콘 (옵션)
- 하버드 로고 영역 (별도 추가 예정)

---

### 3️⃣ onboarding_3_program_14weeks.png (14주 프로그램)

**목적**: 진화 과정 시각화, 14주 여정

**MidJourney 프롬프트:**

```
Chad character evolution journey, showing progression from beginner
to champion, 7 stages in a row, comic book style transformation,
timeline visualization, motivational and inspiring, gradient background
purple to gold, mobile app illustration --ar 9:16 --s 40
```

**--cref 사용 시:**
```
Chad character transformation timeline, showing 3 key stages
(beginning, middle, final), progression visualization,
inspiring comic style, purple to gold gradient --ar 9:16
--cref [rookie_chad.png URL] --cw 70 --s 40
```

**배경색**: 보라색 → 금색 그라데이션 (진화 느낌)
**크기**: 1080×1920
**분위기**: 성장과 변화, 희망적

**구성**:
- 왼쪽: 초보 Chad (작고 약함)
- 중간: 중급 Chad (성장 중)
- 오른쪽: 최종 Chad (강하고 자신감)
- 화살표로 진행 방향 표시

---

### 4️⃣ onboarding_4_level_test.png (레벨 테스트)

**목적**: 푸시업 자세 시연, 테스트 분위기

**MidJourney 프롬프트:**

```
Chad character in perfect push-up position, top-down view,
proper form demonstration, clean white background,
instructional illustration style, red outline showing correct posture,
fitness app tutorial image --ar 9:16 --s 40
```

**--cref 사용 시:**
```
Chad character doing push-up with perfect form, side view angle,
demonstrating proper technique, clean minimal background,
instructional style --ar 9:16 --cref [front_facing_chad.png URL] --cw 85 --s 40
```

**배경색**: 밝은 회색 또는 흰색 (깔끔)
**크기**: 1080×1920
**분위기**: 교육적, 명확한

**핵심**:
- 정확한 푸시업 자세
- 일직선 몸 라인 강조
- 옆면 또는 위에서 본 각도

---

### 5️⃣ onboarding_5_form_guide.png (자세 가이드)

**목적**: 올바른 푸시업 폼 상세 설명

**MidJourney 프롬프트:**

```
Chad character push-up form guide, side view showing 3 positions
(start, down, up), diagram style with arrows and annotations,
educational fitness illustration, clean professional design,
white background with blue accent lines --ar 9:16 --s 40
```

**--cref 사용 시:**
```
Chad character push-up sequence, 3 step diagram (plank, down, up),
educational illustration with guide lines and arrows,
professional fitness tutorial --ar 9:16 --cref [front_facing_chad.png URL] --cw 85 --s 40
```

**배경색**: 흰색 + 파란색 가이드 라인
**크기**: 1080×1920
**분위기**: 교육적, 전문적

**구성**:
- 상단: 시작 자세
- 중간: 내려간 자세
- 하단: 올라온 자세
- 화살표로 동작 흐름 표시
- 각도/거리 가이드 라인

---

### 6️⃣ onboarding_6_ready.png (준비 완료)

**목적**: 동기부여, 시작 준비 완료

**MidJourney 프롬프트:**

```
Chad character ready to start pose, fist pump or thumbs up,
excited and energetic expression, explosion of motivation energy
behind him, vibrant colors orange and yellow, celebration mood,
inspiring mobile app illustration --ar 9:16 --s 40
```

**--cref 사용 시:**
```
Chad character celebrating ready to start, fist pump pose,
energetic smile, burst of energy effect background,
motivational and exciting --ar 9:16 --cref [sunglasses_chad.png URL] --cw 75 --s 40
```

**배경색**: 주황색/노란색 폭발 효과 (에너지)
**크기**: 1080×1920
**분위기**: 흥분된, 동기부여되는

**효과**:
- 에너지 라인 또는 폭발 효과
- 금색 반짝임 (선택)
- 역동적인 포즈

---

## 🎯 앱 아이콘

### App Icon (1024×1024)

**목적**: 앱 스토어에서 한눈에 알아볼 수 있는 아이콘

**옵션 1: Chad 얼굴 중심 (권장)**

```
Mission 100 app icon, Chad character portrait close-up,
confident smile, muscular shoulders visible, simple gradient
background purple to blue, bold clean design, professional
mobile app icon style --ar 1:1 --s 50
```

**옵션 2: 푸시업 포즈**

```
Mission 100 app icon, Chad character doing push-up from top view,
circular composition, bold colors purple and gold,
simple iconic design, fitness app icon --ar 1:1 --s 50
```

**옵션 3: 진화 심볼**

```
Mission 100 app icon, Chad character transformation symbol,
before and after split design, left weak right strong,
inspiring fitness icon, purple and gold colors --ar 1:1 --s 50
```

**--cref 사용 시 (옵션 1 권장):**
```
Chad character face portrait for app icon, confident expression,
close-up view, simple gradient background purple,
professional app icon design --ar 1:1 --cref [sunglasses_chad.png URL] --cw 90 --s 50
```

**배경색**: 보라색 그라데이션 또는 단색
**크기**: 1024×1024
**분위기**: 강렬하고 기억에 남는

**중요 팁**:
- 작은 크기에서도 잘 보여야 함
- 너무 복잡하지 않게
- 텍스트 없이 (순수 아이콘)
- 테두리 여백 확보

---

## 🎨 Feature Graphic (Google Play)

### Feature Graphic (1024×500)

**목적**: Google Play 스토어 상단 배너

**MidJourney 프롬프트:**

```
Mission 100 app banner, Chad character evolution 7 stages in a row,
progression from weak to champion, timeline from left to right,
inspiring transformation journey, gradient background purple to gold,
week numbers (0, 2, 4, 6, 8, 10, 14) below each stage,
professional fitness app banner --ar 2:1 --s 40
```

**--cref 사용 시:**
```
Chad character 7 evolution stages horizontal banner,
showing transformation journey left to right,
timeline progression, inspiring gradient purple to gold,
professional app store banner --ar 2:1 --cref [rookie_chad.png URL] --cw 70 --s 40
```

**배경색**: 보라색 → 금색 그라데이션
**크기**: 1024×500 (2:1 비율)
**분위기**: 웅장하고 영감을 주는

**구성**:
- 왼쪽부터 오른쪽으로 7단계 Chad
- 각 단계 아래 "Week 0", "Week 2", ... "Week 14"
- 화살표로 진행 방향
- 중앙 상단에 "Mission 100" 로고 (선택)

**텍스트 추가 (Photoshop/Figma에서)**:
- "14주 만에 푸시업 100개 달성!"
- "과학적으로 검증된 프로그램"

---

## 🎬 푸시업 자세 동영상

### pushup_form_demo.mp4 (15초)

**옵션 1: 직접 촬영**
- 카메라 고정 (측면 각도)
- 3회 반복 (천천히)
- 0-3초: 시작 자세 (플랭크)
- 3-6초: 내려가기 (2초)
- 6-9초: 올라오기 (1초)
- 9-15초: 반복 2회

**옵션 2: MidJourney + CapCut 조합**
1. MidJourney로 푸시업 3단계 이미지 생성
2. CapCut 또는 After Effects에서 애니메이션
3. 화살표와 가이드 라인 추가

**옵션 3: Stock Video 사용**
- Pexels, Pixabay에서 무료 푸시업 영상
- 15초로 편집
- 자막/가이드 라인 추가

**필요한 각도**:
- 측면 (핵심)
- 위에서 (손 위치)
- 옵션: 정면

---

## 📝 생성 순서 및 팁

### 순서 (우선순위)

1. **앱 아이콘** (최우선!) ⭐⭐⭐
   - 스토어 등록에 필수
   - 첫인상 결정

2. **온보딩 이미지 1, 6** (Welcome + Ready)
   - 사용자 여정의 시작과 끝
   - 중요한 전환 지점

3. **온보딩 이미지 3** (14주 프로그램)
   - 앱의 핵심 가치 전달

4. **온보딩 이미지 2, 4, 5** (Science + Level Test + Form)
   - 보조 설명 이미지

5. **Feature Graphic**
   - Google Play 배너

6. **푸시업 동영상**
   - 나중에 추가 가능 (v1.1 업데이트)

### MidJourney 생성 팁

#### 1단계: 참조 이미지 준비
```bash
# 기존 Chad 이미지 중 하나를 Discord에 업로드
# 우클릭 → "이미지 주소 복사"
# 이 URL을 --cref로 사용
```

#### 2단계: 첫 번째 이미지 생성 (환영 포즈)
```
/imagine prompt: Chad character welcoming pose, cheerful muscular man waving hello, friendly smile, cartoon illustration style, simple gradient background purple to blue, motivational and inviting, clean modern design, mobile app onboarding illustration --ar 9:16 --cref [YOUR_IMAGE_URL] --cw 80 --s 40
```

#### 3단계: 결과 확인 및 조정
- V1, V2, V3, V4 중 선택
- 마음에 드는 것 Upscale (U1, U2, U3, U4)
- Vary (Subtle) 또는 Vary (Strong)로 조정

#### 4단계: 일관성 유지
- 같은 --cref URL을 모든 온보딩 이미지에 사용
- --cw 값 조정:
  - 80-90: 높은 일관성 (얼굴 중심)
  - 70-80: 중간 일관성 (포즈 변형)
  - 60-70: 낮은 일관성 (더 자유로운 변형)

#### 5단계: 다운로드 및 최적화
```bash
# 이미지 다운로드
# PNG 형식으로 저장
# 필요시 크기 조정 (1080×1920)

# ImageMagick으로 크기 조정
magick convert original.png -resize 1080x1920 onboarding_1_welcome.png
```

### 색상 가이드

```
Mission100 브랜드 컬러:
- Primary Purple: #9C88FF
- Primary Blue: #4DABF7
- Gold (Evolution): #FFB000
- Success Green: #51CF66
- Background: #F7FAFC

그라데이션 조합:
- Welcome: Purple → Blue
- Science: Blue → White
- Program: Purple → Gold
- Ready: Orange → Yellow
```

### 파일명 규칙

```
assets/images/chad/온보딩/
├── onboarding_1_welcome.png
├── onboarding_2_science.png
├── onboarding_3_program_14weeks.png
├── onboarding_4_level_test.png
├── onboarding_5_form_guide.png
└── onboarding_6_ready.png

assets/images/
├── app_icon_1024.png
└── feature_graphic_1024x500.png

assets/videos/
└── pushup_form_demo.mp4
```

---

## 🎨 대체 방안 (MidJourney 없이)

### 옵션 1: DALL-E 3 (ChatGPT Plus)
- 같은 프롬프트 사용 가능
- 일관성 유지가 조금 어려움
- 무제한 생성 (ChatGPT Plus 구독)

### 옵션 2: Leonardo.ai (무료)
- 무료 티어로 일부 생성 가능
- Character Reference 기능 있음
- 일일 생성 제한

### 옵션 3: Canva + 일러스트레이터
- Canva Pro의 AI 이미지 생성
- 기본 템플릿 활용
- 수동 편집으로 일관성 유지

### 옵션 4: Fiverr 아티스트 고용
- $50-200 예산
- 6개 온보딩 이미지 패키지
- 2-5일 작업 시간
- 일관성 보장

---

## ✅ 체크리스트

### MidJourney 생성 전
- [ ] Discord에 기존 Chad 이미지 업로드
- [ ] 이미지 URL 복사 (--cref용)
- [ ] MidJourney 구독 확인 (Fast mode)
- [ ] 생성할 이미지 순서 결정

### 생성 중
- [ ] 앱 아이콘 3개 버전 테스트
- [ ] 온보딩 이미지 6개 생성
- [ ] Feature Graphic 생성
- [ ] 각 이미지 Upscale 및 저장

### 생성 후
- [ ] PNG 형식으로 다운로드
- [ ] 크기 조정 (필요시)
- [ ] 파일명 규칙에 맞춰 저장
- [ ] assets 폴더에 배치
- [ ] pubspec.yaml에 추가
- [ ] 앱에서 로드 테스트

---

## 📞 추가 지원

**질문이나 도움이 필요하면**:
- MidJourney 프롬프트 조정
- 색상 변경
- 포즈 변경
- 일관성 문제 해결

**예시 이미지 확인**:
- 기존 Chad 진화 이미지: `assets/images/chad/진화/`
- 참조할 스타일과 분위기

---

**생성 시작 준비가 되셨나요?**
먼저 **앱 아이콘**부터 만들어볼까요? 🎨

아니면 온보딩 이미지 6개를 한 번에 생성할 수도 있습니다!
