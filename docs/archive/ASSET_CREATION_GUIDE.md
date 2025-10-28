# 푸쉬업 폼 가이드 에셋 제작 가이드

## 필요한 에셋 목록

### 1. 올바른 자세 (Correct Form)
- **정면 뷰** (Front View): `assets/images/pushup_forms/correct/front_view.png`
- **측면 뷰** (Side View): `assets/images/pushup_forms/correct/side_view.png`
- **애니메이션** (GIF): `assets/images/pushup_forms/correct/full_motion.gif`

### 2. 잘못된 자세 (Common Mistakes)
- **등이 아치형** (Back Arch): `assets/images/pushup_forms/mistakes/back_arch.png`
- **엉덩이 처짐** (Hips Down): `assets/images/pushup_forms/mistakes/hips_down.png`
- **팔꿈치 벌림** (Elbows Out): `assets/images/pushup_forms/mistakes/elbows_out.png`
- **머리 숙임** (Head Down): `assets/images/pushup_forms/mistakes/head_down.png`

### 3. 근육 강조 이미지 (Muscle Highlights)
- **가슴** (Chest): `assets/images/pushup_forms/muscles/chest_highlighted.png`
- **삼두근** (Triceps): `assets/images/pushup_forms/muscles/triceps_highlighted.png`
- **코어** (Core): `assets/images/pushup_forms/muscles/core_highlighted.png`
- **어깨** (Shoulders): `assets/images/pushup_forms/muscles/shoulders_highlighted.png`

### 4. 변형 운동 (Variations)
#### 초급 (Beginner)
- **무릎 푸쉬업**: `assets/images/pushup_forms/variations/knee_pushup.png`
- **벽 푸쉬업**: `assets/images/pushup_forms/variations/wall_pushup.png`

#### 중급 (Intermediate)
- **와이드 푸쉬업**: `assets/images/pushup_forms/variations/wide_pushup.png`
- **다이아몬드 푸쉬업**: `assets/images/pushup_forms/variations/diamond_pushup.png`

#### 고급 (Advanced)
- **원암 푸쉬업**: `assets/images/pushup_forms/variations/one_arm_pushup.png`
- **플라이오메트릭**: `assets/images/pushup_forms/variations/plyometric_pushup.png`

## 이미지 스펙

### 기본 요구사항
- **해상도**: 1920x1080 (16:9) 또는 1080x1080 (1:1)
- **포맷**: PNG (투명 배경) 또는 JPG (어두운 배경)
- **파일 크기**: 각 500KB 이하 (모바일 최적화)
- **색상 프로필**: sRGB

### 스타일 가이드
- **배경**: 다크 그레이 (#0D0D0D ~ #1A1A1A)
- **메인 모델**: 회색/흰색 톤
- **하이라이트 색상**:
  - 주요 근육: 시안 (#4DABF7)
  - 보조 근육: 그린 (#51CF66)
  - 경고/실수: 레드 (#FF6B6B)
  - 중립: 옐로우 (#FFD43B)

## 제작 도구 옵션

### Option 1: Blender (무료, 전문가용)
```bash
# 설치
Download from: https://www.blender.org/

# 워크플로우
1. Import base character model (MakeHuman)
2. Rig and pose for push-up positions
3. Apply materials with emission shader for highlights
4. Render with Cycles/Eevee
5. Export as PNG sequence or GIF
```

### Option 2: Mixamo + Blender
```bash
# Mixamo에서 캐릭터와 애니메이션 다운로드
1. Visit: https://www.mixamo.com/
2. Select character model
3. Apply push-up related animations
4. Download as FBX

# Blender에서 마무리
1. Import FBX
2. Adjust camera angles
3. Add highlight materials
4. Render
```

### Option 3: AI 이미지 생성
```
Midjourney/DALL-E 프롬프트 템플릿:

"3D anatomical render of [POSE_DESCRIPTION],
highlighting [MUSCLE_GROUP] in cyan glow,
dark studio background, professional fitness illustration,
clean minimalist style, side view, 4k quality"

예시:
"3D anatomical render of male figure in perfect push-up form,
highlighting chest muscles in cyan glow,
dark studio background, professional fitness illustration,
clean minimalist style, side view, 4k quality"
```

## GIF 애니메이션 제작

### 사용 도구
- **ezgif.com** (온라인, 무료)
- **Photoshop** (전문가용)
- **GIMP** (무료)

### 스펙
- **프레임 수**: 15-30 frames
- **FPS**: 15-24
- **크기**: 800x600 또는 1000x1000
- **최적화**: Lossy compression (80-90%)
- **최대 파일 크기**: 2MB

### 애니메이션 시퀀스
```
Frame 1-8:   시작 자세 (Plank position)
Frame 9-15:  내려가기 (Down phase)
Frame 16:    최하단 (Bottom position)
Frame 17-23: 올라가기 (Up phase)
Frame 24-30: 시작 자세로 복귀 (Return to start)
```

## 빠른 프로토타이핑 방법

### 임시 에셋 사용
현재 코드에서 placeholder 이미지를 사용하고 있으므로:

1. **단계별 진행**:
   - Phase 1: 기본 스틱 피규어나 간단한 일러스트
   - Phase 2: 스톡 이미지 구매 (Envato, Shutterstock)
   - Phase 3: 커스텀 3D 렌더링

2. **무료 스톡 리소스**:
   - Pexels
   - Unsplash
   - Pixabay
   - Freepik (무료 계정)

## 라이센스 및 저작권

### 주의사항
- 상업적 사용 가능한 라이센스 확인
- 크레딧 표시 필요 여부 확인
- AI 생성 이미지의 상업적 사용 권한 확인

### 추천 라이센스
- CC0 (Public Domain)
- Creative Commons Attribution
- Commercial Use Allowed

## 구현 체크리스트

- [ ] 디렉토리 구조 생성
- [ ] 올바른 자세 이미지 (3개)
- [ ] 잘못된 자세 이미지 (4개)
- [ ] 근육 하이라이트 이미지 (4개)
- [ ] 변형 운동 이미지 (6개)
- [ ] 애니메이션 GIF (2-3개)
- [ ] 이미지 최적화 (압축)
- [ ] 코드에서 경로 업데이트
- [ ] 다크모드 호환성 테스트
- [ ] 다양한 화면 크기에서 테스트

## 예상 타임라인

### 옵션별 소요 시간
- **AI 생성**: 1-2일 (프롬프트 조정 포함)
- **스톡 이미지 구매/편집**: 2-3일
- **Mixamo + Blender**: 3-5일 (기본 Blender 지식 있는 경우)
- **전문 3D 제작**: 1-2주 (Blender 처음 배우는 경우)

## 참고 자료

### 튜토리얼
- [Blender for Fitness Illustrations](https://www.youtube.com/results?search_query=blender+fitness+illustration)
- [Creating Exercise GIFs](https://www.youtube.com/results?search_query=creating+exercise+gifs)

### 영감 자료
- ExRx.net - 운동 데이터베이스
- Jefit - 운동 앱
- Strong - 피트니스 앱
- Nike Training Club

## 연락처 및 지원
프로젝트 관련 질문: [GitHub Issues](https://github.com/...)
