# 🚀 배포 체크리스트

## 📋 목차
- [배포 전 체크리스트](#배포-전-체크리스트)
- [Release 빌드](#release-빌드)
- [Play Store 배포](#play-store-배포)
- [출시 후 모니터링](#출시-후-모니터링)

---

## ✅ 배포 전 체크리스트

### 코드 품질
- [ ] `flutter analyze` 통과
- [ ] `flutter test` 모두 통과
- [ ] `dart format .` 완료
- [ ] TODO/FIXME 해결 또는 이슈 생성

### 기능 테스트
- [ ] 로그인/회원가입 정상 작동
- [ ] 운동 기록 저장/불러오기
- [ ] Firebase 연동 확인
- [ ] 구독/결제 기능 (sandbox)
- [ ] 오프라인 모드 동작
- [ ] 푸시 알림 수신

### 리소스
- [ ] 모든 이미지 에셋 포함
- [ ] Chad 이미지 15개 완료
- [ ] 다국어 번역 완료 (ko, en)
- [ ] 앱 아이콘 설정
- [ ] 스플래시 스크린 설정

### 문서
- [ ] README.md 최신화
- [ ] CHANGELOG.md 업데이트
- [ ] 버전 번호 업데이트 (pubspec.yaml)
- [ ] 출시 노트 작성

### 보안
- [ ] API 키 노출 확인 (git log 검사)
- [ ] google-services.json gitignore 확인
- [ ] Firestore 보안 규칙 검증
- [ ] 민감 정보 환경 변수 처리

---

## 🔨 Release 빌드

상세 가이드: **[RELEASE_BUILD.md](RELEASE_BUILD.md)**

### 빠른 실행

1. **버전 업데이트**
   ```yaml
   # pubspec.yaml
   version: 1.0.0+1
   ```

2. **빌드**
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

3. **검증**
   ```bash
   # 서명 확인
   jarsigner -verify build/app/outputs/flutter-apk/app-release.apk

   # 실제 기기 테스트
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

---

## 📱 Play Store 배포

### 1. Play Console 준비

#### 스토어 등록 정보
```
앱 이름: Mission100
짧은 설명: 100일 푸쉬업 챌린지 - Chad AI 트레이너
전체 설명: [출시 노트 참고]

카테고리: 건강 및 피트니스
연령 등급: 전체 이용가
```

#### 스크린샷 요구사항
- **Phone**: 16:9 또는 9:16 (최소 2장, 최대 8장)
- **7-inch Tablet**: 16:9 또는 9:16 (선택)
- **10-inch Tablet**: 16:9 또는 9:16 (선택)

필수 스크린샷:
1. 홈 화면 (Chad 컨디션)
2. 운동 화면
3. 진화/레벨업
4. 통계 화면
5. 설정 화면

#### 앱 아이콘
- **512x512px** PNG (Play Console용)
- **1024x1024px** PNG (Feature Graphic)

### 2. APK/AAB 업로드

**권장: AAB (Android App Bundle)**
```bash
flutter build appbundle --release
```

**Play Console 업로드**:
1. 프로덕션 → 새 릴리스 만들기
2. APK/AAB 업로드
3. 출시 노트 작성
4. 검토 시작

### 3. 출시 노트 템플릿

```markdown
## 버전 1.0.0

### 🎉 새로운 기능
- Chad AI 트레이너와 함께하는 100일 챌린지
- 개인 맞춤형 운동 프로그램
- RPE 기반 강도 조절
- 실시간 컨디션 모니터링

### 💪 개선사항
- 운동 기록 자동 저장
- 오프라인 모드 지원
- 한국어/영어 지원

### 🐛 버그 수정
- 초기 로딩 속도 개선
- Firebase 연동 안정화
```

---

## 📊 출시 후 모니터링

### 1일차
- [ ] Play Console에서 앱 심사 상태 확인
- [ ] 충돌 보고서 모니터링
- [ ] 사용자 리뷰 확인
- [ ] Firebase Analytics 데이터 확인

### 1주차
- [ ] 일일 활성 사용자(DAU) 추적
- [ ] 주요 기능 사용률 분석
- [ ] 구독 전환율 확인
- [ ] 평균 평점 모니터링

### 1개월차
- [ ] 월간 활성 사용자(MAU) 분석
- [ ] 리텐션 율 계산
- [ ] 주요 이탈 지점 파악
- [ ] 사용자 피드백 수집 및 개선

### Firebase Analytics 주요 지표

**핵심 이벤트**:
```dart
// 운동 완료
Analytics.logEvent('workout_completed', {
  'type': 'pushup',
  'reps': 100,
  'level': 'intermediate'
});

// 레벨업
Analytics.logEvent('level_up', {
  'from': 'beginner',
  'to': 'intermediate'
});

// 구독 시작
Analytics.logEvent('subscription_started', {
  'tier': 'premium',
  'duration': 'monthly'
});
```

---

## 🔥 긴급 대응

### 심각한 버그 발견 시

1. **평가**
   - 영향 범위 확인
   - 재현 가능 여부
   - 보안 위험 여부

2. **긴급 수정**
   ```bash
   # Hotfix 브랜치
   git checkout -b hotfix/critical-bug

   # 수정 및 테스트
   # ...

   # 배포
   flutter build apk --release
   ```

3. **긴급 배포**
   - 버전 번호: patch 증가 (1.0.0 → 1.0.1)
   - Play Console: 긴급 배포 요청
   - 사용자 공지

4. **사후 조치**
   - 원인 분석
   - 재발 방지 대책
   - 테스트 케이스 추가

---

## 📈 버전 관리 전략

### Semantic Versioning
```
major.minor.patch+buildNumber
```

- **Major** (1.x.x): 호환성 깨지는 변경
- **Minor** (x.1.x): 기능 추가 (호환)
- **Patch** (x.x.1): 버그 수정
- **Build** (+1): 빌드 번호 (자동 증가)

### 예시
```
1.0.0+1  → 초기 출시
1.0.1+2  → 버그 수정
1.1.0+3  → 새 기능 추가
2.0.0+4  → 주요 변경
```

---

## 🎯 출시 성공 기준

### 기술적 지표
- ✅ 충돌률 < 1%
- ✅ ANR (응답 없음) < 0.5%
- ✅ 평균 평점 > 4.0
- ✅ 1일 리텐션 > 40%
- ✅ 7일 리텐션 > 20%

### 비즈니스 지표
- ✅ DAU > 100명 (첫 주)
- ✅ 구독 전환율 > 5%
- ✅ 운동 완료율 > 60%
- ✅ Chad 상호작용률 > 80%

---

**마지막 업데이트**: 2025-10-02

**다음 출시 예정**: v1.1.0 (새 기능)
**다음 마일스톤**: 1000 DAU
