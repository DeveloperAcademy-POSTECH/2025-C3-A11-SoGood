import SwiftUI

struct BlockView: View {
    let block: TreemapBlock
    
    var body: some View {
        VStack(spacing: 3) {
            Text(block.label)
                .font(.headline1)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.primary)
            
            Text(block.percent)
                .font(.body2)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(block.sentiment.percentColor)
        }
        .frame(width: block.rect.width, height: 80)
        .background(block.color)
        .cornerRadius(5)
    }
}

struct TreeMapView: View {
    @StateObject private var viewModel: TreemapViewModel
    @ObservedObject var favoriteViewModel: FavoriteViewModel
    private let size: CGSize
    
    init(favoriteViewModel: FavoriteViewModel, size: CGSize = CGSize(width: 361, height: 144)) {
        self.size = size
        self._viewModel = StateObject(wrappedValue: TreemapViewModel(size: size))
        self.favoriteViewModel = favoriteViewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("즐겨찾기 항목")
                    .font(.title)
                    .foregroundColor(.primary)
                Spacer()
                NavigationLink {
                    FavoriteView(viewModel: favoriteViewModel)
                } label: {
                    Text("편집")
                        .font(.body2)
                        .foregroundColor(Color(.bluePrimary))
                }
            }
            .padding(.horizontal)
            
            Group {
                if favoriteViewModel.favoriteCategories.isEmpty {
                    VStack {
                        Text("즐겨찾기 항목을 추가해주세요.")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .frame(width: size.width, height: 144)
                } else {
                    ZStack(alignment: .topLeading) {
                        ForEach(viewModel.blocks) { block in
                            BlockView(block: block)
                                .position(x: block.rect.midX, y: block.rect.midY)
                        }
                    }
                    .frame(width: size.width, height: viewModel.contentHeight)
                    .onAppear {
                        viewModel.updateData(with: favoriteViewModel)
                    }
                    .onChange(of: favoriteViewModel.favoriteCategories.count) { _, _ in
                        viewModel.updateData(with: favoriteViewModel)
                    }
                }
            }
            .padding(16)
        }
    }
}

#Preview {
    TreeMapView(favoriteViewModel: FavoriteViewModel())
}
