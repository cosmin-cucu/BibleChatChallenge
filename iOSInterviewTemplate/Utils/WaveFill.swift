//
//  WaveFill.swift
//  iOSInterviewTemplate
//
//  Created by Andrei Horvati on 30.04.2025.
//

import SwiftUI

struct WaveFill: Shape {
    var curve: CGFloat
    
    let curveHeight: CGFloat
    let curveLength: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.width, y: rect.height * 2))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 2))
        
        for i in stride(
            from: 0,
            to: CGFloat(rect.width),
            by: 1
        ) {
            path.addLine(
                to: CGPoint(
                    x: i,
                    y: sin(((i / rect.height) + curve) * curveLength * .pi) * curveHeight + rect.midY
                )
            )
        }
        
        return path
    }
}
