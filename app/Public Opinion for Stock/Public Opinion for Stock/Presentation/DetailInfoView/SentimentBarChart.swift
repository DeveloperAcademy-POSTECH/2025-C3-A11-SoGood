import SwiftUI
import Charts


struct SentimentBarChart: View {
    @StateObject private var viewModel = SectorViewModel(shouldLoad: false)
    @State private var selectedIndex: Int
    @State private var currentSectorName: String
    @State private var currentSectorData: SectorData
    
    
    private var sentimentOrder = ["긍정", "중립", "부정"]
    private var sentimentColors: [String: Color] = [
        "긍정": .redPrimary,
        "중립": .grayNeutural,
        "부정": .bluePrimary
    ]
    
    let sectorName: String
    let sectorData: SectorData
    let allSector: [String]
    let allSectorData: [String: SectorData]
    let selectedDate: String
    
    init(
        sectorName: String,
        sectorData: SectorData,
        allSector: [String],
        allSectorData: [String: SectorData],
        selectedDate: String
    ) {
        self.sectorName = sectorName
        self.sectorData = sectorData
        self.allSector = allSector
        self.allSectorData = allSectorData
        self.selectedDate = selectedDate
        self._selectedIndex = State(initialValue: allSector.firstIndex(of: sectorName) ?? 0)
        self._currentSectorName = State(initialValue: sectorName)
        self._currentSectorData = State(initialValue: sectorData)
    }
    
    
    
    var body: some View {
        
        ScrollView() {
            
            VStack(alignment: .leading) {
                
                // MARK: - 탭바
                
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 24) {
                            ForEach(allSector.indices, id: \.self) { index in
                                Text(allSector[index])
                                    .font(.headline2)
                                    .foregroundStyle(index == selectedIndex ? .black : .gray)
                                    .id(index)
                                    .onTapGesture {
                                        withAnimation {
                                            selectedIndex = index
                                        }
                                    }
                            }
                            
                        
                            
                            
                        }
                        .frame(height: 40)
                        .padding(.vertical, 8)
                    }
                    .onChange(of: selectedIndex, initial: true) { _, newIndex in
                        withAnimation {
                            proxy.scrollTo(newIndex, anchor: .center)
                        }
                        let newSectorName = allSector[newIndex]
                        if let newData = allSectorData[newSectorName] {
                            currentSectorName = newSectorName
                            currentSectorData = newData
                            viewModel.injectSectorData(sector: newSectorName, data: newData)
                            viewModel.calculateSentimentRatios(for: newSectorName, date: selectedDate)
                        }
                    }
                }
                
                
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
                
                Text("\(currentSectorName) 종목에 대한 사람들의 반응을 모아봤어요.")
                    .multilineTextAlignment(.leading)
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
                
                SentimentSummaryView(
                    viewModel: viewModel,
                    sectorName: currentSectorName,
                    selectedDate: selectedDate
                )
                
                
            }
            .padding(.horizontal, 16)
            .onAppear {
                viewModel.injectSectorData(sector: sectorName, data: sectorData)
                viewModel.calculateSentimentRatios(for: sectorName, date: selectedDate)
            }
            .onChange(of: selectedIndex, initial: false) { _, newIndex  in
                let newSectorName = allSector[newIndex]
                
                if let newData = allSectorData[newSectorName] {
                    currentSectorName = newSectorName
                    currentSectorData = newData
                    viewModel.injectSectorData(sector: newSectorName, data: newData)
                    viewModel.calculateSentimentRatios(for: newSectorName, date: selectedDate)
                }
            }
            }
            
            

        
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




#Preview {
    //    SentimentBarChart(sectorName: "IT", sectorData: SectorData(id: "dummy", dates: [:]), allSector: ["IT", "바이오", "반도체"], selectedDate: "2025-05-21")
}
