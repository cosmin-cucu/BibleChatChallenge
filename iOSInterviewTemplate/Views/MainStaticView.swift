//
//  MainStaticView.swift
//  iOSInterviewTemplate
//
//  Created by Andrei Horvati on 30.04.2025.
//

import SwiftUI

struct MainStaticView: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .background(
                    content(geometry: geometry)
                )
        }
    }
    
    func content(geometry: GeometryProxy) -> some View {
        VStack {
            AnimatedView(
                size: .init(
                    width: geometry.size.width * 0.8,
                    height: geometry.size.height * 0.6
                )
            )
            
            Spacer()
            
            Text("Ensure this candles always have the same animation state as candles from the other 2 tabs!")
                .multilineTextAlignment(.center)
            
            HStack {
                decreaseAnimationButton
                
                increaseAnimationButton
            }
        }
    }
    
    private var increaseAnimationButton: some View {
        Button {
        } label: {
            Text("Increase Animation")
                .padding()
                .background(Color.green)
                .foregroundStyle(.white)
                .cornerRadius(10)
        }
    }
    
    private var decreaseAnimationButton: some View {
        Button {
        } label: {
            Text("Decrease Animation")
                .padding()
                .background(Color.red)
                .foregroundStyle(.white)
                .cornerRadius(10)
        }
    }
}

#Preview {
    MainStaticView()
}
