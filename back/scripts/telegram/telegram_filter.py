from telethon.tl.types import Channel
from pathlib import Path
import sys
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
