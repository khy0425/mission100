#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Categorize missing translation keys by domain."""

import json
import os
from pathlib import Path
from collections import defaultdict

def main():
    base_dir = Path(__file__).parent.parent
    source_dir = base_dir / 'lib/l10n/source'

    # Read merged files
    with open(base_dir / 'lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
        en_data = json.load(f)
        en_keys = {k for k in en_data.keys() if not k.startswith('@') and k != '@@locale'}

    with open(base_dir / 'lib/l10n/app_ko.arb', 'r', encoding='utf-8') as f:
        ko_data = json.load(f)
        ko_keys = {k for k in ko_data.keys() if not k.startswith('@') and k != '@@locale'}

    # Find missing keys
    missing_in_ko = sorted(en_keys - ko_keys)
    missing_in_en = sorted(ko_keys - en_keys)

    # Load all English source files to determine domains
    domain_keys = {}
    for domain_dir in source_dir.iterdir():
        if domain_dir.is_dir():
            domain_name = domain_dir.name
            en_file = domain_dir / f'{domain_name}_en.arb'
            if en_file.exists():
                with open(en_file, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    keys = {k for k in data.keys() if not k.startswith('@') and k != '@@locale'}
                    domain_keys[domain_name] = keys

    # Categorize missing keys by domain
    missing_by_domain = defaultdict(list)
    for key in missing_in_ko:
        found = False
        for domain_name, keys in domain_keys.items():
            if key in keys:
                missing_by_domain[domain_name].append((key, en_data[key]))
                found = True
                break
        if not found:
            missing_by_domain['unknown'].append((key, en_data[key]))

    # Same for missing English keys
    missing_en_by_domain = defaultdict(list)
    for key in missing_in_en:
        found = False
        for domain_name, keys in domain_keys.items():
            # Check Korean files
            ko_file = source_dir / domain_name / f'{domain_name}_ko.arb'
            if ko_file.exists():
                with open(ko_file, 'r', encoding='utf-8') as f:
                    ko_domain_data = json.load(f)
                    if key in ko_domain_data:
                        missing_en_by_domain[domain_name].append((key, ko_data[key]))
                        found = True
                        break
        if not found:
            missing_en_by_domain['unknown'].append((key, ko_data[key]))

    # Write results
    output_file = base_dir / 'missing_translations_by_domain.txt'
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(f'MISSING KOREAN TRANSLATIONS: {len(missing_in_ko)} keys\n')
        f.write('='*80 + '\n\n')

        for domain in sorted(missing_by_domain.keys()):
            items = missing_by_domain[domain]
            f.write(f'Domain: {domain} ({len(items)} keys)\n')
            f.write('-'*80 + '\n')
            for key, value in items:
                if len(value) > 100:
                    value = value[:100] + '...'
                f.write(f'  {key}: {value}\n')
            f.write('\n')

        if missing_in_en:
            f.write(f'\n{"="*80}\n')
            f.write(f'MISSING ENGLISH TRANSLATIONS: {len(missing_in_en)} keys\n')
            f.write('='*80 + '\n\n')

            for domain in sorted(missing_en_by_domain.keys()):
                items = missing_en_by_domain[domain]
                f.write(f'Domain: {domain} ({len(items)} keys)\n')
                f.write('-'*80 + '\n')
                for key, value in items:
                    if len(value) > 100:
                        value = value[:100] + '...'
                    f.write(f'  {key}: {value}\n')
                f.write('\n')

    print(f'Results written to: {output_file}')
    print(f'\nMissing Korean translations by domain:')
    for domain in sorted(missing_by_domain.keys()):
        print(f'  {domain}: {len(missing_by_domain[domain])} keys')

    if missing_en_by_domain:
        print(f'\nMissing English translations by domain:')
        for domain in sorted(missing_en_by_domain.keys()):
            print(f'  {domain}: {len(missing_en_by_domain[domain])} keys')

if __name__ == '__main__':
    main()
