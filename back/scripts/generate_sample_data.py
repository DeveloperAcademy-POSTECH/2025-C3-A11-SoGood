import json
from pathlib import Path
import random
from datetime import datetime, timedelta

def generate_sample_data(num_records=100):
    # 샘플 데이터 생성
    data = []
    categories = ['기술', '금융', '에너지', '소비재', '의료']
    sentiments = ['긍정', '중립', '부정']
    
    for i in range(num_records):
        # 기본 데이터
        record = {
            'id': f'OP{i+1:04d}',
            'title': f'주식 의견 {i+1}',
            'content': f'이 주식에 대한 의견 {i+1}입니다.',
            'author': f'사용자{i+1}',
            'created_at': (datetime.now() - timedelta(days=random.randint(0, 30))).isoformat(),
            'stock_code': f'STOCK{random.randint(1000, 9999)}',
            'stock_name': f'주식회사 {random.randint(1, 100)}',
            'sentiment': random.choice(sentiments),
            'confidence': round(random.uniform(0.5, 1.0), 2)
        }
        data.append(record)
    
    return data

def generate_sample_data_with_categories(num_records=100):
    # 카테고리가 포함된 샘플 데이터 생성
    data = []
    categories = ['기술', '금융', '에너지', '소비재', '의료']
    sentiments = ['긍정', '중립', '부정']
    
    for i in range(num_records):
        # 기본 데이터
        record = {
            'id': f'OP{i+1:04d}',
            'title': f'주식 의견 {i+1}',
            'content': f'이 주식에 대한 의견 {i+1}입니다.',
            'author': f'사용자{i+1}',
            'created_at': (datetime.now() - timedelta(days=random.randint(0, 30))).isoformat(),
            'stock_code': f'STOCK{random.randint(1000, 9999)}',
            'stock_name': f'주식회사 {random.randint(1, 100)}',
            'sentiment': random.choice(sentiments),
            'confidence': round(random.uniform(0.5, 1.0), 2),
            'categories': random.sample(categories, random.randint(1, 3))
        }
        data.append(record)
    
    return data

def main():
    # 현재 스크립트의 위치를 기준으로 상대 경로 설정
    base_path = Path(__file__).parent.parent.parent
    
    # 샘플 데이터 생성
    sample_data = generate_sample_data(100)
    sample_data_with_categories = generate_sample_data_with_categories(100)
    
    # JSON 파일로 저장
    with open(base_path / 'sample_stock_opinion_data.json', 'w', encoding='utf-8') as f:
        json.dump(sample_data, f, ensure_ascii=False, indent=2)
    
    with open(base_path / 'sample_stock_opinion_data_with_categories.json', 'w', encoding='utf-8') as f:
        json.dump(sample_data_with_categories, f, ensure_ascii=False, indent=2)
    
    print("Sample data files have been generated successfully!")

if __name__ == '__main__':
    main() 