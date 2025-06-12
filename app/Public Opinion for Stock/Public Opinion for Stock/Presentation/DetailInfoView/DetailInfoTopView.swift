import SwiftUI

struct DetailInfoTopView: View {
    let sectors: [MainRowItem]
    @Binding var selectedSector: String
    
    // 선택된 아이템의 스타일을 결정하는 함수
    private func textStyle(for itemName: String) -> Color {
        itemName == selectedSector ? .black : .gray
    }
    
    // 아이템을 탭했을 때의 동작
    private func itemTapped(proxy: ScrollViewProxy, item: MainRowItem) {
        withAnimation {
            selectedSector = item.sector
            proxy.scrollTo(item.sector, anchor: .center)
        }
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(sectors) { item in
                        Text(item.sector)
                            .font(.headline2)
                            .foregroundStyle(textStyle(for: item.sector))
                            .id(item.sector)
                            .onTapGesture {
                                itemTapped(proxy: proxy, item: item)
                            }
                    }
                }
                .frame(height: 40)
                .padding(.vertical, 8)
            }
            .onAppear {
                withAnimation {
                    proxy.scrollTo(selectedSector, anchor: .center)
                }
            }
        }
    }
}