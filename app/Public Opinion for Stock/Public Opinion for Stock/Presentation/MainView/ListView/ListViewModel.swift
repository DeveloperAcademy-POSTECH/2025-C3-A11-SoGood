//
//  SectorScoreViewModel.swift
//  Public Opinion for Stock
//
//  Created by Jacob on 6/5/25.
//

import Foundation
import FirebaseFirestore

final class ListViewModel: ObservableObject {
    @Published var items: [RowItem] = []
    
    //어제 날짜 생성
    var yesterday: Date {
            Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        }
    
    //종목 점수 계산
    func fetchSectorScores() {
        let db = Firestore.firestore()
        db.collection("sector_score").document("datas").getDocument { (document, error) in
            var tempItems: [RowItem] = []
            if let document = document, document.exists {
                let data = document.data() ?? [:]
                for (sector, value) in data {
                    if let score = value as? [String: Any] {
                        let positive = score["positive"] as? Int ?? 0
                        let negative = score["negative"] as? Int ?? 0
                        let neutral = score["neutral"] as? Int ?? 0
                        let total = positive + negative + neutral
                        var emotionScore = 0
                        if total > 0 {
                            if positive >= negative {
                                emotionScore = Int(Double(positive) / Double(total) * 100)
                            } else {
                                emotionScore = Int(Double(negative) / Double(total) * 100) * -1
                            }
                        }
                        tempItems.append(RowItem(name: sector, value: emotionScore))
                    }
                }
            }
            DispatchQueue.main.async {
                self.items = tempItems
            }
        }
    }
}
