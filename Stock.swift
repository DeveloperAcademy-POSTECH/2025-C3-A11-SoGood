import Foundation
import FirebaseFirestoreSwift

struct Stock: Identifiable, Codable {
    @DocumentID var id: String?
    let sectorName: String
    let positiveCount: Int
    let negativeCount: Int
    var isFavorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case sectorName = "sector_name"
        case positiveCount = "positive_count"
        case negativeCount = "negative_count"
        case isFavorite = "is_favorite"
    }
} 