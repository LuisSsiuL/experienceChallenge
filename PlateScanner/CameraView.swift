//
//  CameraView.swift
//  ExperienceChallenge
//
//  Created by Christian Luis Efendy on 10/05/25.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {
    @Binding var recognizedText: String
    @Binding var detectedImage: UIImage? // Declare the detected image binding here

    func makeCoordinator() -> CameraCoordinator {
        // Pass detectedImage to the CameraCoordinator
        CameraCoordinator(recognizedText: $recognizedText, detectedImage: $detectedImage)
    }

    func makeUIView(context: Context) -> UIView {
        let cameraView = CameraUIView()
        cameraView.setupCameraPreview(sessionDelegate: context.coordinator)
        return cameraView
    }

    func updateUIView(_ uiView: UIView, context: Context) { }
}
