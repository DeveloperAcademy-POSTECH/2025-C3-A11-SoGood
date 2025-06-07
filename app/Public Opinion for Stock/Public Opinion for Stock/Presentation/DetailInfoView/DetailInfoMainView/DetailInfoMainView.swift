import SwiftUI

struct DetailInfoMainView: View {
    @ObservedObject var viewModel: SectorViewModel
    let currentSectorName: String
    let selectedDate: String
    
    var body: some View {
        VStack(alignment: .leading) {
            DetailInfoMainTopView(currentSectorName: currentSectorName)
            
            DetailInfoMainChartView(viewModel: viewModel)
            
            SentimentSummaryView(
                viewModel: viewModel,
                sectorName: currentSectorName,
                selectedDate: selectedDate
            )
        }
        .padding(.horizontal, 16)
    }
}