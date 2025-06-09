import SwiftUI

struct DetailInfoMainView: View {
    @Binding var sectorDetail: [String: Any]?
    @Binding var sectorPercent: [String: Double]?
    @Binding var selectedSector: String
    @Binding var sectorDetailDetail: [String: Any]?
    let date: String
    
    init(sectorDetail: Binding<[String: Any]?>, sectorPercent: Binding<[String: Double]?>, 
    selectedSector: Binding<String>, sectorDetailDetail: Binding<[String: Any]?>, date: String) {
        self._sectorDetail = sectorDetail
        self._sectorPercent = sectorPercent
        self._selectedSector = selectedSector
        self._sectorDetailDetail = sectorDetailDetail
        self.date = date
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            DetailInfoMainTopView(currentSectorName: selectedSector)
            
            DetailInfoMainChartView(sectorPercent: $sectorPercent, selectedSector: $selectedSector, date: date)
            
            DetailInfoMainSummaryView(
                selectedSector: $selectedSector,
                sectorDetail: $sectorDetail,
                sectorDetailDetail: $sectorDetailDetail,
                date: date
            )
        }
        .padding(.horizontal, 16)
    }
}