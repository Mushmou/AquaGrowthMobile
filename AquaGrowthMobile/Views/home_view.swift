import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth


struct FavoriteView: View {
    @State private var isImagePickerDisplayedCircle = false
    @State private var selectedCircleImage: UIImage?
    let defaultImage = UIImage(named: "Flower") // Change "default_image" to your default image name

    var light_image : String
    var humidity_image : String
    var temperature_image : String

    var body: some View {
        // Three buttons centered vertically
        VStack {
            HStack{
                Spacer()
                Image(light_image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 5)
                Spacer()
                Image(humidity_image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 5)
                Spacer()
                Image(temperature_image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 10)
                    .padding(.trailing, 5)
                Spacer()
            }
            .cornerRadius(20)
        }
    }
}


struct HomeView: View {
    // State to hold the selected image
    @State private var isImagePickerDisplayed = false
    @State private var selectedUIImage: UIImage?
    @State private var isInfoWindowPresented = false
    @State private var isLoading = false
    @StateObject var viewModel = home_viewmodel()
    @EnvironmentObject var bluetooth: bluetooth_viewmodel
    @State private var selectedPlant: Plant? = nil // Track selected plant for navigation

    @State private var my_sun = ""
    @State private var my_temperature = ""
    @State private var my_humidity = ""

    let defaultImage = UIImage(named: "Flower") // Change "default_image" to your default image name

    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    Text("Home")
                        .foregroundColor(.black)
                        .font(.system(size: 30, weight: .bold))
                }
                Group {
                    if isLoading {
                        // Display a loading indicator while the image is being fetched
                        ProgressView("Loading")
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(1.5)
                            .padding()
                    } else if selectedUIImage != nil {
                        Image(uiImage: selectedUIImage!)
                            .resizable()
                            .scaledToFill()
                            .padding([.top,.bottom], 30)
                    } else {
                        if let defaultImage = defaultImage {
                            ZStack {
                                Image(uiImage: defaultImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, minHeight: 200)
                                    .background(Color.gray)
                                    .onTapGesture {
                                        isImagePickerDisplayed = true
                                    }
                                    .cornerRadius(20)
                                Text("Add your own image here")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.headline)
                                    .padding()
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 20, height: 200)
                .cornerRadius(20)
                .onTapGesture {
                    isImagePickerDisplayed = true
                }
                .navigationBarBackButtonHidden()

                HStack {
                    Text("Favorite Plants")
                        .padding(.top, 10)
                        .foregroundColor(.black)
                        .font(.system(size: 30, weight: .bold))
                        .padding(.leading, 1)

                    Spacer()

                    Button(action: {
                        isInfoWindowPresented.toggle()
                    }) {
                        Image(systemName: "info.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    }
                    .padding(.trailing, 18)
                }
                .padding(.bottom, 20)
                .sheet(isPresented: $isImagePickerDisplayed) {
                    ImagePicker(selectedImage: $selectedUIImage)
                }.onChange(of: isImagePickerDisplayed) { newValue in
                    if !newValue {
                        print("Image Picker was dismissed.")
                        replaceExistingImage(selectedImage: selectedUIImage!)
                    }
                }
                  .onAppear {
                      loadImageFromFirebase()
                  }

                // Three buttons centered vertically

                    List(viewModel.favoritePlants) { plant in
                        NavigationLink(destination: IndividualPlantView(my_plant: plant).environmentObject(bluetooth).toolbar(.hidden, for: .tabBar)) {
                            VStack(alignment: .leading){
                                Text(plant.plant_name)
                                    .bold()
                                FavoriteView(light_image: viewModel.getLightImage(plantId: plant.id.uuidString),
                                             humidity_image: viewModel.getHumidityImage(plantId: plant.id.uuidString),
                                             temperature_image: viewModel.getTemperatureImage(plantId: plant.id.uuidString))
                            }
                        }
                    }
                    .listStyle(PlainListStyle()) // Set list style to avoid default navigation behavior
                Spacer()
            }
            .padding()
            .background(Color.white)
            .edgesIgnoringSafeArea(.bottom)
            .sheet(isPresented: $isInfoWindowPresented) {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Image("sun_original")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .padding(.bottom, 35)

                            Image("sun_100")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .padding(.bottom, 35)
                        }

                        VStack(alignment: .leading) {
                            Text("GOOD: No Attention")
                                .foregroundColor(.black)
                                .font(.system(size: 20, weight: .bold))
                                .padding(.top, 15)
                                .padding(.bottom, 55)

                            Text("BAD: Attention")
                                .foregroundColor(.black)
                                .font(.system(size: 20, weight: .bold))
                                .padding(.top, 10)
                                .padding(.bottom, 55)
                        }
                        .presentationDetents([.fraction(0.28)])
                    }
                }
            }
            .onAppear {
                viewModel.fetchFavoritePlants() // Fetch favorite plants when the view appears
                print("light")
                viewModel.fetchMostRecentDocumentForAllPlants(sensor: "light")
                print("humidity")
                viewModel.fetchMostRecentDocumentForAllPlants(sensor: "humidity")
                print("temperature")
                viewModel.fetchMostRecentDocumentForAllPlants(sensor: "temperature")
            }
        }
    }





    func loadImageFromFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        isLoading = true
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid).collection("home").document("image")
        docRef.getDocument { (document, error) in
            if let document = document, let imagePath = document.data()?["image_path"] as? String {
                let storageRef = Storage.storage().reference().child(imagePath)
                storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    isLoading = false
                    if let error = error {
                        print("Error downloading image: \(error)")
                    } else if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            selectedUIImage = image
                        }
                    }
                }
            } else {
                isLoading = false
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
                deleteImage(path: existingImagePath) { success in
                    if success {
                        self.uploadNewImage(selectedImage: selectedImage)
                    } else {
                        print("Failed to delete existing image.")
                    }
                }
            } else {
                uploadNewImage(selectedImage: selectedImage)
            }
        }
    }

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
            self.saveImagePathToFirestore(path: path)
        }
    }

    private func saveImagePathToFirestore(path: String) {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        db.collection("users").document(uid).collection("home").document("image").setData(["image_path": path])
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

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.selectedImage = nil // Set selectedImage to nil to remove the image
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(bluetooth_viewmodel())
    }
}
