import SwiftUI

struct DetailInfoView: View {
    var items: [RowItem]
    @State private var selectedSector: String
    @StateObject private var viewModel = SectorViewModel()
    @StateObject private var sentimentChartViewModel: SentimentViewModel
    var date: String

    init(items: [RowItem], name: String, date: String) {
        self.items = items
        self._selectedSector = State(initialValue: name)
        self.date = date
        self._sentimentChartViewModel = StateObject(
            wrappedValue: SentimentViewModel(category: name)
        )
    }


    var body: some View {
        ScrollView {
            VStack {
                DetailInfoTopView(
                    items: items,
                    currentName: $selectedSector
                )
                DetailInfoMainView(
                    viewModel: viewModel,
                    selectedSector: $selectedSector,
                    date: date
                )
                SentimentFrameView()
                    .environmentObject(sentimentChartViewModel)
            }
        }
    }
}