import Foundation
import FirebaseFirestore

struct Sector: Identifiable {
    var id: String
    let name: String
    let positiveCount: Int
    let negativeCount: Int
    var isFavorite: Bool
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.name = data["name"] as? String ?? ""
        self.positiveCount = data["positive_count"] as? Int ?? 0
        self.negativeCount = data["negative_count"] as? Int ?? 0
        self.isFavorite = data["is_favorite"] as? Bool ?? false
    }
} 