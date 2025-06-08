import SwiftUI


struct DetailInfoMainSummaryView: View {
    @Binding var sectorDetail: [String: Any]?
    @Binding var sectorDetailDetail: [String: Any]?
    
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
            
            NavigationLink(destination: Text("detailDetailView")) {
                HStack {
                    Text("\(sectorDetailDetail?.count ?? 0)개의 의견보기")
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
