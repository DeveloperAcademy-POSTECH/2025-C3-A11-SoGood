////
////  FavoritesView.swift
////  Public Opinion for Stock
////
////  Created by Karyn Hakyung Kim on 6/5/25.
////
//
//import SwiftUI
//import FirebaseFirestore
//
//
//class FavoriteViewModel: ObservableObject {
//    @Published var sectors: [String] = []
//    @Published var records: [SentimentRecord] = []
//    @Published var selectedSector: String {
//        didSet {
//            print("[DEBUG] selectedSector changed to: \(selectedSector)")
//            fetchSentimentData()
//        }
//    }
//    
//    private let db = Firestore.firestore()
//    
//    init(category: String) {
//        self.selectedSector = category
//        fetchSentimentData()
//    }
//    
//    
//    func fetchSentimentData() {
//        print("[Firestore] fetchSentimentData() called for sector: \(selectedSector)")
//        
//        db.collection("try_sector_detail_page")
//            .document(selectedSector)
//            .collection("dates")
//            .getDocuments { [weak self] snapshot, error in
//                DispatchQueue.main.async {
//                    
//                    self?.records = documents.compactMap { document -> SentimentRecord? in
//                        let data = document.data()
//                        print("[Firestore] Sentiment document: \(data)")
//                        guard let date = document.documentID as String?,
//                              let counts = data["counts"] as? [String: Any],
//                              let positive = counts["positive"] as? Int,
//                              let negative = counts["negative"] as? Int,
//                              let neutral = counts["nutural"] as? Int else {
//                            print("[Firestore] Document missing required fields: \(data)")
//                            return nil
//                        }
//                        return SentimentRecord(date: date, category: self?.selectedSector ?? "", positive: positive, negative: negative, neutral: neutral)
//                    }.sorted { $0.date < $1.date }
//                    print("[Firestore] Sentiment records count: \(self?.records.count ?? 0)")
//                }
//            }
//    }
//}
