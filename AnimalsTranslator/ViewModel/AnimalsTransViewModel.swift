//
//  AnimalsTransViewModel.swift
//  AnimalsTranslator
//
//  Created by Евгений Полтавец on 07/02/2025.
//

import SwiftUI
import Combine

@MainActor
class AnimalsTransViewModel: ObservableObject {
    
    static var shared = AnimalsTransViewModel()
    
    @Published var levels: [CGFloat] = []
    
    
    @Published var isShowMassagePet: Bool = false
    @Published var isToggleVoice: Bool = false
    @Published var isShowLoader: Bool = false
    @Published var detectedMessage: String = ""
    @Published var noiseLevel: Float = 0.0
    @Published var detectedPet: String? = nil
    
    private let audioManager = RecordsAudioManager.shared
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        audioManager.$levels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newLevel in
                self?.levels = newLevel
            }
            .store(in: &cancellable)
        
        audioManager.$isShowMessageFromPat
            .receive(on: DispatchQueue.main)
            .sink { [weak self] finish in
                if finish {
                    DispatchQueue.main.async {
                    self?.isShowMassagePet = true
                    }
                }
            }
            .store(in: &cancellable)
        
        audioManager.$isToggleVoiceView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.isToggleVoice = false
              }
            }
            .store(in: &cancellable)
        
        audioManager.$isShowLoader
            .receive(on: DispatchQueue.main)
            .sink { [weak self] new in
            DispatchQueue.main.async {
                if new {
                    self?.isShowLoader = true
                }
              }
            }
            .store(in: &cancellable)
        
        SoundClassifier.shared.soundDetectionSubject
            .sink { [weak self] id, confidence in
                self?.handleSoundClassification(id: id, confidence: confidence)
            }
            .store(in: &cancellable)
        
        audioManager.$noiselevel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] noise in
            DispatchQueue.main.async {
                self?.noiseLevel = noise
              }
            }
            .store(in: &cancellable)
    }
    
    func startTranslatorPet() async {
      try? await Task.sleep(nanoseconds: 1_000_000)
      await RecordsAudioManager.shared.startRecording()
    }
    
    func handleSoundClassification(id: String, confidence: Double) {
        let messages: [String: String] = [
            "Meow": "I'm hungry feed me!",
            "Purr": "I'm happy",
            "Bark": "Human, what are you doing?",
            "Whine": "I miss you",
            "Talking": "Human talking",
            "Laughing": "Human laughing",
            "Cat": "Cat",
            "Dog": "Dog"
        ]
        DispatchQueue.main.async {[weak self] in
            guard let self else { return }
            if confidence < 0.7 || self.noiseLevel < -50.0 {
                self.detectedMessage = "Unknown sound"
           
            } else {
                let mappedID = id == "Cat" ? "Meow" : id == "Dog" ? "Bark" : id
                let message = messages[mappedID] ?? "Unknown sound"
                self.detectedPet = id == "Cat" ? "cat" : id == "Dog" ? "dog" : "Unknown"
                self.detectedMessage = message
    
            }
        }
    }
}
