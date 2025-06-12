from scripts.telegram.main_feature import TelegramMainFeature
from scripts.telegram.auth import TelegramAuth

from datetime import datetime, timedelta, timezone

KST = timezone(timedelta(hours=9))
now = datetime.now(KST)

# 당일 00시 이전 데이터 기준 n일 전 데이터 크롤링
async def crawl_filtered_data_from_telegram(n=1):
    start_date = datetime(now.year, now.month, now.day, 0, 0, 0, tzinfo=KST) #- timedelta(days=1)
    end_date = start_date - timedelta(days=n)

    # 로그인
    auth = TelegramAuth()
    client = await auth.authenticate()

    main_feature = TelegramMainFeature(client, start_date, end_date)

    crawled_data, for_gemini_crawled_data = await main_feature.export_data()
    await auth.disconnect()

    return crawled_data, for_gemini_crawled_data