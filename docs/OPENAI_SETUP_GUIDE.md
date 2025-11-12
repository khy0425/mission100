# OpenAI API 설정 가이드

## 🚀 빠른 시작 (5분 완료)

### 1단계: OpenAI API 키 발급

1. **OpenAI 계정 생성**
   - https://platform.openai.com/signup 접속
   - 이메일 또는 Google 계정으로 가입

2. **API 키 생성**
   - https://platform.openai.com/api-keys 접속
   - "Create new secret key" 클릭
   - 키 이름 입력 (예: "lucid_dream_100")
   - **⚠️ 중요:** 생성된 키 복사 (다시 볼 수 없음!)

3. **결제 정보 등록**
   - https://platform.openai.com/account/billing/overview
   - 신용카드 등록 (최소 $5 충전 권장)
   - **참고:** GPT-4o-mini는 매우 저렴 (~$0.0003/분석)

---

### 2단계: 앱에 API 키 설정

#### 방법 1: app_config.json 수정 (간단함)

**파일:** `assets/config/app_config.json`

```json
{
  "ai": {
    "openai_api_key": "sk-proj-xxxxxxxxxxxxxxxxxxxxx",  // ← 여기에 복사한 API 키 붙여넣기
    "model": "gpt-4o-mini",
    "max_input_characters": 500,
    "max_output_tokens": 500,
    "use_real_ai": true  // ← false에서 true로 변경
  }
}
```

#### 방법 2: 코드에 직접 입력 (보안성 낮음, 테스트용만)

**파일:** `lib/services/ai/dream_analysis_service.dart`

```dart
// 14번째 줄
static const String _apiKey = 'sk-proj-xxxxxxxxxxxxxxxxxxxxx'; // ← API 키 입력
```

⚠️ **보안 경고:** 방법 2는 API 키가 앱에 노출됩니다. 프로덕션에서는 사용하지 마세요!

---

### 3단계: 테스트

1. **앱 재시작**
   ```bash
   flutter run
   ```

2. **꿈 분석 테스트**
   - 앱에서 꿈 일기 작성
   - "Lumi AI 분석" 버튼 클릭
   - 2-3초 후 GPT-4o-mini의 실제 분석 결과 확인!

3. **로그 확인**
   ```
   ✅ OpenAI API 호출 성공 시:
   (로그에 "OpenAI API 오류" 없음)

   ❌ API 호출 실패 시:
   ❌ OpenAI API 오류: [에러 메시지]
   → 시뮬레이션 모드로 폴백됨
   ```

---

## 💰 비용 관리

### 예상 월간 비용

**시나리오 1: 소규모 (100명 사용자)**
- 무료 사용자 80명 × 5회/월 = 400회
- 프리미엄 사용자 20명 × 100회/월 = 2,000회
- **총:** 2,400회 × $0.00034 = **$0.82/월** 💚

**시나리오 2: 중규모 (1,000명 사용자)**
- 무료 사용자 800명 × 5회/월 = 4,000회
- 프리미엄 사용자 200명 × 100회/월 = 20,000회
- **총:** 24,000회 × $0.00034 = **$8.16/월** 💚

**시나리오 3: 대규모 (10,000명 사용자)**
- 무료 사용자 8,000명 × 5회/월 = 40,000회
- 프리미엄 사용자 2,000명 × 100회/월 = 200,000회
- **총:** 240,000회 × $0.00034 = **$81.60/월** 💚

### 수익 vs 비용

| 사용자 수 | AI 비용 | 광고 수익 (무료) | 프리미엄 수익 | 순이익 | ROI |
|----------|---------|----------------|-------------|--------|-----|
| 100명 | $0.82 | $8.00 | $139.80 | $146.98 | 17,900% 🚀 |
| 1,000명 | $8.16 | $80.00 | $1,398.00 | $1,469.84 | 18,000% 🚀 |
| 10,000명 | $81.60 | $800.00 | $13,980.00 | $14,698.40 | 18,000% 🚀 |

### 비용 제한 설정 (선택사항)

OpenAI에서 월 사용 한도 설정 가능:

1. https://platform.openai.com/account/billing/limits
2. "Usage limits" 설정
3. 예: "월 $100 초과 시 API 차단"

---

## 🔒 보안 모범 사례

### ⚠️ 하지 말아야 할 것
1. ❌ API 키를 Git에 커밋
2. ❌ API 키를 앱 코드에 직접 입력 (프로덕션)
3. ❌ API 키를 공개 저장소에 업로드

### ✅ 권장 사항

#### 프로덕션 환경
1. **Firebase Remote Config 사용** (권장)
   ```dart
   // Firebase Remote Config에서 API 키 가져오기
   final remoteConfig = FirebaseRemoteConfig.instance;
   final apiKey = remoteConfig.getString('openai_api_key');
   ```

2. **환경 변수 사용**
   ```bash
   # .env 파일 (Git에 커밋하지 않음)
   OPENAI_API_KEY=sk-proj-xxxxxxxxxxxxxxxxxxxxx
   ```

3. **백엔드 프록시 사용** (최고 보안)
   - Firebase Cloud Functions에서 OpenAI API 호출
   - 앱은 Firebase Functions만 호출
   - API 키가 서버에만 존재

#### .gitignore 추가
```gitignore
# .gitignore 파일에 추가
assets/config/app_config.json
.env
```

---

## 🐛 트러블슈팅

### 문제 1: "OpenAI API 오류: 401"
**원인:** API 키가 잘못됨

**해결:**
1. API 키 재확인 (공백, 오타 없는지)
2. OpenAI 계정 활성화 확인
3. 결제 정보 등록 확인

### 문제 2: "OpenAI API 오류: 429"
**원인:** 요청 한도 초과 (Rate Limit)

**해결:**
1. OpenAI 플랜 업그레이드
2. 요청 간격 늘리기 (앱에서 자동 처리됨)
3. 캐싱 시스템 구현

### 문제 3: "OpenAI API 오류: 500"
**원인:** OpenAI 서버 오류

**해결:**
- 자동으로 시뮬레이션 모드로 폴백됨
- 잠시 후 다시 시도

### 문제 4: 비용이 예상보다 높음
**원인:** 입력/출력 토큰 초과

**확인:**
1. `app_config.json`에서 `max_input_characters: 500` 확인
2. `max_output_tokens: 500` 확인
3. OpenAI 사용량 대시보드 확인: https://platform.openai.com/usage

---

## 📊 모니터링

### OpenAI 사용량 확인
1. https://platform.openai.com/usage
2. 일별/월별 사용량 그래프 확인
3. 비용 추이 모니터링

### 앱 내 사용량 확인
```dart
// 사용자별 사용량 조회
final dailyCount = await DreamAnalysisService().getDailyUsageCount();
final monthlyCount = await DreamAnalysisService().getMonthlyUsageCount();

print('오늘 사용량: $dailyCount회');
print('이번 달 사용량: $monthlyCount회');
```

---

## 🎯 성능 최적화 팁

### 1. 캐싱 구현 (비용 절감)
유사한 꿈은 이전 분석 재사용:
```dart
// TODO: 향후 구현
// 꿈 내용 해시 → 캐시 조회 → 있으면 재사용, 없으면 API 호출
```

### 2. 배치 처리
한 번에 여러 꿈 분석 (API 호출 줄이기):
```dart
// TODO: 향후 구현
// 여러 꿈을 하나의 API 호출로 처리
```

### 3. 스트리밍 응답
점진적 응답으로 사용자 경험 개선:
```dart
// TODO: 향후 구현
// OpenAI Streaming API 사용
```

---

## ✅ 체크리스트

설정 완료 전 확인:

- [ ] OpenAI 계정 생성
- [ ] API 키 발급
- [ ] 결제 정보 등록 ($5 충전)
- [ ] `app_config.json`에 API 키 입력
- [ ] `use_real_ai: true` 설정
- [ ] 앱 재시작 및 테스트
- [ ] 로그에서 에러 없는지 확인
- [ ] OpenAI 사용량 대시보드 북마크
- [ ] 월 사용 한도 설정 (선택)
- [ ] `.gitignore`에 설정 파일 추가

---

## 🆘 지원

문제 발생 시:
1. 로그 확인 (`❌ OpenAI API 오류` 검색)
2. OpenAI 상태 페이지: https://status.openai.com/
3. OpenAI API 문서: https://platform.openai.com/docs/

---

*생성일: 2025-11-09*
*작성자: Claude Code*

**축하합니다! 🎉 이제 GPT-4o-mini로 실제 AI 꿈 분석이 가능합니다!**
