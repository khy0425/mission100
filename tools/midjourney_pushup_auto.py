"""
Discord MidJourney 푸쉬업 에셋 자동 생성기

전략:
1. 올바른 자세만 생성 (잘못된 자세는 텍스트로 설명)
2. 10개 운동 변형 에셋 순차 생성
3. U1 자동 클릭
4. 이미지 다운로드

소요 시간: 약 25분
"""

import pyautogui
import pygetwindow as gw
import time
import pyperclip
import os
import requests
from PIL import Image
import io
import re

# Safety settings
pyautogui.PAUSE = 0.5
pyautogui.FAILSAFE = True

# Configuration
WAIT_FOR_GRID = 90  # Grid 생성 대기 (Fast mode)
WAIT_FOR_UPSCALE = 60  # Upscale 대기

# Output directory
OUTPUT_DIR = r"E:\Projects\Mission100 App\assets\images\exercises\pushup"

# Reference image URL (standard pushup)
REFERENCE_URL = "https://cdn.discordapp.com/attachments/1429896697898733660/1430981869809172663/standard_pushup.gif?ex=68fbc138&is=68fa6fb8&hm=53c0653db4c53e0e50e66ed98e4dd6e7209469b2750d44d71b1fde36012516c5&"

# Prompts for correct form only (10 variations) - with character reference for face consistency
PROMPTS = {
    "standard": {
        "standard_pushup": f"professional fitness illustration 3D render, athletic muscular male figure in perfect push-up plank position ARMS FULLY EXTENDED STRAIGHT body completely straight horizontal, entire body grayscale monochrome EXCEPT chest and triceps muscles highlighted in bright glowing cyan turquoise blue, side profile angle, simple dark grey background, medical anatomical style, extremely detailed muscle definition, studio lighting --ar 1:1 --v 6 --style raw --cref {REFERENCE_URL} --cw 30",
    },
    "beginner": {
        "knee_pushup": f"professional fitness illustration 3D render, athletic muscular male figure in knee push-up position KNEES RESTING ON GROUND ARMS FULLY EXTENDED STRAIGHT body straight from knees to shoulders, entire body grayscale monochrome EXCEPT chest and arm muscles highlighted in bright glowing cyan turquoise blue, side profile angle, simple dark grey background, medical anatomical style, extremely detailed muscle definition, studio lighting --ar 1:1 --v 6 --style raw --cref {REFERENCE_URL} --cw 30",
        "wall_pushup": f"professional fitness illustration 3D render, athletic muscular male figure doing wall push-up STANDING UPRIGHT hands on vertical wall ARMS EXTENDED STRAIGHT body leaning at angle toward wall, entire body grayscale monochrome EXCEPT chest muscles highlighted in bright glowing cyan turquoise blue, side profile angle, simple dark grey background with wall, medical anatomical style, extremely detailed muscle definition, studio lighting --ar 1:1 --v 6 --style raw --cref {REFERENCE_URL} --cw 30",
        "incline_pushup": f"professional fitness illustration 3D render, athletic muscular male figure in incline push-up position HANDS ON ELEVATED SIMPLE GEOMETRIC BOX PLATFORM feet on ground behind ARMS FULLY EXTENDED STRAIGHT body at downward angle, entire body grayscale monochrome EXCEPT chest and shoulder muscles highlighted in bright glowing cyan turquoise blue, side profile angle, simple dark grey background, medical anatomical style, extremely detailed muscle definition, studio lighting --ar 1:1 --v 6 --style raw --cref {REFERENCE_URL} --cw 30",
    },
    "intermediate": {
        "wide_pushup": f"professional fitness illustration 3D render, athletic muscular male figure in wide push-up plank position HANDS PLACED MUCH WIDER THAN SHOULDERS ARMS FULLY EXTENDED STRAIGHT body straight horizontal, entire body grayscale monochrome EXCEPT chest outer muscles highlighted in bright glowing cyan turquoise blue, side profile angle, simple dark grey background, medical anatomical style, extremely detailed muscle definition, studio lighting --ar 1:1 --v 6 --style raw --cref {REFERENCE_URL} --cw 30",
        "diamond_pushup": f"professional fitness illustration 3D render, athletic muscular male figure in diamond push-up position HANDS FORMING TRIANGLE SHAPE UNDER CHEST ARMS FULLY EXTENDED STRAIGHT body straight horizontal, entire body grayscale monochrome EXCEPT triceps muscles highlighted in bright glowing cyan turquoise blue, side profile angle, simple dark grey background, medical anatomical style, extremely detailed muscle definition, studio lighting --ar 1:1 --v 6 --style raw --cref {REFERENCE_URL} --cw 30",
        "decline_pushup": f"professional fitness illustration 3D render, athletic muscular male figure in decline push-up position FEET ELEVATED ON SIMPLE GEOMETRIC BOX PLATFORM hands on ground ARMS FULLY EXTENDED STRAIGHT body at upward angle, entire body grayscale monochrome EXCEPT upper chest muscles highlighted in bright glowing cyan turquoise blue, side profile angle, simple dark grey background, medical anatomical style, extremely detailed muscle definition, studio lighting --ar 1:1 --v 6 --style raw --cref {REFERENCE_URL} --cw 30",
    },
    "advanced": {
        "one_arm_pushup": f"professional fitness illustration 3D render, athletic muscular male figure in one-arm push-up position BALANCING ON SINGLE ARM EXTENDED STRAIGHT other arm behind back body straight, entire body grayscale monochrome EXCEPT chest and core muscles highlighted in bright glowing cyan turquoise blue, side profile angle, simple dark grey background, medical anatomical style, extremely detailed muscle definition, studio lighting --ar 1:1 --v 6 --style raw --cref {REFERENCE_URL} --cw 30",
        "plyometric_pushup": f"professional fitness illustration 3D render, athletic muscular male figure captured MID-AIR EXPLOSIVE PLYOMETRIC PUSH-UP HANDS OFF GROUND body horizontal, entire body grayscale monochrome EXCEPT chest and arm muscles highlighted in bright glowing cyan turquoise blue, side profile angle, simple dark grey background, medical anatomical style, extremely detailed muscle definition, studio lighting --ar 1:1 --v 6 --style raw --cref {REFERENCE_URL} --cw 30",
        "archer_pushup": f"professional fitness illustration 3D render, athletic muscular male figure in archer push-up position ONE ARM BENT SUPPORTING BODY ONE ARM EXTENDED STRAIGHT TO SIDE body straight, entire body grayscale monochrome EXCEPT working side chest and arm highlighted in bright glowing cyan turquoise blue, side profile angle, simple dark grey background, medical anatomical style, extremely detailed muscle definition, studio lighting --ar 1:1 --v 6 --style raw --cref {REFERENCE_URL} --cw 30",
    }
}


def find_and_activate_discord():
    """Find and activate Discord window"""
    print("[SETUP] Discord 준비 중...")

    all_windows = gw.getAllWindows()
    discord_windows = [w for w in all_windows if 'Discord' in w.title and 'Visual Studio Code' not in w.title]

    if not discord_windows:
        print("    [ERROR] Discord 창을 찾을 수 없습니다!")
        return False

    try:
        discord_windows[0].activate()
        time.sleep(2)
        print(f"    [OK] Discord 준비: {discord_windows[0].title}")
        return True
    except:
        print(f"    [OK] Discord 준비됨")
        return True


def send_command(prompt, exercise_name):
    """Send single /imagine command"""
    print(f"    - {exercise_name} 전송 중...")

    pyautogui.click()
    time.sleep(0.3)

    pyautogui.write('/imagine', interval=0.05)
    time.sleep(1)

    pyautogui.press('tab')
    time.sleep(0.5)

    pyperclip.copy(prompt)
    pyautogui.hotkey('ctrl', 'v')
    time.sleep(0.5)

    pyautogui.press('enter')
    time.sleep(1)

    print(f"    [OK] {exercise_name} 전송 완료!")


def click_u1_button(exercise_name):
    """Click U1 button - manual positioning required"""
    print(f"\n    [U1] {exercise_name} - U1 버튼을 찾아서 클릭해주세요...")
    print(f"    (10초 대기 중... 수동으로 U1 클릭)")
    time.sleep(10)
    print(f"    [OK] {exercise_name} U1 처리 완료")


def extract_latest_url():
    """Extract most recent upscaled image URL"""
    # Scroll to bottom
    pyautogui.press('end')
    time.sleep(1)

    # Click chat
    screen_width, screen_height = pyautogui.size()
    chat_x = int(screen_width * 0.7)
    chat_y = int(screen_height * 0.5)
    pyautogui.click(chat_x, chat_y)
    time.sleep(1)

    # Select all
    pyautogui.hotkey('ctrl', 'a')
    time.sleep(0.5)

    # Copy
    pyautogui.hotkey('ctrl', 'c')
    time.sleep(1)

    # Get clipboard
    chat_content = pyperclip.paste()

    # Find all Discord CDN URLs
    urls = re.findall(r'https://cdn\.discordapp\.com/attachments/[^\s]+?\.(?:png|jpg|jpeg|webp)', chat_content)

    # Filter out reference images
    filtered_urls = [url for url in urls if 'standard_pushup.gif' not in url]

    if filtered_urls:
        latest_url = filtered_urls[-1]
        print(f"    [OK] URL 추출: {latest_url[:50]}...")
        return latest_url
    else:
        print(f"    [ERROR] URL 찾기 실패")
        return None


def download_image(url, category, exercise_name):
    """Download single image"""
    try:
        print(f"    - {exercise_name} 다운로드 중...")

        response = requests.get(url, timeout=30)
        response.raise_for_status()

        img = Image.open(io.BytesIO(response.content))

        # Save as PNG
        filename = f"{exercise_name}.png"
        category_dir = os.path.join(OUTPUT_DIR, category)
        os.makedirs(category_dir, exist_ok=True)

        filepath = os.path.join(category_dir, filename)
        img.save(filepath)

        print(f"    [OK] {filename} 저장!")
        return filepath

    except Exception as e:
        print(f"    [ERROR] {exercise_name} 실패: {e}")
        return None


def main():
    print("=" * 70)
    print("     Discord MidJourney 푸쉬업 에셋 자동 생성기")
    print("=" * 70)
    print()
    print("생성할 에셋: 올바른 자세만 (10개)")
    print("  🔵 스탠다드 (1개)")
    print("  🟢 초급 변형 (3개) - 무릎/벽/인클라인")
    print("  🟡 중급 변형 (3개) - 와이드/다이아몬드/디클라인")
    print("  🔴 고급 변형 (3개) - 원암/플라이오메트릭/아처")
    print()
    print("⚠️  잘못된 자세는 텍스트로 설명 (이미지 생성 안 함)")
    print()
    print("소요 시간: 약 25분 (에셋당 2.5분)")
    print("=" * 70)
    print()

    # Activate Discord
    if not find_and_activate_discord():
        return

    print("\n10초 후 자동 시작...")
    print("Discord 메시지 입력창에 커서를 두세요!")
    time.sleep(10)

    total_count = sum(len(exercises) for exercises in PROMPTS.values())
    current = 0

    # Process each category
    for category, exercises in PROMPTS.items():
        print("\n" + "=" * 70)
        print(f"[카테고리] {category.upper()}")
        print("=" * 70)

        for exercise_name, prompt in exercises.items():
            current += 1
            print(f"\n[{current}/{total_count}] {exercise_name}")
            print("-" * 70)

            # Check if already exists
            output_path = os.path.join(OUTPUT_DIR, category, f"{exercise_name}.png")
            if os.path.exists(output_path):
                print(f"    [SKIP] 이미 존재함: {output_path}")
                continue

            # Send command
            print(f"\n[전송] {exercise_name} 명령 전송 중...")
            send_command(prompt, exercise_name)

            # Wait for grid generation
            print(f"\n[대기] Grid 생성 중... ({WAIT_FOR_GRID}초)")
            for remaining in range(WAIT_FOR_GRID, 0, -15):
                print(f"    - {remaining}초 남음...")
                time.sleep(15)

            # Click U1
            print(f"\n[U1 클릭] {exercise_name}")
            click_u1_button(exercise_name)

            # Wait for upscale
            print(f"\n[대기] Upscale 중... ({WAIT_FOR_UPSCALE}초)")
            for remaining in range(WAIT_FOR_UPSCALE, 0, -10):
                print(f"    - {remaining}초 남음...")
                time.sleep(10)

            # Extract URL and download
            print(f"\n[다운로드] {exercise_name}")
            url = extract_latest_url()

            if url:
                download_image(url, category, exercise_name)
            else:
                print(f"    [ERROR] URL 추출 실패. 수동 입력:")
                manual_url = input(f"    {exercise_name} URL: ").strip()
                if manual_url:
                    download_image(manual_url, category, exercise_name)

            # Wait before next request (API rate limit)
            if current < total_count:
                print(f"\n[휴식] 다음 요청 전 대기 (30초)...")
                time.sleep(30)

    print()
    print("=" * 70)
    print("[SUCCESS] 완료!")
    print("=" * 70)
    print(f"\n저장 위치: {OUTPUT_DIR}")
    print()
    print("생성된 에셋:")
    for category, exercises in PROMPTS.items():
        print(f"\n{category}/")
        for exercise_name in exercises.keys():
            filepath = os.path.join(OUTPUT_DIR, category, f"{exercise_name}.png")
            if os.path.exists(filepath):
                print(f"  ✅ {exercise_name}.png")
            else:
                print(f"  ❌ {exercise_name}.png (실패)")
    print()


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n[ABORT] 중단됨")
    except Exception as e:
        print(f"\n\n[ERROR] {e}")
        import traceback
        traceback.print_exc()
