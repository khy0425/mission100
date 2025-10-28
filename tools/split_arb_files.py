#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ARB 파일을 카테고리별로 분리하는 스크립트

사용법:
  python tools/split_arb_files.py
"""

import json
import os
import sys
from pathlib import Path
from collections import defaultdict

# Windows 인코딩 설정
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

# 카테고리 정의 (우선순위 순서대로 - 먼저 매칭된 것이 적용됨)
CATEGORIES = {
    # 1. 업적 관련 (achievement로 시작하는 것들)
    'achievements': [
        'achievement', 'unlock', 'badge', 'milestone', 'trophy',
        'levelUp', 'reward'
    ],

    # 2. 운동 프로그램 관련
    'workouts': [
        'workout', 'program', 'week', 'day', 'session',
        'reps', 'set', 'rest', 'warmup', 'cooldown'
    ],

    # 3. 운동 종류/자세 관련
    'exercises': [
        'exercise', 'pushup', 'pullup', 'squat', 'plank',
        'form', 'technique', 'posture', 'position'
    ],

    # 4. RPE 및 회복 관련
    'recovery': [
        'rpe', 'recovery', 'fatigue', 'soreness', 'muscle',
        'condition', 'rest', 'sleep', 'activeRecovery'
    ],

    # 5. 진행 상황 관련
    'progress': [
        'progress', 'stats', 'statistics', 'graph', 'chart',
        'history', 'record', 'performance', 'streak'
    ],

    # 6. 레벨/단계 관련
    'levels': [
        'level', 'beginner', 'intermediate', 'advanced',
        'tier', 'rank', 'grade'
    ],

    # 7. Chad 메시지/동기부여
    'chad': [
        'chad', 'motivation', 'tip', 'advice', 'legendary',
        'god', 'strong', 'weak'
    ],

    # 8. 온보딩
    'onboarding': [
        'onboarding', 'welcome', 'intro', 'getStarted',
        'tutorial', 'guide', 'initial', 'test'
    ],

    # 9. 인증 관련
    'auth': [
        'login', 'signup', 'auth', 'account', 'user',
        'email', 'password', 'google', 'guest'
    ],

    # 10. 설정
    'settings': [
        'settings', 'preferences', 'config', 'theme',
        'language', 'locale', 'notification'
    ],

    # 11. 프리미엄/구독
    'premium': [
        'premium', 'subscription', 'billing', 'purchase',
        'upgrade', 'plan', 'free', 'paid'
    ],

    # 12. 챌린지
    'challenges': [
        'challenge', 'competition', 'leaderboard', 'rival'
    ],

    # 13. 백업/동기화
    'sync': [
        'backup', 'restore', 'sync', 'cloud', 'export', 'import'
    ],

    # 14. 에러/경고
    'errors': [
        'error', 'warning', 'fail', 'invalid', 'required',
        'missing', 'notFound'
    ],

    # 15. 공통 버튼/라벨
    'common': [
        'button', 'skip', 'next', 'back', 'cancel', 'confirm',
        'ok', 'yes', 'no', 'save', 'delete', 'edit',
        'close', 'open', 'start', 'stop', 'pause', 'resume',
        'retry', 'done', 'awesome'
    ],
}

def categorize_key(key):
    """키를 적절한 카테고리로 분류"""
    # @ 메타데이터 키는 원본 키와 같은 카테고리
    if key.startswith('@'):
        return categorize_key(key[1:])

    key_lower = key.lower()

    # 각 카테고리의 패턴을 순서대로 확인
    for category, patterns in CATEGORIES.items():
        for pattern in patterns:
            if pattern.lower() in key_lower:
                return category

    # 매칭되지 않으면 common으로
    return 'common'

def split_arb_file(input_file, lang):
    """ARB 파일을 카테고리별로 분리"""

    print(f"\n{'='*60}")
    print(f"Processing {input_file}")
    print(f"{'='*60}")

    with open(input_file, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # 카테고리별로 데이터 분리
    categorized = defaultdict(dict)

    for key, value in data.items():
        # 카테고리 결정
        category = categorize_key(key)
        categorized[category][key] = value

    # l10n 디렉토리
    l10n_dir = Path('lib/l10n')

    # 각 카테고리별 파일 저장
    stats = []
    for category in sorted(categorized.keys()):
        content = categorized[category]
        if content:
            # 실제 키 개수 (@ 제외)
            real_keys = len([k for k in content.keys() if not k.startswith('@')])

            output_file = l10n_dir / f'{category}_{lang}.arb'

            # JSON 저장 (정렬해서 diff 보기 쉽게)
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(content, f, ensure_ascii=False, indent=2, sort_keys=True)

            # 줄 수 계산
            with open(output_file, 'r', encoding='utf-8') as f:
                lines = len(f.readlines())

            stats.append({
                'category': category,
                'file': output_file.name,
                'keys': real_keys,
                'lines': lines
            })

            print(f"  ✓ {output_file.name:30s} - {real_keys:4d} keys, {lines:5d} lines")

    return stats

def create_backup(lang):
    """원본 파일 백업"""
    original = Path(f'lib/l10n/app_{lang}.arb')
    backup = Path(f'lib/l10n/backup/app_{lang}.arb.backup')

    # backup 디렉토리 생성
    backup.parent.mkdir(exist_ok=True)

    if original.exists():
        import shutil
        shutil.copy2(original, backup)
        print(f"  ✓ Backed up to {backup}")

def main():
    print("\n" + "="*60)
    print("ARB 파일 카테고리별 분리 도구")
    print("="*60)

    # 백업 생성
    print("\n[1/4] 원본 파일 백업...")
    create_backup('en')
    create_backup('ko')

    # 영어 파일 분리
    print("\n[2/4] 영어 ARB 파일 분리...")
    en_stats = split_arb_file('lib/l10n/app_en.arb', 'en')

    # 한글 파일 분리
    print("\n[3/4] 한글 ARB 파일 분리...")
    ko_stats = split_arb_file('lib/l10n/app_ko.arb', 'ko')

    # 통계 출력
    print("\n[4/4] 분리 완료 - 통계")
    print("="*60)
    print(f"{'카테고리':<20s} {'파일 개수':>10s} {'총 키':>10s} {'총 줄':>10s}")
    print("-"*60)

    total_files = len(en_stats) * 2  # en + ko
    total_keys_en = sum(s['keys'] for s in en_stats)
    total_lines_en = sum(s['lines'] for s in en_stats)
    total_keys_ko = sum(s['keys'] for s in ko_stats)
    total_lines_ko = sum(s['lines'] for s in ko_stats)

    for stat in en_stats:
        category = stat['category']
        print(f"{category:<20s} {'2':>10s} {stat['keys']:>10d} {stat['lines']:>10d}")

    print("-"*60)
    print(f"{'합계':<20s} {total_files:>10d} {total_keys_en:>10d} {total_lines_en:>10d}")
    print()
    print(f"  • 영어: {len(en_stats)} 파일, {total_keys_en} 키, {total_lines_en} 줄")
    print(f"  • 한글: {len(ko_stats)} 파일, {total_keys_ko} 키, {total_lines_ko} 줄")
    print(f"  • 원본 백업: lib/l10n/backup/")

    # 다음 단계 안내
    print("\n" + "="*60)
    print("다음 단계:")
    print("="*60)
    print("1. flutter gen-l10n 실행하여 다국어 파일 생성")
    print("2. flutter run으로 앱 실행하여 테스트")
    print("3. 문제 없으면 원본 파일(app_en.arb, app_ko.arb) 삭제")
    print("4. l10n.yaml 설정 확인 (필요시)")
    print()

if __name__ == '__main__':
    main()
