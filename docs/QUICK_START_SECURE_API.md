# 빠른 시작: 안전한 API 키 사용

## 🎯 3단계로 완료하기

### 1️⃣ OpenAI API 키 발급 (2분)

```
1. https://platform.openai.com/api-keys 접속
2. "Create new secret key" 클릭
3. 생성된 키 복사 (sk-로 시작)
4. https://platform.openai.com/account/limits에서 예산 설정 ($50/월)
```

---

### 2️⃣ Firebase에 키 안전하게 저장 (1분)

```bash
# 프로젝트 디렉토리에서 실행
cd E:\Projects\mission_apps\lucid_dream_100

# Firebase Secret 설정
firebase functions:secrets:set OPENAI_API_KEY

# 프롬프트에 API 키 입력
? Enter a value for OPENAI_API_KEY: [여기에 API 키 붙여넣기]
```

---

### 3️⃣ Firebase Functions 배포 (2-3분)

```bash
# npm 패키지 설치
cd functions
npm install

# Functions 배포
cd ..
firebase deploy --only functions
```

**완료!** 🎉

---

## ✅ 작동 확인

Flutter 앱에서 테스트:

```dart
import 'package:your_app/services/ai/dream_analysis_service_secure.dart';

final service = DreamAnalysisServiceSecure();

// 빠른 분석 테스트
final analysis = await service.quickAnalysis(
  dreamText: '어젯밤 하늘을 날았어요',
);

print('✅ 분석 결과: $analysis');
```

---

## 🔒 보안 완료!

이제 API 키가:
- ❌ 앱에 없음
- ❌ Git에 없음
- ✅ **Firebase 서버에만 안전하게 보관**

악의적 사용자가 앱을 디컴파일해도 API 키를 찾을 수 없습니다!

---

## 📚 상세 가이드

- [SECURE_API_SETUP_GUIDE.md](./SECURE_API_SETUP_GUIDE.md) - 전체 설정 가이드
- [API_KEY_SECURITY_GUIDE.md](./API_KEY_SECURITY_GUIDE.md) - 보안 설명
- [FIREBASE_REMOTE_CONFIG_CLARIFICATION.md](./FIREBASE_REMOTE_CONFIG_CLARIFICATION.md) - Remote Config 설명

---

## 🚨 문제 발생 시

```bash
# Firebase Functions 로그 확인
firebase functions:log

# Secret 확인
firebase functions:secrets:access OPENAI_API_KEY

# 재배포
firebase deploy --only functions --force
```

도움이 필요하면 [SECURE_API_SETUP_GUIDE.md](./SECURE_API_SETUP_GUIDE.md)의 "문제 해결" 섹션을 참고하세요!
