//
//  CameraUIView.swift
//  ExperienceChallenge
//
//  Created by Christian Luis Efendy on 10/05/25.
//


import SwiftUI
import AVFoundation
import Vision

class CameraUIView: UIView {
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    func setupCameraPreview(sessionDelegate: AVCaptureVideoDataOutputSampleBufferDelegate) {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoDeviceInput: AVCaptureDeviceInput
        
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession?.canAddInput(videoDeviceInput) == true {
            captureSession?.addInput(videoDeviceInput)
        } else {
            return
        }
        
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.setSampleBufferDelegate(sessionDelegate, queue: DispatchQueue(label: "camera-preview"))
        
        if captureSession?.canAddOutput(videoDataOutput) == true {
            captureSession?.addOutput(videoDataOutput)
        } else {
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.frame = bounds
        previewLayer?.videoGravity = .resizeAspectFill
        if let preview = previewLayer {
            layer.addSublayer(preview)
        }
        
        captureSession?.startRunning()
        print("Capture session started")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
}
