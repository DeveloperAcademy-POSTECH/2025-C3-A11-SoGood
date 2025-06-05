import SwiftUI

struct StockListView: View {
    @StateObject private var viewModel: StockViewModel
    
    init(userId: String) {
        _viewModel = StateObject(wrappedValue: StockViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("즐겨찾기 종목")) {
                    ForEach(viewModel.favorites) { stock in
                        StockRow(stock: stock, onFavorite: {
                            viewModel.toggleFavorite(stock)
                        })
                    }
                }
                
                Section(header: Text("전체 종목")) {
                    ForEach(viewModel.stocks) { stock in
                        StockRow(stock: stock, onFavorite: {
                            viewModel.toggleFavorite(stock)
                        })
                    }
                }
            }
            .navigationTitle("주식 종목")
            .onAppear {
                viewModel.loadUserFavorites()
            }
        }
    }
}

struct StockRow: View {
    let stock: Stock
    let onFavorite: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(stock.sectorName)
                    .font(.headline)
                HStack(spacing: 12) {
                    Label("\(stock.positiveCount)", systemImage: "arrow.up.circle")
                        .foregroundColor(.green)
                    Label("\(stock.negativeCount)", systemImage: "arrow.down.circle")
                        .foregroundColor(.red)
                }
                .font(.caption)
            }
            
            Spacer()
            
            Button(action: onFavorite) {
                Image(systemName: stock.isFavorite ? "star.fill" : "star")
                    .foregroundColor(stock.isFavorite ? .yellow : .gray)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    StockListView(userId: "preview_user")
} 