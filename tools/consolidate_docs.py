#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
문서 통합 도구
같은 주제의 여러 문서를 하나의 포괄적인 가이드로 통합합니다.
"""

import os
import sys
import shutil
from pathlib import Path
from datetime import datetime

# Windows 인코딩 문제 해결
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

# 통합 규칙 정의
CONSOLIDATION_GROUPS = {
    'assets': {
        'output': 'ASSETS_COMPLETE_GUIDE.md',
        'destination': 'docs/assets/',
        'sources': [
            ('docs/ASSETS.md', '전체 에셋 개요'),
            ('docs/CHAD_ASSET_CREATION.md', 'Chad 캐릭터 생성'),
            ('docs/ASSET_CREATION_GUIDE.md', '푸시업 폼 가이드'),
            ('docs/APP_STORE_IMAGES_GUIDE.md', '앱 스토어 이미지'),
        ],
        'description': '모든 에셋 제작 가이드를 하나로 통합'
    },
    'midjourney': {
        'output': 'MIDJOURNEY_COMPLETE_GUIDE.md',
        'destination': 'docs/assets/',
        'sources': [
            ('docs/MIDJOURNEY_PROMPTS.md', 'MidJourney 상세 가이드'),
            ('docs/MIDJOURNEY_READY_PROMPTS.txt', '바로 사용 가능한 프롬프트'),
        ],
        'description': 'MidJourney 가이드 + 프롬프트를 하나로'
    },
    'marketing': {
        'output': 'MARKETING_GUIDE.md',
        'destination': 'docs/deployment/',
        'sources': [
            ('docs/ASO_KEYWORDS.md', 'ASO 키워드 전략'),
            ('docs/VIDEO_PRODUCTION_GUIDE.md', '운동 비디오 제작'),
        ],
        'description': '마케팅 관련 가이드 통합'
    }
}


def read_file(filepath):
    """파일 내용 읽기"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            return f.read()
    except Exception as e:
        print(f"  ⚠️  읽기 실패: {filepath} - {e}")
        return None


def create_consolidated_doc(group_name, config):
    """통합 문서 생성"""
    print(f"\n{'='*60}")
    print(f"📄 {config['output']} 생성 중...")
    print(f"{'='*60}")

    # 헤더 생성
    title = config['output'].replace('_', ' ').replace('.md', '')
    content = f"""# {title}

> 통합 가이드 - {config['description']}

**생성일**: {datetime.now().strftime('%Y-%m-%d')}
**포함 문서**: {len(config['sources'])}개

---

## 📋 목차

"""

    # 목차 생성
    for idx, (source_path, description) in enumerate(config['sources'], 1):
        section_id = description.lower().replace(' ', '-').replace('/', '-')
        content += f"{idx}. [{description}](#{section_id})\n"

    content += "\n---\n\n"

    # 각 소스 문서 내용 추가
    for idx, (source_path, description) in enumerate(config['sources'], 1):
        print(f"  [{idx}/{len(config['sources'])}] {description}...")

        source_content = read_file(source_path)
        if not source_content:
            content += f"\n\n## {idx}. {description}\n\n❌ 문서를 찾을 수 없습니다: `{source_path}`\n\n"
            continue

        # 섹션 추가
        content += f"\n\n## {idx}. {description}\n\n"
        content += f"> **원본 문서**: `{source_path}`\n\n"
        content += "---\n\n"

        # 원본 내용의 헤더 레벨 조정 (# → ###)
        lines = source_content.split('\n')
        adjusted_lines = []

        for line in lines:
            # 맨 첫 줄 제목은 건너뛰기
            if line.startswith('# ') and len(adjusted_lines) == 0:
                continue
            # 헤더 레벨 조정
            elif line.startswith('# '):
                adjusted_lines.append('###' + line[1:])
            elif line.startswith('## '):
                adjusted_lines.append('####' + line[2:])
            elif line.startswith('### '):
                adjusted_lines.append('#####' + line[3:])
            else:
                adjusted_lines.append(line)

        content += '\n'.join(adjusted_lines)
        content += "\n\n---\n\n"

    # 푸터 추가
    content += f"""
## 🔗 관련 문서

"""

    for source_path, description in config['sources']:
        content += f"- [{description}]({source_path})\n"

    content += f"""

---

**마지막 업데이트**: {datetime.now().strftime('%Y-%m-%d %H:%M')}
**관리**: 자동 생성 (tools/consolidate_docs.py)
"""

    # 파일 저장
    output_path = Path(config['destination']) / config['output']
    output_path.parent.mkdir(parents=True, exist_ok=True)

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(content)

    print(f"  ✅ 생성 완료: {output_path}")
    print(f"  📊 크기: {len(content):,} bytes")

    return output_path


def archive_original_files(config):
    """원본 파일들을 archive로 이동"""
    archived = []

    for source_path, description in config['sources']:
        if not Path(source_path).exists():
            continue

        # archive 경로 생성
        archive_path = Path('docs/archive') / Path(source_path).name

        try:
            shutil.move(source_path, archive_path)
            archived.append((source_path, archive_path))
            print(f"  📦 {Path(source_path).name} → archive/")
        except Exception as e:
            print(f"  ⚠️  이동 실패: {source_path} - {e}")

    return archived


def preview_consolidation():
    """통합 계획 미리보기"""
    print("\n" + "="*60)
    print("📄 문서 통합 계획")
    print("="*60)

    total_sources = sum(len(config['sources']) for config in CONSOLIDATION_GROUPS.values())

    print(f"\n📊 통계:")
    print(f"  - 통합 그룹: {len(CONSOLIDATION_GROUPS)}개")
    print(f"  - 원본 문서: {total_sources}개")
    print(f"  - 생성 문서: {len(CONSOLIDATION_GROUPS)}개")
    print(f"  - 감소: {total_sources - len(CONSOLIDATION_GROUPS)}개")

    for group_name, config in CONSOLIDATION_GROUPS.items():
        print(f"\n{'-'*60}")
        print(f"📁 그룹: {group_name}")
        print(f"  출력: {config['output']}")
        print(f"  위치: {config['destination']}")
        print(f"  설명: {config['description']}")
        print(f"  통합할 문서 ({len(config['sources'])}개):")

        for source_path, description in config['sources']:
            exists = "✅" if Path(source_path).exists() else "❌"
            print(f"    {exists} {description} ({source_path})")

    print("\n" + "="*60)
    print(f"\n최종 결과:")
    print(f"  {total_sources}개 문서 → {len(CONSOLIDATION_GROUPS)}개 통합 가이드")
    print(f"  원본 파일들은 docs/archive/로 이동됩니다")
    print("="*60)


def execute_consolidation():
    """통합 실행"""
    print("\n" + "="*60)
    print("🚀 문서 통합 실행 중...")
    print("="*60)

    created_files = []
    archived_files = []

    # 각 그룹별로 통합
    for group_name, config in CONSOLIDATION_GROUPS.items():
        print(f"\n[{group_name.upper()}] 그룹 처리 중...")

        # 통합 문서 생성
        output_path = create_consolidated_doc(group_name, config)
        created_files.append(output_path)

        # 원본 파일 archive로 이동
        print(f"\n  원본 파일 정리 중...")
        archived = archive_original_files(config)
        archived_files.extend(archived)

    # 결과 요약
    print("\n" + "="*60)
    print("✅ 문서 통합 완료!")
    print("="*60)

    print(f"\n📝 생성된 통합 문서 ({len(created_files)}개):")
    for file_path in created_files:
        print(f"  ✅ {file_path}")

    print(f"\n📦 Archive로 이동된 파일 ({len(archived_files)}개):")
    for source, dest in archived_files:
        print(f"  📦 {Path(source).name}")

    print(f"\n새 문서 구조:")
    print(f"  docs/")
    print(f"  ├── assets/")
    print(f"  │   ├── ASSETS_COMPLETE_GUIDE.md")
    print(f"  │   └── MIDJOURNEY_COMPLETE_GUIDE.md")
    print(f"  ├── deployment/")
    print(f"  │   └── MARKETING_GUIDE.md")
    print(f"  └── archive/")
    print(f"      └── {len(archived_files)}개 원본 문서")


def main():
    """메인 함수"""
    import sys

    if len(sys.argv) > 1 and sys.argv[1] == '--execute':
        execute_consolidation()
    else:
        preview_consolidation()
        print(f"\n실행하려면: python {sys.argv[0]} --execute")


if __name__ == '__main__':
    main()
