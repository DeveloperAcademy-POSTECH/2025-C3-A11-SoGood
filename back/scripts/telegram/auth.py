from telethon import TelegramClient
from dotenv import load_dotenv
import asyncio
import os

class TelegramAuth:
    def __init__(self, session_name='telegram_session'):
        load_dotenv()
        
        # Telegram API 정보
        self.api_id = os.getenv('TELEGRAM_API_ID')
        self.api_hash = os.getenv('TELEGRAM_API_HASH')
        self.phone = os.getenv('TELEGRAM_PHONE')
        
        # 클라이언트 초기화
        self.client = TelegramClient(session_name, self.api_id, self.api_hash)
    
    #인증
    async def authenticate(self):
        await self.client.connect()
        
        if not await self.client.is_user_authorized():
            await self.client.send_code_request(self.phone)
            print(f"{self.phone}으로 코드를 보냈습니다. 코드를 입력하세요:")
            code = input()
            await self.client.sign_in(self.phone, code)
            
        return self.client
    
    #연결 해제
    async def disconnect(self):
        await self.client.disconnect()
    
    #인증된 클라이언트 반환
    def get_client(self):
        return self.client

"""
# 기본 사용 예시
async def main():
    auth = TelegramAuth()
    client = await auth.authenticate()
    
    # 여기서 클라이언트를 사용한 작업 수행
    print("인증 완료!")
    
    # 작업 완료 후 연결 해제
    await auth.disconnect()

# 스크립트로 직접 실행 시
if __name__ == "__main__":
    asyncio.run(main())
"""