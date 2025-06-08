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
    
    func calculateSentimentRatios(for sector: String, date: String) -> [String: Double] {
        guard let sectorData = sectors[sector],
              let dateInfo = sectorData.dates[date] else {
            self.sentimentRatios = [:]
            return [:]
        }
        
        let counts = dateInfo.counts
        let total = counts.positive + counts.neutral + counts.negative
        
        guard total > 0 else {
            self.sentimentRatios = [:]
            return [:]
        }
        
        let calculatedRatios = [
            "긍정": Double(counts.positive) / Double(total) * 100.0,
            "중립": Double(counts.neutral) / Double(total) * 100.0,
            "부정": Double(counts.negative) / Double(total) * 100.0
        ]
        
        self.sentimentRatios = calculatedRatios
        return calculatedRatios
    }
    
    
    func injectSectorData(sector: String, data: SectorData) {
        self.sectors[sector] = data
    }
}
