# Mission100 v3 배포 체크리스트

## 📋 배포 전 준비 사항

### 1. 코드 품질 검증
- [ ] 모든 단위 테스트 통과 확인 (`flutter test`)
- [ ] 통합 테스트 실제 디바이스에서 실행 확인
- [ ] 코드 분석 통과 (`flutter analyze`)
- [ ] 성능 테스트 결과 검토
- [ ] 메모리 누수 검사 완료

### 2. 빌드 설정 확인
- [ ] `android/app/build.gradle` 버전 정보 업데이트
  - `versionCode` 증가 (정수)
  - `versionName` 업데이트 (예: "1.0.0")
- [ ] `pubspec.yaml` 버전 정보 일치 확인
- [ ] ProGuard 규칙 최신 상태 확인 (`android/app/proguard-rules.pro`)
- [ ] 서명 키스토어 파일 존재 및 접근 가능 확인

### 3. 환경 설정 검증
- [ ] 프로덕션 환경 설정 파일 확인 (`assets/config/prod_config.json`)
  - Firebase 프로덕션 프로젝트 ID
  - API 엔드포인트 URL
  - 광고 유닛 ID (프로덕션)
- [ ] 개발 환경 설정 분리 확인 (`assets/config/dev_config.json`)
- [ ] 민감한 정보가 코드에 하드코딩되지 않았는지 확인

### 4. Firebase 설정 확인
- [ ] Firestore 보안 규칙 배포 (`firebase deploy --only firestore:rules`)
- [ ] Firestore 인덱스 배포 (`firebase deploy --only firestore:indexes`)
- [ ] Firebase 프로젝트 프로덕션 환경 확인
- [ ] Firebase Authentication 제공업체 활성화 확인
- [ ] Cloud Functions 배포 (있는 경우)
- [ ] Firebase 사용량 한도 및 청구 설정 확인

### 5. 인앱 결제 설정
- [ ] Google Play Console에서 인앱 상품 등록 완료
  - `premium_monthly` 상품
  - `premium_yearly` 상품
- [ ] 인앱 상품 ID가 코드와 일치하는지 확인
- [ ] 테스트 계정으로 구매 플로우 테스트 완료
- [ ] 영수증 검증 서버 정상 작동 확인

### 6. 광고 설정
- [ ] AdMob 프로덕션 광고 유닛 ID 설정 확인
- [ ] 광고 테스트 ID에서 프로덕션 ID로 변경 확인
- [ ] 광고 표시 로직 테스트 (프리미엄 사용자 제외)

## 🏗️ 빌드 프로세스

### 1. 릴리스 빌드 생성
```bash
# APK 빌드 (디버깅 및 사이드로드용)
flutter build apk --release

# AAB 빌드 (Play Store 업로드용)
flutter build appbundle --release
```

### 2. 빌드 결과물 확인
- [ ] APK 파일 생성 확인 (`build/app/outputs/flutter-apk/app-release.apk`)
- [ ] AAB 파일 생성 확인 (`build/app/outputs/bundle/release/app-release.aab`)
- [ ] 파일 크기 적정 확인 (AAB < 150MB 권장)
- [ ] APK 분석 도구로 빌드 최적화 확인

### 3. 빌드 테스트
- [ ] 실제 디바이스에 APK 설치 및 테스트
- [ ] 다양한 Android 버전에서 테스트 (minSdk 23 이상)
- [ ] 다양한 화면 크기/해상도에서 테스트
- [ ] 오프라인 모드 동작 확인
- [ ] 권한 요청 플로우 확인

## 📱 Google Play Console 설정

### 1. 앱 정보 업데이트
- [ ] 앱 제목, 짧은 설명, 상세 설명 최신화
- [ ] 스크린샷 업데이트 (최소 2개, 권장 8개)
- [ ] 아이콘 및 그래픽 에셋 확인
- [ ] 프로모션 이미지 준비
- [ ] 개인정보 처리방침 URL 확인

### 2. 릴리스 관리
- [ ] 새 릴리스 버전 생성 (내부 테스트 → 공개 베타 → 프로덕션)
- [ ] AAB 파일 업로드
- [ ] 출시 노트 작성 (한국어/영어)
- [ ] 단계적 출시 비율 설정 (예: 10% → 50% → 100%)

### 3. 콘텐츠 등급 및 정책
- [ ] 콘텐츠 등급 설문조사 완료
- [ ] 개인정보 보호정책 링크 제공
- [ ] 데이터 안전 섹션 작성
- [ ] 광고 포함 여부 명시
- [ ] 인앱 구매 항목 명시

## 🔒 보안 체크리스트

### 1. 코드 보안
- [ ] ProGuard/R8 코드 난독화 활성화 확인
- [ ] 디버그 로그 제거 확인 (ProGuard 규칙으로 자동 제거)
- [ ] API 키 및 비밀 정보 환경 변수로 관리
- [ ] SSL/TLS 인증서 피닝 (필요시)

### 2. Firestore 보안
- [ ] 보안 규칙에서 인증 검증 (`isAuthenticated()`)
- [ ] 데이터 소유권 검증 (`isOwner()`)
- [ ] 비율 제한 규칙 적용 (`isWithinRateLimit()`)
- [ ] 프리미엄 기능 접근 제어 (`isPremiumUser()`)

### 3. 권한 및 개인정보
- [ ] 최소 권한 원칙 준수
- [ ] 개인정보 처리방침 최신화
- [ ] GDPR/CCPA 준수 확인
- [ ] 사용자 데이터 삭제 기능 제공

## 🧪 최종 테스트

### 1. 기능 테스트
- [ ] 회원가입/로그인 플로우
- [ ] 운동 기록 생성/수정/삭제
- [ ] 구독 결제 및 복원
- [ ] 구독 변경 (월간 ↔ 연간)
- [ ] 구독 취소 및 환불
- [ ] 통계 화면 데이터 표시
- [ ] 알림 수신 확인

### 2. 성능 테스트
- [ ] 앱 시작 시간 < 3초
- [ ] 화면 전환 부드러움 (60 FPS)
- [ ] 메모리 사용량 적정 수준
- [ ] 배터리 소모 정상 범위
- [ ] 네트워크 사용량 최적화

### 3. 크래시 테스트
- [ ] Firebase Crashlytics 통합 확인
- [ ] 의도적 크래시 테스트로 리포팅 확인
- [ ] 예외 처리 코드 동작 확인
- [ ] ANR (Application Not Responding) 없음 확인

## 🚀 배포 실행

### 1. 배포 승인
- [ ] 팀 리뷰 및 승인
- [ ] 스테이크홀더 최종 확인
- [ ] 배포 일정 공지

### 2. Play Console 배포
- [ ] 내부 테스트 트랙에 먼저 배포
- [ ] 내부 테스터 그룹 검증 완료
- [ ] 공개 베타 트랙 배포 (선택 사항)
- [ ] 프로덕션 트랙 배포
- [ ] 단계적 출시 시작 (10% 사용자)

### 3. Firebase 배포
```bash
# Firestore 규칙 및 인덱스 배포
firebase deploy --only firestore:rules,firestore:indexes

# Cloud Functions 배포 (있는 경우)
firebase deploy --only functions
```

## 📊 배포 후 모니터링

### 1. 즉시 모니터링 (배포 후 1-24시간)
- [ ] Firebase Crashlytics에서 크래시 리포트 확인
- [ ] Play Console에서 ANR 리포트 확인
- [ ] 사용자 리뷰 및 평점 모니터링
- [ ] Firebase Analytics에서 주요 지표 확인
  - 일일 활성 사용자 (DAU)
  - 세션 시간
  - 화면 조회수
  - 전환율

### 2. 단기 모니터링 (배포 후 1-7일)
- [ ] 크래시 발생률 < 1% 확인
- [ ] ANR 발생률 < 0.5% 확인
- [ ] 구독 전환율 추적
- [ ] 사용자 피드백 수집 및 대응
- [ ] 단계적 출시 비율 증가 (10% → 50% → 100%)

### 3. 장기 모니터링 (배포 후 1-4주)
- [ ] 주요 기능 사용률 분석
- [ ] 사용자 유지율 (Retention Rate) 추적
- [ ] 구독 갱신율 모니터링
- [ ] 구독 해지율 및 해지 사유 분석
- [ ] 성능 지표 (앱 시작 시간, 응답 시간) 추적

### 4. 롤백 기준
다음 조건 시 즉시 롤백 고려:
- [ ] 크래시 발생률 > 5%
- [ ] ANR 발생률 > 2%
- [ ] 중요 기능 사용 불가 (결제, 로그인 등)
- [ ] 보안 취약점 발견
- [ ] 대량의 부정적 리뷰 발생

## 🔧 롤백 프로세스

### 1. 긴급 롤백
```bash
# Play Console에서 이전 버전으로 되돌리기
# 또는 핫픽스 버전 긴급 배포
flutter build appbundle --release
```

### 2. 핫픽스 배포
- [ ] 버그 수정
- [ ] 긴급 테스트 (주요 기능만)
- [ ] versionCode + 1 증가
- [ ] Play Console에 긴급 배포
- [ ] 100% 출시 (단계적 출시 건너뛰기)

## 📝 배포 완료 후 체크리스트

- [ ] 배포 완료 공지 (팀/사용자)
- [ ] 출시 노트 블로그/SNS 게시
- [ ] 모니터링 대시보드 설정 (Firebase/Play Console)
- [ ] 버전 태그 생성 및 Git 푸시
- [ ] 다음 버전 개발 계획 수립
- [ ] 배포 회고 (Retrospective) 진행

---

## 📞 긴급 연락처

- **Firebase 지원**: https://firebase.google.com/support
- **Play Console 지원**: https://support.google.com/googleplay/android-developer
- **팀 리더**: [담당자 연락처]
- **백엔드 팀**: [담당자 연락처]

## 📚 참고 문서

- [Flutter 릴리스 가이드](https://docs.flutter.dev/deployment/android)
- [Firebase 배포 가이드](https://firebase.google.com/docs/cli)
- [Play Console 가이드](https://support.google.com/googleplay/android-developer)
- [인앱 결제 가이드](https://developer.android.com/google/play/billing)

---

**최종 업데이트**: 2025-10-01
**문서 버전**: 1.0.0
**작성자**: Mission100 개발팀
