//
//  SectorDetailView.swift
//  Public Opinion for Stock
//
//  Created by 우정아 on 6/2/25.
//

import SwiftUI
import Charts

struct SectorDetailView: View {
    @StateObject private var viewModel = PublicOpinionsViewModel()
    
    private var sentimentOrder = ["긍정", "중립", "부정"]
    private var sentimentColors: [String: Color] = [
        "긍정": .red,
        "중립": .gray,
        "부정": .blue
    ]
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading) {
                
                // MARK: -- 탭바
                HStack(spacing: 24) {
                    Spacer()
                    
                    // FIXME: 데이터 수정
                    Text("배터리")
                        .font(.headline)
                        .foregroundStyle(.gray)
                    Text("IT")
                        .font(.headline)
                    Text("조선기자재")
                        .font(.headline)
                        .foregroundStyle(.gray)
                    Spacer()
                }.padding()
                
                // MARK: -- 오늘 대중의 이야기 섹터
                HStack {
                    Text("오늘 대중의 이야기")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // FIXME: 버튼 후 안내창 수정
                    Button {
                        print("버튼 눌렀어엽")
                    } label: {
                        HStack {
                            Text("AI요약")
                                .font(.caption)
                                .underline()
                                .foregroundStyle(.gray)
                            Image(systemName: "info.circle")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.top, 8)
                    Spacer()
                    
                }.padding(.bottom, 4)
                
                Text("\(viewModel.groupedBySectorAndDate.keys.sorted().first ?? "섹터 없음") 종목에 대한 사람들의 반응을 모아봤어요.")
                    .font(.subheadline)
                    .padding(.bottom)
                
                
                // MARK: -- 그래프 섹터
                // 감정 비율을 상단에 표시
                HStack {
                    // 긍정 퍼센트
                    Text(String(format: "%.1f%%", viewModel.sentimentRatios["긍정"] ?? 0))
                        .font(.headline)
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // 중립
                    Spacer()
                        .frame(maxWidth: .infinity)
                    
                    // 부정 퍼센트
                    Text(String(format: "%.1f%%", viewModel.sentimentRatios["부정"] ?? 0))
                        .font(.headline)
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
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
                            y: .value("감정", " "),
                            height: MarkDimension(floatLiteral: 10)
                        )
                        .foregroundStyle(sentimentColors[sentiment] ?? .gray)
                        
                        
                    }
                }
                .frame(height: 8)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                
                
                // 감정 레이블을 하단에 표시
                HStack(spacing: 0) {
                    Text("긍정적")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("중립적")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("부정적")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
          
                
                
                
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
        }
        .onAppear {
            viewModel.loadDummyDataGroupedBySectorAndDate()
            viewModel.calculationSentimentRatios()
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
    SectorDetailView()
}
