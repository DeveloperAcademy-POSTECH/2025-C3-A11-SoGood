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

    // 특정 섹터의 모든 날짜 데이터를 가져오는 메서드 추가
    func fetchSectorAllDatesData(sectorName: String, completion: @escaping ([SentimentRecord]?) -> Void) {
        db.collection("sector_detail")
          .document(sectorName)
          .collection("dates")
          .getDocuments { snapshot, error in
              guard let documents = snapshot?.documents else {
                  completion(nil)
                  return
              }
              
              let records = documents.compactMap { document -> SentimentRecord? in
                  let data = document.data()
                  guard let date = document.documentID as String?,
                        let counts = data["counts"] as? [String: Any],
                        let positive = counts["positive"] as? Int,
                        let negative = counts["negative"] as? Int,
                        let neutral = counts["neutral"] as? Int else {
                      return nil
                  }
                  return SentimentRecord(
                      date: date,
                      category: sectorName,
                      positive: positive,
                      negative: negative,
                      neutral: neutral
                  )
              }.sorted { $0.date < $1.date }
              
              completion(records)
          }
    }
}
