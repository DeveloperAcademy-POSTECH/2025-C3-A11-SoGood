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
        let sectorData: [String: [String: Int]] = [
                "게임": ["negative": 3, "neutral": 13, "positive": 4],
                "조선": ["negative": 1, "neutral": 13, "positive": 16],
                "방산": ["negative": 1, "neutral": 13, "positive": 16],
                "반도체": ["negative": 2, "neutral": 26, "positive": 16],
                "이차전지": ["negative": 3, "neutral": 9, "positive": 16],
                "디스플레이": ["negative": 0, "neutral": 4, "positive": 3],
                "화장품": ["negative": 1, "neutral": 9, "positive": 24],
                "자동차": ["negative": 0, "neutral": 28, "positive": 14],
                "건설": ["negative": 4, "neutral": 13, "positive": 16],
                "철강": ["negative": 2, "neutral": 27, "positive": 1],
                "화학": ["negative": 0, "neutral": 18, "positive": 12],
                "엔터": ["negative": 2, "neutral": 16, "positive": 6],
                "음식료": ["negative": 1, "neutral": 19, "positive": 7],
                "패션": ["negative": 0, "neutral": 14, "positive": 2],
                "풍력": ["negative": 0, "neutral": 10, "positive": 18],
                "원전": ["negative": 1, "neutral": 4, "positive": 26],
                "바이오": ["negative": 3, "neutral": 21, "positive": 15],
                "임플란트": ["negative": 0, "neutral": 1, "positive": 0],
                "피부미용": ["negative": 0, "neutral": 12, "positive": 8],
                "유통": ["negative": 1, "neutral": 39, "positive": 4],
                "은행": ["negative": 1, "neutral": 29, "positive": 11],
                "보험": ["negative": 1, "neutral": 12, "positive": 5],
                "수소": ["negative": 0, "neutral": 1, "positive": 6],
                "IT": ["negative": 0, "neutral": 25, "positive": 27],
                "전선": ["negative": 0, "neutral": 20, "positive": 12],
                "여행": ["negative": 0, "neutral": 18, "positive": 9]
            ]
    
        
        return favorites.map { category in
            let positive = Double(sectorData[category.id]!["positive"]!)
            let negative = Double(sectorData[category.id]!["negative"]!)
            return StockData(positive: positive, negative: negative, label: category.id)
        }
    }
}


