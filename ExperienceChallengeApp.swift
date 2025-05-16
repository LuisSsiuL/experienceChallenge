//
//  ExperienceChallengeApp.swift
//  ExperienceChallenge
//
//  Created by Christian Luis Efendy on 09/05/25.
//
import SwiftUI

@main
struct ExperienceChallengeApp: App {
    @State private var plateNumber: String = ""
    @State private var plateImage: UIImage? = nil
    @State private var isDeepLinkActive = false // Track if deep link is active
    @Environment(\.modelContext) var modelContext
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isDeepLinkActive {
                    PlateScannerView(plateNumber: $plateNumber, plateImage: $plateImage).modelContainer(for: [Car.self] )
                } else {
                    // If you don't have a main screen, you can directly set the PlateScannerView
                    PlateScannerView(plateNumber: $plateNumber, plateImage: $plateImage).modelContainer(for: [Car.self]) 
                }
            }
            .onOpenURL { url in
                handleDeepLink(url)
            }
        }
    }
    
    // Handle the deep link
    private func handleDeepLink(_ url: URL) {
        if url.scheme == "experiencechallenge" {
            if url.host == "scanplate" {
                isDeepLinkActive = true // Trigger navigation to PlateScannerView
            }
        }
    }
}
