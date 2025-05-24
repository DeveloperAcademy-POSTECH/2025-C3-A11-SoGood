from fastapi import APIRouter, HTTPException
import json
import os
from pathlib import Path

router = APIRouter(
    prefix="/sectors",
    tags=["sectors"],
    responses={404: {"description": "Not found"}},
)

# JavaScript 데이터 파일 경로
current_dir = Path(__file__).parent.parent
data_file_path = current_dir / "models" / "test_data.js"

# JavaScript 파일에서 JSON 데이터 추출
def extract_json_from_js():
    try:
        with open(data_file_path, "r", encoding="utf-8") as file:
            content = file.read()
            # JavaScript 객체를 Python 딕셔너리로 변환 (간단한 방식)
            # 실제로는 더 견고한 파싱이 필요할 수 있음
            json_str = content.split("const sectorData = ")[1].split("module.exports")[0].strip()
            if json_str.endswith(";"):
                json_str = json_str[:-1]
            
            # Python에서 읽을 수 있는 형식으로 변환
            json_str = json_str.replace("'", '"')
            
            # JSON 파싱
            return json.loads(json_str)
    except Exception as e:
        print(f"데이터 로딩 오류: {e}")
        return {"sectors": []}

# 모든 섹터 목록 조회
@router.get("/")
async def get_all_sectors():
    data = extract_json_from_js()
    return {"sectors": [{"id": sector["id"], "name": sector["name"]} for sector in data["sectors"]]}

# 특정 섹터 정보 조회
@router.get("/{sector_name}")
async def get_sector_data(sector_name: str):
    data = extract_json_from_js()
    
    # 섹터명으로 데이터 찾기
    for sector in data["sectors"]:
        if sector["name"] == sector_name:
            return sector
    
    raise HTTPException(status_code=404, detail=f"섹터 '{sector_name}'를 찾을 수 없습니다")

# 특정 섹터의 특정 날짜 정보 조회
@router.get("/{sector_name}/{date}")
async def get_sector_date_data(sector_name: str, date: str):
    data = extract_json_from_js()
    
    # 섹터명으로 데이터 찾기
    for sector in data["sectors"]:
        if sector["name"] == sector_name:
            # 해당 날짜의 데이터 찾기
            for daily_data in sector["data"]:
                if daily_data["date"] == date:
                    return {
                        "sector": sector_name,
                        "date": date,
                        "score": daily_data["score"],
                        "summary": daily_data["summary"]
                    }
            
            raise HTTPException(status_code=404, detail=f"섹터 '{sector_name}'의 '{date}' 데이터를 찾을 수 없습니다")
    
    raise HTTPException(status_code=404, detail=f"섹터 '{sector_name}'를 찾을 수 없습니다")