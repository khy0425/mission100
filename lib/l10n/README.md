# 다국어(i18n) 파일 관리 가이드

## 📁 디렉토리 구조

```
lib/l10n/
├── source/               # 📝 소스 ARB 파일 (카테고리별 분리)
│   ├── common_en.arb     # 공통 (버튼, 라벨 등)
│   ├── common_ko.arb
│   ├── achievements_en.arb  # 업적
│   ├── achievements_ko.arb
│   ├── workouts_en.arb   # 운동
│   ├── workouts_ko.arb
│   ├── chad_en.arb       # Chad 메시지
│   ├── chad_ko.arb
│   └── ...               # 총 15개 카테고리 x 2개 언어 = 30개 파일
│
├── backup/               # 🔒 원본 백업 (수동 분리 전 백업)
│   ├── app_en.arb.backup
│   └── app_ko.arb.backup
│
├── app_en.arb            # ✅ 병합된 파일 (flutter gen-l10n용)
└── app_ko.arb            # ✅ 병합된 파일 (flutter gen-l10n용)
```

## 🎯 관리 방식

### 기본 원칙
1. **소스 파일 수정**: `lib/l10n/source/` 내의 카테고리별 ARB 파일을 수정
2. **자동 병합**: 스크립트로 `app_en.arb`, `app_ko.arb`로 자동 병합
3. **다국어 생성**: `flutter gen-l10n`으로 Dart 파일 생성

## 🛠 사용 방법

### 1. 번역 텍스트 추가/수정

#### 적절한 카테고리 선택
- `common`: 버튼, 라벨 등 공통 UI 요소
- `workouts`: 운동 프로그램 관련
- `achievements`: 업적 시스템
- `chad`: Chad 메시지/동기부여
- `onboarding`: 온보딩/튜토리얼
- `settings`: 설정 화면
- `errors`: 오류 메시지
- 기타: auth, challenges, exercises, levels, premium, progress, recovery, sync

#### 파일 수정
```json
// lib/l10n/source/common_en.arb
{
  "buttonSave": "Save",
  "@buttonSave": {
    "description": "Save button text"
  }
}
```

```json
// lib/l10n/source/common_ko.arb
{
  "buttonSave": "저장",
  "@buttonSave": {
    "description": "저장 버튼 텍스트"
  }
}
```

### 2. ARB 파일 병합

번역 추가/수정 후 반드시 병합 스크립트 실행:

```bash
# 프로젝트 루트에서
python tools/merge_arb_files.py
```

**출력 예시:**
```
============================================================
ARB 파일 병합 도구
============================================================

병합 중: en
------------------------------------------------------------
  ✓ common          -  403 키
  ✓ auth            -    2 키
  ✓ onboarding      -   15 키
  ...
------------------------------------------------------------
  → app_en.arb: 1493 키

병합 완료!
```

### 3. 다국어 파일 생성

```bash
flutter gen-l10n
```

### 4. 빌드 전 자동화 (선택)

package.json 또는 Makefile에 추가:

```makefile
# Makefile
build:
\tpython tools/merge_arb_files.py
\tflutter gen-l10n
\tflutter build apk

run:
\tpython tools/merge_arb_files.py
\tflutter gen-l10n
\tflutter run
```

## 📊 카테고리별 파일 크기

| 카테고리 | 키 개수 (영어) | 파일 크기 |
|---------|--------------|----------|
| common | 403 | 1609줄 |
| workouts | 287 | 1364줄 |
| achievements | 246 | 610줄 |
| chad | 125 | 486줄 |
| exercises | 131 | 391줄 |
| challenges | 61 | 259줄 |
| settings | 45 | 189줄 |
| levels | 48 | 196줄 |
| sync | 41 | 154줄 |
| progress | 34 | 137줄 |
| premium | 25 | 102줄 |
| onboarding | 15 | 44줄 |
| errors | 16 | 64줄 |
| recovery | 14 | 40줄 |
| auth | 2 | 10줄 |

**총계**: 1493개 키

## ⚠️ 주의사항

### ❌ 하지 말 것
- `app_en.arb`, `app_ko.arb`를 직접 수정하지 마세요
  → 병합 스크립트 실행 시 덮어씌워집니다
  → **이 파일들은 .gitignore에 등록되어 Git에 추적되지 않습니다**
- `source/` 디렉토리를 삭제하지 마세요
  → 소스 파일이 손실됩니다

### ✅ 해야 할 것
- 항상 `source/` 디렉토리 내 파일을 수정
- 수정 후 병합 스크립트 실행
- **Git에 커밋 시 `source/` 디렉토리만 포함됩니다**
  - `app_*.arb`는 자동 생성 파일이므로 Git에서 제외됨
  - 협업자는 pull 후 병합 스크립트를 실행하여 생성

## 🔧 트러블슈팅

### 1. "Multiple arb files with the same locale detected" 오류
**원인**: `lib/l10n`에 카테고리별 ARB 파일이 남아있음
**해결**: `lib/l10n`에는 `app_en.arb`, `app_ko.arb`만 있어야 함

```bash
# 확인
ls lib/l10n/*.arb

# 출력되어야 할 파일:
# app_en.arb  app_ko.arb
```

### 2. 병합 후 특정 키가 없어짐
**원인**: 카테고리 분류 오류
**해결**: 해당 키가 어느 카테고리에 있는지 확인

```bash
# 키 검색
grep -r "yourKey" lib/l10n/source/
```

### 3. 병합 스크립트 실행 실패
**원인**: Python 경로 문제
**해결**:
```bash
# Windows
python tools/merge_arb_files.py

# Mac/Linux
python3 tools/merge_arb_files.py
```

## 📝 Git 작업 흐름

```bash
# 1. 번역 추가/수정
vim lib/l10n/source/common/common_ko.arb

# 2. 병합 (로컬에서만 생성됨)
python tools/merge_arb_files.py

# 3. 다국어 생성
flutter gen-l10n

# 4. 테스트
flutter run

# 5. 커밋 (source만 커밋됨!)
git add lib/l10n/source/
git commit -m "feat: Add new translation keys"

# ⚠️ 주의: app_*.arb는 .gitignore에 등록되어 있어 커밋되지 않음
# 협업자는 pull 후 병합 스크립트를 실행하여 생성해야 함
```

## 🔄 협업자 워크플로우

```bash
# 1. 최신 코드 pull
git pull

# 2. ARB 파일 병합 (app_*.arb 생성)
python tools/merge_arb_files.py

# 3. 다국어 파일 생성
flutter gen-l10n

# 4. 빌드/실행
flutter run
```

## 🚀 장점

### 기존 방식 (7000줄 단일 파일)
- ❌ 특정 텍스트 찾기 어려움
- ❌ Git 충돌 빈번
- ❌ 번역 작업 어려움
- ❌ 코드 리뷰 어려움

### 현재 방식 (카테고리별 분리)
- ✅ 카테고리별로 쉽게 찾기
- ✅ Git 충돌 최소화
- ✅ 병렬 번역 작업 가능
- ✅ 변경사항 추적 용이

## 📚 추가 자료

- [Flutter 다국어 가이드](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [ARB 파일 형식](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)
- [프로젝트 전체 가이드](../../docs/ARB_파일_관리_개선_방안.md)

---

**마지막 업데이트**: 2025-10-26
**관리자**: Mission 100 개발팀
