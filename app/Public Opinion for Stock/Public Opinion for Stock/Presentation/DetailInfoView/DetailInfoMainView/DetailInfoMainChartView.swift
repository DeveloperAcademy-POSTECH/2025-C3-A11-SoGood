import SwiftUI
import Charts

struct DetailInfoMainChartView: View {  // public 제거
    @ObservedObject var viewModel: SectorViewModel

    init(viewModel: SectorViewModel) {
        self.viewModel = viewModel
    }
    
    private var sentimentOrder = ["긍정", "중립", "부정"]
    private var sentimentColors: [String: Color] = [
        "긍정": .redPrimary,
        "중립": .grayNeutural,
        "부정": .bluePrimary
    ]
    
    var body: some View {  // public 제거
        VStack {
            HStack {
                Text(String(format: "%.1f%%", viewModel.sentimentRatios["긍정"] ?? 0))
                    .font(.headline2)
                    .foregroundColor(.redPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                    .frame(maxWidth: .infinity)
                
                Text(String(format: "%.1f%%", viewModel.sentimentRatios["부정"] ?? 0))
                    .font(.headline2)
                    .foregroundColor(.bluePrimary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.bottom, 0)
            
            // 차트
            Chart {
                ForEach(viewModel.sentimentRatios.sorted { sentiment1, sentiment2 in
                    let index1 = sentimentOrder.firstIndex(of: sentiment1.key) ?? 0
                    let index2 = sentimentOrder.firstIndex(of: sentiment2.key) ?? 0
                    return index1 < index2
                }, id: \.key) { sentiment, ratio in
                    BarMark(
                        x: .value("비율", ratio),
                        y: .value("감정", ""),
                        height: MarkDimension(floatLiteral: 10)
                    )
                    .foregroundStyle(sentimentColors[sentiment] ?? .grayNeutural)
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
    }
}