#!/usr/bin/env python3
"""
Fix tutorial_screen.dart to use AppLocalizations
"""

import os
import re

def main():
    """Main function"""
    # Get the script directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)

    # Define file path
    file_path = os.path.join(project_root, 'lib', 'screens', 'tutorial', 'tutorial_screen.dart')

    # Read the file
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Define all replacements (Korean text -> localization key)
    replacements = [
        # Page 1 - Welcome
        ("'14주 만에 푸시업 100개 달성'", "AppLocalizations.of(context).tutorialWelcomeSubtitle"),
        ("'과학적 근거 기반'", "AppLocalizations.of(context).tutorialFeature1Title"),
        ("'최신 스포츠 과학 논문(2016-2024)을\\n바탕으로 설계된 프로그램'", "AppLocalizations.of(context).tutorialFeature1Desc"),
        ("'점진적 과부하'", "AppLocalizations.of(context).tutorialFeature2Title"),
        ("'매주 체계적으로 증가하는 운동량으로\\n안전하고 효과적인 성장'", "AppLocalizations.of(context).tutorialFeature2Desc"),
        ("'개인화된 프로그램'", "AppLocalizations.of(context).tutorialFeature3Title"),
        ("'당신의 레벨에 맞춘\\n맞춤형 운동 계획'", "AppLocalizations.of(context).tutorialFeature3Desc"),

        # Page 2 - Program Overview
        ("'📋 프로그램 구성'", "AppLocalizations.of(context).tutorialProgramTitle"),
        ("'⏱️ 기간'", "AppLocalizations.of(context).tutorialDurationTitle"),
        ("'14주 (총 42회)'", "AppLocalizations.of(context).tutorialDurationSubtitle"),
        ("'주 3회 운동 (월, 수, 금)\\n48시간 회복 시간 보장'", "AppLocalizations.of(context).tutorialDurationDesc"),
        ("'💪 구성'", "AppLocalizations.of(context).tutorialStructureTitle"),
        ("'푸시업 + 피니셔'", "AppLocalizations.of(context).tutorialStructureSubtitle"),
        ("'메인: 푸시업 5-9세트\\n피니셔: 버피/점프스쿼트 등'", "AppLocalizations.of(context).tutorialStructureDesc"),
        ("'⏳ 휴식 시간'", "AppLocalizations.of(context).tutorialRestTitle"),
        ("'과학적 최적화'", "AppLocalizations.of(context).tutorialRestSubtitle"),
        ("'세트간: 45-120초\\n레벨/주차별 자동 조정'", "AppLocalizations.of(context).tutorialRestDesc"),
        ("'💡 꿀팁'", "AppLocalizations.of(context).tutorialTipTitle"),
        ("'매 운동 후 RPE(운동자각도)를 기록하면\\n다음 운동 강도가 자동으로 조정됩니다!'", "AppLocalizations.of(context).tutorialTipDesc"),

        # Page 3 - Pushup Form
        ("'✅ 올바른 푸시업 자세'", "AppLocalizations.of(context).tutorialFormTitle"),
        ("'1. 시작 자세'", "AppLocalizations.of(context).tutorialForm1Title"),
        ("'손을 어깨 너비로 벌리고\\n몸을 일직선으로 유지'", "AppLocalizations.of(context).tutorialForm1Desc"),
        ("'2. 내려가기'", "AppLocalizations.of(context).tutorialForm2Title"),
        ("'가슴이 바닥에 닿을 때까지\\n팔꿈치를 45도 각도로 구부리기'", "AppLocalizations.of(context).tutorialForm2Desc"),
        ("'3. 올라오기'", "AppLocalizations.of(context).tutorialForm3Title"),
        ("'가슴과 코어에 힘을 주고\\n폭발적으로 밀어올리기'", "AppLocalizations.of(context).tutorialForm3Desc"),
        ("'⚠️ 주의사항'", "AppLocalizations.of(context).tutorialWarningTitle"),
        ("'허리가 처지지 않도록 코어에 힘주기'", "AppLocalizations.of(context).tutorialWarning1"),
        ("'목을 과도하게 젖히지 않기'", "AppLocalizations.of(context).tutorialWarning2"),
        ("'팔꿈치를 몸에 너무 붙이지 않기'", "AppLocalizations.of(context).tutorialWarning3"),
        ("'통증이 느껴지면 즉시 중단'", "AppLocalizations.of(context).tutorialWarning4"),

        # Page 4 - RPE
        ("'📊 RPE란?'", "AppLocalizations.of(context).tutorialRpeTitle"),
        ("'Rate of Perceived Exertion\\n(운동자각도)'", "AppLocalizations.of(context).tutorialRpeSubtitle"),
        ("'😊 너무 쉬워요'", "AppLocalizations.of(context).tutorialRpe6"),
        ("'다음엔 더 할 수 있어요'", "AppLocalizations.of(context).tutorialRpe6Desc"),
        ("'🙂 적당해요'", "AppLocalizations.of(context).tutorialRpe7"),
        ("'딱 좋은 난이도예요'", "AppLocalizations.of(context).tutorialRpe7Desc"),
        ("'😤 힘들어요'", "AppLocalizations.of(context).tutorialRpe8"),
        ("'완료하기 버거웠어요'", "AppLocalizations.of(context).tutorialRpe8Desc"),
        ("'😫 너무 힘들어요'", "AppLocalizations.of(context).tutorialRpe9"),
        ("'거의 불가능했어요'", "AppLocalizations.of(context).tutorialRpe9Desc"),
        ("'🤯 한계 돌파!'", "AppLocalizations.of(context).tutorialRpe10"),
        ("'정말 최선을 다했어요'", "AppLocalizations.of(context).tutorialRpe10Desc"),
        ("'🎯 똑똑한 자동 조정'", "AppLocalizations.of(context).tutorialAutoAdjustTitle"),
        ("'RPE를 기록하면 다음 운동 강도가\\n자동으로 최적화됩니다!\\n\\n• RPE 6-7: 난이도 +5%\\n• RPE 8: 유지\\n• RPE 9-10: 난이도 -5%'", "AppLocalizations.of(context).tutorialAutoAdjustDesc"),

        # Page 5 - Scientific Evidence
        ("'🔬 과학적 근거'", "AppLocalizations.of(context).tutorialScienceTitle"),
        ("'최신 연구 결과를 바탕으로 설계되었습니다'", "AppLocalizations.of(context).tutorialScienceSubtitle"),
        ("'Schoenfeld et al. (2016, 2019)'", "AppLocalizations.of(context).tutorialResearch1Author"),
        ("'근비대와 훈련 빈도'", "AppLocalizations.of(context).tutorialResearch1Topic"),
        ("'주 3회 훈련이 근육 성장에 최적\\n48시간 회복 시간 권장'", "AppLocalizations.of(context).tutorialResearch1Finding"),
        ("'Grgic et al. (2018)'", "AppLocalizations.of(context).tutorialResearch2Author"),
        ("'세트간 휴식 시간'", "AppLocalizations.of(context).tutorialResearch2Topic"),
        ("'60-120초 휴식이\\n근비대에 가장 효과적'", "AppLocalizations.of(context).tutorialResearch2Finding"),
        ("'Plotkin et al. (2022)'", "AppLocalizations.of(context).tutorialResearch3Author"),
        ("'점진적 과부하'", "AppLocalizations.of(context).tutorialResearch3Topic"),
        ("'점진적 반복 증가가\\n근력 향상에 효과적'", "AppLocalizations.of(context).tutorialResearch3Finding"),
        ("'Wang et al. (2024)'", "AppLocalizations.of(context).tutorialResearch4Author"),
        ("'HIIT + 저항운동 병행'", "AppLocalizations.of(context).tutorialResearch4Topic"),
        ("'유산소와 근력운동 병행 시\\n체력과 근력 동시 향상'", "AppLocalizations.of(context).tutorialResearch4Finding"),
    ]

    # Apply all replacements
    for old_text, new_text in replacements:
        content = content.replace(old_text, new_text)

    # Write back the file
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

    print(f"Fixed {len(replacements)} hardcoded texts in tutorial_screen.dart")

if __name__ == '__main__':
    main()
