import json
from pathlib import Path
import os

# 경로 설정
current_dir = Path.cwd().parent
data_path = current_dir / "test" / "sector_analysis.json"

# JSON 파일 불러오기
with open(data_path, 'r', encoding='utf-8') as f:
    sector_data = json.load(f)

# JSON 구조 확인
print("최상위 키:")
for key in sector_data.keys():
    print(f"- {key}")

# 구조 파악 후 날짜 내림차순 정렬
# 첫 번째 키와 값의 구조 확인
if len(sector_data) > 0:
    first_key = list(sector_data.keys())[0]
    print(f"\n첫 번째 키: '{first_key}'")
    
    # 값이 리스트인 경우
    if isinstance(sector_data[first_key], list) and len(sector_data[first_key]) > 0:
        print("리스트 형태입니다. 첫 번째 항목:")
        first_item = sector_data[first_key][0]
        print(first_item)
        
        # 날짜 필드 확인
        if isinstance(first_item, dict) and 'date' in first_item:
            print("\n날짜 필드가 있으므로 정렬을 진행합니다.")
            # 각 섹터(키)별로 날짜 내림차순 정렬
            for key in sector_data:
                if isinstance(sector_data[key], list):
                    sector_data[key] = sorted(sector_data[key], key=lambda x: x.get('date', ''), reverse=True)
                    
            # 정렬 결과 확인 (첫 번째 섹터의 처음 3개 항목)
            print(f"\n정렬된 '{first_key}' 섹터의 처음 3개 항목:")
            for item in sector_data[first_key][:3]:
                if 'date' in item:
                    print(f"날짜: {item['date']}, 점수: {item.get('score', 'N/A')}")
    
    # 값이 딕셔너리인 경우
    elif isinstance(sector_data[first_key], dict):
        print("딕셔너리 형태입니다. 내부 구조:")
        for sub_key in sector_data[first_key]:
            print(f"- {sub_key}")
            
            # 내부 값이 리스트이고 날짜 정보가 있는지 확인
            if isinstance(sector_data[first_key][sub_key], list) and len(sector_data[first_key][sub_key]) > 0:
                first_sub_item = sector_data[first_key][sub_key][0]
                if isinstance(first_sub_item, dict) and 'date' in first_sub_item:
                    print(f"\n'{sub_key}' 내에 날짜 필드가 있으므로 정렬을 진행합니다.")
                    sector_data[first_key][sub_key] = sorted(sector_data[first_key][sub_key], 
                                                            key=lambda x: x.get('date', ''), 
                                                            reverse=True)

# 선택사항: 정렬된 데이터를 다시 파일로 저장하려면 아래 주석을 해제하세요
# with open(data_path, 'w', encoding='utf-8') as f:
#     json.dump(sector_data, f, ensure_ascii=False, indent=2) 