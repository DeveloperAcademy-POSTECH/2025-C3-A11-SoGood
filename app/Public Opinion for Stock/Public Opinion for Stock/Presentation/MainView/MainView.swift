import SwiftUI

struct MainView: View {
    @StateObject private var favoriteViewModel = FavoriteViewModel()
    @StateObject private var mainViewModel = MainViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing:16) {
                    TreeMapView(favoriteViewModel: favoriteViewModel)
                    Divider()
                    ListView(mainViewModel: mainViewModel)
                }
                .frame(width: 361, alignment: .leading)
                .padding(.horizontal,16)
            }
        }
    }
}

#Preview {
    MainView()
}
