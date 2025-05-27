from telethon.tl.types import InputPeerEmpty, Channel, User, Chat
from telethon.tl.functions.messages import GetDialogsRequest
from telethon import TelegramClient, events
from dotenv import load_dotenv
from pathlib import Path
from datetime import datetime, timedelta
import asyncio
import json
import os

load_dotenv()

# Telegram API 정보
api_id = os.getenv('TELEGRAM_API_ID')
api_hash = os.getenv('TELEGRAM_API_HASH')
phone = os.getenv('TELEGRAM_PHONE')
import time

async def get_all_messages_by_date_range(channel_username, start_date, end_date):
    async with TelegramClient('session_name', api_id, api_hash) as client:
        await client.start(phone=phone)
        
        channel = await client.get_entity(channel_username)
        
        messages = []
        total_messages = 0
        
        # 메시지 수 카운터와 시간 측정
        start_time = time.time()
        print(f"시작 날짜: {start_date}, 종료 날짜: {end_date} 사이의 메시지를 가져옵니다.")
        
        async for message in client.iter_messages(
            channel, 
            offset_date=end_date,
            reverse=True
        ):
            # 날짜 범위 체크
            if message.date < start_date:
                break
                
            if message.date > end_date:
                continue
            
            # 메시지 저장 (필요한 정보만)
            messages.append({
                'id': message.id,
                'date': message.date.strftime('%Y-%m-%d %H:%M:%S'),
                'text': message.text if message.text else "",
                'sender_id': message.sender_id
            })
            
            total_messages += 1
            
            # 진행 상황 출력 (100개마다)
            if total_messages % 100 == 0:
                elapsed = time.time() - start_time
                print(f"{total_messages}개 메시지 처리 중... (경과 시간: {elapsed:.1f}초)")
                
                # API 제한 방지를 위한 지연
                await asyncio.sleep(0.5)
        
        print(f"완료! 총 {total_messages}개 메시지를 가져왔습니다. (총 소요 시간: {time.time() - start_time:.1f}초)")
        return messages

# 예: 1년 치 메시지 가져오기
async def main():
    end_date = datetime.now()
    start_date = end_date - timedelta(days=60)  # 2달
    
    channel_username = 1500265128
    messages = await get_all_messages_by_date_range(channel_username, start_date, end_date)
    
    # 필요시 파일로 저장
    import json
    with open(f"../data/{channel_username}_messages.json", "w", encoding="utf-8") as f:
        json.dump(messages, f, ensure_ascii=False, indent=2)

asyncio.run(main())