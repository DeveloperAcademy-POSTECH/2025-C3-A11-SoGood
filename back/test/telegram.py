from telethon import TelegramClient, events
from telethon.tl.functions.messages import GetDialogsRequest
from telethon.tl.types import InputPeerEmpty
import os
from dotenv import load_dotenv
import asyncio

# .env 파일에서 환경 변수 로드
load_dotenv()

# Telegram API 정보
api_id = os.getenv('TELEGRAM_API_ID')
api_hash = os.getenv('TELEGRAM_API_HASH')
phone = os.getenv('TELEGRAM_PHONE')

# 클라이언트 설정
client = TelegramClient('telegram_session', api_id, api_hash)

async def get_all_chats():
    # 클라이언트 시작
    await client.connect()
    
    # 인증 확인
    if not await client.is_user_authorized():
        await client.send_code_request(phone)
        print(f"{phone}으로 코드를 보냈습니다. 코드를 입력하세요:")
        code = input()
        await client.sign_in(phone, code)
    
    print("모든 대화 불러오는 중...")
    
    # 대화 목록 가져오기
    result = await client(GetDialogsRequest(
        offset_date=None,
        offset_id=0,
        offset_peer=InputPeerEmpty(),
        limit=100,
        hash=0
    ))
    
    chats = result.chats
    
    print(f"\n총 {len(chats)}개의 채팅방이 있습니다.")
    
    # 각 채팅방 정보 출력
    for i, chat in enumerate(chats):
        try:
            print(f"\n{i+1}. {chat.title}")
            
            # 각 채팅방의 최근 메시지 가져오기
            messages = await client.get_messages(chat, limit=10)
            
            print(f"-- 최근 메시지 {len(messages)}개 --")
            for msg in messages:
                sender = await msg.get_sender()
                sender_name = f"{sender.first_name} {sender.last_name if sender.last_name else ''}" if sender else "알 수 없음"
                content = msg.message if msg.message else "[미디어/특수 메시지]"
                print(f"[{msg.date}] {sender_name}: {content}")
            
        except Exception as e:
            print(f"채팅방 정보를 가져오는 중 오류 발생: {e}")
    
    await client.disconnect()

async def get_messages_from_chat(chat_id, limit=100):
    await client.connect()
    
    if not await client.is_user_authorized():
        await client.send_code_request(phone)
        print(f"{phone}으로 코드를 보냈습니다. 코드를 입력하세요:")
        code = input()
        await client.sign_in(phone, code)
    
    entity = await client.get_entity(chat_id)
    messages = await client.get_messages(entity, limit=limit)
    
    print(f"\n'{entity.title if hasattr(entity, 'title') else entity.first_name}'에서 메시지 {len(messages)}개 가져왔습니다:")
    
    for msg in messages:
        sender = await msg.get_sender()
        sender_name = f"{sender.first_name} {sender.last_name if sender.last_name else ''}" if sender else "알 수 없음"
        content = msg.message if msg.message else "[미디어/특수 메시지]"
        print(f"[{msg.date}] {sender_name}: {content}")
    
    await client.disconnect()

if __name__ == "__main__":
    print("Telegram 채팅 로그 가져오기")
    print("1. 모든 채팅방 및 최근 메시지 보기")
    print("2. 특정 채팅방의 메시지 가져오기")
    
    choice = input("선택: ")
    
    if choice == "1":
        asyncio.run(get_all_chats())
    elif choice == "2":
        chat_id = input("채팅방 ID 또는 사용자명(@username)을 입력하세요: ")
        limit = int(input("가져올 메시지 수(기본 100): ") or "100")
        asyncio.run(get_messages_from_chat(chat_id, limit))
    else:
        print("잘못된 선택입니다.")
