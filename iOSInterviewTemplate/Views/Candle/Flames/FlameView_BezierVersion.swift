import SwiftUI

struct FlameShape: Shape {
    var animationValue: CGFloat
    
    var animatableData: CGFloat {
        get { animationValue }
        set { animationValue = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let midX = rect.midX
        
        let sway = sin(animationValue) * (width * 0.05)
        
        var path = Path()
        
        path.move(to: CGPoint(x: midX, y: height))
        
        path.addCurve(
            to: CGPoint(x: midX + width * 0.4, y: height * 0.5),
            control1: CGPoint(x: midX + width * 0.1, y: height * 0.75),
            control2: CGPoint(x: midX + width * 0.5 + sway, y: height * 0.7)
        )
        
        path.addCurve(
            to: CGPoint(x: midX, y: 0),
            control1: CGPoint(x: midX + width * 0.3 - sway, y: height * 0.3),
            control2: CGPoint(x: midX + width * 0.1, y: height * 0.1)
        )
        
        path.addCurve(
            to: CGPoint(x: midX - width * 0.4, y: height * 0.5),
            control1: CGPoint(x: midX - width * 0.1, y: height * 0.1),
            control2: CGPoint(x: midX - width * 0.3 + sway, y: height * 0.3)
        )
        
        path.addCurve(
            to: CGPoint(x: midX, y: height),
            control1: CGPoint(x: midX - width * 0.5 - sway, y: height * 0.7),
            control2: CGPoint(x: midX - width * 0.1, y: height * 0.75)
        )
        
        return path
    }
}

struct FlameView: View {
    @State private var animationValue: CGFloat = 0
    @State private var flameScale: CGFloat = 1.0
    @State private var innerFlameScale: CGFloat = 0.85
    @State private var brighterInnerFlameScale: CGFloat = 0.7
    
    let size: CGSize
    let animationProgress: Double
    
    init(size: CGSize, animationProgress: Double = 0) {
        self.size = size
        self.animationProgress = animationProgress
    }
    
    private var flameOpacity: Double {
        return max(0, 1 - animationProgress )
    }
    
    private var flameSize: CGSize {
        let scaleFactor = max(0.4, 1 - animationProgress)
        return CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
    }
    
    var body: some View {
        ZStack {
            if flameOpacity > 0 {
                FlameShape(animationValue: animationValue)
                    .fill(Color.outerFlameGradient)
                    .frame(width: flameSize.width, height: flameSize.height)
                    .scaleEffect(flameScale)
                    .opacity(flameOpacity)
                
                FlameShape(animationValue: animationValue + 0.5)
                    .fill(Color.innerFlameGradient)
                    .frame(width: flameSize.width / 2, height: flameSize.height / 2)
                    .scaleEffect(innerFlameScale)
                    .blendMode(.screen)
                    .opacity(flameOpacity)
                
                FlameShape(animationValue: animationValue + 0.5)
                    .fill(Color.brighterInnerFlameGradient)
                    .frame(width: flameSize.width / 6, height: flameSize.height / 6)
                    .scaleEffect(brighterInnerFlameScale)
                    .blendMode(.screen)
                    .opacity(flameOpacity)
            }
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                animationValue = 2 * .pi
            }
            
            let pulseDuration = 1.2 - (animationProgress * 0.5) // Gets faster as it burns out
            withAnimation(Animation.easeInOut(duration: pulseDuration).repeatForever(autoreverses: true)) {
                flameScale = 1.05
            }
            
            withAnimation(Animation.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                innerFlameScale = 0.9
            }
            
            withAnimation(Animation.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                brighterInnerFlameScale = 0.75
            }
        }
    }
}
