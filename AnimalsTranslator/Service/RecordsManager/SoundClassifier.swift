//
//  SoundClassifier.swift
//  AnimalsTranslator
//
//  Created by Евгений Полтавец on 07/02/2025.
//

import SoundAnalysis
import AVFoundation
import Combine

class SoundClassifier: NSObject, SNResultsObserving {
    
    static var shared = SoundClassifier()
    
    private let analyzer = SNAudioStreamAnalyzer(format: AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!)
    private var request: SNClassifySoundRequest?
    
    let soundDetectionSubject = PassthroughSubject<(String, Double), Never>()
    
    override init() {
        super.init()
        do {
            let model = try PetClassification(configuration: .init())
            request = try SNClassifySoundRequest(mlModel: model.model)
            try analyzer.add(request!, withObserver: self)
        } catch {
            print("Ошибка загрузки модели: \(error)")
        }
    }

    func analyze(buffer: AVAudioPCMBuffer, time: AVAudioTime) {
        analyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
    }

    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult else { return }

        if let classification = result.classifications.first {
            let detected = classification.identifier
            let confidence = classification.confidence
            soundDetectionSubject.send((detected, confidence))
        } else {
            print("❌")
        }
    }
}
