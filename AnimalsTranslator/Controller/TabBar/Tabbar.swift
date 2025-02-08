//
//  Tabbar.swift
//  AnimalsTranslator
//
//  Created by Евгений Полтавец on 06/02/2025.
//

import SwiftUI
enum TabbedItems: Int, CaseIterable{
    case translator = 0
    case clicker
    
    var title: String{
        switch self {
        case .translator:
            return "Translator"
        case .clicker:
            return "Clicker"

        }
    }
    
    var iconName: String{
        switch self {
        case .translator:
            return "messages-2"
        case .clicker:
            return  "Group"

        }
    }
}

struct Tabbar: View {
    
    @State private var selectedTab = 0

   
    var body: some View {

        ZStack(alignment: .bottom) {
            ZStack {
                TabView(selection: $selectedTab,
                        content:  {
                    AnimalsTranslatorMain()
                        .toolbarBackground(.hidden, for: .tabBar)
                        .tag(0)
                    AnimalsSettings()
                        .toolbarBackground(.hidden, for: .tabBar)
                        .tag(1)
                })
            }

            ZStack {
                HStack{
                    ForEach((TabbedItems.allCases), id: \.self) { item in
                            Button {
                                withAnimation(.linear(duration: 0.5)) {
                                    selectedTab = item.rawValue
                                }
                            } label: {
                                
                                CustomTabItem(imageName: item.iconName, title: item.title)
                            }
                    }
                }
                .padding(6)
            }
            .frame(height: 100)
            .background(.white)
            .clipShape(.rect(cornerRadius: 18))
            .padding(.horizontal, 26)
        }.ignoresSafeArea(.keyboard)
    }
}

extension Tabbar{
    func CustomTabItem(imageName: String, title: String) -> some View {
        VStack(spacing: 10){
            Image(imageName)
    
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
            
        }
        .frame(maxWidth: 110, maxHeight: 140)

    }
}

#Preview(body: {
    Tabbar()
})
