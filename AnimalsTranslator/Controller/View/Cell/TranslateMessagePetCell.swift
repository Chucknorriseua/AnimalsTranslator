//
//  TranslateMessagePetCell.swift
//  AnimalsTranslator
//
//  Created by Евгений Полтавец on 06/02/2025.
//

import SwiftUI

struct TranslateMessagePetCell: View {
    
    @StateObject var animalVM = AnimalsTransViewModel()
    @State private var confidence: Double = 0.0
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomLeading) {
             
                Text(animalVM.detectedMessage)
                    .fontWeight(.semibold)
                    .frame(maxWidth: 300, maxHeight: 150)
                    .background(Color.init(hex: "#D6DCFF"))
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    .shadow(color: .black.opacity(0.3), radius: 2, y: 4)
                    .onChange(of: animalVM.detectedMessage) { _, newValue in
                        print("new message: \(newValue)")
                    }
                
                
                MessageTailShape()
                    .fill(Color.init(hex: "#D6DCFF"))
                    .frame(width: 140, height: 30)
                    .rotationEffect(.degrees(300), anchor: .topLeading)
                    .shadow(color: .black.opacity(0.2), radius: 2, y: 6)
                    .offset(x: 180, y: 140)
            }
        }
        .padding()
    }
}

import SwiftUI

struct MessageTailShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + 10))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 10))
        path.closeSubpath()
        
        return path
    }
}
