#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
기존 카테고리 기반 구조를 도메인 기반 구조로 재정립

Before:
lib/l10n/source/
  achievements_en.arb
  achievements_ko.arb
  common_en.arb
  ...

After:
lib/l10n/source/
  common/
    common_en.arb
    common_ko.arb
  workout/
    workout_en.arb
    workout_ko.arb
  ...
"""

import json
import shutil
import sys
from pathlib import Path

# Windows 인코딩 설정
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

# 카테고리 → 도메인 매핑
CATEGORY_TO_DOMAIN = {
    'achievements': 'achievement',
    'auth': 'auth',
    'chad': 'chad',
    'challenges': 'challenge',
    'common': 'common',
    'errors': 'error',
    'exercises': 'exercise',
    'levels': 'level',
    'onboarding': 'onboarding',
    'premium': 'premium',
    'progress': 'progress',
    'recovery': 'recovery',
    'settings': 'settings',
    'sync': 'sync',
    'workouts': 'workout',
}

def restructure():
    """카테고리 기반 → 도메인 기반으로 재구조화"""

    source_dir = Path('lib/l10n/source')

    if not source_dir.exists():
        print("✗ lib/l10n/source 디렉토리가 없습니다")
        return

    print("="*60)
    print("l10n 구조 재정립: 카테고리 → 도메인")
    print("="*60)
    print()

    moved_count = 0

    for category, domain in CATEGORY_TO_DOMAIN.items():
        # 도메인 디렉토리 생성
        domain_dir = source_dir / domain
        domain_dir.mkdir(exist_ok=True)

        # 영어/한글 파일 이동
        for lang in ['en', 'ko']:
            old_file = source_dir / f'{category}_{lang}.arb'
            new_file = domain_dir / f'{domain}_{lang}.arb'

            if old_file.exists():
                # 파일 이동
                shutil.move(str(old_file), str(new_file))
                print(f"  ✓ {old_file.name} → {domain}/{new_file.name}")
                moved_count += 1

    print()
    print("="*60)
    print(f"완료! {moved_count}개 파일 이동됨")
    print()
    print("새 구조:")
    print("-"*60)

    # 새 구조 출력
    for domain_dir in sorted(source_dir.iterdir()):
        if domain_dir.is_dir():
            files = list(domain_dir.glob('*.arb'))
            if files:
                print(f"  {domain_dir.name}/")
                for f in sorted(files):
                    print(f"    {f.name}")

    print()
    print("다음 단계:")
    print("  python tools/merge_arb_files.py")
    print("  flutter gen-l10n")
    print()

if __name__ == '__main__':
    restructure()
