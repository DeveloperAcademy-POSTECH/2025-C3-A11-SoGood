#!/bin/bash

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 현재 디렉토리 확인
if [ ! -d "scripts" ]; then
    echo -e "${RED}Error: scripts 디렉토리를 찾을 수 없습니다.${NC}"
    echo -e "back 디렉토리에서 실행해주세요."
    exit 1
fi

# Firebase 서비스 계정 키 확인
if [ ! -f "serviceAccountKey.json" ]; then
    echo -e "${YELLOW}Warning: serviceAccountKey.json 파일이 없습니다.${NC}"
    echo -e "Firebase Console에서 서비스 계정 키를 다운로드하여 back 디렉토리에 복사해주세요."
    exit 1
fi

# JSON 데이터 파일 확인
if [ ! -f "../sample_stock_opinion_data_1000.json" ]; then
    echo -e "${RED}Error: sample_stock_opinion_data_1000.json 파일을 찾을 수 없습니다.${NC}"
    echo -e "프로젝트 루트 디렉토리에 파일이 있는지 확인해주세요."
    exit 1
fi

# 가상환경 확인 및 활성화
if [ -d "venv" ]; then
    echo -e "${GREEN}가상환경을 활성화합니다...${NC}"
    source venv/bin/activate
else
    echo -e "${YELLOW}가상환경이 없습니다. 새로 생성합니다...${NC}"
    python3 -m venv venv
    source venv/bin/activate
    
    echo -e "${GREEN}필요한 패키지를 설치합니다...${NC}"
    pip install -r requirements.txt
fi

# 데이터 임포트 실행
echo -e "${GREEN}데이터 임포트를 시작합니다...${NC}"
python3 scripts/import_data.py

# 실행 결과 확인
if [ $? -eq 0 ]; then
    echo -e "${GREEN}데이터 임포트가 성공적으로 완료되었습니다!${NC}"
else
    echo -e "${RED}데이터 임포트 중 오류가 발생했습니다.${NC}"
fi

# 가상환경 비활성화
deactivate 