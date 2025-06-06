import Foundation
import FirebaseFirestore
import Combine

class FavoriteViewModel: ObservableObject {
    @Published var investmentCategories: [FavoriteItem] = []
    @Published var favoriteCategories: [FavoriteItem] = []
    @Published var selectedCount: Int = 0
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchCategories()
    }
    
    private func fetchCategories() {
        isLoading = true
        errorMessage = nil
        
        // 투자분야 카테고리 가져오기
        db.collection("try_sector_detail_page").getDocuments { [weak self] snapshot, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "데이터를 가져오는데 실패했습니다: \(error.localizedDescription)"
                    self?.isLoading = false
                }
                return
            }
            
            let categories = snapshot?.documents.compactMap { document -> FavoriteItem? in
                return FavoriteItem(
                    id: document.documentID,
                    name: document.documentID,
                    isFavorite: false
                )
            } ?? []
            
            // 즐겨찾기 상태 가져오기
            self?.db.collection("favorites").document("user_favorites").getDocument { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let error = error {
                        self?.errorMessage = "즐겨찾기 데이터를 가져오는데 실패했습니다: \(error.localizedDescription)"
                        return
                    }
                    
                    let favoriteIds = (snapshot?.data()?["items"] as? [String]) ?? []
                    
                    // 즐겨찾기 상태 업데이트
                    self?.investmentCategories = categories.map { item in
                        var updatedItem = item
                        updatedItem.isFavorite = favoriteIds.contains(item.id)
                        return updatedItem
                    }
                    
                    // 즐겨찾기 목록 업데이트
                    self?.favoriteCategories = categories.filter { favoriteIds.contains($0.id) }
                    self?.updateSelectedCount()
                }
            }
        }
    }
    
    func toggleFavorite(for item: FavoriteItem) {
        if let index = favoriteCategories.firstIndex(where: { $0.id == item.id }) {
            // 이미 즐겨찾기에 있으면 제거
            favoriteCategories.remove(at: index)
            if let investmentIndex = investmentCategories.firstIndex(where: { $0.id == item.id }) {
                investmentCategories[investmentIndex].isFavorite = false
            }
        } else {
            // 즐겨찾기에 없고 10개 미만일 때만 추가
            if favoriteCategories.count < 10 {
                var newItem = item
                newItem.isFavorite = true
                favoriteCategories.append(newItem)
                if let investmentIndex = investmentCategories.firstIndex(where: { $0.id == item.id }) {
                    investmentCategories[investmentIndex].isFavorite = true
                }
            }
        }
        updateSelectedCount()
    }
    
    private func updateSelectedCount() {
        selectedCount = favoriteCategories.count
    }
    
    func saveChanges() {
        let favoriteIds = favoriteCategories.map { $0.id }
        db.collection("favorites").document("user_favorites").setData([
            "items": favoriteIds
        ]) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "즐겨찾기 저장에 실패했습니다: \(error.localizedDescription)"
                }
            }
        }
    }
}
