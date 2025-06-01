import Foundation

public struct SentimentRecord: Codable, Identifiable {
    public var id: String { date }
    let date: String // yyyy-MM-dd
    let category: String
    let positive: Int
    let negative: Int
    let neutral: Int
} 
