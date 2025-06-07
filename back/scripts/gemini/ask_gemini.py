import os
import json
import time
from dotenv import load_dotenv
import google.generativeai as genai

import sys
from pathlib import Path

# 상대 경로 추가
sys.path.append(str(Path(__file__).parents[2]))
from data.gemini_raw_data import gemini_prompt

load_dotenv()
api_key = os.getenv("GEMNI_API_KEY")
genai.configure(api_key=api_key)

class GeminiClient:
    def __init__(self, model_name="gemini-2.0-flash", max_retries=3):
        self.model = genai.GenerativeModel(model_name)
        self.max_retries = max_retries

    def ask(self, sector, data):
        prompt = gemini_prompt(sector, data)

        for attempt in range(self.max_retries):
            try:
                response = self.model.generate_content(prompt)
                response_filter = response.text[7:-3].strip()
                return json.loads(response_filter)
            except json.JSONDecodeError as e:
                print(f"[시도 {attempt + 1}] JSON 파싱 오류: {e}")
            except Exception as e:
                print(f"[시도 {attempt + 1}] 일반 오류: {e}")
                if "429" in str(e):
                    print("요청 제한에 걸렸습니다. 60초 대기 후 재시도합니다.")
                    time.sleep(60)
        
        print("최대 재시도 횟수 초과. 실패 처리.")
        return None