//
//  RowView.swift
//  Public Opinion for Stock
//
//  Created by Jacob on 6/3/25.
//

import SwiftUI

struct RowView: View {
    let index: Int
    let item: MainRowItem

    var valueColor: Color {
        if item.score > 0 {
            return .redPrimary
        } else if item.score < 0 {
            return .bluePrimary
        } else {
            return .lableSecondary
        }
    }

    var valueText: String {
        if item.score > 0 {
            return "+\(item.score)"
        } else if item.score < 0 {
            return "\(item.score)"
        } else {
            return "0"
        }
    }

    var body: some View {
        HStack {
            Text("\(index + 1)")
                .font(.headline1)
                .frame(width: 24, alignment: .center)
                .foregroundColor(.lableSecondary)
            Image(systemName: "cpu")
                .foregroundColor(.blue)
            
            Text(item.sector)
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
