import Foundation
import FirebaseFirestore


class FirestoreService {
    // Firestore 데이터 베이스에 연결하는 인스턴스 생성
    private let db = Firestore.firestore()

    // "sector_score" -> "datas" doc 가져오기
    func fetchSectorScoreData(completion: @escaping ([SectorRawScore]?) -> Void) {
        db.collection("sector_score").document("datas").getDocument { document, error in
            guard let document = document,
                  let data = document.data() else {
                completion(nil)
                return
            }
            
            let sectorScores = SectorRawScore.parse(from: data)
            completion(sectorScores)
        }
    }

    // "sector_detail" -> {sectorName} -> "dates" -> {date} doc 가져오기
    func fetchSectorDetailDateData(sectorName: String, date: String, completion: @escaping (SectorDetailDate?) -> Void) {

        db.collection("sector_detail")
          .document(sectorName)
          .collection("dates")
          .document(date)
          .getDocument { document, error in
              guard let document = document,
                    let data = document.data() else {
                  completion(nil)
                  return
              }
              
              let sectorDetail = SectorDetailDate.parse(from: data)
              completion(sectorDetail)
          }
    }

    // "sector_detail" -> {sectorName} -> "detail_dates" -> {date} doc 가져오기
    func fetchSectorDetailDetailDateData(sectorName: String, date: String, completion: @escaping (SectorDetailDetailDate?) -> Void) {
        db.collection("sector_detail")
          .document(sectorName)
          .collection("detail_dates")
          .document(date)
          .getDocument { document, error in
              guard let document = document,
                    let data = document.data() else {
                  completion(nil)
                  return
              }
              
              let detailDate = SectorDetailDetailDate.parse(from: data)
              completion(detailDate)
          }
    }

    
    
    // 모든 섹터 이름 가져오기
    func fetchAllSectors(completion: @escaping ([String]) -> Void) {
        db.collection("sector_detail").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting sectors: \(error)")
                completion([])
                return
            }
            let sectors = snapshot?.documents.map { $0.documentID } ?? []
            completion(sectors)
        }
    }
    
    // 특정 섹터에서 날짜 목록 가져오기
    func fetchDates(for sector: String, completion: @escaping ([String]) -> Void) {
        db.collection("sector_detail")
            .document(sector)
            .collection("dates")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion([])
                    return
                }
                let dates = snapshot?.documents.map { $0.documentID } ?? []
                completion(dates)
            }
    }
    
    
    // 섹터 - 날짜 조합에서 데이터 가져오기
    func fetchDateInfo(for sector: String, date: String, completion: @escaping (DateInfo?) -> Void) {
        db.collection("sector_detail")
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
                   let neutral = countsData["neutral"] as? Int {
                    
                    let counts = Counts(positive: positive, negative: negative, neutral: neutral)
                    
                    // summary 데이터 파싱
                    if let summaryData = data["summary"] as? [String: [String: String]] {
                        
                        // 각 감정별 상세 정보 파싱
                        if let positiveData = summaryData["positive"],
                           let neutralData = summaryData["neutral"],
                           let negativeData = summaryData["negative"] {
                            
                            let summary = Summary(
                                positive: SentimentDetail(
                                    headline: positiveData["headline"] ?? "",
                                    summary: positiveData["summary"] ?? ""
                                ),
                                neutral: SentimentDetail(
                                    headline: neutralData["headline"] ?? "",
                                    summary: neutralData["summary"] ?? ""
                                ),
                                negative: SentimentDetail(
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
