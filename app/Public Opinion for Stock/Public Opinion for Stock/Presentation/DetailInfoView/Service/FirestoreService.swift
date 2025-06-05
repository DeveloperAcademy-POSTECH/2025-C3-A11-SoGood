import Foundation
import FirebaseFirestore


class FirestoreService {
    private let db = Firestore.firestore()
    // Firestore 데이터 베이스에 연결하는 인스턴스 생성
    
    
    // 모든 섹터 이름 가져오기
    func fetchAllSectors(completion: @escaping ([String]) -> Void) {
        db.collection("try_sector_detail_page").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting sectors: \(error)")
                completion([])
                return
            }
            let sectors = snapshot?.documents.map { $0.documentID } ?? []
            print("받아온 섹터 리스트: \(sectors)")
            completion(sectors)
        }
    }
    
    // 특정 섹터에서 날짜 목록 가져오기
    func fetchDates(for sector: String, completion: @escaping ([String]) -> Void) {
        db.collection("try_sector_detail_page")
            .document(sector)
            .collection("dates")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error getting dates for \(sector): \(error)")
                    completion([])
                    return
                }
                let dates = snapshot?.documents.map { $0.documentID } ?? []
                print("\(sector) 섹터의 날짜 리스트: \(dates)")
                completion(dates)
            }
    }
    
    
    // 섹터 - 날짜 조합에서 데이터 가져오기
    func fetchDateInfo(for sector: String, date: String, completion: @escaping (DateInfo?) -> Void) {
        db.collection("try_sector_detail_page")
            .document(sector)
            .collection("dates")
            .document(date)
            .getDocument { document, error in
                guard let document = document,
                      document.exists,
                      let data = document.data() else {
                    completion(nil)
                    return
                }
                
                
                // counts 데이터 파싱
                if let countsData = data["counts"] as? [String: Any],
                   let positive = countsData["positive"] as? Int,
                   let negative = countsData["negative"] as? Int,
                   let nutural = countsData["nutural"] as? Int {
                    print("\(sector) - \(date): counts: \(countsData))")
                    
                    let counts = Counts(positive: positive, negative: negative, nutural: nutural)
                    
                    // summary 데이터 파싱
                    if let summaryData = data["summary"] as? [String: [String: String]] {
                        
                        // 각 감정별 상세 정보 파싱
                        if let positiveData = summaryData["긍정"],
                           let neutralData = summaryData["중립"],
                           let negativeData = summaryData["부정"] {
                            
                            let summary = Summary(
                                긍정: SentimentDetail(
                                    headline: positiveData["headline"] ?? "",
                                    summary: positiveData["summary"] ?? ""
                                ),
                                중립: SentimentDetail(
                                    headline: neutralData["headline"] ?? "",
                                    summary: neutralData["summary"] ?? ""
                                ),
                                부정: SentimentDetail(
                                    headline: negativeData["headline"] ?? "",
                                    summary: negativeData["summary"] ?? ""
                                )
                            )
                            
                            let dateInfo = DateInfo(
                                id: date,
                                counts: counts,
                                summary: summary
                            )
                            
                            completion(dateInfo)
                            return
                        }
                    }
                }
                
                completion(nil)
            }
    }
    
}
