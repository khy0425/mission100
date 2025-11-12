# DreamFlow (Lucid Dream 100) 완성 TODO

## ✅ 완료된 작업

### 백엔드 (Firebase Functions)
- [x] OpenAI API 키 Firebase Secret에 안전하게 저장
- [x] `analyzeWithLumi` 함수 구현 (대화형 분석)
- [x] `quickDreamAnalysis` 함수 구현 (빠른 분석)
- [x] Firebase Functions 배포 완료
- [x] Secret Manager 접근 권한 설정

### 데이터 모델
- [x] `ConversationTokens` 모델 (토큰 경제 시스템)
- [x] `DreamConversation` 모델 (대화 세션)
- [x] `ConversationMessage` 모델 (메시지)

### 서비스
- [x] `ConversationTokenService` - 토큰 관리
- [x] `ConversationStorageService` - 대화 저장
- [x] `DreamAnalysisServiceSecure` - 안전한 AI 호출
- [x] `ConversationTokenService`를 main.dart에 통합

### 구독 시스템
- [x] Lifetime 구독으로 변경 (365일 → null)
- [x] 사용량 제한 설정 (10회/일, 300회/월)
- [x] 프리미엄 혜택에 대화 토큰 추가

### 문서
- [x] API 키 보안 가이드
- [x] Firebase Remote Config 설명
- [x] 대화 시스템 가이드
- [x] 빠른 시작 가이드

---

## 📋 다음 작업 (우선순위별)

### 🔴 Critical (필수)

#### 1. 대화형 UI 구현
**파일**: `lib/screens/ai/lumi_conversation_screen.dart`

**기능**:
- 채팅 인터페이스
- 메시지 입력창
- AI 응답 표시
- 로딩 상태
- 토큰 잔액 표시

**예상 시간**: 2-3시간

---

#### 2. 토큰 관리 UI
**파일**: `lib/widgets/ai/token_balance_widget.dart`

**기능**:
- 현재 토큰 잔액
- 일일 보상 받기 버튼
- 다음 보상까지 남은 시간
- 토큰 사용 내역

**예상 시간**: 1시간

---

#### 3. 분석 모드 선택 화면
**파일**: `lib/screens/ai/dream_analysis_mode_screen.dart`

**기능**:
- 빠른 분석 (기존)
- Lumi와 대화 (신규)
- 각 모드 설명
- 토큰 필요량 표시

**예상 시간**: 1시간

---

### 🟡 Important (중요)

#### 4. 일일 보상 시스템 통합
**파일**: `lib/screens/home_screen.dart` 또는 메인 화면

**기능**:
- 앱 시작 시 자동으로 보상 가능 확인
- 보상 알림 표시
- 보상 받기 다이얼로그

**예상 시간**: 1-2시간

---

#### 5. 리워드 광고 통합
**파일**: `lib/services/ai/conversation_token_reward_service.dart`

**기능**:
- 광고 시청 후 토큰 1개 지급
- `RewardedAdRewardService`와 통합
- `ConversationTokenService.earnFromRewardAd()` 호출

**예상 시간**: 1시간

---

#### 6. 대화 내역 화면
**파일**: `lib/screens/ai/conversation_history_screen.dart`

**기능**:
- 이전 대화 목록
- 대화 재개
- 대화 삭제
- 검색 기능

**예상 시간**: 2시간

---

### 🟢 Nice to Have (선택)

#### 7. 토큰 통계 화면
**파일**: `lib/screens/ai/token_statistics_screen.dart`

**기능**:
- 획득한 토큰 총계
- 사용한 토큰 총계
- 일별/주별 통계 그래프

**예상 시간**: 2시간

---

#### 8. AI 응답 개선 기능
**기능**:
- 응답에 대한 피드백 (좋아요/싫어요)
- 대화 저장
- 대화 공유

**예상 시간**: 1-2시간

---

#### 9. 프리미엄 전용 기능 확장
**기능**:
- 더 긴 대화 (20 메시지 → 30 메시지)
- 더 많은 출력 토큰 (500 → 1000)
- 대화 내보내기

**예상 시간**: 1시간

---

## 🎯 추천 작업 순서

### Phase 1: MVP (최소 기능 제품) - 1주일
1. **Day 1-2**: 대화형 UI 구현 ✨
2. **Day 3**: 토큰 관리 UI
3. **Day 4**: 분석 모드 선택 화면
4. **Day 5**: 일일 보상 시스템 통합
5. **Day 6-7**: 테스트 및 버그 수정

**결과**: 사용자가 Lumi와 대화할 수 있는 기본 기능 완성

---

### Phase 2: 수익화 강화 - 3-4일
1. **Day 8**: 리워드 광고 통합
2. **Day 9**: 대화 내역 화면
3. **Day 10**: 프리미엄 기능 강조

**결과**: 무료 사용자 수익화 및 프리미엄 전환율 향상

---

### Phase 3: UX 개선 - 선택적
1. 토큰 통계
2. AI 응답 개선
3. 추가 기능

---

## 📝 상세 구현 가이드

### 1. 대화형 UI 구현 예시

```dart
// lib/screens/ai/lumi_conversation_screen.dart
class LumiConversationScreen extends StatefulWidget {
  const LumiConversationScreen({super.key});

  @override
  State<LumiConversationScreen> createState() => _LumiConversationScreenState();
}

class _LumiConversationScreenState extends State<LumiConversationScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final DreamAnalysisServiceSecure _aiService = DreamAnalysisServiceSecure();

  String? _conversationId;
  List<ConversationMessage> _messages = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💬 Lumi와 대화'),
        actions: [
          // 토큰 잔액 표시
          Consumer<ConversationTokenService>(
            builder: (context, tokenService, _) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    '🎫 ${tokenService.balance}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 메시지 리스트
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // 입력창
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ConversationMessage message) {
    final isUser = message.role == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Lumi에게 메시지 보내기...',
                border: OutlineInputBorder(),
              ),
              maxLength: 500,
            ),
          ),
          IconButton(
            icon: _isLoading
                ? const CircularProgressIndicator()
                : const Icon(Icons.send),
            onPressed: _isLoading ? null : _sendMessage,
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _isLoading = true);
    _controller.clear();

    try {
      final result = await _aiService.analyzeWithConversation(
        conversationId: _conversationId,
        userMessage: text,
      );

      setState(() {
        _conversationId = result.conversationId;
        // 메시지 추가 로직
        _isLoading = false;
      });

      // 자동 스크롤
      _scrollToBottom();
    } catch (e) {
      // 에러 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
```

---

### 2. 토큰 관리 UI 예시

```dart
// lib/widgets/ai/token_balance_widget.dart
class TokenBalanceWidget extends StatelessWidget {
  const TokenBalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConversationTokenService>(
      builder: (context, tokenService, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '대화 토큰',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '${tokenService.balance}',
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (tokenService.canClaimDailyReward())
                  ElevatedButton(
                    onPressed: () => _claimDailyReward(context, tokenService),
                    child: const Text('일일 보상 받기'),
                  )
                else
                  Text(
                    '다음 보상까지: ${_formatDuration(tokenService.getTimeUntilNextDailyReward())}',
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _claimDailyReward(
    BuildContext context,
    ConversationTokenService tokenService,
  ) async {
    final authService = context.read<AuthService>();
    final isPremium = authService.userSubscription.isPremium;

    await tokenService.claimDailyReward(isPremium: isPremium);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('토큰 ${isPremium ? 5 : 1}개를 받았습니다!'),
        ),
      );
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}시간 ${minutes}분';
  }
}
```

---

## 🧪 테스트 계획

### 단위 테스트
- [ ] ConversationTokenService 테스트
- [ ] DreamAnalysisServiceSecure 테스트
- [ ] ConversationStorageService 테스트

### 통합 테스트
- [ ] 대화 시작부터 종료까지 플로우
- [ ] 토큰 소모 및 보상 시스템
- [ ] Firebase Functions 호출

### 수동 테스트
- [ ] 무료 사용자 시나리오
- [ ] 프리미엄 사용자 시나리오
- [ ] 토큰 부족 시나리오
- [ ] 네트워크 오류 시나리오

---

## 📊 성공 지표

### MVP 완성 기준
- [ ] 사용자가 Lumi와 5회 이상 대화 가능
- [ ] 토큰 획득 및 소모가 정상 작동
- [ ] 대화 내역이 저장되고 불러올 수 있음
- [ ] 에러 처리가 적절함
- [ ] UI/UX가 직관적임

### 수익화 준비
- [ ] 리워드 광고 통합 완료
- [ ] 프리미엄 혜택 명확하게 표시
- [ ] 토큰 경제가 균형잡힘

---

## 💡 팁

1. **빠른 프로토타입**: 먼저 기능만 구현하고 UI는 나중에 다듬기
2. **테스트 토큰**: 개발 중에는 `addTokensForTesting()` 사용
3. **로그 활용**: Firebase Console에서 Functions 로그 확인
4. **점진적 배포**: 기능 하나씩 완성하고 테스트

---

**현재 우선순위**:
1️⃣ 대화형 UI 구현 (가장 중요!)
2️⃣ 토큰 관리 UI
3️⃣ 분석 모드 선택

이 세 가지만 완성하면 사용자가 AI와 대화할 수 있습니다! 🚀
