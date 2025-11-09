//
//  DealButtonView.swift
//  TongitsChips
//
//  Created by Christian Galang on 7/3/25.
//

import SwiftUI

struct DealButtonView: View {
    var position: PlayerPosition
    var onDeal: () -> Void
    
    var body: some View {
        
        Button(action: { onDeal() }) {
            Text("Deal")
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
        
    }
}

#Preview {
    DealButtonView(position: .center, onDeal: {})
}
