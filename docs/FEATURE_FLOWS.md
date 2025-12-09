# Lucid Dream 100 - 기능 플로우 문서

## 1. 일일 체크리스트 완료 플로우

### 사용자 시나리오
사용자가 아침에 일어나서 3가지 필수 태스크를 모두 완료하면 토큰과 경험치를 받습니다.

### 상세 플로우

```
[앱 시작]
    ↓
[홈 화면] → 체크리스트 화면 이동
    ↓
[체크리스트 화면]
    ↓
[태스크 1 완료] - 꿈 일기 작성 ✓
    ↓
[DailyTaskService.toggleTask(dreamJournal, true)]
    ↓
[태스크 2 완료] - 현실 확인 ✓
    ↓
[DailyTaskService.toggleTask(realityCheck, true)]
    ↓
[태스크 3 완료] - MILD 확언 ✓
    ↓
[DailyTaskService.toggleTask(mildAffirmation, true)]
    ↓
[🎁 3개 완료 감지!]
    ↓
[중복 체크] SharedPreferences에서 오늘 날짜 확인
    ├─ 이미 받음 → 종료
    └─ 처음 → 계속
        ↓
[1. 토큰 지급]
    ConversationTokenService.earnFromDailyChecklist()
        ↓
    Cloud Function 호출: earnRewardAdTokens
        ↓
    Firestore conversationTokens/{userId} 업데이트
        - balance += 1 (무료) 또는 5 (프리미엄)
        - totalEarned 증가
        ↓
    [✅ 토큰 지급 완료]
        ↓
[2. 경험치 지급]
    ExperienceService.addAchievementExp(100, '일일 체크리스트 완료')
        ↓
    SharedPreferences에 XP 저장
        - currentExp += 100
        ↓
    [✅ XP 지급 완료]
        ↓
[3. 레벨업 체크]
    ChecklistCompletionService.checkXPAndLevelUp()
        ↓
    LevelUpService.checkForLevelUp()
        ↓
    경험치가 레벨업 기준치 이상?
        ├─ YES → 레벨업!
        │   ↓
        │   currentLevel++
        │   ↓
        │   [🎉 레벨업 알림]
        └─ NO → 현재 레벨 유지
        ↓
[4. 날짜 저장]
    SharedPreferences에 오늘 날짜 저장
    ↓
[✅✅✅ 보상 지급 완료!]
    ↓
[UI 업데이트]
    - 토큰 잔액 표시 갱신
    - 경험치 바 애니메이션
    - 레벨업 팝업 (해당 시)
```

### 에러 처리
- **토큰 서비스 없음**: 경고 로그, 계속 진행
- **Auth 서비스 없음**: 레벨업 체크 스킵
- **네트워크 오류**: 에러 로그, 날짜 저장 (재시도 방지)

---

## 2. 빠른 꿈 분석 플로우

### 사용자 시나리오
사용자가 꿈을 간단하게 분석받고 싶어합니다 (1 토큰 소비).

### 상세 플로우

```
[꿈 분석 화면]
    ↓
[꿈 텍스트 입력] (최대 500자)
    ↓
["분석하기" 버튼 클릭]
    ↓
[토큰 잔액 확인]
    ConversationTokenService.tokens.balance
    ├─ balance < 1 → ❌ "토큰이 부족합니다" 에러
    └─ balance >= 1 → 계속
        ↓
[Cloud Function 호출]
    quickDreamAnalysis(dreamText)
        ↓
    [서버 사이드 검증]
        1. 사용자 인증 확인
        2. 꿈 텍스트 검증 (500자 이내)
        3. 토큰 잔액 재확인
        ↓
    [OpenAI API 호출]
        POST https://api.openai.com/v1/chat/completions
        {
          model: "gpt-4o-mini",
          messages: [
            {role: "system", content: "꿈 분석 전문 AI Lumi..."},
            {role: "user", content: dreamText}
          ],
          max_tokens: 300
        }
        ↓
    [API 응답 받음]
        ↓
    [토큰 차감]
        Firestore conversationTokens/{userId}
        - balance -= 1
        - totalSpent += 1
        ↓
    [히스토리 기록]
        conversationTokens/{userId}/history 추가
        {
          type: "quick_analysis",
          amount: -1,
          balanceBefore,
          balanceAfter,
          createdAt
        }
        ↓
    [분석 결과 반환]
        {
          success: true,
          analysis: "...",
          tokensRemaining: balance - 1
        }
        ↓
[앱에서 결과 표시]
    - 분석 내용 표시
    - 남은 토큰 개수 업데이트
    ↓
[✅ 분석 완료]
```

### 에러 처리
- **토큰 부족**: "토큰이 부족합니다" 메시지
- **API 429 에러**: "API 사용량 한도 초과" 메시지
- **네트워크 오류**: "꿈 분석 중 오류가 발생했습니다"

---

## 3. 리워드 광고 시청 플로우

### 사용자 시나리오
사용자가 토큰을 얻기 위해 광고를 시청합니다.

### 상세 플로우

```
[빠른 분석 화면]
    ↓
["광고 보고 토큰 받기" 버튼 클릭]
    ↓
[RewardAdService.loadAd() 호출]
    ↓
[광고 로딩 중?]
    ├─ YES → 기존 Completer 반환
    └─ NO → 새로 로드
        ↓
[광고 이미 준비됨?]
    ├─ YES → 즉시 true 반환
    └─ NO → AdMob에서 광고 로드
        ↓
    [Google AdMob API]
        RewardedAd.load(
          adUnitId: _adUnitId,
          rewardedAdLoadCallback: {
            onAdLoaded,
            onAdFailedToLoad
          }
        )
        ↓
    [광고 로드 성공]
        _isAdReady = true
        _loadCompleter.complete(true)
        ↓
[광고 준비 완료]
    ↓
[RewardAdService.showAd() 호출]
    ↓
[광고 표시]
    _rewardedAd.show()
    ↓
[사용자가 광고 시청 중...]
    ↓
[광고 시청 완료]
    onUserEarnedReward 콜백 호출
    ↓
[토큰 지급]
    ConversationTokenService.earnFromRewardAd()
    ↓
    Cloud Function 호출: earnRewardAdTokens
    {
      isPremium: false
    }
    ↓
    [서버 사이드 검증]
        1. 사용자 인증 확인
        2. 하루 한도 확인 (무료: 3개, 프리미엄: 5개)
        3. 오늘 광고 시청 횟수 체크
        ↓
    [토큰 지급]
        Firestore conversationTokens/{userId}
        - balance += 1
        - totalEarned += 1
        ↓
    [광고 시청 횟수 기록]
        Firestore rewardAdUsage/{userId}
        - dailyCount += 1
        - lastAdDate = today
        ↓
    [결과 반환]
        {
          success: true,
          tokensEarned: 1,
          newBalance: balance + 1
        }
        ↓
[앱에서 결과 표시]
    - "토큰 1개를 획득했습니다!" 메시지
    - 토큰 잔액 업데이트
    ↓
[광고 정리]
    _rewardedAd.dispose()
    _isAdReady = false
    ↓
[다음 광고 프리로드]
    loadAd() 호출
    ↓
[✅ 광고 시청 완료]
```

### 에러 처리
- **광고 로드 실패**: "광고를 불러올 수 없습니다" 메시지
- **광고 표시 실패**: "광고 표시 중 오류 발생" 메시지
- **일일 한도 초과**: "오늘은 더 이상 광고를 볼 수 없습니다" 메시지

---

## 4. 환영 보너스 플로우 (신규 사용자)

### 사용자 시나리오
사용자가 앱을 처음 설치하고 실행하면 자동으로 1토큰을 받습니다.

### 상세 플로우

```
[앱 첫 실행]
    ↓
[ConversationTokenService 초기화]
    ↓
[Firestore 문서 존재 확인]
    conversationTokens/{userId} 문서 조회
    ↓
    ┌─────────────────────────┐
    │  문서가 존재하는가?      │
    └─────────────────────────┘
         ├─ YES → [기존 사용자] → 일반 리스너 설정
         │
         └─ NO → [🎁 신규 사용자!]
                     ↓
                [환영 보너스 지급]
                Firestore conversationTokens/{userId} 생성
                {
                  userId,
                  balance: 1,           ← 🎁 환영 보너스!
                  totalEarned: 1,
                  totalSpent: 0,
                  currentStreak: 0,
                  lastClaimDate: null,
                  firstTimeBonus: true, ← 보너스 플래그
                  createdAt: 서버시간,
                  lastUpdated: 서버시간
                }
                     ↓
                [✅ 환영 보너스 1토큰 지급 완료!]
                     ↓
                [Firestore 실시간 리스너 설정]
                     ↓
                [UI에 토큰 1개 표시]
```

### 장점
- **낮은 진입 장벽**: 신규 사용자가 즉시 AI 꿈 분석을 체험할 수 있음
- **온보딩 개선**: 토큰 시스템 이해도 향상
- **전환율 증가**: 무료 체험 → 체크리스트 완료 → 광고 시청으로 자연스럽게 유도

---

## 5. 앱 시작 초기화 플로우

### 상세 플로우

```
[앱 시작]
    ↓
[main.dart 실행]
    ↓
[Firebase 초기화]
    Firebase.initializeApp()
    ↓
[AdMob 초기화]
    MobileAds.instance.initialize()
    ↓
[Provider 초기화]
    - AuthService
    - ConversationTokenService
    - ExperienceService
    - DailyTaskService
    ↓
[AuthService 초기화]
    Firebase Auth 상태 리스닝
    ├─ 로그인됨
    │   ↓
    │   Firestore subscriptions/{userId} 구독
    │   ↓
    │   currentSubscription 설정
    └─ 로그아웃 → 익명 로그인
        ↓
[ConversationTokenService 초기화]
    Firestore conversationTokens/{userId} 존재 확인
    ├─ 없음 → 🎁 신규 사용자 환영 보너스 1토큰 지급
    └─ 있음 → 기존 데이터 로드
    ↓
    Firestore 실시간 리스너 설정
    ↓
    ConversationToken 객체 생성
    - balance
    - totalEarned
    - totalSpent
    - currentStreak
    ↓
[ExperienceService 초기화]
    SharedPreferences에서 ExperienceData 로드
    - currentLevel
    - currentExp
    - totalExp
    ↓
[DailyTaskService 초기화]
    TokenService, AuthService 주입
    setTokenService()
    setAuthService()
    ↓
[RewardAdService 백그라운드 프리로드]
    RewardAdService().loadAd()
    ↓
[✅ 앱 초기화 완료]
    ↓
[홈 화면 표시]
```

---

## 5. 데이터 동기화 플로우 (미래)

### 현재 상태
- **토큰**: Firestore에 저장 ✅
- **경험치/레벨**: SharedPreferences만 사용 ⚠️

### 개선 필요
```
[ExperienceService 개선안]
    ↓
[초기화 시]
    1. SharedPreferences 로드
    2. Firestore experience/{userId} 구독
    3. 데이터 병합 (Firestore > SharedPreferences)
    ↓
[경험치 획득 시]
    1. SharedPreferences 업데이트
    2. Firestore 업데이트 (동시)
    ↓
[장점]
    - 앱 삭제해도 데이터 유지
    - 여러 기기 간 동기화
    - 서버에서 레벨 검증 가능
```

---

## 6. 에러 시나리오 및 복구

### 네트워크 오류
```
[토큰 지급 실패]
    ↓
[로컬에 실패 기록]
    - 날짜는 저장 (중복 방지)
    - 재시도 큐에 추가 (미구현)
    ↓
[다음 앱 시작 시]
    - 실패한 작업 재시도 (미구현)
```

### 중복 보상 방지
```
[체크리스트 완료]
    ↓
[SharedPreferences 날짜 체크]
    lastRewardDate == today?
    ├─ YES → "이미 오늘 보상 받음" 메시지
    └─ NO → 보상 지급 진행
```

### 토큰 동기화 불일치
```
[클라이언트 토큰]: 5개
[서버 토큰]: 3개
    ↓
[분석 요청]
    ↓
[서버에서 재검증]
    balance < 1?
    ↓
    YES → 클라이언트에 에러 반환
    ↓
[클라이언트]
    서버 응답 기준으로 UI 업데이트
    (서버가 항상 진실의 원천)
```
