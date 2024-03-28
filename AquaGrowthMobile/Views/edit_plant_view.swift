//
//  edit_plant_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI
import PhotosUI

struct EditPlantView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var plantViewModel: plant_viewmodel
    @State private var isImagePickerDisplayed = false
    @State private var image: UIImage?
    
    @State private var name: String = ""
    @State private var type: String = ""
    @State private var description: String = ""
    
    @State private var showAlert = false
    @State private var showNavigationBar = true
    
    var plant: Plant
    
    var body: some View {
        NavigationStack{
            
            Color.clear.frame(width: 1, height:1)
                .navigationBarBackButtonHidden(true)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button (action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 30)) // Adjust the size as needed
                                .foregroundColor(.black)
                        })
                        .onTapGesture {
                            withAnimation {
                                showNavigationBar.toggle()
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button (action: {
                            showAlert = true
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30)) // Adjust the size as needed
                                .foregroundColor(.black)
                        })
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Delete Plant?"),
                                message: Text("Are you sure you want to delete \(plant.plant_name)?"),
                                primaryButton: .default(
                                    Text("Cancel")
                                ),
                                secondaryButton: .destructive(
                                    Text("Delete")
                                )
                            )
                        }
                    }
                }
            
            Spacer()
            Text("Editing \(plant.plant_name)")
                .bold()
                .font(.system(size: 32))
            VStack{
                Button(action: {self.isImagePickerDisplayed.toggle()})
                {
                    if let my_image = image {
                        Image(uiImage: my_image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "photo.circle.fill")
                            .resizable()
                            .frame(width: 250, height: 300)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                    }
                }
                .sheet(isPresented: $isImagePickerDisplayed) {
                    ImagePicker(selectedImage: $image)
                }
            }
            
            VStack{
                Text("Plant Name")
                    .bold()
                    .frame(maxWidth: 360, alignment: .leading)
                    .font(.system(size: 32))
                
                TextField("\(plant.plant_name)", text: $name)
                    .padding(.horizontal)
                    .frame(width: 360, height: 50, alignment: .center)
                    .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                    .cornerRadius(12)
                    .textInputAutocapitalization(.never)
                
                
                Text("Plant Type")
                    .bold()
                    .frame(maxWidth: 360, alignment: .leading)
                    .font(.system(size: 32))
                TextField("\(plant.plant_type)", text: $type)
                    .padding(.horizontal)
                    .frame(width: 360, height: 50, alignment: .center)
                    .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                    .cornerRadius(12)
                    .textInputAutocapitalization(.never)
                
                Text("Plant Description")
                    .bold()
                    .frame(maxWidth: 360, alignment: .leading)
                    .font(.system(size: 32))
                TextField("\(plant.plant_description)", text: $description)
                    .padding(.horizontal)
                    .frame(width: 360, height: 50, alignment: .center)
                    .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                    .cornerRadius(12)
                    .textInputAutocapitalization(.never)
            }
            Spacer()
                .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    EditPlantView(plant: Plant(plant_name: "Akimbo Cacti", plant_type: "Cactus", plant_description: "My double prickly cactus", plant_image: "Flower"))
}
