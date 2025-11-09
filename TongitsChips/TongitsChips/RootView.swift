//
//  RootView.swift
//  TongitsChips
//
//  Created by Christian Galang on 6/30/25.
//

import SwiftUI

struct RootView: View {
    
    @State private var currentScreen: Screen = .home
    @State private var settings = GameSettings()
    @State private var playerNames: [PlayerPosition: String] = [:]
    @State private var chipCounts: [PlayerPosition: Int] = [:]
    @State private var roundsWon: [PlayerPosition: Int] = [:]
    @State private var boughtBackIn: [PlayerPosition: Int] = [:]
    @State private var longestStreak: [PlayerPosition: Int] = [:]
    @StateObject private var historyManager = GameHistoryManager()
    
    var body: some View {
        
        ZStack {
                
            switch currentScreen {
            case .settings:
                
                SettingsView(
                    settings: $settings,
                    historyManager: historyManager,
                    onSave: {
                        currentScreen = .home
                    }
                )
                
            case .playerNames:
                
                PlayerNamesView(
                    onSubmit: { names in
                        playerNames = names
                        currentScreen = .game
                    },
                    onBack: {
                        currentScreen = .home
                    }
                )
                
            case .game:
                
                GameView(
                    settings: settings,
                    playerNames: playerNames,
                    onEndGame: { chipCounts, roundsWon, boughtBackIn in
                        self.chipCounts = chipCounts
                        self.roundsWon = roundsWon
                        self.boughtBackIn = boughtBackIn
                        
                        currentScreen = .summary
                    }
                )
                
            case .summary:
                
                SummaryView(
                    settings: settings,
                    playerNames: playerNames,
                    chipCounts: chipCounts,
                    roundsWon: roundsWon,
                    boughtBackIn: boughtBackIn,
                    onTap: { netChips in
                        
                        var players: [PlayerResult] = []
                        for player in PlayerPosition.allCases {
                            players.append(PlayerResult(name: playerNames[player]!, netChips: netChips[player]!))
                        }
                        
                        var winners: [String] = []
                        for player in netChips.keys.filter({ netChips[$0]! >= 0 }) {
                            winners.append(playerNames[player]!)
                        }
                        
                        let result = GameResult(
                            id: UUID(),
                            date: Date(),
                            winners: winners,
                            players: players,
                        )
                        
                        historyManager.addResult(result)
                        currentScreen = .home
                    }
                )
                
            case .home:
                
                HomeView(
                    startGame: {
                        currentScreen = .playerNames
                    },
                    openSettings: {
                        currentScreen = .settings
                    },
                    openHistory: {
                        currentScreen = .history
                    }
                )
                
            case .history:
                
                GameHistoryView(
                    historyManager: self.historyManager,
                    onBack: {
                        currentScreen = .home
                    }
                )
                
            }
            
            
        }
        .background(Color.white.ignoresSafeArea())
        
    }
}

enum Screen {
    case home, settings, playerNames, game, summary, history
}

#Preview {
    RootView()
}
