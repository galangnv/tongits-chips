//
//  LeftPlayerChipsView.swift
//  TongitsChips
//
//  Created by Christian Galang on 6/28/25.
//

import SwiftUI

struct PlayerChipsView: View {
    var chipCount: Int
    var position: PlayerPosition
    var isTwoHits: Bool
    
    var body: some View {
        
        ZStack {
            
            if isTwoHits {
                Image("two-hits-marker")
                    .resizable()
                    .frame(width: 150, height: 120)
                    .rotationEffect(.degrees(position.displayAngle))
                    .zIndex(-1)
            }
            
            Circle()
                .fill(Color.white)
                .frame(width: 70, height: 70)
                .overlay(Circle().stroke(Color.black, lineWidth: 1.8))
            
            Text("\(chipCount)")
                .font(.title)
                .foregroundColor(.black)
                .rotationEffect(.degrees(position.displayAngle))
            
        }
        
    }
}

#Preview {
    PlayerChipsView(chipCount: 97, position: .center, isTwoHits: true)
}
