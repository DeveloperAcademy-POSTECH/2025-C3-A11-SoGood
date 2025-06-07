import SwiftUI

struct MainView: View {
    @StateObject private var favoriteViewModel = FavoriteViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Spacer()
                    TreeMapView(favoriteViewModel: favoriteViewModel)
                    ListView()
                }
            }
        }
    }
}

#Preview {
    MainView()
}
