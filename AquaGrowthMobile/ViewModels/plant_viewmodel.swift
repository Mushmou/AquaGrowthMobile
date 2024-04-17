//
//  plant_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Plant: Identifiable {
    var id = UUID()
    var plant_name: String
    var plant_type: String
    var plant_description: String
    var plant_image: String // This should be a string referring to the image name
    
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
        //        Generate plant id
        db.collection("users")
            .document(uid)
            .collection("plants")
            .document(plant.id.uuidString)
            .setData([
                "plant_id" : plant.id.uuidString,
                "plant_name": plant.plant_name,
                "plant_type": plant.plant_type,
                "plant_description": plant.plant_description,
                "plant_image": plant.plant_image,
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
                    self.plants = querySnapshot?.documents.compactMap { document in
                        let data = document.data()
                        let plantID = document.documentID
                        let plantName = data["plant_name"] as? String ?? ""
                        let plantType = data["plant_type"] as? String ?? ""
                        let plantDescription = data["plant_description"] as? String ?? ""
                        let plantImage = data["plant_image"] as? String ?? ""
                        
                        return Plant(id: UUID(uuidString: plantID) ?? UUID(),
                                     plant_name: plantName,
                                     plant_type: plantType,
                                     plant_description: plantDescription,
                                     plant_image: plantImage)
                    } ?? []
                }
            }
    }
}
