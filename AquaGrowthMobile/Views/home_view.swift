import Foundation
import SwiftUI



/// SwiftUI View for the Home Screen
struct HomeView: View {
    // State to hold the selected image
    @State private var isImagePickerDisplayed = false
    @State private var selectedUIImage: UIImage?
    
    /// Displays the content of the view.
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
    
    /// Load the previously saved image from UserDefaults.
    private func loadSavedImage() {
        if let imagePath = UserDefaults.standard.string(forKey: "savedImagePath"),
           let loadedImage = loadImageFromDocumentDirectory(name: imagePath) {
            self.selectedUIImage = loadedImage
        }
    }
}

/// Coordinator to handle communication between SwiftUI and UIKit
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    /// Creates and configures the UIImagePickerController.
    /// - Parameter context: The context in which this view was created.
    /// - Returns: The configured UIImagePickerController.
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    /// Updates the UIImagePickerController.
    /// - Parameters:
    ///   - uiViewController: The UIImagePickerController to update.
    ///   - context: The context for this view.
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    /// Creates and returns the coordinator for this view.
    /// - Returns: The coordinator for this view.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// Coordinator class to handle image picking events
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        /// Handles the selection of an image.
        /// - Parameters:
        ///   - picker: The UIImagePickerController.
        ///   - info: A dictionary containing the original image.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                let imageName = saveImageToDocumentDirectory(image: image)
                UserDefaults.standard.set(imageName, forKey: "savedImagePath")
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        /// Handles the cancellation of image picking.
        /// - Parameter picker: The UIImagePickerController.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}

/// Utility functions for saving and loading images from the document directory
func saveImageToDocumentDirectory(image: UIImage) -> String {
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let imageName = UUID().uuidString
    let imageUrl = documentDirectory.appendingPathComponent(imageName)
    if let imageData = image.jpegData(compressionQuality: 1) {
        try? imageData.write(to: imageUrl)
    }
    return imageName
}

/// Load an image from the document directory.
/// - Parameter name: The name of the image file.
/// - Returns: The loaded UIImage.
func loadImageFromDocumentDirectory(name: String) -> UIImage? {
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let imageUrl = documentDirectory.appendingPathComponent(name)
    return UIImage(contentsOfFile: imageUrl.path)
}



//import SwiftUI
//import UIKit
//
///// SwiftUI View for the Home Screen
//struct HomeView: View {
//    // State to hold the selected image
//    @State private var selectedImage: UIImage? = nil
//    // State to control whether the image picker is shown
//    @State private var isShowingImagePicker = false
//
//    /// Displays the content of the view.
//    var body: some View {
//        ZStack {
//            // Display the selected image if available
//            if let image = selectedImage {
//                GeometryReader { geometry in
//                    Image(uiImage: image)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.33)
//                        .clipped()
//                        .cornerRadius(20) // Apply corner radius to the image
//                        .shadow(radius: 5)
//                        .padding(.horizontal, (geometry.size.width - (geometry.size.width * 0.90)) / 2) // Add horizontal padding to center the image
//                }
//                .edgesIgnoringSafeArea(.top)
//            }
//
//            VStack {
//                if selectedImage == nil {
//        
//                    Button(action: {
//                        self.isShowingImagePicker.toggle()
//                    }) {
//                        Image(systemName: "photo")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 315, height: 185)
//                            .padding()
//                            .background(Color.white)
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                            .shadow(radius: 5)
//                    }
//                    .padding()
//                }
//
//                Spacer()
//
//            }
//
//            VStack {
//                // Button to select a new image
//                Button(action: {
//                    self.isShowingImagePicker.toggle()
//                }) {
//                    Text("Select New Image")
//                        .foregroundColor(.blue)
//                        .padding(.horizontal, 10) // Add horizontal padding
//                        .padding(.vertical, 10) // Add vertical padding
//                        .background(Color.white)
//                        .cornerRadius(8) // Reduce corner radius
//                        .font(.subheadline) // Set smaller font size
//                        .shadow(radius: 3) // Reduce shadow radius
//                }
//                .padding(.bottom)
//
//                
//            }
//
//
//
//
//
//        }
//        .padding(.top) // Add padding to the top to push the image input box to the top
//        .sheet(isPresented: $isShowingImagePicker) {
//            ImagePicker(selectedImage: self.$selectedImage, isPresented: self.$isShowingImagePicker)
//        }
//    }
//}
//
///// SwiftUI View for displaying a preview of the Home Screen
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
//
///// Coordinator to handle communication between SwiftUI and UIKit
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage? // Binding to update the selected image
//    @Binding var isPresented: Bool // Binding to control the presentation of the image picker
//
//    /// Creates and configures the UIImagePickerController.
//    /// - Parameter context: The context in which this view was created.
//    /// - Returns: The configured UIImagePickerController.
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator // Set the coordinator as the delegate
//        return picker
//    }
//
//    /// Updates the UIImagePickerController.
//    /// - Parameters:
//    ///   - uiViewController: The UIImagePickerController to update.
//    ///   - context: The context for this view.
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
//    }
//
//    /// Creates and returns the coordinator for this view.
//    /// - Returns: The coordinator for this view.
//    func makeCoordinator() -> Coordinator {
//        Coordinator(parent: self)
//    }
//
//    /// Coordinator class to handle image picking events
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        let parent: ImagePicker
//
//        init(parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        /// Handles the selection of an image.
//        /// - Parameters:
//        ///   - picker: The UIImagePickerController.
//        ///   - info: A dictionary containing the original image.
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            // Check if the selected item is an image
//            if let image = info[.originalImage] as? UIImage {
//                // Update the selected image in the parent view
//                parent.selectedImage = image
//                // Dismiss the image picker
//                parent.isPresented = false
//            }
//        }
//    }
//}
