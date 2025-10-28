"""
Chad Evolution GIF Generator

9단계 Chad 진화 이미지를 GIF 애니메이션으로 생성합니다.
"""

from PIL import Image
import os
from pathlib import Path

def create_evolution_gif(
    duration=500,
    output_name='complete_evolution.gif',
    optimize=True,
    quality=95
):
    """
    Chad 진화 GIF를 생성합니다.

    Args:
        duration (int): 각 프레임의 지속 시간 (밀리초)
        output_name (str): 출력 파일명
        optimize (bool): 파일 크기 최적화 여부
        quality (int): 이미지 품질 (1-95, 높을수록 고품질)
    """

    # 프로젝트 루트에서 evolution 폴더 경로
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    evolution_path = project_root / 'assets' / 'images' / 'chad' / 'evolution'

    # 뇌절 진화 순서 (밈 스타일)
    # "처음부터 Chad, 점점 더 Chad"
    sequence = [
        'basic_chad.png',       # Level 1: 기본 Chad (이미 완벽)
        'smiling_chad.png',     # Level 2: 미소 Chad (웃어도 Chad)
        'coffee_chad.png',      # Level 3: 커피 Chad (여유)
        'wink_chad.png',        # Level 4: 윙크 Chad (치명적)
        'sunglasses_chad.png',  # Level 5: 썬글라스 Chad (쿨함)
        'laser_eyes_chad.png',  # Level 6: 레이저 눈 Chad (뇌절 시작)
        'double_chad.png',      # Level 7: 더블 Chad (뇌절 가속)
        'alpha_chad.png',       # Level 8: 알파 Chad (지배자)
        'god_chad.png'          # Level 9: 신 Chad (최종 뇌절)
    ]

    print("=" * 60)
    print("🎬 Chad Evolution GIF Generator")
    print("=" * 60)
    print(f"📁 소스 경로: {evolution_path}")
    print(f"⏱️  프레임 지속시간: {duration}ms")
    print(f"📦 최적화: {'ON' if optimize else 'OFF'}")
    print(f"🎨 품질: {quality}")
    print("=" * 60)

    # 이미지 로드 및 검증
    images = []
    missing_files = []

    for i, filename in enumerate(sequence, 1):
        filepath = evolution_path / filename

        if not filepath.exists():
            missing_files.append(filename)
            print(f"❌ Level {i}: {filename} - 파일 없음")
            continue

        try:
            img = Image.open(filepath)

            # 이미지 정보 출력
            print(f"✅ Level {i}: {filename}")
            print(f"   └─ 크기: {img.size[0]}x{img.size[1]}")
            print(f"   └─ 모드: {img.mode}")

            # RGB로 변환 (GIF는 RGBA를 잘 지원하지 않음)
            if img.mode in ('RGBA', 'LA', 'P'):
                # 투명 배경을 흰색으로 변환
                if img.mode == 'RGBA':
                    background = Image.new('RGB', img.size, (255, 255, 255))
                    background.paste(img, mask=img.split()[3])  # 3은 알파 채널
                    img = background
                else:
                    img = img.convert('RGB')
                print(f"   └─ RGB로 변환됨")

            images.append(img)

        except Exception as e:
            print(f"❌ Level {i}: {filename} - 로드 실패: {e}")
            missing_files.append(filename)

    # 파일 누락 확인
    if missing_files:
        print("\n" + "=" * 60)
        print("⚠️  경고: 다음 파일이 누락되었습니다:")
        for f in missing_files:
            print(f"   - {f}")
        print("=" * 60)

        if len(images) < 2:
            print("\n❌ 오류: GIF 생성에 최소 2개의 이미지가 필요합니다.")
            return False

    # GIF 생성
    if images:
        output_path = evolution_path / output_name

        print(f"\n🎬 GIF 생성 중...")
        print(f"   └─ 총 프레임: {len(images)}")
        print(f"   └─ 총 재생시간: {len(images) * duration / 1000:.1f}초")

        try:
            images[0].save(
                output_path,
                save_all=True,
                append_images=images[1:],
                duration=duration,
                loop=0,  # 무한 반복
                optimize=optimize,
                quality=quality
            )

            # 파일 크기 확인
            file_size = output_path.stat().st_size
            file_size_mb = file_size / (1024 * 1024)

            print("\n" + "=" * 60)
            print("✅ GIF 생성 완료!")
            print("=" * 60)
            print(f"📁 출력 경로: {output_path}")
            print(f"📦 파일 크기: {file_size_mb:.2f} MB ({file_size:,} bytes)")
            print(f"🎞️  총 프레임: {len(images)}개")
            print(f"⏱️  재생 시간: {len(images) * duration / 1000:.1f}초")
            print(f"🔁 반복: 무한")
            print("=" * 60)

            return True

        except Exception as e:
            print(f"\n❌ GIF 생성 실패: {e}")
            return False
    else:
        print("\n❌ 로드된 이미지가 없습니다.")
        return False


def create_multiple_versions():
    """여러 버전의 GIF를 한 번에 생성합니다."""

    versions = [
        {
            'output_name': 'evolution_slow.gif',
            'duration': 800,
            'description': '느린 버전 (0.8초/프레임)'
        },
        {
            'output_name': 'evolution_normal.gif',
            'duration': 500,
            'description': '보통 속도 (0.5초/프레임)'
        },
        {
            'output_name': 'evolution_fast.gif',
            'duration': 300,
            'description': '빠른 버전 (0.3초/프레임)'
        },
        {
            'output_name': 'evolution_ultra_fast.gif',
            'duration': 150,
            'description': '매우 빠른 버전 (0.15초/프레임)'
        }
    ]

    print("\n🚀 여러 버전의 GIF 생성을 시작합니다...\n")

    results = []
    for i, config in enumerate(versions, 1):
        print(f"\n{'='*60}")
        print(f"📹 버전 {i}/{len(versions)}: {config['description']}")
        print(f"{'='*60}\n")

        success = create_evolution_gif(
            duration=config['duration'],
            output_name=config['output_name']
        )

        results.append({
            'name': config['output_name'],
            'success': success
        })

    # 최종 결과 요약
    print("\n\n" + "=" * 60)
    print("📊 생성 결과 요약")
    print("=" * 60)

    for result in results:
        status = "✅ 성공" if result['success'] else "❌ 실패"
        print(f"{status}: {result['name']}")

    print("=" * 60)


if __name__ == '__main__':
    import sys

    if len(sys.argv) > 1:
        if sys.argv[1] == '--multiple' or sys.argv[1] == '-m':
            # 여러 버전 생성
            create_multiple_versions()
        elif sys.argv[1] == '--help' or sys.argv[1] == '-h':
            print("""
Chad Evolution GIF Generator

사용법:
    python create_evolution_gif.py              # 기본 GIF 생성 (500ms)
    python create_evolution_gif.py --multiple   # 여러 속도 버전 생성
    python create_evolution_gif.py --help       # 도움말 표시

옵션:
    --multiple, -m    : 4가지 속도로 GIF 생성 (느림, 보통, 빠름, 매우빠름)
    --help, -h        : 도움말 표시

예제:
    python create_evolution_gif.py
    python create_evolution_gif.py -m
            """)
        else:
            try:
                duration = int(sys.argv[1])
                output_name = sys.argv[2] if len(sys.argv) > 2 else 'complete_evolution.gif'
                create_evolution_gif(duration=duration, output_name=output_name)
            except ValueError:
                print("❌ 오류: 지속시간은 숫자여야 합니다.")
                print("사용법: python create_evolution_gif.py [duration] [output_name]")
    else:
        # 기본 버전 생성
        create_evolution_gif()
