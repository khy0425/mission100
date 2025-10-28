#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ARB 파일의 말투 확인 스크립트"""

import json
import sys
import codecs

# Windows에서 UTF-8 출력 설정
if sys.platform == 'win32':
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout.buffer, 'strict')
    sys.stderr = codecs.getwriter('utf-8')(sys.stderr.buffer, 'strict')

def check_tone():
    arb_path = '../lib/l10n/app_ko.arb'

    with open(arb_path, 'r', encoding='utf-8') as f:
        arb = json.load(f)

    results = {
        'chad_mentions': [],
        'formal_tone': [],
        'achievement_issues': []
    }

    # Chad 직접 언급 체크
    print("\n=== 1. Chad 직접 언급 체크 ===")
    for key, value in arb.items():
        if key.startswith('@'):
            continue
        if isinstance(value, str) and 'Chad' in value:
            results['chad_mentions'].append(f"{key}: {value}")
            print(f"❌ {key}: {value[:100]}")

    if not results['chad_mentions']:
        print("✅ Chad 직접 언급 없음")
    else:
        print(f"\n총 {len(results['chad_mentions'])}개 발견")

    # 딱딱한 말투 체크 (하세요, 합니다, 해야, etc.)
    print("\n=== 2. 딱딱한 말투 체크 ===")
    formal_patterns = ['하세요', '합니다', '해야', '진행하', '수행하', '권장합니다', '확인하세요']

    for key, value in arb.items():
        if key.startswith('@'):
            continue
        if isinstance(value, str):
            for pattern in formal_patterns:
                if pattern in value:
                    results['formal_tone'].append(f"{key}: {value}")
                    print(f"❌ {key}: {value[:100]} (패턴: {pattern})")
                    break

    if not results['formal_tone']:
        print("✅ 딱딱한 말투 없음")
    else:
        print(f"\n총 {len(results['formal_tone'])}개 발견")

    # Achievement 관련 확인
    print("\n=== 3. Achievement 딱딱한 말투 체크 ===")
    achievement_count = 0
    for key, value in arb.items():
        if key.startswith('@'):
            continue
        if 'achievement' in key.lower() or '업적' in str(value):
            achievement_count += 1
            if isinstance(value, str):
                for pattern in formal_patterns:
                    if pattern in value:
                        results['achievement_issues'].append(f"{key}: {value}")
                        print(f"❌ {key}: {value[:100]}")
                        break

    if not results['achievement_issues']:
        print(f"✅ Achievement 관련 {achievement_count}개 중 딱딱한 말투 없음")
    else:
        print(f"\n총 {len(results['achievement_issues'])}개 발견")

    # 요약
    print("\n" + "="*50)
    print("=== 요약 ===")
    print(f"❌ Chad 직접 언급: {len(results['chad_mentions'])}개")
    print(f"❌ 딱딱한 말투: {len(results['formal_tone'])}개")
    print(f"❌ Achievement 딱딱한 말투: {len(results['achievement_issues'])}개")

    if not any(results.values()):
        print("\n✅ 모든 체크 통과!")
        return 0
    else:
        print("\n⚠️ 수정 필요한 항목이 있습니다")
        return 1

if __name__ == '__main__':
    exit(check_tone())
