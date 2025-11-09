//
//  LoserInputView.swift
//  TongitsChips
//
//  Created by Christian Galang on 7/4/25.
//

import SwiftUI

struct LoserInputView: View {
    var losers: [PlayerPosition: String]
    var onSubmit: ([PlayerPosition: Int]) -> Void
    
    @State private var pointInputs: [PlayerPosition: String] = [:]
    @FocusState private var focusedField: PlayerPosition?
    
    private var allFieldsEntered: Bool {
        losers.keys.allSatisfy { !(pointInputs[$0]?.trimmingCharacters(in: .whitespaces).isEmpty ?? true) }
    }
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Text("Losers' Total Points")
                .font(.title)
            
            VStack(alignment: .trailing) {
                
                ForEach(Array(losers.keys), id: \.self) { player in
                    HStack {
                        Label("\(losers[player] ?? "Player")", systemImage: player.directionArrow)
                        TextField("", text: Binding(
                            get: { pointInputs[player, default: ""] },
                            set: { pointInputs[player] = $0 })
                        )
                        .padding(.all, 3)
                        .frame(width: 80)
                        .keyboardType(.numberPad)
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .focused($focusedField, equals: player)
                    }
                }
                
            }
            
            Button(
                action: {
                    var result: [PlayerPosition: Int] = [:]
                    for (player, text) in pointInputs {
                        if let points = Int(text) {
                            result[player] = points
                        }
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
            .disabled(!allFieldsEntered)
            .opacity(allFieldsEntered ? 1 : 0.5)
            
        }
        .frame(width: 260, height: 200)
        .padding()
        .background(.ultraThickMaterial)
        .cornerRadius(15)
        .shadow(radius: 5)
        .onAppear {
            if let first = losers.keys.first {
                focusedField = first
            }
        }
        
    }
}

#Preview {
    LoserInputView(
        losers: [.left: "Dad"],
        onSubmit: { _ in }
    )
}
