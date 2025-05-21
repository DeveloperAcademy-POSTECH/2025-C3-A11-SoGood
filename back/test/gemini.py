import os
from dotenv import load_dotenv
import google.generativeai as genai

load_dotenv()

api_key = os.getenv("GEMNI_API_KEY")

# API 키로 구성
genai.configure(api_key=api_key)

# 모델을 사용하여 컨텐츠 생성
model = genai.GenerativeModel('gemini-2.0-flash')
response = model.generate_content("한글도 가능?")

print(response.text)