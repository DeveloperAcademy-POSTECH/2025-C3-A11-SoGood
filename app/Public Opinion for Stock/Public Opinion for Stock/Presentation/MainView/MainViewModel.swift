import Foundation

class MainViewModel: ObservableObject {
    let yesterday: String
    @Published var sortedSectors: [MainRowItem] = []

    private var sectorScores: [String: Int] = [:]
    private let firestoreService = FirestoreService()
    
    init() {
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        self.yesterday = Self.formattedDate(yesterdayDate)
        fetchSectorScoreData()
    }

    //날짜 포맷 함수
    static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }

    private func calculateEmotionScore(positive: Int, negative: Int, neutral: Int) -> Int {
        let total = positive + negative + neutral
        var emotionScore = 0
        
        if total > 0 {
            if positive > negative {
                emotionScore = Int(Double(positive) / Double(total) * 100)
            } else if positive < negative {
                emotionScore = Int(Double(negative) / Double(total) * 100) * -1
            }else{
                emotionScore = 0
            }
        }
        
        return emotionScore
    }

    func fetchSectorScoreData() {
        firestoreService.fetchSectorScoreData { [weak self] sectorScores in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let scores = sectorScores {
                    let rawDict = scores.toDictionary()
                    
                    // 감정 점수 계산
                    var calculatedScores: [String: Int] = [:]
                    for (sector, counts) in rawDict {
                        calculatedScores[sector] = self.calculateEmotionScore(
                            positive: counts["positive"] ?? 0,
                            negative: counts["negative"] ?? 0,
                            neutral: counts["neutral"] ?? 0
                        )
                    }
                    
                    // 딕셔너리 저장
                    self.sectorScores = calculatedScores
                    
                    // 정렬된 배열 저장
                    self.sortedSectors = calculatedScores.map { sector, score in
                        MainRowItem(sector: sector, score: score)
                    }
                    .sorted { $0.score > $1.score }
                }
            }
        }
    }
}