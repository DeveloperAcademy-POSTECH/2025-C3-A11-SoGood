//
//  TestView.swift
//  Public Opinion for Stock
//
//  Created by Jacob on 6/6/25.
//

import SwiftUI

struct DetailView: View {
    var items: [RowItem]
    var name: String
    var date: Date
    
    var body: some View {
        Text (date.description)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(items) { item in
                    Text(item.name)
                        .font(.headline)
                        .foregroundStyle(item.name == name ? .redPrimary : .primary)
                }
            }
            .padding(.horizontal)
        }
    }
}
