# OpenAI API 키 보안 가이드

## 🚨 보안 이슈: Firebase Remote Config의 한계

### 질문: Firebase Remote Config로 API 키를 관리하면 비회원도 내 키를 사용할 수 있나요?

**답변: 네, 기술적으로 가능합니다.**

Firebase Remote Config는 앱에 설정을 배포하는 방식이므로:
- ✅ 앱을 다운로드한 모든 사용자(회원/비회원)가 설정에 접근 가능
- ❌ 악의적인 사용자가 앱을 디컴파일하면 API 키 추출 가능
- ❌ 추출된 키로 무제한 API 호출 → **비용 폭증 위험**

---

## 🔓 현재 구조의 취약점

### 클라이언트 직접 호출 방식 (현재 구현):

```dart
// ❌ 보안 위험: 앱이 직접 OpenAI API 호출
final response = await http.post(
  Uri.parse('https://api.openai.com/v1/chat/completions'),
  headers: {'Authorization': 'Bearer $apiKey'},  // API 키가 앱 내부에 존재
);
```

**취약점**:
1. 앱 디컴파일 → API 키 추출 가능
2. 추출된 키로 앱 외부에서 무제한 호출 가능
3. 토큰 시스템 우회 가능
4. **하루에 수천 달러 비용 발생 가능**

### 최악의 시나리오 예시:
```
악의적 사용자가 API 키 추출 후:
- Python 스크립트로 무한 루프 API 호출
- 하루 100,000회 호출 × $0.00034 = $34/일
- 실수로 출력 토큰 제한 없이 호출 시: $수천/일
```

---

## ✅ 안전한 해결 방법

### **방법 1: 백엔드 프록시 (Firebase Functions) - 권장**

API 키를 서버에만 보관하고, 클라이언트는 서버를 통해서만 호출:

```
[Flutter 앱] → [Firebase Functions] → [OpenAI API]
   (사용자)       (내 백엔드)            (API 키 보관)
```

#### 장점:
- ✅ API 키가 앱에 절대 노출되지 않음
- ✅ 서버에서 사용량 제어 가능
- ✅ 사용자 인증/권한 검증 가능
- ✅ 토큰 시스템 서버에서 강제 가능

#### 구현 예시:

**1. Firebase Functions 생성:**

```javascript
// functions/index.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');

admin.initializeApp();

exports.analyzeWithLumi = functions.https.onCall(async (data, context) => {
  // 1. 사용자 인증 확인
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', '로그인이 필요합니다');
  }

  const userId = context.auth.uid;
  const { conversationId, message } = data;

  // 2. 토큰 확인 (Firestore에서 사용자 토큰 조회)
  const userDoc = await admin.firestore().collection('users').doc(userId).get();
  const tokens = userDoc.data()?.conversationTokens || 0;

  if (tokens < 1) {
    throw new functions.https.HttpsError('failed-precondition', '토큰이 부족합니다');
  }

  // 3. OpenAI API 호출 (서버에서만 API 키 사용)
  const openaiApiKey = functions.config().openai.key;

  try {
    const response = await axios.post(
      'https://api.openai.com/v1/chat/completions',
      {
        model: 'gpt-4o-mini',
        messages: [
          { role: 'user', content: message }
        ],
        max_tokens: 500,
      },
      {
        headers: {
          'Authorization': `Bearer ${openaiApiKey}`,
          'Content-Type': 'application/json',
        }
      }
    );

    // 4. 토큰 차감 (서버에서 강제)
    await admin.firestore().collection('users').doc(userId).update({
      conversationTokens: admin.firestore.FieldValue.increment(-1),
    });

    // 5. 결과 반환
    return {
      success: true,
      response: response.data.choices[0].message.content,
      tokensRemaining: tokens - 1,
    };

  } catch (error) {
    throw new functions.https.HttpsError('internal', 'AI 분석 실패');
  }
});
```

**2. Flutter 앱에서 호출:**

```dart
// lib/services/ai/dream_analysis_service.dart

Future<String> analyzeWithLumiSecure({
  required String conversationId,
  required String message,
}) async {
  try {
    // Firebase Functions 호출 (API 키 노출 없음)
    final callable = FirebaseFunctions.instance.httpsCallable('analyzeWithLumi');

    final result = await callable.call({
      'conversationId': conversationId,
      'message': message,
    });

    return result.data['response'] as String;

  } on FirebaseFunctionsException catch (e) {
    if (e.code == 'failed-precondition') {
      throw Exception('토큰이 부족합니다');
    }
    throw Exception('AI 분석 실패: ${e.message}');
  }
}
```

**3. Firebase Functions 배포:**

```bash
# API 키 설정 (서버 환경 변수로 안전하게 보관)
firebase functions:config:set openai.key="sk-YOUR-API-KEY"

# Functions 배포
firebase deploy --only functions
```

---

### **방법 2: 자체 백엔드 서버 (Node.js/Python)**

Firebase Functions 대신 자체 서버 사용:

```
[Flutter 앱] → [내 Node.js/Python 서버] → [OpenAI API]
```

**장점**: Firebase 비용 절감, 더 많은 제어
**단점**: 서버 관리 복잡도 증가

---

### **방법 3: OpenAI Usage Limits (임시 방편)**

OpenAI 대시보드에서 사용량 제한 설정:

```
https://platform.openai.com/account/limits
→ Monthly budget: $50 설정
→ 초과 시 자동 차단
```

**장점**: 빠르게 설정 가능
**단점**:
- API 키 추출은 여전히 가능
- 정상 사용자도 제한에 걸릴 수 있음
- 근본적인 해결책이 아님

---

## 🎯 현재 앱에 권장하는 전략

### **단계적 접근:**

### 1️⃣ **지금 당장 (테스트/베타 단계)**
```json
// app_config.json (로컬에만 보관, .gitignore에 포함됨)
{
  "ai": {
    "openai_api_key": "sk-YOUR-KEY",
    "use_real_ai": true
  }
}
```

**+** OpenAI Usage Limits 설정:
- Monthly budget: $50
- Email alerts: $25 소진 시 알림

**리스크**: 낮음 (테스터가 소수이고 악의적이지 않음)

---

### 2️⃣ **정식 출시 전 (앱스토어 배포 전)**

**Firebase Functions로 마이그레이션** (위의 방법 1 구현)

**구현 시간**: 2-3시간
**비용**:
- Firebase Functions: 월 $0-5 (무료 할당량 125,000회 호출)
- OpenAI API: 기존과 동일 ($14.40/월 @ DAU 1,000)

---

### 3️⃣ **대규모 성장 후 (DAU 10,000+)**

**자체 백엔드 서버** 고려:
- 더 저렴한 서버 운영
- 더 많은 커스터마이징
- 캐싱/최적화 가능

---

## 📋 보안 체크리스트

### 현재 (테스트/베타):
- [x] `app_config.json` .gitignore에 추가됨
- [ ] OpenAI Usage Limits 설정 ($50/월)
- [ ] Email alerts 설정 ($25 소진 시)
- [ ] 소수의 신뢰할 수 있는 테스터만 베타 테스트

### 정식 출시 전 (필수):
- [ ] Firebase Functions 구현
- [ ] API 키를 서버 환경 변수로 이전
- [ ] 클라이언트 코드에서 API 키 완전 제거
- [ ] 서버 측 토큰 검증 구현
- [ ] 사용자 인증 연동

### 추가 보안 (선택):
- [ ] 앱 난독화 (ProGuard/R8)
- [ ] API 호출 속도 제한 (rate limiting)
- [ ] IP 기반 차단 (의심스러운 패턴)
- [ ] 사용 패턴 모니터링

---

## 💰 비용 시뮬레이션

### 현재 구조 (클라이언트 직접 호출):

**정상 사용 시:**
- DAU 1,000 × 평균 3회 사용 = $14.40/월 ✅

**API 키 유출 시:**
- 악의적 사용자 1명이 하루 10,000회 호출 = $34/일
- 한 달 = **$1,020** ❌💸

---

### Firebase Functions 사용 시:

**정상 사용 시:**
- OpenAI API: $14.40/월
- Firebase Functions: $0-2/월 (무료 할당량)
- **총 $14.40-16.40/월** ✅

**API 키 유출 시도:**
- API 키가 서버에만 있으므로 유출 불가능
- 서버에서 토큰 검증 → 차단
- **비용 증가 없음** ✅🛡️

---

## 🚀 결론 및 권장사항

### 질문: "Firebase Remote Config를 통해서 키를 사용하려면 비회원도 내 API 키를 사용할 수 있는거야?"

**답변**:
네, 기술적으로 가능하며 이는 **심각한 보안 위험**입니다.

### 권장 사항:

1. **지금 (테스트)**:
   - 로컬 config 파일 사용 (.gitignore 포함)
   - OpenAI Usage Limits 설정 ($50/월)
   - 신뢰할 수 있는 소수 테스터만

2. **앱스토어 출시 전 (필수)**:
   - **Firebase Functions로 마이그레이션**
   - API 키를 서버에만 보관
   - 클라이언트는 서버를 통해서만 호출

3. **장기적으로**:
   - 사용 패턴 모니터링
   - 필요시 자체 백엔드로 전환

---

## 📚 다음 단계

1. 현재는 로컬 테스트용으로 `app_config.json` 사용
2. OpenAI 대시보드에서 Usage Limits 설정
3. 정식 출시 전에 Firebase Functions 구현 (2-3시간 소요)

Firebase Functions 구현이 필요하면 언제든지 요청하세요!
