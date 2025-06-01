



## Firebase 저장 구조
- "sector_score"(collection)
    - "datas"(docs)
        - {모든 섹터 각각: {positive: 00, neutral: 00, negative: 00}}

- "sector_detail"(collection)
    - 각 섹터 이름 |ex."전선"| (docs)
        - { "sector": "전선" } -> docs 이름 확인 하기 위한 형식상 데이터

        - "monthly_data"(collection)
            - 각 연도와 달 |ex."25-05"| (docs)
                - {"25-05-":
                    {
                        positive: 00,
                        neutral: 00,
                        negative: 00
                    },
                    
                }

        - "quarters_data"(collection)

    
        - "dates"(collection)
            - 해당 일자 |ex. "25-05-30"| (docs)
                - {
                    "summary": {
                        "positive": {
                            "headline": "헤드라인",
                            "summary": "요약"
                        },
                        "neutral": {
                            "headline": "헤드라인",
                            "summary": "요약"
                        },
                        "negative": {
                            "headline": "헤드라인",
                            "summary": "요약"
                        }
                    }
                }

## 데이터 구조
- 섹터
    - 날짜
        - 채팅방
            - 게시글(+시간, 조회수, 댓글) => 기반해서 긍정도 부정도 도출
            - 긍정도 부정도 중립 평균
        - 모든 채팅방 요약
        - 각 채팅방 언급도 및 조회수, 댓글을 기반 점수 도출


