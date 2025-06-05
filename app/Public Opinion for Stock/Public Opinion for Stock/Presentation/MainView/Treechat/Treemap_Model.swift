import SwiftUI

struct TreemapBlock: Identifiable {
    let id = UUID()
    let value: Double
    let rect: CGRect
    let label: String
    let percent: String
    let sentiment: SentimentType
    let color: Color
}

enum SentimentType {
    case positive, negative, neutral
    
    struct ColorTheme {
        let background: Color
        let text: Color
    }
    
    var colors: ColorTheme {
        switch self {
        case .positive:
            return ColorTheme(
                background: Color(hex: "#FFC1BF"),
                text: Color(hex: "#FF0000")
            )
        case .negative:
            return ColorTheme(
                background: Color(hex: "#BFCAFF"),
                text: Color(hex: "#1900FF")
            )
        case .neutral:
            return ColorTheme(
                background: Color(hex: "#FFC1BF"),
                text: Color(hex: "#555555")
            )
        }
    }
    
    var backgroundColor: Color { colors.background }
    var percentColor: Color { colors.text }
}


struct StockData {
    let positive: Double
    let negative: Double
    let label: String
    
    var totalValue: Double {  // 추가
        return positive + negative
    }
    
    var percentageValue: Double {
        if totalValue == 0 { return 0 }
        return (positive > negative ? positive : negative) / totalValue * 100
    }
    
    var percentString: String {
        if totalValue == 0 { return "0%" }
        let isPositive = positive > negative
        return String(format: "%@%.1f%%", isPositive ? "+" : "-", percentageValue)
    }
    
    var sentiment: SentimentType {
        if positive == negative { return .neutral }
        return positive > negative ? .positive : .negative
    }
    
    
    static let sampleData: [StockData] = [
        StockData(positive: 99, negative: 5, label: "반도체"),
        StockData(positive: 30, negative: 0, label: "2차 전지"),
        StockData(positive: 50, negative: 50, label: "배터리"),
        StockData(positive: 30, negative: 70, label: "IT"),
        StockData(positive: 80, negative: 100, label: "의료"),
        StockData(positive: 2, negative: 100, label: "아이퍼"),
//        StockData(positive: 20, negative: 80, label: "카린"),
//        StockData(positive: 20, negative: 20, label: "이사"),
//        StockData(positive: 60, negative: 20, label: "중간"),
//        StockData(positive: 90, negative: 20, label: "ㅎㅎ")
    ]
}


