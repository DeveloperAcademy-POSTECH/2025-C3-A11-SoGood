//
//  FavoritesView.swift
//  Public Opinion for Stock
//
//  Created by Karyn Hakyung Kim on 6/5/25.
//

import SwiftUI


struct FavoriteView: View {
    @State private var fruits = [
        "Apple",
        "Banana",
        "Papaya",
        "Mango"
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(fruits, id: \.self) { fruit in
                    Text(fruit)
                }
                .onDelete { fruits.remove(atOffsets: $0) }
                .onMove { fruits.move(fromOffsets: $0, toOffset: $1) }
            }
            .navigationTitle("Fruits")
            .toolbar {
                EditButton()
            }
        }
    }
}

#Preview {
    FavoriteView()
}
