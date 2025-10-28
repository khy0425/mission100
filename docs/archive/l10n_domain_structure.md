# Mission 100 프로젝트 l10n 도메인 구조

## 🎯 최적 분할 기준

### Mission 100 앱의 핵심 도메인

```
lib/l10n/
├── common/               # 공통 UI 요소 (300-400 키)
│   ├── common_ko.arb     # 버튼, 라벨, 메시지
│   └── common_en.arb
│
├── workout/              # 운동 프로그램 (500-600 키)
│   ├── workout_ko.arb    # 운동, 세트, 휴식, 프로그램
│   └── workout_en.arb
│
├── exercise/             # 운동 종류/자세 (200-300 키)
│   ├── exercise_ko.arb   # 푸시업, 풀업, 자세 설명
│   └── exercise_en.arb
│
├── achievement/          # 업적 시스템 (300-400 키)
│   ├── achievement_ko.arb
│   └── achievement_en.arb
│
├── progress/             # 진행 상황/통계 (150-200 키)
│   ├── progress_ko.arb
│   └── progress_en.arb
│
├── chad/                 # Chad 메시지 (100-150 키)
│   ├── chad_ko.arb       # 동기부여, 조언
│   └── chad_en.arb
│
├── onboarding/           # 온보딩 (50-100 키)
│   ├── onboarding_ko.arb
│   └── onboarding_en.arb
│
├── auth/                 # 인증 (30-50 키)
│   ├── auth_ko.arb
│   └── auth_en.arb
│
├── settings/             # 설정 (80-120 키)
│   ├── settings_ko.arb
│   └── settings_en.arb
│
├── premium/              # 프리미엄/구독 (50-80 키)
│   ├── premium_ko.arb
│   └── premium_en.arb
│
├── challenge/            # 챌린지 (80-100 키)
│   ├── challenge_ko.arb
│   └── challenge_en.arb
│
└── error/                # 에러 메시지 (30-50 키)
    ├── error_ko.arb
    └── error_en.arb
```

## 📋 분할 원칙

### 1. 기능 단위 분리
- **workout**: 운동 프로그램 전체 (주차별, 세션, 세트, 휴식)
- **exercise**: 운동 동작 설명 (푸시업 자세, 풀업 기술 등)
- **progress**: 통계, 그래프, 히스토리
- **achievement**: 업적, 보상, 레벨업

### 2. 사용자 여정 단위
- **onboarding**: 첫 실행 → 레벨 테스트 → 프로그램 시작
- **auth**: 로그인 → 회원가입 → 게스트
- **settings**: 테마, 언어, 알림 설정

### 3. 횡단 관심사
- **common**: 버튼, 확인/취소, 저장/삭제 등 공통 UI
- **error**: 네트워크 오류, 권한 오류 등

---

## 🏗️ 구현 방법 (intl_utils 방식)

### 1. pubspec.yaml 설정

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0

dev_dependencies:
  intl_utils: ^2.8.0

flutter:
  generate: true

# intl_utils 설정
flutter_intl:
  enabled: true
  class_name: S
  main_locale: ko
  arb_dir: lib/l10n
  output_dir: lib/generated/l10n
  use_deferred_loading: false
```

### 2. 초기화

```bash
flutter pub get
flutter pub run intl_utils:generate
```

### 3. 파일 구조

intl_utils는 **단일 ARB 파일만 지원**하므로, 우리가 직접 **병합 시스템**을 만들어야 합니다.

**최종 구조:**
```
lib/l10n/
├── source/              # 📝 작업용 (도메인별 분리)
│   ├── common/
│   │   ├── common_ko.arb
│   │   └── common_en.arb
│   ├── workout/
│   │   ├── workout_ko.arb
│   │   └── workout_en.arb
│   └── ...
│
├── intl_ko.arb          # ✅ 병합된 파일 (생성됨)
└── intl_en.arb          # ✅ 병합된 파일 (생성됨)
```

---

## 🤖 자동화 스크립트 (개선)

### build_l10n.py (스마트 병합)

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
도메인별 ARB 파일을 자동 병합하고 flutter gen-l10n 실행
"""

import json
import subprocess
from pathlib import Path
from collections import OrderedDict

DOMAINS = [
    'common',
    'auth',
    'onboarding',
    'workout',
    'exercise',
    'progress',
    'achievement',
    'chad',
    'challenge',
    'settings',
    'premium',
    'error',
]

def merge_arb_files(lang):
    """도메인별 ARB 파일을 하나로 병합"""

    source_dir = Path('lib/l10n/source')
    output_file = Path(f'lib/l10n/intl_{lang}.arb')

    merged = OrderedDict()

    for domain in DOMAINS:
        domain_dir = source_dir / domain
        arb_file = domain_dir / f'{domain}_{lang}.arb'

        if arb_file.exists():
            with open(arb_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
                merged.update(data)

    # 저장
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(merged, f, ensure_ascii=False, indent=2)

    return len([k for k in merged.keys() if not k.startswith('@')])

def main():
    print("="*60)
    print("Mission 100 - l10n 빌드 시스템")
    print("="*60)

    # 1. 병합
    print("\n[1/3] ARB 파일 병합...")
    ko_keys = merge_arb_files('ko')
    en_keys = merge_arb_files('en')
    print(f"  ✓ 한글: {ko_keys} 키")
    print(f"  ✓ 영어: {en_keys} 키")

    # 2. flutter gen-l10n
    print("\n[2/3] flutter gen-l10n 실행...")
    result = subprocess.run(['flutter', 'gen-l10n'], capture_output=True, text=True)

    if result.returncode == 0:
        print("  ✓ 다국어 파일 생성 완료")
    else:
        print(f"  ✗ 오류 발생:\n{result.stderr}")
        return

    # 3. 통계
    print("\n[3/3] 완료!")
    print("="*60)
    print(f"총 {len(DOMAINS)}개 도메인, {ko_keys}개 키 처리")
    print()

if __name__ == '__main__':
    main()
```

---

## 🎨 사용 예시

### 개발자 A: 운동 관련 텍스트 추가

```bash
# 1. workout 도메인 파일 수정
vim lib/l10n/source/workout/workout_ko.arb

# 2. 빌드
python tools/build_l10n.py

# 3. 코드에서 사용
Text(S.of(context).workout_pushup_desc)
```

### 개발자 B: 업적 번역 수정

```bash
# 1. achievement 도메인 파일 수정
vim lib/l10n/source/achievement/achievement_en.arb

# 2. 빌드
python tools/build_l10n.py
```

**✅ Git 충돌 없음!** (서로 다른 도메인 파일)

---

## 📊 예상 효과

| 항목 | 기존 (단일 파일) | 개선 (도메인 분리) |
|------|-----------------|------------------|
| 파일 크기 | 7000줄 | 최대 600줄 |
| Git 충돌 | 빈번 | 최소화 |
| 번역 작업 | 어려움 | 병렬 작업 가능 |
| 코드 리뷰 | 힘듦 | 도메인별 리뷰 |
| 유지보수 | 불가능 | 용이 |

---

## 🔧 Makefile 통합

```makefile
.PHONY: l10n build run

l10n:
	@echo "Building localization files..."
	@python tools/build_l10n.py

build: l10n
	flutter build apk

run: l10n
	flutter run

clean:
	flutter clean
	rm -f lib/l10n/intl_*.arb
```

사용:
```bash
make run    # l10n 빌드 + 앱 실행
make build  # l10n 빌드 + APK 빌드
```

---

이제 **도메인 기반 구조**로 전환하면:
- ✅ 파일 크기: 7000줄 → 최대 600줄
- ✅ 협업: Git 충돌 최소화
- ✅ 유지보수: 도메인별 관리
- ✅ 확장성: 새 도메인 쉽게 추가
