//
//  SettingsRowCell.swift
//  AnimalsTranslator
//
//  Created by Евгений Полтавец on 06/02/2025.
//

import SwiftUI

struct SettingsRowCell: View {
    let cell: SettingsRow
    
    var body: some View {
        HStack {
            Text(cell.rawValue)
            Spacer()
            Image("Icons")
        }
        .padding(.horizontal, 14)
        .fontWeight(.semibold)
        .foregroundStyle(Color.black)
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(Color.init(hex: "#D6DCFF"))
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .padding(.horizontal, 14)
    }
}

#Preview {
    SettingsRowCell(cell: SettingsRow.contactUs)
}
