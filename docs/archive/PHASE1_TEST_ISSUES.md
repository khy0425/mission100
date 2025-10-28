# Phase 1 테스트 발견 이슈

## 🔴 Critical Issues (치명적)

### Issue #1: 데이터베이스 스키마 에러 ✅ 해결됨
**증상**:
```
ERROR: DatabaseException(table user_profile has no column named current_weight)
```

**원인**: `user_profile` 테이블에 12개 컬럼 누락

**해결**:
- ✅ 데이터베이스 스키마 v2 → v3 업그레이드
- ✅ 12개 컬럼 추가 완료
- ✅ 마이그레이션 코드 추가

**파일**: `lib/services/database_service.dart`

---

## 🟠 High Priority Issues (높은 우선순위)

### Issue #2: 온보딩 화면 텍스트 오버플로우 ❌ 미해결
**스크린샷**: 첫 번째 이미지
**증상**:
- "BOTTOM OVERFLOWED BY 651 PIXELS" 에러 메시지가 빨간색으로 표시됨
- 온보딩 화면 레이아웃이 화면을 벗어남

**원인**:
- 온보딩 화면의 Column 높이가 화면 크기를 초과
- SingleChildScrollView 미사용 또는 높이 제약 없음

**해결 필요**:
- [ ] `lib/screens/onboarding/onboarding_screen.dart` 확인
- [ ] Column을 SingleChildScrollView로 감싸기
- [ ] 또는 Expanded/Flexible 사용하여 공간 분배

---

### Issue #3: 앱 전체 색상 테마 불일치 ❌ 미해결
**스크린샷**: 세 번째 이미지 (홈 화면)
**증상**:
- 파란색 카드 "Chad 최확 분석" (스코어 75)
- 이 색감이 앱의 전반적인 느낌과 이질적임

**현재 색상**:
- 파란색 계열 (#4DABF7 등)
- 노란색/주황색 계열 (Mission 100 브랜딩)

**문제점**:
- 홈 화면의 파란색 카드가 앱의 주 색상(주황색/노란색)과 충돌
- 브랜딩 일관성 부족

**해결 필요**:
- [ ] 앱의 주요 브랜드 컬러 정의 필요
- [ ] 모든 화면에 일관된 색상 팔레트 적용
- [ ] 홈 화면 카드 색상 변경

**추천 방향**:
1. **Option A**: Mission 100 브랜딩 강화 (주황색/노란색 계열)
2. **Option B**: 다크 테마 강화 (검정/회색 + 포인트 컬러)
3. **Option C**: 기존 파란색 유지하되 통일감 있게 전체 적용

---

### Issue #4: 로케일 자동 감지 오류 ✅ 해결됨
**스크린샷**: 첫 번째, 두 번째 이미지
**증상**:
- Android 에뮬레이터는 영어 설정 (시스템 언어: English)
- 앱 일부 화면이 한글로 표시됨 ("Chad가 말해요", "오늘의 컨디션을 선택해주세요")

**원인**:
- `LocaleService`는 올바르게 영어를 감지했으나, UI 위젯들이 하드코딩된 한글 문자열 사용
- `ChadConditionWidget`에 하드코딩된 한글 문자열 다수 발견

**해결**:
- ✅ `lib/l10n/app_ko.arb`에 다음 키 추가:
  - `chadSays`: "Chad가 말해요" / "Chad says"
  - `selectCondition`: "오늘의 컨디션을 선택해주세요" / "Please select today's condition"
  - `todayCondition`: "오늘 컨디션: " / "Today's condition: "
  - `chadRecommendedWorkout`: "🎯 Chad 추천 운동" / "🎯 Chad's Recommendation"
  - `recheckCondition`: "컨디션 다시 체크" / "Recheck Condition"
  - `conditionVeryTired`, `conditionGood`, `conditionStrong`, `conditionSweaty`, `conditionOnFire`
  - `conditionConfirmed`, `conditionRecheckAvailable`
- ✅ `lib/l10n/app_en.arb`에 영어 번역 추가
- ✅ `ChadConditionWidget`에 `ChadConditionLocalization` extension 추가
- ✅ 모든 하드코딩 문자열을 `AppLocalizations.of(context)` 사용으로 변경
- ✅ `flutter gen-l10n` 실행하여 localization 파일 재생성

**기대 동작**:
```dart
// 에뮬레이터 언어: English
// → 앱 언어: English
// "Chad says" / "Please select today's condition"
```

---

### Issue #5: 앱 아이콘 불일치 ❌ 미해결
**스크린샷**: 두 번째 이미지
**증상**:
- 상단 헤더에 덤벨 드는 사람 아이콘 표시
- 이 아이콘이 푸시업 앱과 맞지 않음

**문제점**:
- 덤벨 = 헬스장/역기 운동 연상
- 푸시업 = 맨몸 운동

**해결 필요**:
- [ ] 아이콘을 푸시업 관련으로 변경
- [ ] 옵션: 팔굽혀펴기 포즈, 플랭크 자세, 또는 Chad 캐릭터

---

## 🟡 Medium Priority Issues (중간 우선순위)

### Issue #6: 홈 화면 레이아웃 확인 필요
**스크린샷**: 세 번째 이미지
**관찰사항**:
- "ALPHA EMPEROR ..." 타이틀이 잘림
- 이모지 카드들의 용도가 불명확
- "Chad 최확 분석" 텍스트 오타 가능성? ("최확" → "최적"?)

**확인 필요**:
- [ ] 타이틀 전체 텍스트 확인
- [ ] 이모지 카드 기능 확인
- [ ] 텍스트 오타 확인

---

## 📋 해결 우선순위

1. **🔴 Issue #1**: ✅ 해결됨
2. **🟠 Issue #4**: 로케일 감지 (가장 기본적인 UX)
3. **🟠 Issue #3**: 색상 테마 통일 (브랜딩)
4. **🟠 Issue #2**: 온보딩 오버플로우 (첫 인상)
5. **🟠 Issue #5**: 아이콘 변경 (브랜딩)
6. **🟡 Issue #6**: 홈 화면 개선

---

## 🎯 다음 액션

### 즉시 해결:
1. ✅ ~~데이터베이스 스키마 수정~~ (완료)
2. 🔄 **로케일 감지 수정** (진행 중)
3. 🔄 **색상 테마 정의 및 적용** (진행 중)

### 사용자 확인 필요:
- 원하는 앱 색상 테마는? (주황/노랑 vs 파랑 vs 다크)
- "Chad 최확 분석" → "Chad 최적 분석"? (오타 확인)

---

**작성일**: 2025-10-25
**테스트 디바이스**: Android Emulator (English)
**앱 버전**: 2.1.0+9
