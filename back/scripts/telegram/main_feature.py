from telethon.tl.types import Channel
from datetime import datetime, timedelta, timezone

from scripts.telegram.filter import find_sector, message_filter
from data.telegram_raw_datas import avoid_channels
import asyncio

KST = timezone(timedelta(hours=9))

class TelegramMainFeature:
    def __init__(self, client, start_date, end_date):
        self.client = client
        self.start_date = start_date
        self.end_date = end_date

    # 필요한 채널만 가져오기
    async def get_needed_channels(self):
        channels = []
        # 채널 목록 가져오기
        dialogs = await self.client.get_dialogs()

        for dialog in dialogs:
            entity = dialog.entity
            if isinstance(entity, Channel):
                if entity.title not in avoid_channels:
                    channels.append(entity.id)
        return channels

    # 텔레그램 메시지 (시간을 기준으로) 해당 채널 크롤링
    async def get_messages(self, channel_id, start_date, end_date, crawled_data, for_gemini_crawled_data):
        try:
            channel = await self.client.get_entity(channel_id)

            messages = await self.client.get_messages(channel, offset_date=start_date, reverse=False, limit=500)
            for message in messages:
                message_date = message.date.astimezone(KST)
                if message_date > start_date:
                    continue

                if message.date < end_date:
                    break

                try:
                    if not hasattr(message, 'message') or not message.message:
                        continue

                    channel_message = message_filter(message.message)

                    if channel_message != 0:
                        sectors = find_sector(message.message)
                        date_str = message_date.strftime('%Y-%m-%d')
                        channel_title = channel.title

                        if not sectors:
                            continue

                        for sector in sectors:
                            if sector not in crawled_data:
                                crawled_data[sector] = {}
                                for_gemini_crawled_data[sector] = {}
                            
                            if date_str not in crawled_data[sector]:
                                crawled_data[sector][date_str] = {}
                                for_gemini_crawled_data[sector][date_str] = {}

                            if channel_title not in crawled_data[sector][date_str]:
                                crawled_data[sector][date_str][channel_title] = {"posts":[]}
                                for_gemini_crawled_data[sector][date_str][channel_title] = {"posts":[]}
                                
                            post_info = {
                                "time": message.date.strftime('%Y-%m-%d %H:%M:%S'),
                                "content": channel_message,
                                "views": message.views
                            }

                            crawled_data[sector][date_str][channel_title]["posts"].append(post_info)
                            for_gemini_crawled_data[sector][date_str][channel_title]["posts"].append(channel_message)
                            
                except Exception as e:
                    print(f"get_messages Error: {e}")
                    continue
            return crawled_data, for_gemini_crawled_data
            

   
        except Exception as e:
            print(f"get_messages Error: {e}")
            return None


    async def export_data(self):
        crawled_data = {}
        for_gemini_crawled_data = {}
        channels = await self.get_needed_channels()
        for channel in channels:
            print(f"Crawling {channel}...")
            await self.get_messages(channel, self.start_date, self.end_date, crawled_data, for_gemini_crawled_data)
            await asyncio.sleep(0.5)
        return crawled_data, for_gemini_crawled_data

