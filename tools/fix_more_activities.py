#!/usr/bin/env python3
"""
Fix moreActivities in ARB files to accept parameter
"""

import json
import os

def fix_arb_file(file_path, text_ko, text_en):
    """Fix moreActivities in ARB file"""
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # Update moreActivities to accept parameter
    is_korean = '_ko.arb' in file_path
    data['moreActivities'] = text_ko if is_korean else text_en
    data['@moreActivities'] = {
        "placeholders": {
            "count": {
                "type": "String"
            }
        }
    }

    # Write back the JSON file
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"Updated moreActivities in {os.path.basename(file_path)}")

def main():
    """Main function"""
    # Get the script directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)

    # Define file paths
    ko_file = os.path.join(project_root, 'lib', 'l10n', 'source', 'common', 'common_ko.arb')
    en_file = os.path.join(project_root, 'lib', 'l10n', 'source', 'common', 'common_en.arb')

    # Fix both files
    fix_arb_file(ko_file, "+ {count}개 더 보기", "+ {count} more")
    fix_arb_file(en_file, "+ {count}개 더 보기", "+ {count} more")

if __name__ == '__main__':
    main()
