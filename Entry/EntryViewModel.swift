import Foundation
import SwiftUI
import SwiftData
import UIKit
import PhotosUI

class objectEntryViewModel: ObservableObject {
    @Environment(\.modelContext) var modelContext
    @Query var cars: [Car]
    
    @Published var platNumber: String = "B 2345 C"
    @Published var image: UIImage? = nil
    @Published var catatan: String = ""
    @Published var category: String = "Parkir Sembarangan"
    @Published var selectedVehicleType: SelectedVehicleType = .car
    
    // Move category options to the ViewModel
    let categoryOptions = ["Parkir Sembarangan", "Kerusakan", "Kehilangan", "Lainnya"]
    
    init(initialPlateNumber: String = "", initialImage: UIImage? = nil) {
        self.platNumber = initialPlateNumber
        self.image = initialImage
        
        // Pre-fill the plate number in the view model
        if !initialPlateNumber.isEmpty {
            self.platNumber = initialPlateNumber
        }
    }
    
    enum SelectedVehicleType: String {
        case car
        case motorcycle
        case others
    }
    
    func saveEntry() {
        let trimmedPlate = platNumber.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let imageDataToSave = image?.jpegData(compressionQuality: 0.7)

        if let existingCar = cars.first(where: { $0.plate.uppercased() == trimmedPlate }) {
            let newEntry = Entry(category: category,
                                time: Date.now,
                                note: catatan)
            
            if let imageData = imageDataToSave {
                newEntry.image = imageData
            }
            
            existingCar.entry.append(newEntry)
            try? modelContext.save()
        } else {
            let newCar = Car(plate: trimmedPlate, type: selectedVehicleType.rawValue)
            let newEntry = Entry(category: category,
                                time: Date.now,
                                note: catatan)
            
            if let imageData = imageDataToSave {
                newEntry.image = imageData
            }
            
            newCar.entry.append(newEntry)
            modelContext.insert(newCar)
            try? modelContext.save()
        }
    }
}
