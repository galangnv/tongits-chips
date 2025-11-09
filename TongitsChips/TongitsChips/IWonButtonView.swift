//
//  IWonButtonView.swift
//  TongitsChips
//
//  Created by Christian Galang on 7/3/25.
//

import SwiftUI

struct IWonButtonView: View {
    var position: PlayerPosition
    var onTap: () -> Void
    
    var body: some View {
        
        Button(action: { onTap() }) {
            Text("I Won")
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
    IWonButtonView(position: .center, onTap: {})
}
