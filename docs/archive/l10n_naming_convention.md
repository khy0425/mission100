# Mission 100 - l10n 키 네이밍 컨벤션

## 🎯 기본 원칙

```
{domain}_{feature}_{element}_{variant}
```

### 예시
```
workout_pushup_desc          # 운동_푸시업_설명
achievement_unlock_title     # 업적_잠금해제_제목
error_network_timeout        # 에러_네트워크_타임아웃
common_button_save           # 공통_버튼_저장
```

---

## 📋 도메인별 Prefix 규칙

### 1. Common (공통 UI)
```
common_button_*           # 버튼
common_label_*            # 라벨
common_message_*          # 메시지
common_dialog_*           # 다이얼로그
common_snackbar_*         # 스낵바
```

**예시:**
```json
{
  "common_button_save": "저장",
  "common_button_cancel": "취소",
  "common_button_delete": "삭제",
  "common_label_email": "이메일",
  "common_message_success": "성공적으로 저장되었습니다",
  "common_dialog_confirm_title": "확인",
  "common_dialog_confirm_desc": "정말로 삭제하시겠습니까?"
}
```

---

### 2. Workout (운동 프로그램)
```
workout_program_*         # 프로그램
workout_week_{n}_*        # 주차별
workout_day_{n}_*         # 일차별
workout_session_*         # 세션
workout_set_*             # 세트
workout_rest_*            # 휴식
workout_rpe_*             # RPE
```

**예시:**
```json
{
  "workout_program_title": "14주 프로그램",
  "workout_week_1_title": "1주차: 기초 체력",
  "workout_day_1_desc": "첫 번째 운동일",
  "workout_session_complete": "세션 완료!",
  "workout_set_current": "현재 세트: {current}/{total}",
  "workout_rest_timer": "휴식 시간: {seconds}초",
  "workout_rpe_question": "운동 강도는 어떠셨나요?"
}
```

---

### 3. Exercise (운동 종류/자세)
```
exercise_{type}_*         # 운동 종류 (pushup, pullup, squat)
exercise_{type}_form_*    # 자세
exercise_{type}_tip_*     # 팁
exercise_{type}_variant_* # 변형
```

**예시:**
```json
{
  "exercise_pushup_name": "푸시업",
  "exercise_pushup_desc": "가슴과 삼두근을 강화하는 운동",
  "exercise_pushup_form_start": "시작 자세: 플랭크 포지션",
  "exercise_pushup_form_down": "몸을 천천히 내립니다",
  "exercise_pushup_tip_breathing": "내려갈 때 숨을 들이마시세요",
  "exercise_pushup_variant_incline": "인클라인 푸시업",
  "exercise_pushup_variant_diamond": "다이아몬드 푸시업"
}
```

---

### 4. Achievement (업적)
```
achievement_{id}_*        # 업적별
achievement_unlock_*      # 잠금 해제
achievement_progress_*    # 진행 상황
achievement_reward_*      # 보상
achievement_tier_*        # 등급 (common, rare, epic, legendary)
```

**예시:**
```json
{
  "achievement_first_workout_name": "첫 걸음",
  "achievement_first_workout_desc": "첫 번째 운동 완료",
  "achievement_100_pushups_name": "백 푸시업",
  "achievement_100_pushups_desc": "한 세션에 100회 달성",
  "achievement_unlock_title": "업적 달성!",
  "achievement_unlock_message": "{name}을(를) 달성했습니다",
  "achievement_progress_current": "진행: {current}/{target}",
  "achievement_reward_xp": "경험치 +{xp}",
  "achievement_tier_common": "일반",
  "achievement_tier_legendary": "전설"
}
```

---

### 5. Progress (진행 상황/통계)
```
progress_stats_*          # 통계
progress_graph_*          # 그래프
progress_history_*        # 히스토리
progress_streak_*         # 연속 기록
progress_level_*          # 레벨
```

**예시:**
```json
{
  "progress_stats_total_workouts": "총 운동 횟수",
  "progress_stats_total_reps": "총 반복 횟수",
  "progress_stats_avg_rpe": "평균 RPE",
  "progress_graph_weekly": "주간 그래프",
  "progress_graph_monthly": "월간 그래프",
  "progress_history_title": "운동 기록",
  "progress_streak_current": "현재 연속: {days}일",
  "progress_streak_best": "최고 연속: {days}일",
  "progress_level_current": "레벨 {level}"
}
```

---

### 6. Chad (동기부여 메시지)
```
chad_motivation_*         # 동기부여
chad_advice_*             # 조언
chad_tip_*                # 팁
chad_reaction_*           # 반응 (good, great, awesome)
chad_legendary_*          # 레전더리 모드
```

**예시:**
```json
{
  "chad_motivation_start": "시작이 반이야! 💪",
  "chad_motivation_progress": "벌써 {percent}% 완료했어!",
  "chad_advice_rest": "휴식도 훈련의 일부야",
  "chad_advice_form": "자세가 가장 중요해",
  "chad_tip_breathing": "호흡을 잊지 마",
  "chad_reaction_good": "좋아!",
  "chad_reaction_great": "훌륭해!",
  "chad_reaction_awesome": "완벽해!",
  "chad_legendary_mode_title": "레전더리 모드",
  "chad_legendary_mode_desc": "한계를 넘어서는 순간"
}
```

---

### 7. Onboarding (온보딩)
```
onboarding_welcome_*      # 환영
onboarding_step_{n}_*     # 단계별
onboarding_test_*         # 레벨 테스트
onboarding_goal_*         # 목표 설정
```

**예시:**
```json
{
  "onboarding_welcome_title": "Mission 100에 오신 것을 환영합니다",
  "onboarding_welcome_subtitle": "14주 만에 100개 달성",
  "onboarding_step_1_title": "레벨 테스트",
  "onboarding_step_1_desc": "현재 레벨을 측정합니다",
  "onboarding_step_2_title": "목표 설정",
  "onboarding_test_ready": "준비되셨나요?",
  "onboarding_test_start": "테스트 시작",
  "onboarding_goal_select": "목표를 선택하세요"
}
```

---

### 8. Auth (인증)
```
auth_login_*              # 로그인
auth_signup_*             # 회원가입
auth_guest_*              # 게스트
auth_email_*              # 이메일
auth_password_*           # 비밀번호
auth_google_*             # Google 로그인
```

**예시:**
```json
{
  "auth_login_title": "로그인",
  "auth_login_button": "로그인",
  "auth_signup_title": "회원가입",
  "auth_signup_button": "가입하기",
  "auth_guest_button": "게스트로 시작",
  "auth_email_label": "이메일",
  "auth_email_hint": "example@email.com",
  "auth_password_label": "비밀번호",
  "auth_password_hint": "8자 이상",
  "auth_google_button": "Google로 로그인"
}
```

---

### 9. Settings (설정)
```
settings_general_*        # 일반
settings_theme_*          # 테마
settings_language_*       # 언어
settings_notification_*   # 알림
settings_data_*           # 데이터
settings_account_*        # 계정
```

**예시:**
```json
{
  "settings_general_title": "일반 설정",
  "settings_theme_title": "테마",
  "settings_theme_light": "라이트 모드",
  "settings_theme_dark": "다크 모드",
  "settings_theme_system": "시스템 설정",
  "settings_language_title": "언어",
  "settings_language_ko": "한국어",
  "settings_language_en": "English",
  "settings_notification_title": "알림 설정",
  "settings_notification_workout": "운동 알림",
  "settings_data_backup": "데이터 백업",
  "settings_data_restore": "데이터 복원",
  "settings_account_info": "계정 정보"
}
```

---

### 10. Premium (프리미엄/구독)
```
premium_plan_*            # 플랜
premium_feature_*         # 기능
premium_upgrade_*         # 업그레이드
premium_billing_*         # 결제
```

**예시:**
```json
{
  "premium_plan_free": "무료",
  "premium_plan_monthly": "월간",
  "premium_plan_yearly": "연간",
  "premium_plan_lifetime": "평생",
  "premium_feature_unlock": "프리미엄 기능 잠금 해제",
  "premium_feature_ads_free": "광고 제거",
  "premium_feature_advanced_stats": "고급 통계",
  "premium_upgrade_button": "업그레이드",
  "premium_upgrade_desc": "더 많은 기능을 경험하세요",
  "premium_billing_monthly_price": "월 {price}원"
}
```

---

### 11. Challenge (챌린지)
```
challenge_{id}_*          # 챌린지별
challenge_active_*        # 진행 중
challenge_complete_*      # 완료
challenge_leaderboard_*   # 리더보드
```

**예시:**
```json
{
  "challenge_30day_name": "30일 챌린지",
  "challenge_30day_desc": "30일 연속 운동",
  "challenge_100day_name": "100일 챌린지",
  "challenge_active_title": "진행 중인 챌린지",
  "challenge_complete_title": "완료한 챌린지",
  "challenge_leaderboard_title": "리더보드",
  "challenge_leaderboard_rank": "{rank}위"
}
```

---

### 12. Error (에러 메시지)
```
error_network_*           # 네트워크
error_auth_*              # 인증
error_permission_*        # 권한
error_validation_*        # 유효성 검사
error_unknown_*           # 알 수 없는 오류
```

**예시:**
```json
{
  "error_network_timeout": "네트워크 연결 시간 초과",
  "error_network_unavailable": "인터넷에 연결되어 있지 않습니다",
  "error_auth_invalid": "이메일 또는 비밀번호가 잘못되었습니다",
  "error_auth_expired": "세션이 만료되었습니다",
  "error_permission_denied": "권한이 거부되었습니다",
  "error_permission_camera": "카메라 접근 권한이 필요합니다",
  "error_validation_required": "필수 입력 항목입니다",
  "error_validation_email": "올바른 이메일 형식이 아닙니다",
  "error_unknown_title": "오류 발생",
  "error_unknown_desc": "알 수 없는 오류가 발생했습니다"
}
```

---

## 🎨 특수 케이스

### 1. 파라미터가 있는 텍스트
```json
{
  "workout_set_progress": "세트 {current}/{total}",
  "achievement_unlock_message": "{name}을(를) 달성했습니다!",
  "progress_streak_current": "현재 연속: {days}일"
}
```

### 2. 복수형
```json
{
  "common_day_singular": "일",
  "common_day_plural": "일들",
  "common_week_singular": "주",
  "common_week_plural": "주들"
}
```

### 3. 긴 텍스트 (여러 줄)
```json
{
  "onboarding_welcome_long_desc": "Mission 100은 과학적으로 검증된 14주 프로그램입니다.\n\n매주 체계적으로 증가하는 운동량으로\n안전하게 100개 푸시업을 달성할 수 있습니다."
}
```

---

## ✅ 체크리스트

### 새 키 추가 시
- [ ] 적절한 도메인 선택 (common, workout, achievement 등)
- [ ] Prefix 규칙 준수
- [ ] 명확하고 설명적인 이름
- [ ] 영어/한글 동시 추가
- [ ] 파라미터 사용 시 일관성 유지
- [ ] @ 메타데이터에 설명 추가

### 예시
```json
{
  "workout_pushup_form_chest_down": "가슴이 바닥에 닿을 때까지 내립니다",
  "@workout_pushup_form_chest_down": {
    "description": "푸시업 하강 동작 설명"
  }
}
```

---

## 🚫 피해야 할 패턴

### ❌ 나쁜 예
```json
{
  "text1": "저장",                    // 의미 없는 이름
  "save": "저장",                     // 도메인 없음
  "SaveButton": "저장",               // PascalCase (X)
  "save_button": "저장",              // 도메인 prefix 없음
  "commonButtonSave": "저장"          // camelCase (X)
}
```

### ✅ 좋은 예
```json
{
  "common_button_save": "저장",
  "@common_button_save": {
    "description": "Save button text"
  }
}
```

---

## 📚 요약

| 도메인 | Prefix | 예시 키 |
|--------|--------|---------|
| Common | `common_` | `common_button_save` |
| Workout | `workout_` | `workout_session_complete` |
| Exercise | `exercise_` | `exercise_pushup_desc` |
| Achievement | `achievement_` | `achievement_unlock_title` |
| Progress | `progress_` | `progress_stats_total` |
| Chad | `chad_` | `chad_motivation_start` |
| Onboarding | `onboarding_` | `onboarding_welcome_title` |
| Auth | `auth_` | `auth_login_button` |
| Settings | `settings_` | `settings_theme_dark` |
| Premium | `premium_` | `premium_upgrade_button` |
| Challenge | `challenge_` | `challenge_active_title` |
| Error | `error_` | `error_network_timeout` |

---

**이 컨벤션을 따르면:**
- ✅ 키 충돌 없음
- ✅ 검색 용이
- ✅ 자동완성 친화적
- ✅ 유지보수 쉬움
