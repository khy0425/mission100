# Mission100 Cloud Functions

Firebase Cloud Functions for Mission100 App

## 📋 Functions

### 1. **verifyPurchase** (HTTP Trigger)
IAP 결제 검증 함수

**Endpoint**: `https://asia-northeast3-mission100-app.cloudfunctions.net/verifyPurchase`

**Request**:
```json
{
  "userId": "user123",
  "packageName": "com.mission100.app",
  "productId": "premium_monthly",
  "purchaseToken": "aebfdk..."
}
```

**Response**:
```json
{
  "success": true,
  "verified": true,
  "expiryTime": "2025-11-01T00:00:00Z"
}
```

---

### 2. **sendWorkoutReminders** (Scheduled)
일일 운동 알림 (매일 오전 8시 KST)

**동작**:
- 알림 설정이 활성화된 모든 사용자 조회
- 오늘 운동 안 한 사용자에게 FCM 푸시 전송

---

### 3. **onUserLevelUp** (Firestore Trigger)
Chad 레벨업 이벤트

**트리거**: `chadProgress/{userId}` 문서 변경
**동작**: 레벨업 시 축하 알림 전송

---

### 4. **onAchievementUnlocked** (Firestore Trigger)
업적 달성 이벤트

**트리거**: `achievements/{achievementId}` 문서 변경
**동작**: 업적 달성 시 축하 알림 전송

---

### 5. **sendStreakWarnings** (Scheduled)
스트릭 위험 알림 (매일 오후 9시 KST)

**동작**:
- 스트릭이 있는 사용자 중 오늘 운동 안 한 사람에게 경고 알림

---

## 🚀 배포 방법

### 1. 의존성 설치
```bash
cd functions
npm install
```

### 2. 서비스 계정 키 다운로드
```
Firebase Console → Project Settings → Service Accounts
→ Generate New Private Key
→ 저장: functions/service-account-key.json
```

### 3. 배포
```bash
# 모든 함수 배포
firebase deploy --only functions

# 특정 함수만 배포
firebase deploy --only functions:verifyPurchase
firebase deploy --only functions:sendWorkoutReminders
```

### 4. 로그 확인
```bash
firebase functions:log
```

---

## 🔐 환경 변수

필요한 경우 Firebase Functions Config 사용:

```bash
# 설정
firebase functions:config:set google.key="YOUR_API_KEY"

# 확인
firebase functions:config:get

# 적용 (재배포 필요)
firebase deploy --only functions
```

---

## 🧪 로컬 테스트

### Emulator 실행
```bash
cd functions
npm run serve
```

### HTTP 함수 테스트
```bash
curl -X POST http://localhost:5001/mission100-app/asia-northeast3/verifyPurchase \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test123",
    "packageName": "com.mission100.app",
    "productId": "premium_monthly",
    "purchaseToken": "test_token"
  }'
```

---

## 📊 모니터링

### Firebase Console
```
https://console.firebase.google.com/
→ Functions
→ Logs / Metrics
```

### Cloud Logging
```
https://console.cloud.google.com/logs
→ Filter: resource.type="cloud_function"
```

---

## 🔧 문제 해결

### Error: Permission denied
```bash
# Firebase 재로그인
firebase login --reauth

# 프로젝트 확인
firebase use --list
firebase use mission100-app
```

### Error: Node version mismatch
```bash
# package.json의 engines.node 확인
# Node.js 18 사용 권장
nvm use 18
```

### Error: Deployment failed
```bash
# 로그 확인
firebase functions:log

# 재배포
firebase deploy --only functions --force
```

---

## 📝 변경 이력

### v1.0.0 (2025-10-02)
- ✅ IAP 결제 검증 함수
- ✅ 일일 운동 알림 스케줄링
- ✅ Chad 레벨업 이벤트
- ✅ 업적 달성 이벤트
- ✅ 스트릭 위험 알림

---

**마지막 업데이트**: 2025-10-02
