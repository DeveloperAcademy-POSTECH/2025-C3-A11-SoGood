import SwiftUI

struct DetailInfoMainView: View {
    @ObservedObject var viewModel: SectorViewModel
    @Binding var selectedSector: String
    let date: String
    
    init(viewModel: SectorViewModel, selectedSector: Binding<String>, date: String) {
        self.viewModel = viewModel
        self._selectedSector = selectedSector
        self.date = date
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            DetailInfoMainTopView(currentSectorName: selectedSector)
            
            DetailInfoMainChartView(viewModel: viewModel)
            
            DetailInfoMainSummaryView(
                viewModel: viewModel,
                selectedSector: $selectedSector,
                selectedDate: date
            )
        }
        .padding(.horizontal, 16)
    }
}