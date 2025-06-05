import SwiftUI
import FirebaseFirestore

class SectorViewModel: ObservableObject {
    @Published var sectors: [Sector] = []
    @Published var favorites: [Sector] = []
    
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    init() {
        fetchSectors()
    }
    
    deinit {
        // 리스너 해제
        listenerRegistration?.remove()
    }
    
    func fetchSectors() {
        // 실시간 리스너 설정
        listenerRegistration = db.collection("sectors").addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self?.sectors = documents.map { document in
                Sector(id: document.documentID, data: document.data())
            }
            
            self?.updateFavorites()
        }
    }
    
    private func updateFavorites() {
        favorites = sectors.filter { $0.isFavorite }
    }
    
    func toggleFavorite(_ sector: Sector) {
        // Firestore에 즐겨찾기 상태 업데이트
        let sectorRef = db.collection("sectors").document(sector.id)
        
        sectorRef.updateData([
            "is_favorite": !sector.isFavorite
        ]) { error in
            if let error = error {
                print("Error updating favorite status: \(error)")
            }
        }
        
        // 로컬 상태 업데이트
        if let index = sectors.firstIndex(where: { $0.id == sector.id }) {
            sectors[index].isFavorite.toggle()
            updateFavorites()
        }
    }
    
    // Firestore에 새로운 섹터 추가 (테스트용)
    func addInitialSectorsIfNeeded() {
        let sectors = [
            "게임", "조선", "방산", "반도체", "이차전지", "디스플레이", 
            "화장품", "자동차", "건설", "철강", "화학", "엔터", 
            "음식료", "패션", "풍력", "원전", "바이오", "임플란트", 
            "피부미용", "유통", "은행", "보험", "수소", "IT", 
            "전선", "여행"
        ]
        
        for sector in sectors {
            db.collection("sectors").addDocument(data: [
                "name": sector,
                "positive_count": Int.random(in: 0...100),
                "negative_count": Int.random(in: 0...100),
                "is_favorite": false
            ])
        }
    }
} 