//
//  ContentView.swift
//  TongitsChips
//
//  Created by Christian Galang on 6/27/25.
//

import SwiftUI

struct HomeView: View {
    
    var startGame: () -> Void
    var openSettings: () -> Void
    var openHistory: () -> Void
    
    var body: some View {
        
            ZStack {
                
                Text("Tongits Chips")
                    .font(.system(size: 48, weight: .heavy))
                    .offset(x: 0, y: -60)
                
                Button(action: startGame) {
                    Text("Start")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 120)
                        .background(Color.black)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .padding(.top, 240)
                
                Button(action: openSettings) {
                    Text("Settings")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 300)
                        .background(Color.black)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .padding(.leading, 600)
                
                Button(action: openHistory) {
                    Text("Game History")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 300)
                        .background(Color.black)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .padding(.trailing, 600)
                
            }
            
    }
}

#Preview {
    HomeView(startGame: {}, openSettings: {}, openHistory: {})
}
