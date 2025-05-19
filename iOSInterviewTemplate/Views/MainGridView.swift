//
//  ContentView.swift
//  iOSInterviewTemplate
//
//  Created by Andrei Horvati on 30.04.2025.
//

import SwiftUI

struct MainGridView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], spacing: 10) {
                    ForEach(viewModel.views, id: \.id) { view in
                        AnimatedView(size: view.size)
                            .overlay(adjustSizeButtons(for: view.id), alignment: Alignment.bottomTrailing)
                    }
                }
                .padding()
            }
            
            HStack {
                startAnimationButton
                
                Spacer()
                    
                stopAnimationButton
                
                Spacer()
                
                addViewButton
            }
            .padding(.horizontal)
        }
    }
    
    private func adjustSizeButtons(for id: UUID) -> some View {
        HStack {
            Button {
                viewModel.adjustSize(for: id, delta: -50)
            } label: {
                Image(systemName: "minus")
            }
            
            Button {
                viewModel.adjustSize(for: id, delta: 50)
            } label: {
                Image(systemName: "plus")
            }
        }
        .padding(5)
        .background(Color.black.opacity(0.5))
        .foregroundStyle(.white)
        .cornerRadius(5)
    }
    
    private var startAnimationButton: some View {
        Button {
        } label: {
            Text("Start Animation")
                .padding()
                .background(Color.green)
                .foregroundStyle(.white)
                .cornerRadius(10)
        }
    }
    
    private var stopAnimationButton: some View {
        Button {
        } label: {
            Text("Stop Animation")
                .padding()
                .background(Color.red)
                .foregroundStyle(.white)
                .cornerRadius(10)
        }
    }
    
    private var addViewButton: some View {
        Button {
            viewModel.addView()
        } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundStyle(.blue)
        }
    }
}

#Preview {
    MainGridView()
}
