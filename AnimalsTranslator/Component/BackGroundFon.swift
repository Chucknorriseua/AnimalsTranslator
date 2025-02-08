//
//  BackGroundFon.swift
//  AnimalsTranslator
//
//  Created by Евгений Полтавец on 06/02/2025.
//


import SwiftUI

struct BackgroundFon: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
            .background(
                LinearGradient(colors: [Color.init(hex: "#F3F5F6"), Color.init(hex: "#C9FFE0")],
                               startPoint: .topLeading,
                               endPoint: .bottomLeading)
            )
    }
}

extension View {
    func createBackgrounfFon() -> some View {
        self.modifier(BackgroundFon())
    }
}

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}
