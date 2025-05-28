import json
import os

# JSON 파일 경로
input_file = '../data/sector_data.json'
output_file = 'channel_posts.json'

# 현재 스크립트의 디렉토리 경로
current_dir = os.path.dirname(os.path.abspath(__file__))
input_path = os.path.join(current_dir, input_file)
output_path = os.path.join(current_dir, output_file)

# JSON 파일 읽기
with open(input_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

# 채널 이름과 포스트만 추출
result = {}

for sector in data.keys():
    for date in data[sector].keys():
        for channel in data[sector][date].keys():
            # 채널이 아직 결과에 없으면 추가
            if channel not in result:
                result[channel] = {
                    "posts": []
                }
            
            # 채널 데이터가 리스트인 경우, 각 포스트의 'content' 필드만 추출
            for post in data[sector][date][channel]['posts']:
                result[channel]["posts"].append(post['content'])

# 결과를 새 JSON 파일로 저장
with open(output_path, 'w', encoding='utf-8') as f:
    json.dump(result, f, ensure_ascii=False, indent=2)

print(f'추출된 채널 수: {len(result)}')