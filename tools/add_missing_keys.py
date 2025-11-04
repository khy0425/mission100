#!/usr/bin/env python3
"""
Add missing localization keys to ARB files
"""

import json
import os

# Define the missing keys for Korean
missing_keys_ko = {
    "googleQuickSignup": "구글로 빠른 가입",
    "competitionTitle": "경쟁과 순위",
    "personalRecordTitle": "개인 기록",
    "chadActivityCompleted": "운동 활동 완료!",
    "todayWorkoutRecommendation": "오늘의 추천 운동",
    "rpeDialogTitle": "운동 강도 평가",
    "rpeDialogSubtitle": "오늘 운동이 얼마나 힘들었나요?",
    "rpeLevel6Title": "매우 쉬움",
    "rpeLevel7Title": "쉬움",
    "rpeLevel8Title": "적당함",
    "rpeLevel9Title": "힘듦",
    "rpeLevel10Title": "최대 강도",
    "rpeLevel6Description": "전혀 힘들지 않았어요",
    "rpeLevel7Description": "조금 힘들었어요",
    "rpeLevel8Description": "적당히 힘들었어요",
    "rpeLevel9Description": "많이 힘들었어요",
    "rpeLevel10Description": "최대로 힘들었어요",
    "signupPromptTitle": "Mission: 100 시작하기",
    "signupPromptMessage": "{goalText}\n\n가입하고 프리미엄 혜택을 받으세요!",
    "@signupPromptMessage": {
        "placeholders": {
            "goalText": {
                "type": "String"
            }
        }
    },
    "signupPromptLaunchEvent": "🎉 런칭 이벤트:",
    "signupPromptBenefit1": "• 1개월 무료 프리미엄",
    "signupPromptBenefit2": "• 전체 14주 프로그램 접근",
    "signupPromptBenefit3": "• 모든 차드 진화 단계",
    "signupPromptBenefit4": "• 상세 통계 및 분석",
    "signupPromptCallToAction": "지금 가입하면 혜택을 받을 수 있어요!",
    "expandAllSteps": "모든 단계 펼치기",
    "noActiveSubscription": "활성화된 구독이 없습니다",
    "subscribeForPremium": "프리미엄 기능을 이용하려면 구독하세요",
    "startSubscriptionButton": "구독 시작하기"
}

# Define the missing keys for English
missing_keys_en = {
    "googleQuickSignup": "Quick Signup with Google",
    "competitionTitle": "Competition & Rankings",
    "personalRecordTitle": "Personal Records",
    "chadActivityCompleted": "Activity Completed!",
    "todayWorkoutRecommendation": "Today's Workout Recommendation",
    "rpeDialogTitle": "Workout Intensity",
    "rpeDialogSubtitle": "How hard was your workout today?",
    "rpeLevel6Title": "Very Easy",
    "rpeLevel7Title": "Easy",
    "rpeLevel8Title": "Moderate",
    "rpeLevel9Title": "Hard",
    "rpeLevel10Title": "Maximum Intensity",
    "rpeLevel6Description": "Not hard at all",
    "rpeLevel7Description": "Slightly hard",
    "rpeLevel8Description": "Moderately hard",
    "rpeLevel9Description": "Very hard",
    "rpeLevel10Description": "Maximum effort",
    "signupPromptTitle": "Start Mission: 100",
    "signupPromptMessage": "{goalText}\n\nSign up and get premium benefits!",
    "@signupPromptMessage": {
        "placeholders": {
            "goalText": {
                "type": "String"
            }
        }
    },
    "signupPromptLaunchEvent": "🎉 Launch Event:",
    "signupPromptBenefit1": "• 1 month free premium",
    "signupPromptBenefit2": "• Access to full 14-week program",
    "signupPromptBenefit3": "• All Chad evolution stages",
    "signupPromptBenefit4": "• Detailed stats and analysis",
    "signupPromptCallToAction": "Sign up now to get these benefits!",
    "expandAllSteps": "Expand All Steps",
    "noActiveSubscription": "No Active Subscription",
    "subscribeForPremium": "Subscribe to access premium features",
    "startSubscriptionButton": "Start Subscription"
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
    ko_added = add_missing_keys(ko_file, missing_keys_ko)
    en_added = add_missing_keys(en_file, missing_keys_en)

    print(f"\nSummary:")
    print(f"  Korean: {ko_added} keys added")
    print(f"  English: {en_added} keys added")

    if ko_added > 0 or en_added > 0:
        print("\nRemember to run:")
        print("  python tools/merge_arb_files.py")
        print("  flutter gen-l10n")

if __name__ == '__main__':
    main()
