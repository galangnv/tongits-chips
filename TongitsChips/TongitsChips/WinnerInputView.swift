//
//  WinnerInputView.swift
//  TongitsChips
//
//  Created by Christian Galang on 7/2/25.
//

import SwiftUI

struct WinnerInputView: View {
    var name: String
    var position: PlayerPosition
    var isSimple: Bool
    var onSubmit: (Int, Int) -> Void
    
    @State private var totalPoints = ""
    @State private var numAces = ""
    @FocusState private var focusedField: Field?
    
    private var allFieldsEntered: Bool {
        (isSimple || !totalPoints.trimmingCharacters(in: .whitespaces).isEmpty) &&
        !numAces.trimmingCharacters(in: .whitespaces).isEmpty &&
        validAces
    }
    
    private var validAces: Bool {
        if let aces = Int(numAces) {
            return (0...4).contains(aces)
        }
        return false
    }
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Label("\(name)", systemImage: position.directionArrow)
                .font(.title)
            
            VStack(alignment: .trailing) {
                
                if !isSimple {
                    
                    HStack {
                        
                        Text("Total Points:")
                        TextField("", text: $totalPoints)
                            .padding(.all, 3)
                            .frame(width: 80)
                            .keyboardType(.numberPad)
                            .background(Color.white)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .focused($focusedField, equals: .totalPoints)
                        
                    }
                    
                }
                
                HStack {
                    
                    Text("# of Aces:")
                    TextField("", text: $numAces)
                        .padding(.all, 3)
                        .frame(width: 80)
                        .keyboardType(.numberPad)
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .focused($focusedField, equals: .numAces)
                    
                }
                
            }
                
            Button(
                action: {
                    let points = Int(totalPoints) ?? 0
                    let aces = Int(numAces) ?? 0
                    onSubmit(points, aces)
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
            focusedField = isSimple ? .numAces : .totalPoints
        }
        
    }
}

private enum Field: Hashable {
    case totalPoints, numAces
}

#Preview {
    WinnerInputView(name: "Christian", position: .center, isSimple: false, onSubmit: { _,_ in })
}
