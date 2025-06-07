import SwiftUI


struct SentimentSummaryView: View {
    @ObservedObject var viewModel: SectorViewModel
    let sectorName: String
    let selectedDate: String
    
    var body: some View {
        
        
        VStack(spacing: 8) {
            
            SentimentItemView(viewModel: viewModel, sectorName: sectorName, selectedDate: selectedDate, sentimentType: "긍정")
            
            SentimentItemView(viewModel: viewModel, sectorName: sectorName, selectedDate: selectedDate, sentimentType: "부정")
            
            SentimentItemView(viewModel: viewModel, sectorName: sectorName, selectedDate: selectedDate, sentimentType: "중립")
            
            Divider()
                .padding()
            
            // FIXME: 네비게이션 연결 및 넘어가는 데이터 설정
            NavigationLink(destination: Text("detailDetailView")) {
                HStack {
                    Text("316개의 의견보기")
                        .font(.subheadline1)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                }
                .foregroundStyle(.lableSecondary)
                
                
            }
            .padding(.horizontal, -16)
            .padding(.bottom)
        }
    }
    
}



struct SentimentItemView: View {
    @ObservedObject var viewModel: SectorViewModel
    @State private var isExpanded: Bool = false
    
    let sectorName: String
    let selectedDate: String
    let sentimentType: String
    
    var sentimentColor: Color {
        switch sentimentType {
        case "긍정":
            return .redPrimary
        case "부정":
            return .bluePrimary
        default:
            return .lableSecondary
            
        }
    }
    
    var sentimentTitle: String {
        switch sentimentType {
        case "긍정":
            return "긍정적 반응"
        case "부정":
            return "부정적 반응"
        default:
            return "중립적 반응"
        }
    }
    
    var currentSectorData: SectorData? {
        if let selectedSector = viewModel.selectedSector {
            return viewModel.sectors[selectedSector]
        }
        return nil
    }

    
    var summaryText: (headline: String, summary: String)? {
        if let sectorData = viewModel.sectors[sectorName],
           let dateInfo = sectorData.dates[selectedDate] {
            switch sentimentType {
            case "긍정":
                return (dateInfo.summary.긍정.headline, dateInfo.summary.긍정.summary)
            case "부정":
                return (dateInfo.summary.부정.headline, dateInfo.summary.부정.summary)
            default:
                return (dateInfo.summary.중립.headline, dateInfo.summary.중립.summary)
            }
        }
        return nil
    }
    
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text(sentimentTitle)
                    .font(.headline3)
                    .foregroundStyle(sentimentColor)
                
                Spacer()
                
                Button {
                    isExpanded.toggle()
                } label: {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.lableSecondary)
                }
                
            }
            
            if let summary = summaryText {
                Text(summary.headline)
                    .font(isExpanded ? .body3 : .body2)
                    .foregroundStyle(.lablePrimary)
                    .lineLimit(nil)
                
                
                if isExpanded {
                    Text(summary.summary)
                        .font(.body1)
                        .foregroundStyle(.lablePrimary)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
            }
            
        }
        .padding(.vertical)
    }
    
}

//#Preview {
//    SentimentSummaryView()
//}
