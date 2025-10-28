# ARB 파일 관리 개선 방안

## 문제점
- `app_en.arb`와 `app_ko.arb` 파일이 각각 7000줄 이상으로 관리가 어려움
- 특정 텍스트를 찾기 어렵고, 번역 관리가 복잡함
- Git 충돌이 자주 발생할 가능성

## 해결 방안

### 방안 1: 카테고리별 ARB 파일 분리 (권장)

Flutter는 여러 ARB 파일을 자동으로 병합할 수 있습니다.

#### 1단계: ARB 파일을 카테고리별로 분리

```
lib/l10n/
├── app_en.arb                    # 기본/공통 텍스트
├── app_ko.arb
├── achievements_en.arb           # 업적 관련
├── achievements_ko.arb
├── workouts_en.arb               # 운동 관련
├── workouts_ko.arb
├── onboarding_en.arb             # 온보딩 관련
├── onboarding_ko.arb
├── settings_en.arb               # 설정 관련
├── settings_ko.arb
├── premium_en.arb                # 프리미엄 기능
├── premium_ko.arb
└── chad_en.arb                   # Chad 메시지
└── chad_ko.arb
```

#### 2단계: l10n.yaml 설정 수정

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
synthetic-package: false
# 여러 ARB 파일 자동 병합
untranslated-messages-file: untranslated.json
```

#### 3단계: Python 스크립트로 ARB 파일 분리

```python
# tools/split_arb_files.py
import json

# 카테고리 정의 (키 패턴으로 분류)
categories = {
    'achievements': ['achievement', 'unlock', 'badge', 'milestone'],
    'workouts': ['workout', 'exercise', 'set', 'rep', 'rpe'],
    'onboarding': ['onboarding', 'welcome', 'getStarted'],
    'settings': ['settings', 'theme', 'language', 'notification'],
    'premium': ['premium', 'subscription', 'billing'],
    'chad': ['chad', 'tip', 'motivation']
}

def split_arb_file(input_file, output_prefix, lang):
    with open(input_file, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # 각 카테고리별로 데이터 분리
    categorized = {cat: {} for cat in categories}
    common = {}

    for key, value in data.items():
        # @ 메타데이터도 함께 처리
        base_key = key.lstrip('@')

        # 카테고리 매칭
        matched = False
        for category, patterns in categories.items():
            if any(pattern in base_key.lower() for pattern in patterns):
                categorized[category][key] = value
                matched = True
                break

        if not matched:
            common[key] = value

    # 각 카테고리별 파일 저장
    for category, content in categorized.items():
        if content:
            output_file = f'lib/l10n/{category}_{lang}.arb'
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(content, f, ensure_ascii=False, indent=2)
            print(f'Created {output_file} with {len(content)} entries')

    # 공통 파일 저장
    output_file = f'lib/l10n/app_{lang}.arb'
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(common, f, ensure_ascii=False, indent=2)
    print(f'Created {output_file} with {len(common)} entries')

# 실행
split_arb_file('lib/l10n/app_en.arb', 'lib/l10n', 'en')
split_arb_file('lib/l10n/app_ko.arb', 'lib/l10n', 'ko')
```

#### 장점
- 각 파일이 500-1000줄 정도로 관리하기 쉬움
- 카테고리별로 번역 작업 가능
- Git 충돌 최소화
- 특정 기능의 텍스트를 쉽게 찾을 수 있음

#### 단점
- 초기 분리 작업 필요
- 파일 개수 증가

---

### 방안 2: JSON 스키마 + 빌드 스크립트

ARB 파일을 YAML이나 여러 JSON 파일로 관리하고, 빌드 시 자동 병합

#### 구조

```
lib/l10n/source/
├── common/
│   ├── buttons_en.json
│   ├── buttons_ko.json
│   ├── errors_en.json
│   └── errors_ko.json
├── features/
│   ├── achievements_en.json
│   ├── achievements_ko.json
│   ├── workouts_en.json
│   └── workouts_ko.json
└── build_arb.py  # 병합 스크립트
```

#### 빌드 스크립트

```python
# lib/l10n/build_arb.py
import json
import glob
from pathlib import Path

def merge_json_to_arb(source_dir, output_file, lang):
    merged = {}

    # 모든 JSON 파일 읽기
    pattern = f'{source_dir}/**/*_{lang}.json'
    for file_path in glob.glob(pattern, recursive=True):
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
            merged.update(data)

    # ARB 파일로 저장
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(merged, f, ensure_ascii=False, indent=2)

    print(f'Merged {len(merged)} entries into {output_file}')

# 빌드 시 실행
merge_json_to_arb('lib/l10n/source', 'lib/l10n/app_en.arb', 'en')
merge_json_to_arb('lib/l10n/source', 'lib/l10n/app_ko.arb', 'ko')
```

#### pubspec.yaml에 빌드 스크립트 추가

```yaml
# pubspec.yaml
scripts:
  build_l10n:
    - python lib/l10n/build_arb.py
    - flutter gen-l10n
```

---

### 방안 3: IDE 플러그인 활용 (가장 간단)

VSCode나 Android Studio의 Flutter Intl 플러그인 사용

#### 설정

1. **Flutter Intl 플러그인 설치**
2. **Command Palette** → `Flutter Intl: Initialize`
3. 플러그인이 자동으로 ARB 파일을 관리하고 UI 제공

#### 장점
- 코드 변경 없이 즉시 적용 가능
- UI로 번역 관리
- 자동 완성 및 오류 체크

#### 단점
- 플러그인 의존성

---

## 권장 사항

**단계적 적용:**

1. **단기 (즉시 적용 가능)**:
   - IDE 플러그인 사용으로 검색/필터링 개선
   - 주석 추가로 섹션 구분

2. **중기 (1-2주)**:
   - 방안 1 적용: 카테고리별 ARB 파일 분리
   - Python 스크립트로 자동 분리/병합

3. **장기**:
   - 번역 관리 시스템 도입 (Lokalise, Crowdin 등)
   - CI/CD 파이프라인에 번역 검증 추가

---

## 현재 ARB 파일 주석으로 구분하기 (임시 방안)

최소한 주석으로 섹션을 구분하여 가독성을 높일 수 있습니다:

```json
{
  "@@_COMMON": "=== 공통 텍스트 ===",
  "appName": "Mission 100",

  "@@_BUTTONS": "=== 버튼 ===",
  "next": "Next",
  "skip": "Skip",

  "@@_ACHIEVEMENTS": "=== 업적 ===",
  "achievementUnlocked": "Achievement Unlocked!",

  "@@_WORKOUTS": "=== 운동 ===",
  "workoutComplete": "Workout Complete"
}
```

주석은 `@@_`로 시작하면 Flutter gen-l10n이 무시합니다.

---

## 실행 예시

```bash
# ARB 파일 분리
python tools/split_arb_files.py

# 다국어 파일 생성
flutter gen-l10n

# 빌드
flutter build apk
```

---

이 방법들을 조합하면 ARB 파일 관리가 훨씬 쉬워집니다!
