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
            return .redPrimary
        } else if item.value < 0 {
            return .bluePrimary
        } else {
            return .lableSecondary
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
                .font(.headline1)
                .frame(width: 24)
                .foregroundColor(.lableSecondary)
            Image(systemName: "cpu")
                .foregroundColor(.blue)
            Text(item.name)
                .font(.headline1)
                .frame(width: 120, alignment: .leading)
            Spacer()
            Text(valueText)
                .font(.headline2)
                .foregroundColor(valueColor)
        }
        .padding(.vertical, 8)
    }
}
