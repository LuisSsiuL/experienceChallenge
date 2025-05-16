//
//  EntryView.swift
//  ExperienceChallenge
//
//  Created by Christian Luis Efendy on 10/05/25.
//

import SwiftUI
import SwiftData

struct EntryView: View {

    // Props to accept the plate number and captured image from the PlateScannerView
    @Binding var plateNumber: String
    @Binding var plateImage: UIImage?
    @StateObject private var viewModel = objectEntryViewModel()
    @Environment(\.modelContext) var modelContext

    @Environment(\.dismiss) private var dismiss
    
    init(plateNumber: Binding<String>, plateImage: Binding<UIImage?>) {
            _plateNumber = plateNumber
            _plateImage = plateImage
            
            
            // Initialize the viewModel with the bound values
            _viewModel = StateObject(wrappedValue: objectEntryViewModel(
                initialPlateNumber: plateNumber.wrappedValue,
                initialImage: plateImage.wrappedValue,
            ))
        }

    enum Field: Hashable {
        case plateNumber
        case catatan
    }

    @FocusState private var focusedField: Field?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Captured Image Section
                    
                    // Plate Number Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Plat Nomor Kendaraan") + Text("*").foregroundColor(.red)
                        TextField("", text: $plateNumber)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .focused($focusedField, equals: .plateNumber)
                    }
                    
                    
                    // Vehicle Type Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Jenis kendaraan") + Text("*").foregroundColor(.red)
                        HStack(spacing: 15) {
                            vehicleTypeButton(type: .car, systemName: "car.fill")
                            vehicleTypeButton(type: .motorcycle, systemName: "motorcycle")
                            vehicleTypeButton(type: .others, systemName: "", label: "...")
                            Spacer()
                        }
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Foto Kendaraan")
                          

                        if let image = plateImage {
                            // Display the captured plate image
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(8)
                        } else {
                            // Placeholder for when no image is selected
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(UIColor.systemGray5))
                                    .frame(height: 200)
                                Text("Tidak Ada Foto")
                                    .foregroundColor(.gray)
                            }
                        }
                    }


                    // Categories Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Kategori Catatan") + Text("*").foregroundColor(.red)
                        Menu {
                            ForEach(viewModel.categoryOptions, id: \.self) { category in
                                Button(action: {
                                    viewModel.category = category
                                }) {
                                    Text(category)
                                }
                            }
                        } label: {
                            HStack {
                                Text(viewModel.category.isEmpty ? "Pilih Kategori" : viewModel.category)
                                    .foregroundColor(viewModel.category.isEmpty ? .gray : .primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        }
                    }

                    // Notes Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Catatan")
                        TextEditor(text: $viewModel.catatan)
                            .frame(minHeight: 180)
                            .padding(4)
                            .background(Color.white)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .focused($focusedField, equals: .catatan)
                    }

                    // Save Button
                    Button(action: {
                        viewModel.platNumber = plateNumber
                        viewModel.image = plateImage
                        
                        viewModel.saveEntry()
                        dismiss()
                    }) {
                        Text("Simpan")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
//                    .disabled(plateNumber.isEmpty || viewModel.category.isEmpty || viewModel.catatan.isEmpty)
                }
                .padding(.horizontal)
                .padding(.top)
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = nil // Dismiss the keyboard
                }
            }
            .navigationTitle("Catatan Baru")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .background(Color.white)
    }

    // Helper function for vehicle type buttons
    private func vehicleTypeButton(type: objectEntryViewModel.SelectedVehicleType, systemName: String, label: String? = nil) -> some View {
        Button(action: {
            viewModel.selectedVehicleType = type
        }) {
            if let label = label {
                Text(label)
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
                    .frame(width: 60, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(viewModel.selectedVehicleType == type ? Color.blue : Color.gray, lineWidth: 2)
                            .background(Color.white)
                    )
            } else {
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
                    .padding(15)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(viewModel.selectedVehicleType == type ? Color.blue : Color.gray, lineWidth: 2)
                            .background(Color.white)
                    )
            }
        }
    }
}

#Preview {
//    EntryView(plateNumber: "B1234ABC", plateImage: UIImage(named: "example"))
}
