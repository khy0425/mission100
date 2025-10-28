#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ARB 파일 완전 수정 스크립트 - Chad 언급 + 딱딱한 말투 모두 수정"""

import json
import sys
import codecs

# Windows에서 UTF-8 출력 설정
if sys.platform == 'win32':
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout.buffer, 'strict')
    sys.stderr = codecs.getwriter('utf-8')(sys.stderr.buffer, 'strict')

def complete_fix():
    arb_path = '../lib/l10n/app_ko.arb'

    print("ARB 파일 로드 중...")
    with open(arb_path, 'r', encoding='utf-8') as f:
        arb = json.load(f)

    print(f"총 {len(arb)}개 항목 로드됨\n")

    # 모든 수정사항
    changes = {
        # Chad 직접 언급 제거 (28개)
        "chadSleepyCap": "수면모자",
        "chadBasic": "기본형",
        "chadCoffee": "커피 파워",
        "chadFrontFacing": "정면 돌파",
        "chadSunglasses": "스타일 MAX",
        "chadDouble": "더블 파워",
        "chadSleepyCapDesc": "여정을 시작하는 단계다.\n아직 잠이 덜 깼지만 곧 깨어날 거야!",
        "chadBasicDesc": "첫 진화 완료!\n기초 다지기 시작! 🔥",
        "chadCoffeeDesc": "에너지 MAX!\n커피 파워로 더 강해졌다! ☕💪",
        "chadFrontFacingDesc": "자신감 폭발!\n정면 돌파 준비 완료! 💪",
        "chadSunglassesDesc": "스타일 MAX!\n멋도 실력이다! 😎",
        "chadDoubleDesc": "최종 진화 완료! 전설 등극!\n2배 파워로 모든 걸 정복한다! 👑",
        "sleepyHatChad": "수면모자",
        "chadEvolutionCompleteNotification": "진화 완료 알림",
        "chadEvolutionPreviewNotification": "진화 예고 알림",
        "chadEvolutionQuarantineNotification": "진화 격리 알림",
        "sleepyChadEvolution": "수면모자 진화",
        "chadEvolutionNotifications": "진화 완료 알림",
        "chadEvolutionNotificationsDesc": "새로운 단계로 진화했을 때 알림받기",
        "chadEvolutionPreviewNotifications": "진화 예고 알림",
        "chadEvolutionEncouragementNotifications": "진화 격려 알림",
        "chadEvolutionStage": "진화단계",
        "chadEvolutionStages": "진화 단계",
        "alphaChad": "알파 레벨",
        "chadAchievements": "업적",
        "chadEvolution": "진화",
        "copyrightMission100": "© 2024 Mission 100 Team\n모든 권리 보유\n\n💪 강자가 되는 그 날까지!",
        "chadEvolutionStatus": "• 진화 상태",

        # 딱딱한 말투 수정
        "congratulations": "축하한다!",
        "scientificFact2Content": "푸시업은 근육 내 미토콘드리아 밀도를 최대 40% 증가시켜 에너지 생산을 극대화한다.",
        "scientificFact2Explanation": "미토콘드리아는 세포의 발전소로, 증가하면 피로도가 현저히 감소한다.",
        "firstWorkoutMessage": "첫 운동 시작이다! 화이팅!",
        "programCompletedMessage": "프로그램 완료! 정말 대단하다!",
    }

    # 변경사항 적용
    modified = 0
    for key, new_value in changes.items():
        if key in arb:
            old_value = arb[key]
            if old_value != new_value:
                arb[key] = new_value
                modified += 1
                print(f"✓ {key}")

    print(f"\n총 {modified}개 항목 수정됨")

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

    return modified

if __name__ == '__main__':
    count = complete_fix()
    print(f"\n🎉 {count}개 수정 완료!")
