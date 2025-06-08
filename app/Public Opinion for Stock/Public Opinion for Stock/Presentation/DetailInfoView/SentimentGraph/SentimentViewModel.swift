import SwiftUI
import FirebaseFirestore

class SentimentViewModel: ObservableObject {
    @Published var records: [SentimentRecord] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var selectedSector: String
    
    init(selectedSector: String) {
        self.selectedSector = selectedSector
        fetchSentimentData()
    }
    
    func updateCategory(_ newCategory: String) {
        self.selectedSector = newCategory
        fetchSentimentData()
    }
    
    func fetchSentimentData() {
        isLoading = true
        errorMessage = nil
        
        db.collection("sector_detail")
            .document(selectedSector)
            .collection("dates")
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if let error = error {
                        self?.errorMessage = "데이터를 가져오는데 실패했습니다: \(error.localizedDescription)"
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        self?.errorMessage = "데이터가 없습니다."
                        return
                    }
                    
                    self?.records = documents.compactMap { document -> SentimentRecord? in
                        let data = document.data()
                        guard let date = document.documentID as String?,
                              let counts = data["counts"] as? [String: Any],
                              let positive = counts["positive"] as? Int,
                              let negative = counts["negative"] as? Int,
                              let neutral = counts["neutral"] as? Int else {
                            return nil
                        }
                        return SentimentRecord(date: date, category: self?.selectedSector ?? "", positive: positive, negative: negative, neutral: neutral)
                    }.sorted { $0.date < $1.date }
                }
            }
    }
} 
