//
//  AnimalsTranslatorMain.swift
//  AnimalsTranslator
//
//  Created by Евгений Полтавец on 06/02/2025.
//

import SwiftUI


struct AnimalsTranslatorMain: View {
    
    
    @StateObject private var animalsTransVM = AnimalsTransViewModel()
    
    @State private var isProccessOfTran: Bool = false
    @State private var selectedPet: String? = nil
    @State private var text: String = "Translating the voice"
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .center, spacing: 20) {
                    VStack(spacing: 68) {
                        if animalsTransVM.isShowLoader {
                          
                        } else {
                            HumanOrPet()
                            RecordVoice(animalsVM: animalsTransVM, selectedPet: $animalsTransVM.detectedPet)
                        }

                    }
                    Spacer()
                }
                .sheet(isPresented: $animalsTransVM.isShowMassagePet) {
                    TranslateResultsView(animalVM: animalsTransVM)
                        .onAppear {
                            animalsTransVM.isShowLoader = false
                    }
                }
            }.createBackgrounfFon()
                .overlay(alignment: .bottom, content: {
                    VStack(spacing: 80) {
                        Text(animalsTransVM.isShowLoader ? "Proces of translation..." : "")
                            .foregroundStyle(Color.black)
                            .fontWeight(.semibold)
                        VStack(spacing: 0) {
                            if animalsTransVM.detectedPet == "cat" {
                                Image("cat 2")
                            } else if animalsTransVM.detectedPet == "dog" {
                                Image("cat 1")
                            }
                        }
                      
                    }.padding(.bottom, 90)
                })
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text("Translator")
                        .foregroundStyle(Color.black)
                        .font(.system(size: 30, weight: .bold))
                }
            })
        }
    }
}

#Preview {
    AnimalsTranslatorMain()
}
