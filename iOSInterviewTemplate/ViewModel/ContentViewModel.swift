//
//  ContentViewModel.swift
//  iOSInterviewTemplate
//
//  Created by Andrei Horvati on 30.04.2025.
//

import Combine
import Foundation

class ContentViewModel: ObservableObject {
    @Published var views: [(id: UUID, size: CGSize)] = []
    
    func addView() {
        let newSize = CGSize(width: 200, height: 200)
        views.append((id: UUID(), size: newSize))
    }
    
    func adjustSize(for id: UUID, delta: CGFloat) {
        if let index = views.firstIndex(where: { $0.id == id }) {
            let currentSize = views[index].size
            let newWidth = max(50, currentSize.width + delta)
            let newHeight = max(50, currentSize.height + delta)
            views[index].size = CGSize(width: newWidth, height: newHeight)
        }
    }
}
