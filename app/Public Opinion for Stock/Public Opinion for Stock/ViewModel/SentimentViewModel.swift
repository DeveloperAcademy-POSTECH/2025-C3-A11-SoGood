import SwiftUI
import FirebaseFirestore

class SentimentViewModel: ObservableObject {
    @Published var records: [SentimentRecord] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var sectors: [String] = []
    @Published var selectedSector: String {
        didSet {
            print("[DEBUG] selectedSector changed to: \(selectedSector)")
            fetchSentimentData()
        }
    }
    
    private let db = Firestore.firestore()
    
    init(category: String) {
        self.selectedSector = category
        fetchSectors()
        fetchSentimentData()
    }
    
    func fetchSectors() {
        print("[Firestore] fetchSectors() called")
        isLoading = true
        db.collection("try_sector_detail_page").getDocuments { [weak self] snapshot, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    print("[Firestore] Error fetching sectors: \(error.localizedDescription)")
                    self?.errorMessage = "섹터 목록을 가져오는데 실패했습니다: \(error.localizedDescription)"
                    return
                }
                let ids = snapshot?.documents.compactMap { $0.documentID } ?? []
                print("[Firestore] 섹터 목록: \(ids)")
                self?.sectors = ids
                if let first = ids.first, self?.selectedSector != first {
                    print("[DEBUG] Setting selectedSector to first sector: \(first)")
                    self?.selectedSector = first
                } else {
                    self?.fetchSentimentData()
                }
                if ids.isEmpty {
                    print("[Firestore] 섹터 목록이 비어있음")
                    self?.errorMessage = "섹터 목록이 비어있습니다."
                }
            }
        }
    }
    
    func fetchSentimentData() {
        print("[Firestore] fetchSentimentData() called for sector: \(selectedSector)")
        isLoading = true
        errorMessage = nil
        
        db.collection("try_sector_detail_page")
            .document(selectedSector)
            .collection("dates")
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if let error = error {
                        print("[Firestore] Error fetching sentiment data: \(error.localizedDescription)")
                        self?.errorMessage = "데이터를 가져오는데 실패했습니다: \(error.localizedDescription)"
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print("[Firestore] No sentiment documents found")
                        self?.errorMessage = "데이터가 없습니다."
                        return
                    }
                    
                    self?.records = documents.compactMap { document -> SentimentRecord? in
                        let data = document.data()
                        print("[Firestore] Sentiment document: \(data)")
                        guard let date = document.documentID as String?,
                              let counts = data["counts"] as? [String: Any],
                              let positive = counts["positive"] as? Int,
                              let negative = counts["negative"] as? Int,
                              let neutral = counts["nutural"] as? Int else {
                            print("[Firestore] Document missing required fields: \(data)")
                            return nil
                        }
                        return SentimentRecord(date: date, category: self?.selectedSector ?? "", positive: positive, negative: negative, neutral: neutral)
                    }.sorted { $0.date < $1.date }
                    print("[Firestore] Sentiment records count: \(self?.records.count ?? 0)")
                }
            }
    }
} 
