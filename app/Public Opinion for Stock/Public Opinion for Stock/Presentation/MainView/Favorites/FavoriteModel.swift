import Foundation
import FirebaseFirestore

struct FavoriteItem: Identifiable {
    let id: String
    let name: String
    var isFavorite: Bool
    var score: Int
    
    init(id: String = UUID().uuidString, name: String, isFavorite: Bool = false, score: Int = 0) {
        self.id = id
        self.name = name
        self.isFavorite = isFavorite
        self.score = score
    }
}

struct FavoriteSection {
    let title: String
    var items: [FavoriteItem]
}
