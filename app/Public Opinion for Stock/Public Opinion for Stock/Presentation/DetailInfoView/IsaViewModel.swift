import Foundation
import FirebaseFirestore

class SectorViewModel: ObservableObject {
    @Published var sectors: [String: SectorData] = [:]
    @Published var selectedSector: String? = nil
    @Published var sentimentRatios: [String: Double] = [:]
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let db = Firestore.firestore()
    private let firestoreService = FirestoreService()
    
    init(shouldLoad: Bool = true) {
        if shouldLoad{
            loadSectorData()
        }
    }
    
    func loadSectorData() {
        isLoading = true
        errorMessage = nil
        
        firestoreService.fetchAllSectors { [weak self] sectors in
            guard let self = self else { return }
            
            if sectors.isEmpty {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "섹터 데이터를 찾을 수 없습니다."
                }
                return
            }
            
            var sectorDataDict: [String: SectorData] = [:]
            let group = DispatchGroup()
            
            for sector in sectors {
                group.enter()
                
                self.firestoreService.fetchDates(for: sector) { dates in
                    var dateInfoDict: [String: DateInfo] = [:]
                    let dateGroup = DispatchGroup()
                    
                    for date in dates {
                        dateGroup.enter()
                        
                        self.firestoreService.fetchDateInfo(for: sector, date: date) { dateInfo in
                            if let dateInfo = dateInfo {
                                dateInfoDict[date] = dateInfo
                                
                                
                            }
                            dateGroup.leave()
                        }
                    }
                    
                    // dateGroup이 완료된 후에 SectorData를 생성하고 group.leave() 호출
                    dateGroup.notify(queue: .main) { [weak self] in
                        guard self != nil else { return }
                        
                        // SectorData 생성 - 일반 이니셜라이저 사용
                        let sectorData = SectorData(id: sector, dates: dateInfoDict)
                        sectorDataDict[sector] = sectorData
                        
                        // 모든 날짜 데이터가 처리된 후에 group.leave() 호출
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) { [weak self] in
                guard let self = self else { return }
                self.sectors = sectorDataDict
                self.selectedSector = sectors.first
                
                
                DispatchQueue.main.async {
                    if let sector = self.selectedSector,
                       let date = self.sectors[sector]?.dates.keys.sorted().first {
                        self.calculateSentimentRatios(for: sector, date: date)
                    } else {
                        self.sentimentRatios = [:]
                    }
                    self.isLoading = false
                    
                }
            }
        }
    }
    //
    //    // 특정 섹터의 감정 비율 계산
    //    func calculateSentimentRatios(forSector sectorName: String? = nil) {
    //        var sentimentCount: [String: Int] = ["긍정": 0, "중립": 0, "부정": 0]
    //        var totalCount = 0
    //
    //        let sectorsToCalculate: [String: SectorData]
    //        if let sectorName = sectorName {
    //            if let sectorData = sectors[sectorName] {
    //                sectorsToCalculate = [sectorName: sectorData]
    //            } else {
    //                return
    //            }
    //        } else {
    //            sectorsToCalculate = sectors
    //        }
    //
    //        // 감정 카운트 합산
    //        for (_, sectorData) in sectorsToCalculate {
    //            for (_, dateInfo) in sectorData.dates {
    //                let pos = dateInfo.counts.positive
    //                let neu = dateInfo.counts.nutural
    //                let neg = dateInfo.counts.negative
    //
    //                sentimentCount["긍정"]! += pos
    //                sentimentCount["중립"]! += neu
    //                sentimentCount["부정"]! += neg
    //
    //                totalCount += pos + neu + neg
    //
    //            }
    //        }
    //
    //        guard totalCount > 0 else {
    //            print("⚠️ 데이터가 없습니다.")
    //            return
    //        }
    //
    //        self.sentimentRatios = sentimentCount.mapValues { count in
    //            (Double(count) / Double(totalCount)) * 100.0
    //        }
    //
    //        print("✅ 감정 비율 계산 완료 \(sectorName ?? "전체"):")
    //        sentimentRatios.forEach { sentiment, ratio in
    //            print("\(sentiment): \(ratio)%")
    //        }
    //    }
    
    
    func calculateSentimentRatios(for sector: String, date: String) {
        guard let sectorData = sectors[sector],
              let dateInfo = sectorData.dates[date] else {
            sentimentRatios = [:]
            return
        }
        
        let counts = dateInfo.counts
        let total = counts.positive + counts.nutural + counts.negative
        
        guard total > 0 else {
            sentimentRatios = [:]
            return
        }
        
        sentimentRatios = [
            "긍정": Double(counts.positive) / Double(total) * 100.0,
            "중립": Double(counts.nutural) / Double(total) * 100.0,
            "부정": Double(counts.negative) / Double(total) * 100.0
        ]
        
        sentimentRatios.forEach { sentiment, ratio in
            print("\(sentiment): \(ratio)%")
        }
        print("📊 감정 카운트 - 긍정: \(counts.positive), 중립: \(counts.nutural), 부정: \(counts.negative)")
        print("📊 총합: \(total)")
    }
    
    
    
    func selectSector(_ sectorName: String) {
        self.selectedSector = sectorName
        
        if let sectorData = sectors[sectorName],
           let firstDate = sectorData.dates.keys.sorted().first {
            calculateSentimentRatios(for: sectorName, date: firstDate)
        } else {
            sentimentRatios = [:]
        }
    }
    
    func injectSectorData(sector: String, data: SectorData) {
        self.sectors[sector] = data
    }
}
