import SwiftUI
//
class TreemapViewModel: ObservableObject {
    @Published var blocks: [TreemapBlock] = []
    private let size: CGSize
    
    init(size: CGSize) {  // 기본값 제거
        self.size = size
        generateBlocks()
    }
    
    private func sortData(_ data: [StockData]) -> [StockData] {
        return data.sorted { first, second in
            // 1. sentiment로 먼저 정렬 (positive > neutral > negative)
            if first.sentiment != second.sentiment {
                switch (first.sentiment, second.sentiment) {
                case (.positive, _): return true
                case (.neutral, .negative): return true
                case (.negative, .positive): return false
                case (.neutral, .positive): return false
                case (.negative, .neutral): return false
                default: return false
                }
            }
            
            // 2. 같은 sentiment 내에서의 정렬
            switch first.sentiment {
            case .positive:
                return abs(first.percentageValue) > abs(second.percentageValue)
            case .negative:
                return abs(first.percentageValue) < abs(second.percentageValue)
            case .neutral:
                return true
            }
        }
    }
    
    private func calculateTreemapLayout(data: [StockData], frame: CGRect) -> [CGRect] {
        let sortedData = sortData(data)
        let totalValue = sortedData.reduce(0.0) { $0 + abs($1.percentageValue) }
        var remainingRect = frame
        var remainingValues = sortedData
        var rects: [CGRect] = Array(repeating: .zero, count: sortedData.count)
        
        while !remainingValues.isEmpty {
            let row = selectRow(values: remainingValues, totalPercentage: totalValue, frameWidth: remainingRect.width)
            let rowRects = layoutRow(values: row, frame: remainingRect)
            
            let offset = sortedData.count - remainingValues.count
            for (i, rect) in rowRects.enumerated() {
                rects[offset + i] = rect
            }
            
            remainingValues.removeFirst(row.count)
            remainingRect.origin.y += rowRects[0].height + 3
            remainingRect.size.height -= rowRects[0].height + 3
        }
        
        return rects
    }
    
    private func selectRow(values: [StockData], totalPercentage: Double, frameWidth: CGFloat) -> [StockData] {
            var row: [StockData] = []
            var rowPercentage = 0.0
            var bestAspectRatio = CGFloat.infinity
            
            for value in values.prefix(10) { // 최대 6개까지만 검사
                row.append(value)
                rowPercentage += abs(value.percentageValue)
                
                let rowWidth = frameWidth
                let rowHeight: CGFloat = 80
                var worstRatio: CGFloat = 0
                
                for rowItem in row {
                    let itemWidth = rowWidth * CGFloat(abs(rowItem.percentageValue) / rowPercentage)
                    let ratio = max(itemWidth / rowHeight, rowHeight / itemWidth)
                    worstRatio = max(worstRatio, ratio)
                }
                
                if worstRatio > bestAspectRatio {
                    row.removeLast()
                    break
                }
                bestAspectRatio = worstRatio
                
                if row.count >= 3 { // 최대 3개 제한
                    break
                }
            }
            
            return row.isEmpty ? [values[0]] : row
        }
    
    
    private func layoutRow(values: [StockData], frame: CGRect) -> [CGRect] {
        let rowValue = values.reduce(0.0) { $0 + abs($1.percentageValue) }
        let height: CGFloat = 80
        let spacing: CGFloat = 3
        var rects: [CGRect] = []
        
        let totalSpacing = CGFloat(values.count - 1) * spacing
        let availableWidth = frame.width - totalSpacing
        
        var xOffset = frame.minX
        for value in values {
            // 각 블록의 너비를 percentageValue 비율에 따라 계산
            let width = availableWidth * CGFloat(abs(value.percentageValue) / rowValue)
            
            let rect = CGRect(x: xOffset,
                             y: frame.minY,
                             width: width,
                             height: height)
            rects.append(rect)
            xOffset += width + spacing
        }
        
        return rects
    }
    
    
    private func generateBlocks() {
        let data = StockData.sampleData
        let sortedData = sortData(data)
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let rects = calculateTreemapLayout(data: sortedData, frame: frame)
        
        self.blocks = zip(sortedData, rects).map { item, rect in
            TreemapBlock(
                value: item.totalValue,
                rect: rect,
                label: item.label,
                percent: item.percentString,
                sentiment: item.sentiment,
                color: item.sentiment.backgroundColor
            )
        }
    }
}
