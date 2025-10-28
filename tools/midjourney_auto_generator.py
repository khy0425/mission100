"""
Midjourney Discord 자동화 스크립트
⚠️ 주의: Discord 사용자 계정 자동화는 ToS 위반이며 계정 정지 위험이 있습니다.
개인 사용, 적당한 빈도로만 사용하세요.
"""

import discord
import asyncio
import aiohttp
import os
from pathlib import Path
from datetime import datetime
import json

# ===== 설정 =====
DISCORD_TOKEN = "YOUR_DISCORD_USER_TOKEN"  # Discord 사용자 토큰
MIDJOURNEY_CHANNEL_ID = 1234567890  # Midjourney를 사용할 채널 ID
OUTPUT_DIR = r"E:\Projects\Mission100 App\assets\images\exercises\pushup"
REFERENCE_IMAGE_URL = "https://cdn.discordapp.com/attachments/1429896697898733660/1430981869809172663/standard_pushup.gif"

# ===== 프롬프트 목록 =====
PROMPTS = {
    "correct": {
        "standard_pushup": "3D render of athletic male figure performing perfect push-up form, side view angle, highlighted chest muscles in glowing cyan blue, dark grey studio background, professional fitness illustration style, clean minimalist design, anatomical muscle visualization, high detail, photorealistic lighting, 4k quality --ar 1:1 --v 6 --style raw",
    },
    "mistakes": {
        "arched_back": "3D render muscular male figure performing incorrect push-up with arched lower back sagging downward, spine highlighted in glowing red, side view angle, dark grey background, professional fitness illustration style, anatomical muscle visualization, high detail, photorealistic lighting --ar 1:1 --v 6 --style raw",
        "sagging_hips": "3D render muscular male figure doing push-up with hips sagging toward ground, lower back highlighted in glowing red warning, side view angle, dark grey background, fitness error demonstration, anatomical style, high detail --ar 1:1 --v 6 --style raw",
        "elbows_flared": "3D render muscular male figure performing push-up with elbows flared out wide, shoulder joints highlighted in glowing red, three-quarter view angle, dark grey background, form mistake illustration, high detail rendering --ar 1:1 --v 6 --style raw",
        "head_down": "3D render muscular male figure doing push-up with head dropped down toward floor, neck area highlighted in glowing red, side view angle, dark grey background, posture error demonstration, anatomical precision --ar 1:1 --v 6 --style raw",
    },
    "beginner": {
        "knee_pushup": "3D render muscular male figure performing beginner knee push-up with knees on ground, chest and arm muscles highlighted in glowing green, side view angle, dark grey background, beginner level indicator, clean minimalist design --ar 1:1 --v 6 --style raw",
        "wall_pushup": "3D render muscular male figure doing standing wall push-up exercise against vertical surface, chest muscles highlighted in glowing green, side view angle, dark grey background, beginner friendly illustration --ar 1:1 --v 6 --style raw",
        "incline_pushup": "3D render muscular male figure performing incline push-up with hands on elevated bench surface, chest highlighted in glowing green, side view angle, dark grey background, beginner level fitness illustration --ar 1:1 --v 6 --style raw",
    },
    "intermediate": {
        "wide_pushup": "3D render muscular male figure doing wide-grip push-up with hands positioned wider than shoulders, chest muscles highlighted in glowing yellow, side view angle, dark grey background, intermediate level illustration --ar 1:1 --v 6 --style raw",
        "diamond_pushup": "3D render muscular male figure performing diamond push-up with hands forming triangle shape, triceps highlighted in glowing yellow, side view angle, dark grey background, intermediate technique illustration --ar 1:1 --v 6 --style raw",
        "decline_pushup": "3D render muscular male figure doing decline push-up with feet elevated on platform, upper chest muscles highlighted in glowing yellow, side view angle, dark grey background, intermediate level fitness diagram --ar 1:1 --v 6 --style raw",
    },
    "advanced": {
        "one_arm_pushup": "3D render muscular male figure performing one-arm push-up with single arm support, multiple muscle groups highlighted in glowing red, side view angle, dark grey background, advanced level fitness visualization --ar 1:1 --v 6 --style raw",
        "plyometric_pushup": "3D render muscular male figure performing explosive plyometric push-up with hands off ground mid-air, fast-twitch muscles highlighted in glowing red, side view angle, dark grey background, advanced power movement --ar 1:1 --v 6 --style raw",
        "archer_pushup": "3D render muscular male figure doing archer push-up with asymmetric arm position, unilateral chest highlighted in glowing red, side view angle, dark grey background, advanced technique demonstration --ar 1:1 --v 6 --style raw",
    }
}


class MidjourneyAutomation:
    def __init__(self, token, channel_id):
        self.token = token
        self.channel_id = channel_id
        self.client = discord.Client()
        self.setup_events()

    def setup_events(self):
        @self.client.event
        async def on_ready():
            print(f'✅ 로그인 완료: {self.client.user}')

        @self.client.event
        async def on_message(message):
            # Midjourney 봇의 메시지 처리
            if message.author.id == 936929561302675456:  # Midjourney 봇 ID
                print(f"📨 Midjourney 메시지: {message.content[:100]}")

    async def send_imagine_command(self, prompt, use_cref=True):
        """Midjourney /imagine 명령어 전송"""
        channel = self.client.get_channel(self.channel_id)
        if not channel:
            print(f"❌ 채널을 찾을 수 없습니다: {self.channel_id}")
            return None

        # cref 추가
        if use_cref and REFERENCE_IMAGE_URL:
            prompt = f"{prompt} --cref {REFERENCE_IMAGE_URL} --cw 100"

        print(f"🎨 프롬프트 전송: {prompt[:100]}...")

        # /imagine 명령어 전송
        await channel.send(f"/imagine {prompt}")

        # 응답 대기
        return await self.wait_for_generation(channel)

    async def wait_for_generation(self, channel, timeout=300):
        """이미지 생성 완료 대기"""
        print("⏳ 이미지 생성 대기 중...")
        start_time = asyncio.get_event_loop().time()

        def check(message):
            # Midjourney 봇의 완료 메시지 확인
            return (
                message.channel.id == channel.id and
                message.author.id == 936929561302675456 and
                len(message.attachments) > 0
            )

        try:
            message = await self.client.wait_for('message', check=check, timeout=timeout)
            elapsed = asyncio.get_event_loop().time() - start_time
            print(f"✅ 이미지 생성 완료! ({elapsed:.1f}초)")
            return message
        except asyncio.TimeoutError:
            print(f"⏱️ 타임아웃 ({timeout}초)")
            return None

    async def download_image(self, message, output_path):
        """생성된 이미지 다운로드"""
        if not message or not message.attachments:
            print("❌ 다운로드할 이미지가 없습니다")
            return False

        attachment = message.attachments[0]
        print(f"💾 다운로드 중: {attachment.filename}")

        async with aiohttp.ClientSession() as session:
            async with session.get(attachment.url) as resp:
                if resp.status == 200:
                    output_path.parent.mkdir(parents=True, exist_ok=True)
                    with open(output_path, 'wb') as f:
                        f.write(await resp.read())
                    print(f"✅ 저장 완료: {output_path}")
                    return True
                else:
                    print(f"❌ 다운로드 실패: {resp.status}")
                    return False

    async def generate_all_assets(self):
        """모든 에셋 자동 생성"""
        print("\n" + "="*60)
        print("🚀 Midjourney 자동 생성 시작")
        print("="*60 + "\n")

        total = sum(len(items) for items in PROMPTS.values())
        current = 0

        for category, items in PROMPTS.items():
            print(f"\n📂 카테고리: {category}")
            category_dir = Path(OUTPUT_DIR) / category

            for name, prompt in items.items():
                current += 1
                print(f"\n[{current}/{total}] 생성 중: {name}")
                print("-" * 60)

                # 이미 존재하는지 확인
                output_path = category_dir / f"{name}.gif"
                if output_path.exists():
                    print(f"⏭️ 이미 존재함: {output_path}")
                    continue

                # 프롬프트 전송 및 이미지 생성 대기
                message = await self.send_imagine_command(prompt)

                if message:
                    # 이미지 다운로드
                    await self.download_image(message, output_path)

                    # 요청 간격 (Discord API 제한 고려)
                    print("⏸️ 60초 대기 (API 제한)...")
                    await asyncio.sleep(60)
                else:
                    print(f"❌ 생성 실패: {name}")

        print("\n" + "="*60)
        print("✅ 모든 에셋 생성 완료!")
        print("="*60)

    async def start(self):
        """봇 시작"""
        try:
            await self.client.start(self.token)
        except Exception as e:
            print(f"❌ 오류 발생: {e}")

    async def run(self):
        """실행"""
        # 봇 시작 (백그라운드)
        asyncio.create_task(self.start())

        # 로그인 대기
        await asyncio.sleep(5)

        # 에셋 생성
        await self.generate_all_assets()

        # 종료
        await self.client.close()


# ===== 메인 함수 =====
async def main():
    """메인 실행 함수"""

    # 설정 확인
    if DISCORD_TOKEN == "YOUR_DISCORD_USER_TOKEN":
        print("❌ DISCORD_TOKEN을 설정해주세요!")
        print("\n토큰 얻는 방법:")
        print("1. Discord 웹 버전 열기 (브라우저)")
        print("2. F12 → Console 탭")
        print("3. 다음 코드 입력:")
        print('   (webpackChunkdiscord_app.push([[""],{},e=>{m=[];for(let c in e.c)m.push(e.c[c])}]),m).find(m=>m?.exports?.default?.getToken!==void 0).exports.default.getToken()')
        print("\n⚠️ 주의: 토큰은 절대 공유하지 마세요!")
        return

    if MIDJOURNEY_CHANNEL_ID == 1234567890:
        print("❌ MIDJOURNEY_CHANNEL_ID를 설정해주세요!")
        print("\n채널 ID 얻는 방법:")
        print("1. Discord 설정 → 고급 → 개발자 모드 활성화")
        print("2. Midjourney 채널 우클릭 → ID 복사")
        return

    # 자동화 실행
    automation = MidjourneyAutomation(DISCORD_TOKEN, MIDJOURNEY_CHANNEL_ID)
    await automation.run()


# ===== 실행 =====
if __name__ == "__main__":
    print("""
╔══════════════════════════════════════════════════════════╗
║  Midjourney Discord 자동화 스크립트                      ║
║                                                          ║
║  ⚠️  경고:                                               ║
║  - Discord 사용자 계정 자동화는 ToS 위반입니다          ║
║  - 계정 정지 위험이 있습니다                            ║
║  - 개인 사용, 적당한 빈도로만 사용하세요                ║
║  - 자기 책임하에 사용하세요                             ║
╚══════════════════════════════════════════════════════════╝
    """)

    input("계속하려면 Enter를 누르세요...")

    asyncio.run(main())
