//
//  RowItem_test.swift
//  Public Opinion for Stock
//
//  Created by Jacob on 6/3/25.
//

import Foundation

struct RowItem: Identifiable {
    let id = UUID()
    let name: String
    let value: Int
    let iconName: String
}

