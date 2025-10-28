# Mission 100 - 완전한 l10n 관리 시스템

## 📋 목차

1. [문제 정의](#문제-정의)
2. [해결 방안 (3가지 질문에 대한 답변)](#해결-방안)
3. [구현 가이드](#구현-가이드)
4. [워크플로우](#워크플로우)
5. [자동화](#자동화)
6. [FAQ](#faq)

---

## 문제 정의

### 현재 상황
- **ARB 파일 크기**: 7000+줄
- **관리**: 불가능에 가까움
- **협업**: Git 충돌 빈번
- **번역**: 특정 텍스트 찾기 어려움
- **확장성**: 새 기능 추가 시 더욱 복잡해짐

### 왜 지금 개선해야 하는가?
- 앱이 성장하면 번역도 증가
- 지금 구조를 정리하지 않으면 **기술 부채 폭발**
- 다국어 확장 시 (일본어, 중국어 등) 관리 불가능

---

## 해결 방안

### Q1: ARB 파일을 어느 기준으로 분할하는 것이 가장 적합한가?

**답변: 도메인 기반 분리**

```
lib/l10n/source/
├── common/              # 공통 UI (300-400키)
├── workout/             # 운동 프로그램 (500-600키)
├── exercise/            # 운동 종류/자세 (200-300키)
├── achievement/         # 업적 시스템 (300-400키)
├── progress/            # 진행 상황 (150-200키)
├── chad/                # Chad 메시지 (100-150키)
├── onboarding/          # 온보딩 (50-100키)
├── auth/                # 인증 (30-50키)
├── settings/            # 설정 (80-120키)
├── premium/             # 프리미엄 (50-80키)
├── challenge/           # 챌린지 (80-100키)
└── error/               # 에러 (30-50키)
```

**분할 원칙:**
1. **기능 단위**: workout, exercise, achievement
2. **사용자 여정**: onboarding, auth, settings
3. **횡단 관심사**: common, error

**상세 문서**: [l10n_domain_structure.md](l10n_domain_structure.md)

---

### Q2: 세부 카테고리별로 prefix 규칙을 어떻게 정할까?

**답변: `{domain}_{feature}_{element}_{variant}` 패턴**

#### 예시

```json
{
  // Common
  "common_button_save": "저장",
  "common_label_email": "이메일",
  "common_dialog_confirm_title": "확인",

  // Workout
  "workout_session_complete": "세션 완료!",
  "workout_set_progress": "세트 {current}/{total}",
  "workout_rest_timer": "휴식 {seconds}초",

  // Exercise
  "exercise_pushup_name": "푸시업",
  "exercise_pushup_form_start": "시작 자세: 플랭크",
  "exercise_pushup_tip_breathing": "호흡을 잊지 마세요",

  // Achievement
  "achievement_first_workout_name": "첫 걸음",
  "achievement_unlock_title": "업적 달성!",
  "achievement_tier_legendary": "전설",

  // Chad
  "chad_motivation_start": "시작이 반이야! 💪",
  "chad_reaction_awesome": "완벽해!",

  // Error
  "error_network_timeout": "네트워크 연결 시간 초과",
  "error_auth_invalid": "이메일 또는 비밀번호가 잘못되었습니다"
}
```

**장점:**
- ✅ 키 충돌 없음
- ✅ 자동완성 친화적 (IDE에서 `workout_` 입력 시 관련 키 모두 표시)
- ✅ 검색 용이
- ✅ 유지보수 쉬움

**상세 문서**: [l10n_naming_convention.md](l10n_naming_convention.md)

---

### Q3: ChatGPT 번역 자동화로 관리 효율 극대화

**답변: 도메인별 번역 스타일 가이드 + ChatGPT API**

#### 번역 자동화 시스템

```python
# 도메인별 번역 스타일
TRANSLATION_STYLE = {
    'chad': {
        'tone': '동기부여, 친근함, 밈 느낌',
        'style': '반말, 이모지 사용',
        'example_ko': '너 진짜 대단해! 💪',
        'example_en': "You're crushing it! 💪"
    },
    'workout': {
        'tone': '전문적, 명확함',
        'style': '존댓말, 간결함',
        'example_ko': '3세트 10회를 수행하세요',
        'example_en': 'Perform 3 sets of 10 reps'
    }
}
```

#### 사용법

```bash
# 특정 도메인 번역
python tools/auto_translate.py --domain workout --source ko --target en

# 모든 도메인 번역
python tools/auto_translate.py --all --source ko --target en

# 일본어 추가
python tools/auto_translate.py --all --source ko --target ja
```

**자동화 도구**: [auto_translate.py](../tools/auto_translate.py)

---

## 구현 가이드

### 1단계: 기존 ARB 파일 백업

```bash
cd E:\Projects\mission100_v3
python tools/split_arb_files.py
```

**결과:**
- ✅ 백업: `lib/l10n/backup/`
- ✅ 분리: `lib/l10n/source/{domain}/`

### 2단계: 도메인별 파일 생성

```
lib/l10n/source/
├── common/
│   ├── common_ko.arb
│   └── common_en.arb
├── workout/
│   ├── workout_ko.arb
│   └── workout_en.arb
└── ...
```

### 3단계: 병합 스크립트 실행

```bash
python tools/merge_arb_files.py
```

**결과:**
- ✅ `lib/l10n/app_ko.arb` (병합됨)
- ✅ `lib/l10n/app_en.arb` (병합됨)

### 4단계: Flutter 다국어 생성

```bash
flutter gen-l10n
```

### 5단계: 테스트

```bash
flutter run
```

---

## 워크플로우

### 개발자 A: 새로운 운동 프로그램 추가

```bash
# 1. workout 도메인 파일 수정
vim lib/l10n/source/workout/workout_ko.arb

# 추가
{
  "workout_advanced_program_title": "고급 프로그램",
  "@workout_advanced_program_title": {
    "description": "Advanced program title"
  }
}

# 2. 영어 자동 번역
python tools/auto_translate.py --domain workout --source ko --target en

# 3. 빌드
python tools/merge_arb_files.py
flutter gen-l10n

# 4. 코드에서 사용
Text(AppLocalizations.of(context).workout_advanced_program_title)
```

### 개발자 B: 업적 번역 수정 (동시 작업)

```bash
# 1. achievement 도메인 수정
vim lib/l10n/source/achievement/achievement_en.arb

# 2. 빌드
python tools/merge_arb_files.py
flutter gen-l10n
```

**✅ Git 충돌 없음!** (서로 다른 도메인 파일)

---

## 자동화

### Makefile 통합

```makefile
.PHONY: l10n translate build run

# 번역 파일 병합
l10n:
\t@python tools/merge_arb_files.py
\t@flutter gen-l10n

# 자동 번역
translate:
\t@python tools/auto_translate.py --all --source ko --target en

# 빌드 (l10n 자동 포함)
build: l10n
\t@flutter build apk

# 실행 (l10n 자동 포함)
run: l10n
\t@flutter run

# 정리
clean:
\t@flutter clean
\t@rm -f lib/l10n/app_*.arb
```

**사용:**
```bash
make l10n        # 병합 + 다국어 생성
make translate   # 자동 번역
make run         # l10n 빌드 + 앱 실행
make build       # l10n 빌드 + APK 빌드
```

### CI/CD 통합 (GitHub Actions)

```yaml
# .github/workflows/l10n-check.yml
name: L10n Check

on: [push, pull_request]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.x'

      - name: Check missing translations
        run: |
          python tools/check_missing_keys.py

      - name: Verify ARB format
        run: |
          python tools/validate_arb.py
```

---

## FAQ

### Q: 기존 코드 수정이 필요한가요?

**A:** 아니요. `AppLocalizations.of(context).키이름` 방식은 동일합니다.

### Q: 도메인 파일을 직접 수정하지 않고 병합된 파일만 수정하면?

**A:** 다음 병합 시 덮어씌워집니다. **반드시 source/ 디렉토리의 도메인 파일을 수정**하세요.

### Q: 새로운 언어(일본어, 중국어) 추가는?

**A:** 각 도메인에 `{domain}_ja.arb`, `{domain}_zh.arb` 파일 추가 후:
```bash
python tools/auto_translate.py --all --source ko --target ja
python tools/merge_arb_files.py
flutter gen-l10n
```

### Q: ChatGPT API 비용은?

**A:** GPT-4 기준 1000토큰당 $0.03. Mission 100 전체 번역 시 약 $5-10 예상.

### Q: 번역 품질은?

**A:** ChatGPT로 초벌 번역 후 사람이 검토. 약 80-90% 품질로 시작하여 수정.

---

## 효과 비교

| 항목 | 기존 (단일 파일) | 개선 (도메인 분리) |
|------|-----------------|------------------|
| 파일 크기 | 7000줄 | 최대 600줄 |
| 검색 시간 | 5-10분 | 10-30초 |
| Git 충돌 | 빈번 (주 2-3회) | 거의 없음 |
| 번역 작업 | 순차 (1명) | 병렬 (N명) |
| 코드 리뷰 | 힘듦 | 도메인별 리뷰 |
| 유지보수 | 불가능 | 용이 |
| 자동화 | 불가능 | ChatGPT 통합 |

---

## 다음 단계

### 즉시 (1일)
- [x] 기존 ARB 파일 백업
- [x] 도메인별 분리 스크립트 실행
- [x] 병합 테스트
- [ ] 팀원들에게 가이드 공유

### 단기 (1주)
- [ ] 키 네이밍 규칙 적용
- [ ] CI/CD에 l10n 검증 추가
- [ ] Makefile 통합

### 중기 (1개월)
- [ ] ChatGPT 번역 자동화 활성화
- [ ] 일본어/중국어 추가
- [ ] 번역 품질 리뷰 프로세스 구축

### 장기
- [ ] 번역 관리 시스템 도입 (Lokalise, Crowdin)
- [ ] 커뮤니티 기반 번역
- [ ] A/B 테스팅으로 최적 번역 찾기

---

## 관련 문서

- [도메인 구조 상세](l10n_domain_structure.md)
- [키 네이밍 컨벤션](l10n_naming_convention.md)
- [사용 가이드](../lib/l10n/README.md)

---

**이 시스템을 도입하면:**
- ✅ 관리 가능한 l10n 구조
- ✅ 팀 협업 원활
- ✅ 번역 자동화
- ✅ 확장 가능한 아키텍처
- ✅ 기술 부채 최소화

**결론: 지금이 가장 좋은 시점입니다!** 🚀
