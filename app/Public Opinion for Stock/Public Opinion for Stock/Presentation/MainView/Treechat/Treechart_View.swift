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

struct TreemapView: View {
    @StateObject private var viewModel: TreemapViewModel
    private let size: CGSize
    
    init(size: CGSize = CGSize(width: 361, height: 252)) {
        self.size = size
        _viewModel = StateObject(wrappedValue: TreemapViewModel(size: size))
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(viewModel.blocks) { block in
                BlockView(block: block)
                    .position(x: block.rect.midX, y: block.rect.midY)
            }
        }
        .frame(width: size.width, height: size.height)
        .padding(16)
    }
}

#Preview{
    TreemapView()
}
