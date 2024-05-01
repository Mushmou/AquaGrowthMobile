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
    @StateObject var plantViewModel = plant_viewmodel()
    @State private var isImagePickerDisplayed = false
    @State private var image: UIImage?
    
    @State private var name: String = ""
    @State private var type: String = ""
    @State private var description: String = ""
    
    @State private var showAlert = false
    @State private var showNavigationBar = true
    
    let plant: Plant
    let frameWidth: CGFloat = 360
    let frameHeight: CGFloat = 40
    let sectionFontSize: CGFloat = 28
    
    var changesMade: Bool {
        return !name.isEmpty || !type.isEmpty || !description.isEmpty
    }
    
    var saveChangesButtonColor: Color {
        return changesMade ? .green : .gray
    }
    
    var body: some View {
        NavigationStack{
            
            Color.clear.frame(width: 1, height:1)
                .navigationBarBackButtonHidden(true)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button (action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Cancel")
                                .font(.headline)
                        }
                    }
                    
                    // PLANT DELETION
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button (action: {
                            showAlert = true
                        }) {
                            Text("Delete")
                                .font(.headline)
                                .foregroundColor(.red)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Delete Plant?"),
                                message: Text("Are you sure you want to delete \(plant.plant_name)?"),
                                primaryButton: .default(
                                    Text("Cancel")
                                ),
                                secondaryButton: .destructive(Text("Delete")){
                                    plantViewModel.deletePlant(plant)
                                    presentationMode.wrappedValue.dismiss()
                                }
                            )
                        }
                    }
                }
            
            Spacer()
            VStack{
                Text("Editing \(plant.plant_name)")
                    .bold()
                    .font(.system(size: sectionFontSize))
                Button(action: {self.isImagePickerDisplayed.toggle()})
                {
                    if plant.plant_ui_image != nil {
                        Image(uiImage: plant.plant_ui_image!)
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
                    .frame(maxWidth: frameWidth, alignment: .leading)
                    .font(.system(size: sectionFontSize))
                
                TextField("\(plant.plant_name)", text: $name)
                    .padding(.horizontal)
                    .frame(width: frameWidth, height: frameHeight, alignment: .center)
                    .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                    .cornerRadius(12)
                    .textInputAutocapitalization(.never)
                
                
                Text("Plant Type")
                    .bold()
                    .frame(maxWidth: frameWidth, alignment: .leading)
                    .font(.system(size: 32))
                TextField("\(plant.plant_type)", text: $type)
                    .padding(.horizontal)
                    .frame(width: frameWidth, height: frameHeight, alignment: .center)
                    .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                    .cornerRadius(12)
                    .textInputAutocapitalization(.never)
                
                Text("Plant Description")
                    .bold()
                    .frame(maxWidth: frameWidth, alignment: .leading)
                    .font(.system(size: 32))
                TextField("\(plant.plant_description)", text: $description)
                    .padding(.horizontal)
                    .frame(width: frameWidth, height: frameHeight, alignment: .center)
                    .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                    .cornerRadius(12)
                    .textInputAutocapitalization(.never)
            }
            // UPDATE PLANT DATABASE
            Button(action: {
                plantViewModel.updatePlant(Plant(id: plant.id,
                                                 plant_name: updatedValue(newValue: name, oldValue: plant.plant_name),
                                                 plant_type: updatedValue(newValue: type, oldValue: plant.plant_type),
                                                 plant_description: updatedValue(newValue: description, oldValue: plant.plant_description),
                                                 plant_image: "Flower"))
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save Changes")
                    .foregroundColor(.white)
                    .frame(width: frameWidth, height: frameHeight, alignment: .center)
            }
            .disabled(!changesMade)
            .background(saveChangesButtonColor)
            .cornerRadius(12)
            .contentShape(Rectangle())
            .padding()
        }
        Spacer()
            .navigationBarBackButtonHidden(true)
        }
    }


#Preview {
    EditPlantView(plant: Plant(plant_name: "Akimbo Cacti", plant_type: "Cactus", plant_description: "My double prickly cactus", plant_image: "Flower"))
}

func updatedValue(newValue: String, oldValue: String) -> String {
    if !newValue.isEmpty {
        return newValue
    }
    return oldValue
}
