#!/usr/bin/env python3
"""
Fix goalProgramReady in Korean ARB file to accept parameter
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

    # Update goalProgramReady to accept parameter
    data['goalProgramReady'] = "{goalText}을(를) 위한 맞춤 프로그램이 준비되었습니다!"
    data['@goalProgramReady'] = {
        "placeholders": {
            "goalText": {
                "type": "String"
            }
        }
    }

    # Write back the JSON file
    with open(ko_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print("Updated goalProgramReady in common_ko.arb")

if __name__ == '__main__':
    main()
