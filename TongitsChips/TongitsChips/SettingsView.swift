//
//  SettingsView.swift
//  TongitsChips
//
//  Created by Christian Galang on 6/27/25.
//

import SwiftUI
import Combine

struct SettingsView: View {
    @Binding var settings: GameSettings
    var historyManager: GameHistoryManager
    var onSave: () -> Void
    
    @State private var startingChipAmount = ""
    @State private var tongitsWinAmount = ""
    @State private var dealWinAmount = ""
    @State private var simpleWinAmount = ""
    @State private var burnPenalty = ""
    @State private var startingPotContribution = ""
    @State private var potIncrement = ""
    
    @State private var showClearHistoryAlert = false
    @FocusState private var isInputActive: Bool
    
    private var allSettingsEntered: Bool {
        !startingChipAmount.trimmingCharacters(in: .whitespaces).isEmpty &&
        !tongitsWinAmount.trimmingCharacters(in: .whitespaces).isEmpty &&
        !dealWinAmount.trimmingCharacters(in: .whitespaces).isEmpty &&
        !simpleWinAmount.trimmingCharacters(in: .whitespaces).isEmpty &&
        !burnPenalty.trimmingCharacters(in: .whitespaces).isEmpty &&
        !startingPotContribution.trimmingCharacters(in: .whitespaces).isEmpty &&
        !potIncrement.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        
        ZStack {
            
            Button(
                action: {
                    settings.startingChipAmount = Int(startingChipAmount) ?? 100
                    settings.tongitsWinAmount = Int(tongitsWinAmount) ?? 5
                    settings.dealWinAmount = Int(dealWinAmount) ?? 5
                    settings.simpleWinAmount = Int(simpleWinAmount) ?? 3
                    settings.burnPenalty = Int(burnPenalty) ?? 0
                    settings.startingPotContribution = Int(startingPotContribution) ?? 3
                    settings.potIncrement = Int(potIncrement) ?? 1
                    onSave()
                }
            ) {
                Text("Save")
                    .font(.headline)
                    .frame(width: 80, height: 50)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            .padding(.leading, 600)
            .padding(.bottom, 240)
            .disabled(!allSettingsEntered)
            .opacity(allSettingsEntered ? 1.0 : 0.5)
            
            VStack(spacing: 25) {
                
                Text("Settings")
                    .font(.largeTitle)
                
                HStack(spacing: 40) {
                    
                    VStack(alignment: .trailing) {
                        
                        HStack {
                            
                            Text("Starting Chip Amount:")
                            TextField("", text: $startingChipAmount)
                                .padding(.all, 5)
                                .frame(width: 80)
                                .keyboardType(.numberPad)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .focused($isInputActive)
                            
                        }
                        
                        HStack {
                            
                            Text("Tongits Win Amount:")
                            TextField("", text: $tongitsWinAmount)
                                .padding(.all, 5)
                                .frame(width: 80)
                                .keyboardType(.numberPad)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .focused($isInputActive)
                            
                        }
                        
                        HStack {
                            
                            Text("Deal Win Amount:")
                            TextField("", text: $dealWinAmount)
                                .padding(.all, 5)
                                .frame(width: 80)
                                .keyboardType(.numberPad)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .focused($isInputActive)
                            
                        }
                        
                        HStack {
                            
                            Text("Simple Win Amount:")
                            TextField("", text: $simpleWinAmount)
                                .padding(.all, 5)
                                .frame(width: 80)
                                .keyboardType(.numberPad)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .focused($isInputActive)
                            
                        }
                        
                    }
                    
                    VStack(alignment: .trailing) {
                        
                        HStack {
                            
                            Text("Burn Penalty:")
                            TextField("", text: $burnPenalty)
                                .padding(.all, 5)
                                .frame(width: 80)
                                .keyboardType(.numberPad)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .focused($isInputActive)
                            
                        }
                        
                        HStack {
                            
                            Text("Starting Pot Contribution:")
                            TextField("", text: $startingPotContribution)
                                .padding(.all, 5)
                                .frame(width: 80)
                                .keyboardType(.numberPad)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .focused($isInputActive)
                            
                        }
                        
                        HStack {
                            
                            Text("Pot Increment:")
                            TextField("", text: $potIncrement)
                                .padding(.all, 5)
                                .frame(width: 80)
                                .keyboardType(.numberPad)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .focused($isInputActive)
                            
                        }
                        
                    }
                    
                }
                .font(.title2)
                
                Button(
                    action: {
                        showClearHistoryAlert = true
                    }
                ) {
                    Text("Clear History")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(Color.red)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                
            }
            .padding(.top, 20)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            isInputActive = false
        }
        .onAppear {
            startingChipAmount = String(settings.startingChipAmount)
            tongitsWinAmount = String(settings.tongitsWinAmount)
            dealWinAmount = String(settings.dealWinAmount)
            simpleWinAmount = String(settings.simpleWinAmount)
            burnPenalty = String(settings.burnPenalty)
            startingPotContribution = String(settings.startingPotContribution)
            potIncrement = String(settings.potIncrement)
        }
        .alert("Are you sure you want to clear all game history?", isPresented: $showClearHistoryAlert) {
            Button("Clear History", role: .destructive) {
                historyManager.clearHistory()
            }
            Button("Cancel", role: .cancel) {}
        }
        
    }
}

#Preview {
    let mockManager = GameHistoryManager()
    SettingsView(
        settings: .constant(GameSettings()),
        historyManager: mockManager,
        onSave: {}
    )
}
