//
//  GameHistoryManager.swift
//  TongitsChips
//
//  Created by Christian Galang on 7/6/25.
//

import Foundation

class GameHistoryManager: ObservableObject {
    @Published var history: [GameResult] = []
    
    private let filename = "game_history.json"
    
    init() {
        loadHistory()
    }
    
    func addResult(_ result: GameResult) {
        history.append(result)
        saveHistory()
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private func saveHistory() {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let data = try JSONEncoder().encode(history)
            try data.write(to: url)
        } catch {
            print("Error saving game history:", error)
        }
    }
    
    private func loadHistory() {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let data = try Data(contentsOf: url)
            history = try JSONDecoder().decode([GameResult].self, from: data)
        } catch {
            print("No previous history or failed to load:", error)
        }
    }
    
    func clearHistory() {
        history = []
        saveHistory()
    }
}

struct GameResult: Codable, Identifiable {
    var id: UUID
    let date: Date
    let winners: [String]
    let players: [PlayerResult]
}

struct PlayerResult: Codable {
    let name: String
    let netChips: Int
}
