import Foundation

class StockModel: ObservableObject {
    @Published var allStocks = [
        "게임", "조선", "방산", "반도체", "이차전지", "디스플레이", 
        "화장품", "자동차", "건설", "철강", "화학", "엔터", 
        "음식료", "패션", "풍력", "원전", "바이오", "임플란트", 
        "피부미용", "유통", "은행", "보험", "수소", "IT", 
        "전선", "여행"
    ]
    
    @Published var favorites: [String] = []
    
    func toggleFavorite(_ stock: String) {
        if favorites.contains(stock) {
            favorites.removeAll { $0 == stock }
        } else {
            favorites.append(stock)
        }
    }
    
    func isFavorite(_ stock: String) -> Bool {
        return favorites.contains(stock)
    }
} 