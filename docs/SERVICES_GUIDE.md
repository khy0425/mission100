# Services 폴더 가이드

## 📅 최종 업데이트: 2025-10-28

---

## 📊 개요

Mission100 앱의 모든 비즈니스 로직이 담긴 **51개의 서비스 파일**이 있습니다.

**위치:** `lib/services/`

---

## 🗂️ 카테고리별 서비스

### 1️⃣ 인증 & 구독 (5개) 🔐

핵심 비즈니스 로직

| 파일 | 크기 | 주요 기능 | 상태 |
|------|------|----------|------|
| **auth_service.dart** | 19KB | 사용자 인증, VIP 로그인 경험 | ✅ 최신 |
| **billing_service.dart** | 18KB | 결제 처리, 구독 활성화 | ✅ 최신 |
| **payment_verification_service.dart** | 17KB | 구매 검증 (6단계) | ✅ 최신 |
| **signup_prompt_service.dart** | 4.7KB | 회원가입 유도 (한 번만) | 🆕 신규 |
| **data_migration_service.dart** | 7KB | 데이터 마이그레이션 | ✅ 최신 |

**주요 기능:**
- Firebase Auth 통합
- Google Sign-In
- 프리미엄 구독 관리
- VIP 로그인 경험 (10배 빠른 로딩)
- 회원가입 부드러운 유도

**사용 예시:**
```dart
final authService = AuthService();
await authService.initialize();

// 로그인 시 자동으로 VIP 경험 제공
final result = await authService.signInWithEmail(
  email: 'user@example.com',
  password: 'password',
);

// 현재 구독 확인
final subscription = authService.currentSubscription;
final isPremium = subscription?.type == SubscriptionType.premium;
```

---

### 2️⃣ 클라우드 & 데이터 (5개) ☁️

| 파일 | 크기 | 주요 기능 | 상태 |
|------|------|----------|------|
| **cloud_sync_service.dart** | 49KB | 클라우드 동기화, 데이터 프리로드 | ✅ 최신 |
| database_service.dart | 11KB | 로컬 데이터베이스 | |
| data_backup_service.dart | 17KB | 데이터 백업 | |
| data_service.dart | 9KB | 데이터 관리 | |
| backup_scheduler.dart | 16KB | 백업 스케줄링 | |

**주요 기능:**
- Firestore 동기화
- 오프라인 지원
- 데이터 프리로드 (VIP 기능)
- 자동 백업

**VIP 프리로드 시스템:**
```dart
final cloudSync = CloudSyncService();

// VIP 사용자: 모든 데이터 미리 로드
await cloudSync.preloadAllUserData(userId);

// 즉시 사용 (Firestore 조회 없이)
final workouts = await cloudSync.getPreloadedWorkoutHistory();
final progress = await cloudSync.getPreloadedProgress();
final achievements = await cloudSync.getPreloadedAchievements();
final chadState = await cloudSync.getPreloadedChadState();
```

---

### 3️⃣ Chad Evolution (8개) 💪

캐릭터 진화 시스템

| 파일 | 크기 | 주요 기능 |
|------|------|----------|
| **chad_evolution_service.dart** | 32KB | Chad 진화 시스템 |
| chad_image_service.dart | 13KB | Chad 이미지 관리 |
| chad_level_manager.dart | 14KB | 레벨 관리 |
| chad_condition_service.dart | 8KB | 컨디션 관리 |
| chad_encouragement_service.dart | 5KB | 격려 메시지 |
| chad_recovery_service.dart | 12KB | 회복 관리 |
| chad_active_recovery_service.dart | 16KB | 액티브 회복 |
| chad_onboarding_service.dart | 8KB | 온보딩 |

**Chad Evolution 레벨:**
```
Level 1: 🥚 Chad Egg (시작)
Level 2: 🐣 Beginner Chad
Level 3: 🐥 Growing Chad
Level 4: 🐤 Training Chad
Level 5: 🦅 Fit Chad
Level 6: 💪 Strong Chad
Level 7: 🦾 Muscular Chad
Level 8: 🏋️ Bodybuilder Chad
Level 9: 🏆 Elite Chad (최종)
```

**사용 예시:**
```dart
final chadService = ChadEvolutionService();

// 운동 완료 시 Chad 진화 체크
await chadService.addExperience(pushupCount);

// 현재 Chad 레벨
final level = chadService.currentLevel;
final imagePath = chadService.getCurrentChadImage();
```

---

### 4️⃣ Achievement (5개) 🏆

업적 시스템

| 파일 | 크기 | 주요 기능 | 상태 |
|------|------|----------|------|
| **achievement_service.dart** | 58KB | 업적 관리 (가장 큰 파일) | |
| **achievement_enhancement_service.dart** | 20KB | 업적 강화 | ✅ 최신 |
| achievement_logger.dart | 18KB | 업적 로깅 | |
| achievement_notification_service.dart | 18KB | 알림 | |
| achievement_performance_service.dart | 14KB | 성능 분석 | |

**주요 업적 카테고리:**
- 푸시업 횟수 (10회, 50회, 100회...)
- 연속 기록 (7일, 30일, 100일...)
- 특별 업적 (완벽한 자세, 새벽 운동...)

---

### 5️⃣ 운동 & 프로그램 (5개) 🏋️

| 파일 | 크기 | 주요 기능 |
|------|------|----------|
| workout_history_service.dart | 22KB | 운동 기록 |
| workout_program_service.dart | 17KB | 14주 프로그램 |
| workout_session_service.dart | 4KB | 세션 관리 |
| workout_resumption_service.dart | 7KB | 중단 후 재개 |
| pushup_form_guide_service.dart | 31KB | 자세 가이드 |

**14주 프로그램:**
```
Week 1-2:  초보 (비회원도 가능)
Week 3-6:  중급
Week 7-10: 고급
Week 11-14: 마스터
```

---

### 6️⃣ 알림 시스템 (2개) 🔔

| 파일 | 크기 | 주요 기능 | 상태 |
|------|------|----------|------|
| **notification_service.dart** | 38KB | 로컬 알림 | |
| **fcm_service.dart** | 7KB | 푸시 알림 (Firebase) | ✅ 최신 |

**알림 타입:**
- 운동 리마인더
- 업적 달성
- Chad 진화
- 연속 기록 유지

---

### 7️⃣ 사용자 경험 (11개) ⭐

| 파일 | 크기 | 주요 기능 |
|------|------|----------|
| challenge_service.dart | 29KB | 도전 과제 |
| experience_service.dart | 17KB | 경험치 시스템 |
| progress_tracker_service.dart | 10KB | 진행 추적 |
| streak_service.dart | 15KB | 연속 기록 |
| social_share_service.dart | 19KB | 소셜 공유 |
| pushup_mastery_service.dart | 8KB | 푸시업 마스터 |
| pushup_tutorial_service.dart | 9KB | 튜토리얼 |
| motivational_message_service.dart | 15KB | 동기부여 |
| user_goals_service.dart | 3KB | 목표 설정 |
| adaptive_recovery_service.dart | 17KB | 적응형 회복 |
| rpe_adaptation_service.dart | 9KB | RPE 적응 |

---

### 8️⃣ 기타 서비스 (10개) 🛠️

| 파일 | 크기 | 기능 |
|------|------|------|
| ad_service.dart | 3.6KB | 광고 SDK |
| onboarding_service.dart | 14KB | 온보딩 |
| first_launch_service.dart | 2KB | 첫 실행 |
| deep_link_handler.dart | 9KB | 딥링크 |
| permission_service.dart | 19KB | 권한 관리 |
| theme_service.dart | 12KB | 테마 |
| locale_service.dart | 4KB | 언어 |
| difficulty_service.dart | 3KB | 난이도 |
| multilingual_content_service.dart | 27KB | 다국어 |
| memory_manager.dart | 201B | 메모리 |

---

## 📈 파일 크기 Top 5

1. **achievement_service.dart** - 58KB 🥇
2. **cloud_sync_service.dart** - 49KB 🥈 (VIP 프리로드)
3. **notification_service.dart** - 38KB 🥉
4. **chad_evolution_service.dart** - 32KB
5. **pushup_form_guide_service.dart** - 31KB

---

## 🗑️ Old Archive

**위치:** `lib/services/old_archive/`

더 이상 사용하지 않는 구형 서비스 파일들:

1. `workout_program_service_backup.dart` - 백업 파일
2. `subscription_service.dart` - 구형 구독 시스템
3. `subscription_cancellation_service.dart` - 구형 취소 서비스
4. `subscription_change_service.dart` - 구형 변경 서비스

**상세:** [lib/services/old_archive/README.md](../lib/services/old_archive/README.md)

---

## 🎯 핵심 서비스 플로우

### 앱 시작 시

```
1. first_launch_service - 첫 실행 확인
2. auth_service.initialize() - 인증 초기화
3. permission_service - 권한 요청
4. cloud_sync_service - 동기화 시작
5. notification_service - 알림 설정
6. onboarding_service (첫 실행 시)
```

### VIP 로그인 시

```
1. auth_service.signInWithEmail()
   ↓
2. _onLoginSuccess() 실행
   ├─ 환영 메시지
   ├─ 구독 정보 복원
   ├─ 클라우드 동기화
   ├─ 보류 구매 완료
   └─ 데이터 프리로드 (백그라운드)
       ├─ 운동 기록
       ├─ 진행 상황
       ├─ 업적
       └─ Chad 상태
   ↓
3. 앱 사용 준비 완료 (1초 이내)
```

### 운동 완료 시

```
1. workout_session_service - 세션 종료
2. workout_history_service - 기록 저장
3. achievement_service - 업적 체크
4. chad_evolution_service - 경험치 추가
5. streak_service - 연속 기록 업데이트
6. notification_service - 축하 알림
7. cloud_sync_service - 클라우드 동기화
```

---

## 🔧 서비스 사용 가이드

### Singleton 패턴

대부분의 서비스는 Singleton 패턴을 사용합니다:

```dart
class MyService {
  static final MyService _instance = MyService._internal();
  factory MyService() => _instance;
  MyService._internal();
}

// 사용
final service = MyService(); // 항상 같은 인스턴스
```

### 초기화

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 필수 서비스 초기화
  await Firebase.initializeApp();
  await AuthService().initialize();
  await CloudSyncService().initialize();
  await NotificationService().initialize();

  runApp(MyApp());
}
```

### Provider 통합

```dart
// Provider로 전역 사용
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthService()),
    Provider(create: (_) => CloudSyncService()),
    Provider(create: (_) => AchievementService()),
  ],
  child: MyApp(),
)

// 사용
final authService = Provider.of<AuthService>(context);
final isPremium = authService.currentSubscription?.type == SubscriptionType.premium;
```

---

## ⚠️ 주의사항

### 순환 참조 방지

일부 서비스는 서로 의존합니다. 순환 참조 주의:

```dart
// ❌ 나쁜 예
class AuthService {
  final billingService = BillingService(); // AuthService → BillingService
}

class BillingService {
  final authService = AuthService(); // BillingService → AuthService
}

// ✅ 좋은 예
class AuthService {
  // BillingService 메서드 직접 호출
  void _completePendingPurchases() {
    debugPrint('ℹ️ 보류 중인 구매는 BillingService에서 처리됩니다');
  }
}
```

### 메모리 관리

```dart
// 스트림 정리
@override
void dispose() {
  _streamController.close();
  _subscription?.cancel();
  super.dispose();
}
```

---

## 📚 관련 문서

- [SUBSCRIPTION_STRATEGY_V2.md](SUBSCRIPTION_STRATEGY_V2.md) - 구독 전략
- [VIP_EXPERIENCE_IMPLEMENTATION.md](VIP_EXPERIENCE_IMPLEMENTATION.md) - VIP 기능
- [SECURITY_IMPROVEMENTS.md](SECURITY_IMPROVEMENTS.md) - 보안 강화
- [PURCHASE_MODEL_DECISION.md](PURCHASE_MODEL_DECISION.md) - 구매 모델

---

## 🔍 서비스 찾기

### 인증 관련
→ `auth_service.dart`

### 결제 관련
→ `billing_service.dart`, `payment_verification_service.dart`

### 데이터 동기화
→ `cloud_sync_service.dart`

### 운동 기록
→ `workout_history_service.dart`, `workout_session_service.dart`

### 업적
→ `achievement_service.dart`

### Chad 캐릭터
→ `chad_evolution_service.dart`

### 알림
→ `notification_service.dart`, `fcm_service.dart`

---

**작성일:** 2025-10-28
**작성자:** Claude
**버전:** 1.0
**상태:** ✅ 완료
