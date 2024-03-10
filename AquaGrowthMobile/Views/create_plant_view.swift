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
                    savePlantData()
                }
            }
            .navigationBarTitle("Add Plant Information", displayMode: .inline)
            .sheet(isPresented: $isImagePickerDisplayed) {
                ImagePicker(selectedImage: $plantImage)
            }
        }
    }
    
    func savePlantData() {
        // Your code to save the data would go here.
        // This might involve writing to a database, saving to UserDefaults,
        // or sending the data to a server depending on your app's architecture.
    }
}
// The preview provider
struct AddPlantView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePlantView()
    }
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
