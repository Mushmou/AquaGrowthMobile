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
    @State private var showAlert = false
    @State private var showNavigationBar = true
    var body: some View {
        NavigationStack{
            Color.clear.frame(width: 1, height:1)
                .navigationBarBackButtonHidden(true)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button (action: {
                            plantViewModel.savePlant(Plant(plant_name: plantName, plant_type: plantType, plant_description: plantDescription, plant_image: "Flower"))
                            plantViewModel.savePlantDatabase(Plant(plant_name: plantName, plant_type: plantType, plant_description: plantDescription, plant_image: "Flower"))
                            presentationMode.wrappedValue.dismiss() // Dismiss the view after saving the plant
                        }, label: {
                            Image(systemName: "checkmark")
                                .font(.system(size: 20)) // Adjust the size as needed
                                .foregroundColor(.black)
                        })
                    }
                }
            
            VStack(spacing: 0){
                Text("Create your plant")
                    .bold()
                    .font(.system(size: 32))
                    .padding(.bottom, 20)
                VStack(spacing: 0){
                    Button(action: {self.isImagePickerDisplayed.toggle()})
                    {
                        if let my_image = plantImage {
                            Image(uiImage: my_image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                                .clipShape(Circle())
                        } else {
                            Image("Upload")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 300)
                                .foregroundColor(.gray)
                                .clipShape(Circle())
                        }
                    }
                    .sheet(isPresented: $isImagePickerDisplayed) {
                        ImagePicker(selectedImage: $plantImage)
                    }
                }
            }
            
            VStack{
                VStack(spacing: 0){
                    Text("Plant Name")
                        .bold()
                        .frame(maxWidth: 360, alignment: .leading)
                        .font(.system(size: 32))
                    TextField("Display name...", text: $plantName)
                        .frame(width: 360, height: 60)
                        .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                        .cornerRadius(12)
                        .textInputAutocapitalization(.never)
                }
                
                VStack(spacing: 0){
                    Text("Plant Type")
                        .bold()
                        .frame(maxWidth: 360, alignment: .leading)
                        .font(.system(size: 32))
                    TextField(" Type of plant...", text: $plantType)
                        .frame(width: 360, height: 50, alignment: .center)
                        .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                        .cornerRadius(12)
                        .textInputAutocapitalization(.never)
                }
                
                VStack(spacing: 0){
                    Text("Plant Description")
                        .bold()
                        .frame(maxWidth: 360, alignment: .leading)
                        .font(.system(size: 32))
                    TextField(" Enter a description", text: $plantDescription)
                        .frame(width: 360, height: 50, alignment: .center)
                        .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                        .cornerRadius(12)
                        .textInputAutocapitalization(.never)
                }
            }
            Spacer()
                .navigationBarBackButtonHidden(true)
        }
    }
}

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
