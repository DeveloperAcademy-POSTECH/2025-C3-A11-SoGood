import time
import asyncio
import schedule
from scripts.daily import daily_task

async def job(n):
    await daily_task(n)

def run_job(n):
    asyncio.run(job(n))

run_job(n = 7)

# 매일 아침 6시에 실행하도록 스케줄 설정
schedule.every().day.at("06:00").do(run_job, n = 1)

def main():
    while True:
        print(f"크롤링 시간: {time.strftime("%Y-%m-%d %H:%M:%S")}")
        schedule.run_pending()
        time.sleep(1)


if __name__ == "__main__":
    main()