import SwiftUI
import FirebaseFirestore

struct SectorListView: View {
    @StateObject private var viewModel = SectorViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("즐겨찾기 종목")) {
                    ForEach(viewModel.favorites) { sector in
                        SectorRow(sector: sector) {
                            viewModel.toggleFavorite(sector)
                        }
                    }
                }
                
                Section(header: Text("전체 종목")) {
                    ForEach(viewModel.sectors) { sector in
                        SectorRow(sector: sector) {
                            viewModel.toggleFavorite(sector)
                        }
                    }
                }
            }
            .navigationTitle("주식 종목")
            .toolbar {
                // 테스트용 버튼 - 실제 앱에서는 제거
                Button("초기 데이터 추가") {
                    viewModel.addInitialSectorsIfNeeded()
                }
            }
        }
    }
}

struct SectorRow: View {
    let sector: Sector
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(sector.name)
                    .font(.headline)
                HStack(spacing: 12) {
                    Label("\(sector.positiveCount)", systemImage: "arrow.up.circle")
                        .foregroundColor(.green)
                    Label("\(sector.negativeCount)", systemImage: "arrow.down.circle")
                        .foregroundColor(.red)
                }
                .font(.caption)
            }
            
            Spacer()
            
            Button(action: onFavoriteToggle) {
                Image(systemName: sector.isFavorite ? "star.fill" : "star")
                    .foregroundColor(sector.isFavorite ? .yellow : .gray)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    SectorListView()
} 