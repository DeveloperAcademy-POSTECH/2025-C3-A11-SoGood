import SwiftUI

struct FavoriteView: View {
    @ObservedObject private var viewModel = FavoriteViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 24) {
                // 네비게이션 바
                HStack(spacing: 99) {
                    Button("취소") {
                        dismiss()
                    }
                    .font(.body2)
                    .foregroundColor(Color(.gray))
                    
                    Text("즐겨찾는 종목")
                        .font(.headline2)
                        .foregroundColor(Color(.lablePrimary))
                    
                    Button("완료") {
                        viewModel.saveChanges()
                        dismiss()
                    }
                    .font(.body2)
                    .foregroundColor(Color(.bluePrimary))
                }
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.5)
                    Spacer()
                } else if let errorMessage = viewModel.errorMessage {
                    Spacer()
                    VStack(spacing: 16) {
                        Text("오류가 발생했습니다")
                            .font(.headline2)
                            .foregroundColor(Color(.lablePrimary))
                        Text(errorMessage)
                            .font(.body2)
                            .foregroundColor(Color(.gray))
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    Spacer()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 40) {
                            // 즐겨찾기 섹션
                            if !viewModel.favoriteCategories.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack(spacing: 8) {
                                        Text("즐겨찾기")
                                            .font(.headline2)
                                            .foregroundColor(Color(.lablePrimary))
                                        Text("\(viewModel.selectedCount)/10")
                                            .font(.body2)
                                            .foregroundColor(Color(.gray))
                                    }
                                    
                                    VStack(spacing: 0) {
                                        ForEach(viewModel.favoriteCategories) { item in
                                            CategoryRow(item: item, isFavorite: true) {
                                                viewModel.toggleFavorite(for: item)
                                            }
                                        }
                                    }
                                    .background(Color.white)
                                    .cornerRadius(10)
                                }
                            }
                            
                            // 투자분야 섹션
                            VStack(alignment: .leading, spacing: 20) {
                                HStack(spacing: 8) {
                                    Text("투자분야")
                                        .font(.headline2)
                                        .foregroundColor(Color(.lablePrimary))
                                    Text("\(viewModel.investmentCategories.count)")
                                        .font(.body2)
                                        .foregroundColor(Color(.gray))
                                }
                                
                                VStack(spacing: 0) {
                                    ForEach(viewModel.investmentCategories.filter { !$0.isFavorite }) { item in
                                        CategoryRow(item: item, isFavorite: item.isFavorite) {
                                            viewModel.toggleFavorite(for: item)
                                        }
                                    }
                                }
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 32)
                    }
                }
            }
        }
        .alert(item: Binding(
            get: { viewModel.errorMessage.map { ErrorWrapper(message: $0) } },
            set: { _ in viewModel.errorMessage = nil }
        )) { error in
            Alert(
                title: Text("오류"),
                message: Text(error.message),
                dismissButton: .default(Text("확인"))
            )
        }
    }
}

struct CategoryRow: View {
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

private struct ErrorWrapper: Identifiable {
    let id = UUID()
    let message: String
}

#Preview {
    FavoriteView()
}
