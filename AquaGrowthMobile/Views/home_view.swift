//
//  home_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI



struct HomeView: View {
    @State private var isImagePickerDisplayed = false
    @State private var selectedUIImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                Group {
                    if let selectedUIImage = selectedUIImage {
                        Image(uiImage: selectedUIImage)
                            .resizable()
                            .scaledToFill()
                            .padding([.top,.bottom], 30)
                    } else {
                        Text("Tap to choose image")
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .background(Color.gray)
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 20, height: 200)
                .cornerRadius(20)
                .onTapGesture {
                    isImagePickerDisplayed = true
                }
                .navigationBarTitle("Home")
                .navigationBarTitleDisplayMode(.large)
                
                Spacer()
            }
            .sheet(isPresented: $isImagePickerDisplayed) {
                ImagePicker(selectedImage: $selectedUIImage)
            }
            .onAppear {
                loadSavedImage()
            }
        }
    }
    
    private func loadSavedImage() {
        if let imagePath = UserDefaults.standard.string(forKey: "savedImagePath"),
           let loadedImage = loadImageFromDocumentDirectory(name: imagePath) {
            self.selectedUIImage = loadedImage
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                let imageName = saveImageToDocumentDirectory(image: image)
                UserDefaults.standard.set(imageName, forKey: "savedImagePath")
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

    // Utility functions for saving and loading images from the document directory
func saveImageToDocumentDirectory(image: UIImage) -> String {
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let imageName = UUID().uuidString
    let imageUrl = documentDirectory.appendingPathComponent(imageName)
    if let imageData = image.jpegData(compressionQuality: 1) {
        try? imageData.write(to: imageUrl)
    }
    return imageName
}

func loadImageFromDocumentDirectory(name: String) -> UIImage? {
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let imageUrl = documentDirectory.appendingPathComponent(name)
    return UIImage(contentsOfFile: imageUrl.path)
}
