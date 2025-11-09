//
//  DealResponse.swift
//  TongitsChips
//
//  Created by Christian Galang on 6/30/25.
//

import Foundation

enum DealResponse: CaseIterable, Hashable {
    case challenge
    case fold
    case burn
    
    var displayChoiceText: String {
        switch self {
        case .challenge: return "Challenge"
        case .fold: return "Fold"
        case .burn: return "Burn"
        }
    }
    
    var displayDecisionText: String {
        switch self {
        case .challenge: return "I Lost"
        case .fold: return "Folded"
        case .burn: return "Burned"
        }
    }
}
