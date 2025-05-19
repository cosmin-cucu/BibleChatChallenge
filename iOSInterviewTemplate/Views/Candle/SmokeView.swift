//
//  SmokeParticle.swift
//  iOSInterviewTemplate
//
//  Created by Cosmin Cucu on 5/18/25.
//


import SwiftUI

struct SmokeParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var opacity: Double
    var offset: CGSize
}

struct SmokeView: View {
    @State private var particles: [SmokeParticle] = []
    @State private var isAnimating = false
    @State private var hasCompleted = false
    private let wickPosition: CGPoint
    
    init(wickPosition: CGPoint) {
        self.wickPosition = wickPosition
    }
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(Color.gray.opacity(particle.opacity))
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .offset(particle.offset)
                    .blur(radius: particle.size / 2)
            }
        }
        .onAppear {
            if !isAnimating && !hasCompleted {
                startAnimation()
            }
        }
    }
    
    private func startAnimation() {
        isAnimating = true
        
        particles = (0..<15).map { _ in
            let randomSize = CGFloat.random(in: 5...15)
            return SmokeParticle(
                position: wickPosition,
                size: randomSize,
                opacity: Double.random(in: 0.3...0.6),
                offset: .zero
            )
        }
        
        withAnimation(Animation.easeOut(duration: 2.0)) {
            for i in 0..<particles.count {
                let horizontalDrift = CGFloat.random(in: -20...20)
                let verticalRise = CGFloat.random(in: (-80)...(-40))
                
                particles[i].offset = CGSize(width: horizontalDrift, height: verticalRise)
                particles[i].size *= 1.5
                particles[i].opacity *= 0.6
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(Animation.easeOut(duration: 1.0)) {
                for i in 0..<particles.count {
                    particles[i].opacity = 0
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                isAnimating = false
                hasCompleted = true
                particles = []
            }
        }
    }
    
    func reset() {
        hasCompleted = false
        isAnimating = false
        particles = []
    }
}
