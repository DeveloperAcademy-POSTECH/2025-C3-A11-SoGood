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
}
