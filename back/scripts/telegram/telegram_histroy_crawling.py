from telegram_auth import TelegramAuth
from telegram_filter import filter_channel, find_sector
import asyncio


async def get_channel_messages(client, channel_id, start_date, end_date, telegram_crawling):
    pass


async def main():
    # 로그인
    auth = TelegramAuth()
    client = await auth.authenticate()

    # 채널 필터링
    channels = filter_channel(client)

    await auth.disconnect()

if __name__ == "__main__":
    asyncio.run(main())