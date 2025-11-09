//
//  PotView.swift
//  TongitsChips
//
//  Created by Christian Galang on 6/28/25.
//

import SwiftUI

struct PotView: View {
    var potCount: Int
    
    var body: some View {
        
        ZStack {
            
            Image("pot")
                .resizable()
                .frame(width: 180.0, height: 105.0)
                .scaledToFit()
            
            Text("\(potCount)")
                .font(.title)
                .foregroundColor(.black)
            
        }
        
    }
}

#Preview {
    PotView(potCount: 9)
}
