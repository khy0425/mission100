#!/usr/bin/env python3
"""
Add remaining missing localization keys to ARB files
"""

import json
import os

# Define the remaining missing keys for Korean
remaining_keys_ko = {
    # Recovery screen keys
    "chadRecoveryTitle": "Chad 회복 가이드",
    "chadRecoverySettingsTitle": "회복 설정",
    "chadRecoverySettingsSubtitle": "회복 활동 맞춤 설정",
    "chadWeeklyRecoveryReport": "주간 회복 리포트",
    "tomorrowsChadActivity": "내일의 Chad 활동",
    "chadActivityDuration": "{duration}분 활동",
    "@chadActivityDuration": {
        "placeholders": {
            "duration": {
                "type": "String"
            }
        }
    },
    "moreActivities": "더 많은 활동",
    "chadRecoverySettings": "회복 설정",

    # User goals keys
    "goalProgramReady": "프로그램 준비 완료!",
    "signupToAchieveGoal": "목표를 달성하려면 가입하세요",
    "startForFree": "무료로 시작하기",

    # Deep link keys
    "viewAchievement": "업적 보기",
    "chadLevelUpTitle": "Chad 레벨 업!",
    "viewChad": "Chad 보기",

    # Auth key
    "continueWithGoogle": "Google로 계속하기"
}

# Define the remaining missing keys for English
remaining_keys_en = {
    # Recovery screen keys
    "chadRecoveryTitle": "Chad Recovery Guide",
    "chadRecoverySettingsTitle": "Recovery Settings",
    "chadRecoverySettingsSubtitle": "Customize recovery activities",
    "chadWeeklyRecoveryReport": "Weekly Recovery Report",
    "tomorrowsChadActivity": "Tomorrow's Chad Activity",
    "chadActivityDuration": "{duration} min activity",
    "@chadActivityDuration": {
        "placeholders": {
            "duration": {
                "type": "String"
            }
        }
    },
    "moreActivities": "More Activities",
    "chadRecoverySettings": "Recovery Settings",

    # User goals keys
    "goalProgramReady": "Program Ready!",
    "signupToAchieveGoal": "Sign up to achieve your goal",
    "startForFree": "Start for Free",

    # Deep link keys
    "viewAchievement": "View Achievement",
    "chadLevelUpTitle": "Chad Level Up!",
    "viewChad": "View Chad",

    # Auth key
    "continueWithGoogle": "Continue with Google"
}

def add_missing_keys(file_path, missing_keys):
    """Add missing keys to ARB file"""
    print(f"Processing {file_path}...")

    # Read the JSON file
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # Add missing keys
    keys_added = []
    for key, value in missing_keys.items():
        if key not in data:
            data[key] = value
            keys_added.append(key)

    # Write back the JSON file
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"Added {len(keys_added)} keys: {', '.join(keys_added) if keys_added else 'None'}")

    return len(keys_added)

def main():
    """Main function"""
    # Get the script directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)

    # Define file paths
    ko_file = os.path.join(project_root, 'lib', 'l10n', 'source', 'common', 'common_ko.arb')
    en_file = os.path.join(project_root, 'lib', 'l10n', 'source', 'common', 'common_en.arb')

    # Add missing keys
    ko_added = add_missing_keys(ko_file, remaining_keys_ko)
    en_added = add_missing_keys(en_file, remaining_keys_en)

    print(f"\nSummary:")
    print(f"  Korean: {ko_added} keys added")
    print(f"  English: {en_added} keys added")

    if ko_added > 0 or en_added > 0:
        print("\nNext steps:")
        print("  1. python tools/merge_arb_files.py")
        print("  2. flutter gen-l10n")
        print("  3. Fix const errors in Dart files")

if __name__ == '__main__':
    main()
