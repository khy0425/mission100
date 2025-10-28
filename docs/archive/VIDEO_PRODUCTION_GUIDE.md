# 운동 시연 비디오 제작 가이드

## 목표
실제 사람이 푸쉬업을 시연하는 전문적인 운동 비디오 제작 (앱에서 사용)

## 비디오 스펙

### 기술 요구사항
```yaml
해상도: 1920x1080 (Full HD) 또는 1080x1080 (1:1 정사각형)
프레임레이트: 30fps 또는 60fps
길이: 5-15초 (루프 가능하게)
포맷: MP4 (H.264 코덱)
파일 크기: 각 5MB 이하 (모바일 최적화)
비트레이트: 3-5 Mbps
```

### 스타일 요구사항
- ✅ 깨끗한 단색 배경 (어두운 회색 또는 검정)
- ✅ 전문적인 조명 (3점 조명 또는 소프트박스)
- ✅ 최소 2개 각도 (측면, 정면)
- ✅ 슬로우 모션 또는 일반 속도
- ✅ 루프 가능한 시작/종료 프레임
- ✅ 워터마크 없음

## 제작 방법

### Option 1: 직접 촬영 (추천!)

#### 필요한 장비
**필수:**
- 스마트폰 (iPhone 12 이상 또는 최신 Android)
- 삼각대 또는 폰 거치대
- 밝은 조명 (창문 자연광 또는 링라이트)

**선택:**
- DSLR/미러리스 카메라
- 전문 조명 (소프트박스, LED 패널)
- 녹색 배경천 (크로마키용)

#### 촬영 설정
```
카메라 설정:
- 해상도: 1080p 이상
- FPS: 30fps 또는 60fps (슬로우모션용)
- 화이트밸런스: 자동 또는 수동 (5500K)
- ISO: 최대한 낮게 (100-400)
- 셔터스피드: 1/60 또는 1/120

스마트폰 (iPhone):
- 설정 > 카메라 > 비디오 녹화 > 1080p 60fps 선택
- 그리드 라인 활성화
- AE/AF 잠금 사용
```

#### 촬영 각도
```
1. 측면 뷰 (Side View) - 가장 중요!
   - 카메라를 바닥에서 약 60-80cm 높이에 설치
   - 모델의 정중앙에서 90도 각도
   - 전신이 다 들어오게 프레이밍

2. 정면 뷰 (Front View)
   - 머리 방향에서 촬영
   - 팔과 어깨 움직임 강조

3. 3/4 뷰 (선택)
   - 측면과 정면 사이 45도 각도
   - 입체감 있는 시연
```

#### 조명 세팅
```
기본 3점 조명:

         [Key Light]
              ↓
    [Model] ← [Fill Light]
              ↑
         [Back Light]

또는 간단히:
- 창문 옆에서 자연광 활용
- 링라이트를 카메라 뒤에 설치
- 반사판으로 그림자 제거
```

#### 촬영 팁
```markdown
✅ DO:
- 배경을 깔끔하게 정리
- 모델이 편안한 옷 착용 (단색, 몸 라인이 보이는 옷)
- 여러 번 촬영 (최소 5-10회)
- 워밍업 후 촬영
- 천천히, 정확한 자세로 시연

❌ DON'T:
- 흔들리는 카메라
- 어두운 조명
- 배경에 불필요한 물건
- 너무 빠른 동작
- 프레임 밖으로 나가는 부분
```

### Option 2: 스톡 비디오 구매

#### 추천 사이트
1. **Envato Elements** ($16.50/월 무제한)
   - https://elements.envato.com/
   - 검색어: "push up exercise", "fitness training"
   - 고품질, 다양한 각도

2. **Storyblocks** ($29/월)
   - https://www.storyblocks.com/
   - 무제한 다운로드
   - 상업적 사용 가능

3. **Pexels Videos** (무료!)
   - https://www.pexels.com/videos/
   - 검색: "push up", "workout", "fitness"
   - CC0 라이센스

4. **Pixabay Videos** (무료)
   - https://pixabay.com/videos/
   - 무료, 상업적 사용 가능

#### 선택 기준
- ✅ 깨끗한 배경 (단색 또는 크로마키)
- ✅ 정확한 운동 자세
- ✅ 1080p 이상 해상도
- ✅ 워터마크 없음
- ✅ 상업적 사용 라이센스

### Option 3: AI 비디오 생성 (미래 기술)

**RunwayML Gen-2** (아직 실험 단계)
- 텍스트나 이미지로 비디오 생성
- 품질이 아직 낮음
- 운동 동작은 정확도가 떨어짐

## 편집 작업

### 편집 소프트웨어

#### 무료:
- **DaVinci Resolve** (전문가급, 무료)
- **CapCut** (모바일/PC, 사용 쉬움)
- **iMovie** (Mac)
- **Shotcut** (오픈소스)

#### 유료:
- **Adobe Premiere Pro** (전문가용)
- **Final Cut Pro** (Mac 전문가용)

### 편집 워크플로우

```bash
# 1. 비디오 임포트
- 촬영한 모든 클립 불러오기
- 최고의 테이크 선택

# 2. 기본 편집
- 불필요한 부분 트림
- 시작/종료 프레임 정확히 맞추기
- 루프 가능하게 만들기 (시작과 끝 프레임이 자연스럽게 이어지게)

# 3. 색보정
- 노출 조정
- 콘트라스트 증가
- 채도 약간 증가 (5-10%)
- 배경을 더 어둡게

# 4. 배경 제거/변경 (선택사항)
- 녹색 배경으로 촬영했다면 크로마키
- 단색 배경으로 교체
- 그라디언트 오버레이 추가

# 5. 텍스트/그래픽 오버레이
- 운동 이름 표시
- 카운트 표시 (1-5)
- 근육 부위 하이라이트 (애프터 이펙트 필요)

# 6. 내보내기
- 포맷: MP4 (H.264)
- 해상도: 1080p
- 프레임레이트: 30fps
- 비트레이트: 3-5 Mbps
```

### DaVinci Resolve 빠른 가이드

```bash
# 설치
Download: https://www.blackmagicdesign.com/products/davinciresolve

# 기본 워크플로우
1. Media 탭 → 비디오 임포트
2. Cut 탭 → 타임라인에 드래그
3. Edit 탭 → 트림 및 편집
4. Color 탭 → 색보정
   - Contrast: +10
   - Saturation: +5
   - Lift (shadows): 약간 감소
5. Deliver 탭 → 내보내기
   - Format: MP4
   - Codec: H.264
   - Resolution: 1920x1080
   - Frame Rate: 30
   - Quality: 높음 (5000 kbps)
```

## 근육 하이라이트 효과 추가

### After Effects 사용 (전문가)
```bash
1. 비디오 임포트
2. 마스크 도구로 근육 부위 선택
3. 애니메이션 마스크 (프레임별로 조정)
4. Glow 효과 추가
   - Glow Threshold: 50%
   - Glow Radius: 20
   - Glow Intensity: 1.0
   - Color: #4DABF7 (시안)
5. 내보내기: MP4
```

### 간단한 방법 (CapCut)
```bash
1. 비디오 임포트
2. Effects → Body Effects → Muscle Highlight
3. 색상 변경 → 시안 (#4DABF7)
4. 강도 조절 → 50-70%
5. 내보내기
```

## 파일 구조

```
assets/videos/pushup_forms/
├── correct_form/
│   ├── side_view.mp4          (5-10초, 루프)
│   ├── front_view.mp4         (5-10초, 루프)
│   └── slow_motion.mp4        (10-15초, 0.5x 속도)
│
├── mistakes/
│   ├── back_arch.mp4          (5초)
│   ├── hips_down.mp4          (5초)
│   ├── elbows_out.mp4         (5초)
│   └── head_down.mp4          (5초)
│
├── variations/
│   ├── knee_pushup.mp4        (5-10초)
│   ├── wide_pushup.mp4        (5-10초)
│   ├── diamond_pushup.mp4     (5-10초)
│   ├── decline_pushup.mp4     (5-10초)
│   └── one_arm_pushup.mp4     (5-10초)
│
└── muscle_highlights/
    ├── chest_focus.mp4        (근육 하이라이트 버전)
    ├── triceps_focus.mp4
    └── core_focus.mp4
```

## 코드 통합

### pubspec.yaml 업데이트
```yaml
flutter:
  assets:
    - assets/videos/pushup_forms/correct_form/
    - assets/videos/pushup_forms/mistakes/
    - assets/videos/pushup_forms/variations/
    - assets/videos/pushup_forms/muscle_highlights/
```

### 사용 예시 (기존 VideoPlayerWidget 활용)
```dart
// 이미 구현되어 있는 VideoPlayerWidget 사용
VideoPlayerWidget(
  videoUrl: 'assets/videos/pushup_forms/correct_form/side_view.mp4',
  autoPlay: true,
  loop: true,
  showControls: false,
)
```

## 비용 예상

### DIY (직접 촬영)
```
초기 투자:
- 스마트폰 삼각대: $20-50
- 링라이트: $30-80
- 배경천 (선택): $20-50
합계: $70-180

시간 투자: 1-2일
```

### 스톡 비디오
```
Envato Elements: $16.50/월 (무제한)
또는
개별 구매: $10-30 per clip
20개 필요시: $200-600

시간 투자: 2-3시간 (검색 및 다운로드)
```

### 외주 제작
```
프리랜서 촬영 + 편집:
- Fiverr: $100-500
- Upwork: $200-800
- 전문 스튜디오: $1000-3000

시간 투자: 1-2주 (피드백 포함)
```

## 실전 체크리스트

### 촬영 전
- [ ] 촬영 장소 확보 (깨끗한 배경)
- [ ] 장비 테스트 (카메라, 삼각대, 조명)
- [ ] 모델 섭외 (운동 경험 있는 사람)
- [ ] 의상 준비 (몸 라인이 보이는 운동복)
- [ ] 촬영 리스트 작성 (각도별, 운동별)

### 촬영 중
- [ ] 각 운동당 최소 5회 촬영
- [ ] 측면 + 정면 각도 모두 촬영
- [ ] 느린 속도로 정확하게 시연
- [ ] 촬영 후 바로 확인 (포커스, 노출, 프레이밍)
- [ ] 백업 클립 추가 촬영

### 편집 후
- [ ] 비디오 트림 (5-15초)
- [ ] 색보정 완료
- [ ] 루프 테스트 (자연스럽게 반복되는지)
- [ ] 파일 크기 확인 (각 5MB 이하)
- [ ] 여러 기기에서 재생 테스트
- [ ] 다크모드에서 확인

### 앱 통합
- [ ] assets 폴더에 비디오 파일 추가
- [ ] pubspec.yaml 업데이트
- [ ] VideoPlayerWidget으로 테스트
- [ ] 로딩 속도 확인
- [ ] 메모리 사용량 모니터링

## 추천 워크플로우 (가장 빠름)

### Week 1: 프로토타입
```bash
Day 1-2: Pexels/Pixabay에서 무료 비디오 다운로드
Day 3-4: DaVinci Resolve로 편집 (트림, 색보정)
Day 5:   앱에 통합 및 테스트
```

### Week 2-3: 커스텀 제작
```bash
Day 1:   촬영 계획 및 준비
Day 2:   직접 촬영 또는 모델 섭외
Day 3-4: 편집 작업
Day 5-6: 근육 하이라이트 효과 추가
Day 7:   최종 검토 및 앱 통합
```

## 참고 자료

### 유튜브 튜토리얼
- [How to Film Workout Videos](https://www.youtube.com/results?search_query=how+to+film+workout+videos)
- [DaVinci Resolve Tutorial](https://www.youtube.com/results?search_query=davinci+resolve+tutorial+beginners)
- [Color Grading for Fitness Videos](https://www.youtube.com/results?search_query=color+grading+fitness+videos)

### 영감 자료
- Nike Training Club 앱
- Freeletics 앱
- Jefit 운동 시연
- Strong 앱 비디오들

## 다음 단계

1. **즉시**: Pexels에서 무료 비디오 다운로드해서 테스트
2. **단기**: 직접 촬영 계획 수립
3. **장기**: 전체 운동 라이브러리 제작

---

💡 **Pro Tip**: 시작은 무료 스톡 비디오로 하고, 앱이 성장하면 커스텀 제작으로 업그레이드하세요!
