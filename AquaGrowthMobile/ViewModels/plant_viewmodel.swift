//
//  plant_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct Plant: Identifiable {
    var id = UUID()
    var plant_name: String
    var plant_type: String
    var plant_description: String
    var plant_image: String
    var plant_ui_image: UIImage?
}

class plant_viewmodel: ObservableObject{
//    @Published var plants = [
//        Plant(plant_name: "Fern", plant_type: "something what", plant_description: "I love ferns", plant_image: "Tomato"),
//        Plant(plant_name: "Cactus", plant_type: "pincushion", plant_description: "Yea its a prickly cactus", plant_image: "Temperature"),
//        Plant(plant_name: "Orchid", plant_type: "colorful flower", plant_description: "Colorful and stuff", plant_image: "Water"),
//    ]
    
    @Published var plants = [Plant]()
        
    
    func savePlant(_ plant: Plant) {
        plants.append(plant)
    }
    
    func savePlantDatabase(_ plant: Plant){
        let db = Firestore.firestore()
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        uploadNewImage(plant: plant, selectedImage: plant.plant_ui_image!)
        
        
        db.collection("users")
            .document(uid)
            .collection("plants")
            .document(plant.id.uuidString)
            .setData([
                "plant_id" : plant.id.uuidString,
                "plant_name": plant.plant_name,
                "plant_type": plant.plant_type,
                "plant_description": plant.plant_description,
                "favorite": 0
            ])
    }
    
    func fetchPlants() {
        let db = Firestore.firestore()
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        db.collection("users")
            .document(uid)
            .collection("plants")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error)")
                } else {
                    var tempPlants = [Plant]()
                    let group = DispatchGroup()

                    querySnapshot?.documents.forEach { document in
                        group.enter()
                        let data = document.data()
                        let plantID = document.documentID
                        let plantName = data["plant_name"] as? String ?? ""
                        let plantType = data["plant_type"] as? String ?? ""
                        let plantDescription = data["plant_description"] as? String ?? ""
                        let plantImage = data["plant_image"] as? String ?? ""

                        self.loadImageFromFirebase(plantId: plantID) { image in
                            let plant = Plant(id: UUID(uuidString: plantID) ?? UUID(),
                                              plant_name: plantName,
                                              plant_type: plantType,
                                              plant_description: plantDescription,
                                              plant_image: plantImage,
                                              plant_ui_image: image)
                            tempPlants.append(plant)
                            group.leave()
                        }
                    }

                    group.notify(queue: .main) {
                        self.plants = tempPlants
                    }
                }
            }
    }

    func uploadNewImage(plant: Plant, selectedImage: UIImage){
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        let path = "plant_images/\(UUID().uuidString).jpg"
        let storageRef = Storage.storage().reference().child(path)
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard let _ = metadata, error == nil else {
                print("Error uploading image: \(error?.localizedDescription ?? "")")
                return
            }
            
            // Save a reference to Firestore
            self.saveImagePathToFirestore(plant: plant, path: path)
        }
    }
    
    /// Saves the image path to Firestore
    private func saveImagePathToFirestore(plant: Plant, path: String) {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        db.collection("users")
            .document(uid)
            .collection("plants")
            .document(plant.id.uuidString)
            .setData(["plant_image": path])
    }
    
    func loadImageFromFirebase(plantId: String, completion: @escaping (UIImage?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            completion(nil)
            return
        }

        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid).collection("plants").document(plantId)
        docRef.getDocument { (document, error) in
            if let document = document, let imagePath = document.data()?["plant_image"] as? String {
                let storageRef = Storage.storage().reference().child(imagePath)
                storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in  // Adjust size limit as needed
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    } else {
                        print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                        completion(nil)
                    }
                }
            } else {
                print("Document does not exist or path is incorrect")
                completion(nil)
            }
        }
    }
}
