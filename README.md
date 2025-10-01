# 💪 Mission100: 100일 푸쉬업 챌린지

> **Chad 스타일 동기부여로 무적의 체력 완성!** 🔥

## 🎯 Mission100이란?

**100일 동안 푸쉬업 챌린지를 완주**하여 진정한 **Chad**가 되는 앱입니다.

- 🔥 **극한의 동기부여**: Chad 스타일 공격적 메시징
- 📊 **과학적 프로그레션**: 레벨별 체계적인 발전 시스템
- 🏆 **달성 시스템**: 매 단계마다 성취감 극대화
- 🌍 **다국어 지원**: 한국어, 영어 Chad 메시징

## 🚀 핵심 기능

### 💀 Chad 모드 활성화
```
🔥 OK, 만삣삐! 🔥    (한국어)
🔥 HELL YEAH, BRO! 🔥 (영어)
```

### 📈 단계별 프로그레션
- **초보자**: 기본 푸쉬업 마스터
- **중급자**: 변형 푸쉬업 도전
- **고급자**: 극한 챌린지 모드
- **Chad**: 인간을 초월한 레벨

### 🎮 게이미피케이션
- 실시간 피드백 시스템
- 달성별 뱃지 수집
- 연속 도전 스트릭 관리
- 소셜 공유 기능

## 🛠 기술 스택

- **Flutter**: 크로스 플랫폼 앱 개발
- **Dart**: 메인 프로그래밍 언어
- **i18n**: 다국어 지원 (한국어/영어)
- **Chad Engine**: 동기부여 메시징 시스템

## ⚠️ 보안 설정 필수

**이 저장소는 보안상 Firebase 설정 파일을 포함하지 않습니다.**

시작하기 전에 반드시 [SECURITY_SETUP.md](SECURITY_SETUP.md)를 참고하여 Firebase 구성을 완료하세요.

필요한 파일:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart`

자동화 스크립트 사용:
```bash
# Windows
scripts\revoke_exposed_keys.bat

# Linux/Mac
scripts/revoke_exposed_keys.sh
```

## 📱 설치 및 실행

```bash
# 의존성 설치
flutter pub get

# i18n 파일 생성
flutter gen-l10n

# 앱 실행 (Debug)
flutter run

# Debug APK 빌드
flutter build apk --debug
```

### Release 빌드
프로덕션 배포는 [Release 빌드 가이드](docs/RELEASE_BUILD.md) 참고

## 🔄 CI/CD

### 자동화 (GitHub Actions)
- ✅ 코드 품질 검사 (analyze, format)
- ✅ 단위 테스트 자동 실행
- ✅ Debug APK 빌드 및 검증

### 수동 배포
- 🔐 Release APK는 로컬에서 빌드
- 📱 Play Console에서 수동 업로드
- 상세 가이드: [docs/RELEASE_BUILD.md](docs/RELEASE_BUILD.md)

## 🎊 개발 현황

- ✅ Chad 스타일 UI/UX 완성
- ✅ 한국어/영어 다국어 지원
- ✅ 기본 푸쉬업 프로그레션 시스템
- ✅ 달성 시스템 구현
- 🚧 소셜 기능 개발중
- 🚧 고급 운동 모드 추가중

## 🔥 Chad 철학

**"약함은 선택이다. 강함은 의무다!"**

Mission100은 단순한 운동 앱이 아닙니다.
당신의 한계를 깨고 진정한 Chad로 거듭나게 하는 **변혁의 도구**입니다.

---

**Made with 💪 by Chad Developers**
*Weakness is not an option!*