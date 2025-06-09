import SwiftUI

enum Sentiment: String, CaseIterable {
    case positive = "긍정적 의견"
    case negative = "부정적 의견"
    case neutral = "중립적 의견"
    
    var color: Color {
        switch self {
        case .positive: return .red
        case .negative: return .blue
        case .neutral: return .gray
        }
    }
}


struct Feedback: Identifiable {
    let id: String
    let text: String
    let source: String
    let time: String
    let sentiment: Sentiment
}