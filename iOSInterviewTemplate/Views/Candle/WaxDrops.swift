//
//  WaxDrops.swift
//  LightMyFire
//
//  Created by Cosmin Cucu on 5/18/25.
//

import Combine
import SwiftUI

struct WaxDrop: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var startY: CGFloat // Initial Y position
    var size: CGFloat
    var opacity: Double
    var fallProgress: CGFloat // 0 to 1, representing how far the drop has fallen
    
    init(x: CGFloat, y: CGFloat, size: CGFloat, opacity: Double = 0.9) {
        self.x = x
        self.y = y
        self.startY = y
        self.size = size
        self.opacity = opacity
        self.fallProgress = 0
    }
}


struct WaxDropsView: View {
    @State private var waxDrops: [WaxDrop] = []
    private let candleHeight: CGFloat
    private let initialCandleHeight: CGFloat
    private let sizesConfig: Config.Sizes
    private let animationProgress: CGFloat
    
    @State private var previousanimationProgress: CGFloat = 0
    
    private var maxFallDistance: CGFloat {
        return initialCandleHeight / 2
    }
    
    init(candleHeight: CGFloat,
         initialCandleHeight: CGFloat,
         sizesConfig: Config.Sizes,
         animationProgress: CGFloat) {
        self.candleHeight = candleHeight
        self.initialCandleHeight = initialCandleHeight
        self.sizesConfig = sizesConfig
        self.animationProgress = animationProgress
    }

    var body: some View {
        ZStack {
            ForEach(waxDrops) { drop in
                Circle()
                    .fill(Color.waxDropColor.opacity(drop.opacity))
                    .frame(width: drop.size, height: drop.size)
                    .offset(
                        x: drop.x,
                        y: calculateDropPosition(drop)
                    )
            }
        }
        .onChange(of: animationProgress) {
            updateWaxDrops(animationProgress)
        }
        .onAppear {
            if waxDrops.isEmpty && animationProgress > 0 {
                createInitialDrops()
            }
        }
    }
    
    private func calculateDropPosition(_ drop: WaxDrop) -> CGFloat {
        let fallDistance = drop.fallProgress * maxFallDistance
        return drop.startY + fallDistance
    }
    
    private func updateWaxDrops(_ newanimationProgress: CGFloat) {
        for i in 0..<waxDrops.count {
            let animationProgressDelta = newanimationProgress - previousanimationProgress
            waxDrops[i].fallProgress += animationProgressDelta * 2
            
            waxDrops[i].opacity = max(0.2, 0.95 - waxDrops[i].fallProgress * 0.7)
        }

        waxDrops.removeAll(where: { $0.fallProgress >= 1.0 || $0.opacity <= 0 })
        
        let animationProgressDifference = newanimationProgress - previousanimationProgress
        if animationProgressDifference > 0 {
    
            let dropChance = 0.5 + animationProgress * 0.5
            if Double.random(in: 0...1) < dropChance * Double(animationProgressDifference * 20) {
                createNewWaxDrop()
            }
        }
        
        previousanimationProgress = newanimationProgress
    }
    
    private func createNewWaxDrop() {
        let newDrop = WaxDrop(
            x: -sizesConfig.candleWidth/2 + CGFloat.random(in: 0...sizesConfig.candleWidth),
            y: -candleHeight / 8 + sizesConfig.wickHeight,
            size: CGFloat.random(in: 1...5)
        )
        waxDrops.append(newDrop)
    }
    
    private func createInitialDrops() {
        let numberOfDrops = Int(animationProgress * 5) + 1
        for _ in 0..<numberOfDrops {
            let drop = WaxDrop(
                x: -sizesConfig.candleWidth/2 + CGFloat.random(in: 0...sizesConfig.candleWidth),
                y: -candleHeight / 8 + sizesConfig.wickHeight,
                size: CGFloat.random(in: 1...5)
            )
            var modifiedDrop = drop
            modifiedDrop.fallProgress = CGFloat.random(in: 0...(animationProgress * 0.8))
            modifiedDrop.opacity = max(0, 0.9 - modifiedDrop.fallProgress * 0.9)
            waxDrops.append(modifiedDrop)
        }
    }
}
