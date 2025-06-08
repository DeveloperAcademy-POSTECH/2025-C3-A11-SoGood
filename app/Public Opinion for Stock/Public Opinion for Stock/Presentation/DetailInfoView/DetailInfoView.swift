import SwiftUI

struct DetailInfoView: View {
    var sectors: [MainRowItem]
    @State private var selectedSector: String
    @StateObject private var detailInfoViewModel: DetailInfoViewModel
    @StateObject private var sentimentChartViewModel: SentimentViewModel
    var date: String

    init(sectors: [MainRowItem], selectedSector: String, date: String) {
        self.sectors = sectors
        self._selectedSector = State(initialValue: selectedSector)
        self.date = date
        self._detailInfoViewModel = StateObject(wrappedValue: DetailInfoViewModel(selectedSector: selectedSector, date: date))
        self._sentimentChartViewModel = StateObject(
            wrappedValue: SentimentViewModel(selectedSector: selectedSector)
        )
    }


    var body: some View {
        ScrollView {
            VStack {
                DetailInfoTopView(
                    sectors: sectors,
                    selectedSector: $selectedSector
                )
                DetailInfoMainView(
                    sectorDetail: $detailInfoViewModel.sectorDetail,
                    sectorPercent: $detailInfoViewModel.sectorPercent,
                    selectedSector: $selectedSector,
                    sectorDetailDetail: $detailInfoViewModel.sectorDetailDetail,
                    date: date
                )
                SentimentFrameView()
                    .environmentObject(sentimentChartViewModel)
            }
        }
        .onChange(of: selectedSector) { _, newSector in
            detailInfoViewModel.updateSector(newSector)
            sentimentChartViewModel.updateCategory(newSector)
        }
    }
}
