import SwiftUI


struct SentimentSummaryView: View {
    @StateObject private var viewModel = SectorViewModel()
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            SentimentItemView(viewModel: viewModel, sentimentType: "긍정")
            
            SentimentItemView(viewModel: viewModel, sentimentType: "부정")
            
            SentimentItemView(viewModel: viewModel, sentimentType: "중립")
        }
        .padding()
    }
}


struct SentimentItemView: View {
    @ObservedObject var viewModel: SectorViewModel
    @State private var isExpanded: Bool = false
    
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
    
    var latestDateSummary: (headline: String, summary: String)? {
        if let sectorData = currentSectorData,
           let latestDate = sectorData.dates.keys.sorted().last,
           let dateInfo = sectorData.dates[latestDate] {
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
            
            if let summary = latestDateSummary {
                Text(summary.headline)
                    .font(isExpanded ? .body3 : .body2)
                    .foregroundStyle(.lablePrimary)
                
            
                if isExpanded {
                    Text(summary.summary)
                        .font(.body1)
                        .foregroundStyle(.lablePrimary)
                }
                
            }
            
        }
        .padding()
    }
        
}

#Preview {
    SentimentSummaryView()
}
