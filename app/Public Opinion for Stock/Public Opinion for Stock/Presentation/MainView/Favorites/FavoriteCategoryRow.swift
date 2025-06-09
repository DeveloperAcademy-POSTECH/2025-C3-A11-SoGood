import SwiftUI


struct FavoriteCategoryRow: View {
    let item: CategoryItem  // FavoriteItem에서 CategoryItem으로 변경
    let isFavorite: Bool
    let onToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 16) {
                    Circle()
                        .fill(Color(hex: "#E9EDFC"))
                        .frame(width: 44, height: 44)
                    
                    Text(item.name)
                        .font(.body1)
                        .foregroundColor(Color(.lablePrimary))
                }
                
                Spacer()
                
                Button(action: onToggle) {
                    Image(systemName: isFavorite ? "minus.circle.fill" : "plus.circle.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(isFavorite ? .red : .green)  // .redPrimary와 .accent 대신 .red와 .green 사용
                }
            }
            .padding(.horizontal, 16)
 
            Divider()
                .background(Color(.tertiaryLabel))
        }
        .padding(.bottom, 8)
    }
}