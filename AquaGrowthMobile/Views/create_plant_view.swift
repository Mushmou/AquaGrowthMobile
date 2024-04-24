//
//  create_plant_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

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
                            plantViewModel.savePlant(Plant(plant_name: plantName, plant_type: plantType, plant_description: plantDescription, plant_image: "Flower",plant_ui_image: plantImage!))
                            plantViewModel.savePlantDatabase(Plant(plant_name: plantName, plant_type: plantType, plant_description: plantDescription, plant_image: "Flower",plant_ui_image: plantImage!))
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
    
    /// Uploads a new image to Firebase Storage and updates Firestore
    func uploadNewImage(selectedImage: UIImage) {
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        let path = "home_images/\(UUID().uuidString).jpg"
        let storageRef = Storage.storage().reference().child(path)
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard let _ = metadata, error == nil else {
                print("Error uploading image: \(error?.localizedDescription ?? "")")
                return
            }
            // Save a reference to Firestore
            self.saveImagePathToFirestore(path: path)
        }
    }
    
    /// Saves the image path to Firestore
    private func saveImagePathToFirestore(path: String) {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        db.collection("users").document(uid).collection("plant").document("").setData(["image_path": path])
    }
}


#Preview {
    CreatePlantView()
        .environmentObject(plant_viewmodel())
}
