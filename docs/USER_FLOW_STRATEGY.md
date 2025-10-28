# 사용자 플로우 전략 - 선택적 회원가입

## 📊 비즈니스 모델

### 수익 구조
1. **광고 수익** (Primary) - 무료 사용자 80-90%
2. **구독 수익** (Secondary) - 유료 사용자 10-20%

---

## 👤 사용자 유형

### 1. 비회원 사용자 (기본)

**특징:**
- 회원가입 없이 바로 시작
- 로컬 데이터 관리 (SharedPreferences)
- 광고 표시
- 기본 기능 제공

**접근 권한:**
- ✅ Week 1-2 운동 프로그램
- ✅ 기본 진행 추적
- ✅ Chad Evolution (Level 1-2)
- ✅ 로컬 업적 시스템
- ❌ 클라우드 동기화
- ❌ 기기 간 데이터 이동
- ❌ 전체 프로그램 (Week 3-14)

**데이터 저장:**
```dart
SharedPreferences (로컬만)
├─ user_profile (익명)
├─ workout_history
├─ progress_data
└─ achievements
```

**장점:**
- 진입 장벽 ↓
- 이탈률 ↓
- 광고 수익 ↑
- 빠른 사용자 확보

---

### 2. 유료 사용자 (선택)

**특징:**
- 구매 시점에 회원가입
- Firebase 계정 연동
- 클라우드 동기화
- 광고 제거 (프리미엄)

**접근 권한:**
- ✅ 전체 프로그램 (Week 1-14)
- ✅ 클라우드 동기화
- ✅ 기기 간 데이터 이동
- ✅ 광고 제거 (프리미엄만)
- ✅ 고급 통계
- ✅ 데이터 백업/복원

**데이터 저장:**
```dart
Firestore (클라우드)
├─ users/{uid}/profile
├─ users/{uid}/workout_history
├─ users/{uid}/subscription
└─ users/{uid}/achievements

+ SharedPreferences (캐시)
```

**장점:**
- 고객 정보 관리
- 이탈 방지 (투자함)
- 높은 ARPU
- 지속 가능한 수익

---

## 🔄 전환 플로우

### 무료 → 유료 전환 시점

```
1. Week 2 완료 후
   ├─> "Week 3 잠금 해제하시겠습니까?"
   └─> 구매 화면 → 회원가입 유도

2. 광고 클릭 시 (선택)
   ├─> "광고 제거하시겠습니까?"
   └─> 프리미엄 구매 → 회원가입

3. 기기 변경 시
   ├─> "데이터를 새 기기로 옮기시겠습니까?"
   └─> 클라우드 동기화 → 회원가입

4. 백업 요청 시
   ├─> "데이터를 백업하시겠습니까?"
   └─> 클라우드 백업 → 회원가입
```

### 회원가입 화면 (구매 시)

```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('💪 프리미엄으로 업그레이드'),
    content: Column(
      children: [
        Text('전체 14주 프로그램을 잠금 해제하려면\n간단한 계정 생성이 필요합니다.'),
        SizedBox(height: 16),
        Text('혜택:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('✅ Week 1-14 전체 접근'),
        Text('✅ 클라우드 동기화'),
        Text('✅ 데이터 백업'),
        Text('✅ 여러 기기 사용'),
      ],
    ),
    actions: [
      TextButton(child: Text('나중에'), onPressed: () => Navigator.pop(context)),
      ElevatedButton(
        child: Text('계정 만들고 구매하기'),
        onPressed: () {
          // 1. 회원가입 (이메일 or Google)
          // 2. 구매 진행
          // 3. 로컬 데이터 → Firebase 마이그레이션
        },
      ),
    ],
  ),
);
```

---

## 💾 데이터 마이그레이션

### 비회원 → 회원 전환 시

```dart
Future<void> migrateLocalDataToFirebase() async {
  try {
    print('📤 로컬 데이터를 Firebase로 마이그레이션...');

    // 1. 로컬 데이터 읽기
    final localProfile = await DatabaseService.getLocalUserProfile();
    final localHistory = await DatabaseService.getLocalWorkoutHistory();
    final localProgress = await DatabaseService.getLocalProgress();

    // 2. Firebase 사용자 확인
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('로그인 필요');

    // 3. Firestore에 업로드
    final cloudSync = CloudSyncService();

    await cloudSync.uploadUserProfile(user.uid, localProfile);
    await cloudSync.uploadWorkoutHistory(user.uid, localHistory);
    await cloudSync.uploadProgress(user.uid, localProgress);

    // 4. 로컬 데이터 유지 (캐시로 사용)
    print('✅ 마이그레이션 완료!');

  } catch (e) {
    print('❌ 마이그레이션 실패: $e');
    rethrow;
  }
}
```

---

## 🔒 보안 모델

### 비회원 사용자
```
보안 레벨: 낮음 (로컬만)
├─ 데이터: 기기에만 저장
├─ 위험: 앱 삭제 시 데이터 손실
└─ 해결: "백업하려면 계정 생성하세요" 안내
```

### 회원 사용자
```
보안 레벨: 높음 (Firebase)
├─ 데이터: 클라우드 저장
├─ 인증: Firebase Auth
├─ 구독: Firestore (조작 불가)
└─ 영수증: Functions 검증 (TODO)
```

---

## 📱 구현 예시

### 1. auth_service.dart (기존 코드 활용)

**이미 게스트 모드 구현됨!**
```dart
// 게스트로 시작
Future<void> signInAsGuest() async {
  debugPrint('👤 게스트 모드로 계속');

  // 무료 구독 생성 (게스트용)
  _currentSubscription = UserSubscription.createFreeSubscription('guest');
  notifyListeners();
}
```

### 2. home_screen.dart - 구매 유도

```dart
// Week 2 완료 후 표시
if (currentWeek == 2 && weekCompleted) {
  _showPremiumPrompt();
}

void _showPremiumPrompt() {
  showDialog(
    context: context,
    builder: (context) => PremiumUpgradeDialog(
      onPurchase: () async {
        // 1. 회원가입 필요한지 체크
        final authService = Provider.of<AuthService>(context, listen: false);

        if (!authService.isLoggedIn) {
          // 2. 회원가입 화면 표시
          final signedUp = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUpScreen()),
          );

          if (!signedUp) return; // 취소됨

          // 3. 로컬 데이터 마이그레이션
          await migrateLocalDataToFirebase();
        }

        // 4. 구매 진행
        final billingService = BillingService();
        await billingService.purchaseSubscription('premium_monthly');
      },
    ),
  );
}
```

### 3. billing_service.dart 수정

**현재 문제: Firebase Auth 강제 체크**
```dart
// ❌ 현재 코드 - 비회원 구매 불가
if (userId == null) {
  debugPrint('❌ 사용자 인증 필요 - 구독 활성화 불가');
  return;
}
```

**수정 필요: 구매 시 회원가입 유도**
```dart
Future<void> _activateSubscription(String productId) async {
  final auth = FirebaseAuth.instance;
  final userId = auth.currentUser?.uid;

  // 비회원이면 회원가입 유도 (구매 전에 처리)
  if (userId == null) {
    debugPrint('⚠️ 구매를 완료하려면 계정이 필요합니다');

    // 콜백으로 회원가입 필요 알림
    _onAccountRequired?.call();

    return;
  }

  // 회원이면 정상 처리
  final cloudSyncService = CloudSyncService();
  final subscription = models.UserSubscription.createPremiumSubscription(userId);
  await cloudSyncService.saveSubscription(subscription);

  debugPrint('✅ 구독 활성화 완료');
}

// 콜백 추가
Function? _onAccountRequired;

void setAccountRequiredCallback(Function callback) {
  _onAccountRequired = callback;
}
```

---

## 📊 전환율 최적화

### 무료 → 유료 전환 전략

**1. 가치 경험 후 유도 (Week 2 완료)**
```dart
if (completedWeeks >= 2) {
  return PaywallScreen(
    title: '💪 멋지네요! Week 2 완료!',
    message: 'Week 3부터는 더 강력한 운동이 기다리고 있어요.',
    features: [
      '✅ Week 3-14 잠금 해제',
      '✅ 클라우드 동기화',
      '✅ 여러 기기에서 사용',
    ],
  );
}
```

**2. 광고 피로도 활용**
```dart
// 광고 3회 시청 후
if (adViewCount >= 3) {
  showSnackBar('광고 없이 운동하고 싶으신가요? 프리미엄으로 업그레이드하세요!');
}
```

**3. 기기 변경 시점**
```dart
// 새 기기에서 앱 설치 감지
if (isNewDevice && hasLocalProgress) {
  showDialog(
    title: '이전 데이터를 불러오시겠습니까?',
    message: '계정을 만들면 데이터를 복원할 수 있습니다.',
  );
}
```

---

## 🎯 구현 우선순위

### Phase 1: 현재 상태 유지 ✅
- [x] 게스트 모드 구현됨
- [x] SharedPreferences 로컬 저장
- [x] 광고 표시
- [x] Week 1-2 접근

### Phase 2: 구매 플로우 개선 (이번 작업)
- [ ] billing_service.dart 수정
  - [ ] 비회원 구매 시 회원가입 유도
  - [ ] 구매 전 계정 체크
- [ ] 회원가입 화면 간소화
  - [ ] 이메일 간단 가입
  - [ ] Google 로그인
- [ ] 데이터 마이그레이션 구현
  - [ ] 로컬 → Firebase 자동 전송

### Phase 3: 전환율 최적화
- [ ] Week 2 완료 시 Paywall
- [ ] 광고 피로도 추적
- [ ] 기기 변경 감지

---

## 💡 결론

### 당신의 전략이 완벽한 이유:

1. **낮은 진입 장벽** → 더 많은 사용자
2. **광고 수익 최대화** → 무료 사용자 80%+
3. **선택적 회원가입** → 높은 전환율
4. **Firebase 관리** → 유료 고객만 관리 비용

### 현재 코드 상태:
- ✅ **게스트 모드 이미 구현됨** (auth_service.dart)
- ✅ **로컬 저장 구현됨** (SharedPreferences)
- ⚠️ **billing_service.dart만 수정 필요**

---

**다음 작업**: billing_service.dart를 수정하여 비회원도 구매 가능하도록 개선하시겠습니까?

**작성자:** Claude
**작성일:** 2025-10-28
**전략:** 선택적 회원가입 (업계 표준)
