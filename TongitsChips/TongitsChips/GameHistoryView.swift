//
//  GameHistoryView.swift
//  TongitsChips
//
//  Created by Christian Galang on 7/9/25.
//

import SwiftUI

struct GameHistoryView: View {
    @ObservedObject var historyManager: GameHistoryManager
    var onBack: () -> Void
    
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
            
            VStack {
                
                Text("Game History")
                    .font(.title)
                
                if historyManager.history.isEmpty {
                    Text("No game history yet.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(historyManager.history.reversed()) { game in
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("Date: \(game.date.formatted(date: .abbreviated, time: .shortened))")
                                .font(.headline)
                            
                            if !game.winners.isEmpty {
                                Text("Winner\(game.winners.count > 1 ? "s" : ""): \(game.winners.joined(separator: ", "))")
                                    .font(.subheadline)
                            }
                            
                            ForEach(game.players, id: \.name) { player in
                                HStack(spacing: 50) {
                                    Text(player.name)
                                    Spacer()
                                    Text("\(player.netChips >= 0 ? "+" : "")\(player.netChips) chips")
                                        .foregroundColor(player.netChips >= 0 ? .green: .red)
                                }
                                .font(.caption)
                            }
                            
                        }
                        
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                }
                
            }
            .padding(.top, 40)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        
    }
}

#Preview {
    let mockManager = GameHistoryManager()
    
    GameHistoryView(historyManager: mockManager, onBack: {})
}
