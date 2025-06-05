import SwiftUI

struct FavoriteButton: View {
    @State private var isFavorite: Bool = false
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: {
            isFavorite.toggle()
            action()
        }) {
            HStack(spacing: 8) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(isFavorite ? .yellow : .gray)
                Text("즐겨찾기")
                    .foregroundColor(isFavorite ? .primary : .gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isFavorite ? Color.yellow : Color.gray, lineWidth: 1)
            )
        }
    }
}

#Preview {
    FavoriteButton()
} 