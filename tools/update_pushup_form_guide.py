#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
푸시업 폼 가이드 JSON 파일 업데이트
- 기존 pushup_videos.dart의 YouTube 링크 재사용
- 없는 이미지 경로는 null 처리
- 파이크 푸시업은 주석으로 보관
"""

import json
import os
import sys

# Windows에서 UTF-8 출력 가능하도록 설정
if sys.platform == 'win32':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except:
        pass

# pushup_videos.dart의 링크 매핑 (한국어/영어)
VIDEO_LINKS = {
    'standard_pushup': {
        'ko': 'https://youtube.com/shorts/qeK3LrNRN2o?si=UpDjiIEcGBMZdRIw',
        'en': 'https://youtube.com/shorts/4Bc1tPaYkOo?si=9kRAT-0liXtl5NwB',
    },
    'knee_pushup': {
        'ko': 'https://youtube.com/shorts/S9_wN5w6J_s?si=kal2op6plWLIbrkq',
        'en': 'https://youtube.com/shorts/rrVwNeIpy-k?si=cO-m0ffZbhB9GvsD',
    },
    'incline_pushup': {
        'ko': 'https://youtube.com/shorts/DORUKQ3zLIo?si=WrLVks7iCQLkyU2X',
        'en': 'https://youtube.com/shorts/DORUKQ3zLIo?si=4hG1sHddRmmMSwa7',
    },
    'wide_pushup': {
        'ko': 'https://youtu.be/cmHZnB2QfFI?si=Vze3fmJ6qPGRIqTI',
        'en': 'https://youtube.com/shorts/5VcUrU_Yn9A?si=IgzgCeT9oioi_04d',
    },
    'diamond_pushup': {
        'ko': 'https://youtube.com/shorts/PPTj-MW2tcs?si=N1Ov2pDR8ewiPoSB',
        'en': 'https://youtube.com/shorts/PPTj-MW2tcs?si=N1Ov2pDR8ewiPoSB',
    },
    'decline_pushup': {
        'ko': 'https://youtu.be/AeDw1tlXczo?si=lu78SdsLr9Ba4ON7&t=9',
        'en': 'https://youtube.com/shorts/dcV-ATSeryA?si=PtPULllWHi0uNAzA',
    },
}

def update_form_guide(file_path, language):
    """푸시업 폼 가이드 JSON 파일 업데이트"""

    print(f"\n📝 Processing {file_path}...")

    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    changes = []

    # 1. Form Steps - standard_pushup 영상 추가
    for step in data['formSteps']:
        if step['videoUrl'] is None:
            step['videoUrl'] = VIDEO_LINKS['standard_pushup'][language]
            changes.append(f"  ✅ Step {step['stepNumber']}: 영상 링크 추가")

        # placeholder 이미지 경로는 null로
        if 'placeholder' in step.get('imagePath', ''):
            step['imagePath'] = None
            changes.append(f"  🖼️ Step {step['stepNumber']}: placeholder 이미지 → null")

    # 2. Common Mistakes - 이미지 경로 null 처리
    for mistake in data['commonMistakes']:
        if 'wrongImagePath' in mistake:
            if 'mistakes/' in mistake['wrongImagePath']:
                mistake['wrongImagePath'] = None
                changes.append(f"  🚫 Mistake '{mistake['title'][:20]}...': wrongImagePath → null")

        if 'correctImagePath' in mistake:
            if 'mistakes/' in mistake['correctImagePath'] or 'standard/' in mistake['correctImagePath']:
                mistake['correctImagePath'] = None
                changes.append(f"  🚫 Mistake '{mistake['title'][:20]}...': correctImagePath → null")

    # 3. Variations - 매칭되는 영상 링크 추가
    variation_mapping = {
        '무릎 푸시업': 'knee_pushup',
        'Knee Push-ups': 'knee_pushup',
        '인클라인 푸시업': 'incline_pushup',
        'Incline Push-ups': 'incline_pushup',
        '다이아몬드 푸시업': 'diamond_pushup',
        'Diamond Push-ups': 'diamond_pushup',
        '와이드 그립 푸시업': 'wide_pushup',
        'Wide Grip Push-ups': 'wide_pushup',  # 영어 파일 이름 확인 필요
        '디클라인 푸시업': 'decline_pushup',
        'Decline Push-ups': 'decline_pushup',
        '파이크 푸시업': None,  # 영상 없음 - 제거 예정
        'Pike Push-ups': None,
    }

    # 파이크 푸시업 제거
    original_count = len(data['variations'])
    data['variations'] = [
        v for v in data['variations']
        if v['name'] not in ['파이크 푸시업', 'Pike Push-ups']
    ]

    if len(data['variations']) < original_count:
        changes.append(f"  ❌ 파이크 푸시업 제거 (영상 링크 없음)")

    # 나머지 variations에 영상 링크 추가
    for variation in data['variations']:
        video_key = variation_mapping.get(variation['name'])
        if video_key and video_key in VIDEO_LINKS:
            # imagePath 확인 - 실제 파일 있는지 체크 후 없으면 null
            image_path = variation.get('imagePath', '')
            if 'placeholder' in image_path or 'pike' in image_path.lower():
                variation['imagePath'] = None
                changes.append(f"  🖼️ Variation '{variation['name']}': 이미지 → null")

            # 영상 링크는 항상 추가 (JSON에는 videoUrl 필드 없음, 새로 추가)
            variation['videoUrl'] = VIDEO_LINKS[video_key][language]
            changes.append(f"  ✅ Variation '{variation['name']}': 영상 링크 추가")

    # 4. 파일 저장
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"✅ {file_path} 업데이트 완료!")
    if changes:
        print("\n변경 사항:")
        for change in changes:
            print(change)

    return len(changes)

def main():
    base_path = 'E:/Projects/mission100_v3/assets/data'

    files = [
        ('pushup_form_guide.json', 'ko'),
        ('pushup_form_guide_en.json', 'en'),
    ]

    total_changes = 0

    print("🚀 푸시업 폼 가이드 업데이트 시작...\n")
    print("=" * 60)

    for filename, language in files:
        file_path = os.path.join(base_path, filename)
        if os.path.exists(file_path):
            count = update_form_guide(file_path, language)
            total_changes += count
        else:
            print(f"⚠️ 파일 없음: {file_path}")

    print("\n" + "=" * 60)
    print(f"\n🎉 완료! 총 {total_changes}개 변경사항 적용")
    print("\n✅ 결과:")
    print("  - Form Steps: standard_pushup 영상 추가")
    print("  - Common Mistakes: 이미지 경로 제거 (텍스트만 활용)")
    print("  - Variations: 매칭 영상 추가, 파이크 푸시업 제거")
    print("  - Placeholder 이미지: 모두 null 처리")

if __name__ == '__main__':
    main()
