//
//  create_plant_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import SwiftUI

struct CreatePlantView: View {
    @State private var plantName: String = ""
    @State private var plantType: String = ""
    @State private var plantDescription: String = ""
    @State private var plantImage: UIImage?
    @State private var isImagePickerDisplayed = false
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var plantViewModel: plant_viewmodel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Upload Image").font(.headline)) {
                    Button(action: {
                        self.isImagePickerDisplayed.toggle()
                    }) {
                        if let plantImage = plantImage {
                            Image(uiImage: plantImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section(header: Text("Plant Information").font(.headline)) {
                    TextField("Display name...", text: $plantName)
                    TextField("Type of plant...", text: $plantType)
                    TextField("Enter a description...", text: $plantDescription)
                }
                
                Button("Save Plant") {
                    // Here you would include the code to save the plant data
                    plantViewModel.savePlant(Plant(plant_name: plantName, plant_type: plantType, plant_description: plantDescription, plant_image: "Flower"))
                    plantViewModel.savePlantDatabase(Plant(plant_name: plantName, plant_type: plantType, plant_description: plantDescription, plant_image: "Flower"))
                    presentationMode.wrappedValue.dismiss() // Dismiss the view after saving the plant
                }
            }
            .navigationBarTitle("Add Plant Information", displayMode: .inline)
            .sheet(isPresented: $isImagePickerDisplayed) {
                ImagePicker(selectedImage: $plantImage)
            }
        }
    }
}

//I removed this, this preview provider is Deprecated (Noah)
// The preview provider
//struct AddPlantView_Previews: PreviewProvider {
//    @StateObject var viewModel = plant_viewmodel()
//    static var previews: some View {
//        CreatePlantView()
//            .environmentObject(viewModel)
//    }
//}

#Preview {
    CreatePlantView()
        .environmentObject(plant_viewmodel())
}

func saveImage(_ image: UIImage, withName name: String) {
    if let data = image.jpegData(compressionQuality: 0.8) {
        let filename = getDocumentsDirectory().appendingPathComponent("\(name).jpg")
        try? data.write(to: filename)
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
