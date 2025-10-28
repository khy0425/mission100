# 🎨 Mission: 100 Push-Ups 에셋 가이드

> **14주 푸시업 전용 프로그램** | 100일 챌린지 | 연속 100개 목표

## 📋 목차
- [운동 프로그램 이미지](#운동-프로그램-이미지)
- [Chad 캐릭터 이미지](#chad-캐릭터-이미지)
- [푸시업 자세 가이드](#푸시업-자세-가이드)
- [MidJourney 생성 가이드](#midjourney-생성-가이드)
- [에셋 적용](#에셋-적용)

---

## 📅 운동 프로그램 이미지

### 필수 에셋 (14개) - 주차별 일정표

#### 현재 상태
- ✅ **Week 1-6**: 완료 (6개 이미지)
- ❌ **Week 7-14**: 필요 (8개 이미지)

#### 필요한 이미지 목록
7. **7주차_수정-7.jpg** - Week 7 (Day 1: 31개, Day 2: 36개, Day 3: 41개)
8. **8주차_수정-8.jpg** - Week 8 (Day 1: 37개, Day 2: 43개, Day 3: 48개)
9. **9주차_수정-9.jpg** - Week 9 (Day 1: 44개, Day 2: 50개, Day 3: 57개)
10. **10주차_수정-10.jpg** - Week 10 (Day 1: 52개, Day 2: 59개, Day 3: 67개)
11. **11주차_수정-11.jpg** - Week 11 (Day 1: 61개, Day 2: 70개, Day 3: 79개)
12. **12주차_수정-12.jpg** - Week 12 (Day 1: 72개, Day 2: 82개, Day 3: 93개)
13. **13주차_수정-13.jpg** - Week 13 (Day 1: 84개, Day 2: 97개, Day 3: 110개)
14. **14주차_수정-14.jpg** - Week 14 (Day 1: **100개 🎯**, Day 2: 114개, Day 3: 130개)

#### 기술 스펙
- **해상도**: 1600x2150px (8:11 비율)
- **포맷**: JPG
- **스타일**: 기존 1-6주차와 동일한 디자인
- **위치**: `docs/운동/`

#### 생성 방법
1. **추천**: 기존 1주차_수정-1.jpg 디자인 참고하여 Figma/Canva로 제작
2. **대안**: Python + Pillow로 자동 생성 스크립트 작성
3. **시간**: 이미지당 15-20분 × 8개 = 2-3시간

상세 가이드: **[WORKOUT_IMAGE_PLAN.md](WORKOUT_IMAGE_PLAN.md)**

---

## 🔥 Chad 캐릭터 이미지

### 필수 에셋 (15개)

#### Priority 1: 핵심 Chad (5개) ⭐⭐⭐
1. **기본차드.jpg** - 기본 상태, 보통 컨디션
2. **수면차드.jpg** - 피곤한 상태, 휴식 필요
3. **파워차드.jpg** - 강한 컨디션, 높은 에너지
4. **비스트차드.jpg** - 최강 컨디션, 언스터퍼블
5. **축하차드.jpg** - 목표 달성, 레벨업, 업적 해금

#### Priority 2: 진화 Chad (4개) ⭐⭐
6. **진화1차드.jpg** - Rookie Chad (초보자)
7. **진화2차드.jpg** - Rising Chad (중급자)
8. **진화3차드.jpg** - Alpha Chad (고급자)
9. **진화최종차드.jpg** - Giga Chad (마스터)

#### Priority 3: 활동 Chad (6개) ⭐
10. **운동차드.jpg** - 푸시업 운동 중 **(메인 운동, 최우선!)**
11. **스트레칭차드.jpg** - 스트레칭/회복
12. **명상차드.jpg** - 명상/집중
13. **산책차드.jpg** - 야외 산책
14. **요가차드.jpg** - 요가 활동
15. **수영차드.jpg** - 수영 활동

> **Note**: Mission: 100 Push-Ups는 푸시업 전용 앱이므로 **운동차드.jpg**가 가장 중요합니다.

### 기술 스펙
- **해상도**: 1024x1024px (1:1 비율)
- **포맷**: JPG (PNG도 가능)
- **스타일**: 애니메이션/만화 스타일
- **일관성**: 모든 Chad는 동일한 캐릭터

---

## 💪 푸시업 자세 가이드

### 필수 에셋 (7가지 자세)

#### 기본 자세
1. **standard_pushup.jpg** - 표준 푸시업 (어깨 너비)
2. **knee_pushup.jpg** - 무릎 푸시업 (초보자용)

#### 난이도별 변형
3. **wide_pushup.jpg** - 와이드 푸시업 (가슴 강조)
4. **close_pushup.jpg** - 좁은 푸시업 (삼두근 강조)
5. **diamond_pushup.jpg** - 다이아몬드 푸시업 (고급)

#### 각도 변형
6. **decline_pushup.jpg** - 디클라인 푸시업 (상부 가슴)
7. **incline_pushup.jpg** - 인클라인 푸시업 (하부 가슴)

#### 기술 스펙
- **해상도**: 800x600px (4:3 비율)
- **포맷**: PNG (투명 배경) 또는 JPG
- **스타일**: 실사 또는 3D 일러스트
- **위치**: `assets/images/pushup_forms/`

#### MidJourney 프롬프트 예시
```
Athletic person doing standard push-up, side view,
proper form demonstration, clean white background,
fitness tutorial style, detailed anatomy --ar 4:3 --v 6.0
```

---

## 🎨 MidJourney 생성 가이드

상세 가이드: **[CHAD_ASSET_CREATION.md](CHAD_ASSET_CREATION.md)**

### 빠른 시작

#### Step 1: 마스터 Chad 생성 (푸시업 전용)
```
/imagine prompt: Muscular friendly male AI trainer,
tank top, confident smile, cartoon anime style,
clean background, doing push-up pose --ar 1:1 --v 6.0
```

#### Step 2: Character Reference로 나머지 생성
```
/imagine prompt: [마스터 Chad 설명] + [새로운 상황]
--cref [마스터_이미지_URL] --cw 100 --ar 1:1 --v 6.0
```

### 핵심 프롬프트 예시

**운동 Chad (푸시업)** ⭐:
```
[Same character] doing push-up exercise,
proper form, focused expression, training mode
--cref [URL] --cw 100 --ar 1:1
```

**수면 Chad**:
```
[Same character] wearing sleep cap, tired friendly,
sleepy eyes, yawning, soft blue colors
--cref [URL] --cw 100 --ar 1:1
```

**파워 Chad**:
```
[Same character] flexing muscles, confident pose,
determined expression, bold red colors
--cref [URL] --cw 100 --ar 1:1
```

**비스트 Chad**:
```
[Same character] ultimate form, glowing aura,
maximum strength, intense expression, red energy
--cref [URL] --cw 100 --ar 1:1
```

**축하 Chad**:
```
[Same character] celebrating arms raised,
joyful smile, confetti, golden yellow background,
trophy or medal visible
--cref [URL] --cw 100 --ar 1:1
```

### 일관성 보장 파라미터
- `--cref [URL]`: 캐릭터 참조 (얼굴/체형 유지)
- `--cw 100`: Character Weight 최대 (완벽한 일치)
- `--ar 1:1`: 정사각형 비율
- `--v 6.0`: MidJourney V6

---

## 📂 에셋 적용

### 1. 폴더 구조
```
assets/images/
├── chad/
│   ├── condition/
│   │   ├── 기본차드.jpg
│   │   ├── 수면차드.jpg
│   │   ├── 파워차드.jpg
│   │   └── 비스트차드.jpg
│   ├── evolution/
│   │   ├── 진화1차드.jpg        # Rookie Chad
│   │   ├── 진화2차드.jpg        # Rising Chad
│   │   ├── 진화3차드.jpg        # Alpha Chad
│   │   └── 진화최종차드.jpg     # Giga Chad
│   ├── activity/
│   │   ├── 운동차드.jpg         # 푸시업 운동 중 ⭐
│   │   ├── 스트레칭차드.jpg
│   │   ├── 명상차드.jpg
│   │   ├── 산책차드.jpg
│   │   ├── 요가차드.jpg
│   │   └── 수영차드.jpg
│   └── celebration/
│       └── 축하차드.jpg
├── pushup_forms/
│   ├── standard_pushup.jpg
│   ├── knee_pushup.jpg
│   ├── wide_pushup.jpg
│   ├── close_pushup.jpg
│   ├── diamond_pushup.jpg
│   ├── decline_pushup.jpg
│   └── incline_pushup.jpg
└── workout_schedule/
    # 주차별 운동 일정표는 docs/운동/ 폴더에 위치
```

### 2. pubspec.yaml 등록
```yaml
flutter:
  assets:
    - assets/images/chad/condition/
    - assets/images/chad/evolution/
    - assets/images/chad/activity/
    - assets/images/chad/celebration/
    - assets/images/pushup_forms/
    - assets/legal/
```

### 3. 코드 연동

**ChadImageService** (이미 구현됨):
```dart
// lib/services/chad_image_service.dart
ImageProvider getChadImage(String type) {
  return AssetImage('assets/images/chad/condition/기본차드.jpg');
}
```

**사용 위치**:
- `chad_condition_service.dart` - 컨디션별 Chad
- `chad_evolution_service.dart` - 레벨별 Chad
- `chad_active_recovery_service.dart` - 활동별 Chad

### 4. 적용 순서

```bash
# 1. 이미지 배치
cp *.jpg assets/images/chad/condition/

# 2. pubspec.yaml 업데이트
# (위 내용 추가)

# 3. 의존성 갱신
flutter pub get

# 4. 앱 재시작 (Hot Reload는 에셋 변경 감지 안 함)
flutter run

# 5. 테스트
# 홈화면에서 Chad 이미지 확인
```

---

## 📱 앱 아이콘 & 스플래시

### 앱 아이콘 (푸시업 테마)
```bash
# flutter_launcher_icons 사용
flutter pub run flutter_launcher_icons:main
```

**android/app/src/main/res/**:
- mipmap-hdpi (72x72)
- mipmap-mdpi (48x48)
- mipmap-xhdpi (96x96)
- mipmap-xxhdpi (144x144)
- mipmap-xxxhdpi (192x192)

### 스플래시 스크린
```
android/app/src/main/res/drawable/
└── launch_background.xml
```

---

## 🎯 에셋 체크리스트

### 1️⃣ 운동 프로그램 이미지 (우선순위: 높음)
- [x] Week 1-6 이미지 (완료)
- [ ] Week 7 이미지 생성
- [ ] Week 8 이미지 생성
- [ ] Week 9 이미지 생성
- [ ] Week 10 이미지 생성
- [ ] Week 11 이미지 생성
- [ ] Week 12 이미지 생성
- [ ] Week 13 이미지 생성
- [ ] Week 14 이미지 생성 (100개 달성 🎯)

### 2️⃣ Chad 캐릭터 (우선순위: 중간)
#### 생성 전
- [ ] MidJourney 플랜 가입
- [ ] 마스터 Chad 컨셉 결정 (푸시업 자세 포함)
- [ ] 15개 이미지 목록 확인

#### 생성 중
- [ ] 마스터 Chad URL 저장
- [ ] --cref --cw 100 파라미터 사용
- [ ] 각 이미지 일관성 확인
- [ ] 1024x1024 해상도 확인
- [ ] **운동차드.jpg (푸시업)** 먼저 생성

#### 적용 전
- [ ] 모든 이미지 다운로드 완료
- [ ] 파일명 규칙 준수
- [ ] 폴더 구조 생성
- [ ] pubspec.yaml 등록

#### 적용 후
- [ ] flutter pub get 실행
- [ ] 앱에서 이미지 로드 확인
- [ ] 컨디션별 Chad 동작 테스트
- [ ] 레벨업 시 진화 Chad 확인

### 3️⃣ 푸시업 자세 가이드 (우선순위: 낮음)
- [ ] standard_pushup.jpg
- [ ] knee_pushup.jpg
- [ ] wide_pushup.jpg
- [ ] close_pushup.jpg
- [ ] diamond_pushup.jpg
- [ ] decline_pushup.jpg
- [ ] incline_pushup.jpg

---

## 💰 비용 예상

### MidJourney
- **Basic**: $10/월 (200장 Fast 생성)
- 필요: Chad 15장 + 푸시업 자세 7장 = 22장 (여유분 포함 40장)
- **1개월 안에 완성 가능**

### 대안 (무료)
- **DALL-E 3**: ChatGPT Plus ($20/월)
- **Stable Diffusion**: 로컬 실행 (무료, 복잡함)
- ⚠️ 캐릭터 일관성은 MidJourney가 최고

---

## 🔧 문제 해결

### Q: 이미지가 앱에 안 보입니다
```bash
# pubspec.yaml 확인
flutter pub get

# 앱 재시작 (Hot Reload 불가)
flutter run
```

### Q: 파일 크기가 너무 큽니다
```bash
# ImageMagick으로 최적화
convert input.jpg -quality 85 -resize 512x512 output.jpg
```

### Q: Chad 얼굴이 계속 바뀝니다
```
# MidJourney
--cw 100 파라미터 확인
마스터 이미지 URL 정확히 입력
```

---

## 📊 에셋 생성 우선순위

### Phase 1: MVP 필수 에셋 (앱 출시 전)
1. ✅ Week 1-6 운동 프로그램 이미지
2. ❌ Week 7-14 운동 프로그램 이미지 **(최우선)**
3. ❌ 기본차드.jpg + 운동차드.jpg **(최소 2개)**

### Phase 2: 완성도 향상 (출시 후 업데이트)
4. ❌ 컨디션 Chad 4개 (수면, 파워, 비스트, 축하)
5. ❌ 진화 Chad 4개 (레벨별)
6. ❌ 활동 Chad 6개

### Phase 3: 프리미엄 기능 (장기 로드맵)
7. ❌ 푸시업 자세 가이드 7개
8. ❌ 앱 아이콘 리디자인
9. ❌ 스플래시 스크린 애니메이션

---

**마지막 업데이트**: 2025-10-08

**현재 상태**:
- ✅ **6주 프로그램** 완료 → **14주 프로그램**으로 확장
- ✅ **프로그램 데이터** 완료 (완만한 증가 +17.5%)
- ⏳ **7-14주 이미지** 필요 (8개)
- ⏳ **Chad 캐릭터** 필요 (최소 2개: 기본+운동)

**다음 작업**: Week 7-14 운동 프로그램 이미지 생성 (2-3시간 예상)
