//
//  AnimatedView.swift
//  iOSInterviewTemplate
//
//  Created by Andrei Horvati on 30.04.2025.
//

import SwiftUI

enum DownloadState {
    case notInitiated
    case downloading
    case downloaded
}

struct AnimatedView: View {
    let size: CGSize
    
    @State private var circleTrim: CGFloat = 0
    @State private var arrowEnd: CGFloat = 0
    @State private var downloadState: DownloadState = .notInitiated

    @State private var downloadPercentage: Double = 0
    @State private var time: CGFloat = 0.5

    @State private var animatableX: CGFloat = 0
    @State private var fillOffset: CGFloat = 0
    @State private var arrowYOffset: CGFloat = -40
    @State private var LineDifference: CGFloat = 0
    @State private var animationDuration: TimeInterval = 4
    
    let arrowHeight: CGFloat = 100
    let fillColor: Color = .orange
    
    private var candleScaleFactor: CGFloat {
        return min(size.width, size.height) / 400
   }
    
    private var candleHeight: CGFloat {
        return (size.height / 4) * candleScaleFactor
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.clear
                    .ignoresSafeArea()
                
                ZStack {
                    ZStack {
                        WaveFill(curve: time * 0.7, curveHeight: 10, curveLength: 5)
                            .fill(fillColor.opacity(0.975))
                            .offset(y: self.downloadState != .notInitiated ? fillOffset : -fillOffset + 5)
                        
                        WaveFill(curve: time * 0.001, curveHeight: 5, curveLength: 10)
                            .fill(fillColor.opacity(0.9))
                            .offset(y: self.downloadState != .notInitiated ? fillOffset : -fillOffset + 7)
                    }
                    .animation(.linear(duration: animationDuration), value: downloadState)
                    .mask(Circle().scaleEffect(0.91))
                    
                    CandleView(
                        initialCandleHeight: size.height / 4,
                        animationProgress: min(1.0, downloadPercentage / 100)
                    ).offset(y: (size.height / 8) * candleScaleFactor)
                    
                    Circle()
                        .stroke(lineWidth: 10)
                        .fill(fillColor)
                        .opacity(0.85)
                        .clipShape(Circle())
                    
                    ZStack {
                        Circle()
                            .trim(from: 0, to: circleTrim)
                            .stroke(style: StrokeStyle(lineWidth: 11, lineCap: .round, lineJoin: .round))
                            .rotation(.degrees(-90))
                            .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                            .foregroundColor(.brown)
                        Circle()
                            .trim(from: 0, to: circleTrim)
                            .stroke(style: StrokeStyle(lineWidth: 11, lineCap: .round, lineJoin: .round))
                            .rotation(.degrees(90))
                            .foregroundColor(.brown)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(y: -24)
            }
            .padding(24)
            .onAppear {
                guard downloadState == .notInitiated else {
                    return
                }
                
                initiateDownload()
            }
        }
        .frame(width: size.width, height: size.height)
        .onAppear {
            fillOffset = -150
            withAnimation(.spring()) {
                arrowYOffset = 0
            }
            withAnimation(.easeInOut(duration: 0.4)) {
                arrowEnd = 1
            }
        }
    }

    func initiateDownload() {
        withAnimation(.default) {
            arrowYOffset = -20
        }
        withAnimation(.easeInOut(duration: 0.3)) {
            animatableX = arrowHeight / 3
        }
        withAnimation(.easeInOut(duration: 0.5).delay(0.2)) {
            LineDifference = arrowHeight
            arrowYOffset = arrowHeight
        }

        withAnimation(.default.delay(0.45)) {
            animatableX = arrowHeight / 3 + 10
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
            animate()
        }
    }

    func animate() {
        animationDuration = 7
        downloadState = .downloading

        withAnimation(.linear(duration: animationDuration)) {
            circleTrim = 0.5
        }

        Timer.scheduledTimer(withTimeInterval: animationDuration / 100, repeats: true) { timerBlock in
            downloadPercentage += 1
            if downloadPercentage == 100 {
                downloadState = .downloaded
                timerBlock.invalidate()
            }
        }
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { waveTimer in
            guard self.downloadState == .downloading else {
                waveTimer.invalidate()
                return
            }
            withAnimation(.default) {
                time += 0.5
            }
        }
    }

    func reset() {
        animationDuration = 0
        downloadPercentage = 0
        withAnimation(.easeInOut(duration: 0.5)) {
            circleTrim = 0
            time = 0.5
            downloadState = .notInitiated
        }

        withAnimation(.default) {
            fillOffset = -150
        }

        withAnimation(.spring().delay(0.3)) {
            arrowYOffset = 0
        }
        withAnimation(.easeInOut(duration: 0.4).delay(0.35)) {
            arrowEnd = 1
            LineDifference = 0
        }

        withAnimation(.default.delay(0.375)) {
            animatableX = 0
        }
    }
}
#Preview {
    AnimatedView(size: .init(width: 100, height: 100))
}
