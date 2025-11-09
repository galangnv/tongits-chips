//
//  SummaryView.swift
//  TongitsChips
//
//  Created by Christian Galang on 6/28/25.
//

import SwiftUI

struct SummaryView: View {
    var settings: GameSettings
    var playerNames: [PlayerPosition: String]
    var chipCounts: [PlayerPosition: Int]
    var roundsWon: [PlayerPosition: Int]
    var boughtBackIn: [PlayerPosition: Int]
    var onTap: ([PlayerPosition: Int]) -> Void
    
    var netChips: [PlayerPosition: Int] {
        var chips: [PlayerPosition: Int] = [:]
        for player in PlayerPosition.allCases {
            let buyBackChips = boughtBackIn[player]! * settings.startingChipAmount
            let net = chipCounts[player]! - buyBackChips - settings.startingChipAmount
            chips[player] = net
        }
        return chips
    }
    
    var body: some View {
        
        ZStack {
            
            HStack {
                
                VStack(spacing: 40) {
                    
                    Label("\(playerNames[.left]!)", systemImage: "arrow.left")
                        .font(.title)
                    
                    VStack {
                        
                        Text("Remaining Chips: \(chipCounts[.left]!)")
                        Text("# of Times Bought Back In: \(boughtBackIn[.left]!)")
                        Text("# of Rounds Won: \(roundsWon[.left]!)")
                        
                    }
                    
                    if netChips[.left]! >= 0 {
                        Text("You won \(netChips[.left]!) chips.")
                    } else {
                        Text("You lost \(-netChips[.left]!) chips.")
                    }
                    
                }
                .frame(maxWidth: .infinity)
                
                Rectangle()
                    .frame(width: 2)
                    .padding(.vertical, 8)
                
                VStack(spacing: 40) {
                    
                    Label("\(playerNames[.center]!)", systemImage: "arrow.down")
                        .font(.title)
                    
                    VStack {
                        
                        Text("Remaining Chips: \(chipCounts[.center]!)")
                        Text("# of Times Bought Back In: \(boughtBackIn[.center]!)")
                        Text("# of Rounds Won: \(roundsWon[.center]!)")
                        
                    }
                    
                    if netChips[.center]! >= 0 {
                        Text("You won \(netChips[.center]!) chips.")
                    } else {
                        Text("You lost \(-netChips[.center]!) chips.")
                    }
                    
                }
                .frame(maxWidth: .infinity)
                
                Rectangle()
                    .frame(width: 2)
                    .padding(.vertical, 8)
                
                VStack(spacing: 40) {
                    
                    Label("\(playerNames[.right]!)", systemImage: "arrow.right")
                        .font(.title)
                    
                    VStack {
                        
                        Text("Remaining Chips: \(chipCounts[.right]!)")
                        Text("# of Times Bought Back In: \(boughtBackIn[.right]!)")
                        Text("# of Rounds Won: \(roundsWon[.right]!)")
                        
                    }
                    
                    if netChips[.right]! >= 0 {
                        Text("You won \(netChips[.right]!) chips.")
                    } else {
                        Text("You lost \(-netChips[.right]!) chips.")
                    }
                    
                }
                .frame(maxWidth: .infinity)
                
            }
            
            Button(
                action: {
                    onTap(netChips)
                }
            ) {
                Image(systemName: "house")
                    .resizable()
                    .scaledToFit()
                    .padding(.all, 8)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(15.0)
                    .shadow(radius: 5)
            }
            .padding(.leading, 700.0)
            .padding(.top, 300.0)
        }
        
    }
}

#Preview {
    SummaryView(
        settings: GameSettings(),
        playerNames: [
            .left: "EM-J",
            .center: "Christian",
            .right: "Plum"
        ],
        chipCounts: [
            .left: 79,
            .center: 155,
            .right: 66
        ],
        roundsWon: [
            .left: 6,
            .center: 12,
            .right: 4
        ],
        boughtBackIn: [
            .left: 0,
            .center: 0,
            .right: 0
        ],
        onTap: { _ in }
    )
}
