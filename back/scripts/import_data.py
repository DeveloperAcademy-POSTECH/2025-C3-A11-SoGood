import json
import os
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from pathlib import Path
from datetime import datetime
from collections import defaultdict
import asyncio

# Firebase Admin SDK 초기화
cred = credentials.Certificate('serviceAccountKey.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

async def import_json_data(file_path: str):
    try:
        # JSON 파일 읽기
        with open(file_path, 'r', encoding='utf-8') as f:
            json_data = json.load(f)
        
        # 데이터가 리스트인지 확인
        if not isinstance(json_data, list):
            raise ValueError('JSON 데이터는 리스트 형태여야 합니다.')

        # 1. 카테고리별 컬렉션 구조로 저장
        await import_by_category(json_data)
        
        # 2. 하이브리드 방식으로 저장 (개별 의견 + 통계)
        await import_hybrid(json_data)

        print('Successfully imported data using both methods')
        
    except Exception as e:
        print(f'Error importing data: {str(e)}')

async def import_by_category(data):
    """카테고리별 컬렉션 구조로 데이터 저장"""
    try:
        # 날짜별, 카테고리별로 데이터 그룹화
        category_data = defaultdict(lambda: defaultdict(list))
        
        for item in data:
            date = item.get('created_at', '').split('T')[0]  # YYYY-MM-DD 형식
            category = item.get('category', '기타')
            category_data[category][date].append(item)

        # 각 카테고리별로 배치 처리
        for category, dates in category_data.items():
            batch = db.batch()
            count = 0
            
            for date, items in dates.items():
                # 해당 날짜의 통계 계산
                stats = {
                    'avg_score': sum(item.get('score', 0) for item in items) / len(items),
                    'count': len(items),
                    'sentiment_distribution': defaultdict(int)
                }
                
                # 감정 분포 계산
                for item in items:
                    sentiment = item.get('sentiment', '중립')
                    stats['sentiment_distribution'][sentiment] += 1
                
                # Firestore에 저장
                doc_ref = db.collection('category_stats').document(category).collection('daily').document(date)
                batch.set(doc_ref, stats)
                count += 1
                
                if count >= 500:  # Firebase 배치 제한
                    await batch.commit()
                    batch = db.batch()
                    count = 0
            
            if count > 0:
                await batch.commit()
            
            print(f'Imported category stats for {category}')

    except Exception as e:
        print(f'Error in import_by_category: {str(e)}')

async def import_hybrid(data):
    """하이브리드 방식으로 데이터 저장 (개별 의견 + 통계)"""
    try:
        # 1. 개별 의견 저장
        batch = db.batch()
        count = 0
        
        for item in data:
            doc_ref = db.collection('stock_opinions').document()
            batch.set(doc_ref, item)
            count += 1
            
            if count >= 500:
                await batch.commit()
                batch = db.batch()
                count = 0
        
        if count > 0:
            await batch.commit()
        
        print('Imported individual opinions')

        # 2. 통계 데이터 계산 및 저장
        stats_by_date = defaultdict(lambda: defaultdict(lambda: {
            'total_score': 0,
            'count': 0,
            'sentiment_distribution': defaultdict(int)
        }))

        # 통계 계산
        for item in data:
            date = item.get('created_at', '').split('T')[0]
            category = item.get('category', '기타')
            score = item.get('score', 0)
            sentiment = item.get('sentiment', '중립')

            stats = stats_by_date[date][category]
            stats['total_score'] += score
            stats['count'] += 1
            stats['sentiment_distribution'][sentiment] += 1

        # 통계 데이터 저장
        batch = db.batch()
        count = 0

        for date, categories in stats_by_date.items():
            for category, stats in categories.items():
                avg_score = stats['total_score'] / stats['count'] if stats['count'] > 0 else 0
                
                doc_data = {
                    'avg_score': avg_score,
                    'count': stats['count'],
                    'sentiment_distribution': dict(stats['sentiment_distribution'])
                }

                doc_ref = db.collection('daily_stats').document(date).collection('categories').document(category)
                batch.set(doc_ref, doc_data)
                count += 1

                if count >= 500:
                    await batch.commit()
                    batch = db.batch()
                    count = 0

        if count > 0:
            await batch.commit()

        print('Imported daily statistics')

    except Exception as e:
        print(f'Error in import_hybrid: {str(e)}')

async def main():
    # 현재 스크립트의 위치를 기준으로 상대 경로 설정
    base_path = Path(__file__).parent.parent.parent
    
    # JSON 파일 경로
    stock_opinion_path = base_path / 'sample_stock_opinion_data_1000.json'

    # 파일 존재 여부 확인
    if not stock_opinion_path.exists():
        print(f"Error: {stock_opinion_path} does not exist")
        return

    print(f"Importing from {stock_opinion_path}")

    # 데이터 임포트 실행
    await import_json_data(str(stock_opinion_path))

if __name__ == '__main__':
    asyncio.run(main()) 