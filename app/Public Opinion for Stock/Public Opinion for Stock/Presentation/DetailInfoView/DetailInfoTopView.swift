import SwiftUI

struct DetailInfoTopView: View {
    let allSector: [String]
    @Binding var selectedIndex: Int
    let allSectorData: [String: SectorData]
    let selectedDate: String
    @ObservedObject var viewModel: SectorViewModel
    @Binding var currentSectorName: String
    @Binding var currentSectorData: SectorData
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(allSector.indices, id: \.self) { index in
                        Text(allSector[index])
                            .font(.headline2)
                            .foregroundStyle(index == selectedIndex ? .black : .gray)
                            .id(index)
                            .onTapGesture {
                                withAnimation {
                                    selectedIndex = index
                                }
                            }
                    }
                }
                .frame(height: 40)
                .padding(.vertical, 8)
            }
            .onChange(of: selectedIndex, initial: true) { _, newIndex in
                withAnimation {
                    proxy.scrollTo(newIndex, anchor: .center)
                }
                let newSectorName = allSector[newIndex]
                if let newData = allSectorData[newSectorName] {
                    currentSectorName = newSectorName
                    currentSectorData = newData
                    viewModel.injectSectorData(sector: newSectorName, data: newData)
                    viewModel.calculateSentimentRatios(for: newSectorName, date: selectedDate)
                }
            }
        }
    }
}
