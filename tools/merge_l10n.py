#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
L10n ARB File Merger

Merges domain-separated ARB files into unified ARB files.
This allows managing small files while keeping Flutter's gen-l10n working.

Usage:
    python tools/merge_l10n.py

Structure:
    lib/l10n/source/[domain]/[domain]_ko.arb  ->  lib/l10n/app_ko.arb
    lib/l10n/source/[domain]/[domain]_en.arb  ->  lib/l10n/app_en.arb
"""

import json
import os
import sys
from pathlib import Path
from typing import Dict, List, Tuple

# UTF-8 output for Windows
if sys.platform == 'win32':
    import codecs
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout.buffer, 'strict')
    sys.stderr = codecs.getwriter('utf-8')(sys.stderr.buffer, 'strict')


def load_arb_file(file_path: Path) -> Dict:
    """Load an ARB file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"[!] Warning: Failed to load {file_path}: {e}")
        return {}


def merge_arb_files(source_dir: Path, locale: str) -> Dict:
    """
    Merge all domain ARB files for a specific locale.

    Args:
        source_dir: Path to source directory
        locale: 'ko' or 'en'

    Returns:
        Merged ARB dictionary
    """
    merged = {}
    domains = sorted([d for d in source_dir.iterdir() if d.is_dir()])

    print(f"\n[*] Merging {locale.upper()} locale files...")

    for domain_dir in domains:
        domain_name = domain_dir.name
        arb_file = domain_dir / f"{domain_name}_{locale}.arb"

        if not arb_file.exists():
            print(f"  [!] Skipping {domain_name}: {arb_file.name} not found")
            continue

        domain_data = load_arb_file(arb_file)

        if not domain_data:
            print(f"  [!] Skipping {domain_name}: Empty or invalid file")
            continue

        # Check for duplicate keys
        duplicate_keys = set(merged.keys()) & set(domain_data.keys())
        if duplicate_keys:
            print(f"  [!] Warning: Duplicate keys in {domain_name}: {duplicate_keys}")

        # Merge
        merged.update(domain_data)
        key_count = len([k for k in domain_data.keys() if not k.startswith('@')])
        print(f"  [+] {domain_name:15s} -> {key_count:3d} keys")

    return merged


def save_arb_file(data: Dict, output_path: Path) -> None:
    """Save ARB file."""
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)


def get_statistics(arb_data: Dict) -> Tuple[int, int]:
    """
    Get statistics for ARB data.

    Returns:
        (translation keys count, metadata keys count)
    """
    translation_keys = [k for k in arb_data.keys() if not k.startswith('@')]
    metadata_keys = [k for k in arb_data.keys() if k.startswith('@')]
    return len(translation_keys), len(metadata_keys)


def main():
    """Main execution function"""
    # Setup paths
    project_root = Path(__file__).parent.parent
    source_dir = project_root / 'lib' / 'l10n' / 'source'
    output_dir = project_root / 'lib' / 'l10n'

    if not source_dir.exists():
        print(f"[X] Error: Source directory not found: {source_dir}")
        return 1

    print("=" * 60)
    print("L10n ARB File Merger")
    print("=" * 60)

    # Merge Korean and English
    locales = ['ko', 'en']
    results = {}

    for locale in locales:
        merged_data = merge_arb_files(source_dir, locale)
        output_file = output_dir / f"app_{locale}.arb"

        # Save file
        save_arb_file(merged_data, output_file)

        # Statistics
        trans_count, meta_count = get_statistics(merged_data)
        results[locale] = (trans_count, meta_count)

        print(f"\n[*] {locale.upper()} Statistics:")
        print(f"  - Translation keys: {trans_count}")
        print(f"  - Metadata keys:    {meta_count}")
        print(f"  - Total keys:       {trans_count + meta_count}")
        print(f"  - Output:           {output_file.relative_to(project_root)}")

    print("\n" + "=" * 60)
    print("[+] L10n merge completed!")
    print("=" * 60)

    # Final summary
    print("\n[*] Summary:")
    print(f"  - Korean translations:  {results['ko'][0]}")
    print(f"  - English translations: {results['en'][0]}")

    missing = results['ko'][0] - results['en'][0]
    if missing > 0:
        print(f"  [!] Missing EN translations: {missing}")
    elif missing < 0:
        print(f"  [!] Missing KO translations: {abs(missing)}")
    else:
        print(f"  [+] All translations in sync!")

    print("\n[*] Next steps:")
    print("  1. Review the generated files: lib/l10n/app_*.arb")
    print("  2. Run: flutter gen-l10n")
    print("  3. Test the app")

    return 0


if __name__ == '__main__':
    exit(main())
