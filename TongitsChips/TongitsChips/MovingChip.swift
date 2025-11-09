//
//  MovingChip.swift
//  TongitsChips
//
//  Created by Christian Galang on 7/5/25.
//

import SwiftUI

struct MovingChip: Identifiable {
    let id = UUID()
    var position: CGPoint
    var count: Int
}
