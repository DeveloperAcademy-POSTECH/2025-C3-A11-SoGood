import SwiftUI
import Charts


struct SentimentBarChart: View {
    @StateObject private var viewModel = SectorViewModel(shouldLoad: false)
    @State private var selectedTab = 0
    
    
    private var sentimentOrder = ["긍정", "중립", "부정"]
    private var sentimentColors: [String: Color] = [
        "긍정": .redPrimary,
        "중립": .grayNeutural,
        "부정": .bluePrimary
    ]
    
    let sectorName: String
    let sectorData: SectorData
    let allSector: [String]
    let selectedDate: String

    init(
        sectorName: String,
        sectorData: SectorData,
        allSector: [String],
        selectedDate: String
    ) {
        self.sectorName = sectorName
        self.sectorData = sectorData
        self.allSector = allSector
        self.selectedDate = selectedDate
    }
    
    
    
    var body: some View {
        
        ScrollView() {
            
            VStack(alignment: .leading) {
                
                // MARK: - 탭바
                // FIXME: 버튼으로 변경?
                HStack(spacing: 24) {
                    Spacer()
                    
                    // FIXME: 데이터 수정
                    
                    Text(allSector.joined(separator: ", "))
                        .font(.headline2)
                    Spacer()
                }.padding()
                
                // MARK: - 오늘 대중의 이야기 섹터
                HStack {
                    Text("오늘 대중의 이야기")
                        .font(.title)
                        .foregroundStyle(.lablePrimary)
                    
                    // FIXME: 버튼 후 안내창 수정
                    Button {
                        print("AI 요약 버튼 눌렀어엽")
                    } label: {
                        HStack {
                            Text("AI요약")
                                .font(.caption1)
                                .underline()
                                .foregroundStyle(.lableSecondary)
                            Image(systemName: "info.circle")
                                .font(.caption1)
                                .foregroundStyle(.lableSecondary)
                        }
                    }
                    .padding(.top, 8)
                    Spacer()
                    
                }.padding(.bottom, 4)
                
                Text("\(sectorName) 종목에 대한 사람들의 반응을 모아봤어요.")
                    .font(.subheadline1)
                    .foregroundStyle(.lablePrimary)
                    .padding(.bottom, 37)
                
                
                // MARK: - 그래프 섹터
                // 감정 비율을 상단에 표시
                HStack {
                    // 긍정 퍼센트
                    Text(String(format: "%.1f%%", viewModel.sentimentRatios["긍정"] ?? 0))
                        .font(.headline2)
                        .foregroundColor(.redPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // 중립
                    Spacer()
                        .frame(maxWidth: .infinity)
                    
                    // 부정 퍼센트
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
            .padding(.horizontal, 16)
            .onAppear {
                viewModel.injectSectorData(sector: sectorName, data: sectorData)
                viewModel.calculateSentimentRatios(for: sectorName, date: selectedDate)
            }
            
            SentimentSummaryView(
                viewModel: viewModel,
                sectorName: sectorName,
                selectedDate: selectedDate
            )
            
            Spacer()
            
        }
    }
    
    private func getSentimentLabel(_ sentiment: String) -> String {
        switch sentiment {
        case "긍정":
            return "긍정적"
        case "중립":
            return "중립적"
        case "부정":
            return "부정적"
        default:
            return sentiment
        }
    }
}



#Preview {
//    SentimentBarChart(sectorName: "IT", sectorData: SectorData(id: "dummy", dates: [:]), allSector: ["IT", "바이오", "반도체"], selectedDate: "2025-05-21")
}
