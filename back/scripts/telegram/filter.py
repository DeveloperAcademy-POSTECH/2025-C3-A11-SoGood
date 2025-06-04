from telethon.tl.types import Channel
from pathlib import Path
import sys
import re 

# 상대 경로 추가
sys.path.append(str(Path(__file__).parents[2]))
from data.telegram_raw_datas import avoid_channels, sectors

## 채널 및 제거하고 싶은 채널 제거
def filter_channel(client):
    channels = []
    # 채널 목록 가져오기
    dialogs = client.get_dialogs()

    for dialog in dialogs:
        entity = dialog.entity
        if isinstance(entity, Channel):
            if entity.title not in avoid_channels:
                channels.append(entity.id)
    return channels

## 메시지에서 찾은 섹터 반환
def find_sector(messages):
    found_sectors = []
    for sector in sectors:
        for message in messages:
            if sector in message.message:
                found_sectors.append(sector)
    ## 중복 제거를 위해 set 사용
    return list(set(found_sectors))


# 8개 이상의 공백 \n 대체 + 뉴스기사 위주 text 0으로 return
def message_filter(message):
    # 불필요한 공백 개행문자(\n)로 대체
    cleaned_message = re.sub(r'\s{8,}','\n',message)
    
    # 모든 http 또는 https URL 찾기
    urls = re.findall(r'https?://[^\s]+', cleaned_message)
    
    # URL이 없는 경우 바로 반환
    if not urls:
        return cleaned_message
        
    # 모든 URL의 총 길이 계산
    url_total_length = sum(len(url) for url in urls)
    
    # 모든 URL을 제거하고 남은 텍스트 길이 계산
    text_without_urls = cleaned_message
    for url in urls:
        text_without_urls = text_without_urls.replace(url, '')
    remaining_text_length = len(text_without_urls.strip())
    
    # URL 길이 총합이 나머지 텍스트보다 짧으면 0 반환
    if url_total_length > remaining_text_length:
        return 0
        
    return cleaned_message
