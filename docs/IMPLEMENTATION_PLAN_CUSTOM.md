# Mission100 커스텀 구현 계획

## 🎯 목표

1. 운동 프로그램을 버피 + 푸시업으로 단순화
2. 10월 가입자 특별 혜택 (Early Adopter)
3. 신규 가입자 1주 무료 체험

---

## 📝 상세 구현 계획

### 1. 운동 프로그램 변경

#### 1.1 운동 종류 단순화

**기존 (복잡)**:
```dart
- 푸시업
- 플랭크
- 스쿼트
- 런지
- 마운틴 클라이머
- 버피
- 등 다양한 운동
```

**신규 (단순)**:
```dart
Week 1-14: 버피 + 푸시업만

Week 1:
  Day 1: 버피 3세트 (5-5-5), 푸시업 3세트 (10-10-10)
  Day 2: 버피 3세트 (6-6-6), 푸시업 3세트 (12-12-12)
  ...

Week 14 (최종):
  Day 1: 버피 5세트 (20-20-20-20-20), 푸시업 5세트 (50-50-50-50-50)
```

#### 1.2 프로그램 구조

```dart
// lib/data/workout_program.dart
class WorkoutProgram {
  static List<WeekProgram> get mission100Program {
    return [
      // Week 1: 기초 (버피 5회, 푸시업 10회)
      WeekProgram(
        week: 1,
        days: [
          DayProgram(
            day: 1,
            exercises: [
              Exercise(
                name: '버피',
                type: ExerciseType.burpee,
                sets: [
                  ExerciseSet(targetReps: 5, restSeconds: 60),
                  ExerciseSet(targetReps: 5, restSeconds: 60),
                  ExerciseSet(targetReps: 5, restSeconds: 60),
                ],
              ),
              Exercise(
                name: '푸시업',
                type: ExerciseType.pushup,
                sets: [
                  ExerciseSet(targetReps: 10, restSeconds: 60),
                  ExerciseSet(targetReps: 10, restSeconds: 60),
                  ExerciseSet(targetReps: 10, restSeconds: 60),
                ],
              ),
            ],
          ),
          // Day 2-7...
        ],
      ),
      // Week 2-14: 점진적으로 증가
      // Week 2: 버피 6-7회, 푸시업 12-15회
      // Week 3: 버피 8-10회, 푸시업 15-20회
      // ...
      // Week 14: 버피 20회, 푸시업 50회
    ];
  }
}
```

---

### 2. 구독 시스템 개선

#### 2.1 새로운 구독 타입

```dart
// lib/models/subscription_type.dart
enum SubscriptionTier {
  free,              // 무료 (제한적)
  trial,             // 1주 체험 (신규 가입자)
  earlyAdopter,      // 10월 가입자 (프리미엄 기능, 광고 O)
  premium,           // 유료 프리미엄 (프리미엄 기능, 광고 X)
}

class SubscriptionFeatures {
  final SubscriptionTier tier;

  // 기능 접근 권한
  bool get hasUnlimitedWorkouts {
    return tier != SubscriptionTier.free;
  }

  bool get hasAdvancedStats {
    return tier != SubscriptionTier.free;
  }

  bool get hasAdFree {
    return tier == SubscriptionTier.premium; // 유료 프리미엄만 광고 제거
  }

  bool get hasPremiumChad {
    return tier != SubscriptionTier.free;
  }
}
```

#### 2.2 10월 가입자 판별

```dart
// lib/services/subscription_service.dart
class SubscriptionService {
  // 10월 가입자 확인
  Future<bool> isEarlyAdopter(String userId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (!userDoc.exists) return false;

    final createdAt = userDoc.data()?['createdAt'] as Timestamp?;
    if (createdAt == null) return false;

    final signupDate = createdAt.toDate();

    // 2025년 10월 1일 ~ 10월 31일
    final octoberStart = DateTime(2025, 10, 1);
    final octoberEnd = DateTime(2025, 10, 31, 23, 59, 59);

    return signupDate.isAfter(octoberStart) &&
           signupDate.isBefore(octoberEnd);
  }

  // 구독 tier 결정
  Future<SubscriptionTier> getUserSubscriptionTier(String userId) async {
    // 1. 유료 프리미엄 확인
    final subscription = await _getSubscription(userId);
    if (subscription?.status == 'active' &&
        subscription?.productId != null) {
      return SubscriptionTier.premium;
    }

    // 2. 10월 가입자 (Early Adopter) 확인
    if (await isEarlyAdopter(userId)) {
      return SubscriptionTier.earlyAdopter;
    }

    // 3. 1주 무료 체험 확인
    if (await isInTrialPeriod(userId)) {
      return SubscriptionTier.trial;
    }

    // 4. 기본 무료
    return SubscriptionTier.free;
  }

  // 1주 무료 체험 확인
  Future<bool> isInTrialPeriod(String userId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (!userDoc.exists) return false;

    final createdAt = userDoc.data()?['createdAt'] as Timestamp?;
    if (createdAt == null) return false;

    final signupDate = createdAt.toDate();
    final trialEndDate = signupDate.add(Duration(days: 7));

    return DateTime.now().isBefore(trialEndDate);
  }
}
```

#### 2.3 Firestore 데이터 구조

```javascript
// subscriptions 컬렉션
{
  userId: "abc123",
  tier: "earlyAdopter" | "trial" | "premium" | "free",

  // Early Adopter 정보
  isEarlyAdopter: true,
  earlyAdopterGrantedAt: Timestamp(2025-10-15),

  // Trial 정보
  trialStartDate: Timestamp(2025-11-01),
  trialEndDate: Timestamp(2025-11-08),
  hasUsedTrial: true,

  // Premium 정보
  productId: "premium_monthly" | "premium_yearly" | null,
  status: "active" | "inactive",
  startDate: Timestamp | null,
  expiryDate: Timestamp | null,

  // 광고 설정 (tier별로 다름)
  showAds: true, // earlyAdopter, trial은 true
}
```

---

### 3. 광고 시스템 분리

#### 3.1 광고 표시 로직

```dart
// lib/services/ad_service.dart
class AdService {
  // 광고 표시 여부 확인
  Future<bool> shouldShowAds(String userId) async {
    final tier = await SubscriptionService().getUserSubscriptionTier(userId);

    // Premium만 광고 제거
    return tier != SubscriptionTier.premium;
  }

  // 배너 광고 표시
  Widget buildBannerAd(String userId) {
    return FutureBuilder<bool>(
      future: shouldShowAds(userId),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return BannerAdWidget(); // 광고 표시
        }
        return SizedBox.shrink(); // 광고 숨김
      },
    );
  }
}
```

#### 3.2 홈 화면 광고 배치

```dart
// lib/screens/home_screen.dart
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        // 운동 정보
        TodayWorkoutCard(),

        // 진행 상황
        ProgressCard(),

        // 광고 배너 (Premium만 제거)
        AdService().buildBannerAd(currentUserId),

        // 프리미엄 배너 (Free tier만 표시)
        _buildPremiumBanner(),
      ],
    ),
  );
}

Widget _buildPremiumBanner() {
  return FutureBuilder<SubscriptionTier>(
    future: SubscriptionService().getUserSubscriptionTier(currentUserId),
    builder: (context, snapshot) {
      final tier = snapshot.data;

      if (tier == SubscriptionTier.free) {
        // 무료 사용자만 프리미엄 배너 표시
        return PremiumUpgradeBanner();
      } else if (tier == SubscriptionTier.trial) {
        // 체험 사용자에게 남은 기간 표시
        return TrialRemainingBanner();
      } else if (tier == SubscriptionTier.earlyAdopter) {
        // Early Adopter 감사 배너
        return EarlyAdopterThanksBanner();
      }

      return SizedBox.shrink();
    },
  );
}
```

---

### 4. UI 변경사항

#### 4.1 Early Adopter 배지

```dart
// 홈 화면 헤더
Widget _buildHeader(SubscriptionTier tier) {
  return Row(
    children: [
      Text('Mission100'),
      if (tier == SubscriptionTier.earlyAdopter)
        Container(
          margin: EdgeInsets.only(left: 8),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.red],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.stars, size: 16, color: Colors.white),
              SizedBox(width: 4),
              Text(
                'Early Adopter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      if (tier == SubscriptionTier.premium)
        Icon(Icons.workspace_premium, color: Colors.amber),
    ],
  );
}
```

#### 4.2 체험 종료 안내 (Day 7)

```dart
// 체험 만료 1일 전 알림
void _showTrialExpiringNotification() {
  NotificationService().show(
    title: '💎 무료 체험이 곧 종료됩니다',
    body: '내일부터 프리미엄 기능이 제한됩니다. 지금 구독하고 계속 이용하세요!',
    payload: 'subscription_screen',
  );
}

// 체험 만료 화면
class TrialExpiredDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('무료 체험 종료'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('7일 무료 체험이 종료되었습니다.'),
          SizedBox(height: 16),
          Text('프리미엄으로 업그레이드하고\n모든 기능을 계속 이용하세요!'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('나중에'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SubscriptionScreen(),
              ),
            );
          },
          child: Text('구독하기'),
        ),
      ],
    );
  }
}
```

#### 4.3 Early Adopter 감사 메시지

```dart
class EarlyAdopterThanksBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade100, Colors.red.shade100],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.stars, color: Colors.orange, size: 32),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Early Adopter 감사합니다!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '10월 가입자 여러분께 프리미엄 기능을 무료로 제공합니다! '
            '(광고는 서비스 운영을 위해 표시됩니다)',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
```

---

### 5. 구독 화면 업데이트

#### 5.1 Tier별 구독 화면

```dart
// lib/screens/subscription_screen.dart
class SubscriptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SubscriptionTier>(
      future: SubscriptionService().getUserSubscriptionTier(userId),
      builder: (context, snapshot) {
        final tier = snapshot.data ?? SubscriptionTier.free;

        return Scaffold(
          appBar: AppBar(title: Text('구독')),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // 현재 상태 표시
                _buildCurrentStatus(tier),

                // 구독 플랜
                if (tier != SubscriptionTier.premium)
                  _buildSubscriptionPlans(),

                // 혜택 설명
                _buildFeatureComparison(tier),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentStatus(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return _buildFreeStatus();
      case SubscriptionTier.trial:
        return _buildTrialStatus();
      case SubscriptionTier.earlyAdopter:
        return _buildEarlyAdopterStatus();
      case SubscriptionTier.premium:
        return _buildPremiumStatus();
    }
  }
}
```

#### 5.2 기능 비교표

```dart
Widget _buildFeatureComparison(SubscriptionTier currentTier) {
  return DataTable(
    columns: [
      DataColumn(label: Text('기능')),
      DataColumn(label: Text('무료')),
      DataColumn(label: Text('Early Adopter')),
      DataColumn(label: Text('프리미엄')),
    ],
    rows: [
      DataRow(cells: [
        DataCell(Text('무제한 운동')),
        DataCell(Icon(Icons.close, color: Colors.red)),
        DataCell(Icon(Icons.check, color: Colors.green)),
        DataCell(Icon(Icons.check, color: Colors.green)),
      ]),
      DataRow(cells: [
        DataCell(Text('고급 통계')),
        DataCell(Icon(Icons.close, color: Colors.red)),
        DataCell(Icon(Icons.check, color: Colors.green)),
        DataCell(Icon(Icons.check, color: Colors.green)),
      ]),
      DataRow(cells: [
        DataCell(Text('광고 제거')),
        DataCell(Icon(Icons.close, color: Colors.red)),
        DataCell(Icon(Icons.close, color: Colors.red)), // Early는 광고 O
        DataCell(Icon(Icons.check, color: Colors.green)),
      ]),
      DataRow(cells: [
        DataCell(Text('프리미엄 Chad')),
        DataCell(Icon(Icons.close, color: Colors.red)),
        DataCell(Icon(Icons.check, color: Colors.green)),
        DataCell(Icon(Icons.check, color: Colors.green)),
      ]),
    ],
  );
}
```

---

### 6. 마이그레이션 전략

#### 6.1 기존 사용자 처리

```dart
// 한 번만 실행되는 마이그레이션 함수
Future<void> migrateExistingUsers() async {
  final usersSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .get();

  for (var doc in usersSnapshot.docs) {
    final userId = doc.id;
    final createdAt = doc.data()['createdAt'] as Timestamp?;

    if (createdAt == null) continue;

    final signupDate = createdAt.toDate();
    final isOctober = signupDate.month == 10 && signupDate.year == 2025;

    // 10월 가입자에게 Early Adopter 부여
    if (isOctober) {
      await FirebaseFirestore.instance
          .collection('subscriptions')
          .doc(userId)
          .set({
            'tier': 'earlyAdopter',
            'isEarlyAdopter': true,
            'earlyAdopterGrantedAt': FieldValue.serverTimestamp(),
            'showAds': true, // 광고 표시
          }, SetOptions(merge: true));

      print('Early Adopter 부여: $userId');
    }
  }

  print('마이그레이션 완료!');
}
```

---

### 7. 테스트 시나리오

#### 7.1 10월 가입자 테스트

```
1. 2025-10-15에 계정 생성
2. 로그인
3. 홈 화면에서 "Early Adopter" 배지 확인 ✓
4. 통계 화면에서 고급 통계 접근 가능 확인 ✓
5. 광고 배너 표시 확인 ✓
6. 구독 화면에서 현재 상태 "Early Adopter" 확인 ✓
```

#### 7.2 신규 가입자 (11월) 테스트

```
1. 2025-11-01에 계정 생성
2. 로그인
3. 홈 화면에서 "1주 무료 체험" 배너 확인 ✓
4. 프리미엄 기능 사용 가능 확인 ✓
5. 광고 배너 표시 확인 ✓
6. 7일 후 (2025-11-08):
   - 체험 만료 알림 표시 ✓
   - 프리미엄 기능 제한 ✓
   - 구독 권유 화면 표시 ✓
```

#### 7.3 유료 프리미엄 테스트

```
1. 계정 생성
2. 프리미엄 구독 (월간 또는 연간)
3. 홈 화면에서 💎 아이콘 확인 ✓
4. 광고 없음 확인 ✓
5. 모든 프리미엄 기능 사용 가능 ✓
```

---

## 📊 구현 우선순위

### Phase 1: 핵심 기능 (우선)
1. ✅ SubscriptionTier 열거형 추가
2. ✅ isEarlyAdopter() 함수 구현
3. ✅ isInTrialPeriod() 함수 구현
4. ✅ shouldShowAds() 로직 수정

### Phase 2: UI 업데이트
5. ✅ Early Adopter 배지 추가
6. ✅ 체험 종료 안내 화면
7. ✅ 구독 화면 기능 비교표

### Phase 3: 운동 프로그램 변경
8. ✅ 버피 + 푸시업 프로그램 작성
9. ✅ 기존 운동 데이터 마이그레이션

### Phase 4: 테스트 및 배포
10. ✅ 시나리오별 테스트
11. ✅ 기존 사용자 마이그레이션
12. ✅ 프로덕션 배포

---

## 🎯 예상 결과

### 비즈니스 효과

**10월 가입자 (Early Adopter)**:
- 특별한 느낌 제공 (배지, 무료 프리미엄)
- 광고 수익 유지
- 충성도 높은 사용자 확보
- 예상: 50-100명

**신규 가입자 (11월 이후)**:
- 1주 무료 체험으로 전환율 향상
- 체험 → 유료 전환율: 15-20% 예상
- 광고 수익 유지

**유료 프리미엄**:
- 광고 제거로 가치 제공
- 월 ₩9,900 또는 연 ₩99,000
- 예상 전환율: 5-10%

### 수익 시뮬레이션 (100명 기준)

```
사용자 분포:
- Early Adopter: 20명 (광고 수익)
- Trial: 30명 (광고 수익)
- Free: 40명 (광고 수익)
- Premium: 10명 (구독 수익)

월 수익:
- 광고: 90명 × ₩1,000 = ₩90,000
- 구독: 10명 × ₩9,900 = ₩99,000
- 총: ₩189,000/월

vs 기존 (모두 유료 구독만):
- 구독: 10명 × ₩9,900 = ₩99,000
- 총: ₩99,000/월

→ 90% 수익 증가! ✅
```

---

**문서 버전**: 1.0.0
**최종 업데이트**: 2025-10-01
**작성자**: Mission100 개발팀
