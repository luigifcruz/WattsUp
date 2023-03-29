//
//  ContentView.swift
//  Watt's Up
//
//  Created by Luigi Cruz on 3/28/23.
//

import SwiftUI

struct ContentView: View {
    @Binding var chargingSpeed: Int
    @Binding var chargingSpeedLabel: String
    @Binding var chargingUnit: String
    @Binding var chargingState: Bool
    
    var body: some View {
        let boxColor = chargingState ? Color(hue: 0.3, saturation: 0.7, brightness: 0.8)
                                     : Color(hue: 0.7, saturation: 0.8, brightness: 0.9)
        
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(boxColor)
                    .frame(width: 300, height: 100)
                    .padding(50)
                VStack {
                    Text(chargingSpeedLabel)
                        .font(.headline)
                        .padding(.top, 5)
                        .foregroundColor(.white.opacity(0.85))
                    HStack {
                        Text("\(chargingSpeed)")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.white)
                        Text(chargingUnit)
                            .font(.system(size: 45, weight: .bold))
                            .foregroundColor(.white.opacity(0.95))
                            .padding(.bottom, -10)
                    }
                }
            
            }
            Text("Also available as a widget.")
                .font(.footnote)
                .foregroundColor(.init(white: 0.6))
                .multilineTextAlignment(.center)
                .padding(.bottom, -5)
                .hidden()
            HStack {
                Text("Brought to you by")
                    .padding(.trailing, -5)
                Link("@luigifcruz", destination: URL(string: "https://twitter.com/luigifcruz")!)
                    .font(.footnote.bold())
            }
            .font(.footnote)
            .foregroundColor(.init(white: 0.6))
            .padding(.bottom, 10)
        }
        .animation(.easeInOut(duration: 0.5))
    }
}
