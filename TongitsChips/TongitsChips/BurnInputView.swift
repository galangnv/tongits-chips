//
//  BurnInputView.swift
//  TongitsChips
//
//  Created by Christian Galang on 7/5/25.
//

import SwiftUI

struct BurnInputView: View {
    var losers: [PlayerPosition: String]
    var onSubmit: ([PlayerPosition: Bool]) -> Void
    
    @State private var burnInputs: [PlayerPosition: Bool] = [:]
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Text("Did You Burn?")
                .font(.title)
            
            VStack(alignment: .trailing) {
                
                ForEach(Array(losers.keys), id: \.self) { player in
                    HStack() {
                        Label("\(losers[player] ?? "Player"):", systemImage: player.directionArrow)
                        Toggle("", isOn: Binding(
                            get: { burnInputs[player, default: false] },
                            set: { burnInputs[player] = $0 }
                        ))
                        .labelsHidden()
                        .frame(alignment: .leading)
                    }
                }
                
            }
            
            Button(
                action: {
                    var result: [PlayerPosition: Bool] = [:]
                    for (player, choice) in burnInputs {
                        result[player] = choice
                    }
                    onSubmit(result)
                }
            ) {
                Text("Done")
                    .foregroundColor(.white)
                    .frame(width: 120, height: 50)
                    .background(Color.black)
                    .cornerRadius(5)
            }
            
        }
        .frame(width: 260, height: 200)
        .padding()
        .background(.ultraThickMaterial)
        .cornerRadius(15)
        .shadow(radius: 5)
        
    }
}

#Preview {
    BurnInputView(
        losers: [.left: "Dad", .right: "Mom"],
        onSubmit: { _ in }
    )
}
