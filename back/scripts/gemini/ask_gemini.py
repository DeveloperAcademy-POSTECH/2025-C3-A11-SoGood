import os
import json
from dotenv import load_dotenv
import google.generativeai as genai
from data.gemini_raw_data import gemini_prompt

load_dotenv()

class GeminiClient:
    def __init__(self, model_name="gemini-2.0-flash", api_key=None, max_retries=3):
        genai.configure(api_key=self.api_key)
        self.api_key = api_key or os.getenv("GEMNI_API_KEY")
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
            
        print("최대 재시도 횟수 초과. 실패 처리.")
        return None