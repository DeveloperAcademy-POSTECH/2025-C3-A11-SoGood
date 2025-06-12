import SwiftUI

struct TreeMapViewBlockModel: View {
    let treeBlock: TreeMapBlock
    
    var body: some View {
        VStack(spacing: 3) {
            Text(treeBlock.label)
                .font(.headline1)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.primary)
            
            Text(treeBlock.percent)
                .font(.body2)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(treeBlock.sentiment.percentColor)
        }
        .frame(width: treeBlock.rect.width, height: 80)
        .background(treeBlock.color)
        .cornerRadius(5)
    }
}
