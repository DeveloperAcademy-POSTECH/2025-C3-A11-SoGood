//
//  TestViewModel.swift
//  Public Opinion for Stock
//
//  Created by 우정아 on 6/2/25.
//

import Foundation


class SectorViewModel: ObservableObject {
    @Published var sectors: [String: SectorData] = [:]  // 섹터별 데이터
    @Published var selectedSector: String? = nil  // 현재 선택된 섹터
    @Published var sentimentRatios: [String: Double] = [:]  // 감정 비율
    
    init() {
        loadSectorData()
    }
    
    func loadSectorData() {
        guard let url = Bundle.main.url(forResource: "sector_summary_mock_data", withExtension: "json") else {
            print("❌ JSON 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            print("📄 데이터 로드 완료: \(data.count) bytes")
            
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(SectorCollection.self, from: data)
            print("✅ 디코딩 성공")
            print("📊 섹터 수: \(decoded.count)")
            print("📊 섹터 목록: \(decoded.keys.joined(separator: ", "))")
            
            self.sectors = decoded
            
            // 첫 번째 섹터를 기본 선택
            self.selectedSector = decoded.keys.sorted().first
            
            // 전체 감정 비율 계산
            calculateSentimentRatios()
            
        } catch {
            print("❌ JSON 디코딩 에러: \(error)")
            print("🔍 상세 에러: \(error.localizedDescription)")
        }
    }
    
    // 특정 섹터의 감정 비율 계산
    func calculateSentimentRatios(forSector sectorName: String? = nil) {
        var sentimentCount: [String: Int] = ["긍정": 0, "중립": 0, "부정": 0]
        var totalCount = 0
        
        let sectorsToCalculate: [String: SectorData]
        if let sectorName = sectorName {
            // 특정 섹터만 계산
            if let sectorData = sectors[sectorName] {
                sectorsToCalculate = [sectorName: sectorData]
            } else {
                return
            }
        } else {
            // 전체 섹터 계산
            sectorsToCalculate = sectors
        }
        
        // 감정 카운트 합산
        for (_, sectorData) in sectorsToCalculate {
            for (_, dateInfo) in sectorData.dates {
                sentimentCount["긍정"]! += dateInfo.counts.positive
                sentimentCount["중립"]! += dateInfo.counts.natural
                sentimentCount["부정"]! += dateInfo.counts.negative
                
                totalCount += dateInfo.counts.positive +
                            dateInfo.counts.natural +
                            dateInfo.counts.negative
            }
        }
        
        // 비율 계산
        guard totalCount > 0 else {
            print("⚠️ 데이터가 없습니다.")
            return
        }
        
        self.sentimentRatios = sentimentCount.mapValues { count in
            (Double(count) / Double(totalCount)) * 100.0
        }
        
        // 결과 출력
        print("✅ 감정 비율 계산 완료 \(sectorName ?? "전체"):")
        sentimentRatios.forEach { sentiment, ratio in
            print("\(sentiment): \(ratio)%")
        }
    }
    
    // 섹터 선택
    func selectSector(_ sectorName: String) {
        self.selectedSector = sectorName
        calculateSentimentRatios(forSector: sectorName)
    }
    
}
