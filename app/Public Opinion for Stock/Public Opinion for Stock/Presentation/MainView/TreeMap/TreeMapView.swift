import SwiftUI


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
                            TreeMapViewBlockModel(treeBlock: block)
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
        }
    }
}

#Preview {
    TreeMapView(favoriteViewModel: FavoriteViewModel())
}
