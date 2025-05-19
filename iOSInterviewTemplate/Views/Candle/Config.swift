//
//  Config.swift
//  LightMyFire
//
//  Created by Cosmin Cucu on 5/18/25.
//
import SwiftUI

struct Config {
    struct Sizes {
        let candleHeight: CGFloat
        
        let minCandleHeight: CGFloat = 10
        
        var candleWidth: CGFloat {
            candleHeight / 5
        }

        var wickHeight: CGFloat {
            candleHeight / 15
        }
        
        var wickWidth: CGFloat {
            candleHeight / 75
        }
        
        var glowSize: CGFloat {
            candleHeight / 2
        }
        
        var flameSize: CGSize {
            .init(width: candleHeight / 3, height: candleHeight / 1.75)
        }
        
    }
}

extension Color {
    static var outerFlameGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 1.0, green: 0.4, blue: 0.3),
                Color(red: 1.0, green: 0.2, blue: 0.2),
                Color(red: 0.9, green: 0.1, blue: 0.1)
            ]),
            startPoint: .bottom,
            endPoint: .top
        )
    }
    
    static var innerFlameGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.yellow,
                Color.orange,
                Color(red: 1.0, green: 0.3, blue: 0.2)
            ]),
            startPoint: .bottom,
            endPoint: .top
        )
    }
    
    static var brighterInnerFlameGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 1.0, green: 1.0, blue: 0.3),
                Color(red: 1.0, green: 0.6, blue: 0.0),
                Color(red: 1.0, green: 0.0, blue: 0.0)
            ]),
            startPoint: .bottom,
            endPoint: .top
        )
    }

    static var candleGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 1.0, green: 0.8, blue: 0.3),
                Color(red: 0.95, green: 0.7, blue: 0.2)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var waxDropColor: Color {
        Color(red: 0.98, green: 0.95, blue: 0.9)
    }
}
