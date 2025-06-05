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
    
    init() {
        loadSectorData()
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
                                DispatchQueue.main.async {
                                    dateInfoDict[date] = dateInfo

                                }
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
            
            group.notify(queue: .main) {
                self.sectors = sectorDataDict
                self.selectedSector = sectors.first
                self.calculateSentimentRatios()
                self.isLoading = false
            }
        }
    }
    
    // 특정 섹터의 감정 비율 계산
    func calculateSentimentRatios(forSector sectorName: String? = nil) {
        var sentimentCount: [String: Int] = ["긍정": 0, "중립": 0, "부정": 0]
        var totalCount = 0
        
        let sectorsToCalculate: [String: SectorData]
        if let sectorName = sectorName {
            if let sectorData = sectors[sectorName] {
                sectorsToCalculate = [sectorName: sectorData]
            } else {
                return
            }
        } else {
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
        
        guard totalCount > 0 else {
            print("⚠️ 데이터가 없습니다.")
            return
        }
        
        self.sentimentRatios = sentimentCount.mapValues { count in
            (Double(count) / Double(totalCount)) * 100.0
        }
        
        print("✅ 감정 비율 계산 완료 \(sectorName ?? "전체"):")
        sentimentRatios.forEach { sentiment, ratio in
            print("\(sentiment): \(ratio)%")
        }
    }
    
    func selectSector(_ sectorName: String) {
        self.selectedSector = sectorName
        calculateSentimentRatios(forSector: sectorName)
    }
}
