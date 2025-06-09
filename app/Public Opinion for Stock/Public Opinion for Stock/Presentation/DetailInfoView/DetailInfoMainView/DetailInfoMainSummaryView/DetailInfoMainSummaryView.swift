import SwiftUI


struct DetailInfoMainSummaryView: View {
    @Binding var selectedSector: String
    @Binding var sectorDetail: [String: Any]?
    @Binding var sectorDetailDetail: [String: Any]?
    let date: String
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            DetailInfoSummaryItemView(
                sectorDetail: $sectorDetail,
                sentimentType: "positive"
            )
            
            DetailInfoSummaryItemView(
                sectorDetail: $sectorDetail,
                sentimentType: "negative"
            )
            
            DetailInfoSummaryItemView(
                sectorDetail: $sectorDetail,
                sentimentType: "neutral"
            )

            Divider()
                .padding()
            
            NavigationLink(destination: DetailExplainView(sectorDetailDetail: sectorDetailDetail, date: date, selectedSector: selectedSector)) {
                HStack {
                    Text("\(sectorDetailDetail?.count ?? 0)개 채널 의견보기")
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


//#Preview {
//    SentimentSummaryView()
//}
