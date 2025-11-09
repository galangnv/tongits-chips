//
//  Item.swift
//  TongitsChips
//
//  Created by Christian Galang on 6/27/25.
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
