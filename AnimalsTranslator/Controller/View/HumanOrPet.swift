//
//  HumanOrPet.swift
//  AnimalsTranslator
//
//  Created by Евгений Полтавец on 06/02/2025.
//

import SwiftUI

struct HumanOrPet: View {
    
    @State private var isSelected: Bool = false
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 60) {
                Text(isSelected ? "HUMAN" : "PET")
                    .frame(width: 80)
                HStack(alignment: .center) {
                    Button(action: {
                        isSelected.toggle()
                    }, label: {
                        Image("arrow-swap-horizontal")
                    })
                }
                Text(isSelected ? "PET" : "HUMAN")
                    .frame(width: 80)
            }.fontWeight(.heavy)
        }.frame(maxWidth: .infinity)
            .foregroundStyle(Color.black)
    }
}

#Preview {
    HumanOrPet()
}
