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

    @State private var name: String = "Plant name"
    @State private var type: String = "Plant type"
    @State private var description: String = "Plant description"

    var body: some View {
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
                    Image(systemName: "photo.on.rectangle.angled")
                        .resizable()
                        .frame(height: 250)
                        .foregroundColor(.gray)
                        .border(.red)
                        .clipShape(Circle())
                }
            }
            .sheet(isPresented: $isImagePickerDisplayed) {
                ImagePicker(selectedImage: $image)
            }
        }.border(.red)
        
        VStack{
            Text("Plant Name")
            TextField("Change name", text: $name)
            Text("Plant Type")
            TextField("Change type", text: $type)
            Text("Plant Description")
            TextField("Change description", text: $description)


        }
        Spacer()
    }
}

#Preview {
    EditPlantView()
}
