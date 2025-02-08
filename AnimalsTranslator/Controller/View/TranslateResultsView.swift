//
//  TranslateResultsView.swift
//  AnimalsTranslator
//
//  Created by Евгений Полтавец on 06/02/2025.
//

import SwiftUI

struct TranslateResultsView: View {
    
    @Environment (\.dismiss) var dismiss
    @ObservedObject var animalVM: AnimalsTransViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 120) {
                    if animalVM.detectedMessage == "Unknown sound" {
                        RepeatCell(animalVM: animalVM) {
                            animalVM.isToggleVoice = true
                            dismiss()
                        }
                    } else {
                        TranslateMessagePetCell(animalVM: animalVM)
                    }
                    if animalVM.detectedPet == "cat" {
                        Image("cat 2")
                    } else if animalVM.detectedPet == "dog" {
                        Image("cat 1")
                    }
                }
            }.createBackgrounfFon()
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Text("Results")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundStyle(Color.black)
                        }
                    }
                    ToolbarItem(placement: .navigation) {
                        HStack {
                            Button(action: {dismiss()}, label: {
                                Image("more")
                            })
                        }.padding(.top, 40)
                            .padding(.leading, -14)
                    }
                })
            
        }
    }
}
