#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
pushup_form_guide.json에서 commonMistakes 섹션 제거
화면에서 사용하지 않는 데이터이므로 정리
"""

import json
import os
import sys

# Windows UTF-8 출력
if sys.platform == 'win32':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except:
        pass

def remove_common_mistakes(file_path):
    """commonMistakes 섹션 제거"""

    print(f"\n📝 Processing {file_path}...")

    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # commonMistakes 제거
    if 'commonMistakes' in data:
        removed_count = len(data['commonMistakes'])
        del data['commonMistakes']
        print(f"  ❌ commonMistakes 섹션 제거 ({removed_count}개 항목)")
    else:
        print(f"  ℹ️ commonMistakes 섹션 없음")
        removed_count = 0

    # 파일 저장
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"✅ {file_path} 업데이트 완료!")

    return removed_count

def main():
    base_path = 'E:/Projects/mission100_v3/assets/data'

    files = [
        'pushup_form_guide.json',
        'pushup_form_guide_en.json',
    ]

    total_removed = 0

    print("🗑️ Common Mistakes 섹션 제거 시작...")
    print("=" * 60)

    for filename in files:
        file_path = os.path.join(base_path, filename)
        if os.path.exists(file_path):
            count = remove_common_mistakes(file_path)
            total_removed += count
        else:
            print(f"⚠️ 파일 없음: {file_path}")

    print("\n" + "=" * 60)
    print(f"\n🎉 완료! 총 {total_removed}개 항목 제거")
    print("\n✅ 결과:")
    print("  - commonMistakes 섹션 제거됨")
    print("  - JSON 파일 정리 완료")
    print("  - 화면에서 사용하지 않으므로 앱 동작에 영향 없음")

if __name__ == '__main__':
    main()
