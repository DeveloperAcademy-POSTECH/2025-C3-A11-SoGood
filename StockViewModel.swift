import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class StockViewModel: ObservableObject {
    @Published var stocks: [Stock] = []
    @Published var favorites: [Stock] = []
    
    private let db = Firestore.firestore()
    private let userId: String // 실제 구현시 Firebase Auth의 사용자 ID를 사용
    
    init(userId: String) {
        self.userId = userId
        fetchStocks()
    }
    
    func fetchStocks() {
        db.collection("sectors")
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self?.stocks = documents.compactMap { document -> Stock? in
                    try? document.data(as: Stock.self)
                }
                
                self?.updateFavorites()
            }
    }
    
    private func updateFavorites() {
        favorites = stocks.filter { $0.isFavorite }
    }
    
    func toggleFavorite(_ stock: Stock) {
        guard let id = stock.id else { return }
        
        // 사용자의 즐겨찾기 컬렉션 업데이트
        let userFavRef = db.collection("users").document(userId)
            .collection("favorites").document(id)
        
        if stock.isFavorite {
            // 즐겨찾기 제거
            userFavRef.delete()
        } else {
            // 즐겨찾기 추가
            userFavRef.setData([:])
        }
        
        // 로컬 상태 업데이트
        if let index = stocks.firstIndex(where: { $0.id == id }) {
            stocks[index].isFavorite.toggle()
            updateFavorites()
        }
    }
    
    func loadUserFavorites() {
        db.collection("users").document(userId)
            .collection("favorites")
            .getDocuments { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching favorites: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                let favoriteIds = Set(documents.map { $0.documentID })
                
                // 기존 stocks 배열 업데이트
                self?.stocks = self?.stocks.map { stock in
                    var updatedStock = stock
                    updatedStock.isFavorite = favoriteIds.contains(stock.id ?? "")
                    return updatedStock
                } ?? []
                
                self?.updateFavorites()
            }
    }
} 