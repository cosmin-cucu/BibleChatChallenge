import Combine
import SwiftUI

struct CandleView: View {
    private let initialCandleHeight: CGFloat
    private let sizesConfig: Config.Sizes
    private let isImplementedWithBezier: Bool
    private let animationProgress: Double
    private var shouldShowSmoke: Bool {
        return animationProgress >= 0.98
    }
    
    private var candleHeight: CGFloat {
        let minHeight = sizesConfig.minCandleHeight
        let maxHeight = initialCandleHeight
        let range = maxHeight - minHeight
        return maxHeight - (range * animationProgress)
    }
    
    init(initialCandleHeight: CGFloat,
         animationProgress: Double,
         isImplementedWithBezier: Bool = false) {
        self.initialCandleHeight = initialCandleHeight
        self.sizesConfig = Config.Sizes(candleHeight: initialCandleHeight)
        self.animationProgress = animationProgress
        self.isImplementedWithBezier = isImplementedWithBezier
    }
    
    private var candleBody: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.candleGradient)
            .frame(width: initialCandleHeight / 5, height: candleHeight)
    }
    
    private var wickView: some View {
        Rectangle()
            .fill(Color.black)
            .frame(width: sizesConfig.wickWidth, height: sizesConfig.wickHeight)
    }
    
    private var glowView: some View {
        Circle()
            .fill(Color.yellow.opacity(0.8))
            .frame(width: sizesConfig.glowSize, height: sizesConfig.glowSize)
            .blur(radius: initialCandleHeight / 3)
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            ZStack(alignment: .bottom) {
                glowView
                    .offset(y: -sizesConfig.wickHeight/2)
                
                if isImplementedWithBezier {
                    FlameView(size: sizesConfig.flameSize, animationProgress: animationProgress)
                        .offset(y: sizesConfig.wickHeight)
                } else {
                    VectorialAssetFlameView(size: sizesConfig.flameSize, animationProgress: animationProgress)
                        .offset(y: sizesConfig.wickHeight)
                }
            }
            .overlay(alignment: .top) {
                if shouldShowSmoke {
                    SmokeView(wickPosition: .init(x: sizesConfig.flameSize.width / 2, y: 2 * sizesConfig.minCandleHeight + sizesConfig.wickHeight))
                }
            }
            
            wickView
            
            ZStack(alignment: .top) {
                candleBody
                    .zIndex(1)
                WaxDropsView(
                    candleHeight: candleHeight,
                    initialCandleHeight: initialCandleHeight,
                    sizesConfig: sizesConfig,
                    animationProgress: animationProgress
                )
                .opacity(max(0, 1 - (animationProgress * 2)))
                .zIndex(2)
            }
            
            Spacer()
                .frame(height: sizesConfig.minCandleHeight)
        }
        .frame(height: initialCandleHeight * 1.5, alignment: .bottom)
    }
}
