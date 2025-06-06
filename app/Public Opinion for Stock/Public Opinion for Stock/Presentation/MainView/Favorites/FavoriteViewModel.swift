import Foundation
import Combine

class FavoriteViewModel: ObservableObject {
    @Published var investmentCategories: [CategoryItem] = []
    @Published var favoriteCategories: [CategoryItem] = []
    @Published var selectedCount: Int = 0
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let jsonFileName = "investment_categories"
    private let userDefaultsKey = "favoriteCategories"
    
    init() {
        loadCategories()
    }
    
    // MARK: - Data Loading
    private func loadCategories() {
        isLoading = true
        errorMessage = nil
        
        // 1. JSON 파일에서 카테고리 로드
        if let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let categories = try JSONSerialization.jsonObject(with: data) as? [String: Bool] ?? [:]
                
                // 2. UserDefaults에서 저장된 즐겨찾기 상태 로드
                let savedFavorites = UserDefaults.standard.dictionary(forKey: userDefaultsKey) as? [String: Bool] ?? [:]
                
                // 3. CategoryItem 배열 생성
                self.investmentCategories = categories.map { (id, _) in
                    CategoryItem(id: id, isFavorite: savedFavorites[id] ?? false)
                }.sorted { $0.id < $1.id }  // 알파벳 순 정렬
                
                // 4. 즐겨찾기 목록 업데이트
                updateFavoritesList()
                
            } catch {
                self.errorMessage = "카테고리 데이터를 불러오는데 실패했습니다: \(error.localizedDescription)"
            }
        } else {
            self.errorMessage = "카테고리 파일을 찾을 수 없습니다."
        }
        
        isLoading = false
    }
    
    // MARK: - Favorites Management
    private func updateFavoritesList() {
        favoriteCategories = investmentCategories.filter { $0.isFavorite }
        selectedCount = favoriteCategories.count
    }
    
    func toggleFavorite(for item: CategoryItem) {
        guard let index = investmentCategories.firstIndex(where: { $0.id == item.id }) else { return }
        
        if item.isFavorite {
            // 즐겨찾기 해제
            investmentCategories[index].isFavorite = false
        } else {
            // 즐겨찾기 추가 (10개 제한)
            if selectedCount < 10 {
                investmentCategories[index].isFavorite = true
            } else {
                errorMessage = "즐겨찾기는 최대 10개까지만 가능합니다."
                return
            }
        }
        
        updateFavoritesList()
        saveChanges()
    }
    
    // MARK: - Data Saving
    func saveChanges() {
        // 현재 즐겨찾기 상태를 Dictionary로 변환
        let favorites = Dictionary(
            uniqueKeysWithValues: investmentCategories.map { ($0.id, $0.isFavorite) }
        )
        
        // UserDefaults에 저장
        UserDefaults.standard.set(favorites, forKey: userDefaultsKey)
    }
    
    // MARK: - Reset
    func resetFavorites() {
        // 모든 즐겨찾기 해제
        investmentCategories = investmentCategories.map { item in
            CategoryItem(id: item.id, isFavorite: false)
        }
        updateFavoritesList()
        saveChanges()
    }
}
