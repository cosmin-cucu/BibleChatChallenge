import SwiftUI
import Combine

struct VectorialAssetFlameView: View {
    @State private var currentFlameIndex: Int = 0
    @State private var flameScale: CGFloat = 1.0
    @State private var hoverOffset: CGPoint = .zero
    @State private var timer: AnyCancellable?
    
    let size: CGSize
    let animationProgress: Double
    
    private let flameImages = ["flame1", "flame2", "flame3", "flame4"]
    private let frameRate: Double = 0.1
    
    init(size: CGSize,
         animationProgress: Double = 0) {
        self.size = size
        self.animationProgress = animationProgress

    }
    
    private var flameOpacity: Double {
        if animationProgress < 0.85 {
            return max(0.9, 1 - animationProgress * 0.2)
        } else {
            let remainingProgress = (animationProgress - 0.85) / 0.15
            return max(0, 0.9 - (remainingProgress * 0.9))
        }
    }
    
    private var flameSize: CGSize {
        let scaleFactor: CGFloat
        if animationProgress < 0.8 {
            scaleFactor = max(0.8, 1 - animationProgress * 0.25)
        } else {
            let remainingProgress = (animationProgress - 0.8) / 0.2
            scaleFactor = max(0.4, 0.8 - remainingProgress * 0.4)
        }
        
        return CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
    }
    
    private var innerFlameOpacity: Double {
        return min(1.0, flameOpacity * 1.2)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if flameOpacity > 0 {
                Image(flameImages[currentFlameIndex])
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: flameSize.width, height: flameSize.height)
                    .scaleEffect(flameScale)
                    .offset(
                        x: hoverOffset.x,
                        y: hoverOffset.y
                    )
                    .opacity(flameOpacity)
                
                Image(flameImages[currentFlameIndex])
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: flameSize.width * 1.2, height: flameSize.height * 1.2)
                    .scaleEffect(flameScale)
                    .blur(radius: 3)
                    .offset(
                        x: hoverOffset.x,
                        y: hoverOffset.y
                    )
                    .opacity(flameOpacity * 0.4)
                    .blendMode(.screen)
            }
        }
        .onAppear {
            setupAnimations()
        }
        .onDisappear {
            timer?.cancel()
        }
    }
    
    private func setupAnimations() {
        timer = Timer.publish(every: frameRate, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                withAnimation(.easeInOut(duration: frameRate)) {
                    currentFlameIndex = (currentFlameIndex + 1) % flameImages.count
                }
            }
        
        withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            hoverOffset = CGPoint(x: 1, y: -1)
        }
        
        let pulseDuration = 1.2 - (animationProgress * 0.4)
        withAnimation(Animation.easeInOut(duration: pulseDuration).repeatForever(autoreverses: true)) {
            flameScale = 1.05
        }
    }
}


#Preview {
    VectorialAssetFlameView(size: .init(width: 50, height: 100))
}
