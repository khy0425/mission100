# DreamFlow 수익화 시스템 가이드

**작성일:** 2025-11-14
**버전:** 1.0
**상태:** Phase 1 구현 완료

---

## 📋 개요

DreamFlow의 수익화 시스템은 무료 사용자와 프리미엄 사용자 모두에게 최적의 경험을 제공하면서 지속 가능한 수익을 창출하도록 설계되었습니다.

### 핵심 전략
1. **광고 기반 수익** - 보상형 광고로 사용자 경험 유지
2. **프리미엄 구독** - 광고 제거 + 추가 기능
3. **AI 크레딧 시스템** - 무료 사용자용 제한적 AI 분석

---

## 💰 수익 모델

### 1. 무료 사용자 수익화

#### A. 보상형 광고 (Rewarded Ads)
```
사용자 행동: 광고 시청 (자발적)
보상: AI 분석 크레딧 1개
빈도: 무제한 (최대 크레딧까지)
eCPM: $5-$10 (높은 수익)
```

**장점:**
- ✅ 사용자가 선택적으로 시청
- ✅ 높은 광고 단가
- ✅ 사용자 만족도 유지
- ✅ 프리미엄 전환 동기 부여

#### B. 전면 광고 (Interstitial Ads)
```
타이밍:
- 체크리스트 완료 후 (1일 1회)
- 주간 리포트 확인 후
빈도: 제한적 (1일 1-2회)
eCPM: $2-$5
```

### 3. AI 크레딧 시스템

#### 일간 무료 크레딧
```
매일 자정: 1 크레딧 자동 지급
최대 누적: 10 크레딧
광고 시청: 추가 1 크레딧 획득
```

**배치 원칙:**
- ❌ 꿈 일기 작성 중 방해 금지
- ❌ 체크리스트 작성 중 방해 금지
- ✅ 완료 후 자연스러운 타이밍만

### 2. 프리미엄 구독

#### 가격
- **월간:** $4.99
- **연간:** $39.99 (33% 할인)

#### 제공 기능
- ✅ 광고 완전 제거
- ✅ AI 분석 무제한 (크레딧 제한 없음)
- ✅ 고급 통계 (60일치)
- ✅ 프리미엄 캐릭터 진화 (Stage 5-6)
- ✅ 클라우드 백업

---

## 📊 수익 예상

### 무료 사용자당 수익
```
보상형 광고: 월 2-3회 시청 × $0.30-$0.50 = $0.60-$1.50
전면 광고: 월 15회 × $0.02-$0.05 = $0.30-$0.75
------------------------------------------------
총 예상 수익: 사용자당 월 $0.90-$2.25
```

### 프리미엄 전환율 목표
```
전환율: 2-5%
평균 구독료: $4.99/월

예시:
10,000 무료 사용자
  - 광고 수익: $9,000-$22,500
  - 프리미엄 전환 (3%): 300명 × $4.99 = $1,497
  - 총 수익: $10,497-$23,997/월
```

---

## 🔧 기술 구현

### 파일 구조
```
lib/
├── services/
│   └── monetization/
│       ├── ad_service.dart          # Google AdMob 관리
│       └── ai_credit_service.dart   # AI 크레딧 시스템
├── widgets/
│   └── monetization/
│       └── watch_ad_button.dart     # 광고 시청 UI
└── main.dart                        # AdMob 초기화
```

### 핵심 서비스

#### 1. AdService
```dart
// services/monetization/ad_service.dart

// 초기화
await AdService().initialize();

// 보상형 광고 표시
await AdService().showRewardedAd(
  onRewardEarned: (amount, type) {
    // 크레딧 지급
    await AIcreditService.earnCreditsFromAd();
  },
);

// 전면 광고 표시
await AdService().showInterstitialAd();
```

#### 2. AIcreditService
```dart
// services/monetization/ai_credit_service.dart

// 크레딧 확인
int credits = await AIcreditService.getCredits();

// 크레딧 사용 (AI 분석)
bool success = await AIcreditService.useCredit();

// 광고로 크레딧 획득
await AIcreditService.earnCreditsFromAd();
```

### UI 위젯

#### WatchAdButton
```dart
// 기본 사용
WatchAdButton(
  onAdWatched: () {
    print('광고 시청 완료!');
  },
)

// 스타일 변경
WatchAdButton(
  style: 'outlined', // 'elevated' | 'outlined' | 'text'
  customText: '광고 보고 AI 분석 받기',
)
```

#### AIcreditDisplay
```dart
// 크레딧 표시 + 광고 버튼
AIcreditDisplay(
  isPremium: false, // 프리미엄 사용자는 무제한 표시
  onAdWatched: () {
    // 크레딧 획득 후 콜백
  },
)
```

---

## 🎯 사용자 경험 설계

### 무료 사용자 플로우

#### 1. 첫 방문 (Day 1)
```
✅ 무료 크레딧 1개 지급
✅ AI 분석 무료 체험
```

#### 2. 크레딧 소진
```
📊 "AI 크레딧이 부족합니다"
┌─────────────────────────────┐
│ 현재 크레딧: 0 / 10         │
│                             │
│ 옵션 1: 광고 보고 받기      │
│ 옵션 2: 프리미엄 구독       │
│ 옵션 3: 매일 자정 무료 1개  │
└─────────────────────────────┘
```

#### 3. 광고 시청
```
1️⃣ 사용자가 "광고 보기" 버튼 클릭
2️⃣ 보상형 광고 재생 (15-30초)
3️⃣ 광고 완료 시 크레딧 +1
4️⃣ AI 분석 즉시 사용 가능
```

#### 4. 프리미엄 전환 제안
```
타이밍:
- Day 7: "7일 완료! 프리미엄으로 무제한 사용"
- Day 14: "2주 달성! AI 무제한 + 고급 통계"
- Day 28: "30일 완료! 프리미엄 전용 캐릭터"
```

---

## 📱 화면별 구현 예시

### AI 분석 화면

```dart
// lucid_dream_ai_assistant_screen.dart

class LucidDreamAIAssistantScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isPremium(),
      builder: (context, snapshot) {
        final isPremium = snapshot.data ?? false;

        return Column(
          children: [
            // 크레딧 표시
            AIcreditDisplay(
              isPremium: isPremium,
              onAdWatched: () {
                setState(() {
                  // 크레딧 업데이트
                });
              },
            ),

            // AI 분석 버튼
            ElevatedButton(
              onPressed: () async {
                if (!isPremium) {
                  // 무료 사용자 - 크레딧 확인
                  final hasCredit = await AIcreditService.useCredit();
                  if (!hasCredit) {
                    _showNoCreditDialog();
                    return;
                  }
                }

                // AI 분석 실행
                await _analyzeDream();
              },
              child: Text('AI 분석 시작'),
            ),
          ],
        );
      },
    );
  }

  void _showNoCreditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('AI 크레딧 부족'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('AI 분석에는 크레딧이 필요합니다.'),
            SizedBox(height: 16),
            WatchAdButton(
              onAdWatched: () {
                Navigator.pop(context);
                // 자동으로 분석 실행
              },
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // 프리미엄 구독 화면으로
              },
              child: Text('프리미엄 구독하기'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🚀 배포 전 체크리스트

### AdMob 설정

#### 1. 광고 단위 ID 생성
```
Google AdMob Console:
1. 앱 등록
2. 광고 단위 생성:
   - 보상형 광고 (Rewarded)
   - 전면 광고 (Interstitial)
3. 광고 단위 ID 복사
```

#### 2. 코드에 적용
```dart
// ad_service.dart에서 수정:

static String get _rewardedAdUnitId {
  if (Platform.isAndroid) {
    return 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY'; // 실제 ID
  } else if (Platform.isIOS) {
    return 'ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ'; // 실제 ID
  }
  return '';
}
```

#### 3. AndroidManifest.xml 설정
```xml
<!-- android/app/src/main/AndroidManifest.xml -->

<manifest>
  <application>
    <!-- AdMob App ID -->
    <meta-data
      android:name="com.google.android.gms.ads.APPLICATION_ID"
      android:value="ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY"/>
  </application>
</manifest>
```

#### 4. Info.plist 설정 (iOS)
```xml
<!-- ios/Runner/Info.plist -->

<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY</string>

<key>SKAdNetworkItems</key>
<array>
  <dict>
    <key>SKAdNetworkIdentifier</key>
    <string>cstr6suwn9.skadnetwork</string>
  </dict>
  <!-- 더 많은 SKAdNetwork IDs... -->
</array>
```

### 테스트

#### 1. 테스트 광고 확인
```
✅ 보상형 광고 로드 확인
✅ 보상형 광고 표시 확인
✅ 보상 지급 확인
✅ 크레딧 증가 확인
✅ 전면 광고 표시 확인
```

#### 2. 실제 광고 테스트
```
⚠️ 주의: 본인 앱에서 실제 광고 클릭 금지!
- 테스트 계정 사용
- 테스트 기기 등록
```

---

## 📈 성공 지표

### 사용자 참여
- 광고 시청률: 20-30%
- 보상형 광고 완료율: 80%+
- 프리미엄 전환율: 2-5%

### 수익
- 무료 사용자 ARPU: $1-$2/월
- 프리미엄 사용자 ARPU: $4.99/월
- 총 ARPU (혼합): $1.50-$2.50/월

### 광고 성능
- 보상형 광고 eCPM: $5-$10
- 전면 광고 eCPM: $2-$5
- Fill Rate: 90%+

---

## 🔄 개선 계획

### Phase 2: 추가 수익원
- [ ] 제휴 마케팅 (수면 제품)
- [ ] 프리미엄 가이드북 판매
- [ ] 기업 B2B 라이선스

### Phase 3: 최적화
- [ ] A/B 테스트 (광고 타이밍)
- [ ] 프리미엄 가격 실험
- [ ] 크레딧 시스템 조정

---

## 💡 베스트 프랙티스

### 광고 배치
1. **사용자 경험 우선**: 핵심 기능 방해 금지
2. **적절한 빈도**: 1일 1-2회 전면 광고 제한
3. **보상형 중심**: 자발적 시청 유도
4. **자연스러운 타이밍**: 작업 완료 후에만

### 프리미엄 전환
1. **가치 제공**: 광고 제거 + 추가 기능
2. **적절한 타이밍**: 7/14/28일차 제안
3. **명확한 차별화**: 무료 vs 프리미엄 비교
4. **체험 제공**: 첫 7일 프리미엄 체험 (선택)

### 크레딧 시스템
1. **공정한 제한**: 매일 1개 무료 제공 (자정 자동 지급)
2. **획득 기회**: 광고로 추가 획득 가능
3. **최대값 설정**: 10개까지 누적 가능
4. **투명성**: 남은 크레딧 명확히 표시

---

## 🆘 문제 해결

### 광고가 표시되지 않음
```
1. AdMob 앱 승인 대기 (최대 24시간)
2. 광고 단위 ID 확인
3. 인터넷 연결 확인
4. 테스트 광고 ID로 테스트
```

### 보상이 지급되지 않음
```
1. onRewardEarned 콜백 확인
2. AIcreditService.earnCreditsFromAd() 호출 확인
3. SharedPreferences 저장 확인
4. 로그 확인 (debugPrint)
```

### 크레딧이 리셋되지 않음
```
1. _checkDailyReset() 로직 확인
2. 마지막 리셋 날짜 확인 (자정 기준)
3. SharedPreferences 키 확인
4. 디바이스 시간 설정 확인
```

---

**작성자:** Claude Code Assistant
**마지막 업데이트:** 2025-11-14
**다음 단계:** AdMob 광고 단위 ID 설정 및 테스트
