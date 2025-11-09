//
//  PlayerNamesView.swift
//  TongitsChips
//
//  Created by Christian Galang on 7/1/25.
//

import SwiftUI

struct PlayerNamesView: View {
    var onSubmit: ([PlayerPosition: String]) -> Void
    var onBack: () -> Void
    
    @State private var leftName = ""
    @State private var centerName = ""
    @State private var rightName = ""
    
    private var allNamesEntered: Bool {
        !leftName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !centerName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !rightName.trimmingCharacters(in: .whitespaces).isEmpty
    }
        
    var body: some View {
        
        ZStack {
            
            Button(action: { onBack() }) {
                Text("Back")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 80, height: 50)
                    .background(Color.black)
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            .padding(.bottom, 260)
            .padding(.leading, 600)
            .zIndex(1)
            
            VStack(spacing: 35) {
                
                Text("Enter Players' Names")
                    .font(.largeTitle)
                
                VStack(alignment: .trailing) {
                    
                    HStack {
                        Label("Player 1:", systemImage: "arrow.down")
                        TextField("", text: $centerName)
                            .padding(.all, 5)
                            .frame(width: 200)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                    .font(.title2)
                    
                    HStack {
                        Label("Player 2:", systemImage: "arrow.right")
                        TextField("", text: $rightName)
                            .padding(.all, 5)
                            .frame(width: 200)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                    .font(.title2)
                    
                    HStack {
                        Label("Player 3:", systemImage: "arrow.left")
                        TextField("", text: $leftName)
                            .padding(.all, 5)
                            .frame(width: 200)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                    .font(.title2)
                    
                }
                
                Button(
                    action: {
                        onSubmit([
                            .left: leftName,
                            .center: centerName,
                            .right: rightName
                        ])
                    }
                ) {
                    Text("Start Game")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 250, height: 70)
                        .background(Color.black)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .disabled(!allNamesEntered)
                .opacity(allNamesEntered ? 1.0 : 0.5)
                
            }
            .padding(.top, 20)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

#Preview {
    PlayerNamesView(onSubmit: { _ in }, onBack: {})
}
