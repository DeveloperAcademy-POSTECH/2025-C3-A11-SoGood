import Foundation

class DetailInfoViewModel: ObservableObject {
    @Published var selectedSector: String
    // 각 체널들의 score, summary
    @Published var sectorDetail: [String: Any]?
    // score 퍼센트로 변환.
    @Published var sectorPercent: [String: Double]? 
    // 각 체널들의 채팅 상새내용
    @Published var sectorDetailDetail: [String: Any]?
    let date: String
    
    private let firestoreService = FirestoreService()

    init(selectedSector: String, date: String) {
        self.selectedSector = selectedSector
        self.date = date
        fetchSectorDetailDate()
        fetchSectorDetailDetailDate()
    }

    func updateSector(_ newSector: String) {
        selectedSector = newSector
        fetchSectorDetailDate()
        fetchSectorDetailDetailDate()
    }

    // 섹터별 설명상세 데이터
    func fetchSectorDetailDate() {
        firestoreService.fetchSectorDetailDateData(
            sectorName: selectedSector,
            date: date
        ) { [weak self] sectorDetail in
            DispatchQueue.main.async {
                if let sectorDetail = sectorDetail {
                    self?.sectorDetail = sectorDetail.toDictionary() 
                    let detail = sectorDetail.toDictionary() 
                    self?.sectorDetail = detail
                    if let strongSelf = self {
                        strongSelf.sectorPercent = strongSelf.calculateSectorPercent(counts: detail["counts"] as? [String: Int] ?? [:])
                    }
                } else {
                    // 기본값 Dictionary
                    self?.sectorDetail = [
                        "counts": ["positive": 0, "negative": 0, "neutral": 0],
                        "summary": [
                            "positive": ["headline": "정보없음", "summary": "해당 유형의 의견을 확인할 수 있는 게시글이 부족합니다."],
                            "neutral": ["headline": "정보없음", "summary": "해당 유형의 의견을 확인할 수 있는 게시글이 부족합니다."],
                            "negative": ["headline": "정보없음", "summary": "해당 유형의 의견을 확인할 수 있는 게시글이 부족합니다."]
                        ]
                    ]
                }
            }
        }
    }

    // 섹터별 세부 설명상세 데이터
    private func fetchSectorDetailDetailDate() {
        firestoreService.fetchSectorDetailDetailDateData(
            sectorName: selectedSector,
            date: date
        ) { [weak self] sectorDetailDetail in
            DispatchQueue.main.async {
                if let sectorDetailDetail = sectorDetailDetail {
                    self?.sectorDetailDetail = sectorDetailDetail.toDictionary()
                } else {
                    self?.sectorDetailDetail = [:]
                }
            }
        }
    }

    // 섹터 별 점수 계산
    private func calculateSectorPercent(counts: [String: Int]) -> [String: Double] {
        let total = counts.values.reduce(0, +)
        guard total > 0 else {
            return ["positive": 0.0, "neutral": 0.0, "negative": 0.0]
        }
        
        var sectorPercent: [String: Double] = [:]
        for (key, value) in counts {
            let percentage = Double(value) / Double(total) * 100
            sectorPercent[key] = round(percentage * 10) / 10
        }
        return sectorPercent
    }
}
