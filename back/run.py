import time
import asyncio
import schedule
from scripts.daily import daily_task

async def job():
    await daily_task()

def run_job():
    asyncio.run(job())

run_job()

# 매일 아침 6시에 실행하도록 스케줄 설정
schedule.every().day.at("06:00").do(run_job)

def main():
    while True:
        schedule.run_pending()
        time.sleep(1)


if __name__ == "__main__":
    main()