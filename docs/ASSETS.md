# 🎨 Mission100 에셋 가이드

## 📋 목차
- [Chad 캐릭터 이미지](#chad-캐릭터-이미지)
- [MidJourney 생성 가이드](#midjourney-생성-가이드)
- [에셋 적용](#에셋-적용)

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
6. **진화1차드.jpg** - Beginner 레벨
7. **진화2차드.jpg** - Intermediate 레벨
8. **진화3차드.jpg** - Advanced 레벨
9. **진화최종차드.jpg** - Chad Master 레벨

#### Priority 3: 활동 Chad (6개) ⭐
10. **운동차드.jpg** - 푸시업 운동 중
11. **스트레칭차드.jpg** - 스트레칭/회복
12. **명상차드.jpg** - 명상/집중
13. **산책차드.jpg** - 야외 산책
14. **요가차드.jpg** - 요가 활동
15. **수영차드.jpg** - 수영 활동

### 기술 스펙
- **해상도**: 1024x1024px (1:1 비율)
- **포맷**: JPG (PNG도 가능)
- **스타일**: 애니메이션/만화 스타일
- **일관성**: 모든 Chad는 동일한 캐릭터

---

## 🎨 MidJourney 생성 가이드

상세 가이드: **[CHAD_ASSET_CREATION.md](CHAD_ASSET_CREATION.md)**

### 빠른 시작

#### Step 1: 마스터 Chad 생성
```
/imagine prompt: Muscular friendly male AI trainer,
tank top, confident smile, cartoon anime style,
clean background, energetic pose --ar 1:1 --v 6.0
```

#### Step 2: Character Reference로 나머지 생성
```
/imagine prompt: [마스터 Chad 설명] + [새로운 상황]
--cref [마스터_이미지_URL] --cw 100 --ar 1:1 --v 6.0
```

### 핵심 프롬프트 예시

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

**축하 Chad**:
```
[Same character] celebrating arms raised,
joyful smile, confetti, golden yellow background
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
│   ├── 명상차드.jpg
│   ├── 산책차드.jpg
│   ├── 요가차드.jpg
│   └── 수영차드.jpg
└── celebration/
    └── 축하차드.jpg
```

### 2. pubspec.yaml 등록
```yaml
flutter:
  assets:
    - assets/images/chad/condition/
    - assets/images/chad/evolution/
    - assets/images/chad/activity/
    - assets/images/chad/celebration/
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

## 🎯 에셋 체크리스트

### 생성 전
- [ ] MidJourney 플랜 가입
- [ ] 마스터 Chad 컨셉 결정
- [ ] 15개 이미지 목록 확인

### 생성 중
- [ ] 마스터 Chad URL 저장
- [ ] --cref --cw 100 파라미터 사용
- [ ] 각 이미지 일관성 확인
- [ ] 1024x1024 해상도 확인

### 적용 전
- [ ] 모든 이미지 다운로드 완료
- [ ] 파일명 규칙 준수
- [ ] 폴더 구조 생성
- [ ] pubspec.yaml 등록

### 적용 후
- [ ] flutter pub get 실행
- [ ] 앱에서 이미지 로드 확인
- [ ] 컨디션별 Chad 동작 테스트
- [ ] 레벨업 시 진화 Chad 확인

---

## 🖼️ 기타 에셋

### 푸시업 자세 가이드
```
assets/images/pushup_forms/
├── standard/
├── wide/
├── close/
├── diamond/
├── decline/
├── incline/
└── knee/
```

### 앱 아이콘
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

## 💰 비용 예상

### MidJourney
- **Basic**: $10/월 (200장 Fast 생성)
- 필요: 15장 에셋 (여유분 포함 30장)
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

**마지막 업데이트**: 2025-10-02

**에셋 생성 상태**:
- [x] 기본차드.jpg
- [ ] 수면차드.jpg
- [ ] 파워차드.jpg
- [ ] 비스트차드.jpg
- [ ] 축하차드.jpg
- [ ] 진화 Chad 4개
- [ ] 활동 Chad 6개
