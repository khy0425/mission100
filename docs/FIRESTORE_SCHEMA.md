# Firestore 데이터베이스 스키마 설계

## 📋 전체 컬렉션 구조

```
mission100_firestore/
├── users/{userId}                     # 사용자 기본 정보
├── userProfiles/{userId}              # 사용자 프로필 상세
├── subscriptions/{subscriptionId}     # 구독 정보
├── workoutRecords/{recordId}          # 개별 운동 기록
├── workoutProgress/{userId}           # 사용자별 운동 진행 상황
├── userSettings/{userId}              # 사용자 설정
├── achievements/{achievementId}       # 업적 시스템
├── chadProgress/{userId}              # Chad XP 및 진화 진행 상황
└── appMetadata/config                 # 앱 전역 설정
```

---

## 🔧 상세 스키마 정의

### 1. users/{userId}
```typescript
{
  uid: string,                    // Firebase Auth UID
  email: string,                  // 이메일
  displayName: string,            // 표시 이름
  photoURL?: string,              // 프로필 사진 URL
  provider: string,               // 로그인 제공자 (google, email)
  isEmailVerified: boolean,       // 이메일 인증 여부
  createdAt: Timestamp,           // 계정 생성일
  lastLoginAt: Timestamp,         // 마지막 로그인
  status: 'active' | 'suspended' | 'deleted'
}
```

### 2. userProfiles/{userId}
```typescript
{
  userId: string,                 // users 컬렉션 참조
  nickname?: string,              // 사용자 닉네임
  age?: number,                   // 나이
  gender?: 'male' | 'female' | 'other',
  fitnessLevel: 'beginner' | 'intermediate' | 'advanced',
  goals: string[],                // 운동 목표
  preferredWorkoutTime?: string,  // 선호 운동 시간
  timezone: string,               // 시간대
  language: 'ko' | 'en',          // 언어 설정
  onboardingCompleted: boolean,   // 온보딩 완료 여부
  chadPersonality: string,        // Chad 성격 설정
  totalWorkouts: number,          // 총 운동 횟수
  totalPushups: number,           // 총 푸시업 개수
  longestStreak: number,          // 최장 연속 운동 일수
  currentStreak: number,          // 현재 연속 운동 일수
  updatedAt: Timestamp
}
```

### 3. subscriptions/{subscriptionId}
```typescript
{
  id: string,                     // 구독 ID
  userId: string,                 // 사용자 ID
  type: 'free' | 'launchPromo' | 'premium',
  status: 'active' | 'expired' | 'cancelled' | 'trial',
  platform: 'android' | 'ios' | 'web',
  productId: string,              // Google Play/App Store 상품 ID
  purchaseToken?: string,         // 구매 토큰
  orderId?: string,               // 주문 ID
  startDate: Timestamp,           // 구독 시작일
  endDate?: Timestamp,            // 구독 종료일
  renewalDate?: Timestamp,        // 갱신일
  autoRenewal: boolean,           // 자동 갱신 여부
  hasAds: boolean,                // 광고 표시 여부
  allowedWeeks: number,           // 접근 가능 주차
  allowedFeatures: string[],      // 사용 가능 기능
  price?: number,                 // 결제 금액
  currency?: string,              // 통화
  paymentMethod?: string,         // 결제 수단
  createdAt: Timestamp,
  updatedAt: Timestamp,
  cancelledAt?: Timestamp,        // 취소일
  cancellationReason?: string     // 취소 이유
}
```

### 4. workoutRecords/{recordId}
```typescript
{
  id: string,                     // 기록 ID
  userId: string,                 // 사용자 ID
  date: Timestamp,                // 운동 날짜
  week: number,                   // 주차 (1-14)
  day: number,                    // 일차 (1-3)
  exerciseType: 'pushup',         // 운동 종류
  sets: {                         // 세트별 기록
    setNumber: number,
    targetReps: number,           // 목표 횟수
    actualReps: number,           // 실제 횟수
    rpe: number,                  // 체감 강도 (1-10)
    restTime: number,             // 휴식 시간 (초)
    formQuality?: number,         // 폼 품질 (1-10)
    completedAt: Timestamp
  }[],
  totalReps: number,              // 총 횟수
  totalTime: number,              // 총 소요 시간 (초)
  averageRpe: number,             // 평균 RPE
  workoutCompleted: boolean,      // 운동 완료 여부
  chadMessages: string[],         // Chad가 준 메시지들
  deviceInfo?: {                  // 기기 정보
    platform: string,
    version: string,
    model: string
  },
  syncStatus: 'pending' | 'synced' | 'conflict',
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

### 5. workoutProgress/{userId}
```typescript
{
  userId: string,                 // 사용자 ID
  currentWeek: number,            // 현재 주차
  currentDay: number,             // 현재 일차
  unlockedWeeks: number[],        // 해금된 주차들
  completedWorkouts: {            // 완료된 운동들
    week: number,
    day: number,
    completedAt: Timestamp,
    recordId: string
  }[],
  weeklyStats: {                  // 주차별 통계
    week: number,
    totalPushups: number,
    averageRpe: number,
    completionRate: number,       // 완료율 (0-1)
    improvementRate: number       // 향상률
  }[],
  personalBests: {                // 개인 기록
    maxPushupsInSet: number,
    maxPushupsInWorkout: number,
    fastestWorkout: number,       // 초
    lowestAverageRpe: number
  },
  streakData: {                   // 연속 기록
    current: number,
    longest: number,
    lastWorkoutDate: Timestamp
  },
  nextWorkoutDate?: Timestamp,    // 다음 운동 예정일
  lastSyncAt: Timestamp,          // 마지막 동기화 시간
  updatedAt: Timestamp
}
```

### 6. userSettings/{userId}
```typescript
{
  userId: string,                 // 사용자 ID
  notifications: {
    pushEnabled: boolean,         // 푸시 알림 허용
    workoutReminders: boolean,    // 운동 리마인더
    achievementAlerts: boolean,   // 업적 알림
    weeklyReports: boolean,       // 주간 리포트
    reminderTime: string,         // 리마인더 시간 (HH:mm)
    reminderDays: number[]        // 리마인더 요일 (0=일요일)
  },
  appearance: {
    darkMode: boolean,            // 다크 모드
    language: 'ko' | 'en',        // 언어
    chadIntensity: 'mild' | 'normal' | 'intense' // Chad 강도
  },
  privacy: {
    shareProgress: boolean,       // 진행 상황 공유
    analytics: boolean,           // 분석 데이터 수집
    crashReporting: boolean       // 크래시 리포트
  },
  backup: {
    autoBackup: boolean,          // 자동 백업
    backupFrequency: 'daily' | 'weekly' | 'monthly',
    lastBackupAt?: Timestamp
  },
  updatedAt: Timestamp
}
```

### 7. achievements/{achievementId}
```typescript
{
  userId: string,                 // 사용자 ID
  achievementType: string,        // 업적 타입
  title: string,                  // 업적 제목
  description: string,            // 업적 설명
  requirement: {                  // 달성 조건
    type: 'count' | 'streak' | 'time' | 'rpe',
    target: number,
    unit: string
  },
  progress: number,               // 현재 진행도
  completed: boolean,             // 완료 여부
  completedAt?: Timestamp,        // 완료 시간
  rarity: 'common' | 'rare' | 'epic' | 'legendary',
  xpReward: number,               // 경험치 보상
  badgeUrl?: string,              // 뱃지 이미지 URL
  createdAt: Timestamp
}
```

### 8. chadProgress/{userId}
**목적**: Chad XP 및 진화 시스템 진행 상황 추적

```typescript
{
  userId: string,           // 사용자 ID
  experience: number,       // 현재 경험치
  currentLevel: number,     // 현재 레벨
  currentStage: number,     // 현재 진화 단계 인덱스
  totalLevelUps: number,    // 총 레벨업 횟수
  xpProgress: number,       // 현재 레벨에서의 경험치 진행률 (0.0-1.0)
  lastLevelUpAt?: Timestamp, // 마지막 레벨업 시간
  lastUpdatedAt?: Timestamp, // 마지막 업데이트 시간
  syncedAt: Timestamp,      // 마지막 동기화 시간
  updatedAt: Timestamp      // 문서 업데이트 시간
}
```

**보안 규칙**:
- 사용자 본인만 읽기/쓰기 가능
- XP 조작 방지를 위한 검증 필요
- 레벨 감소 방지 로직

**인덱스**:
- `userId + currentLevel + updatedAt`
- `userId + experience`

---

### 9. appMetadata/config
```typescript
{
  version: string,                // 앱 버전
  minSupportedVersion: string,    // 최소 지원 버전
  forceUpdateRequired: boolean,   // 강제 업데이트 필요
  maintenance: {
    enabled: boolean,
    message: string,
    startTime?: Timestamp,
    endTime?: Timestamp
  },
  features: {                     // 기능 플래그
    cloudSync: boolean,
    premiumFeatures: boolean,
    chadAI: boolean,
    socialFeatures: boolean
  },
  pricing: {                      // 가격 정보
    premium: {
      monthly: number,
      yearly: number,
      currency: string
    }
  },
  chadPersonalities: string[],    // 사용 가능한 Chad 성격들
  updatedAt: Timestamp
}
```

---

## 🔐 보안 규칙 (Security Rules)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 사용자는 자신의 데이터만 접근 가능
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    match /userProfiles/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    match /subscriptions/{subscriptionId} {
      allow read, write: if request.auth != null &&
        request.auth.uid == resource.data.userId;
    }

    match /workoutRecords/{recordId} {
      allow read, write: if request.auth != null &&
        request.auth.uid == resource.data.userId;
    }

    match /workoutProgress/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    match /userSettings/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    match /achievements/{achievementId} {
      allow read, write: if request.auth != null &&
        request.auth.uid == resource.data.userId;
    }

    // 앱 메타데이터는 모든 사용자 읽기 가능
    match /appMetadata/{document} {
      allow read: if request.auth != null;
      allow write: if false; // 관리자만 수정 가능
    }
  }
}
```

---

## 📈 인덱스 설정

```javascript
// 복합 인덱스 필요한 쿼리들
Collection: workoutRecords
- userId (Ascending), date (Descending)
- userId (Ascending), week (Ascending), day (Ascending)
- userId (Ascending), syncStatus (Ascending), updatedAt (Descending)

Collection: subscriptions
- userId (Ascending), status (Ascending), endDate (Descending)
- userId (Ascending), createdAt (Descending)

Collection: achievements
- userId (Ascending), completed (Ascending), completedAt (Descending)
- userId (Ascending), achievementType (Ascending)
```

---

## 💾 데이터 크기 추정

### 예상 사용자당 데이터 크기:
- **사용자 정보**: ~2KB
- **운동 기록** (14주 완주): ~50KB
- **설정/진행상황**: ~5KB
- **업적**: ~10KB

**총 사용자당**: ~67KB

### 10,000명 사용자 기준:
- **총 데이터 크기**: ~670MB
- **월간 읽기**: ~100만 회
- **월간 쓰기**: ~50만 회

---

## 🔄 동기화 전략

### 1. 실시간 동기화 대상
- 구독 상태 변경
- 운동 완료 시 즉시 저장

### 2. 배치 동기화 대상
- 설정 변경
- 통계 업데이트

### 3. 충돌 해결 규칙
- **Last Write Wins**: 설정 데이터
- **Merge Strategy**: 운동 기록 (중복 방지)
- **Server Authority**: 구독 상태

이 스키마를 기반으로 다음 단계인 데이터 모델 클래스를 생성하겠습니다.