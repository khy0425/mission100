#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ARB 파일 Chad 언급 및 딱딱한 말투 완전 수정 스크립트"""

import json
import sys
import codecs
import re

# Windows에서 UTF-8 출력 설정
if sys.platform == 'win32':
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout.buffer, 'strict')
    sys.stderr = codecs.getwriter('utf-8')(sys.stderr.buffer, 'strict')

def fix_all_tone():
    arb_path = '../lib/l10n/app_ko.arb'

    print("ARB 파일 로드 중...")
    with open(arb_path, 'r', encoding='utf-8') as f:
        arb = json.load(f)

    print(f"총 {len(arb)}개 항목 로드됨\n")

    # Edit 도구로 수정할 항목들
    changes = {
        # Chad 직접 언급 제거 (가장 중요한 것들만 먼저)
        "chadSays": "메시지",
        "chadRecommendedWorkout": "🎯 추천 운동",
        "chadConfirmedCondition": "{condition} 컨디션 확인 완료!",
        "chadGlowingEyes": "빛나는눈",
        "chadGlowingEyesDesc": "강력한 힘을 가진 캐릭터다.\n눈에서 빛이 나며 엄청난 파워를 보여준다!",
        "chadTitleCoffee": "커피 파워",
        "chadTitleCool": "스타일 MAX",
        "chadTitleDouble": "더블 파워",
        "chadTitleFront": "정면 돌파",
        "chadTitleLaser": "눈빛 파워",
        "chadTitleSleepy": "수면모자",
        "chadTitleBasic": "기본형",
        "currentChadState": "현재 상태",
        "gigaChad": "Giga 레벨",
        "legendaryChad": "Legendary 레벨",
        "risingChad": "Rising 레벨",
        "rookieChad": "Rookie 레벨",
        "sigmaChad": "Sigma 레벨",
        "ultraChad": "Ultra 레벨",
        "journeyChadEvolution": "여정의 시작",
        "journeyStartingChad": "각성의 시작.\n잠재력이 깨어나고 있다.",
        "perfectChadExperience": "설정을 조정해서 완벽한 경험을 만들어봐",

        # 레벨명에서 Chad 제거
        "levelNameRookie": "Rookie 레벨",
        "levelNameRising": "Rising 레벨",
        "levelNameAlpha": "Alpha 레벨",
        "levelNameSigma": "Sigma 레벨",
        "levelNameGiga": "Giga 레벨",
        "levelNameUltra": "Ultra 레벨",
        "levelNameLegendary": "Legendary 레벨",

        # 딱딱한 말투 수정
        "pushupInclineChad": "🚀 높이는 조절하고 강도는 MAX! 20개 완벽 완성하면 GOD TIER 입장권 획득이다, 만삣삐! 🚀",
    }

    # 변경사항 적용
    modified = []
    for key, new_value in changes.items():
        if key in arb:
            old_value = arb[key]
            if old_value != new_value:
                arb[key] = new_value
                modified.append(key)
                print(f"✓ {key}")
                print(f"  이전: {old_value[:60]}...")
                print(f"  변경: {new_value[:60]}...")
                print()

    print(f"\n총 {len(modified)}개 항목 수정됨")

    # 파일 저장
    print("\nARB 파일 저장 중...")
    with open(arb_path, 'w', encoding='utf-8') as f:
        json.dump(arb, f, ensure_ascii=False, indent=2)

    print("✅ ARB 파일 저장 완료!")

    # 검증
    print("\n파일 형식 검증 중...")
    with open(arb_path, 'r', encoding='utf-8') as f:
        test = json.load(f)
        print(f"✅ JSON 형식 검증 완료! ({len(test)}개 항목)")

    return len(modified)

if __name__ == '__main__':
    count = fix_all_tone()
    print(f"\n🎉 {count}개 수정 완료!")
