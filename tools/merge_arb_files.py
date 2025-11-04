#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
분리된 ARB 파일들을 하나로 병합하는 스크립트

사용법:
  python tools/merge_arb_files.py
"""

import json
import os
import sys
from pathlib import Path

# Windows 인코딩 설정
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

def merge_arb_files(lang):
    """여러 ARB 파일을 하나로 병합"""

    source_dir = Path('lib/l10n/source')
    l10n_dir = Path('lib/l10n')
    merged = {}

    # 병합할 도메인 순서 (이 순서대로 병합됨)
    domains = [
        'common',       # 공통 (먼저)
        'auth',
        'onboarding',
        'tutorial',
        'workout',
        'exercise',
        'recovery',
        'progress',
        'level',
        'achievement',
        'challenge',
        'chad',
        'premium',
        'settings',
        'sync',
        'error',        # 에러 (나중)
    ]

    print(f"\n병합 중: {lang}")
    print("-" * 60)

    total_keys = 0

    for domain in domains:
        arb_file = source_dir / domain / f'{domain}_{lang}.arb'

        if arb_file.exists():
            with open(arb_file, 'r', encoding='utf-8') as f:
                data = json.load(f)

            # 실제 키 개수 (@ 제외)
            real_keys = len([k for k in data.keys() if not k.startswith('@')])

            # 병합 (기존 키 덮어쓰기)
            merged.update(data)

            total_keys += real_keys
            print(f"  ✓ {domain:15s} - {real_keys:4d} 키")

        else:
            print(f"  ✗ {domain:15s} - 파일 없음 (건너뜀)")

    # 결과 파일에 저장
    output_file = l10n_dir / f'app_{lang}.arb'

    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(merged, f, ensure_ascii=False, indent=2)

    print("-" * 60)
    print(f"  → {output_file.name}: {total_keys} 키")

    return total_keys

def main():
    print("\n" + "="*60)
    print("ARB 파일 병합 도구")
    print("="*60)

    # 영어 병합
    en_keys = merge_arb_files('en')

    # 한글 병합
    ko_keys = merge_arb_files('ko')

    print("\n" + "="*60)
    print("병합 완료!")
    print("="*60)
    print(f"  • 영어: {en_keys} 키 → lib/l10n/app_en.arb")
    print(f"  • 한글: {ko_keys} 키 → lib/l10n/app_ko.arb")
    print()
    print("다음 단계:")
    print("  flutter gen-l10n")
    print()

if __name__ == '__main__':
    main()
