import SwiftUI

struct FavoriteView: View {
    @ObservedObject var viewModel: FavoriteViewModel
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
                                            FavoriteCategoryRow(item: item, isFavorite: true) {
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
                                        FavoriteCategoryRow(item: item, isFavorite: item.isFavorite) {
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
        .navigationBarHidden(true)
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
