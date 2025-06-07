import SwiftUI

struct DetailInfoView: View {
    @StateObject private var viewModel = SectorViewModel(shouldLoad: false)
    @State private var selectedIndex: Int
    @State private var currentSectorName: String
    @State private var currentSectorData: SectorData
    
    let sectorName: String
    let sectorData: SectorData
    let allSector: [String]
    let allSectorData: [String: SectorData]
    let selectedDate: String
    
    init(
        sectorName: String,
        sectorData: SectorData,
        allSector: [String],
        allSectorData: [String: SectorData],
        selectedDate: String
    ) {
        self.sectorName = sectorName
        self.sectorData = sectorData
        self.allSector = allSector
        self.allSectorData = allSectorData
        self.selectedDate = selectedDate
        self._selectedIndex = State(initialValue: allSector.firstIndex(of: sectorName) ?? 0)
        self._currentSectorName = State(initialValue: sectorName)
        self._currentSectorData = State(initialValue: sectorData)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                DetailInfoTopView(
                    allSector: allSector,
                    selectedIndex: $selectedIndex,
                    allSectorData: allSectorData,
                    selectedDate: selectedDate,
                    viewModel: viewModel,
                    currentSectorName: $currentSectorName,
                    currentSectorData: $currentSectorData
                )
                
                DetailInfoMainView(
                    viewModel: viewModel,
                    currentSectorName: currentSectorName,
                    selectedDate: selectedDate
                )
            }
            .onAppear {
                viewModel.injectSectorData(sector: sectorName, data: sectorData)
                viewModel.calculateSentimentRatios(for: sectorName, date: selectedDate)
            }
        }
    }
}