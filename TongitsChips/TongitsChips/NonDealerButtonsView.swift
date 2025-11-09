//
//  ChallengerButtonsView.swift
//  TongitsChips
//
//  Created by Christian Galang on 6/30/25.
//

import SwiftUI

struct NonDealerButtonsView: View {
    var position: PlayerPosition
    var onRespond: (DealResponse) -> Void
    var selectedResponse: DealResponse?
    
    var body: some View {
        
        HStack {
            
            ForEach(DealResponse.allCases, id: \.self) { responseType in
                Button(action: { onRespond(responseType) }) {
                    Text(responseType.displayChoiceText)
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(
                            width: position == .center ? 110 : 100,
                            height: position == .center ? 120 : 150
                        )
                        .background(Color.black)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .opacity(selectedResponse == nil || selectedResponse == responseType ? 1.0 : 0.5)
                }
            }
            
        }
        .rotationEffect(.degrees(position.displayAngle))
        
    }
}

#Preview {
    NonDealerButtonsView(position: .center, onRespond: { _ in }, selectedResponse: nil)
}
