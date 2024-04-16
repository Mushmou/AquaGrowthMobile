import Foundation
import SwiftUI
/// SwiftUI View for the Home Screen


struct HomeView: View {
    // State to hold the selected image
    @State private var isImagePickerDisplayed = false
    @State private var isImagePickerDisplayedCircle = false
    @State private var selectedUIImage: UIImage?
    @State private var isInfoWindowPresented = false
    @State private var selectedCircleImage: UIImage? // Declared at the top level of the struct
    @State private var isNavigationActive = false // State for navigation
    
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
                }
                .onAppear {
                    //loadSavedImage() // Load saved image if needed
                }
                
                // Three buttons centered vertically
                VStack {
                    // Navigation link to trigger navigation to HomeInfoView
                    if isNavigationActive {
                        NavigationLink(destination: HomeInfoView(), isActive: $isNavigationActive) {
                            EmptyView()
                        }
                        .hidden()
                    }
                    // Button to trigger navigation
                    Button(action: {
                        isNavigationActive = true // Set navigation state
                    }) {
                        ZStack { // BUTTON #1
                            // Background of the button
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.gray.opacity(0.1))
                                .frame(maxWidth: .infinity)
                                .frame(height: 80) // Adjust height as needed
                            
                            // Image overlays (replace with your images)
                            Image("Sun - Dim")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .padding(.trailing, 150)
                                .offset(x: 7, y: 1)
                            Image("Water - Dim")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .padding(.leading)
                                .offset(x: 7, y: 1)
                            Image("Humidity - Dim")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .padding(.leading, 180)
                                .offset(x: 7, y: 1)
                            Image("Arrow Indicator")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .padding(.leading, 295)
                                .offset(x: 7, y: 1)
                            Image(systemName: "camera.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                                .frame(width: 60, height: 60)
                                .offset(x: -140, y: 0)
                        }
                    }
                    .cornerRadius(20)
                    .background(Color.white.edgesIgnoringSafeArea(.all)) // Add this line to avoid dark background issue
                    .navigationViewStyle(StackNavigationViewStyle()) // Add this line to avoid iPad split view issue
                }
              
            
        

    

                    
                    
                    
                    Spacer().frame(height: 25) // Add space between buttons

                    Button(action: {
                        // Action for the first button
                    }) {
                        ZStack { // BUTTON #2
                            // Background of the button
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.gray.opacity(0.1))
                                .frame(maxWidth: .infinity)
                                .frame(height: 80) // Adjust height as needed
                            
                            // Image overlay
                            Image("Sun - Dim")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50) // Adjust size of the image as needed
                                .padding(.trailing, 150) // Adjust padding around the image as needed
                                .offset(x: 7, y: 1) // Adjust position of the image relative to the button as needed
                            
                            // Image overlay
                            Image("Water - Dim")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60) // Adjust size of the image as needed
                                .padding(.leading) // Adjust padding around the image as needed
                                .offset(x: 7, y: 1) // Adjust position of the image relative to the button as needed
                            
                            
                            // Image overlay
                            Image("Humidity - Dim")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60) // Adjust size of the image as needed
                                .padding(.leading, 180) // Adjust padding around the image as needed
                                .offset(x: 7, y: 1) // Adjust position of the image relative to the button as needed
                            
                            
                            Image("Arrow Indicator") // Shows that plant needs to be added TODO: add loop to check if plant is there or not
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40) // Adjust size of the image as needed
                                .padding(.leading, 295) // Adjust padding around the image as needed
                                .offset(x: 7, y: 1) // Adjust position of the image relative to the button as needed
                            
                            // Circular image input
                            Image(systemName: "camera.circle.fill") // You can replace this with your image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                                .frame(width: 60, height: 60)
                                .offset(x: -140, y: 0)
//                                .onTapGesture {
//                                    isImagePickerDisplayedCircle.toggle()
//                                }
//                                .sheet(isPresented: $isImagePickerDisplayedCircle) {
//                                    ImagePicker(selectedImage: $selectedCircleImage)
//                                }
                        }
                        .cornerRadius(20)
                    }
                    
                    
                    
                    
                    Spacer().frame(height: 25) // Add space between buttons

                    Button(action: {
                        // Action for the first button
                    }) {
                        ZStack { // BUTTON #3
                            // Background of the button
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.gray.opacity(0.1))
                                .frame(maxWidth: .infinity)
                                .frame(height: 80) // Adjust height as needed
                            
                            // Image overlay
                            Image("Sun - Dim")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50) // Adjust size of the image as needed
                                .padding(.trailing, 150) // Adjust padding around the image as needed
                                .offset(x: 7, y: 1) // Adjust position of the image relative to the button as needed
                            
                            // Image overlay
                            Image("Water - Dim")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70) // Adjust size of the image as needed
                                .padding(.leading) // Adjust padding around the image as needed
                                .offset(x: 7, y: 1) // Adjust position of the image relative to the button as needed
                            
                            
                            // Image overlay
                            Image("Humidity - Dim")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60) // Adjust size of the image as needed
                                .padding(.leading, 180) // Adjust padding around the image as needed
                                .offset(x: 7, y: 1) // Adjust position of the image relative to the button as needed
                            
                            Image("Arrow Indicator") // Shows that plant needs to be added TODO: add loop to check if plant is there or not
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40) // Adjust size of the image as needed
                                .padding(.leading, 295) // Adjust padding around the image as needed
                                .offset(x: 7, y: 1) // Adjust position of the image relative to the button as needed
                            
                            // Circular image input
                            Image(systemName: "camera.circle.fill") // You can replace this with your image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                                .frame(width: 60, height: 60)
                                .offset(x: -140, y: 0)
//                                .onTapGesture {
//                                    isImagePickerDisplayedCircle.toggle()
//                                }
//                                .sheet(isPresented: $isImagePickerDisplayedCircle) {
//                                    ImagePicker(selectedImage: $selectedCircleImage)
//                                }
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
//                loadSavedImage()
//            }
        }// End of NavigationView
    /// Load the previously saved image from UserDefaults.
    private func loadSavedImage() {
        if let imagePath = UserDefaults.standard.string(forKey: "savedImagePath"),
           let loadedImage = loadImageFromDocumentDirectory(name: imagePath) {
            self.selectedUIImage = loadedImage
        }
    }
    }// End of Body View
    
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
/// SwiftUI View for displaying a preview of the Home Screen
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


