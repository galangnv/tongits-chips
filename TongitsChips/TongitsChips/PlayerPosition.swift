//
//  PlayerPosition.swift
//  TongitsChips
//
//  Created by Christian Galang on 6/28/25.
//

import Foundation

enum PlayerPosition: String, CaseIterable, Identifiable, Hashable {
    case left, center, right
    
    var id: String { rawValue }
    
    var displayAngle: Double {
        switch self {
        case .left: return 90
        case .center: return 0
        case .right: return -90
        }
    }
    
    var directionArrow: String {
        switch self {
        case .left: return "arrow.left"
        case .center: return "arrow.down"
        case .right: return "arrow.right"
        }
    }
}
