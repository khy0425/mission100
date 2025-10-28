#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
docs 폴더 정리 도구

사용법:
  python tools/organize_docs.py --preview  # 미리보기
  python tools/organize_docs.py --execute  # 실제 실행
"""

import sys
import shutil
import argparse
from pathlib import Path

# Windows 인코딩 설정
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

# 정리 규칙
ORGANIZATION_RULES = {
    # 보관할 파일들 (최신/핵심 문서)
    'keep': {
        'root': [
            'README.md',
            'CHANGELOG.md',
        ],
        'development': [
            'DEVELOPMENT.md',
            'IMPLEMENTATION_PLAN.md',
            'FEATURES.md',
        ],
        'deployment': [
            'RELEASE_BUILD.md',
            'DEPLOYMENT.md',
            'LAUNCH_READINESS.md',
        ],
        'l10n': [
            'l10n_complete_guide.md',  # 통합 가이드만 유지
        ],
        'workout': [
            'SCIENTIFIC_REFERENCES.md',
        ],
    },

    # archive로 이동할 파일들
    'archive': [
        # OLD 파일들
        'USER_JOURNEY_OLD.md',
        'ASSETS_OLD.md',
        'archive/ASSETS_OLD.md',

        # 중복/세부 온보딩 문서
        'ONBOARDING_TUTORIAL_FLOW.md',
        'ONBOARDING_TUTORIAL_GUIDE.md',
        'ONBOARDING_SIMPLIFIED_SUMMARY.md',
        'ONBOARDING_3_PROGRAM_IMPROVED.md',
        'ONBOARDING_3_BODY_TRANSFORMATION.md',
        'ONBOARDING_3_ALTERNATIVE_SOLUTIONS.md',
        'ONBOARDING_REDESIGN_MIDJOURNEY_FRIENDLY.md',

        # Midjourney 세부 프롬프트 (통합 문서만 유지)
        'MIDJOURNEY_ONBOARDING_PROMPTS.md',
        'MIDJOURNEY_WEB_OPTIMIZED_PROMPTS.md',
        'PUSHUP_FORM_GUIDE_MIDJOURNEY.md',
        'MIDJOURNEY_AUTOMATION_GUIDE.md',
        'APP_ICON_MIDJOURNEY_PROMPTS.md',

        # 세부 운동 가이드
        'PUSHUP_EXERCISE_GUIDE.md',
        'PUSHUP_VIDEO_LINKS.md',

        # 기타
        'REMAINING_TASKS.md',  # 구버전 태스크
        'PHASE1_TEST_ISSUES.md',  # 과거 테스트 이슈
        'USER_JOURNEY_CHECKLIST.md',  # 중복
        'MISSION100_NEXT_STEPS.md',  # 구버전
        'APP_ICON_LOCATION.md',  # 세부사항
        'CHAD_IMAGE_GENERATION_GUIDE.md',  # 세부 가이드
        'WORKOUT_IMAGE_PLAN.md',  # 구버전 계획

        # l10n 세부 문서 (complete_guide로 통합)
        'ARB_파일_관리_개선_방안.md',
        'l10n_domain_structure.md',
        'l10n_naming_convention.md',
    ],

    # 삭제할 파일들 (완전 중복)
    'delete': [
        'ASSETS_OLD.md',  # 이미 archive에 있음
    ],
}

def preview_changes():
    """변경사항 미리보기"""
    docs_dir = Path('docs')

    print("="*60)
    print("📋 docs 폴더 정리 미리보기")
    print("="*60)
    print()

    # 현재 파일 수
    all_files = list(docs_dir.rglob('*.md'))
    print(f"현재 파일 수: {len(all_files)}개")
    print()

    # 보관할 파일들
    print("✅ 보관 (새 구조)")
    print("-"*60)
    keep_count = 0
    for category, files in ORGANIZATION_RULES['keep'].items():
        if category == 'root':
            print(f"  docs/")
        else:
            print(f"  docs/{category}/")
        for f in files:
            print(f"    {f}")
            keep_count += 1
    print(f"  → 총 {keep_count}개 파일")
    print()

    # Archive로 이동
    print("📦 Archive로 이동")
    print("-"*60)
    archive_files = ORGANIZATION_RULES['archive']
    for f in archive_files:
        print(f"  {f}")
    print(f"  → 총 {len(archive_files)}개 파일")
    print()

    # 삭제
    delete_files = ORGANIZATION_RULES['delete']
    if delete_files:
        print("🗑️  삭제")
        print("-"*60)
        for f in delete_files:
            print(f"  {f}")
        print(f"  → 총 {len(delete_files)}개 파일")
        print()

    # 요약
    print("="*60)
    print("요약")
    print("="*60)
    print(f"  • 현재: {len(all_files)}개 파일")
    print(f"  • 보관: {keep_count}개 파일 (새 구조)")
    print(f"  • Archive: {len(archive_files)}개 파일")
    print(f"  • 삭제: {len(delete_files)}개 파일")
    print(f"  • 최종: {keep_count}개 핵심 문서")
    print()

def execute_reorganization():
    """실제로 재구성 실행"""
    docs_dir = Path('docs')
    archive_dir = docs_dir / 'archive'
    archive_dir.mkdir(exist_ok=True)

    print("="*60)
    print("🔧 docs 폴더 재구성 실행 중...")
    print("="*60)
    print()

    # 1. 카테고리별 디렉토리 생성
    print("[1/4] 카테고리 디렉토리 생성")
    print("-"*60)
    categories = ['development', 'deployment', 'l10n', 'workout', 'assets']
    for cat in categories:
        cat_dir = docs_dir / cat
        cat_dir.mkdir(exist_ok=True)
        print(f"  ✓ docs/{cat}/")
    print()

    # 2. 보관할 파일 이동
    print("[2/4] 핵심 문서 정리")
    print("-"*60)
    for category, files in ORGANIZATION_RULES['keep'].items():
        if category == 'root':
            continue

        cat_dir = docs_dir / category
        for filename in files:
            src = docs_dir / filename
            dst = cat_dir / filename

            if src.exists() and src != dst:
                shutil.move(str(src), str(dst))
                print(f"  ✓ {filename} → {category}/")
    print()

    # 3. Archive로 이동
    print("[3/4] Archive로 이동")
    print("-"*60)
    for filename in ORGANIZATION_RULES['archive']:
        src = docs_dir / filename

        if src.exists():
            dst = archive_dir / Path(filename).name
            shutil.move(str(src), str(dst))
            print(f"  ✓ {filename}")
    print()

    # 4. 운동 폴더 이동
    print("[4/4] 운동 폴더 정리")
    print("-"*60)
    workout_old_dir = docs_dir / '운동'
    if workout_old_dir.exists():
        # 운동 폴더의 파일들을 archive로 이동
        for f in workout_old_dir.glob('*.md'):
            dst = archive_dir / f.name
            shutil.move(str(f), str(dst))
            print(f"  ✓ {f.name} → archive/")

        # 빈 폴더 삭제
        if not any(workout_old_dir.iterdir()):
            workout_old_dir.rmdir()
            print(f"  ✓ 운동/ 폴더 삭제")
    print()

    print("="*60)
    print("✅ 재구성 완료!")
    print("="*60)
    print()
    print("새 구조:")
    print("  docs/")
    print("    README.md")
    print("    CHANGELOG.md")
    print("    development/")
    print("    deployment/")
    print("    l10n/")
    print("    workout/")
    print("    assets/")
    print("    archive/")
    print()

def main():
    parser = argparse.ArgumentParser(description='docs 폴더 정리 도구')
    parser.add_argument('--preview', action='store_true', help='변경사항 미리보기')
    parser.add_argument('--execute', action='store_true', help='실제로 실행')

    args = parser.parse_args()

    if args.preview:
        preview_changes()
    elif args.execute:
        execute_reorganization()
    else:
        print("사용법:")
        print("  python tools/organize_docs.py --preview   # 미리보기")
        print("  python tools/organize_docs.py --execute   # 실행")

if __name__ == '__main__':
    main()
