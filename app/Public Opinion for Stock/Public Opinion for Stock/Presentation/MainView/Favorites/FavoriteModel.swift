import Foundation

struct CategoryItem: Identifiable, Codable {
    let id: String
    var isFavorite: Bool
    
    var name: String { id }  // id와 name이 동일
}

struct FavoriteState: Codable {
    var categories: [String: Bool]
}