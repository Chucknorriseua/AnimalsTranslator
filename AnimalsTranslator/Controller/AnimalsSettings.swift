//
//  AnimalsSettings.swift
//  AnimalsTranslator
//
//  Created by Евгений Полтавец on 06/02/2025.
//

import SwiftUI

enum SettingsRow: String, CaseIterable, Identifiable {
    case rateUS = "Rate Us"
    case shareApp = "Share App"
    case contactUs = "Contact Us"
    case restorePursh = "Restore Purchases"
    case privacyPolice = "Privacy Policy"
    case termsOfUse = "Terms of Use"
    
    var id: String {
        self.rawValue
    }
}

struct AnimalsSettings: View {
    
    var body: some View {
        NavigationView(content: {
            VStack {
                ForEach(SettingsRow.allCases, id: \.id) { cell in
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        SettingsRowCell(cell: cell)
                    })
                }
                Spacer()
            }.createBackgrounfFon()
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text("Settings")
                                .font(.title)
                                .foregroundStyle(Color.black)
                                .fontWeight(.bold)
                        }.padding(.top, 30)
                    }
                })
        })
    }
}

#Preview {
    AnimalsSettings()
}
