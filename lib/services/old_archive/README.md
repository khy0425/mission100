# Old Archive - Deprecated Services

## 📅 Archived: 2025-10-28

이 폴더에는 더 이상 사용하지 않는 구형 서비스 파일들이 보관되어 있습니다.

---

## 📂 보관된 파일

### 1. workout_program_service_backup.dart

**이유:** 백업 파일, 현재 `workout_program_service.dart`가 정상 작동 중

**설명:**
- 원본 파일과 24개 차이점 있음
- 백업 목적으로만 보관
- 삭제해도 무방

---

### 2. subscription_management_screen.dart

**이유:** 새로운 구독 시스템에서 별도 관리 화면 불필요

**대체 방법:**
- `subscription_screen.dart`로 직접 이동하여 구독/업그레이드
- 구독 관리는 Google Play Billing이 자동 처리
- 설정 화면에서 구독 상태 확인 가능

**참고:**
- 구형 SubscriptionService, SubscriptionChangeService, SubscriptionCancellationService 사용
- 새 시스템에서는 AuthService가 모든 구독 관리를 처리

---

### 3. subscription_service.dart

**이유:** 새로운 구독 시스템(V2)으로 대체됨

**대체 파일:**
- `lib/models/user_subscription.dart` - 새로운 구독 모델
- `lib/services/auth_service.dart` - 구독 관리 통합
- `lib/services/billing_service.dart` - 결제 처리

**차이점:**
- 구형: SharedPreferences 기반, SubscriptionType enum
- 신형: Firestore 기반, UserSubscription 클래스, 보안 강화

---

### 4. subscription_cancellation_service.dart

**이유:** 새 구독 시스템에서 통합 처리

**대체 방법:**
- Google Play Billing으로 자동 처리
- BillingService에서 취소 감지
- auth_service.dart에서 자동 다운그레이드

---

### 5. subscription_change_service.dart

**이유:** 새 구독 시스템에서 통합 처리

**대체 방법:**
- BillingService.purchaseSubscription()으로 업그레이드
- auth_service.dart에서 자동 갱신 처리
- Firestore에 구독 변경 이력 저장

---

## 🔄 마이그레이션 가이드

### 구형 코드 (Old)

```dart
// subscription_service.dart
final subscriptionService = SubscriptionService();
final isPremium = subscriptionService.isPremium;
```

### 신형 코드 (New)

```dart
// auth_service.dart + user_subscription.dart
final authService = AuthService();
final subscription = authService.currentSubscription;
final isPremium = subscription?.type == SubscriptionType.premium;
```

---

## ⚠️ 주의사항

### 삭제하지 마세요 (아직)

이 파일들은 다음 이유로 당분간 보관합니다:

1. **롤백 가능성**: 새 시스템에 문제 발생 시 복구용
2. **참고 자료**: 기존 로직 확인 필요 시
3. **마이그레이션**: 기존 사용자 데이터 변환 필요 시

### 삭제해도 되는 시점

- [ ] 새 구독 시스템 1개월 이상 안정 운영
- [ ] 모든 사용자 데이터 마이그레이션 완료
- [ ] Google Play Billing 정식 연동 완료
- [ ] 프로덕션 배포 후 3개월 경과

---

## 📊 새로운 구독 시스템 (V2)

### 핵심 철학

> **"쪼잔하지 않게, 관대하게"**

### 주요 변경사항

| 항목 | 구형 | 신형 (V2) |
|------|------|-----------|
| 저장소 | SharedPreferences | Firestore (신뢰) |
| 캐시 | 없음 | SharedPreferences (오프라인) |
| Week 제한 | 비회원 Week 1-2 | **비회원도 Week 1-14** |
| 회원가입 유도 | 없음 | **한 번만 부드럽게** |
| 광고 제거 | 프리미엄 | **프리미엄만** |
| 보안 | 낮음 | **6단계 검증** |

---

## 📚 관련 문서

- [docs/SUBSCRIPTION_STRATEGY_V2.md](../../../../docs/SUBSCRIPTION_STRATEGY_V2.md) - 새 구독 전략
- [docs/VIP_EXPERIENCE_IMPLEMENTATION.md](../../../../docs/VIP_EXPERIENCE_IMPLEMENTATION.md) - VIP 기능
- [docs/SECURITY_IMPROVEMENTS.md](../../../../docs/SECURITY_IMPROVEMENTS.md) - 보안 강화

---

**보관 일자:** 2025-10-28
**보관자:** Claude
**복구 방법:** 이 폴더에서 `lib/services`로 복사
