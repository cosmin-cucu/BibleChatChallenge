//
//  MainNavigationView.swift
//  iOSInterviewTemplate
//
//  Created by Andrei Horvati on 30.04.2025.
//

import SwiftUI

struct MainNavigationView: View {
    @State private var sliderValue: CGFloat = 0.5
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Slider(value: $sliderValue)
            }
            .padding()
            .frame(height: .infinity)
            .toolbar {
                Button(role: .cancel) {
                    
                } label: {
                    AnimatedView(size: .init(width: 100, height: 100))
                }
            }
            .navigationTitle("Main Navigation View")
        }
    }
}

#Preview {
    MainNavigationView()
}
