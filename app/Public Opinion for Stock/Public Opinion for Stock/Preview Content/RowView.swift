//
//  RowView.swift
//  Public Opinion for Stock
//
//  Created by Jacob on 6/3/25.
//

import SwiftUI

struct RowView: View {
    let index: Int
    let item: RowItem_test

    var valueColor: Color {
        if item.value > 0 {
            return .red
        } else if item.value < 0 {
            return .blue
        } else {
            return .gray
        }
    }

    var valueText: String {
        if item.value > 0 {
            return "+\(item.value)%"
        } else if item.value < 0 {
            return "\(item.value)%"
        } else {
            return "0%"
        }
    }

    var body: some View {
        HStack {
            Text("\(index + 1)")
                .frame(width: 24)
                .foregroundColor(.blue)
            Image(systemName: "cpu")
                .foregroundColor(.blue)
            Text(item.name)
                .frame(width: 60, alignment: .leading)
            Spacer()
            Text(valueText)
                .foregroundColor(valueColor)
        }
        .padding(.vertical, 8)
    }
}
