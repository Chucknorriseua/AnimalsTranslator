//
//  AudioVisualizerView.swift
//  AnimalsTranslator
//
//  Created by Евгений Полтавец on 07/02/2025.
//

import SwiftUI

struct AudioVisualizerView: View {
    var levels: [CGFloat]

    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                let barCount = levels.count
                let barWidth = size.width / CGFloat(barCount)
                
                for (index, level) in levels.enumerated() {
                 
                    let waveOffset = sin(CGFloat(index) * 0.3 + CGFloat(Date().timeIntervalSince1970 * 3)) * 0.5 + 1
                    let adjustedHeight = max(size.height * (level / 100) * waveOffset, 5)
                    
                    let centerY = size.height / 2
                    
                    let rect = CGRect(
                        x: CGFloat(index) * barWidth,
                        y: centerY - adjustedHeight / 2,
                        width: barWidth * 0.09,
                        height: adjustedHeight
                    )
                    
                    context.fill(Path(rect), with: .color(.blue))
                }
            }
            .animation(.easeInOut(duration: 0.1), value: levels)
        }
        .frame(height: 40)
    }
}

#Preview(body: {
    AudioVisualizerView(levels: Array(repeating: 10, count: 20))
})
