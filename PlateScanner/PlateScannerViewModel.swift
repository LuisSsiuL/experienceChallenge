//
//  PlateScannerViewModel.swift
//  ExperienceChallenge
//
//  Created by Christian Luis Efendy on 10/05/25.
//

import SwiftUI
import AVFoundation
import Vision

class PlateScannerViewModel: ObservableObject {

    @Published var recognizedText: String = "Menunggu hasil scan..."
    @Published var presentedText: String = "Tidak terdeteksi plat"
    @Published var detectedPlateImage: UIImage?
    @Published var isPresentedPlateDetected: Bool = false
    @Published var isPresentedPlateNotDetected: Bool = false

    // Add a trailing closure parameter
    func processRecognitionResult(completion: (() -> Void)? = nil) {
        presentedText = recognizedText

        if presentedText == "Menunggu hasil scan..." || presentedText == "Tidak terdeteksi plat" {
            isPresentedPlateNotDetected = true
        } else {
            isPresentedPlateDetected = true
            completion?() // If a trailing closure is provided, execute it
        }
    
    }
}
