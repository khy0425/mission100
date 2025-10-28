#!/usr/bin/env python3
"""
비디오 최적화 스크립트
모바일 앱에 최적화된 크기와 품질로 비디오 변환
FFmpeg 필요: https://ffmpeg.org/download.html
"""

import os
import subprocess
import sys
from pathlib import Path

def check_ffmpeg():
    """FFmpeg 설치 확인"""
    try:
        subprocess.run(["ffmpeg", "-version"],
                      stdout=subprocess.PIPE,
                      stderr=subprocess.PIPE,
                      check=True)
        return True
    except:
        return False

def optimize_video(input_path: str, output_path: str,
                  target_size_mb: float = 5.0,
                  resolution: str = "1080x1080",
                  fps: int = 30):
    """
    비디오 최적화

    Args:
        input_path: 입력 비디오 경로
        output_path: 출력 비디오 경로
        target_size_mb: 목표 파일 크기 (MB)
        resolution: 해상도 (예: "1080x1080", "1920x1080")
        fps: 프레임레이트
    """

    # 비디오 길이 가져오기
    duration_cmd = [
        "ffprobe", "-v", "error",
        "-show_entries", "format=duration",
        "-of", "default=noprint_wrappers=1:nokey=1",
        input_path
    ]

    try:
        duration = float(subprocess.check_output(duration_cmd).decode().strip())
    except:
        print("⚠️  Could not determine video duration, using default bitrate")
        duration = 10.0

    # 목표 비트레이트 계산
    # 파일크기(MB) = (비트레이트(kbps) × 시간(s)) / (8 × 1024)
    target_bitrate = int((target_size_mb * 8 * 1024) / duration)

    print(f"📊 Optimization Settings:")
    print(f"   Resolution: {resolution}")
    print(f"   FPS: {fps}")
    print(f"   Duration: {duration:.1f}s")
    print(f"   Target Size: {target_size_mb}MB")
    print(f"   Target Bitrate: {target_bitrate}kbps")

    # FFmpeg 명령어
    cmd = [
        "ffmpeg",
        "-i", input_path,
        "-vf", f"scale={resolution}:force_original_aspect_ratio=decrease,pad={resolution}:(ow-iw)/2:(oh-ih)/2,fps={fps}",
        "-c:v", "libx264",
        "-preset", "slow",  # 더 나은 압축
        "-b:v", f"{target_bitrate}k",
        "-maxrate", f"{int(target_bitrate * 1.5)}k",
        "-bufsize", f"{int(target_bitrate * 2)}k",
        "-c:a", "aac",
        "-b:a", "128k",
        "-movflags", "+faststart",  # 웹 스트리밍 최적화
        "-y",  # 덮어쓰기
        output_path
    ]

    print(f"\n⚙️  Processing: {os.path.basename(input_path)}")

    try:
        subprocess.run(cmd, check=True,
                      stdout=subprocess.PIPE,
                      stderr=subprocess.PIPE)

        # 결과 파일 크기 확인
        output_size = os.path.getsize(output_path) / (1024 * 1024)
        print(f"✅ Complete! Output size: {output_size:.2f}MB")

        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Error processing video: {e}")
        return False

def batch_optimize(input_dir: str, output_dir: str, **kwargs):
    """디렉토리 내 모든 비디오 최적화"""

    os.makedirs(output_dir, exist_ok=True)

    video_extensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm']
    videos = []

    for ext in video_extensions:
        videos.extend(Path(input_dir).glob(f"*{ext}"))

    if not videos:
        print(f"❌ No videos found in {input_dir}")
        return

    print(f"\n📹 Found {len(videos)} videos to optimize\n")

    success_count = 0
    for idx, video_path in enumerate(videos, 1):
        print(f"\n[{idx}/{len(videos)}]")

        output_filename = f"optimized_{video_path.stem}.mp4"
        output_path = os.path.join(output_dir, output_filename)

        if optimize_video(str(video_path), output_path, **kwargs):
            success_count += 1

    print(f"\n{'='*50}")
    print(f"✅ Successfully optimized: {success_count}/{len(videos)} videos")
    print(f"📁 Output directory: {output_dir}")

def create_loop_video(input_path: str, output_path: str, duration: int = 10):
    """루프 가능한 비디오 생성 (부드러운 시작/끝)"""

    print(f"🔄 Creating seamless loop video...")

    cmd = [
        "ffmpeg",
        "-i", input_path,
        "-filter_complex",
        f"[0:v]trim=0:{duration},setpts=PTS-STARTPTS[v1];"
        f"[0:v]trim=0:1,setpts=PTS-STARTPTS,reverse[v2];"
        f"[v1][v2]concat=n=2:v=1[outv]",
        "-map", "[outv]",
        "-c:v", "libx264",
        "-preset", "slow",
        "-crf", "20",
        "-movflags", "+faststart",
        "-y",
        output_path
    ]

    try:
        subprocess.run(cmd, check=True,
                      stdout=subprocess.PIPE,
                      stderr=subprocess.PIPE)
        print("✅ Loop video created!")
        return True
    except:
        print("❌ Failed to create loop video")
        return False

def main():
    """메인 함수"""

    print("🎬 Video Optimizer for Mobile Apps")
    print("=" * 50)

    # FFmpeg 확인
    if not check_ffmpeg():
        print("❌ FFmpeg not found!")
        print("   Download: https://ffmpeg.org/download.html")
        print("   Mac: brew install ffmpeg")
        print("   Ubuntu: sudo apt install ffmpeg")
        print("   Windows: Download and add to PATH")
        return

    print("✅ FFmpeg found\n")

    # 메뉴
    print("옵션:")
    print("1. 단일 비디오 최적화")
    print("2. 폴더 내 모든 비디오 최적화")
    print("3. 루프 비디오 생성")

    choice = input("\n선택 (1-3): ").strip()

    if choice == "1":
        input_file = input("입력 비디오 경로: ").strip()
        output_file = input("출력 비디오 경로 (Enter=자동): ").strip()

        if not output_file:
            output_file = f"optimized_{Path(input_file).stem}.mp4"

        resolution = input("해상도 (Enter=1080x1080): ").strip() or "1080x1080"

        optimize_video(input_file, output_file, resolution=resolution)

    elif choice == "2":
        input_dir = input("입력 폴더 경로: ").strip()
        output_dir = input("출력 폴더 경로 (Enter=./optimized): ").strip() or "./optimized"

        resolution = input("해상도 (Enter=1080x1080): ").strip() or "1080x1080"
        target_size = float(input("목표 파일 크기 MB (Enter=5): ").strip() or "5")

        batch_optimize(input_dir, output_dir,
                      resolution=resolution,
                      target_size_mb=target_size)

    elif choice == "3":
        input_file = input("입력 비디오 경로: ").strip()
        output_file = input("출력 비디오 경로: ").strip()
        duration = int(input("루프 길이 (초, Enter=10): ").strip() or "10")

        create_loop_video(input_file, output_file, duration)

if __name__ == "__main__":
    main()
