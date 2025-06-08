import SwiftUI

struct DetailInfoMainView: View {
    @ObservedObject var viewModel: SectorViewModel
    @ObservedObject var detailInfoViewModel: DetailInfoViewModel
    @Binding var selectedSector: String
    let date: String
    
    init(viewModel: SectorViewModel, detailInfoViewModel: DetailInfoViewModel, selectedSector: Binding<String>, date: String) {
        self.viewModel = viewModel
        self.detailInfoViewModel = detailInfoViewModel
        self._selectedSector = selectedSector
        self.date = date
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            DetailInfoMainTopView(currentSectorName: selectedSector)
            
            DetailInfoMainChartView(viewModel: viewModel, detailInfoViewModel: detailInfoViewModel, selectedSector: $selectedSector, date: date)
            
            DetailInfoMainSummaryView(
                viewModel: viewModel,
                selectedSector: $selectedSector,
                selectedDate: date
            )
        }
        .padding(.horizontal, 16)
    }
}