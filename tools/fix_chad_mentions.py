#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Chad 직접 언급 제거 스크립트"""

import json
import sys
import codecs

# Windows에서 UTF-8 출력 설정
if sys.platform == 'win32':
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout.buffer, 'strict')
    sys.stderr = codecs.getwriter('utf-8')(sys.stderr.buffer, 'strict')

def fix_chad_mentions():
    arb_path = '../lib/l10n/app_ko.arb'

    with open(arb_path, 'r', encoding='utf-8') as f:
        arb = json.load(f, object_pairs_hook=lambda pairs: pairs)

    changes = {
        # Chad 직접 언급 제거
        "chadGlowingEyes": "빛나는눈",
        "chadGlowingEyesDesc": "강력한 힘을 가진 캐릭터다.\n눈에서 빛이 나며 엄청난 파워를 보여준다!",
        "chadSays": "메시지",
        "chadRecommendedWorkout": "🎯 추천 운동",
        "chadConfirmedCondition": "{condition} 컨디션 확인 완료!",
        "chadTitleCoffee": "커피 파워",
        "chadTitleCool": "스타일 MAX",
        "chadTitleDouble": "더블 파워",
        "chadTitleFront": "정면 돌파",
        "chadTitleLaser": "눈빛 파워",
        "currentChadState": "현재 상태",
        "gigaChad": "Giga 레벨",
        "journeyChadEvolution": "여정의 시작",
        "journeyStartingChad": "각성의 시작.\n잠재력이 깨어나고 있다.",
        "legendaryChad": "Legendary 레벨",
        "perfectChadExperience": "설정을 조정해서 완벽한 경험을 만들어봐",
        "risingChad": "Rising 레벨",
        "rookieChad": "Rookie 레벨",
        "sigmaChad": "Sigma 레벨",
        "ultraChad": "Ultra 레벨",

        # 딱딱한 말투 수정
        "pushupInclineChad": "🚀 높이는 조절하고 강도는 MAX! 20개 완벽 완성하면 GOD TIER 입장권 획득이다, 만삣삐! 🚀",
    }

    # 변경사항 적용
    modified = []
    arb_dict = dict(arb)

    for key, new_value in changes.items():
        if key in arb_dict:
            old_value = arb_dict[key]
            arb_dict[key] = new_value
            modified.append(f"{key}: '{old_value}' → '{new_value}'")
            print(f"✓ {key}")

    # 파일 저장 (순서 유지)
    with open(arb_path, 'w', encoding='utf-8') as f:
        json.dump(arb_dict, f, ensure_ascii=False, indent=2)

    print(f"\n총 {len(modified)}개 항목 수정 완료!")
    return len(modified)

if __name__ == '__main__':
    count = fix_chad_mentions()
    print(f"\n✅ {count}개 수정 완료!")
