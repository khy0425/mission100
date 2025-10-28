#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ChatGPT를 활용한 ARB 파일 자동 번역 도구

사용법:
  python tools/auto_translate.py --domain workout --source ko --target en
  python tools/auto_translate.py --all  # 모든 도메인 번역
"""

import json
import sys
import argparse
from pathlib import Path
from collections import OrderedDict

# Windows 인코딩 설정
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

# ChatGPT API 사용 시 (선택)
# import openai
# openai.api_key = "YOUR_API_KEY"

DOMAINS = [
    'common', 'auth', 'onboarding', 'workout', 'exercise',
    'progress', 'achievement', 'chad', 'challenge', 'settings',
    'premium', 'error'
]

# 번역 스타일 가이드 (도메인별)
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
    },
    'common': {
        'tone': '중립적, 간결함',
        'style': '명사형',
        'example_ko': '저장',
        'example_en': 'Save'
    }
}


def translate_with_chatgpt(text, source_lang, target_lang, domain, context):
    """
    ChatGPT API를 사용한 번역

    실제 구현 시 openai 라이브러리 사용:

    ```python
    import openai

    style_guide = TRANSLATION_STYLE.get(domain, TRANSLATION_STYLE['common'])

    prompt = f'''
    Translate the following {source_lang} text to {target_lang}.

    Domain: {domain}
    Context: {context}
    Tone: {style_guide['tone']}
    Style: {style_guide['style']}

    Example:
    {source_lang}: {style_guide[f'example_{source_lang}']}
    {target_lang}: {style_guide[f'example_{target_lang}']}

    Text to translate: "{text}"

    Requirements:
    - Maintain formatting (newlines, parameters like {{name}}, {{count}})
    - Preserve emojis
    - Keep technical terms consistent
    - Natural and fluent translation
    - Only output the translated text, nothing else
    '''

    response = openai.ChatCompletion.create(
        model="gpt-4",
        messages=[
            {"role": "system", "content": "You are a professional translator specializing in fitness app localization."},
            {"role": "user", "content": prompt}
        ],
        temperature=0.3
    )

    return response.choices[0].message.content.strip()
    ```
    """

    # 데모용 (실제로는 위의 ChatGPT API 사용)
    print(f"  [번역 필요] {text}")
    return f"[TRANSLATE_{target_lang.upper()}] {text}"


def auto_translate_arb(domain, source_lang, target_lang):
    """도메인의 ARB 파일 자동 번역"""

    source_dir = Path('lib/l10n/source') / domain
    source_file = source_dir / f'{domain}_{source_lang}.arb'
    target_file = source_dir / f'{domain}_{target_lang}.arb'

    if not source_file.exists():
        print(f"  ✗ 소스 파일 없음: {source_file}")
        return 0

    # 소스 파일 읽기
    with open(source_file, 'r', encoding='utf-8') as f:
        source_data = json.load(f)

    # 타겟 파일이 있으면 읽기 (기존 번역 유지)
    target_data = OrderedDict()
    if target_file.exists():
        with open(target_file, 'r', encoding='utf-8') as f:
            target_data = json.load(f)

    translated_count = 0

    # 번역
    for key, value in source_data.items():
        # @ 메타데이터는 건너뛰기
        if key.startswith('@'):
            # description만 번역
            if isinstance(value, dict) and 'description' in value:
                if key not in target_data or target_data[key].get('description') == '':
                    context = source_data.get(key.lstrip('@'), '')
                    translated_desc = translate_with_chatgpt(
                        value['description'],
                        source_lang,
                        target_lang,
                        domain,
                        context
                    )
                    target_data[key] = {'description': translated_desc}
                    translated_count += 1
            continue

        # 이미 번역된 키는 건너뛰기
        if key in target_data and target_data[key]:
            continue

        # 번역 실행
        translated_text = translate_with_chatgpt(
            value,
            source_lang,
            target_lang,
            domain,
            key
        )

        target_data[key] = translated_text
        translated_count += 1

    # 저장
    source_dir.mkdir(parents=True, exist_ok=True)
    with open(target_file, 'w', encoding='utf-8') as f:
        json.dump(target_data, f, ensure_ascii=False, indent=2)

    return translated_count


def main():
    parser = argparse.ArgumentParser(
        description='Mission 100 - ARB 파일 자동 번역 도구'
    )
    parser.add_argument('--domain', type=str, help='번역할 도메인')
    parser.add_argument('--source', type=str, default='ko', help='소스 언어 (기본: ko)')
    parser.add_argument('--target', type=str, default='en', help='타겟 언어 (기본: en)')
    parser.add_argument('--all', action='store_true', help='모든 도메인 번역')

    args = parser.parse_args()

    print("="*60)
    print("Mission 100 - 자동 번역 도구 (ChatGPT)")
    print("="*60)
    print()
    print("⚠️  주의: 이것은 데모 버전입니다.")
    print("    실제 번역을 위해서는 OpenAI API 키가 필요합니다.")
    print("    코드 내 주석을 참고하여 ChatGPT API를 활성화하세요.")
    print()

    if args.all:
        domains_to_translate = DOMAINS
    elif args.domain:
        if args.domain not in DOMAINS:
            print(f"✗ 잘못된 도메인: {args.domain}")
            print(f"  사용 가능: {', '.join(DOMAINS)}")
            return
        domains_to_translate = [args.domain]
    else:
        print("✗ --domain 또는 --all 옵션을 지정하세요")
        parser.print_help()
        return

    total_translated = 0

    for domain in domains_to_translate:
        print(f"\n[{domain}] {args.source} → {args.target}")
        print("-" * 60)

        count = auto_translate_arb(domain, args.source, args.target)
        total_translated += count

        print(f"  ✓ {count}개 키 번역됨")

    print()
    print("="*60)
    print(f"총 {total_translated}개 키 번역 완료")
    print()
    print("다음 단계:")
    print("  1. 번역 결과 검토 및 수정")
    print("  2. python tools/merge_arb_files.py")
    print("  3. flutter gen-l10n")
    print()


if __name__ == '__main__':
    main()
