#!/usr/bin/env python3
"""
Fix chadActivityCompleted in Korean ARB file to accept parameter
"""

import json
import os

def main():
    """Main function"""
    # Get the script directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)

    # Define file path
    ko_file = os.path.join(project_root, 'lib', 'l10n', 'source', 'common', 'common_ko.arb')

    # Read the JSON file
    with open(ko_file, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # Update chadActivityCompleted to accept parameter
    data['chadActivityCompleted'] = "{activityTitle} 완료! Chad가 자랑스러워해! 💪"
    data['@chadActivityCompleted'] = {
        "placeholders": {
            "activityTitle": {
                "type": "String"
            }
        }
    }

    # Write back the JSON file
    with open(ko_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print("Updated chadActivityCompleted in common_ko.arb")
    print("\nNext steps:")
    print("  1. python tools/merge_arb_files.py")
    print("  2. flutter gen-l10n")

if __name__ == '__main__':
    main()
