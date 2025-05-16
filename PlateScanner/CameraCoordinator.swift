//
//  CameraCoordinator.swift
//  ExperienceChallenge
//
//  Created by Christian Luis Efendy on 10/05/25.
//

import SwiftUI
import AVFoundation
import Vision

class CameraCoordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {

    @Binding var recognizedText: String
    @Binding var detectedImage: UIImage?

    init(recognizedText: Binding<String>, detectedImage: Binding<UIImage?>) {
        _recognizedText = recognizedText
        _detectedImage = detectedImage
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // Process text recognition on the detected frame
        recognizeText(in: pixelBuffer)
        
        // Create a better quality UIImage from the buffer
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            // Create UIImage with correct orientation
            let uiImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .right) // Adjust orientation here
            
            DispatchQueue.main.async {
                self.detectedImage = uiImage
            }
        }
    }

    private func recognizeText(in image: CVPixelBuffer) {
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: image, options: [:])
        
        let textRecognitionRequest = VNRecognizeTextRequest { [weak self] request, error in
            guard let results = request.results as? [VNRecognizedTextObservation],
                  let self = self else { return }
            
            if let bestObservation = results.first,
               let candidate = bestObservation.topCandidates(1).first {
                DispatchQueue.main.async {
                    self.recognizedText = candidate.string
                }
            } else {
                DispatchQueue.main.async {
                    self.recognizedText = "Tidak terdeteksi plat"
                }
            }
        }

        do {
            try requestHandler.perform([textRecognitionRequest])
        } catch {
            print("Failed to perform text recognition: $error.localizedDescription)")
        }
    }
}
