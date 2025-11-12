# 안전한 API 키 설정 가이드

## ✅ 완료된 구현

Firebase Functions를 통한 안전한 OpenAI API 호출 시스템이 완성되었습니다!

### 구조:
```
[Flutter 앱] → [Firebase Functions] → [OpenAI API]
                      ↑
                API 키는 여기에만 존재
                (앱에 절대 노출되지 않음)
```

---

## 🔧 설정 방법 (단계별)

### 1단계: Firebase CLI 설치 및 로그인

```bash
# Firebase CLI 설치 (이미 설치되었을 수 있음)
npm install -g firebase-tools

# Firebase 로그인
firebase login

# 프로젝트 확인
cd E:\Projects\mission_apps\lucid_dream_100
firebase projects:list
```

---

### 2단계: OpenAI API 키 발급

1. **OpenAI 플랫폼 접속**:
   - https://platform.openai.com/api-keys

2. **새 API 키 생성**:
   - "Create new secret key" 클릭
   - 이름: "Lucid Dream 100 - Production"
   - **중요**: 생성된 키를 안전한 곳에 복사 (한 번만 표시됨!)

3. **사용량 제한 설정** (권장):
   - https://platform.openai.com/account/limits
   - Monthly budget: $50
   - Email alert at: $25

---

### 3단계: Firebase Functions 의존성 설치

```bash
# functions 디렉토리로 이동
cd functions

# npm 패키지 설치
npm install

# axios가 설치되었는지 확인
npm list axios
```

**출력 예시**:
```
mission100-functions@1.0.0
├── axios@1.6.0
├── firebase-admin@12.0.0
└── firebase-functions@5.0.0
```

---

### 4단계: Firebase Secret에 API 키 저장 (가장 안전한 방법)

```bash
# 프로젝트 루트로 돌아가기
cd ..

# OpenAI API 키를 Firebase Secret으로 설정
firebase functions:secrets:set OPENAI_API_KEY

# 프롬프트가 나타나면 API 키 입력:
# ? Enter a value for OPENAI_API_KEY: sk-YOUR-API-KEY-HERE
```

**성공 메시지**:
```
✔ Created a new secret version OPENAI_API_KEY
```

---

### 5단계: Firebase Functions 배포

```bash
# Functions 배포
firebase deploy --only functions

# 또는 특정 함수만 배포
firebase deploy --only functions:analyzeWithLumi,functions:quickDreamAnalysis
```

**배포 과정**:
```
=== Deploying to 'lucid-dream-100'...

i  deploying functions
i  functions: ensuring required API is enabled...
✔  functions: required API is enabled
i  functions: preparing functions directory for uploading...
i  functions: packaged functions (2.5 MB) for uploading
✔  functions: functions folder uploaded successfully
i  functions: updating function analyzeWithLumi...
i  functions: updating function quickDreamAnalysis...
✔  functions[analyzeWithLumi]: Successful update operation.
✔  functions[quickDreamAnalysis]: Successful update operation.

✔  Deploy complete!
```

---

### 6단계: Secret 접근 권한 설정

배포 후 Cloud Functions 서비스 계정에 Secret 접근 권한을 부여해야 합니다:

**방법 1: Firebase Console (권장)**

1. Firebase Console 접속: https://console.firebase.google.com
2. 프로젝트 선택
3. "Functions" → 배포된 함수 확인
4. Google Cloud Console로 이동
5. "Secret Manager" 메뉴
6. `OPENAI_API_KEY` 선택
7. "Permissions" 탭
8. "Grant Access" 클릭
9. Principal: `PROJECT_ID@appspot.gserviceaccount.com`
10. Role: "Secret Manager Secret Accessor"

**방법 2: 명령어**

```bash
# 프로젝트 ID 확인
firebase projects:list

# Secret 접근 권한 부여
gcloud secrets add-iam-policy-binding OPENAI_API_KEY \
  --member="serviceAccount:YOUR-PROJECT-ID@appspot.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"
```

---

### 7단계: Flutter 앱 설정

#### 7-1. Firebase 초기화 확인

`lib/main.dart`에 Firebase가 초기화되어 있는지 확인:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp();

  // ... 나머지 코드
}
```

#### 7-2. 안전한 서비스 사용

기존 `DreamAnalysisService` 대신 `DreamAnalysisServiceSecure` 사용:

```dart
import 'package:your_app/services/ai/dream_analysis_service_secure.dart';

// 빠른 분석
final service = DreamAnalysisServiceSecure();
final analysis = await service.quickAnalysis(
  dreamText: '어젯밤 꿈에서 하늘을 날았어요...',
);

// 대화형 분석
final result = await service.analyzeWithConversation(
  conversationId: null, // 새 대화 시작
  userMessage: '이 꿈의 의미가 뭘까요?',
);

print('AI 응답: ${result.response}');
print('남은 토큰: ${result.tokensRemaining}');
```

---

## 🧪 테스트

### 1. 로컬 에뮬레이터로 테스트 (선택)

```bash
# Firebase Emulator 시작
firebase emulators:start --only functions

# 에뮬레이터 실행 중 표시:
✔  functions[us-central1-analyzeWithLumi]: http function initialized (http://127.0.0.1:5001/...)
```

Flutter 앱에서 에뮬레이터 사용:

```dart
// lib/main.dart 또는 초기화 코드에 추가
void main() async {
  // ...

  // 디버그 모드에서만 에뮬레이터 사용
  if (kDebugMode) {
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  }

  // ...
}
```

### 2. 프로덕션 테스트

앱을 실행하고 실제 API 호출:

```dart
try {
  final service = DreamAnalysisServiceSecure();
  final analysis = await service.quickAnalysis(
    dreamText: '테스트 꿈 내용',
  );
  print('✅ 분석 성공: $analysis');
} catch (e) {
  print('❌ 오류: $e');
}
```

---

## 🔒 보안 확인 사항

### ✅ 완료된 보안 조치:

- [x] API 키가 앱 코드에 전혀 없음
- [x] API 키가 Git에 커밋되지 않음 (Firebase Secret 사용)
- [x] Firebase Functions에서만 OpenAI 호출
- [x] 서버 측 토큰 검증
- [x] 사용자 인증 필수
- [x] 입력 길이 제한 (500자)
- [x] 출력 토큰 제한 (500 tokens)
- [x] 대화 히스토리 제한 (최근 10개)

### 🛡️ 추가 보안 (선택):

- [ ] Firebase App Check 활성화 (봇 방지)
- [ ] Rate Limiting (과도한 호출 차단)
- [ ] IP 화이트리스트 (필요 시)

---

## 💰 비용 관리

### Firebase Functions 비용:

**무료 할당량 (매월)**:
- 호출: 125,000회
- 컴퓨팅 시간: 40,000 GB-seconds
- 네트워크: 5 GB

**DAU 1,000 예상 사용량**:
- 월 호출: ~3,000-5,000회
- **비용: $0** (무료 범위 내)

### OpenAI API 비용:

**GPT-4o-mini**:
- 입력: $0.15/1M tokens
- 출력: $0.60/1M tokens

**DAU 1,000 예상 비용**:
- 빠른 분석: $2.40/월
- 대화형 분석: $12.00/월
- **총 $14.40/월**

**총 비용: ~$14.40/월** (Firebase Functions 무료 범위)

---

## 🚨 문제 해결

### 문제 1: "unauthenticated" 오류

**원인**: 사용자가 로그인되지 않음

**해결**:
```dart
// Firebase Auth 로그인 확인
final user = FirebaseAuth.instance.currentUser;
if (user == null) {
  // 익명 로그인 또는 로그인 화면으로 이동
  await FirebaseAuth.instance.signInAnonymously();
}
```

---

### 문제 2: "PERMISSION_DENIED" 오류

**원인**: Secret 접근 권한 없음

**해결**: 6단계 Secret 접근 권한 설정 다시 확인

```bash
# 현재 권한 확인
gcloud secrets get-iam-policy OPENAI_API_KEY

# 권한 추가
gcloud secrets add-iam-policy-binding OPENAI_API_KEY \
  --member="serviceAccount:YOUR-PROJECT-ID@appspot.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"
```

---

### 문제 3: "API 인증 실패" 오류

**원인**: OpenAI API 키가 잘못되었거나 사용량 초과

**해결**:
1. OpenAI 대시보드에서 API 키 확인
2. 사용량 확인: https://platform.openai.com/usage
3. 새 API 키로 교체:

```bash
firebase functions:secrets:set OPENAI_API_KEY
# 새 키 입력 후 재배포
firebase deploy --only functions
```

---

### 문제 4: Functions 배포 실패

**원인**: Node.js 버전 불일치 또는 패키지 오류

**해결**:
```bash
cd functions

# Node 버전 확인 (18 이상 필요)
node --version

# 패키지 재설치
rm -rf node_modules package-lock.json
npm install

# 재배포
cd ..
firebase deploy --only functions
```

---

## 📊 모니터링

### Firebase Console에서 확인:

1. **Functions 로그**:
   - https://console.firebase.google.com
   - Functions → Logs
   - 실시간 로그 확인

2. **사용량 확인**:
   - Functions → Usage
   - 호출 횟수, 실행 시간 모니터링

3. **Secret 상태**:
   - Google Cloud Console
   - Secret Manager
   - OPENAI_API_KEY 버전 관리

---

## ✅ 완료 체크리스트

### 초기 설정:
- [ ] Firebase CLI 설치 및 로그인
- [ ] OpenAI API 키 발급
- [ ] OpenAI Usage Limits 설정 ($50/월)
- [ ] Firebase Functions 의존성 설치 (`npm install`)
- [ ] Firebase Secret에 API 키 저장
- [ ] Functions 배포
- [ ] Secret 접근 권한 설정

### 앱 통합:
- [ ] Firebase 초기화 확인
- [ ] `DreamAnalysisServiceSecure` 사용
- [ ] 테스트 실행 (로컬 또는 프로덕션)
- [ ] 에러 핸들링 구현

### 보안 확인:
- [ ] 앱 코드에 API 키 없음 확인
- [ ] `.gitignore`에 `app_config.json` 포함 확인
- [ ] Firebase Console에서 함수 동작 확인
- [ ] 로그에서 성공적인 API 호출 확인

---

## 🎉 완료!

이제 **안전한 AI 대화 시스템**이 완성되었습니다!

### 보안 이점:
✅ API 키가 앱에 절대 노출되지 않음
✅ 서버에서 모든 토큰 검증
✅ 악의적 사용자가 API를 직접 호출할 수 없음
✅ 비용 예측 가능

### 다음 단계:
1. UI 구현 (대화 화면, 토큰 표시)
2. 토큰 시스템과 통합
3. 리워드 광고 통합
4. 앱스토어 배포

---

## 📚 추가 리소스

- Firebase Functions 문서: https://firebase.google.com/docs/functions
- Firebase Secrets 문서: https://firebase.google.com/docs/functions/config-env
- OpenAI API 문서: https://platform.openai.com/docs
- Cloud Functions 가격: https://firebase.google.com/pricing

문제가 발생하면 Firebase Console의 Functions 로그를 확인하세요!
