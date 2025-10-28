# 구매 플로우 구현 가이드

## 📦 완료된 작업

### 1. billing_service.dart 개선 ✅
- 비회원 구매 지원
- 회원가입 유도 콜백
- 대기 중인 구매 처리

### 2. 회원가입 유도 UI ✅
- AccountRequiredDialog 위젯
- SignUpForPurchaseScreen 화면

### 3. 데이터 마이그레이션 ✅
- DataMigrationService 서비스
- 로컬 → Firebase 자동 전송

---

## 🔄 구매 플로우

### 전체 흐름

```
1. 사용자가 구매 버튼 클릭
   ↓
2. Google Play 결제 진행
   ↓
3. 구매 성공
   ↓
4. billing_service: 회원 여부 확인
   ├─ 회원: Firestore 저장 (완료)
   └─ 비회원: 구매 정보 임시 저장 → 회원가입 유도
         ↓
5. 회원가입 화면 표시
   ├─ 이메일 회원가입
   └─ Google 로그인
         ↓
6. 로컬 데이터 마이그레이션
   ↓
7. 대기 중인 구매 완료 처리
   ↓
8. Firestore에 구독 저장
   ↓
9. 완료!
```

---

## 📝 구현 예시

### 1. 앱 시작 시 billing_service 콜백 설정

**파일**: `lib/main.dart` 또는 앱의 루트 위젯

```dart
import 'package:flutter/material.dart';
import 'services/billing_service.dart';
import 'widgets/dialogs/account_required_dialog.dart';
import 'screens/signup_for_purchase_screen.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final BillingService _billingService = BillingService();

  @override
  void initState() {
    super.initState();
    _setupBillingCallbacks();
  }

  void _setupBillingCallbacks() {
    // 회원가입 필요 시 호출되는 콜백
    _billingService.setAccountRequiredCallback(() {
      _showAccountRequiredFlow();
    });
  }

  void _showAccountRequiredFlow() {
    // 현재 context 가져오기
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // 회원가입 유도 다이얼로그 표시
    showAccountRequiredDialog(
      context,
      productName: '프리미엄 구독',
      onSignUp: () {
        // 회원가입 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignUpForPurchaseScreen(
              productName: '프리미엄 구독',
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // 전역 navigator key 필요
      home: HomeScreen(),
    );
  }
}

// 전역 navigator key (앱 전체에서 context 접근용)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
```

---

### 2. 구매 버튼 클릭 시

**파일**: `lib/screens/home_screen.dart` 또는 구매 화면

```dart
import 'package:flutter/material.dart';
import '../services/billing_service.dart';

class HomeScreen extends StatelessWidget {
  final BillingService _billingService = BillingService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handlePurchase(context),
          child: const Text('프리미엄 구매하기'),
        ),
      ),
    );
  }

  Future<void> _handlePurchase(BuildContext context) async {
    try {
      // 구매 진행 (회원 여부는 billing_service가 자동 처리)
      await _billingService.purchaseSubscription('premium_monthly');

      // 성공 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('구매가 완료되었습니다!')),
      );

    } catch (e) {
      // 에러 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('구매 실패: $e')),
      );
    }
  }
}
```

---

### 3. Week 2 완료 후 Paywall 표시

**파일**: `lib/screens/workout_completion_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/billing_service.dart';
import '../widgets/dialogs/account_required_dialog.dart';
import '../screens/signup_for_purchase_screen.dart';

class WorkoutCompletionScreen extends StatelessWidget {
  final int completedWeek;

  const WorkoutCompletionScreen({
    Key? key,
    required this.completedWeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Week 2 완료 시 Paywall 표시
    if (completedWeek == 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPaywall(context);
      });
    }

    return Scaffold(
      body: Center(
        child: Text('Week $completedWeek 완료!'),
      ),
    );
  }

  void _showPaywall(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('💪 멋지네요! Week 2 완료!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Week 3부터는 더 강력한 운동이\n기다리고 있어요.'),
            const SizedBox(height: 16),
            const Text('프리미엄 혜택:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildBenefit('✅ Week 3-14 전체 잠금 해제'),
            _buildBenefit('✅ 클라우드 동기화'),
            _buildBenefit('✅ 여러 기기에서 사용'),
            _buildBenefit('✅ 데이터 백업 & 복원'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('나중에'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handlePremiumPurchase(context);
            },
            child: const Text('프리미엄 시작하기'),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefit(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  Future<void> _handlePremiumPurchase(BuildContext context) async {
    final billingService = BillingService();

    try {
      // 구매 시도 (회원 여부는 billing_service가 자동 처리)
      await billingService.purchaseSubscription('premium_monthly');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('프리미엄 구독이 활성화되었습니다!')),
        );
      }

    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('구매 실패: $e')),
        );
      }
    }
  }
}
```

---

### 4. 로그인 후 대기 중인 구매 완료

**파일**: `lib/services/auth_service.dart` (기존 파일 수정)

```dart
// 로그인 성공 후 호출
Future<void> _onLoginSuccess() async {
  try {
    // 대기 중인 구매가 있는지 확인하고 처리
    final billingService = BillingService();
    await billingService.completePendingPurchase();

    debugPrint('✅ 로그인 후 대기 중인 구매 처리 완료');

  } catch (e) {
    debugPrint('⚠️ 대기 중인 구매 처리 오류: $e');
  }
}

// 기존 signIn, signUp, signInWithGoogle 메서드에 추가
Future<bool> signIn({required String email, required String password}) async {
  // ... 기존 로그인 코드 ...

  if (credential != null) {
    await _onLoginSuccess(); // 추가
    return true;
  }

  return false;
}
```

---

## 🔒 Firestore Security Rules

**중요**: Firestore에 다음 규칙을 설정해야 합니다.

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // 구독 정보
    match /users/{userId}/subscription/{subscriptionId} {
      // 읽기: 본인만
      allow read: if request.auth != null && request.auth.uid == userId;

      // 쓰기: 본인만 (클라이언트에서 생성 가능)
      allow create: if request.auth != null && request.auth.uid == userId;

      // 업데이트/삭제: Firebase Functions만 (TODO: Functions 구현 후 변경)
      allow update, delete: if false;
    }

    // 사용자 프로필
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // 운동 기록
    match /users/{userId}/workoutHistory/{historyId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## 📊 테스트 시나리오

### 시나리오 1: 비회원 → 구매 → 회원가입

```
1. 앱 설치 (회원가입 없이 시작)
2. Week 1-2 운동 진행
3. Week 2 완료 → Paywall 표시
4. "프리미엄 시작하기" 클릭
5. Google Play 결제 진행
6. 결제 완료
7. "계정 생성이 필요합니다" 다이얼로그 표시
8. 회원가입 화면으로 이동
9. 이메일/Google로 회원가입
10. 로컬 데이터 마이그레이션 자동 진행
11. 구매 완료 처리
12. 프리미엄 기능 사용 가능
```

**테스트 체크리스트:**
- [ ] 비회원으로 Week 1-2 완료 가능
- [ ] 구매 시 회원가입 다이얼로그 표시
- [ ] 회원가입 후 데이터 보존
- [ ] Firestore에 구독 정보 저장 확인
- [ ] Week 3-14 접근 가능

---

### 시나리오 2: 기존 회원 → 구매

```
1. 앱 설치
2. 로그인
3. 운동 진행
4. 구매 버튼 클릭
5. Google Play 결제 진행
6. 결제 완료
7. 바로 Firestore에 저장
8. 프리미엄 기능 사용 가능
```

**테스트 체크리스트:**
- [ ] 로그인 후 바로 구매 가능
- [ ] 회원가입 단계 생략됨
- [ ] Firestore에 구독 정보 저장 확인

---

### 시나리오 3: 구매 → 회원가입 취소 → 재시도

```
1. 비회원으로 구매
2. 회원가입 다이얼로그에서 "나중에" 클릭
3. 앱 계속 사용 (구매는 완료됨)
4. 나중에 다시 로그인 시도
5. 회원가입 완료
6. 대기 중인 구매 자동 처리
7. 프리미엄 기능 사용 가능
```

**테스트 체크리스트:**
- [ ] 회원가입 취소 후에도 앱 사용 가능
- [ ] 구매 정보가 로컬에 저장됨
- [ ] 나중에 로그인 시 구매 복원

---

## 🚨 주의사항

### 1. 구매 검증 미구현 (TODO)
```dart
// TODO: Firebase Functions로 영수증 검증 구현 필요
// await _verifyPurchaseWithServer(productId, purchaseToken);
```

**현재 상태**: 클라이언트에서 Firestore에 직접 저장
**배포 전 필수**: Firebase Functions로 Google Play API 영수증 검증

---

### 2. 환불 처리 (TODO)
현재는 환불 시 자동으로 구독 상태가 업데이트되지 않습니다.

**해결책**: Firebase Functions로 Pub/Sub 알림 수신
```typescript
// functions/src/index.ts
export const handleRefund = functions.pubsub
  .topic('play-billing')
  .onPublish(async (message) => {
    const notification = message.json;

    if (notification.notificationType === 2) { // REFUND
      // Firestore 구독 상태 업데이트
      await admin.firestore()
        .collection('users')
        .doc(userId)
        .collection('subscription')
        .doc(subscriptionId)
        .update({ status: 'refunded' });
    }
  });
```

---

### 3. 기기 간 동기화
**현재 구현**: ✅ Firestore 기반으로 자동 동기화
**테스트 필요**:
- 기기 A에서 구매
- 기기 B에서 로그인
- 구독 상태 자동 복원 확인

---

## 📚 추가 문서

- [USER_FLOW_STRATEGY.md](./USER_FLOW_STRATEGY.md) - 전체 전략
- [SECURITY_IMPROVEMENTS.md](./SECURITY_IMPROVEMENTS.md) - 보안 개선
- [TODO_COMPLETION_REPORT.md](./TODO_COMPLETION_REPORT.md) - 완료 보고서

---

**작성자:** Claude
**작성일:** 2025-10-28
**버전:** 1.0
**상태:** ✅ 구현 완료 (영수증 검증 제외)
