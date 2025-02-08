//
//  RecordsAudioManager.swift
//  AnimalsTranslator
//
//  Created by Евгений Полтавец on 07/02/2025.
//

import SwiftUI
import AVFoundation

@MainActor
class RecordsAudioManager: ObservableObject {
    
    static let shared = RecordsAudioManager()
    
    private let soundClassifier = SoundClassifier()
    private let audioEngine = AVAudioEngine()
    private var audioRecorder: AVAudioRecorder?
    private var audioSession = AVAudioSession.sharedInstance()
    var audioPlayer: AVAudioPlayer?
    
    
    private var audioData: Data?

    @Published var message: String = ""
    @Published var isShowMessageFromPat = false
    @Published var isShowLoader = false
    @Published var isToggleVoiceView = false
    @Published var levels: [CGFloat] = []
    @Published var noiselevel: Float = 0.0
    
    @Published var audioFileURL: URL?
    @Published var progress: Float = 0.0
    @Published var currentTime: TimeInterval = 0.0
    @Published var duration: TimeInterval = 0.0
    @Published var selectedRecords: String? = nil
    @Published var recordDurationTimer: Double = 5
    @Published var timer: Timer?
    @Published var timerDurationAnalize: Timer?
    
    
    init() {
        Task {
            await requestPermission()
        }
    }
    
    
    private func requestPermission() async {
        if #available(iOS 17.0, *) {
            let granted = await AVAudioApplication.requestRecordPermission()
            if !granted {
                print("❌ Доступ запрещен, отправляем в настройки")
                redirectToSettings()
            } else {
                print("✅ Доступ разрешен")
            }
        } else {
            let granted = await withCheckedContinuation { continuation in
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    continuation.resume(returning: granted)
                }
            }
            if !granted {
                print("❌ Доступ запрещен, отправляем в настройки")
                redirectToSettings()
            } else {
                print("✅ Доступ разрешен")
            }
        }
    }

    private func redirectToSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
    }

    
    func startRecording() async {
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .mixWithOthers, .overrideMutedMicrophoneInterruption])
            try audioSession.setActive(true, options: [.notifyOthersOnDeactivation])
        } catch {
            print("Error settings audio \(error.localizedDescription)")
            stopAudioIfError()
            message = error.localizedDescription
            
        }
        
        let fileName = UUID().uuidString + ".m4a"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent(fileName)
        print("Save file in, \(fileURL.path)")
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderBitRateKey: 64000,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
    
            audioFileURL = fileURL
            startUpdatetingMeters()
            startAudioEngine()
            startTimer()
        } catch {
            stopAudioIfError()
            message = error.localizedDescription
            print("Error start record \(error.localizedDescription)")
        }
    }
    
    private func startAudioEngine() {
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        
        inputNode.removeTap(onBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, time in
            guard let self else { return }
            self.soundClassifier.analyze(buffer: buffer, time: time)
        }
        do {
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("Error launch audioEngine:", error.localizedDescription)
        }
    }
    private func startTimer() {
        timerDurationAnalize?.invalidate()
        timerDurationAnalize = Timer.scheduledTimer(withTimeInterval: recordDurationTimer, repeats: false, block: { [weak self] _ in
            guard let self else { return }
            Task {
                await self.stopRecording()
            }
        })
    }
    
    func stopRecording() async {
        timer?.invalidate()
        timer = nil
        timerDurationAnalize?.invalidate()
        timerDurationAnalize = nil
        
        audioRecorder?.stop()
        audioRecorder = nil
        audioPlayer = nil
        
        do {
            if audioSession.isInputAvailable {
                try audioSession.setActive(false)
                print("Audio session deactivated successfully")
            } else {
                print("Audio session is already inactive")
            }
        } catch {
            print("Error deactivating audio session: \(error.localizedDescription)")
        }
 
        if let fileURL = audioFileURL {
            do {
                let audioData = try Data(contentsOf: fileURL)
                if !audioData.isEmpty {
                    analizeSounds(fileURL: fileURL)
 
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.isShowMessageFromPat = true
                        self.isToggleVoiceView = false
                        self.isShowLoader = true
                        self.objectWillChange.send()
                    }
                } else {
                    print("Audio file is empty", fileURL.absoluteString)
                }
            } catch {
                print("Error loading audio file: \(error.localizedDescription)")
            }
        } else {
            print("No audio file to process")
        }
    }

    private func analizeSounds(fileURL: URL) {
        let soundClassifier = SoundClassifier.shared
        
        do {
            let file = try AVAudioFile(forReading: fileURL)
            
            guard let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length)) else {
                print("Error creating buffer...")
                return
            }
            
            try file.read(into: buffer)
            
            let time = AVAudioTime(sampleTime: 0, atRate: file.fileFormat.sampleRate)
            soundClassifier.analyze(buffer: buffer, time: time)
        } catch {
            print("Error analyzing sounds: \(error.localizedDescription)")
        }
    }
    
    private func startUpdatetingMeters() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                guard let recorder = self.audioRecorder else { return }
                recorder.updateMeters()
                self.noiselevel = recorder.averagePower(forChannel: 0)
                print("noise level: ", self.noiselevel)
              
                let minDb: Float = -80
                let maxDb: Float = 0
                let currentPower = recorder.averagePower(forChannel: 0)
                let normalized = max(0, min(1, (currentPower - minDb) / (maxDb - minDb)))
                
                let newLevel = CGFloat(normalized) * 100
                self.levels.append(newLevel)
                if self.levels.count > 20 {
                    self.levels.removeFirst()
                }
            }
        }
    }
    
    func stopAudioIfError() {
        timer?.invalidate()
        timerDurationAnalize?.invalidate()
        timerDurationAnalize = nil
        timer = nil
        audioRecorder = nil
   
    }
}
