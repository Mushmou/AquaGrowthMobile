import Foundation
import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
/// SwiftUI View for the Home Screen


struct HomeView: View {
    // State to hold the selected image
    @State private var isImagePickerDisplayed = false
    @State private var isImagePickerDisplayedCircle = false
    @State private var selectedUIImage: UIImage?
    @State private var isInfoWindowPresented = false
    @State private var selectedCircleImage: UIImage?
    @State private var isLoading = false
    

    
    var body: some View {
        NavigationView {
            VStack {
                Group {
                    if isLoading {
                        // Display a loading indicator while the image is being fetched
                        ProgressView("Loading")
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(1.5)
                            .padding()
                    }
                    else if selectedUIImage != nil{
                        Image(uiImage: selectedUIImage!)
                            .resizable()
                            .scaledToFill()
                            .padding([.top,.bottom], 30)
                        
                    }
                    else {
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
                
                HStack {
                    
                    Text("Today") // Add your text aligned to the left
                        .padding(.top, 10)
                        .foregroundColor(.black) // Customize text color
                        .font(.system(size: 30, weight: .bold)) // Adjust font size and weight as needed
                        .padding(.leading, 1) // Adjust leading padding if needed
                    
                    Spacer()
                    
                    Button(action: {
                        // Set the state to true to present the info window
                        isInfoWindowPresented.toggle()
                    }) {
                        Image(systemName: "info.circle") // Example of a button with a plus icon
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30) // Adjust size as needed
                            .foregroundColor(.black) // Customize button color
                    }
                    .padding(.trailing, 18)
                }
                .padding(.bottom, 20)
                
                .sheet(isPresented: $isImagePickerDisplayed) {
                    ImagePicker(selectedImage: $selectedUIImage)
                    
                }.onChange(of: isImagePickerDisplayed) { newValue in
                    if !newValue { // newValue is false when the sheet is dismissed
                        print("Image Picker was dismissed.")
                        replaceExistingImage(selectedImage: selectedUIImage!)
                    }
                }
                  .onAppear {
                      loadImageFromFirebase()
                  }
                
                // Three buttons centered vertically
                VStack {
                    
                    Button(action: {
                        // Action for the first button
                    }) {
                        ZStack {
                            // Background of the button
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.gray.opacity(0.1))
                                .frame(maxWidth: .infinity)
                                .frame(height: 80) // Adjust height as needed
                            
                            // Image overlay
                            Image("Sun - Bright")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50) // Adjust size of the image as needed
                                .padding(.trailing, 150) // Adjust padding around the image as needed
                                .offset(x: 7, y: 1) // Adjust position of the image relative to the button as needed
                            
                            // Image overlay
                            Image("Water - Bright")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70) // Adjust size of the image as needed
                                .padding(.leading) // Adjust padding around the image as needed
                                .offset(x: 7, y: 1) // Adjust position of the image relative to the button as needed
                            
                            
                            // Image overlay
                            Image("Humidity - Bright")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60) // Adjust size of the image as needed
                                .padding(.leading, 180) // Adjust padding around the image as needed
                                .offset(x: 7, y: 1) // Adjust position of the image relative to the button as needed
                            
                            // Circular image input
                            Image(systemName: "camera.circle.fill") // You can replace this with your image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                                .frame(width: 60, height: 60)
                                .offset(x: -140, y: 0)
                                .onTapGesture {
                                    isImagePickerDisplayedCircle.toggle()
                                }
                                .sheet(isPresented: $isImagePickerDisplayedCircle) {
                                    ImagePicker(selectedImage: $selectedCircleImage)
                                }
                        }
                        .cornerRadius(20)
                    }

                    
                    
                    
                    Spacer().frame(height: 25) // Add space between buttons

                    Button(action: {
                        // Action for the first button
                    }) {
                        ZStack {
                            // Background of the button
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.gray.opacity(0.1))
                                .frame(maxWidth: .infinity)
                                .frame(height: 80) // Adjust height as needed
                            
                            // Image overlay
                            Image("Sun - Bright")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50) // Adjust size of the image as needed
                                .padding(.trailing, 150) // Adjust padding around the image as needed
                                .offset(x: 7, y: 1) // Adjust position of the image relative to the button as needed
                            
                            // Image overlay
                            Image("Water - Bright")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70) // Adjust size of the image as needed
                                .padding(.leading) // Adjust padding around the image as needed
                                .offset(x: 7, y: 1) // Adjust position of the image relative to the button as needed
                            
                            
                            // Image overlay
                            Image("Humidity - Bright")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60) // Adjust size of the image as needed
                                .padding(.leading, 180) // Adjust padding around the image as needed
                                .offset(x: 7, y: 1) // Adjust position of the image relative to the button as needed
                            
                            // Circular image input
                            Image(systemName: "camera.circle.fill") // You can replace this with your image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                                .frame(width: 60, height: 60)
                                .offset(x: -140, y: 0)
                                .onTapGesture {
                                    isImagePickerDisplayedCircle.toggle()
                                }
                                .sheet(isPresented: $isImagePickerDisplayedCircle) {
                                    ImagePicker(selectedImage: $selectedCircleImage)
                                }
                        }
                        .cornerRadius(20)
                    }
                    
                    
                    Spacer().frame(height: 25) // Add space between buttons

                    Button(action: {
                        // Action for the first button
                    }) {
                        ZStack {
                            // Background of the button
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.gray.opacity(0.1))
                                .frame(maxWidth: .infinity)
                                .frame(height: 80) // Adjust height as needed
                            
                            // Image overlay
                            Image("Sun - Bright")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50) // Adjust size of the image as needed
                                .padding(.trailing, 150) // Adjust padding around the image as needed
                                .offset(x: 7, y: 1) // Adjust position of the image relative to the button as needed
                            
                            // Image overlay
                            Image("Water - Bright")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70) // Adjust size of the image as needed
                                .padding(.leading) // Adjust padding around the image as needed
                                .offset(x: 7, y: 1) // Adjust position of the image relative to the button as needed
                            
                            
                            // Image overlay
                            Image("Humidity - Bright")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60) // Adjust size of the image as needed
                                .padding(.leading, 180) // Adjust padding around the image as needed
                                .offset(x: 7, y: 1) // Adjust position of the image relative to the button as needed
                            
                            // Circular image input
                            Image(systemName: "camera.circle.fill") // You can replace this with your image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                                .frame(width: 60, height: 60)
                                .offset(x: -140, y: 0)
                                .onTapGesture {
                                    isImagePickerDisplayedCircle.toggle()
                                }
                                .sheet(isPresented: $isImagePickerDisplayedCircle) {
                                    ImagePicker(selectedImage: $selectedCircleImage)
                                }
                        }
                        .cornerRadius(20)
                    }
                    
                    
                    Spacer()
                }
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .edgesIgnoringSafeArea(.bottom)
            .sheet(isPresented: $isInfoWindowPresented) { // Start of Pop Up Window
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Image("Sun - Bright")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .padding(.bottom, 35)
                            
                            Image("Sun - Dim")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .padding(.bottom, 35)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("GOOD: Needs NO Attention")
                                .foregroundColor(.black)
                                .font(.system(size: 20, weight: .bold))
                                .padding(.top, 15)
                                .padding(.bottom, 55)
                            
                            Text("BAD: Needs Attention !!")
                                .foregroundColor(.black)
                                .font(.system(size: 20, weight: .bold))
                                .padding(.top, 10)
                                .padding(.bottom, 55)
                        }
                        .presentationDetents([.fraction(0.40)])
                    }
                }
            } // End of Pop Up Window
//            .sheet(isPresented: $isImagePickerDisplayed) {
//                ImagePicker(selectedImage: $selectedUIImage)
//            }
//            .onAppear {
//               loadImageFromFirebase()
//            }
        }// End of NavigationView
    }// End of Body View

    func loadImageFromFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        isLoading = true  // Start the loading indicator
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid).collection("home").document("image")
        docRef.getDocument { (document, error) in
            if let document = document, let imagePath = document.data()?["image_path"] as? String {
                let storageRef = Storage.storage().reference().child(imagePath)
                storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in  // Adjust size limit as needed
                    isLoading = false  // Stop the loading indicator
                    if let error = error {
                        print("Error downloading image: \(error)")
                    } else if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            selectedUIImage = image
                        }
                    }
                }
            } else {
                isLoading = false  // Stop the loading indicator if there's an error
                print("Document does not exist or path is incorrect")
            }
        }
    }
    func replaceExistingImage(selectedImage: UIImage) {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let docRef = db.collection("users").document(uid).collection("home").document("image")
        docRef.getDocument { document, error in
            if let document = document, document.exists, let existingImagePath = document.data()?["image_path"] as? String {
                // An image exists, delete it first
                deleteImage(path: existingImagePath) { success in
                    if success {
                        self.uploadNewImage(selectedImage: selectedImage)
                    } else {
                        print("Failed to delete existing image.")
                    }
                }
            } else {
                // No existing image, just upload the new one
                uploadNewImage(selectedImage: selectedImage)
            }
        }
    }
    
    /// Deletes an image from Firebase Storage
    func deleteImage(path: String, completion: @escaping (Bool) -> Void) {
        let storageRef = Storage.storage().reference().child(path)
        storageRef.delete { error in
            if let error = error {
                print("Error deleting image: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Image successfully deleted")
                completion(true)
            }
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
        db.collection("users").document(uid).collection("home").document("image").setData(["image_path": path])
    }
}
// End of HomeView





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
        
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

/// SwiftUI View for displaying a preview of the Home Screen
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


