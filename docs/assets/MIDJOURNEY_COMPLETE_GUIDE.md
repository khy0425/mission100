# MIDJOURNEY COMPLETE GUIDE

> 통합 가이드 - MidJourney 가이드 + 프롬프트를 하나로

**생성일**: 2025-10-26
**포함 문서**: 2개

---

## 📋 목차

1. [MidJourney 상세 가이드](#midjourney-상세-가이드)
2. [바로 사용 가능한 프롬프트](#바로-사용-가능한-프롬프트)

---



## 1. MidJourney 상세 가이드

> **원본 문서**: `docs/MIDJOURNEY_PROMPTS.md`

---


#### 기본 프롬프트 템플릿

##### 완벽한 푸쉬업 자세 (측면)
```
3D render of athletic male figure performing perfect push-up form,
side view angle, highlighted chest muscles in glowing cyan blue (#4DABF7),
dark grey studio background (#1A1A1A),
professional fitness illustration style,
clean minimalist design,
anatomical muscle visualization,
high detail,
photorealistic lighting,
4k quality
--ar 1:1 --v 6 --style raw
```

##### 완벽한 푸쉬업 자세 (정면)
```
3D anatomical render of fit male doing push-up exercise,
front view showing shoulder and arm muscles,
highlighted deltoids and triceps in bright cyan glow,
dark studio background,
medical illustration style,
precise anatomy,
studio lighting,
ultra detailed
--ar 1:1 --v 6 --style raw
```

#### 운동별 프롬프트

##### 1. 올바른 자세 시리즈

#### 시작 자세 (Plank Position)
```
3D render athletic figure in plank position,
perfect straight body alignment,
side profile view,
glowing cyan highlights on core and shoulder muscles,
dark minimalist background,
fitness app illustration style,
clean professional design
--ar 16:9 --v 6
```

#### 하강 단계 (Down Phase)
```
3D anatomical model lowering body in push-up motion,
elbows at 45 degrees,
highlighted pectoralis major in cyan blue,
side view angle,
dark grey background,
medical fitness illustration,
high detail muscle definition
--ar 1:1 --v 6 --style raw
```

#### 최하단 자세 (Bottom Position)
```
3D render male figure at bottom of push-up,
chest near ground,
elbows bent 90 degrees,
glowing cyan chest and triceps muscles,
side profile,
dark background,
professional fitness diagram style
--ar 1:1 --v 6
```

##### 2. 잘못된 자세 (실수) 시리즈

#### 등이 아치형 (Back Arch)
```
3D render incorrect push-up form with arched lower back,
highlighted in red warning glow (#FF6B6B),
X mark overlay,
side view,
educational fitness illustration,
dark background,
anatomical style showing poor posture
--ar 1:1 --v 6
```

#### 엉덩이 처짐 (Hips Down)
```
3D anatomical figure doing push-up with sagging hips,
wrong posture highlighted in red,
warning indicators,
side profile view,
medical illustration style,
dark background,
educational fitness diagram
--ar 1:1 --v 6 --style raw
```

#### 팔꿈치 벌림 (Elbows Out)
```
3D render push-up with elbows flared out at wrong angle,
top-down view showing arm position,
red warning highlights on shoulder strain,
dark background,
fitness education illustration,
clear anatomical markers
--ar 1:1 --v 6
```

##### 3. 근육 강조 시리즈

#### 가슴 근육 강조
```
3D anatomical model in push-up position,
x-ray style view of glowing pectoralis major muscles,
bright cyan muscle highlights,
side angle,
dark background,
medical fitness visualization,
translucent skin showing muscle structure
--ar 1:1 --v 6 --style raw
```

#### 삼두근 강조
```
3D render push-up exercise highlighting triceps brachii,
neon cyan glow on back of arms,
side view,
anatomical muscle visualization,
dark grey background,
professional fitness illustration,
clear muscle definition
--ar 1:1 --v 6
```

#### 코어 근육 강조
```
3D anatomical figure doing plank,
highlighted core muscles in cyan blue,
rectus abdominis and obliques glowing,
side profile,
medical illustration style,
dark background,
precise muscle anatomy
--ar 1:1 --v 6 --style raw
```

##### 4. 변형 운동 시리즈

#### 무릎 푸쉬업 (초급)
```
3D render beginner knee push-up exercise,
athletic figure with knees on ground,
highlighted muscles in green (#51CF66),
side view,
beginner level indicator,
dark background,
friendly fitness illustration style
--ar 1:1 --v 6
```

#### 와이드 푸쉬업 (중급)
```
3D anatomical model doing wide-grip push-up,
hands positioned wider than shoulders,
glowing chest muscles in yellow (#FFD43B),
top-down angle view,
dark background,
intermediate level fitness diagram
--ar 1:1 --v 6
```

#### 다이아몬드 푸쉬업 (중급)
```
3D render diamond push-up with hands forming triangle,
highlighted triceps in bright yellow glow,
close-up side view,
dark background,
advanced technique illustration,
anatomical muscle detail
--ar 1:1 --v 6 --style raw
```

#### 원암 푸쉬업 (고급)
```
3D athletic figure performing one-arm push-up,
extreme strength pose,
multiple muscle groups highlighted in red (#FF6B6B),
side profile,
dark background,
advanced level fitness visualization,
dramatic lighting
--ar 1:1 --v 6
```

#### 비교 이미지 (올바른 vs 잘못된)

##### Side-by-Side 비교
```
split screen comparison 3D render,
left side correct push-up form with green checkmark,
right side incorrect form with red X,
both highlighted with corresponding colors,
side view angles,
dark background,
educational fitness infographic style,
clear visual distinction
--ar 16:9 --v 6
```

#### 프롬프트 최적화 팁

##### 색상 지정
- 올바른 자세: `glowing green (#51CF66)` 또는 `bright cyan (#4DABF7)`
- 잘못된 자세: `red warning glow (#FF6B6B)`
- 주요 근육: `neon cyan highlights`
- 초급: `soft green glow`
- 중급: `yellow highlights (#FFD43B)`
- 고급: `intense red glow`

##### 배경 스타일
```
dark grey studio background (#1A1A1A)
minimalist dark backdrop
professional fitness studio setting
medical illustration background
gradient dark grey to black
```

##### 각도 표현
```
side view / side profile / lateral view
front view / anterior view
top-down view / bird's eye view
3/4 angle / three-quarter view
isometric view
```

##### 스타일 키워드
```
3D render
anatomical illustration
medical visualization
professional fitness diagram
educational illustration
clean minimalist design
photorealistic
studio quality
high detail muscle definition
```

#### Midjourney 설정

##### 기본 설정
```
--ar 1:1        # 정사각형 (인스타그램, 앱)
--ar 16:9       # 와이드 (비교 이미지)
--ar 9:16       # 세로 (모바일 세로 모드)
--v 6           # 버전 6 (최신)
--style raw     # 더 현실적인 스타일
--s 50          # 스타일화 레벨 (50-200)
--q 2           # 품질 2 (최고 품질)
```

##### 고급 설정
```
--no text, watermark, logo, signature  # 제외할 요소
--chaos 0                               # 일관성 높음
--weird 0                               # 현실적
```

#### 워크플로우

##### 1단계: 기본 이미지 생성
```bash
1. Midjourney Discord 접속
2. /imagine 명령어 입력
3. 프롬프트 붙여넣기
4. 4개 결과 중 최고 선택 (U1, U2, U3, U4)
5. 추가 변형 생성 (V1, V2, V3, V4)
```

##### 2단계: 이미지 개선
```bash
### 선택한 이미지 업스케일
U1 클릭 → 고해상도 버전 생성

### 세부 조정이 필요하면
/imagine [원본 프롬프트] + 추가 키워드

### 예: 근육 하이라이트 더 강하게
+ "more intense cyan glow, brighter muscle highlights"

### 예: 배경 더 어둡게
+ "darker background, higher contrast"
```

##### 3단계: 일관성 유지
```bash
### 같은 캐릭터 스타일 유지하려면
/imagine [프롬프트] --cref [이미지 URL] --cw 100

### 예:
/imagine 3D render push-up side view --cref https://...첫번째이미지URL --cw 100
```

#### 실전 예제

##### 완전한 푸쉬업 가이드 세트 (5개 이미지)

**1. 시작 자세**
```
professional 3D render of athletic male in perfect plank position,
arms straight, body aligned,
highlighted core and shoulder muscles in cyan blue,
side profile view,
dark grey background,
fitness app illustration,
clean design
--ar 1:1 --v 6 --style raw
```

**2. 하강 동작**
```
3D anatomical figure lowering into push-up,
elbows bending 45 degrees,
glowing cyan chest muscles,
side view,
dark background,
professional fitness diagram
--ar 1:1 --v 6 --style raw --cref [이미지1 URL] --cw 100
```

**3. 최하단**
```
3D render male at bottom of push-up,
chest near ground,
90 degree elbow bend,
cyan muscle highlights,
side profile,
dark studio background
--ar 1:1 --v 6 --style raw --cref [이미지1 URL] --cw 100
```

**4. 상승 동작**
```
3D athletic figure pushing up from ground,
arms extending,
highlighted triceps and chest in cyan,
side view,
dark background,
fitness illustration
--ar 1:1 --v 6 --style raw --cref [이미지1 URL] --cw 100
```

**5. 완료 자세**
```
3D render returning to plank position,
arms fully extended,
full body alignment,
cyan core highlights,
side profile view,
dark grey background
--ar 1:1 --v 6 --style raw --cref [이미지1 URL] --cw 100
```

#### 문제 해결

##### 이미지가 너무 만화 같아요
```
프롬프트에 추가:
+ photorealistic, studio photography lighting, realistic anatomy
+ --style raw
- cartoon, animated 키워드 제거
```

##### 근육 하이라이트가 안보여요
```
프롬프트에 추가:
+ glowing neon cyan muscles, x-ray style, translucent skin
+ bright muscle highlights, bioluminescent effect
```

##### 배경이 밝아요
```
프롬프트에 추가:
+ pitch black background, dark studio, high contrast
+ --no bright lights, white background
```

##### 자세가 부정확해요
```
프롬프트에 더 구체적으로:
+ perfect form, correct posture, professional trainer demonstration
+ precise anatomy, medically accurate
+ reference image 사용: --cref [정확한 자세 사진 URL]
```

#### 비용 및 시간

##### Midjourney 구독
```
Basic Plan: $10/월 (200장 생성)
Standard Plan: $30/월 (무제한 relax 모드)
Pro Plan: $60/월 (무제한 fast 모드)

추천: Standard Plan
```

##### 예상 시간
```
이미지 1장 생성: 1-2분
완벽한 결과까지 반복: 3-5번
한 운동당 시간: 10-20분
전체 세트 (20개): 4-6시간
```

#### 체크리스트

##### 생성할 이미지 목록
- [ ] 올바른 자세 - 측면 (5단계)
- [ ] 올바른 자세 - 정면
- [ ] 잘못된 자세 - 등 아치형
- [ ] 잘못된 자세 - 엉덩이 처짐
- [ ] 잘못된 자세 - 팔꿈치 벌림
- [ ] 잘못된 자세 - 머리 숙임
- [ ] 근육 강조 - 가슴
- [ ] 근육 강조 - 삼두근
- [ ] 근육 강조 - 코어
- [ ] 근육 강조 - 어깨
- [ ] 변형 - 무릎 푸쉬업
- [ ] 변형 - 와이드 푸쉬업
- [ ] 변형 - 다이아몬드 푸쉬업
- [ ] 변형 - 원암 푸쉬업
- [ ] 비교 이미지 (올바른 vs 잘못된)

##### 후처리
- [ ] 배경 통일성 확인
- [ ] 색상 일관성 체크
- [ ] 필요시 Photoshop에서 미세 조정
- [ ] 모바일 크기로 리사이즈 (1080x1080)
- [ ] 파일 크기 최적화 (<500KB)
- [ ] 다크모드에서 테스트

#### 추가 리소스

##### 레퍼런스 이미지
생성 전에 실제 푸쉬업 사진을 레퍼런스로 사용하면 더 정확합니다:
```
/imagine [프롬프트] --cref [레퍼런스 이미지 URL]
```

##### Midjourney 커뮤니티
- Discord: Midjourney 서버에서 다른 사람들의 fitness 이미지 참고
- 검색: `/search fitness illustration` 또는 `/search push up`

##### 영감 자료
Midjourney Discord에서 검색:
- "fitness illustration"
- "exercise diagram"
- "anatomical render"
- "muscle visualization"

#### 다음 단계

1. **지금 바로 시작**: Midjourney 구독 및 첫 이미지 생성
2. **테스트**: 3-5개 이미지로 앱에 적용해보기
3. **피드백**: 팀/유저 피드백 받기
4. **완성**: 전체 세트 제작

---

💡 **Pro Tip**: 첫 이미지를 완벽하게 만든 후 `--cref`로 일관성 유지하세요!


---



## 2. 바로 사용 가능한 프롬프트

> **원본 문서**: `docs/MIDJOURNEY_READY_PROMPTS.txt`

---

=================================================
미드저니 푸쉬업 가이드 이미지 - 바로 사용 가능한 프롬프트
=================================================

✅ v5.2 버전 사용 (개인화 스타일 오류 해결됨!)
=================================================

v6에서 발생하는 개인화 스타일 오류를 피하기 위해
모든 프롬프트를 v5.2로 설정했습니다.

v5.2 장점:
- 개인화 스타일 설정 불필요
- 안정적이고 고품질
- 바로 사용 가능

설정 변경 없이 바로 사용하세요!

=================================================

프롬프트 사용법 (웹 버전):
1. 위의 설정 변경 완료 확인 ✅
2. 상단의 프롬프트 입력창 클릭
3. 아래 프롬프트 복사해서 붙여넣기 (명령어 없이 바로 프롬프트만!)
4. Enter 또는 생성 버튼 클릭!

=================================================
✅ 올바른 자세 시리즈
=================================================

[1] 완벽한 푸쉬업 - 측면뷰
----------------------------------------
3D render of athletic male figure performing perfect push-up form, side view angle, highlighted chest muscles in glowing cyan blue, dark grey studio background, professional fitness illustration style, clean minimalist design, anatomical muscle visualization, high detail, photorealistic lighting, 4k quality --ar 1:1 --v 5.2 --style raw


[2] 완벽한 푸쉬업 - 정면뷰
----------------------------------------
3D anatomical render of fit male doing push-up exercise, front view showing shoulder and arm muscles, highlighted deltoids and triceps in bright cyan glow, dark studio background, medical illustration style, precise anatomy, studio lighting, ultra detailed --ar 1:1 --v 5.2 --style raw


[3] 플랭크 시작 자세
----------------------------------------
3D render athletic figure in plank position, perfect straight body alignment, side profile view, glowing cyan highlights on core and shoulder muscles, dark minimalist background, fitness app illustration style, clean professional design --ar 1:1 --v 5.2 --style raw


[4] 하강 단계
----------------------------------------
3D anatomical model lowering body in push-up motion, elbows at 45 degrees, highlighted pectoralis major in cyan blue, side view angle, dark grey background, medical fitness illustration, high detail muscle definition --ar 1:1 --v 5.2 --style raw


[5] 최하단 자세
----------------------------------------
3D render male figure at bottom of push-up, chest near ground, elbows bent 90 degrees, glowing cyan chest and triceps muscles, side profile, dark background, professional fitness diagram style --ar 1:1 --v 5.2 --style raw


=================================================
❌ 잘못된 자세 (실수) 시리즈
=================================================

[6] 등이 아치형 - 잘못된 자세
----------------------------------------
3D render incorrect push-up form with arched lower back, highlighted in red warning glow, X mark overlay, side view, educational fitness illustration, dark background, anatomical style showing poor posture --ar 1:1 --v 5.2 --style raw


[7] 엉덩이 처짐 - 잘못된 자세
----------------------------------------
3D anatomical figure doing push-up with sagging hips, wrong posture highlighted in red, warning indicators, side profile view, medical illustration style, dark background, educational fitness diagram --ar 1:1 --v 5.2 --style raw


[8] 팔꿈치 벌림 - 잘못된 자세
----------------------------------------
3D render push-up with elbows flared out at wrong angle, top-down view showing arm position, red warning highlights on shoulder strain, dark background, fitness education illustration, clear anatomical markers --ar 1:1 --v 5.2 --style raw


[9] 머리 숙임 - 잘못된 자세
----------------------------------------
3D anatomical figure doing push-up with head dropped down, neck strain highlighted in red, side view, warning illustration style, dark background, educational fitness diagram showing poor form --ar 1:1 --v 5.2 --style raw


=================================================
💪 근육 강조 시리즈
=================================================

[10] 가슴 근육 강조
----------------------------------------
3D anatomical model in push-up position, x-ray style view of glowing pectoralis major muscles, bright cyan muscle highlights, side angle, dark background, medical fitness visualization, translucent skin showing muscle structure --ar 1:1 --v 5.2 --style raw


[11] 삼두근 강조
----------------------------------------
3D render push-up exercise highlighting triceps brachii, neon cyan glow on back of arms, side view, anatomical muscle visualization, dark grey background, professional fitness illustration, clear muscle definition --ar 1:1 --v 5.2 --style raw


[12] 코어 근육 강조
----------------------------------------
3D anatomical figure doing plank, highlighted core muscles in cyan blue, rectus abdominis and obliques glowing, side profile, medical illustration style, dark background, precise muscle anatomy --ar 1:1 --v 5.2 --style raw


[13] 어깨 근육 강조
----------------------------------------
3D render push-up with highlighted deltoid muscles, bright cyan shoulder glow, side angle view, anatomical muscle visualization, dark studio background, professional fitness diagram, clear muscle definition --ar 1:1 --v 5.2 --style raw


=================================================
🔄 변형 운동 - 초급
=================================================

[14] 무릎 푸쉬업
----------------------------------------
3D render beginner knee push-up exercise, athletic figure with knees on ground, highlighted muscles in soft green glow, side view, beginner level indicator, dark background, friendly fitness illustration style --ar 1:1 --v 5.2 --style raw


[15] 벽 푸쉬업
----------------------------------------
3D anatomical figure doing wall push-up exercise, standing position against vertical surface, highlighted chest and arm muscles in green, side view angle, beginner friendly illustration, dark background --ar 1:1 --v 5.2 --style raw


[16] 인클라인 푸쉬업
----------------------------------------
3D render incline push-up using elevated surface, hands on bench, athletic figure highlighted muscles in green glow, side view, beginner level fitness illustration, dark background, clear form demonstration --ar 1:1 --v 5.2 --style raw


=================================================
🔄 변형 운동 - 중급
=================================================

[17] 와이드 푸쉬업
----------------------------------------
3D anatomical model doing wide-grip push-up, hands positioned wider than shoulders, glowing chest muscles in yellow, top-down angle view, dark background, intermediate level fitness diagram --ar 1:1 --v 5.2 --style raw


[18] 다이아몬드 푸쉬업
----------------------------------------
3D render diamond push-up with hands forming triangle, highlighted triceps in bright yellow glow, close-up side view, dark background, intermediate technique illustration, anatomical muscle detail --ar 1:1 --v 5.2 --style raw


[19] 디클라인 푸쉬업
----------------------------------------
3D anatomical figure doing decline push-up with feet elevated, highlighted upper chest muscles in yellow glow, side profile view, intermediate level illustration, dark background, professional fitness diagram --ar 1:1 --v 5.2 --style raw


=================================================
🔄 변형 운동 - 고급
=================================================

[20] 원암 푸쉬업
----------------------------------------
3D athletic figure performing one-arm push-up, extreme strength pose, multiple muscle groups highlighted in red glow, side profile, dark background, advanced level fitness visualization, dramatic lighting --ar 1:1 --v 5.2 --style raw


[21] 플라이오메트릭 푸쉬업
----------------------------------------
3D render explosive plyometric push-up with hands off ground, dynamic motion blur, highlighted fast-twitch muscles in red, side view, advanced level illustration, dark background, power movement visualization --ar 1:1 --v 5.2 --style raw


[22] 아처 푸쉬업
----------------------------------------
3D anatomical model doing archer push-up, asymmetric arm position, highlighted unilateral chest muscles in red glow, side angle view, advanced technique illustration, dark background, precise form demonstration --ar 1:1 --v 5.2 --style raw


=================================================
⚖️ 비교 이미지
=================================================

[23] 올바른 vs 잘못된 (Side by Side)
----------------------------------------
split screen comparison 3D render, left side correct push-up form with green checkmark and cyan highlights, right side incorrect form with red X and warning glow, both side view angles, dark background, educational fitness infographic style, clear visual distinction --ar 16:9 --v 5.2 --style raw


[24] 근육 활성화 맵
----------------------------------------
3D anatomical figure in push-up position, full body muscle activation map, color-coded intensity from blue cool to red hot, showing all working muscles, dark background, scientific fitness visualization, medical illustration style --ar 1:1 --v 5.2 --style raw


=================================================
🎯 특별 각도
=================================================

[25] 3/4 각도 뷰
----------------------------------------
3D render perfect push-up form from three-quarter angle view, showing both side and front perspective, highlighted muscles in cyan blue, athletic male figure, dark studio background, professional fitness illustration, dynamic composition --ar 1:1 --v 5.2 --style raw


[26] 탑다운 뷰 (위에서)
----------------------------------------
3D anatomical render push-up from bird's eye view, top-down perspective showing shoulder and back muscles, cyan muscle highlights, dark background, unique angle fitness illustration, clear form demonstration --ar 1:1 --v 5.2 --style raw


=================================================
💡 팁
=================================================

1. 첫 이미지 생성 후 마음에 들면 URL 복사
2. 다음 프롬프트에 --cref [URL] --cw 100 추가하여 일관성 유지
3. 색상이 마음에 안들면: 프롬프트에 "brighter", "more intense", "neon" 추가
4. 배경이 밝으면: "darker background, pitch black, high contrast" 추가
5. 자세가 부정확하면: "anatomically correct, precise form, professional" 추가

예시:
/imagine [위 프롬프트] --cref https://cdn.midjourney.com/abc123/0_0.png --cw 100


=================================================
⚙️ 파라미터 설명
=================================================

--ar 1:1         # 정사각형 (인스타그램, 앱)
--ar 16:9        # 와이드 (비교 이미지, 웹)
--v 5.2          # 버전 5.2 (안정적, 개인화 오류 없음) ✅
--style raw      # 덜 스타일화, 더 현실적
--s 50           # 스타일 강도 조절 (0-1000, 기본 100)
--q 2            # 품질 최대
--chaos 0        # 변화 없음 (일관성)

제외할 요소 추가:
--no text, watermark, logo, numbers, letters


=================================================
🚀 빠른 시작
=================================================

1단계: 프롬프트 [1] 복사 → 생성
2단계: 4개 중 최고 선택 (U1~U4 클릭)
3단계: 업스케일된 이미지 URL 복사
4단계: 프롬프트 [2] + --cref [URL] --cw 100 추가
5단계: 반복!

성공적인 제작을 기원합니다! 💪


---


## 🔗 관련 문서

- [MidJourney 상세 가이드](docs/MIDJOURNEY_PROMPTS.md)
- [바로 사용 가능한 프롬프트](docs/MIDJOURNEY_READY_PROMPTS.txt)


---

**마지막 업데이트**: 2025-10-26 07:05
**관리**: 자동 생성 (tools/consolidate_docs.py)
