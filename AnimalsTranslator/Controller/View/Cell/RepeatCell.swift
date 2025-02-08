//
//  RepeatCell.swift
//  AnimalsTranslator
//
//  Created by Евгений Полтавец on 06/02/2025.
//

import SwiftUI

struct RepeatCell: View {
    
    @ObservedObject var animalVM: AnimalsTransViewModel
    let dismiss: () -> ()
    
    var body: some View {
        Button {
            Task {
              await animalVM.startTranslatorPet()
            }
            dismiss()
        } label: {
            HStack {
                Image("Rotate - Right")
                Text("Repeat")
                    .fontWeight(.semibold)
            }.fontWeight(.semibold)
                .foregroundStyle(Color.black)
                .frame(maxWidth: 340, maxHeight: 68)
                .background(Color.init(hex: "#D6DCFF"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.2), radius: 2, y: 4)
        }
    }
}
