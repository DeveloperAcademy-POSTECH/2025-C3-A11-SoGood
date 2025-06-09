import SwiftUI

struct MainView: View {
    @StateObject private var favoriteViewModel = FavoriteViewModel()
    @StateObject private var mainViewModel = MainViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Spacer()
                    TreeMapView(favoriteViewModel: favoriteViewModel)
                    ListView(mainViewModel: mainViewModel)
                }
                .padding(16)
            }
        }
    }
}

#Preview {
    MainView()
}
