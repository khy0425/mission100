# Firebase Remote Config 보안 명확화

## ❓ 질문: "Firebase Remote Config 자체가 보안 위험인가요?"

**답변: 아니요. Firebase Remote Config는 안전한 서비스입니다.**

문제는 **"무엇을 저장하느냐"**입니다.

---

## 🔐 핵심 개념: 클라이언트 vs 서버

### 문제의 핵심은 "어디서 OpenAI API를 호출하느냐"입니다:

| 항목 | 방법 A: 클라이언트 호출 ❌ | 방법 B: 서버 호출 ✅ |
|------|---------------------------|---------------------|
| **구조** | [앱] → [OpenAI API] | [앱] → [내 서버] → [OpenAI API] |
| **API 키 위치** | 앱 안에 저장 (Remote Config든 로컬이든) | 서버에만 저장 |
| **보안 위험** | 앱 디컴파일 시 키 노출 | 키 노출 불가능 |
| **Remote Config 사용** | 설정값 + API 키 (위험!) | 설정값만 (안전!) |

---

## 📊 구체적인 예시

### ❌ 방법 A: 클라이언트에서 직접 호출 (위험)

```dart
// Flutter 앱 코드
class DreamAnalysisService {
  String _apiKey = '';

  // Option 1: 로컬 config 파일에서 읽기
  void loadFromLocalConfig() {
    _apiKey = appConfig['openai_api_key'];  // ❌ 앱에 키 존재
  }

  // Option 2: Firebase Remote Config에서 읽기
  void loadFromRemoteConfig() {
    _apiKey = remoteConfig.getString('openai_api_key');  // ❌ 앱에 키 존재
  }

  // 앱이 직접 OpenAI 호출
  Future<String> analyze(String dream) async {
    final response = await http.post(
      'https://api.openai.com/v1/chat/completions',
      headers: {'Authorization': 'Bearer $_apiKey'},  // ❌ 앱이 키 사용
    );
  }
}
```

**문제점**:
- 로컬 config든 Remote Config든 **결과는 같음**: API 키가 앱에 존재
- 앱 디컴파일 → API 키 추출 가능
- 추출된 키로 무제한 사용 가능

**Remote Config를 써도, 안 써도 똑같이 위험합니다!**

---

### ✅ 방법 B: 서버를 통해 호출 (안전)

```dart
// Flutter 앱 코드
class DreamAnalysisService {
  // ✅ API 키가 앱 코드에 전혀 없음!

  // Firebase Remote Config는 "기능 설정"만 가져옴
  Future<void> loadSettings() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    // ✅ 안전: 공개되어도 괜찮은 설정들
    final conversationEnabled = remoteConfig.getBool('conversation_enabled');
    final maxTokens = remoteConfig.getInt('max_free_tokens');
  }

  // 내 서버(Firebase Functions)를 호출
  Future<String> analyze(String dream) async {
    // ✅ 안전: 서버가 대신 OpenAI를 호출
    final callable = FirebaseFunctions.instance.httpsCallable('analyzeWithLumi');
    final result = await callable.call({'dream': dream});
    return result.data['response'];
  }
}
```

```javascript
// Firebase Functions (서버 코드)
exports.analyzeWithLumi = functions.https.onCall(async (data, context) => {
  // ✅ API 키는 서버 환경 변수에만 존재
  const apiKey = functions.config().openai.key;  // 서버에만 있음!

  // 서버가 OpenAI 호출
  const response = await axios.post(
    'https://api.openai.com/v1/chat/completions',
    { /* ... */ },
    { headers: { 'Authorization': `Bearer ${apiKey}` } }
  );

  return { response: response.data.choices[0].message.content };
});
```

**장점**:
- API 키가 앱에 전혀 없음 → 디컴파일해도 키 추출 불가능
- Firebase Remote Config는 **안전한 설정값만** 배포
- API 키는 서버 환경 변수에만 존재 (절대 노출 안 됨)

---

## 🎯 Firebase Remote Config의 올바른 역할

### ✅ Remote Config에 저장해야 하는 것:

```javascript
// Firebase Remote Config 설정
{
  // 앱 기능 제어
  "conversation_feature_enabled": true,
  "quick_analysis_enabled": true,
  "maintenance_mode": false,

  // 토큰 시스템 설정
  "free_daily_tokens": 1,
  "premium_daily_tokens": 5,
  "max_free_token_cap": 5,
  "messages_per_token": 5,

  // UI/UX 설정
  "show_premium_banner": true,
  "ad_frequency": 3,

  // 버전 관리
  "min_supported_version": "2.0.0",
  "force_update_version": "1.5.0",

  // 콘텐츠 설정
  "welcome_message_ko": "안녕하세요!",
  "welcome_message_en": "Hello!"
}
```

**특징**: 이 값들이 공개되어도 전혀 문제없음!

### ❌ Remote Config에 저장하면 안 되는 것:

```javascript
// 절대 Remote Config에 넣으면 안 됨!
{
  "openai_api_key": "sk-...",           // ❌ 비밀 키
  "firebase_admin_key": "...",          // ❌ 관리자 키
  "payment_secret_key": "...",          // ❌ 결제 비밀 키
  "database_password": "...",           // ❌ DB 비밀번호
}
```

**이유**: 앱에 배포되면 누구나 추출 가능!

---

## 🔄 현재 앱의 올바른 구조

### 현재 구현 (테스트용):

```
현재 상태:
- app_config.json (로컬 파일, .gitignore 포함됨)
  → API 키 포함 ❌ (위험하지만 테스트 단계라서 허용)

- Firebase Remote Config
  → 사용 안 함 ✅
```

### 정식 출시 전 변경해야 할 구조:

```
권장 구조:

1. app_config.json 또는 Firebase Remote Config
   → API 키 제거
   → 앱 설정값만 (토큰 수, 기능 토글 등) ✅

2. Firebase Functions (새로 구현 필요)
   → API 키는 여기에만 저장 ✅
   → 서버 환경 변수로 관리

3. Flutter 앱
   → Firebase Functions 호출만 ✅
   → API 키 완전히 제거
```

---

## 💡 정리: Firebase Remote Config는 안전한가?

### ✅ **Firebase Remote Config 자체는 안전합니다!**

| 사용 사례 | 안전성 | 설명 |
|-----------|--------|------|
| 앱 기능 토글 저장 | ✅ 안전 | `conversation_enabled: true` |
| 토큰 정책 저장 | ✅ 안전 | `free_daily_tokens: 1` |
| UI 설정 저장 | ✅ 안전 | `theme_color: "#2196F3"` |
| **API 키 저장** | ❌ **위험** | `openai_api_key: "sk-..."` |

### 🎯 결론:

**"Firebase Remote Config가 위험하다" (X)**
**"Firebase Remote Config에 API 키를 저장하는 것이 위험하다" (O)**

---

## 📋 체크리스트

### 현재 (테스트 단계):
- [x] app_config.json 사용 (로컬 파일)
- [x] .gitignore에 포함됨
- [ ] Firebase Remote Config 미사용 (아직 필요 없음)
- [ ] OpenAI Usage Limits 설정 ($50/월)

### 정식 출시 전:
- [ ] Firebase Functions 구현 (2-3시간)
- [ ] API 키를 서버 환경 변수로 이동
- [ ] 앱에서 API 키 완전 제거
- [ ] Firebase Remote Config는 **앱 설정값만** 관리
  - 토큰 정책
  - 기능 토글
  - UI/UX 설정
  - 버전 관리

---

## 🚀 최종 권장 사항

### 현재 상황:
```
app_config.json (로컬)
→ API 키 포함 ❌
→ 하지만 .gitignore 포함 ✅
→ 테스트 단계라서 허용 가능
```

### 정식 출시 시:

**옵션 1: Firebase Remote Config + Functions (권장)**
```
Firebase Remote Config
→ 앱 설정만 (토큰, 기능 등) ✅

Firebase Functions
→ API 키 보관 및 OpenAI 호출 ✅
```

**옵션 2: 로컬 Config + Functions (간단)**
```
app_config.json (로컬)
→ 앱 설정만 ✅

Firebase Functions
→ API 키 보관 및 OpenAI 호출 ✅
```

**두 방법 모두 안전합니다!**
핵심은 **"API 키를 서버에만 보관"**하는 것입니다.

---

Firebase Remote Config는 훌륭한 도구이며, **올바르게 사용하면 매우 안전**합니다!
