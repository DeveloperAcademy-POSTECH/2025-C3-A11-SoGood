import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parents[1]))

from scripts.telegram.histroy_crawling import crawl_filtered_data_from_telegram
from scripts.gemini.main_feature import daily_scoring
from scripts.firebase.put_data import PutData

import json

current_dir = Path(__file__).parent

async def daily_task(n):
    crawled_data, for_gemini_crawled_data = await crawl_filtered_data_from_telegram(n)
    gemini_result_data = daily_scoring(for_gemini_crawled_data, {})

    put_data = PutData()
    put_data.put_sector_score(gemini_result_data)
    put_data.put_sector_detail__dates(gemini_result_data)
    put_data.put_sector_detail__detail_dates(crawled_data, gemini_result_data)

