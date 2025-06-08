import SwiftUI

class SentimentViewModel: ObservableObject {
    @Published var records: [SentimentRecord] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let firestoreService = FirestoreService()
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
        
        firestoreService.fetchSectorAllDatesData(sectorName: selectedSector) { [weak self] records in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let records = records {
                    self?.records = records
                } else {
                    self?.errorMessage = "데이터가 없습니다."
                }
            }
        }
    }
} 
