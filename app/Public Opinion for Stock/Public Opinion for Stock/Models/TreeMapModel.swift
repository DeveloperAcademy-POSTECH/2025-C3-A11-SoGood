import SwiftUI

struct TreeMapBlock: Identifiable {
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
                text: Color(red: 1, green: 0, blue: 0)
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
    
    var totalValue: Double {
        return positive + negative
    }
    
    var percentageValue: Double {
        if totalValue == 0 { return 0 }
        return (positive > negative ? positive : negative) / totalValue * 100
    }
    
    var percentString: String {
        if totalValue == 0 { return "0%" }
        let isPositive = positive > negative
        return String(format: "%@%.f%", isPositive ? "+" : "-", percentageValue)
    }
    
    var sentiment: SentimentType {
        if positive == negative { return .neutral }
        return positive > negative ? .positive : .negative
    }
    
    static func getDataFromFavorites(_ favoriteViewModel: FavoriteViewModel) -> [StockData] {
        let favorites = favoriteViewModel.favoriteCategories
        guard !favorites.isEmpty else { return [] }
        
        return favorites.map { category in
            // 임시로 랜덤 데이터 생성 (제이콥 데이터랑 연결해야함.)
            let positive = Double.random(in: 0...100)
            let negative = Double.random(in: 0...100)
            return StockData(positive: positive, negative: negative, label: category.id)
        }
    }
}


