import SwiftUI


struct DetailInfoMainSummaryView: View {
    @ObservedObject var viewModel: SectorViewModel
    let sectorName: String
    let selectedDate: String
    
    var body: some View {
        
        
        VStack(spacing: 8) {
            
            DetailInfoSummaryItemView(viewModel: viewModel, sectorName: sectorName, selectedDate: selectedDate, sentimentType: "긍정")
            DetailInfoSummaryItemView(viewModel: viewModel, sectorName: sectorName, selectedDate: selectedDate, sentimentType: "부정")
            DetailInfoSummaryItemView(viewModel: viewModel, sectorName: sectorName, selectedDate: selectedDate, sentimentType: "중립")
            
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


//#Preview {
//    SentimentSummaryView()
//}
