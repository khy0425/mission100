# 📱 Mission100 앱 스토어 이미지 가이드

**날짜**: 2025-10-20
**목적**: Apple App Store & Google Play Store 출시용 이미지 제작

---

## 📋 필요한 이미지 목록

### 1. 앱 아이콘 (필수) ⭐⭐⭐⭐⭐
- **크기**: 1024×1024px
- **형식**: PNG
- **용도**: App Store, Google Play, 앱 내 표시
- **상태**: 🔄 제작 중
- **가이드**: `APP_ICON_MIDJOURNEY_PROMPTS.md` 참조

---

### 2. 스크린샷 (필수) ⭐⭐⭐⭐⭐

#### Apple App Store
- **최소**: 6.7인치 디스플레이 스크린샷 (최소 3장, 최대 10장)
- **권장 크기**: 1290×2796px (iPhone 15 Pro Max)
- **대체 크기**: 1242×2688px (iPhone 11 Pro Max)
- **형식**: PNG 또는 JPG

#### Google Play Store
- **최소**: 2장 (휴대전화용)
- **최대**: 8장
- **크기**:
  - 최소: 320px (짧은 쪽)
  - 최대: 3840px (긴 쪽)
- **권장**: 1080×1920px 또는 1080×2340px
- **형식**: PNG 또는 JPG

**상태**: ⏸️ 대기 중 (앱 구현 후 캡처)

---

### 3. Feature Graphic (Google Play 전용, 필수) ⭐⭐⭐⭐⭐
- **크기**: 1024×500px (가로)
- **형식**: PNG 또는 JPG
- **용도**: Google Play 스토어 상단 배너
- **상태**: 🔄 제작 예정

---

### 4. 프로모 이미지 (선택사항) ⭐⭐
- **Apple App Store**: 1024×1024px (iPad Pro용 앱 미리보기 포스터)
- **용도**: 동영상 미리보기 대신 표시되는 이미지
- **상태**: ⏸️ 선택사항 (나중에)

---

## 📸 스크린샷 가이드

### 캡처할 화면 (8장)

#### 1. 메인 화면 (홈)
**내용**: Week 진행 상황 + Chad 진화 단계 + 오늘의 운동
**포인트**:
- 사용자가 가장 먼저 보는 화면
- Week 6-8 정도 진행된 상태 (중간 진화)
- 다음 운동 버튼 강조

---

#### 2. 운동 세션 화면
**내용**: 실제 운동 중 화면 (세트 진행 중)
**포인트**:
- SET 3/5 같은 중간 진행 상태
- 타이머 또는 카운터 표시
- 클린한 UI

---

#### 3. 운동 완료 화면
**내용**: 세트 완료 축하 화면 또는 RPE 선택
**포인트**:
- 성취감을 주는 화면
- "잘했어요!" 메시지
- 통계 요약

---

#### 4. Chad 진화 화면
**내용**: Chad 진화 알림 또는 진화 갤러리
**포인트**:
- Week 4 → Week 6 진화 같은 중간 단계
- 비포/애프터 비교
- 다음 진화까지 진행률

---

#### 5. 통계/진행 상황 화면
**내용**: 주간/월간 통계, 그래프
**포인트**:
- 상승하는 그래프 (동기부여)
- 총 푸시업 개수, 완료 세션 등
- 시각적으로 데이터 표현

---

#### 6. 캘린더 화면
**내용**: 14주 전체 운동 기록 캘린더
**포인트**:
- 완료일 초록색 체크
- 진화 주차 금색 표시
- 일관성 있는 운동 기록

---

#### 7. 업적/배지 화면
**내용**: 획득한 업적 목록
**포인트**:
- 여러 개 배지 획득 상태
- "첫 주 완료", "첫 진화" 등
- 게임화 요소 강조

---

#### 8. 설정/프로필 화면 (선택)
**내용**: 사용자 설정 또는 프로필
**포인트**:
- 레벨 선택
- 알림 설정
- 과학적 근거 링크

---

### 스크린샷 촬영 팁

#### 준비사항
1. **테스트 데이터 입력**:
   - Week 6-8 정도 진행
   - 여러 운동 완료 기록
   - 2-3개 진화 완료
   - 여러 배지 획득

2. **깔끔한 상태**:
   - 배터리 100%
   - 시간 9:41 (애플 기본)
   - 알림 없음
   - WiFi 연결

3. **밝은 모드**: 다크모드보다 스크린샷이 더 잘 보임

#### 캡처 방법
- **iOS**: 볼륨 Up + 전원 버튼
- **Android**: 볼륨 Down + 전원 버튼
- 또는 **Flutter**: `flutter screenshot` 명령어

#### 편집
- 안전 영역 내 중요한 UI 위치 확인
- 상단 노치/펀치홀 고려
- 필요시 프레임 추가 (예: 디바이스 목업)

---

## 🎨 Feature Graphic 가이드 (Google Play)

### 크기
- **1024×500px** (가로형)

### 디자인 컨셉

#### 옵션 A: Chad 진화 + "100" 타이포
```
좌측: Week 0 Chad (작고 약함)
중앙: 큰 "Mission100" 로고 또는 "100" 숫자
우측: Week 14 Chad (크고 강함)
배경: 빨강→금색 그라데이션
```

#### 옵션 B: 14주 타임라인
```
좌측→우측: 14주 진행 바
7개 Chad 진화 단계 표시
상단: "14주 만에 푸시업 100개"
하단: "과학적으로 검증된 프로그램"
```

#### 옵션 C: 미니멀 타이포
```
배경: 단색 빨강 또는 그라데이션
중앙: 큰 "100"
하단: "14 Weeks to 100 Push-Ups"
```

---

### MidJourney 프롬프트 (Feature Graphic)

#### 프롬프트 A: 진화 비교 (추천!)
```
Google Play feature graphic banner design, 1024x500 pixels horizontal,
muscular transformation journey, weak person at left side gradually
transforming into strong Chad at right side, diagonal progression from
bottom left to top right, number "100" in center, "Mission100" text,
red to gold gradient background, motivational fitness banner,
modern professional design --ar 1024:500 --s 40
```

---

#### 프롬프트 B: 타임라인
```
Google Play feature graphic banner, horizontal 1024x500 design,
14 week fitness journey timeline, 7 evolution checkpoints,
Week 0 to Week 14 progression, ascending path visualization,
"Mission100" title text, "14 Weeks to 100 Push-Ups" subtitle,
red and gold gradient, motivational and energetic --ar 1024:500 --s 40
```

---

#### 프롬프트 C: 미니멀
```
Google Play feature graphic banner, 1024x500 horizontal format,
bold number "100" centered, "Mission100" text logo,
"14 Weeks to 100 Push-Ups" subtitle, red to gold gradient background,
modern minimalist fitness app banner, clean and professional --ar 1024:500 --s 40
```

---

## ✅ 제작 우선순위

### Phase 1: 필수 (출시 전 필요)
1. ✅ 앱 아이콘 (1024×1024) - 🔄 진행 중
2. ⏸️ Feature Graphic (1024×500) - Google Play 필수
3. ⏸️ 스크린샷 8장 - 앱 구현 후 캡처

### Phase 2: 선택사항 (나중에)
4. ⏸️ 프로모 이미지
5. ⏸️ 동영상 미리보기
6. ⏸️ 태블릿용 스크린샷

---

## 📝 체크리스트

### 앱 아이콘
- [ ] 1024×1024px PNG
- [ ] 불투명 배경
- [ ] 여러 크기에서 테스트
- [ ] 브랜드 일관성

### Feature Graphic (Google Play)
- [ ] 1024×500px PNG/JPG
- [ ] 가독성 확인 (작은 크기에서도)
- [ ] 텍스트 안전 영역 준수
- [ ] 브랜드 컬러 사용

### 스크린샷
- [ ] 최소 3장 (App Store)
- [ ] 최소 2장 (Google Play)
- [ ] 권장: 8장 (다양한 기능 표시)
- [ ] 1290×2796px (iOS) 또는 1080×1920px (Android)
- [ ] 깔끔한 테스트 데이터
- [ ] 밝은 모드
- [ ] 배터리/시간 정리

---

## 📚 참고 자료

### 공식 가이드라인
- [Apple App Store 스크린샷 가이드](https://developer.apple.com/app-store/product-page/)
- [Google Play 그래픽 에셋 가이드](https://support.google.com/googleplay/android-developer/answer/9866151)

### 도구
- **디바이스 프레임**: [Mockuphone](https://mockuphone.com/)
- **스크린샷 편집**: Figma, Canva, Photoshop
- **배경 제거**: Remove.bg

---

**다음 단계**:
1. 앱 아이콘 MidJourney로 생성 → `APP_ICON_MIDJOURNEY_PROMPTS.md` 참조
2. Feature Graphic 생성 (위 프롬프트 사용)
3. 앱 구현 완료 후 스크린샷 8장 캡처
