#!/usr/bin/env python3
"""
무료 스톡 비디오 다운로드 헬퍼 스크립트
Pexels API를 사용하여 운동 시연 비디오 검색 및 다운로드
"""

import requests
import os
import json
from typing import List, Dict

# Pexels API 키 (무료로 발급: https://www.pexels.com/api/)
# 여기에 본인의 API 키를 입력하세요
PEXELS_API_KEY = "YOUR_API_KEY_HERE"

class VideoDownloader:
    def __init__(self, api_key: str):
        self.api_key = api_key
        self.base_url = "https://api.pexels.com/videos"
        self.headers = {"Authorization": api_key}

    def search_videos(self, query: str, per_page: int = 15) -> List[Dict]:
        """비디오 검색"""
        url = f"{self.base_url}/search"
        params = {
            "query": query,
            "per_page": per_page,
            "orientation": "landscape"  # 또는 "portrait", "square"
        }

        response = requests.get(url, headers=self.headers, params=params)

        if response.status_code == 200:
            data = response.json()
            return data.get("videos", [])
        else:
            print(f"❌ Error: {response.status_code}")
            return []

    def download_video(self, video_url: str, filename: str):
        """비디오 다운로드"""
        print(f"⬇️  Downloading: {filename}")

        response = requests.get(video_url, stream=True)
        total_size = int(response.headers.get('content-length', 0))

        with open(filename, 'wb') as f:
            downloaded = 0
            for chunk in response.iter_content(chunk_size=8192):
                if chunk:
                    f.write(chunk)
                    downloaded += len(chunk)
                    progress = (downloaded / total_size) * 100
                    print(f"\r  Progress: {progress:.1f}%", end="")

        print("\n  ✓ Complete!")

    def get_best_quality_url(self, video_files: List[Dict]) -> str:
        """가장 좋은 품질의 비디오 URL 반환"""
        # 1080p 찾기
        for file in video_files:
            if file.get("height") == 1080:
                return file.get("link")

        # 없으면 가장 높은 해상도
        if video_files:
            return sorted(video_files, key=lambda x: x.get("height", 0), reverse=True)[0].get("link")

        return None

def main():
    """메인 함수"""

    # API 키 확인
    if PEXELS_API_KEY == "YOUR_API_KEY_HERE":
        print("❌ Error: Pexels API 키를 설정해주세요!")
        print("   1. https://www.pexels.com/api/ 방문")
        print("   2. 무료 계정 생성")
        print("   3. API 키 받기")
        print("   4. 이 스크립트의 PEXELS_API_KEY 변수에 입력")
        return

    downloader = VideoDownloader(PEXELS_API_KEY)

    # 검색할 운동들
    exercises = [
        "push up exercise",
        "push up workout",
        "fitness push up",
        "bodyweight training",
        "home workout",
    ]

    # 다운로드 디렉토리
    output_dir = "assets/videos/pushup_forms/stock"
    os.makedirs(output_dir, exist_ok=True)

    print("\n🎬 Pexels 무료 비디오 다운로더")
    print("=" * 50)

    all_videos = []

    # 각 검색어로 비디오 찾기
    for exercise in exercises:
        print(f"\n🔍 Searching: {exercise}")
        videos = downloader.search_videos(exercise, per_page=5)

        for video in videos:
            video_id = video.get("id")
            video_user = video.get("user", {}).get("name", "unknown")
            video_files = video.get("video_files", [])

            # 중복 제거
            if video_id not in [v["id"] for v in all_videos]:
                all_videos.append({
                    "id": video_id,
                    "user": video_user,
                    "url": video.get("url"),
                    "duration": video.get("duration"),
                    "files": video_files
                })

    print(f"\n✅ Found {len(all_videos)} unique videos")

    # 비디오 정보 출력 및 선택
    print("\n📋 Available Videos:")
    print("-" * 50)

    for idx, video in enumerate(all_videos[:10], 1):  # 상위 10개만
        print(f"{idx}. Duration: {video['duration']}s | By: {video['user']}")
        print(f"   URL: {video['url']}")

    # 사용자가 선택하도록 (또는 자동 다운로드)
    print("\n💾 다운로드 옵션:")
    print("1. 상위 5개 자동 다운로드")
    print("2. 수동 선택")
    print("3. 모두 다운로드")

    choice = input("\n선택 (1-3): ").strip()

    videos_to_download = []

    if choice == "1":
        videos_to_download = all_videos[:5]
    elif choice == "2":
        indices = input("다운로드할 번호 (예: 1,3,5): ").strip()
        indices = [int(i.strip())-1 for i in indices.split(",")]
        videos_to_download = [all_videos[i] for i in indices if i < len(all_videos)]
    elif choice == "3":
        videos_to_download = all_videos[:10]

    # 다운로드 시작
    print(f"\n⬇️  Downloading {len(videos_to_download)} videos...")

    for idx, video in enumerate(videos_to_download, 1):
        video_files = video.get("files", [])
        best_url = downloader.get_best_quality_url(video_files)

        if best_url:
            filename = os.path.join(output_dir, f"stock_video_{idx}_{video['id']}.mp4")
            print(f"\n[{idx}/{len(videos_to_download)}]")
            downloader.download_video(best_url, filename)
        else:
            print(f"❌ No suitable quality found for video {video['id']}")

    print("\n✅ Download complete!")
    print(f"📁 Location: {output_dir}/")
    print("\n💡 Remember to:")
    print("   1. Review videos for quality and relevance")
    print("   2. Edit/trim as needed")
    print("   3. Give credit to creators (Pexels license allows free use)")

if __name__ == "__main__":
    main()
