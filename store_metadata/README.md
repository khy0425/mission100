# 📦 Mission100 스토어 메타데이터

이 디렉토리는 Google Play Store와 Apple App Store에 Mission100 앱을 게시하기 위한 모든 메타데이터를 포함합니다.

## 📁 디렉토리 구조

```
store_metadata/
├── README.md                      # 이 파일
├── google_play_ko.md              # Google Play Store 한국어 메타데이터
├── google_play_en.md              # Google Play Store 영어 메타데이터
├── app_store_ios.md               # App Store (iOS) 메타데이터
├── SCREENSHOT_REQUIREMENTS.md     # 스크린샷 제작 가이드
└── screenshots/                   # 스크린샷 파일들 (추가 예정)
    ├── android/
    │   ├── phone/
    │   ├── tablet_7/
    │   └── tablet_10/
    └── ios/
        ├── iphone_6_7/
        ├── iphone_6_5/
        └── ipad_pro_12_9/
```

## 🎯 ASO (App Store Optimization) 전략

### 핵심 키워드

**한국어**:
1. 푸시업
2. 팔굽혀펴기
3. 운동 앱
4. 홈트레이닝
5. 100개 챌린지

**영어**:
1. push-up
2. pushup workout
3. 100 push-ups
4. home workout
5. fitness app

### 핵심 메시지

✅ **6주 만에 푸시업 100개 달성**
✅ **초보자도 가능한 과학적 프로그램**
✅ **차드 스타일 강력한 동기부여**
✅ **완벽한 진행 추적 및 분석**

## 📝 메타데이터 파일

### 1. [google_play_ko.md](google_play_ko.md)
Google Play Store 한국어 버전 메타데이터
- 앱 제목 (30자)
- 짧은 설명 (80자)
- 전체 설명 (4000자)
- 키워드 우선순위

### 2. [google_play_en.md](google_play_en.md)
Google Play Store 영어 버전 메타데이터
- App Title (30 chars)
- Short Description (80 chars)
- Full Description (4000 chars)
- Keywords Priority

### 3. [app_store_ios.md](app_store_ios.md)
Apple App Store 메타데이터
- App Name (30 chars)
- Subtitle (30 chars)
- Keywords (100 chars)
- Promotional Text (170 chars)
- Description (4000 chars)

### 4. [SCREENSHOT_REQUIREMENTS.md](SCREENSHOT_REQUIREMENTS.md)
스크린샷 제작 요구사항 및 가이드
- 해상도 및 규격
- 8개 스크린샷 기획
- 디자인 가이드라인
- 제작 도구 추천

## ✅ 작업 체크리스트

### Phase 1: 메타데이터 준비 ✅ 완료
- [x] ASO 키워드 리서치 ([docs/ASO_KEYWORDS.md](../docs/ASO_KEYWORDS.md))
- [x] Google Play Store 한국어 메타데이터 작성
- [x] Google Play Store 영어 메타데이터 작성
- [x] App Store (iOS) 메타데이터 작성
- [x] 스크린샷 요구사항 문서 작성
- [x] pubspec.yaml 설명 업데이트

### Phase 2: 비주얼 에셋 제작 🔴 진행 필요
- [ ] 앱 아이콘 디자인 (1024x1024)
- [ ] 앱 아이콘 플랫폼별 변형 생성
- [ ] 스크린샷 8장 제작 (한국어)
- [ ] 스크린샷 8장 제작 (영어)
- [ ] 프로모션 비디오 제작 (선택)

### Phase 3: 스토어 등록 🟡 대기 중
- [ ] Google Play Console 계정 설정
- [ ] App Store Connect 계정 설정
- [ ] 앱 등록 및 메타데이터 입력
- [ ] 스크린샷 업로드
- [ ] 법적 문서 링크 설정
- [ ] 카테고리 및 연령 등급 설정

### Phase 4: 검토 및 출시 🟡 대기 중
- [ ] 스토어 리스팅 미리보기
- [ ] 내부 테스트 (Google Play)
- [ ] TestFlight 베타 테스트 (iOS)
- [ ] 피드백 반영 및 수정
- [ ] 최종 검토 및 제출
- [ ] 출시 승인 대기

## 🚀 다음 단계

### 즉시 필요한 작업

1. **앱 아이콘 제작** 🔴 우선순위 높음
   - 1024x1024 PNG 파일
   - 차드 컨셉 반영
   - 단순하고 임팩트 있는 디자인
   - 참고: [SCREENSHOT_REQUIREMENTS.md](SCREENSHOT_REQUIREMENTS.md)

2. **스크린샷 제작** 🔴 우선순위 높음
   - 8개 스크린샷 (한국어/영어)
   - 1080x1920 해상도
   - 텍스트 오버레이 포함
   - 참고: [SCREENSHOT_REQUIREMENTS.md](SCREENSHOT_REQUIREMENTS.md)

3. **스토어 계정 준비** 🟡 우선순위 중간
   - Google Play Console ($25 일회성)
   - Apple Developer Program ($99/년)

## 📊 A/B 테스트 계획

### Phase 1: 제목 테스트 (출시 직후)
- 버전 A: "Mission100: 6주 푸시업 100개 달성"
- 버전 B: "푸시업 100개: 6주 챌린지"
- 측정 지표: 설치 전환율 (Listing conversion rate)

### Phase 2: 아이콘 테스트 (1개월 후)
- 버전 A: 차드 이미지 중심
- 버전 B: 숫자 "100" 강조
- 측정 지표: 클릭률 (Click-through rate)

### Phase 3: 스크린샷 순서 테스트 (2개월 후)
- 다양한 스크린샷 순서 조합 테스트
- 측정 지표: 설치율, 앱 체류 시간

## 🔗 관련 문서

- [ASO 키워드 전략](../docs/ASO_KEYWORDS.md)
- [개발 태스크](../docs/REMAINING_DEVELOPMENT_TASKS.md)
- [프로젝트 README](../README.md)

## 📞 연락처

문의사항이나 피드백은 다음으로 연락주세요:
- 이메일: support@mission100.com
- GitHub: [Mission100 Repository](https://github.com/yourusername/mission100)

---

**최종 업데이트**: 2025-10-03
**버전**: 2.1.0
**상태**: Phase 1 완료, Phase 2 진행 필요
