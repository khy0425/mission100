# Mission 100 백엔드 대안 시스템 설계

## 🎯 목표
현재 Firebase + Google Play Billing 시스템의 대안을 설계하여 마이그레이션 또는 멀티 플랫폼 확장 시 참고할 수 있는 아키텍처 제공

---

## 🔄 대안 1: Supabase + Stripe

### 개요
오픈소스 Firebase 대안 Supabase와 강력한 결제 플랫폼 Stripe를 조합한 시스템

### 장점
- ✅ **비용 효율성**: Firebase보다 낮은 가격
- ✅ **SQL 데이터베이스**: PostgreSQL 기반으로 복잡한 쿼리 가능
- ✅ **오픈소스**: 자체 호스팅 가능
- ✅ **멀티 플랫폼**: 웹/모바일/데스크톱 통합 결제
- ✅ **구독 관리**: Stripe의 강력한 구독 관리 기능

### 단점
- ⚠️ **학습 곡선**: Firebase보다 복잡
- ⚠️ **Play Store 정책**: Android는 Google Play Billing 필수 (2023년 정책)
- ⚠️ **초기 설정**: 더 많은 설정 작업 필요

---

## 📦 아키텍처 설계

### 1. Supabase 데이터베이스 스키마

#### 1.1 사용자 테이블 (users)
```sql
-- Supabase Auth 자동 생성 테이블 확장
CREATE TABLE public.user_profiles (
  id UUID REFERENCES auth.users PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  display_name TEXT,
  photo_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_login_at TIMESTAMP WITH TIME ZONE,

  -- 통계
  total_workouts INTEGER DEFAULT 0,
  total_xp INTEGER DEFAULT 0,
  current_level INTEGER DEFAULT 1,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,

  -- Chad 시스템
  chad_level INTEGER DEFAULT 1,
  chad_xp INTEGER DEFAULT 0,
  chad_mode TEXT DEFAULT 'normal',

  -- 설정
  settings JSONB DEFAULT '{}',

  CONSTRAINT user_profiles_email_check CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- 인덱스
CREATE INDEX idx_user_profiles_email ON user_profiles(email);
CREATE INDEX idx_user_profiles_created_at ON user_profiles(created_at);
```

#### 1.2 운동 기록 테이블 (workout_records)
```sql
CREATE TABLE public.workout_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE NOT NULL,

  -- 운동 정보
  week INTEGER NOT NULL CHECK (week >= 1 AND week <= 14),
  day INTEGER NOT NULL CHECK (day >= 1 AND day <= 7),
  exercise_name TEXT NOT NULL,

  -- 세트 정보 (JSONB 배열)
  sets JSONB NOT NULL DEFAULT '[]',
  -- 예시: [{"setNumber": 1, "targetReps": 10, "actualReps": 10, "restSeconds": 60, "completed": true}]

  -- 운동 상태
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed', 'skipped', 'failed')),
  started_at TIMESTAMP WITH TIME ZONE,
  completed_at TIMESTAMP WITH TIME ZONE,
  duration_seconds INTEGER,

  -- 메타데이터
  notes TEXT,
  xp_earned INTEGER DEFAULT 0,
  device_info JSONB,

  -- 동기화
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  synced_at TIMESTAMP WITH TIME ZONE,

  CONSTRAINT workout_records_user_week_day_unique UNIQUE (user_id, week, day, exercise_name)
);

-- 인덱스
CREATE INDEX idx_workout_records_user_id ON workout_records(user_id);
CREATE INDEX idx_workout_records_user_week_day ON workout_records(user_id, week, day);
CREATE INDEX idx_workout_records_completed_at ON workout_records(completed_at);
CREATE INDEX idx_workout_records_status ON workout_records(status);
```

#### 1.3 구독 테이블 (subscriptions)
```sql
CREATE TABLE public.subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE NOT NULL UNIQUE,

  -- 구독 정보
  stripe_customer_id TEXT UNIQUE,
  stripe_subscription_id TEXT UNIQUE,
  product_id TEXT NOT NULL, -- 'premium_monthly', 'premium_yearly', 'premium_lifetime'
  status TEXT NOT NULL DEFAULT 'inactive' CHECK (status IN ('active', 'inactive', 'past_due', 'canceled', 'trialing')),

  -- 결제 정보
  current_period_start TIMESTAMP WITH TIME ZONE,
  current_period_end TIMESTAMP WITH TIME ZONE,
  cancel_at_period_end BOOLEAN DEFAULT false,
  canceled_at TIMESTAMP WITH TIME ZONE,

  -- 플랫폼별 정보
  platform TEXT NOT NULL CHECK (platform IN ('web', 'android', 'ios')),
  payment_method TEXT, -- 'stripe', 'google_play', 'apple_pay'

  -- 평생 구독
  is_lifetime BOOLEAN DEFAULT false,

  -- 메타데이터
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 인덱스
CREATE INDEX idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_stripe_customer_id ON subscriptions(stripe_customer_id);
```

#### 1.4 결제 기록 테이블 (payment_history)
```sql
CREATE TABLE public.payment_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE NOT NULL,
  subscription_id UUID REFERENCES subscriptions(id) ON DELETE SET NULL,

  -- 결제 정보
  stripe_payment_intent_id TEXT UNIQUE,
  amount INTEGER NOT NULL, -- cents
  currency TEXT NOT NULL DEFAULT 'usd',
  status TEXT NOT NULL CHECK (status IN ('succeeded', 'pending', 'failed', 'refunded')),

  -- 상품 정보
  product_id TEXT NOT NULL,
  description TEXT,

  -- 메타데이터
  payment_method TEXT,
  receipt_url TEXT,
  metadata JSONB DEFAULT '{}',

  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 인덱스
CREATE INDEX idx_payment_history_user_id ON payment_history(user_id);
CREATE INDEX idx_payment_history_status ON payment_history(status);
CREATE INDEX idx_payment_history_created_at ON payment_history(created_at DESC);
```

#### 1.5 운동 진행 상황 테이블 (workout_progress)
```sql
CREATE TABLE public.workout_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE NOT NULL UNIQUE,

  -- 진행 상황
  current_week INTEGER DEFAULT 1,
  current_day INTEGER DEFAULT 1,
  unlocked_weeks INTEGER[] DEFAULT ARRAY[1],

  -- 완료 기록
  completed_workouts JSONB DEFAULT '[]',
  -- 예시: [{"week": 1, "day": 1, "completedAt": "2025-10-01T10:00:00Z", "xpEarned": 50}]

  -- 통계
  weekly_stats JSONB DEFAULT '{}',
  -- 예시: {"1": {"completed": 5, "skipped": 2, "totalXp": 250}}

  personal_bests JSONB DEFAULT '{}',
  -- 예시: {"pushups": {"reps": 50, "achievedAt": "2025-10-01T10:00:00Z"}}

  -- 연속 기록
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_workout_date DATE,

  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 인덱스
CREATE INDEX idx_workout_progress_user_id ON workout_progress(user_id);
```

#### 1.6 업적 테이블 (achievements)
```sql
CREATE TABLE public.achievements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE NOT NULL,

  -- 업적 정보
  achievement_id TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('workout', 'streak', 'level', 'chad', 'special')),

  -- 진행 상황
  progress INTEGER DEFAULT 0,
  target INTEGER NOT NULL,
  completed BOOLEAN DEFAULT false,
  completed_at TIMESTAMP WITH TIME ZONE,

  -- 보상
  xp_reward INTEGER DEFAULT 0,

  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  CONSTRAINT achievements_user_achievement_unique UNIQUE (user_id, achievement_id)
);

-- 인덱스
CREATE INDEX idx_achievements_user_id ON achievements(user_id);
CREATE INDEX idx_achievements_completed ON achievements(completed);
CREATE INDEX idx_achievements_type ON achievements(type);
```

---

### 2. Supabase Row Level Security (RLS) 정책

#### 2.1 사용자 프로필 보안
```sql
-- 사용자는 자신의 프로필만 읽기/수정 가능
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile"
  ON user_profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON user_profiles FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON user_profiles FOR INSERT
  WITH CHECK (auth.uid() = id);
```

#### 2.2 운동 기록 보안
```sql
ALTER TABLE workout_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own workout records"
  ON workout_records FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own workout records"
  ON workout_records FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own workout records"
  ON workout_records FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own workout records"
  ON workout_records FOR DELETE
  USING (auth.uid() = user_id);
```

#### 2.3 구독 보안 (읽기 전용, 서버만 수정)
```sql
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own subscription"
  ON subscriptions FOR SELECT
  USING (auth.uid() = user_id);

-- 서버 전용 정책 (service_role 키 필요)
CREATE POLICY "Service role can manage subscriptions"
  ON subscriptions FOR ALL
  USING (auth.role() = 'service_role');
```

---

### 3. Supabase Edge Functions (서버리스)

#### 3.1 Stripe Webhook 처리
```typescript
// supabase/functions/stripe-webhook/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import Stripe from 'https://esm.sh/stripe@11.1.0?target=deno'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.7.1'

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') as string, {
  apiVersion: '2022-11-15',
  httpClient: Stripe.createFetchHttpClient(),
})

const supabase = createClient(
  Deno.env.get('SUPABASE_URL') as string,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') as string
)

serve(async (req) => {
  const signature = req.headers.get('stripe-signature')
  const body = await req.text()

  try {
    const event = stripe.webhooks.constructEvent(
      body,
      signature!,
      Deno.env.get('STRIPE_WEBHOOK_SECRET') as string
    )

    switch (event.type) {
      case 'customer.subscription.created':
      case 'customer.subscription.updated':
        await handleSubscriptionUpdate(event.data.object)
        break

      case 'customer.subscription.deleted':
        await handleSubscriptionCancellation(event.data.object)
        break

      case 'invoice.payment_succeeded':
        await handlePaymentSuccess(event.data.object)
        break

      case 'invoice.payment_failed':
        await handlePaymentFailure(event.data.object)
        break
    }

    return new Response(JSON.stringify({ received: true }), {
      headers: { 'Content-Type': 'application/json' },
      status: 200,
    })
  } catch (err) {
    console.error('Webhook error:', err)
    return new Response(JSON.stringify({ error: err.message }), {
      status: 400,
    })
  }
})

async function handleSubscriptionUpdate(subscription: Stripe.Subscription) {
  const { customer, id, status, current_period_start, current_period_end, items } = subscription

  const productId = items.data[0].price.product as string

  await supabase
    .from('subscriptions')
    .upsert({
      stripe_customer_id: customer as string,
      stripe_subscription_id: id,
      product_id: productId,
      status: status,
      current_period_start: new Date(current_period_start * 1000).toISOString(),
      current_period_end: new Date(current_period_end * 1000).toISOString(),
      updated_at: new Date().toISOString(),
    }, {
      onConflict: 'stripe_subscription_id'
    })
}

async function handleSubscriptionCancellation(subscription: Stripe.Subscription) {
  await supabase
    .from('subscriptions')
    .update({
      status: 'canceled',
      canceled_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    })
    .eq('stripe_subscription_id', subscription.id)
}

async function handlePaymentSuccess(invoice: Stripe.Invoice) {
  const { customer, amount_paid, currency, subscription, hosted_invoice_url } = invoice

  await supabase
    .from('payment_history')
    .insert({
      stripe_payment_intent_id: invoice.payment_intent as string,
      amount: amount_paid,
      currency: currency,
      status: 'succeeded',
      receipt_url: hosted_invoice_url,
      created_at: new Date().toISOString(),
    })
}

async function handlePaymentFailure(invoice: Stripe.Invoice) {
  await supabase
    .from('payment_history')
    .insert({
      stripe_payment_intent_id: invoice.payment_intent as string,
      amount: invoice.amount_due,
      currency: invoice.currency,
      status: 'failed',
      created_at: new Date().toISOString(),
    })
}
```

#### 3.2 구독 상태 확인 함수
```typescript
// supabase/functions/check-subscription/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.7.1'

const supabase = createClient(
  Deno.env.get('SUPABASE_URL') as string,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') as string
)

serve(async (req) => {
  try {
    const { userId } = await req.json()

    const { data: subscription, error } = await supabase
      .from('subscriptions')
      .select('*')
      .eq('user_id', userId)
      .single()

    if (error) throw error

    const isPremium = subscription.status === 'active' || subscription.is_lifetime

    return new Response(
      JSON.stringify({
        isPremium,
        subscription,
      }),
      { headers: { 'Content-Type': 'application/json' } }
    )
  } catch (err) {
    return new Response(
      JSON.stringify({ error: err.message }),
      { status: 400 }
    )
  }
})
```

---

### 4. Flutter 클라이언트 구현

#### 4.1 Supabase 클라이언트 설정
```dart
// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  late SupabaseClient client;

  Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://your-project.supabase.co',
      anonKey: 'your-anon-key',
    );
    client = Supabase.instance.client;
  }

  // 인증
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // 프로필
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await client
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .single();
    return response;
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    await client
        .from('user_profiles')
        .update(data)
        .eq('id', userId);
  }

  // 운동 기록
  Future<void> createWorkoutRecord(Map<String, dynamic> record) async {
    await client.from('workout_records').insert(record);
  }

  Future<List<Map<String, dynamic>>> getWorkoutRecords(String userId) async {
    final response = await client
        .from('workout_records')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // 구독
  Future<Map<String, dynamic>?> getSubscription(String userId) async {
    final response = await client
        .from('subscriptions')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    return response;
  }

  // 실시간 구독
  RealtimeChannel subscribeToWorkoutRecords(
    String userId,
    Function(Map<String, dynamic>) onInsert,
  ) {
    return client
        .channel('workout_records')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'workout_records',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) => onInsert(payload.newRecord),
        )
        .subscribe();
  }
}
```

#### 4.2 Stripe 결제 처리
```dart
// lib/services/stripe_payment_service.dart
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StripePaymentService {
  static final StripePaymentService _instance = StripePaymentService._internal();
  factory StripePaymentService() => _instance;
  StripePaymentService._internal();

  final String publishableKey = 'pk_test_...';
  final String serverUrl = 'https://your-project.supabase.co/functions/v1';

  Future<void> initialize() async {
    Stripe.publishableKey = publishableKey;
    await Stripe.instance.applySettings();
  }

  Future<bool> createSubscription({
    required String priceId, // Stripe Price ID
    required String userId,
  }) async {
    try {
      // 1. Create Customer (if needed) and Subscription on server
      final response = await http.post(
        Uri.parse('$serverUrl/create-subscription'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SupabaseService().client.auth.currentSession?.accessToken}',
        },
        body: json.encode({
          'priceId': priceId,
          'userId': userId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create subscription');
      }

      final data = json.decode(response.body);
      final clientSecret = data['clientSecret'] as String;

      // 2. Confirm payment on client
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              // User details
            ),
          ),
        ),
      );

      return true;
    } catch (e) {
      print('Payment error: $e');
      return false;
    }
  }

  Future<bool> cancelSubscription(String subscriptionId) async {
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/cancel-subscription'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SupabaseService().client.auth.currentSession?.accessToken}',
        },
        body: json.encode({
          'subscriptionId': subscriptionId,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Cancellation error: $e');
      return false;
    }
  }
}
```

---

## 🔄 대안 2: AWS + PayPal

### 개요
AWS 클라우드 인프라와 PayPal 결제 시스템 조합

### 장점
- ✅ **확장성**: AWS의 강력한 인프라
- ✅ **글로벌 결제**: PayPal 전 세계 지원
- ✅ **커스터마이징**: 완전한 제어권
- ✅ **엔터프라이즈**: 대규모 서비스 가능

### 단점
- ⚠️ **복잡성**: 높은 기술 요구사항
- ⚠️ **비용**: 초기 비용 높음
- ⚠️ **관리 부담**: 인프라 관리 필요
- ⚠️ **Play Store 정책**: Android는 Google Play Billing 필수

### 아키텍처 개요

```
┌─────────────┐
│ Flutter App │
└──────┬──────┘
       │
       ├─────────────────────┬──────────────────────┐
       │                     │                      │
       ▼                     ▼                      ▼
┌──────────────┐    ┌─────────────────┐    ┌──────────────┐
│ AWS Amplify  │    │ AWS API Gateway │    │    PayPal    │
│   (Auth)     │    │     (REST)      │    │  (Payment)   │
└──────┬───────┘    └────────┬────────┘    └──────┬───────┘
       │                     │                     │
       ▼                     ▼                     ▼
┌──────────────┐    ┌─────────────────┐    ┌──────────────┐
│   Cognito    │    │ Lambda Functions│    │   PayPal     │
│ (User Pool)  │    │   (Business)    │    │     API      │
└──────────────┘    └────────┬────────┘    └──────────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │   DynamoDB /    │
                    │   RDS (Data)    │
                    └─────────────────┘
```

---

## 📊 비용 비교 (월 1만 사용자 기준)

### Firebase + Google Play Billing
| 항목 | 비용 |
|------|------|
| Firestore (읽기/쓰기) | $50 |
| Authentication | $0 (무료) |
| Cloud Functions | $10 |
| Storage | $5 |
| Google Play 수수료 | 15-30% |
| **총 비용** | **$65 + 수수료** |

### Supabase + Stripe
| 항목 | 비용 |
|------|------|
| Supabase Pro | $25 |
| Edge Functions | $10 |
| Storage | $5 |
| Stripe 수수료 | 2.9% + $0.30 |
| **총 비용** | **$40 + 수수료** |

### AWS + PayPal
| 항목 | 비용 |
|------|------|
| EC2 / Lambda | $50 |
| RDS / DynamoDB | $40 |
| S3 Storage | $5 |
| CloudFront | $10 |
| PayPal 수수료 | 2.9% + $0.30 |
| **총 비용** | **$105 + 수수료** |

---

## 🚀 마이그레이션 전략

### Phase 1: 준비 (1-2주)
- [ ] 대안 시스템 선택 (Supabase 권장)
- [ ] 계정 생성 및 프로젝트 설정
- [ ] 스키마 설계 및 검증
- [ ] 테스트 환경 구축

### Phase 2: 병렬 운영 (2-4주)
- [ ] 새 시스템 구현 (읽기 전용)
- [ ] 기존 데이터 마이그레이션 스크립트
- [ ] 데이터 동기화 로직 구현
- [ ] 테스트 사용자 검증

### Phase 3: 점진적 전환 (2-3주)
- [ ] 신규 사용자 새 시스템 사용
- [ ] 기존 사용자 10% → 50% → 100% 전환
- [ ] 모니터링 및 롤백 준비
- [ ] 성능 최적화

### Phase 4: 완전 전환 (1주)
- [ ] Firebase 읽기 전용 전환
- [ ] 모든 쓰기 작업 새 시스템
- [ ] 데이터 일관성 검증
- [ ] Firebase 서비스 종료

---

## 💡 권장사항

### 웹 버전 출시 시
**추천**: Supabase + Stripe
- ✅ 웹/모바일 통합 인증
- ✅ 글로벌 결제 지원
- ✅ 낮은 비용
- ✅ 빠른 개발

### 대규모 엔터프라이즈
**추천**: AWS + Custom
- ✅ 최고 성능
- ✅ 완전한 제어
- ✅ 보안 강화
- ⚠️ 높은 비용

### 모바일 앱만 운영
**추천**: 현재 시스템 유지 (Firebase + Google Play Billing)
- ✅ Play Store 정책 완벽 준수
- ✅ 안정성 검증됨
- ✅ 충분한 성능

---

## 📝 결론

### 현재 시스템 (Firebase)의 장점
1. ✅ **Play Store 완벽 통합**: Google Play Billing 정책 준수
2. ✅ **검증된 안정성**: 프로덕션 레벨 신뢰성
3. ✅ **낮은 유지보수**: 관리형 서비스
4. ✅ **빠른 개발**: Firebase SDK 완성도

### 대안 시스템 고려 시점
1. **웹 버전 출시**: Supabase + Stripe 추천
2. **Firebase 비용 급증**: Supabase 마이그레이션
3. **커스텀 요구사항**: AWS로 이전
4. **글로벌 확장**: Stripe/PayPal 추가

### 최종 권장사항
- **현재 (모바일 전용)**: Firebase + Google Play Billing 유지 ✅
- **웹 확장 시**: Supabase + Stripe 병렬 운영 🔄
- **엔터프라이즈**: 단계적으로 AWS 전환 고려 📈

---

**문서 버전**: 1.0.0
**최종 업데이트**: 2025-10-01
**작성자**: Mission100 개발팀
