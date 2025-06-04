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
            
            for value in values.prefix(4) { // 최대 4개까지만 검사
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
                
                if row.count >= 4 { // 최대 4개 제한
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
//
//
//
//class TreemapViewModel: ObservableObject {
//    @Published var blocks: [TreemapBlock] = []
//    private let size: CGSize
//    
//    init(size: CGSize) {
//        self.size = size
//        generateBlocks()
//    }
//    
//    private func sortData(_ data: [StockData]) -> [StockData] {
//        return data.sorted { first, second in
//            if first.sentiment != second.sentiment {
//                switch (first.sentiment, second.sentiment) {
//                case (.positive, _): return true
//                case (.neutral, .negative): return true
//                case (.negative, .positive): return false
//                case (.neutral, .positive): return false
//                case (.negative, .neutral): return false
//                default: return false
//                }
//            }
//            return true
//        }
//    }
//    
//    private func calculateAbsoluteWidths(data: [StockData], totalWidth: CGFloat) -> [(StockData, CGFloat)] {
//        let maxPercentage = 100.0  // 최대값을 100%로 고정
//        
//        return data.map { stockData in
//            let relativeSize = abs(stockData.percentageValue) / maxPercentage
//            let width = totalWidth * CGFloat(relativeSize)
//            return (stockData, width)
//        }
//    }
//    
//    private func calculateTreemapLayout(data: [StockData], frame: CGRect) -> [CGRect] {
//        let sortedData = sortData(data)
//        let blocksWithWidth = calculateAbsoluteWidths(data: sortedData, totalWidth: frame.width)
//        var remainingBlocks = blocksWithWidth
//        var remainingRect = frame
//        var rects: [CGRect] = Array(repeating: .zero, count: sortedData.count)
//        var currentRow: [(StockData, CGFloat)] = []
//        var currentRowWidth: CGFloat = 0
//        var currentIndex = 0
//        
//        for block in remainingBlocks {
//            if currentRow.count >= 4 || currentRowWidth + block.1 + (currentRow.isEmpty ? 0 : 3) > frame.width {
//                // 현재 행 레이아웃 처리
//                let rowRects = layoutRow(values: currentRow, frame: remainingRect)
//                for (i, rect) in rowRects.enumerated() {
//                    rects[currentIndex + i] = rect
//                }
//                
//                currentIndex += currentRow.count
//                remainingRect.origin.y += 83 // 80 height + 3 spacing
//                currentRow = []
//                currentRowWidth = 0
//            }
//            
//            currentRow.append(block)
//            currentRowWidth += block.1 + (currentRow.count > 1 ? 3 : 0)
//        }
//        
//        // 마지막 행 처리
//        if !currentRow.isEmpty {
//            let rowRects = layoutRow(values: currentRow, frame: remainingRect)
//            for (i, rect) in rowRects.enumerated() {
//                rects[currentIndex + i] = rect
//            }
//        }
//        
//        return rects
//    }
//    
//    private func layoutRow(values: [(StockData, CGFloat)], frame: CGRect) -> [CGRect] {
//        let height: CGFloat = 80
//        let spacing: CGFloat = 3
//        var rects: [CGRect] = []
//        
//        let maxWidth = values.map { $0.1 }.max() ?? frame.width
//        let scale = (frame.width - (CGFloat(values.count - 1) * spacing)) / maxWidth
//        
//        var xOffset = frame.minX
//        for (_, width) in values {
//            let scaledWidth = width * scale
//            let rect = CGRect(x: xOffset,
//                            y: frame.minY,
//                            width: min(scaledWidth, frame.width - xOffset),
//                            height: height)
//            rects.append(rect)
//            xOffset += scaledWidth + spacing
//        }
//        
//        return rects
//    }
//    
//    private func generateBlocks() {
//        let data = StockData.sampleData
//        let sortedData = sortData(data)
//        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//        let rects = calculateTreemapLayout(data: sortedData, frame: frame)
//        
//        self.blocks = zip(sortedData, rects).map { item, rect in
//            TreemapBlock(
//                value: abs(item.percentageValue),
//                rect: rect,
//                label: item.label,
//                percent: item.percentString,
//                sentiment: item.sentiment,
//                color: item.sentiment.backgroundColor
//            )
//        }
//    }
//}
