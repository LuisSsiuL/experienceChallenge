//
//  PlateScannerView.swift
//  ExperienceChallenge
//
//  Created by Christian Luis Efendy on 10/05/25.
//

//
//  PlateScannerView.swift
//  ExperienceChallenge
//
//  Created by Christian Luis Efendy on 10/05/25.
//

import SwiftUI
import AVFoundation
import Vision

struct PlateScannerView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var plateNumber: String
    @Binding var plateImage: UIImage?

    @StateObject private var viewModel = PlateScannerViewModel()
    @State private var navigateToEntryView = false // Navigation state to EntryView

    var body: some View {
        NavigationStack {
            VStack {
                // Camera View
                CameraView(
                    recognizedText: $viewModel.recognizedText,
                    detectedImage: $viewModel.detectedPlateImage
                )
                .edgesIgnoringSafeArea(.all)

                // Recognized Text Display
                Text("Plat Nomor Terdeteksi:")
                    .padding(.top)
                    .foregroundColor(.white)

                Text(viewModel.recognizedText)
                    .padding([.horizontal, .bottom])
                    .foregroundColor(.white)
                    .font(.headline)

                // Process Button
                Button(action: {
                    viewModel.processRecognitionResult {
                        // Pass plate data and navigate to EntryView
                        plateNumber = viewModel.presentedText
                        plateImage = viewModel.detectedPlateImage
                        
                        navigateToEntryView = true // Trigger navigation
                    }
                }) {
                    Image(systemName: "inset.filled.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                }
                .alert(isPresented: $viewModel.isPresentedPlateNotDetected) {
                    Alert(
                        title: Text("Plat Tidak Terdeteksi"),
                        message: Text("Arahkan kamera ke plat nomor kendaraan"),
                        dismissButton: .default(Text("Coba Lagi"))
                    )
                }
                
                Spacer()
            }
            .background(Color.black)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        exit(0)
                    }
                    .tint(.white)
                }
            }
            .navigationDestination(isPresented: $navigateToEntryView) {
                EntryView(plateNumber: $plateNumber, plateImage: $plateImage)
            }
        }
    }
}

#Preview {
    PlateScannerView(plateNumber: .constant(""), plateImage: .constant(nil))
}
