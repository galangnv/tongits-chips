//
//  PlayerButtonPadding.swift
//  TongitsChips
//
//  Created by Christian Galang on 7/2/25.
//

import SwiftUI

struct PlayerButtonPadding: ViewModifier {
    let player: PlayerPosition
    
    init(for player: PlayerPosition) {
        self.player = player
    }
    
    func body(content: Content) -> some View {
        switch player {
        case .left: content.padding(.trailing, 600)
        case .right: content.padding(.leading, 600)
        case.center: content.padding(.top, 240)
        }
    }
}

extension View {
    func playerButtonPadding(for player: PlayerPosition) -> some View {
        modifier(PlayerButtonPadding(for: player))
    }
}
