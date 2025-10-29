#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Find missing translations between English and Korean ARB files."""

import json
import os
import sys
from pathlib import Path

def main():
    base_dir = Path(__file__).parent.parent
    output_file = base_dir / 'missing_translations.txt'

    # Read merged English file
    with open(base_dir / 'lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
        en_data = json.load(f)
        en_keys = {k for k in en_data.keys() if not k.startswith('@') and k != '@@locale'}

    # Read merged Korean file
    with open(base_dir / 'lib/l10n/app_ko.arb', 'r', encoding='utf-8') as f:
        ko_data = json.load(f)
        ko_keys = {k for k in ko_data.keys() if not k.startswith('@') and k != '@@locale'}

    # Find missing translations
    missing_in_ko = sorted(en_keys - ko_keys)
    missing_in_en = sorted(ko_keys - en_keys)

    # Write to file with UTF-8 encoding
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(f'Total English keys: {len(en_keys)}\n')
        f.write(f'Total Korean keys: {len(ko_keys)}\n')
        f.write(f'\n{"="*80}\n')
        f.write(f'Keys missing in Korean: {len(missing_in_ko)}\n')
        f.write(f'{"="*80}\n\n')

        for key in missing_in_ko:
            value = en_data[key]
            if len(value) > 120:
                value = value[:120] + '...'
            f.write(f'{key}:\n')
            f.write(f'  EN: {value}\n')
            f.write('\n')

        if missing_in_en:
            f.write(f'\n{"="*80}\n')
            f.write(f'Keys missing in English: {len(missing_in_en)}\n')
            f.write(f'{"="*80}\n\n')
            for key in missing_in_en:
                value = ko_data[key]
                if len(value) > 120:
                    value = value[:120] + '...'
                f.write(f'{key}:\n')
                f.write(f'  KO: {value}\n')
                f.write('\n')

    print(f'Results written to: {output_file}')
    print(f'Missing in Korean: {len(missing_in_ko)} keys')
    if missing_in_en:
        print(f'Missing in English: {len(missing_in_en)} keys')

if __name__ == '__main__':
    main()
