//
//  MainView.swift
//  iOSInterviewTemplate
//
//  Created by Andrei Horvati on 30.04.2025.
//

import SwiftUI

enum Tabs {
    case mainGrid, mainStatic, mainNavigation
}

struct MainView: View {
    @State private var selectedTab: Tabs = .mainGrid
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Main Grid", systemImage: "", value: .mainGrid) {
                MainGridView()
            }
            
            Tab("Main Static", systemImage: "", value: .mainStatic) {
                MainStaticView()
            }
            
            Tab("Main Navigation", systemImage: "", value: .mainNavigation) {
                MainNavigationView()
            }
        }
    }
}

#Preview {
    MainView()
}

