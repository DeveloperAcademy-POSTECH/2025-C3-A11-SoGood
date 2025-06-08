import Foundation

class DetailInfoViewModel: ObservableObject {
    @Published var selectedSector: String
    // score, summary 존재
    @Published var sectorDetail: SectorDetailDate?
    // channel 존재
    @Published var sectorDetailDetail: SectorDetailDetailDate?
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
                    let dict = sectorDetail.toDictionary()
                    self?.sectorDetail = sectorDetail
                } else {
                    // 기본값으로 SectorDetailDate 객체 생성
                    let defaultCounts = Counts(positive: 0, negative: 0, neutral: 0)
                    let defaultSentimentDetail = SentimentDetail(
                        headline: "정보없음",
                        summary: "해당 유형의 의견을 확인할 수 있는 게시글이 부족합니다."
                    )
                    let defaultSummary = Summary(
                        positive: defaultSentimentDetail,
                        neutral: defaultSentimentDetail,
                        negative: defaultSentimentDetail
                    )
                    self?.sectorDetail = SectorDetailDate(
                        counts: defaultCounts,
                        summary: defaultSummary
                    )
                }
            }
        }
    }

    // 섹터별 세부 설명상세 데이터
    func fetchSectorDetailDetailDate() {
        firestoreService.fetchSectorDetailDetailDateData(
            sectorName: selectedSector,
            date: date
        ) { [weak self] sectorDetailDetail in
            DispatchQueue.main.async {
                if let sectorDetailDetail = sectorDetailDetail {
                    let dict = sectorDetailDetail.toDictionary()
                    self?.sectorDetailDetail = sectorDetailDetail
                } else {
                    self?.sectorDetailDetail = SectorDetailDetailDate(channels: [:])
                }
            }
        }
    }
}