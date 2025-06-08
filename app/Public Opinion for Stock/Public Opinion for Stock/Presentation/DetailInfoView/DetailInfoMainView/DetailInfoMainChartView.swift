import SwiftUI
import Charts

struct DetailInfoMainChartView: View {  // public 제거
    @Binding var selectedSector: String
    @Binding var sectorPercent: [String: Double]?
    let date: String

    init(sectorPercent: Binding<[String: Double]?>, selectedSector: Binding<String>, date: String) {
        self._sectorPercent = sectorPercent
        self._selectedSector = selectedSector
        self.date = date
    }
    
    private var sentimentOrder = ["positive", "neutral", "negative"]
    private var sentimentColors: [String: Color] = [
        "positive": .redPrimary,
        "neutral": .grayNeutural,
        "negative": .bluePrimary
    ]
    
    var body: some View {  // public 제거
        VStack {
            HStack {
                Text(String(format: "%.1f%%", sectorPercent?["positive"] ?? 0))
                    .font(.headline2)
                    .foregroundColor(.redPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                    .frame(maxWidth: .infinity)
                
                Text(String(format: "%.1f%%", sectorPercent?["negative"] ?? 0))
                    .font(.headline2)
                    .foregroundColor(.bluePrimary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.bottom, 0)
            
            // 차트
            Chart {
                if let percentData = sectorPercent {
                    ForEach(Array(percentData.sorted { pair1, pair2 in
                        let index1 = sentimentOrder.firstIndex(of: pair1.key) ?? 0
                        let index2 = sentimentOrder.firstIndex(of: pair2.key) ?? 0
                        return index1 < index2
                    }), id: \.key) { sentiment, ratio in
                        BarMark(
                            x: .value("비율", ratio / 100),  // 퍼센트를 비율로 변환
                            y: .value("감정", ""),
                            height: MarkDimension(floatLiteral: 10)
                        )
                        .foregroundStyle(sentimentColors[sentiment] ?? .grayNeutural)
                    }
                }
            }
            .frame(height: 8)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            
            // 감정 레이블을 하단에 표시
            HStack(spacing: 0) {
                Text("긍정적")
                    .font(.caption2)
                    .foregroundColor(.lableSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("중립적")
                    .font(.caption2)
                    .foregroundColor(.lableSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("부정적")
                    .font(.caption2)
                    .foregroundColor(.lableSecondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.bottom, 37)
        }
        .onChange(of: sectorPercent) { _, newSectorPercent in
            sectorPercent = newSectorPercent
        }
    }
}
