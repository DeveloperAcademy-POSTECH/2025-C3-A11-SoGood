//
//  Item.swift
//  Public Opinion for Stock
//
//  Created by 유승재 on 5/29/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
