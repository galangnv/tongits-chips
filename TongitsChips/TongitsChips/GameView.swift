//
//  GameView.swift
//  TongitsChips
//
//  Created by Christian Galang on 6/28/25.
//

import SwiftUI

struct GameView: View {
    
    var settings: GameSettings
    var playerNames: [PlayerPosition: String]
    var onEndGame: ([PlayerPosition: Int], [PlayerPosition: Int], [PlayerPosition: Int]) -> Void
    
    
    @State private var chipCounts: [PlayerPosition: Int] = [:]
    @State private var potAmount: Int = 0
    @State private var roundsWon: [PlayerPosition: Int] = [:]
    @State private var twoHitsPlayer: PlayerPosition? = nil
    @State private var numRounds: Int = 0
    @State private var boughtBackIn: [PlayerPosition: Int] = [:]
    
    @State private var prevChipCounts: [PlayerPosition: Int] = [:]
    @State private var prevPotAmount: Int = 0
    @State private var prevRoundsWon: [PlayerPosition: Int] = [:]
    @State private var prevTwoHitsPlayer: PlayerPosition? = nil
    @State private var prevBoughtBackIn: [PlayerPosition: Int] = [:]
    
    @State private var nonDealerResponses: [PlayerPosition: DealResponse] = [:]
    @State private var playerPoints: [PlayerPosition: Int] = [:]
    @State private var winnerAces: Int = 0
    
    @State private var dealer: PlayerPosition? = nil
    @State private var nonDealers: [PlayerPosition] = []
    @State private var promptingNonDealer: PlayerPosition? = nil
    @State private var simpleLosers: [PlayerPosition] = []
    @State private var losersToAsk: [PlayerPosition: String] = [:]
    @State private var winner: PlayerPosition? = nil
    
    @State private var currentInputState: ScreenState = .deal
    @State private var winType: WinType? = nil
    @State private var chipTransfers: [(from: PlayerPosition, to: PlayerPosition, amount: Int)] = []
    
    @State private var wrongWinnerAlertMessage: String = ""
    @State private var showWrongWinnerAlert: Bool = false
    
    @StateObject private var shakeDetector = ShakeDetector()
    @State private var showRestartRoundAlert: Bool = false
    @State private var showRestartPrevRoundAlert: Bool = false
    
    @State private var showEndGameAlert: Bool = false
    
    @State private var playersThatCantPayWinner: [PlayerPosition] = []
    @State private var playersThatCantPayPot: [PlayerPosition] = []
    @State private var showOutOfChipsAlert: Bool = false
    
    @State private var animatedChips: [MovingChip] = []
    @State private var disableWhileAnimating: Bool = false
    
    init(
        settings: GameSettings,
        playerNames: [PlayerPosition: String],
        onEndGame: @escaping ([PlayerPosition: Int], [PlayerPosition: Int], [PlayerPosition: Int]) -> Void
    ) {
        self.settings = settings
        self.playerNames = playerNames
        self.onEndGame = onEndGame
        
        _chipCounts = State(initialValue: [
            .left: settings.startingChipAmount,
            .center: settings.startingChipAmount,
            .right: settings.startingChipAmount
        ])
        
        _roundsWon = State(initialValue: [
            .left: 0,
            .center: 0,
            .right: 0
        ])
        
        _boughtBackIn = State(initialValue: [
            .left: 0,
            .center: 0,
            .right: 0
        ])
    }
    
    var body: some View {
        
        ZStack {
            
            // ********** TOP TOOLBAR **********
            
            HStack {
                
                Button(
                    action: {
                        winType = .spread
                        currentInputState = .selectWinner
                    }
                ) {
                    Text("Spread")
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(width: 100, height: 60)
                        .background(Color.black)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    
                }
                .disabled(disableWhileAnimating)
                
                Button(
                    action: {
                        winType = .tongits
                        currentInputState = .selectWinner
                    }
                ) {
                    Text("Tongits")
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(width: 100, height: 60)
                        .background(Color.black)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .disabled(disableWhileAnimating)
                
                Button(
                    action: {
                        winType = .noDeal
                        currentInputState = .selectWinner
                    }
                ) {
                    Text("No Deal")
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(width: 100, height: 60)
                        .background(Color.black)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .disabled(disableWhileAnimating)
                
                Button(
                    action: {
                        showEndGameAlert = true
                    }
                ) {
                    Text("End Game")
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(width: 100, height: 60)
                        .background(Color.black)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .disabled(disableWhileAnimating)
                
            }
            .padding(.bottom, 340.0)
            .disabled(currentInputState != .deal)
            .opacity(currentInputState == .deal ? 1.0 : 0.5)
            
            // ********** CENTER OF SCREEN **********
            
            if currentInputState == .selectWinner {
                switch winType {
                case .tongits:
                    
                    Text("Who Won\nWith Tongits?")
                        .font(.system(size: 48))
                        .multilineTextAlignment(.center)
                        .offset(x: 0, y: -60)
                    
                case .spread:
                    
                    Text("Who Won\nWith A Spread?")
                        .font(.system(size: 48))
                        .multilineTextAlignment(.center)
                        .offset(x: 0, y: -60)
                    
                case .noDeal:
                    
                    Text("Who Won?")
                        .font(.system(size: 48))
                        .offset(x: 0, y: -60)
                    
                case .deal:
                    
                    Text("Who Won\nThe Deal?")
                        .font(.system(size: 48))
                        .multilineTextAlignment(.center)
                        .offset(x: 0, y: -60)
                    
                case .none:
                    
                    PotView(potCount: potAmount)
                        .offset(x: 0, y: -60)
                    
                }
            } else {
                PotView(potCount: potAmount)
                    .offset(x: 0, y: -60)
            }
            
            // ********** PLAYER BUTTONS **********
            
            switch currentInputState {
                
            case .deal:
                
                ForEach(PlayerPosition.allCases) { player in
                    DealButtonView(
                        position: player,
                        onDeal: {
                            handleDeal(dealer: player)
                        }
                    )
                    .playerButtonPadding(for: player)
                    .disabled(disableWhileAnimating)
                }
                
            case .dealResponses:
                
                ForEach(PlayerPosition.allCases) { player in
                    if dealer == player {
                        DealButtonView(position: player, onDeal: {})
                            .disabled(true)
                            .opacity(0.5)
                            .playerButtonPadding(for: player)
                    } else {
                        NonDealerButtonsView(
                            position: player,
                            onRespond: { response in
                                respondToDeal(from: player, response: response)
                            },
                            selectedResponse: nonDealerResponses[player]
                        )
                        .disabled(promptingNonDealer != player)
                        .opacity(promptingNonDealer != player ? 0.5 : 1.0)
                        .playerButtonPadding(for: player)
                    }
                }
                
            case .selectWinner:
                
                if winType == .deal {
                    
                    ForEach(PlayerPosition.allCases) { player in
                        if dealer == player || nonDealerResponses[player] == .challenge {
                            IWonButtonView(
                                position: player,
                                onTap: {
                                    handleWinnerSelected(winner: player)
                                }
                            )
                            .playerButtonPadding(for: player)
                        } else {
                            LoserButtonView(position: player, decision: nonDealerResponses[player] ?? .fold)
                                .playerButtonPadding(for: player)
                        }
                    }
                    
                } else {
                    
                    ForEach(PlayerPosition.allCases) { player in
                        IWonButtonView(
                            position: player,
                            onTap: {
                                handleWinnerSelected(winner: player)
                            }
                        )
                        .playerButtonPadding(for: player)
                    }
                    
                }
                
            case .winnerInfo:
                
                ForEach(PlayerPosition.allCases) { player in
                    if winner == player {
                        IWonButtonView(position: player, onTap: {})
                            .playerButtonPadding(for: player)
                            .disabled(true)
                            .opacity(0.5)
                    } else {
                        LoserButtonView(position: player, decision: nonDealerResponses[player] ?? .challenge)
                            .playerButtonPadding(for: player)
                    }
                }
                
                WinnerInputView(
                    name: playerNames[winner!, default: "Player"],
                    position: winner!,
                    isSimple: winType == .noDeal || (winType == .deal && losersToAsk.count == 0),
                    onSubmit: { points, aces in
                        playerPoints[winner!] = points
                        winnerAces = aces
                        if losersToAsk.count > 0 {
                            if winType == .noDeal {
                                currentInputState = .burnInfo
                            } else {
                                currentInputState = .loserInfo
                            }
                        } else {
                            handleChipTransfers()
                        }
                    }
                )
                .zIndex(2)
                
            case .loserInfo:
                
                ForEach(PlayerPosition.allCases) { player in
                    if winner == player {
                        IWonButtonView(position: player, onTap: {})
                            .playerButtonPadding(for: player)
                            .disabled(true)
                            .opacity(0.5)
                    } else {
                        LoserButtonView(position: player, decision: nonDealerResponses[player] ?? .challenge)
                            .playerButtonPadding(for: player)
                    }
                }
                
                LoserInputView(
                    losers: losersToAsk,
                    onSubmit: { pointInputs in
                        for (player, points) in pointInputs {
                            playerPoints[player] = points
                        }
                        if winnerSelectedCorrectly() {
                            handleChipTransfers()
                        } else {
                            playerPoints = [:]
                            winnerAces = 0
                            losersToAsk = [:]
                            winner = nil
                            currentInputState = .selectWinner
                        }
                    }
                )
                .zIndex(2)
                
            case .burnInfo:
                
                ForEach(PlayerPosition.allCases) { player in
                    if winner == player {
                        IWonButtonView(position: player, onTap: {})
                            .playerButtonPadding(for: player)
                            .disabled(true)
                            .opacity(0.5)
                    } else {
                        LoserButtonView(position: player, decision: nonDealerResponses[player] ?? .challenge)
                            .playerButtonPadding(for: player)
                    }
                }
                
                BurnInputView(
                    losers: losersToAsk,
                    onSubmit: { burnInputs in
                        for (player, choice) in burnInputs {
                            if choice {
                                nonDealerResponses[player] = .burn
                            }
                        }
                        handleChipTransfers()
                    }
                )
                .zIndex(2)
                
            }
            
            // ********** PLAYERS CHIP COUNTS **********
            
            PlayerChipsView(chipCount: chipCounts[.center] ?? -101, position: .center, isTwoHits: twoHitsPlayer == .center)
                .offset(x: -100, y: 50)
                .zIndex(1)
            
            PlayerChipsView(chipCount: chipCounts[.right] ?? -101, position: .right, isTwoHits: twoHitsPlayer == .right)
                .offset(x: 210, y: -90)
                .zIndex(1)
            
            PlayerChipsView(chipCount: chipCounts[.left] ?? -101, position: .left, isTwoHits: twoHitsPlayer == .left)
                .offset(x: -210, y: -90)
                .zIndex(1)
            
            ForEach(animatedChips) { chip in
                PlayerChipsView(chipCount: chip.count, position: .center, isTwoHits: false)
                    .position(chip.position)
                    .zIndex(2)
            }
            
            // ********** PLAYERS NAMES **********
            
            Text(playerNames[.center] ?? "Player 1")
                .font(.body)
                .offset(x: 80, y: 45)
            
            Text(playerNames[.right] ?? "Player 2")
                .font(.body)
                .offset(x: -70, y: 210)
                .rotationEffect(.degrees(270.0))
            
            Text(playerNames[.left] ?? "Player 3")
                .font(.body)
                .offset(x: 70, y: 210)
                .rotationEffect(.degrees(90.0))
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            disableWhileAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                potAmount += settings.startingPotContribution * 3
                disableWhileAnimating = false
            }
            for player in PlayerPosition.allCases {
                chipCounts[player]! -= settings.startingPotContribution
                animatePotTransfer(player: player, count: settings.startingPotContribution, isTwoHits: false)
            }
        }
        .alert(wrongWinnerAlertMessage, isPresented: $showWrongWinnerAlert) {
            Button("Okay", role: .cancel) {}
        }
        .onReceive(shakeDetector.$didShake) { didShake in
            if didShake {
                if currentInputState == .deal {
                    if numRounds > 0 {
                        showRestartPrevRoundAlert = true
                        shakeDetector.didShake = false
                    }
                } else {
                    showRestartRoundAlert = true
                    shakeDetector.didShake = false
                }
            }
        }
        .alert("Restart round?", isPresented: $showRestartRoundAlert) {
            Button("Restart", role: .destructive) {
                restartRound()
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Restart previous round?", isPresented: $showRestartPrevRoundAlert) {
            Button("Restart", role: .destructive) {
                restartPrevRound()
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Are you sure you want to end the game? (Pot will be split amongst players)", isPresented: $showEndGameAlert) {
            Button("End Game", role: .destructive) {
                handleEndGame()
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("At least one player is out of money. Buy back in or end game?", isPresented: $showOutOfChipsAlert) {
            Button("End Game", role: .destructive) {
                handleEndGame()
            }
            Button("Buy Back In", role: .cancel) {
                handleBuyBackIn()
            }
        } message: {
            Text("All chip transfers, including two-hits if necessary, will be completed before ending game. Pot will be split amongst players.")
        }
        
    }
    
    private func nextPlayer(after player: PlayerPosition) -> PlayerPosition {
        switch player {
        case .left: return .center
        case .center: return .right
        case .right: return .left
        }
    }
    
    private func handleDeal(dealer: PlayerPosition) {
        self.dealer = dealer
        nonDealers = PlayerPosition.allCases.filter { $0 != dealer }
        promptingNonDealer = nextPlayer(after: dealer)
        winType = .deal
        
        currentInputState = .dealResponses
    }
    
    private func respondToDeal(from player: PlayerPosition, response: DealResponse) {
        nonDealerResponses[player] = response
        if response != .challenge {
            simpleLosers.append(player)
        }
        let remaining = nonDealers.filter { nonDealerResponses[$0] == nil }
        
        if let next = remaining.first {
            promptingNonDealer = next
        } else {
            promptingNonDealer = nil
            if !nonDealerResponses.values.contains(.challenge) {
                winner = dealer
                currentInputState = .winnerInfo
            } else {
                currentInputState = .selectWinner
            }
        }
    }
    
    private func handleWinnerSelected(winner: PlayerPosition) {
        self.winner = winner
        
        switch winType {
        case .tongits:
            
            if settings.burnPenalty > 0 {
                losersToAsk = playerNames.filter { $0.key != winner }
                currentInputState = .burnInfo
            } else {
                simpleLosers = playerNames.keys.filter { $0 != winner }
                handleChipTransfers()
            }
            
        case .spread:
            
            prevTwoHitsPlayer = twoHitsPlayer
            twoHitsPlayer = winner
            simpleLosers = playerNames.keys.filter { $0 != winner }
            handleChipTransfers()
            
        case .noDeal:

            if settings.burnPenalty > 0 {
                losersToAsk = playerNames.filter { $0.key != winner }
                currentInputState = .winnerInfo
            } else {
                simpleLosers = playerNames.keys.filter { $0 != winner }
                currentInputState = .winnerInfo
            }
                
        case .deal:
            
            losersToAsk = playerNames.filter {
                ($0.key == dealer && winner != dealer) ||
                (nonDealerResponses[$0.key] == .challenge && winner != $0.key)
            }
            currentInputState = .winnerInfo
            
        case .none: break
        }
    }
    
    private func winnerSelectedCorrectly() -> Bool {
        for loser in losersToAsk.keys {
            if playerPoints[loser]! < playerPoints[winner!]! {
                wrongWinnerAlertMessage = "Winner selected incorrectly: \(playerNames[loser, default: "Player"]) can't have less total points than \(playerNames[winner!, default: "Player"]). Returning to winner selection."
                showWrongWinnerAlert = true
                return false
            } else if playerPoints[loser]! == playerPoints[winner!]! {
                if winner! == dealer {
                    wrongWinnerAlertMessage = "Winner selected incorrectly: \(playerNames[winner!, default: "Player"]) loses the tiebreaker since they dealt. Returning to winner selection."
                    showWrongWinnerAlert = true
                    return false
                } else {
                    if (loser != dealer) && (nextPlayer(after: loser) == winner!) {
                        wrongWinnerAlertMessage = "Winner selected incorrectly: \(playerNames[winner!, default: "Player"]) loses the tiebreaker since \(playerNames[loser, default: "Player"]) is next in line after the player who dealt. Returning to winner selection."
                        showWrongWinnerAlert = true
                        return false
                    }
                }
            }
        }
        return true
    }
    
    private func chipTransfer(from loser: PlayerPosition, to winner: PlayerPosition, amount: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            chipCounts[loser]! -= amount
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            chipCounts[winner]! += amount
        }
        animateChipTransfer(from: loser, to: winner, count: amount)
    }
    
    private func animateChipTransfer(from sender: PlayerPosition, to receiver: PlayerPosition, count: Int) {
        let playerChipPositions: [PlayerPosition : CGPoint] = [
            .left: CGPoint(x: 240, y: 110),
            .center: CGPoint(x: 350, y: 250),
            .right: CGPoint(x: 660, y: 110)
        ]
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let chip = MovingChip(position: playerChipPositions[sender]!, count: count)
            animatedChips.append(chip)
            if let index = animatedChips.firstIndex(where: { $0.id == chip.id }) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    animatedChips[index].position = playerChipPositions[receiver]!
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    animatedChips.removeAll { $0.id == chip.id }
                }
            }
        }
    }
    
    private func animatePotTransfer(player: PlayerPosition, count: Int, isTwoHits: Bool) {
        let playerChipPositions: [PlayerPosition : CGPoint] = [
            .left: CGPoint(x: 240, y: 110),
            .center: CGPoint(x: 350, y: 250),
            .right: CGPoint(x: 660, y: 110)
        ]
        let potPosition: CGPoint = CGPoint(x: 450, y: 140)
        
        if isTwoHits {
                
            let chip = MovingChip(position: potPosition, count: count)
            animatedChips.append(chip)
            
            if let index = animatedChips.firstIndex(where: { $0.id == chip.id }) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    animatedChips[index].position = playerChipPositions[player]!
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    animatedChips.removeAll { $0.id == chip.id }
                }
            }
            
        } else {
                
            let chip = MovingChip(position: playerChipPositions[player]!, count: count)
            animatedChips.append(chip)
            
            if let index = animatedChips.firstIndex(where: { $0.id == chip.id }) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    animatedChips[index].position = potPosition
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    animatedChips.removeAll { $0.id == chip.id }
                }
            }
            
        }
    }
    
    private func hasEnoughChips(player: PlayerPosition, lossAmount: Int) -> Bool {
        return lossAmount > chipCounts[player]! ? false : true
    }
    
    private func handleChipTransfers() {
        if playersThatCantPayWinner.count > 0 {
            playersThatCantPayWinner = []
        } else {
            prevChipCounts = chipCounts
            prevPotAmount = potAmount
            prevRoundsWon = roundsWon
            prevBoughtBackIn = boughtBackIn
            if winType != .spread {
                prevTwoHitsPlayer = twoHitsPlayer
            }
            currentInputState = .deal
            disableWhileAnimating = true
            
            switch winType {
            case .deal:
                
                for player in simpleLosers {
                    chipTransfers.append((from: player, to: winner!, amount: settings.simpleWinAmount + winnerAces))
                }
                
                for (player, _) in losersToAsk {
                    let difference = playerPoints[player]! - playerPoints[winner!]!
                    chipTransfers.append((from: player, to: winner!, amount: settings.dealWinAmount + winnerAces + difference))
                }
                
            case .noDeal:
                
                if settings.burnPenalty > 0 {
                    for (player, _) in losersToAsk {
                        if nonDealerResponses[player] == .burn {
                            chipTransfers.append((from: player, to: winner!, amount: settings.simpleWinAmount + winnerAces + settings.burnPenalty))
                        } else {
                            chipTransfers.append((from: player, to: winner!, amount: settings.simpleWinAmount + winnerAces))
                        }
                    }
                } else {
                    for player in simpleLosers {
                        chipTransfers.append((from: player, to: winner!, amount: settings.simpleWinAmount + winnerAces))
                    }
                }
                
            case .tongits:
                
                if settings.burnPenalty > 0 {
                    for (player, _) in losersToAsk {
                        if nonDealerResponses[player] == .burn {
                            chipTransfers.append((from: player, to: winner!, amount: settings.tongitsWinAmount + settings.burnPenalty))
                        } else {
                            chipTransfers.append((from: player, to: winner!, amount: settings.tongitsWinAmount))
                        }
                    }
                } else {
                    for player in simpleLosers {
                        chipTransfers.append((from: player, to: winner!, amount: settings.tongitsWinAmount))
                    }
                }
                
            case .spread:
                
                for player in simpleLosers {
                    chipTransfers.append((from: player, to: winner!, amount: settings.tongitsWinAmount + settings.burnPenalty))
                }
                
            case .none: break
            }
            
            for player in simpleLosers {
                if nonDealerResponses[player] == .burn && settings.burnPenalty > 0 {
                    if let index = chipTransfers.firstIndex(where: { $0.from == player }) {
                        chipTransfers[index].amount += settings.burnPenalty
                    }
                }
            }
            
            for player in PlayerPosition.allCases.filter({ $0 != winner! }) {
                let lossAmount = chipTransfers.first { $0.from == player }!.amount
                if !hasEnoughChips(player: player, lossAmount: lossAmount) {
                    playersThatCantPayWinner.append(player)
                }
            }
        }
        
        if playersThatCantPayWinner.count > 0 {
            showOutOfChipsAlert = true
        } else {
            for transfer in chipTransfers {
                chipTransfer(from: transfer.from, to: transfer.to, amount: transfer.amount)
            }
            handlePotTransfers()
        }
    }
    
    private func handlePotTransfers() {
        if winner == twoHitsPlayer {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if playersThatCantPayPot.count > 0 {
                    playersThatCantPayPot = []
                } else {
                    let tempPotAmount: Int = potAmount
                    animatePotTransfer(player: winner!, count: potAmount, isTwoHits: true)
                    potAmount = 0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        chipCounts[winner!]! += tempPotAmount
                    }
                }
                    
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    for player in PlayerPosition.allCases {
                        if !hasEnoughChips(player: player, lossAmount: settings.startingPotContribution) {
                            playersThatCantPayPot.append(player)
                        }
                    }
                    
                    if playersThatCantPayPot.count > 0 {
                        showOutOfChipsAlert = true
                    } else {
                        for player in PlayerPosition.allCases {
                            chipCounts[player]! -= settings.startingPotContribution
                            animatePotTransfer(player: player, count: settings.startingPotContribution, isTwoHits: false)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            potAmount = settings.startingPotContribution * 3
                            resetForNextRound()
                        }
                    }
                }
                
            }
            
        } else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if playersThatCantPayPot.count > 0 {
                    playersThatCantPayPot = []
                } else {
                    for player in PlayerPosition.allCases {
                        if !hasEnoughChips(player: player, lossAmount: settings.potIncrement) {
                            playersThatCantPayPot.append(player)
                        }
                    }
                }
                
                if playersThatCantPayPot.count > 0 {
                    showOutOfChipsAlert = true
                } else {
                    twoHitsPlayer = winner
                    for player in PlayerPosition.allCases {
                        chipCounts[player]! -= settings.potIncrement
                        animatePotTransfer(player: player, count: settings.potIncrement, isTwoHits: false)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        potAmount += settings.potIncrement * 3
                        resetForNextRound()
                    }
                }
                
            }
            
        }
    }
    
    private func handleBuyBackIn() {
        if playersThatCantPayWinner.count > 0 {
            for player in playersThatCantPayWinner {
                chipCounts[player]! += settings.startingChipAmount
                boughtBackIn[player]! += 1
            }
            handleChipTransfers()
        } else if playersThatCantPayPot.count > 0 {
            for player in playersThatCantPayPot {
                chipCounts[player]! += settings.startingChipAmount
                boughtBackIn[player]! += 1
            }
            handlePotTransfers()
        }
    }
    
    private func resetForNextRound() {
        roundsWon[winner!]! += 1
        numRounds += 1
        
        nonDealerResponses = [:]
        playerPoints = [:]
        winnerAces = 0
        dealer = nil
        nonDealers = []
        simpleLosers = []
        losersToAsk = [:]
        winner = nil
        winType = nil
        chipTransfers = []
        disableWhileAnimating = false
    }
    
    private func restartRound() {
        nonDealerResponses = [:]
        playerPoints = [:]
        winnerAces = 0
        dealer = nil
        nonDealers = []
        promptingNonDealer = nil
        simpleLosers = []
        losersToAsk = [:]
        winner = nil
        winType = nil
        chipTransfers = []
        currentInputState = .deal
    }
    
    private func restartPrevRound() {
        chipCounts = prevChipCounts
        potAmount = prevPotAmount
        roundsWon = prevRoundsWon
        twoHitsPlayer = prevTwoHitsPlayer
        boughtBackIn = prevBoughtBackIn
        numRounds -= 1
        currentInputState = .deal
    }
    
    private func handleEndGame() {
        if playersThatCantPayWinner.count > 0 {
            roundsWon[winner!]! += 1
            for player in PlayerPosition.allCases.filter({ $0 != winner! }) {
                let lossAmount = chipTransfers.first { $0.from == player }!.amount
                chipCounts[player]! -= lossAmount
                chipCounts[winner!]! += lossAmount
            }
            if winner == twoHitsPlayer {
                chipCounts[winner!]! += potAmount
                potAmount = 0
            }
        } else if playersThatCantPayPot.count > 0 {
            roundsWon[winner!]! += 1
        }
        
        for player in PlayerPosition.allCases {
            chipCounts[player]! += potAmount / 3
        }
        onEndGame(chipCounts, roundsWon, boughtBackIn)
    }
    
}

private enum ScreenState {
    case deal,                  // Waiting for someone to deal
         dealResponses,         // Asking each non-dealer whether to challenge, fold, or burn
         selectWinner,          // Selecting a winner if there's a challenger, nobody deals, or tongits/spread
         winnerInfo,            // Asking winner for their total points and/or # of aces
         loserInfo,             // Asking each loser for their total points
         burnInfo               // Asking if losers got burned (if there's a burn penalty)
}

private enum WinType {
    case tongits, spread, deal, noDeal
}

#Preview {
    GameView(
        settings: GameSettings(),
        playerNames: [
            .left: "Dad",
            .center: "Christian",
            .right: "Mom"
        ],
        onEndGame: { _,_,_  in }
    )
}
