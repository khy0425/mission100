#!/usr/bin/env python3
"""
푸쉬업 폼 가이드용 플레이스홀더 이미지 생성 스크립트
실제 에셋 제작 전까지 사용할 임시 이미지 생성
"""

from PIL import Image, ImageDraw, ImageFont
import os

# 색상 정의
COLORS = {
    'background': '#0D0D0D',
    'primary': '#4DABF7',
    'success': '#51CF66',
    'warning': '#FFD43B',
    'error': '#FF6B6B',
    'text': '#FFFFFF'
}

def create_placeholder(
    width=1080,
    height=1080,
    text="PLACEHOLDER",
    color='#4DABF7',
    filename='placeholder.png'
):
    """플레이스홀더 이미지 생성"""

    # 이미지 생성
    img = Image.new('RGB', (width, height), COLORS['background'])
    draw = ImageDraw.Draw(img)

    # 테두리
    border_width = 10
    draw.rectangle(
        [border_width, border_width, width-border_width, height-border_width],
        outline=color,
        width=border_width
    )

    # 대각선
    draw.line([(0, 0), (width, height)], fill=color, width=3)
    draw.line([(width, 0), (0, height)], fill=color, width=3)

    # 중앙 원
    center_x, center_y = width // 2, height // 2
    radius = min(width, height) // 4
    draw.ellipse(
        [center_x-radius, center_y-radius, center_x+radius, center_y+radius],
        outline=color,
        width=5
    )

    # 텍스트
    try:
        font = ImageFont.truetype("arial.ttf", 60)
    except:
        font = ImageFont.load_default()

    # 텍스트 크기 계산
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]

    text_x = (width - text_width) // 2
    text_y = (height - text_height) // 2

    # 텍스트 그림자
    draw.text((text_x+3, text_y+3), text, fill='#000000', font=font)
    # 텍스트
    draw.text((text_x, text_y), text, fill=color, font=font)

    # 저장
    img.save(filename)
    print(f"✓ Created: {filename}")

def main():
    """메인 함수"""

    base_path = "assets/images/pushup_forms"

    # 올바른 자세
    placeholders = [
        (f"{base_path}/correct/front_view.png", "FRONT VIEW\nCORRECT FORM", COLORS['success']),
        (f"{base_path}/correct/side_view.png", "SIDE VIEW\nCORRECT FORM", COLORS['success']),

        # 잘못된 자세
        (f"{base_path}/mistakes/back_arch.png", "BACK ARCH\nMISTAKE", COLORS['error']),
        (f"{base_path}/mistakes/hips_down.png", "HIPS DOWN\nMISTAKE", COLORS['error']),
        (f"{base_path}/mistakes/elbows_out.png", "ELBOWS OUT\nMISTAKE", COLORS['error']),
        (f"{base_path}/mistakes/head_down.png", "HEAD DOWN\nMISTAKE", COLORS['error']),

        # 근육 하이라이트
        (f"{base_path}/muscles/chest_highlighted.png", "CHEST\nMUSCLES", COLORS['primary']),
        (f"{base_path}/muscles/triceps_highlighted.png", "TRICEPS\nMUSCLES", COLORS['primary']),
        (f"{base_path}/muscles/core_highlighted.png", "CORE\nMUSCLES", COLORS['primary']),
        (f"{base_path}/muscles/shoulders_highlighted.png", "SHOULDERS\nMUSCLES", COLORS['primary']),

        # 변형 운동 - 초급
        (f"{base_path}/variations/knee_pushup.png", "KNEE\nPUSH-UP", COLORS['success']),
        (f"{base_path}/variations/wall_pushup.png", "WALL\nPUSH-UP", COLORS['success']),
        (f"{base_path}/variations/incline_pushup.png", "INCLINE\nPUSH-UP", COLORS['success']),

        # 변형 운동 - 중급
        (f"{base_path}/variations/wide_pushup.png", "WIDE\nPUSH-UP", COLORS['warning']),
        (f"{base_path}/variations/diamond_pushup.png", "DIAMOND\nPUSH-UP", COLORS['warning']),
        (f"{base_path}/variations/decline_pushup.png", "DECLINE\nPUSH-UP", COLORS['warning']),

        # 변형 운동 - 고급
        (f"{base_path}/variations/one_arm_pushup.png", "ONE ARM\nPUSH-UP", COLORS['error']),
        (f"{base_path}/variations/plyometric_pushup.png", "PLYOMETRIC\nPUSH-UP", COLORS['error']),
        (f"{base_path}/variations/archer_pushup.png", "ARCHER\nPUSH-UP", COLORS['error']),
    ]

    print("\n🎨 Generating placeholder images...\n")

    for filename, text, color in placeholders:
        # 디렉토리 생성
        os.makedirs(os.path.dirname(filename), exist_ok=True)

        # 이미지 생성
        create_placeholder(
            width=1080,
            height=1080,
            text=text,
            color=color,
            filename=filename
        )

    print(f"\n✅ Successfully generated {len(placeholders)} placeholder images!")
    print(f"📁 Location: {base_path}/")
    print("\n💡 Tip: Replace these with real assets when ready!")

if __name__ == "__main__":
    main()
