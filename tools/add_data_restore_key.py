#!/usr/bin/env python3
"""
Add dataRestore key to ARB files
"""

import json
import os

def main():
    """Main function"""
    # Get the script directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)

    # Define file paths
    ko_file = os.path.join(project_root, 'lib', 'l10n', 'source', 'common', 'common_ko.arb')
    en_file = os.path.join(project_root, 'lib', 'l10n', 'source', 'common', 'common_en.arb')

    # Read and update Korean file
    with open(ko_file, 'r', encoding='utf-8') as f:
        ko_data = json.load(f)

    if 'dataRestore' not in ko_data:
        ko_data['dataRestore'] = '• 데이터 복원'
        with open(ko_file, 'w', encoding='utf-8') as f:
            json.dump(ko_data, f, ensure_ascii=False, indent=2)
        print("Added dataRestore to common_ko.arb")
    else:
        print("dataRestore already exists in common_ko.arb")

    # Read and update English file
    with open(en_file, 'r', encoding='utf-8') as f:
        en_data = json.load(f)

    if 'dataRestore' not in en_data:
        en_data['dataRestore'] = '• Data restore'
        with open(en_file, 'w', encoding='utf-8') as f:
            json.dump(en_data, f, ensure_ascii=False, indent=2)
        print("Added dataRestore to common_en.arb")
    else:
        print("dataRestore already exists in common_en.arb")

if __name__ == '__main__':
    main()
