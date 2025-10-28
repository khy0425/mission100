# 📦 Release 빌드 가이드

Mission100 앱의 프로덕션 릴리스 빌드 및 배포 가이드입니다.

## 🎯 배포 전략

### CI/CD (자동)
- ✅ 코드 품질 검사 (analyze, format)
- ✅ 단위 테스트 실행
- ✅ Debug APK 빌드 및 검증

### Release 배포 (수동)
- 🔐 로컬에서 Release APK 빌드
- 📱 Play Console에서 수동 업로드
- ✅ 최종 품질 검토 및 승인

**왜 수동 배포?**
- keystore 보안 유지 (GitHub 노출 방지)
- 배포 전 최종 검토 단계
- 실수 배포 방지

## 🚀 Release 빌드 프로세스

### 1. 사전 준비

#### 버전 업데이트
`pubspec.yaml` 파일에서 버전 번호 업데이트:
```yaml
version: 1.0.1+2  # 1.0.1은 버전명, 2는 빌드 번호
```

버전 규칙:
- **major.minor.patch+buildNumber**
- 예: 1.2.3+4
  - major: 주요 변경 (1.x.x)
  - minor: 기능 추가 (x.1.x)
  - patch: 버그 수정 (x.x.1)
  - buildNumber: 빌드 번호 (항상 증가)

#### Firebase 설정 확인
```bash
# google-services.json 존재 확인
ls android/app/google-services.json
```

없으면 [SECURITY_SETUP.md](../SECURITY_SETUP.md) 참고

### 2. 로컬 테스트

```bash
# 의존성 업데이트
flutter pub get

# 코드 포맷팅
dart format .

# 분석
flutter analyze --no-fatal-infos --no-fatal-warnings

# 테스트
flutter test

# Debug 빌드로 테스트
flutter run --debug
```

### 3. Release APK 빌드

#### Keystore 설정 (최초 1회)

1. **keystore 생성** (처음만):
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

2. **key.properties 생성**:
```bash
# android/key.properties
storePassword=<keystore 비밀번호>
keyPassword=<key 비밀번호>
keyAlias=upload
storeFile=<keystore 절대 경로>
```

**⚠️ 중요: keystore와 비밀번호는 안전하게 백업!**

#### Release 빌드 실행

```bash
# Clean build
flutter clean

# 의존성 재설치
flutter pub get

# Release APK 빌드
flutter build apk --release

# 빌드 완료 확인
ls -lh build/app/outputs/flutter-apk/app-release.apk
```

빌드 시간: 약 3-5분

### 4. 빌드 검증

```bash
# APK 정보 확인
aapt dump badging build/app/outputs/flutter-apk/app-release.apk | grep version

# APK 크기 확인 (권장: 50MB 이하)
du -h build/app/outputs/flutter-apk/app-release.apk

# 서명 확인
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk
```

### 5. 실제 기기 테스트

```bash
# APK 설치
adb install build/app/outputs/flutter-apk/app-release.apk

# 앱 실행 및 테스트
# - 로그인/회원가입
# - 핵심 기능 동작 확인
# - Firebase 연동 확인
# - 결제 기능 (sandbox)
```

### 6. Play Console 업로드

1. [Google Play Console](https://play.google.com/console) 접속
2. Mission100 앱 선택
3. **프로덕션** → **새 릴리스 만들기**
4. APK 업로드: `build/app/outputs/flutter-apk/app-release.apk`
5. 출시 노트 작성:
   ```
   버전 1.0.1

   새로운 기능:
   - [기능 설명]

   개선사항:
   - [개선 내용]

   버그 수정:
   - [수정 내용]
   ```
6. **검토 시작** 클릭
7. Google 심사 대기 (보통 1-3일)

## 📋 체크리스트

릴리스 전 확인사항:

### 코드
- [ ] 버전 번호 업데이트 (pubspec.yaml)
- [ ] 모든 테스트 통과
- [ ] Flutter analyze 통과
- [ ] 코드 포맷팅 완료
- [ ] CHANGELOG.md 업데이트

### 설정
- [ ] Firebase 설정 확인 (google-services.json)
- [ ] API 키 정상 작동 확인
- [ ] 프로덕션 환경 변수 확인

### 빌드
- [ ] keystore 백업 확인
- [ ] Release APK 빌드 성공
- [ ] APK 서명 검증 완료
- [ ] APK 크기 확인 (50MB 이하)

### 테스트
- [ ] 실제 기기에서 설치 테스트
- [ ] 로그인/회원가입 동작
- [ ] 핵심 기능 동작 확인
- [ ] Firebase 연동 확인
- [ ] 결제 기능 테스트 (sandbox)

### 문서
- [ ] 출시 노트 작성
- [ ] Play Console 메타데이터 확인
- [ ] 스크린샷 최신화

## 🔧 문제 해결

### 빌드 실패

```bash
# Clean 후 재시도
flutter clean
flutter pub get
flutter build apk --release --verbose
```

### keystore 오류

```bash
# key.properties 경로 확인
cat android/key.properties

# keystore 존재 확인
ls -la ~/upload-keystore.jks
```

### 서명 실패

```bash
# 비밀번호 재확인
# keystore와 key 비밀번호가 다를 수 있음
```

## 📞 지원

문제 발생 시:
1. [GitHub Issues](https://github.com/khy0425/mission100/issues)
2. CI/CD 로그 확인
3. Flutter 공식 문서 참고

---

**마지막 업데이트**: 2025-10-02
**문서 버전**: 1.0
