import SwiftUI

struct DetailInfoTopView: View {
    let items: [RowItem]
    @Binding var currentName: String
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(items) { item in
                        Text(item.name)
                            .font(.headline2)
                            .foregroundStyle(item.name == currentName ? .black : .gray)
                            .id(item.name)
                            .onTapGesture {
                                withAnimation {
                                    currentName = item.name  // 선택된 이름 업데이트
                                    proxy.scrollTo(item.name, anchor: .center)
                                }
                        }
                    }
                }
                .frame(height: 40)
                .padding(.vertical, 8)
            }
            .onAppear {
                withAnimation {
                    proxy.scrollTo(currentName, anchor: .center)
                }
            }
        }
    }
}


