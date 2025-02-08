//
//  RecordVoice.swift
//  AnimalsTranslator
//
//  Created by Евгений Полтавец on 06/02/2025.
//

import SwiftUI

struct RecordVoice: View {
    
    @StateObject var animalsVM: AnimalsTransViewModel
    @Binding var selectedPet: String?
    
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 18) {
                VStack {
                    if animalsVM.isToggleVoice {
                        Button(action: {}, label: {
                            VStack(spacing: 22) {
                                AudioVisualizerView(levels: animalsVM.levels)
                                Text("Recording...")
                                    .foregroundStyle(Color.black)
                            }
                        })
                        .transition(.opacity)
                    } else {
                        Button(action: {
                            withAnimation(.snappy(duration: 0.6)) {
                               animalsVM.isToggleVoice = true
                            }
                            Task {
                             await animalsVM.startTranslatorPet()
                            }
                        }, label: {
                            VStack {
                                Image("microphone-2")
                                Text("Start Speak")
                            }.fontWeight(.medium)
                                .foregroundStyle(Color.black)
                        })
                        .transition(.opacity)
                    }
                }.frame(maxWidth: .infinity, maxHeight: 180)
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 24))
                    .shadow(color: Color.black.opacity(0.3), radius: 6)
                    .transition(.opacity)
                Spacer()
                
                VStack(alignment: .center, spacing: -50) {
                    Button(action: {
                        selectedPet = "cat"
                    }, label: {
                        Image("Frame 200")
                    })
                    Button(action: {
                        selectedPet = "dog"
                    }, label: {
                        Image("Frame 198")
                    })
                    Spacer(minLength: 70)
                }.frame(maxWidth: 110, maxHeight: 180)
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 24))
                    .shadow(color: Color.black.opacity(0.3), radius: 6)
                
            }.padding(.horizontal, 32)
        }.frame(maxWidth: .infinity)
    }
}
