# 🎨 Chad 캐릭터 에셋 생성 가이드 (MidJourney)

## 🎯 목표
**완벽한 캐릭터 일관성**으로 5~15개 Chad 이미지 생성

## 📋 사전 준비

### 1. MidJourney 설정
- [ ] MidJourney Basic 플랜 가입 ($10/월)
- [ ] Discord 서버 입장
- [ ] `/settings` 명령어로 V6.0 활성화
- [ ] `Raw Mode` 활성화 (더 정확한 제어)

### 2. 기술 스펙
- **해상도**: 1:1 비율 (정사각형)
- **최소 크기**: 512x512px (실제 생성: 1024x1024)
- **포맷**: PNG (투명 배경 불가, JPG 변환)
- **스타일**: 만화/애니메이션 (일관성)

## 🚀 생성 프로세스

### Step 1: 마스터 Chad 생성 ⭐

**목표**: 모든 Chad의 기준이 되는 기본 이미지

**프롬프트**:
```
/imagine prompt: Muscular friendly male AI fitness trainer character,
early 30s, short black hair, warm smile, confident expression,
wearing bright blue tank top, athletic build but approachable,
cartoon anime art style, clean white background,
standing pose with slight lean forward, energetic vibe,
bright vibrant colors, professional illustration --ar 1:1 --v 6.0 --style raw
```

**체크포인트**:
- [ ] 얼굴 표정: 친근하고 자신감 있음
- [ ] 체형: 근육질이지만 과하지 않음
- [ ] 의상: 탱크탑 (색상 통일)
- [ ] 배경: 깔끔함 (흰색/밝은 단색)
- [ ] 스타일: 애니메이션/만화 (일관성)

**저장**:
1. 가장 마음에 드는 버전 선택 (U1~U4)
2. 이미지 우클릭 → `Copy Image Address`
3. URL 메모장에 저장: `MASTER_CHAD_URL`

---

### Step 2: Character Reference로 나머지 생성

**중요 파라미터**:
- `--cref [MASTER_CHAD_URL]`: 마스터 이미지 참조
- `--cw 100`: 최대 일관성 (얼굴/체형 완전 일치)

---

## 📸 우선순위별 생성 목록

### 🔥 Priority 1: 핵심 Chad (5개)

#### 1. 기본차드.jpg ✅
- **상태**: 이미 있음 (또는 Step 1 마스터 사용)
- **용도**: 기본 상태, 보통 컨디션

#### 2. 수면차드.jpg
**프롬프트**:
```
/imagine prompt: [Copy description from master] now wearing a blue sleep cap,
tired but still friendly expression, sleepy half-closed eyes, small yawn,
still in tank top, relaxed posture, cozy soft atmosphere,
pastel blue and purple color palette, dreamy background --ar 1:1
--cref [MASTER_CHAD_URL] --cw 100 --v 6.0
```

**사용 위치**:
- 매우 피곤한 컨디션
- 휴식 필요 상태
- 완전 휴식 활동

#### 3. 파워차드.jpg
**프롬프트**:
```
/imagine prompt: [Same character] flexing biceps with both arms,
strong confident smile, determined eyes, peak energy,
wearing same tank top, power stance with legs apart,
bold red and orange background with energy lines,
intense but friendly vibe --ar 1:1
--cref [MASTER_CHAD_URL] --cw 100 --v 6.0
```

**사용 위치**:
- 강한 컨디션
- 높은 에너지 상태

#### 4. 비스트차드.jpg
**프롬프트**:
```
/imagine prompt: [Same character] in ultimate beast mode,
intense focused expression, muscles tensed,
subtle energy aura around body, same tank top slightly torn,
explosive power pose, electric blue lightning effects,
dramatic lighting, peak physical form --ar 1:1
--cref [MASTER_CHAD_URL] --cw 100 --v 6.0
```

**사용 위치**:
- 최강 컨디션
- 언스터퍼블 모드

#### 5. 축하차드.jpg
**프롬프트**:
```
/imagine prompt: [Same character] celebrating with arms raised high,
big joyful smile, excited expression, confetti and sparkles around,
wearing same tank top, victory pose,
bright golden yellow background, triumphant atmosphere --ar 1:1
--cref [MASTER_CHAD_URL] --cw 100 --v 6.0
```

**사용 위치**:
- 목표 달성
- 레벨업
- 업적 해금

---

### ⭐ Priority 2: 진화 Chad (4개)

#### 6. 진화1차드.jpg (Beginner)
**프롬프트**:
```
/imagine prompt: [Same character] beginner level,
slightly less muscular, encouraging smile,
simple tank top, basic pose, bright hopeful background --ar 1:1
--cref [MASTER_CHAD_URL] --cw 100 --v 6.0
```

#### 7. 진화2차드.jpg (Intermediate)
**프롬프트**:
```
/imagine prompt: [Same character] intermediate level,
well-defined muscles, confident stance,
athletic tank top, stronger pose, vibrant background --ar 1:1
--cref [MASTER_CHAD_URL] --cw 100 --v 6.0
```

#### 8. 진화3차드.jpg (Advanced)
**프롬프트**:
```
/imagine prompt: [Same character] advanced level,
highly muscular, powerful presence,
professional workout gear, dynamic pose, epic background --ar 1:1
--cref [MASTER_CHAD_URL] --cw 100 --v 6.0
```

#### 9. 진화최종차드.jpg (Chad Master)
**프롬프트**:
```
/imagine prompt: [Same character] ultimate chad master level,
peak physique, legendary aura,
elite training outfit, heroic pose, divine light background --ar 1:1
--cref [MASTER_CHAD_URL] --cw 100 --v 6.0
```

---

### 💪 Priority 3: 활동 Chad (6개)

#### 10. 운동차드.jpg
**프롬프트**:
```
/imagine prompt: [Same character] doing push-up exercise,
focused expression, proper form, gym environment --ar 1:1
--cref [MASTER_CHAD_URL] --cw 100 --v 6.0
```

#### 11. 스트레칭차드.jpg
**프롬프트**:
```
/imagine prompt: [Same character] stretching arms overhead,
relaxed calm expression, recovery pose --ar 1:1
--cref [MASTER_CHAD_URL] --cw 100 --v 6.0
```

#### 12. 명상차드.jpg
**프롬프트**:
```
/imagine prompt: [Same character] meditating cross-legged,
peaceful serene expression, zen atmosphere --ar 1:1
--cref [MASTER_CHAD_URL] --cw 100 --v 6.0
```

#### 13. 산책차드.jpg
**프롬프트**:
```
/imagine prompt: [Same character] walking outdoors,
happy relaxed smile, nature background --ar 1:1
--cref [MASTER_CHAD_URL] --cw 100 --v 6.0
```

#### 14. 요가차드.jpg
**프롬프트**:
```
/imagine prompt: [Same character] yoga pose,
balanced focused expression, calm blue background --ar 1:1
--cref [MASTER_CHAD_URL] --cw 100 --v 6.0
```

#### 15. 수영차드.jpg
**프롬프트**:
```
/imagine prompt: [Same character] swimming motion,
energetic smile, water splash effects --ar 1:1
--cref [MASTER_CHAD_URL] --cw 100 --v 6.0
```

---

## 🎨 생성 팁

### Character Consistency 극대화

1. **항상 --cw 100 사용**
   - 얼굴/체형 완벽 일치

2. **마스터 이미지 설명 재사용**
   ```
   [Same character from reference] + [새로운 상황/포즈/표정]
   ```

3. **의상 통일**
   - 기본: 밝은 파란색 탱크탑
   - 변형 시에도 색상 유지

4. **배경 단순화**
   - 캐릭터에 집중
   - 단색 또는 심플한 그라데이션

### 품질 체크리스트

각 이미지 생성 후:
- [ ] 얼굴이 마스터와 동일한가?
- [ ] 체형이 일관적인가?
- [ ] 의상 색상이 통일되었는가?
- [ ] 표정/포즈가 상황에 맞는가?
- [ ] 배경이 깔끔한가?
- [ ] 1024x1024 해상도인가?

### 불만족 시 재생성

**Variation 사용**:
```
V1~V4 버튼: 미세 조정
🔄 버튼: 완전 재생성
```

**프롬프트 수정**:
- 더 구체적으로 표현 추가
- `--cw` 값 조정 (90~100)
- `--style` 파라미터 추가

---

## 📥 다운로드 및 적용

### 1. 이미지 다운로드
1. 완성된 이미지 우클릭
2. `Save Image` 또는 `Open Original`
3. 원본 크기로 저장 (1024x1024)

### 2. 파일명 규칙
```
기본차드.jpg
수면차드.jpg
파워차드.jpg
비스트차드.jpg
축하차드.jpg
진화1차드.jpg
진화2차드.jpg
...
```

### 3. 파일 배치
```
assets/images/chad/
├── condition/
│   ├── 기본차드.jpg
│   ├── 수면차드.jpg
│   ├── 파워차드.jpg
│   └── 비스트차드.jpg
├── evolution/
│   ├── 진화1차드.jpg
│   ├── 진화2차드.jpg
│   ├── 진화3차드.jpg
│   └── 진화최종차드.jpg
├── activity/
│   ├── 운동차드.jpg
│   ├── 스트레칭차드.jpg
│   └── ...
└── celebration/
    └── 축하차드.jpg
```

### 4. pubspec.yaml 등록
```yaml
flutter:
  assets:
    - assets/images/chad/condition/
    - assets/images/chad/evolution/
    - assets/images/chad/activity/
    - assets/images/chad/celebration/
```

### 5. 코드 연동 확인
```dart
// lib/services/chad_image_service.dart
// 이미 구현되어 있음 - 파일명만 맞추면 자동 로드
```

---

## 💰 예상 비용

**MidJourney Basic ($10/월)**:
- Fast 생성: ~200장/월
- 필요 이미지: 15장 (여유 있게 30장 생성 가정)
- 충분히 1개월 안에 완성 가능

**절약 팁**:
- 마스터 이미지 확정 후 생성 시작
- 한 번에 여러 variation 비교
- 1개월 안에 모든 에셋 완성 후 구독 취소

---

## ✅ 최종 체크리스트

### 생성 전
- [ ] MidJourney 플랜 활성화
- [ ] Discord 서버 입장
- [ ] V6.0 + Raw Mode 설정
- [ ] 마스터 Chad URL 준비

### 생성 중
- [ ] 마스터 Chad 완성 (가장 중요!)
- [ ] URL 복사 및 저장
- [ ] --cref --cw 100 파라미터 적용
- [ ] 각 이미지 일관성 확인

### 생성 후
- [ ] 15개 이미지 다운로드
- [ ] 파일명 규칙에 맞게 저장
- [ ] assets 폴더에 배치
- [ ] pubspec.yaml 등록
- [ ] flutter pub get
- [ ] 앱에서 이미지 로드 테스트

---

## 🚨 문제 해결

### Q: 얼굴이 계속 바뀝니다
A: `--cw` 값 100으로 고정, 프롬프트에 `[Same character]` 명시

### Q: 스타일이 달라집니다
A: `--style raw` 추가, 마스터 이미지와 같은 스타일 키워드 사용

### Q: 배경이 복잡합니다
A: `clean white background` 또는 `simple solid color background` 명시

### Q: 생성 속도가 느립니다
A: Relax Mode 사용 (무제한이지만 느림, Basic 플랜에서 사용 가능)

---

**생성 시작일**: _________
**완료 예정일**: _________
**담당자**: _________

**마스터 Chad URL**:
```
[여기에 저장]
```
