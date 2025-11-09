//
//  LoserButtonView.swift
//  TongitsChips
//
//  Created by Christian Galang on 7/3/25.
//

import SwiftUI

struct LoserButtonView: View {
    var position: PlayerPosition
    var decision: DealResponse
    
    var body: some View {
        
        Button(action: {}) {
            Text(decision.displayDecisionText)
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(
                    width: position == .center ? 340 : 300,
                    height: position == .center ? 120 : 150
                )
                .background(Color.black)
                .cornerRadius(15)
                .shadow(radius: 5)
                .rotationEffect(.degrees(position.displayAngle))
        }
        .disabled(true)
        .opacity(0.5)
        
    }
}

#Preview {
    LoserButtonView(position: .center, decision: .challenge)
}
