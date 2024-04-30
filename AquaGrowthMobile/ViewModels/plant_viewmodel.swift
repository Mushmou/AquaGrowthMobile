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
    var plant_image: String = "Flower"
    var plant_ui_image: UIImage?
}

class plant_viewmodel: ObservableObject{
    @Published var plants = [Plant]()
        
    func savePlant(_ plant: Plant) {
        plants.append(plant)
    }
    
    func savePlantDatabase(_ plant: Plant) {
        guard let uid = Auth.auth().currentUser?.uid, let selectedImage = plant.plant_ui_image else {
            print("User not logged in or image not selected")
            return
        }

        let db = Firestore.firestore()
        let plantRef = db.collection("users").document(uid).collection("plants").document(plant.id.uuidString)
        plantRef.setData([
            "plant_id": plant.id.uuidString,
            "plant_name": plant.plant_name,
            "plant_type": plant.plant_type,
            "plant_description": plant.plant_description,
            "favorite": 0  // Assume default not favorite
        ]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                self.uploadNewImage(plantId: plant.id, selectedImage: selectedImage, dbRef: plantRef)
            }
        }
    }

    
    
    func deletePlant(_ plant: Plant) {
            let db = Firestore.firestore()
            
            guard let uid = Auth.auth().currentUser?.uid else {
                print("User not logged in")
                return
            }
            
            db.collection("users")
                .document(uid)
                .collection("plants")
                .document(plant.id.uuidString)
                .delete {
                    error in
                    if let error = error {
                        print("Error deleting:\(error.localizedDescription)")
                    }
                    else {
                        print("Deleted plant: \(plant.plant_name)")
                    }
                }
        }
    
    func updatePlant(_ plant: Plant) {
        let db = Firestore.firestore()
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let plantReference = db.collection("users")
            .document(uid)
            .collection("plants")
            .document(plant.id.uuidString)
       
            plantReference.updateData([
                "plant_name" : plant.plant_name,
                "plant_type" : plant.plant_type,
                "plant_description" : plant.plant_description,
                "plant_image" : plant.plant_image
            ]) { error in
                if let error = error {
                    print("Error Updating:\(error.localizedDescription)")
                }
            }
    }
    
    func fetchPlants() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(uid).collection("plants").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }

            self.plants = documents.compactMap { document in
                let data = document.data()
                let plantID = UUID(uuidString: document.documentID) ?? UUID()
                let plantName = data["plant_name"] as? String ?? ""
                let plantType = data["plant_type"] as? String ?? ""
                let plantDescription = data["plant_description"] as? String ?? ""
                let plantImage = data["plant_image"] as? String ?? ""

                let plant = Plant(id: plantID, plant_name: plantName, plant_type: plantType, plant_description: plantDescription, plant_image: plantImage)

                // Load the image from Firebase Storage
                if plantImage == "Flower"{
                    return plant
                }
                if let plantImagePath = data["plant_image"] as? String {
                    self.loadImageFromFirebase(plantId: plant.id, imagePath: plantImagePath)
                }

                return plant
            }
        }
    }

    
    private func loadImageFromFirebase(plantId: UUID, imagePath: String) {
        let storageRef = Storage.storage().reference().child(imagePath)
        storageRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] data, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.updatePlantImage(plantId: plantId, image: image)
                }
            }
        }
    }

    private func updatePlantImage(plantId: UUID, image: UIImage) {
        if let index = self.plants.firstIndex(where: { $0.id == plantId }) {
            self.plants[index].plant_ui_image = image
        }
    }
    
    private func saveImagePathToFirestore(plant:Plant,path: String) {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        db.collection("users").document(uid).collection("plants").document(plant.id.uuidString).setData(["image_path": path])
    }
    

    
    func uploadNewImage(plantId: UUID, selectedImage: UIImage, dbRef: DocumentReference) {
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            print("Could not get JPEG representation of UIImage")
            return
        }

        let path = "plant_images/\(plantId.uuidString).jpg"
        let storageRef = Storage.storage().reference().child(path)

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
            } else {
                dbRef.updateData(["plant_image": path]) { error in
                    if let error = error {
                        print("Error updating document with image path: \(error)")
                    }
                }
            }
        }
    }

    
    private func updateLocalPlant(_ updatedPlant: Plant) {
        if let index = plants.firstIndex(where: { $0.id == updatedPlant.id }) {
            plants[index] = updatedPlant
        }
    }

}
