"""
Discord MidJourney 푸쉬업 에셋 자동 생성기 - 얼굴 일관성 보장

2단계 전략:
1단계: 마스터 이미지 1장 생성 (완벽한 얼굴)
2단계: 마스터 이미지를 --cref로 사용하여 나머지 9개 생성

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

# Master reference image URL (will be set after first generation)
MASTER_REFERENCE_URL = None

# Face characteristics to maintain consistency
FACE_DESCRIPTION = "athletic male with short dark hair clean-shaven chiseled jawline side profile"

# Master prompt to create consistent character
MASTER_PROMPT = f"professional fitness illustration 3D render, {FACE_DESCRIPTION}, athletic muscular male figure in perfect push-up plank position ARMS FULLY EXTENDED STRAIGHT body completely straight horizontal, entire body grayscale monochrome EXCEPT chest and triceps muscles highlighted in bright glowing cyan turquoise blue, side profile angle, simple dark grey background, medical anatomical style, extremely detailed muscle definition, studio lighting --ar 1:1 --v 6 --style raw"

# Prompts for all 10 exercises (will use MASTER_REFERENCE_URL)
EXERCISE_PROMPTS = {
    "standard": {
        "standard_pushup": "perfect push-up plank position ARMS FULLY EXTENDED STRAIGHT body completely straight horizontal",
    },
    "beginner": {
        "knee_pushup": "knee push-up position KNEES RESTING ON GROUND ARMS FULLY EXTENDED STRAIGHT body straight from knees to shoulders",
        "wall_pushup": "wall push-up STANDING UPRIGHT hands on vertical wall ARMS EXTENDED STRAIGHT body leaning at angle toward wall",
        "incline_pushup": "incline push-up position HANDS ON ELEVATED SIMPLE GEOMETRIC BOX PLATFORM feet on ground behind ARMS FULLY EXTENDED STRAIGHT body at downward angle",
    },
    "intermediate": {
        "wide_pushup": "wide push-up plank position HANDS PLACED MUCH WIDER THAN SHOULDERS ARMS FULLY EXTENDED STRAIGHT body straight horizontal",
        "diamond_pushup": "diamond push-up position HANDS FORMING TRIANGLE SHAPE UNDER CHEST ARMS FULLY EXTENDED STRAIGHT body straight horizontal",
        "decline_pushup": "decline push-up position FEET ELEVATED ON SIMPLE GEOMETRIC BOX PLATFORM hands on ground ARMS FULLY EXTENDED STRAIGHT body at upward angle",
    },
    "advanced": {
        "one_arm_pushup": "one-arm push-up position BALANCING ON SINGLE ARM EXTENDED STRAIGHT other arm behind back body straight",
        "plyometric_pushup": "captured MID-AIR EXPLOSIVE PLYOMETRIC PUSH-UP HANDS OFF GROUND body horizontal",
        "archer_pushup": "archer push-up position ONE ARM BENT SUPPORTING BODY ONE ARM EXTENDED STRAIGHT TO SIDE body straight",
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

    if urls:
        latest_url = urls[-1]
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


def create_full_prompt(exercise_description, reference_url, cw_value=75):
    """Create full prompt with reference"""
    base = f"professional fitness illustration 3D render, {FACE_DESCRIPTION}, athletic muscular male figure in {exercise_description}, entire body grayscale monochrome EXCEPT chest and shoulder muscles highlighted in bright glowing cyan turquoise blue, side profile angle, simple dark grey background, medical anatomical style, extremely detailed muscle definition, studio lighting --ar 1:1 --v 6 --style raw"

    if reference_url:
        base += f" --cref {reference_url} --cw {cw_value}"

    return base


def main():
    global MASTER_REFERENCE_URL

    print("=" * 70)
    print("   푸쉬업 에셋 생성기 - 얼굴 일관성 보장")
    print("=" * 70)
    print()
    print("전략:")
    print("  [1단계] 마스터 이미지 1장 생성 (완벽한 얼굴)")
    print("  [2단계] 마스터를 레퍼런스로 나머지 9개 생성")
    print()
    print("생성 에셋: 10개 (스탠다드 + 초급3 + 중급3 + 고급3)")
    print("소요 시간: 약 25분")
    print("=" * 70)
    print()

    # Activate Discord
    if not find_and_activate_discord():
        return

    print("\n10초 후 자동 시작...")
    print("Discord 메시지 입력창에 커서를 두세요!")
    time.sleep(10)

    # ===== STAGE 1: Generate master image =====
    print("\n" + "=" * 70)
    print("[STAGE 1] 마스터 이미지 생성")
    print("=" * 70)

    print("\n[전송] 마스터 이미지 프롬프트 전송...")
    send_command(MASTER_PROMPT, "master_reference")

    print(f"\n[대기] Grid 생성 중... ({WAIT_FOR_GRID}초)")
    for remaining in range(WAIT_FOR_GRID, 0, -15):
        print(f"    - {remaining}초 남음...")
        time.sleep(15)

    print("\n[U1 클릭] 마스터 이미지")
    click_u1_button("master_reference")

    print(f"\n[대기] Upscale 중... ({WAIT_FOR_UPSCALE}초)")
    for remaining in range(WAIT_FOR_UPSCALE, 0, -10):
        print(f"    - {remaining}초 남음...")
        time.sleep(10)

    print("\n[URL 추출] 마스터 이미지 URL...")
    MASTER_REFERENCE_URL = extract_latest_url()

    if not MASTER_REFERENCE_URL:
        print("\n[ERROR] 마스터 URL 추출 실패. 수동 입력:")
        MASTER_REFERENCE_URL = input("마스터 이미지 URL: ").strip()

    print(f"\n[OK] 마스터 레퍼런스 설정!")
    print(f"     {MASTER_REFERENCE_URL[:60]}...")

    # ===== STAGE 2: Generate all exercises using master =====
    print("\n" + "=" * 70)
    print("[STAGE 2] 나머지 9개 운동 생성 (마스터 레퍼런스 사용)")
    print("=" * 70)

    total_count = sum(len(exercises) for exercises in EXERCISE_PROMPTS.values())
    current = 0

    for category, exercises in EXERCISE_PROMPTS.items():
        print("\n" + "=" * 70)
        print(f"[카테고리] {category.upper()}")
        print("=" * 70)

        for exercise_name, exercise_description in exercises.items():
            current += 1
            print(f"\n[{current}/{total_count}] {exercise_name}")
            print("-" * 70)

            # Check if already exists
            output_path = os.path.join(OUTPUT_DIR, category, f"{exercise_name}.png")
            if os.path.exists(output_path):
                print(f"    [SKIP] 이미 존재함: {output_path}")
                continue

            # Create full prompt with master reference
            full_prompt = create_full_prompt(exercise_description, MASTER_REFERENCE_URL, cw_value=75)

            # Send command
            print(f"\n[전송] {exercise_name} 명령 전송 중...")
            send_command(full_prompt, exercise_name)

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

            # Wait before next request
            if current < total_count:
                print(f"\n[휴식] 다음 요청 전 대기 (30초)...")
                time.sleep(30)

    print()
    print("=" * 70)
    print("[SUCCESS] 완료!")
    print("=" * 70)
    print(f"\n저장 위치: {OUTPUT_DIR}")
    print(f"\n마스터 레퍼런스: {MASTER_REFERENCE_URL}")
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
