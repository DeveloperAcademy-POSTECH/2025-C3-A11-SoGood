import Foundation

struct MainRowItem: Identifiable {
    var id: String { sector }  // sector를 id로 사용
    let sector: String
    let score: Int
}